#!/usr/bin/env python3
"""Independent standard-library verifier. It does not import the LP code.

Verify exact field feasibility, rational repaired bounds, all stored margin
intervals, and support functions against direct small permutation enumeration.
"""
from pathlib import Path
from fractions import Fraction as F
from itertools import permutations, product
from math import isqrt
import json, time, sys, platform, hashlib

ROOT=Path(__file__).resolve().parents[1]


def add(x,y):return (x[0]+y[0],x[1]+y[1])
def neg(x):return (-x[0],-x[1])
def sub(x,y):return add(x,neg(y))
def mul(x,y):return (x[0]*y[0]+2*x[1]*y[1],x[0]*y[1]+x[1]*y[0])
def scale(x,a):return (x[0]*a,x[1]*a)
ZERO=(F(0),F(0))
ONE=(F(1),F(0))


def nonnegative(x):
    a,b=x
    if b>=0:return a>=0 or 2*b*b>=a*a
    return a>=0 and a*a>=2*b*b


def enclosure(x,digits=70):
    den=10**digits;s=isqrt(2*den*den)
    a,b=x
    lo,hi=F(s,den),F(s+1,den)
    return (a+b*lo,a+b*hi) if b>=0 else (a+b*hi,a+b*lo)


def probabilities(d):
    c=[ONE,(F(-1,2),F(-1,4))]
    for n in range(2,d):c.append(sub(scale(mul(c[1],c[-1]),F(2)),c[-2]))
    return [mul((F(6,17),F(-1,17)),sub(ONE,x)) for x in c[:d]]


def null_bound(v,m,depths,reset=False):
    maximum=F(0)
    for q in range(1,m+1):
        residues=[F(0) for _ in range(q)]
        for n,x in zip(depths,v):residues[n%q]+=x
        maximum=max(maximum,sum((x for x in residues[int(reset):] if x>0),F(0)))
    return maximum


def verify_record(c,p):
    m=c['budget'];depths=c['depths'];d=len(depths)
    v=list(map(F,c['v']));eta=list(map(F,c['eta']));z=list(map(F,c['z']))
    assert len(eta)==m and len(z)==m*(m+1)//2 and len(v)==d
    assert sum(eta)==1 and min(eta)>=0 and min(z)>=0
    for q in range(1,m+1):
        for r in range(q):assert z[q*(q-1)//2+r]<=eta[q-1]
        if c['reset']:assert z[q*(q-1)//2]==0
    h=null_bound(v,m,depths,c['reset']);assert h==F(c['null_bound'])
    nu=list(map(F,c['uncertainty']))
    margin=ZERO
    for n,x in zip(depths,v):margin=add(margin,scale(p[n],x))
    margin=sub(margin,(h+sum((a*abs(b) for a,b in zip(nu,v)),F(0)),F(0)))
    assert margin==(F(c['margin_exact']['a']),F(c['margin_exact']['b']))
    den=10**60
    weight_lo=[F(isqrt(x*den*den),den) for x in c['costs']]
    weight_hi=[F(isqrt(x*den*den)+1,den) for x in c['costs']]
    wh=sum((abs(x)*w for x,w in zip(v,weight_hi)),F(0))
    wl=sum((abs(x)*w for x,w in zip(v,weight_lo)),F(0))
    assert wh==F(c['normalization_upper']) and wl==F(c['normalization_lower'])
    lower=max(F(0),enclosure(margin)[0]/wh) if wh else F(0)
    assert lower==F(c['certified_lower'])
    upper=F(0)
    for i,n in enumerate(depths):
        curve=sum((z[q*(q-1)//2+n%q] for q in range(1,m+1)),F(0))
        lo,hi=enclosure(sub(p[n],(curve,F(0))))
        upper=max(upper,max(F(0),-lo-nu[i],hi-nu[i])/weight_lo[i])
    assert upper==F(c['certified_upper']) and lower<=upper
    assert upper-lower<F(1,50000000)
    return len(v)+len(z)+len(eta)


def check_central(p):
    c=json.loads((ROOT/'data/exact_central.json').read_text())
    values=[tuple(map(F,x)) for x in c['exact_variables']]
    m=c['budget'];eta,z,t=values[:m],values[m:-1],values[-1]
    assert len(values)==45 and sum((x[0] for x in eta),F(0))==1
    assert sum((x[1] for x in eta),F(0))==0
    assert all(nonnegative(x) for x in values)
    for q in range(1,m+1):
        for r in range(q):assert nonnegative(sub(eta[q-1],z[q*(q-1)//2+r]))
    for n in range(c['length']):
        curve=ZERO
        for q in range(1,m+1):curve=add(curve,z[q*(q-1)//2+n%q])
        error=sub(curve,p[n]);assert nonnegative(sub(t,error)) and nonnegative(add(t,error))
    v=list(map(F,c['v']));assert sum(map(abs,v))==1
    for q in range(1,m+1):
        for r in range(q):assert sum(v[r::q],F(0))==0
    score=ZERO
    for n,x in enumerate(v):score=add(score,scale(p[n],x))
    assert score==t==tuple(map(F,c['distance']))
    return {'exact_distance':c['distance'],'float':c['distance_float'],
            'basis_variables':45,'primal_probability_inequalities':128,
            'vanishing_residue_sums':36}


def small_enumeration():
    # Directly evolve every permutation and binary readout, without using
    # periodic-hull generators. A linear score maximizes at a binary readout.
    support_comparisons=0;controllers=0
    depths=[0,1,3,6,8]
    for m in range(1,5):
        for reset in [False,True]:
            for trial in range(4):
                v=[F(((i+1)*(trial+2))%9-4,7) for i in range(len(depths))]
                best=None
                for perm in permutations(range(m)):
                    for readout in product([0,1],repeat=m):
                        for initial in range(m):
                            if reset and readout[initial]:continue
                            state=initial;curve=[]
                            for n in range(max(depths)+1):
                                curve.append(readout[state]);state=perm[state]
                            value=sum((x*curve[n] for x,n in zip(v,depths)),F(0))
                            best=value if best is None else max(best,value)
                            controllers+=1
                assert best==null_bound(v,m,depths,reset)
                support_comparisons+=1
    return {'support_comparisons':support_comparisons,'direct_controller_cases':controllers}


def run():
    started=time.perf_counter();p=probabilities(1024)
    records=0;entries=0
    for filename in ['window_grid.json','reset_calibration.json','cost_noise.json']:
        for row in json.loads((ROOT/'data'/filename).read_text()):
            entries+=verify_record(row,p);records+=1
    summary={'status':'PASS','certificate_records':records,'exact_entries_checked':entries,
             'central_theorem':check_central(p),'small_enumeration':small_enumeration(),
             'python':sys.version,'platform':platform.platform(),
             'elapsed_seconds':time.perf_counter()-started,
             'method':'independent standard-library rational verifier; no LP solver'}
    # Hash all research sources and numerical inputs, leaving this output excluded.
    summary['source_sha256']={str(path.relative_to(ROOT)):hashlib.sha256(path.read_bytes()).hexdigest()
        for folder in ['src','scripts','data','wolfram'] for path in sorted((ROOT/folder).rglob('*'))
        if path.is_file() and '__pycache__' not in str(path)
        and path.name not in ['verification_summary.json','wolfram_checks.txt']}
    (ROOT/'data/verification_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps({k:v for k,v in summary.items() if k!='source_sha256'},indent=2))

if __name__=='__main__':run()
