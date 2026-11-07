"""Recover the 45-variable optimal LP basis exactly over Q(sqrt(2))."""
from pathlib import Path
import sys, json
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'src'))
from reversible_tests import Quadratic as K, F, ht_exact, solve_window
import sympy as sp

ROOT=Path(__file__).resolve().parents[1]


def recover():
    m,d=8,64
    p=ht_exact(d);s=solve_window([float(x) for x in p],m)
    k=m*(m+1)//2;nv=m+k+1
    values=list(s['eta'])+list(s['z'])+[s['distance']]
    rows=[];rhs=[]
    row=[0]*nv;row[:m]=[1]*m
    rows.append(row);rhs.append(K(F(1)))
    for j,x in enumerate(values):
        if abs(x)<1e-8:
            row=[0]*nv;row[j]=1;rows.append(row);rhs.append(K())
    for q in range(1,m+1):
        for r in range(q):
            j=m+q*(q-1)//2+r
            if abs(values[j]-values[q-1])<1e-8:
                row=[0]*nv;row[j]=1;row[q-1]=-1
                rows.append(row);rhs.append(K())
    for n in range(d):
        error=s['curve'][n]-float(p[n])
        if abs(abs(error)-s['distance'])<1e-8:
            row=[0]*nv
            for q in range(1,m+1):row[m+q*(q-1)//2+n%q]=1
            row[-1]=-1 if error>0 else 1
            rows.append(row);rhs.append(p[n])
    matrix=sp.Matrix(rows)
    right=sp.Matrix([[sp.Rational(x.a.numerator,x.a.denominator),
                      sp.Rational(x.b.numerator,x.b.denominator)] for x in rhs])
    solution,params=matrix.gauss_jordan_solve(right)
    if params.rows:raise RuntimeError('Optimal face did not produce a unique basis')
    exact=[K(F(str(solution[j,0])),F(str(solution[j,1]))) for j in range(nv)]
    def nonnegative(x):
        assert x.a==x.b==0 or x.interval()[0]>0
    eta,z,t=exact[:m],exact[m:-1],exact[-1]
    assert sum(eta,K())==K(F(1))
    for x in exact:nonnegative(x)
    for q in range(1,m+1):
        for r in range(q):nonnegative(eta[q-1]-z[q*(q-1)//2+r])
    for n in range(d):
        curve=sum((z[q*(q-1)//2+n%q] for q in range(1,m+1)),K())
        nonnegative(t-(curve-p[n]));nonnegative(t+(curve-p[n]))
    # A sparse equality, independently checked for each residue and period.
    v=[F(0)]*d
    for n in [6,28,47,57]:v[n]=F(1,8)
    for n in [12,22,41,63]:v[n]=F(-1,8)
    for q in range(1,m+1):
        assert all(sum((v[n] for n in range(r,d,q)),F(0))==0 for r in range(q))
    assert sum((v[n]*p[n] for n in range(d)),K())==t
    output={'budget':m,'length':d,'exact_variables':[[str(x.a),str(x.b)] for x in exact],
            'v':[str(x) for x in v], 'distance':[str(t.a),str(t.b)],
            'distance_float':float(t),'active_rows':len(rows),'rank':nv,
            'engine':'Python / SymPy exact linear algebra; verified using rational enclosures'}
    (ROOT/'data').mkdir(exist_ok=True)
    (ROOT/'data/exact_central.json').write_text(json.dumps(output,indent=2)+'\n')
    print(json.dumps({key:output[key] for key in ['distance','distance_float','active_rows','rank']}))

if __name__=='__main__':recover()
