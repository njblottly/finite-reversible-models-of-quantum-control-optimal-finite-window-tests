#!/usr/bin/env python3
"""Reproduce LP discovery, rational certificates, and synthetic experiments."""
from pathlib import Path
import sys, json, platform, time, csv
from fractions import Fraction as F
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'src'))
from reversible_tests import (ht_exact, solve_window, solve_dual,
                              rational_certificate, support)
import numpy as np
import scipy
from scipy.stats import binom

ROOT=Path(__file__).resolve().parents[1]
DATA=ROOT/'data'


def pack(solution, certificate, **extra):
    return {**certificate, **extra,
            'optimizer_distance':solution['distance'],
            'primal_curve':solution['curve'].tolist()}


def run():
    DATA.mkdir(exist_ok=True)
    started=time.perf_counter()
    allp=ht_exact(1024);pf=np.array([float(x) for x in allp])
    grid=[]
    lengths=[16,24,32,48,64,96,128,192,256,384,512,768,1024]
    for m in [2,4,8,16,32,64]:
        for d in lengths:
            s=solve_window(pf[:d],m)
            c=rational_certificate(s,allp[:d])
            assert c['gap_float']<2e-8
            omega=np.arccos(-(2+np.sqrt(2))/4)
            v=-np.cos(omega*np.arange(d));v/=np.abs(v).sum()
            # Actual support, rather than an asymptotic small-denominator bound.
            fourier=max(0,float(v@pf[:d]-support(v,m)))
            grid.append(pack(s,c,fourier_margin=fourier,length=d))
        print(f'Completed label budget {m}',flush=True)
        (DATA/'window_grid.json').write_text(json.dumps(grid,indent=2)+'\n')
    calibration=[]
    for m in [4,8,16,32]:
        for d in [32,64,128,256,512]:
            s=solve_window(pf[:d],m,reset=True)
            c=rational_certificate(s,allp[:d])
            assert c['gap_float']<2e-8
            calibration.append(pack(s,c,length=d))
    (DATA/'reset_calibration.json').write_text(json.dumps(calibration,indent=2)+'\n')
    cost_noise=[]
    kappas=[F(0),F(1,10000),F(1,5000),F(1,2000),F(1,1000),
            F(1,500),F(1,250),F(3,500)]
    for kappa in kappas:
        for d in [32,48,64,96,128,192,256]:
            costs=1+2*np.arange(d)
            nu=[F(1,200)+kappa*n for n in range(d)]
            s=solve_window(pf[:d],8,weights=np.sqrt(costs),
                           uncertainty=[float(x) for x in nu])
            c=rational_certificate(s,allp[:d],costs,nu)
            assert c['gap_float']<2e-8
            v=np.array([float(F(x)) for x in c['v']])
            active=np.flatnonzero(v)
            allocation=np.abs(v)/np.sqrt(costs)
            if allocation.sum():allocation/=allocation.sum()
            cost_noise.append(pack(s,c,length=d,kappa=str(kappa),
                                   max_used_depth=int(active.max()) if len(active) else None,
                                   shot_fraction=allocation.tolist()))
    (DATA/'cost_noise.json').write_text(json.dumps(cost_noise,indent=2)+'\n')
    # Independent primal and explicit-dual discovery checks, not exact certificates.
    dual_checks=[]
    for m,d,reset,cost,kappa in [(8,64,False,False,F(0)),
                                (8,64,True,False,F(0)),
                                (16,128,False,False,F(0)),
                                (32,256,False,False,F(0)),
                                (8,128,False,True,F(1,1000))]:
        weights=np.sqrt(1+2*np.arange(d)) if cost else np.ones(d)
        nu=[F(1,200)+n*kappa for n in range(d)] if cost else [F(0)]*d
        s=solve_window(pf[:d],m,weights,[float(x) for x in nu],reset=reset)
        val,v=solve_dual(pf[:d],m,weights,[float(x) for x in nu],reset=reset)
        assert abs(val-s['distance'])<1e-8
        dual_checks.append({'budget':m,'length':d,'reset':reset,'cost':cost,
                            'absolute_gap':abs(val-s['distance'])})
    # Check the target using direct unitary matrix powers, a separate computation.
    h=np.array([[1,1],[1,-1]],complex)/np.sqrt(2)
    t=np.diag([1,np.exp(1j*np.pi/4)])
    state=np.array([1,0],complex);direct=[]
    for n in range(1024):
        direct.append(float(abs(state[1])**2));state=h@t@state
    target_error=float(np.max(np.abs(pf-direct)))
    assert target_error<2e-12
    # Simulation uses the exactly certified sparse eight-depth equality.
    chosen=np.array([6,12,22,28,41,47,57,63])
    signs=np.array([1,-1,-1,1,-1,1,1,-1])
    v=signs/8
    ideal=pf[chosen]
    laws={'quantum':ideal,'constant_half':np.ones(8)/2,
          'period_7':np.array([F((n%7)+1,9) for n in chosen],float)}
    rng=np.random.default_rng(20261102)
    simulation=[];repetitions=20000;alpha=.05
    margin=float(v@ideal)
    for total in [16,32,64,96,128,256,512]:
        per=total//8
        variance_proxy=float(np.sum(v*v/per))
        threshold=float(np.sqrt(variance_proxy*np.log(1/alpha)/2))
        for name,probs in laws.items():
            scores=(rng.binomial(per,probs,(repetitions,8))/per)@v
            rejection=float(np.mean(scores>threshold))
            pmf=np.array([1.])
            for probability,sgn in zip(probs,signs):
                pp=probability if sgn>0 else 1-probability
                pmf=np.convolve(pmf,binom.pmf(np.arange(per+1),per,pp))
            distribution_rejection=float(pmf[(np.arange(total+1)/total-.5)>threshold].sum())
            lower=(max(0,1-np.exp(-2*(margin-threshold)**2/variance_proxy))
                   if margin>threshold else 0.)
            simulation.append({'total_shots':total,'shots_per_depth':per,
                               'law':name,'rejection_rate':rejection,
                               'numerically_evaluated_rejection':distribution_rejection,
                               'alpha':alpha,'threshold':threshold,
                               'quantum_power_lower_bound':float(lower),
                               'replicates':repetitions})
    (DATA/'sampling.json').write_text(json.dumps({'seed':20261102,
             'depths':chosen.tolist(),'signs':signs.tolist(),'results':simulation},indent=2)+'\n')
    summary={'python':sys.version,'platform':platform.platform(),
             'numpy':np.__version__,'scipy':scipy.__version__,
             'grid_cases':len(grid),'calibration_cases':len(calibration),
             'cost_noise_cases':len(cost_noise),'dual_checks':dual_checks,
             'maximum_grid_certificate_gap':max(x['gap_float'] for x in grid+calibration+cost_noise),
             'target_matrix_max_error':target_error,
             'elapsed_seconds':time.perf_counter()-started,
             'data_kind':'synthetic quantum probabilities and synthetic Bernoulli trials',
             'native_mathematica_executed':False}
    (DATA/'study_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    with (DATA/'summary.csv').open('w',newline='') as stream:
        writer=csv.writer(stream);writer.writerow(['M','D','lower','upper','support','Fourier_margin'])
        for row in grid:writer.writerow([row[k] for k in ['budget','length','lower_float','upper_float','support_size','fourier_margin']])
    print(json.dumps(summary,indent=2))

if __name__=='__main__':run()
