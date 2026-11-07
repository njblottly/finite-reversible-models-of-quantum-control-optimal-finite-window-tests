#!/usr/bin/env python3
"""Generate every manuscript figure as vector PDF and 180 dpi PNG."""
from pathlib import Path
from fractions import Fraction as F
import json, sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'src'))
from reversible_tests import ht_exact
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter

ROOT=Path(__file__).resolve().parents[1];DATA=ROOT/'data';FIG=ROOT/'figures'
FIG.mkdir(exist_ok=True)
plt.rcParams.update({'font.family':'DejaVu Serif','font.size':9.5,
    'mathtext.fontset':'dejavuserif','axes.spines.top':False,
    'axes.spines.right':False,'axes.grid':True,'grid.alpha':.18,
    'axes.axisbelow':True,'savefig.bbox':'tight','pdf.fonttype':42,
    'legend.frameon':False,'legend.fontsize':8.5})
COLORS=['#183C5A','#198B85','#C05B35','#7865A6','#9A7B29','#6C7B86']


def read(name):return json.loads((DATA/name).read_text())
def save(fig,name):
    from PIL import Image
    for extension in ['pdf','png']:
        temporary=FIG/(name+'.tmp.'+extension)
        fig.savefig(temporary,dpi=180)
        if extension=='png':
            with Image.open(temporary) as picture:picture.load()
        temporary.replace(FIG/(name+'.'+extension))
    plt.close(fig)


def run():
    grid=read('window_grid.json');cal=read('reset_calibration.json')
    cost=read('cost_noise.json');p=np.array(list(map(float,ht_exact(1024))))
    a=(6-np.sqrt(2))/17
    fig,axes=plt.subplots(1,2,figsize=(10,3.15),layout='constrained')
    for color,m in zip(COLORS,[2,4,8,16,32,64]):
        rows=[x for x in grid if x['budget']==m]
        axes[0].plot([x['length'] for x in rows],[x['lower_float'] for x in rows],
                     '-o',ms=3,color=color,label=f'$M={m}$')
    axes[0].axhline(a,color='0.6',ls=':',lw=1)
    axes[0].set(xscale='log',xlabel='Window length $D$',ylabel='Certified distance $R_M(D)$',
                ylim=(-.008,.286),title='(a) All reversible controllers up to $M$ labels')
    axes[0].legend(ncol=3,loc='lower center',bbox_to_anchor=(.5,1.0),fontsize=8)
    axes[0].set_title('(a) All reversible controllers up to $M$ labels',pad=38)
    rows=[x for x in grid if x['budget']==8]
    for key,label,col,ls in [('lower_float','Optimized contrast',COLORS[0],'-'),
                             ('fourier_margin','Cosine contrast',COLORS[2],'--')]:
        axes[1].plot([x['length'] for x in rows],[x[key] for x in rows],
                     ls+'o',ms=3,color=col,label=label)
    axes[1].set(xscale='log',xlabel='Window length $D$',ylabel='Certified score gap',
                ylim=(-.008,.286),title='(b) The same $M=8$ null for both methods')
    axes[1].legend(loc='lower right')
    save(fig,'window_separation')

    central=next(x for x in grid if x['budget']==8 and x['length']==64)
    v=np.array(list(map(lambda x:float(F(x)),central['v'])));chosen=np.flatnonzero(v)
    fig,axes=plt.subplots(2,1,figsize=(9.6,4.3),sharex=True,layout='constrained',
                          gridspec_kw={'height_ratios':[2,1]})
    n=np.arange(64)
    axes[0].plot(n,p[:64],'.-',lw=.8,ms=3,color=COLORS[0],label='Quantum probability')
    axes[0].plot(n,central['primal_curve'],'--',lw=1,color=COLORS[1],label='Closest mixture')
    axes[0].scatter(chosen,p[chosen],s=26,facecolors='white',edgecolors=COLORS[2],
                    zorder=4,label='Eight selected depths')
    axes[0].set(ylabel='Terminal probability',ylim=(-.025,.565))
    axes[0].legend(ncol=3,loc='upper center',bbox_to_anchor=(.5,1.25))
    axes[1].axhline(0,color='0.5',lw=.8)
    axes[1].vlines(chosen,0,v[chosen],color=[COLORS[0] if x>0 else COLORS[2] for x in v[chosen]],lw=2)
    axes[1].scatter(chosen,v[chosen],s=19,c=[COLORS[0] if x>0 else COLORS[2] for x in v[chosen]])
    for j in chosen:
        axes[1].annotate(str(j),(j,v[j]),xytext=(0,5 if v[j]>0 else -12),
                          textcoords='offset points',ha='center',fontsize=8)
    axes[1].set(xlabel='Repeated blocks $n$',ylabel='Contrast $v_n$',ylim=(-.18,.18),xlim=(-1,64))
    axes[1].set_yticks([-.125,0,.125],['$-1/8$','0','$1/8$'])
    save(fig,'eight_depth_witness')

    fig,axes=plt.subplots(1,2,figsize=(9.6,3.0),layout='constrained')
    for ax,m in zip(axes,[8,16]):
        rows=[x for x in grid if x['budget']==m and x['length'] in [32,64,128,256,512]]
        anchored=[x for x in cal if x['budget']==m]
        ax.plot([x['length'] for x in rows],[x['lower_float'] for x in rows],'-o',ms=4,
                color=COLORS[0],label='Uncalibrated readout')
        ax.plot([x['length'] for x in anchored],[x['lower_float'] for x in anchored],'-s',ms=4,
                color=COLORS[1],label='Trusted reset $f_0=0$')
        ax.axhline(a,color=COLORS[0],ls=':',lw=.8);ax.axhline(2*a,color=COLORS[1],ls=':',lw=.8)
        ax.set(xscale='log',xlabel='Window length $D$',ylabel='Certified distance',
               ylim=(-.015,.57),title=f'$M={m}$ labels')
        ax.legend(loc='upper left',bbox_to_anchor=(0,.88),fontsize=8)
    save(fig,'reset_calibration')

    fig,axes=plt.subplots(1,2,figsize=(10,3.15),layout='constrained')
    for col,kappa in zip(COLORS,['0','1/1000','1/250','3/500']):
        rows=[x for x in cost if x['kappa']==kappa]
        axes[0].plot([x['length'] for x in rows],[x['lower_float'] for x in rows],'-o',ms=3,
                     color=col,label=rf'$\kappa={float(F(kappa)):g}$')
    axes[0].set(xlabel='Available window length $D$',ylabel='Gap per square root of cost',
                title='(a) Robust test design, $M=8$')
    axes[0].legend(ncol=2,loc='lower right',fontsize=8)
    c=next(x for x in cost if x['kappa']=='1/1000' and x['length']==64)
    ns=np.flatnonzero(np.array(c['shot_fraction']))
    vv=np.abs([float(F(c['v'][i])) for i in ns]);vv/=vv.sum()
    positions=np.arange(len(ns))
    axes[1].bar(positions-.19,np.array(c['shot_fraction'])[ns],width=.38,
                color=COLORS[0],label='Cost-optimal shots')
    axes[1].bar(positions+.19,vv,width=.38,color=COLORS[1],alpha=.7,label='Shots ignoring depth cost')
    axes[1].set(xlabel='Repeated blocks $n$',ylabel='Fraction of shots',
                title=r'(b) Allocation at $\kappa=10^{-3}$',ylim=(0,.51))
    axes[1].set_xticks(positions,[str(x) for x in ns])
    axes[1].legend(loc='center right',bbox_to_anchor=(1,.65),fontsize=8)
    save(fig,'cost_aware_design')

    sample=read('sampling.json')['results']
    fig,axes=plt.subplots(1,2,figsize=(9.6,3.0),layout='constrained')
    rows=[x for x in sample if x['law']=='quantum']
    xs=[x['total_shots'] for x in rows];ys=np.array([x['rejection_rate'] for x in rows])
    axes[0].plot(xs,[x['numerically_evaluated_rejection'] for x in rows],'-',
                  color=COLORS[0],label='Bernoulli distribution')
    axes[0].errorbar(xs,ys,yerr=1.96*np.sqrt(ys*(1-ys)/20000),fmt='o',ms=4,
                     color=COLORS[0],capsize=2,label='20,000 synthetic data sets')
    axes[0].plot(xs,[x['quantum_power_lower_bound'] for x in rows],'--',
                 color=COLORS[1],label='Proved power lower bound')
    axes[0].set(xscale='log',xlabel='Total shots over eight depths',ylabel='Rejection probability',
                title='(a) Quantum alternative',ylim=(-.025,1.04))
    axes[0].legend(loc='lower right',fontsize=8)
    for law,col,label in [('constant_half',COLORS[2],'Constant $1/2$ readout'),
                           ('period_7',COLORS[1],'Period-seven readout')]:
        rows=[x for x in sample if x['law']==law]
        axes[1].plot([x['total_shots'] for x in rows],[x['rejection_rate'] for x in rows],
                     '-o',ms=3,color=col,label=label)
    axes[1].axhline(.05,color='0.4',ls=':',label=r'Uniform bound $\alpha=0.05$')
    axes[1].set(xscale='log',xlabel='Total shots over eight depths',ylabel='False rejection probability',
                title='(b) Two null examples',ylim=(-.002,.057))
    axes[1].legend(loc='upper right',fontsize=8)
    save(fig,'finite_shot_power')
    print('Generated five vector figures and five PNG previews')

if __name__=='__main__':run()
