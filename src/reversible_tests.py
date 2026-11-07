"""Finite-window terminal-readout witnesses for stationary permutations.

LP discovery uses SciPy/HiGHS. Certificates are verified separately with
fractions; no solver status is used as an exact mathematical certificate.
"""
from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction as F
from math import isqrt
import numpy as np
from scipy.optimize import linprog
from scipy.sparse import coo_matrix


@dataclass(frozen=True)
class Quadratic:
    """Exact a+b sqrt(2), used only for the HT target."""
    a: F = F(0)
    b: F = F(0)

    def __add__(self, other):
        other = other if isinstance(other, Quadratic) else Quadratic(F(other))
        return Quadratic(self.a+other.a, self.b+other.b)

    __radd__ = __add__

    def __neg__(self):
        return Quadratic(-self.a, -self.b)

    def __sub__(self, other):
        return self + (-other if isinstance(other, Quadratic) else -F(other))

    def __rsub__(self, other):
        return -self + other

    def __mul__(self, other):
        other = other if isinstance(other, Quadratic) else Quadratic(F(other))
        return Quadratic(self.a*other.a+2*self.b*other.b,
                         self.a*other.b+self.b*other.a)

    __rmul__ = __mul__

    def interval(self, digits=70):
        den = 10**digits
        s = isqrt(2*den*den)
        lo, hi = F(s, den), F(s+1, den)
        return ((self.a+self.b*lo, self.a+self.b*hi) if self.b >= 0
                else (self.a+self.b*hi, self.a+self.b*lo))

    def __float__(self):
        # Evaluate the exact expression once; it is not a floating recurrence.
        return float(float(self.a)+float(self.b)*np.sqrt(2))


def ht_exact(length):
    """p_n=|(HT)^n[1,0]|^2 in Q(sqrt(2)), including n=0."""
    c0, c1 = Quadratic(F(1)), Quadratic(F(-1, 2), F(-1, 4))
    amplitude = Quadratic(F(6, 17), F(-1, 17))
    values = []
    for n in range(length):
        c = c0 if n == 0 else c1
        values.append(amplitude*(1-c))
        if n > 0:
            c0, c1 = c1, 2*Quadratic(F(-1, 2), F(-1, 4))*c1-c0
    return values


def support_fraction(v, budget, depths=None, reset=False):
    depths = list(range(len(v))) if depths is None else list(depths)
    candidates=[]
    for q in range(1,budget+1):
        residues=[F(0)]*q
        for n,a in zip(depths,v):residues[n%q]+=a
        candidates.append(sum((max(F(0),x) for x in residues[int(reset):]),F(0)))
    return max(candidates)


def support(v, budget, depths=None, reset=False):
    depths = np.arange(len(v)) if depths is None else np.asarray(depths)
    return max(np.maximum(0, np.bincount(depths % q, weights=v,
                                        minlength=q))[int(reset):].sum()
               for q in range(1, budget+1))


def solve_window(p, budget, weights=None, uncertainty=None, depths=None, reset=False):
    """Solve the primal extended LP; extract a dual score from its marginals.

    Minimise max_n ((|p_n-q_n|-nu_n)_+/w_n).
    The null is the convex hull of all [0,1]-valued q-periodic curves, q<=M.
    """
    p = np.asarray(p, dtype=float)
    d = len(p)
    depths = np.arange(d, dtype=int) if depths is None else np.asarray(depths, int)
    weights = np.ones(d) if weights is None else np.asarray(weights, float)
    uncertainty = np.zeros(d) if uncertainty is None else np.asarray(uncertainty, float)
    if budget < 1 or not d or len(set(depths.tolist())) != d:
        raise ValueError('Use a positive budget and distinct nonempty depths')
    if np.any(depths < 0) or np.any(weights <= 0) or np.any(uncertainty < 0):
        raise ValueError('Invalid depth, weight, or uncertainty')
    offsets = np.cumsum([0]+list(range(1, budget+1)))
    k = int(offsets[-1])
    # Variables eta[0:M], z[0:k], t. z[q,r] <= eta[q].
    rr, cc, dd = [], [], []
    for q in range(1, budget+1):
        for r in range(q):
            j = int(offsets[q-1])+r
            rr.extend([j, j]); cc.extend([budget+j, q-1]); dd.extend([1., -1.])
    for i, n in enumerate(depths):
        for q in range(1, budget+1):
            j = budget+int(offsets[q-1])+int(n % q)
            rr.extend([k+i, k+d+i]); cc.extend([j, j]); dd.extend([1., -1.])
        rr.extend([k+i, k+d+i]); cc.extend([budget+k]*2)
        dd.extend([-weights[i]]*2)
    aub = coo_matrix((dd, (rr, cc)), shape=(k+2*d, budget+k+1)).tocsr()
    aeq = coo_matrix((np.ones(budget), (np.zeros(budget), np.arange(budget))),
                     shape=(1, budget+k+1)).tocsr()
    objective = np.zeros(budget+k+1); objective[-1] = 1
    bounds = [(0, None)]*(budget+k+1)
    if reset:
        for q in range(1,budget+1):
            bounds[budget+int(offsets[q-1])] = (0, 0)
    res = linprog(objective, A_ub=aub,
                  b_ub=np.r_[np.zeros(k), p+uncertainty, -p+uncertainty],
                  A_eq=aeq, b_eq=[1.], bounds=bounds, method='highs',
                  options={'dual_feasibility_tolerance':1e-9,
                           'primal_feasibility_tolerance':1e-9})
    if not res.success:
        raise RuntimeError(res.message)
    v = res.ineqlin.marginals[k:k+d]-res.ineqlin.marginals[k+d:]
    z = res.x[budget:budget+k]
    curve = sum(z[int(offsets[q-1])+depths % q] for q in range(1, budget+1))
    return {'distance':float(res.fun), 'v':v, 'eta':res.x[:budget],
            'z':z, 'curve':curve, 'weights':weights, 'uncertainty':uncertainty,
            'depths':depths, 'budget':budget, 'reset':reset, 'status':res.message}


def solve_dual(p, budget, weights=None, uncertainty=None, reset=False):
    """Independently solve the explicit support-function dual LP."""
    p = np.asarray(p, float); d = len(p)
    weights = np.ones(d) if weights is None else np.asarray(weights, float)
    uncertainty = np.zeros(d) if uncertainty is None else np.asarray(uncertainty, float)
    k = budget*(budget+1)//2
    rr, cc, dd = [], [], []
    offset = 0
    for q in range(1, budget+1):
        for r in range(int(reset), q):
            row = offset+r
            for n in range(r, d, q):
                rr.extend([row, row]); cc.extend([n, d+n]); dd.extend([1., -1.])
            rr.append(row); cc.append(2*d+row); dd.append(-1.)
        for r in range(int(reset), q):
            rr.append(k+q-1); cc.append(2*d+offset+r); dd.append(1.)
        rr.append(k+q-1); cc.append(2*d+k); dd.append(-1.)
        offset += q
    for n, w in enumerate(weights):
        rr.extend([k+budget]*2); cc.extend([n, d+n]); dd.extend([w, w])
    aub = coo_matrix((dd, (rr, cc)), shape=(k+budget+1, 2*d+k+1)).tocsr()
    res = linprog(np.r_[-p+uncertainty, p+uncertainty, np.zeros(k), 1.],
                  A_ub=aub, b_ub=np.r_[np.zeros(k+budget), 1.],
                  bounds=(0,None), method='highs',
                  options={'dual_feasibility_tolerance':1e-9,
                           'primal_feasibility_tolerance':1e-9})
    if not res.success:
        raise RuntimeError(res.message)
    return float(-res.fun), res.x[:d]-res.x[d:2*d]


def rational_certificate(solution, target, costs=None, nu_exact=None, den=10**9):
    """Repair primal and dual into exact witnesses and enclose their gap.

    weights=sqrt(costs). The sqrt normalisation is bounded by integer arithmetic.
    Rational z/eta always satisfy the hull constraints after this repair.
    """
    m = solution['budget']; d = len(solution['depths'])
    reset = solution.get('reset',False)
    depths = list(map(int, solution['depths']))
    costs = [1]*d if costs is None else list(map(int, costs))
    nu = [F(0)]*d if nu_exact is None else list(nu_exact)
    v = [F(round(float(x)*den), den) for x in solution['v']]
    eta = [max(F(0), F(round(float(x)*den), den)) for x in solution['eta']]
    total = sum(eta)
    if total <= 0:
        raise ValueError('No preparation weight survived rationalisation')
    z = []
    j = 0
    for q in range(1, m+1):
        z.extend(F(0) if reset and r == 0 else
                 min(eta[q-1], max(F(0), F(round(float(x)*den), den)))/total
                 for r,x in enumerate(solution['z'][j:j+q]))
        j += q
    eta = [x/total for x in eta]
    exact_curve = [sum((z[q*(q-1)//2+n % q] for q in range(1,m+1)), F(0))
                   for n in depths]
    h = support_fraction(v, m, depths, reset=reset)
    raw_margin = sum((x*y for x,y in zip(v,target)), Quadratic())-h
    raw_margin -= sum((a*abs(b) for a,b in zip(nu,v)), F(0))
    scale = 10**60
    weight_lo = [F(isqrt(c*scale*scale), scale) for c in costs]
    weight_hi = [F(isqrt(c*scale*scale)+1, scale) for c in costs]
    norm_lo = sum((abs(x)*w for x,w in zip(v,weight_lo)), F(0))
    norm_hi = sum((abs(x)*w for x,w in zip(v,weight_hi)), F(0))
    lower = max(F(0), raw_margin.interval()[0]/norm_hi) if norm_hi else F(0)
    upper = F(0)
    for p, q, nn, ww in zip(target, exact_curve, nu, weight_lo):
        lo, hi = (p-q).interval()
        upper = max(upper, max(F(0), -lo-nn, hi-nn)/ww)
    return {
        'budget':m, 'depths':depths, 'costs':costs, 'reset':reset,
        'uncertainty':[str(x) for x in nu],
        'v':[str(x) for x in v], 'null_bound':str(h),
        'eta':[str(x) for x in eta], 'z':[str(x) for x in z],
        'margin_exact':{'a':str(raw_margin.a),'b':str(raw_margin.b)},
        'normalisation_lower':str(norm_lo),'normalisation_upper':str(norm_hi),
        'certified_lower':str(lower),'certified_upper':str(upper),
        'lower_float':float(lower),'upper_float':float(upper),
        'gap_float':float(upper-lower),
        'support_size':sum(x != 0 for x in v),
    }
