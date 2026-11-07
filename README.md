# Finite Reversible Models of Quantum Control: Optimal Finite-Window Tests

Josef Bruzzese — research package, 11 October 2026.

The main manuscript is 12 pages, with five vector figures and a separate exact-certificate supplement. It develops a finite-window certification method for terminal measurements after repeated stationary reversible updates. All probability experiments in this package are numerical and synthetic.

## Main result

For every stationary deterministic permutation controller with at most eight evolving labels, arbitrary probabilistic readout and preparation, and mixtures of controllers independent of depth,

~~~
(f6 - f12 - f22 + f28 - f41 + f47 + f57 - f63) / 8 = 0.
~~~

The quantum Hadamard–phase target has value

~~~
(6839009527 + 1256766840 sqrt(2)) / 34359738368
  = 0.25076868003434436295...
~~~

This equals its exact maximum-norm distance from the full convexified eight-label class on depths 0–63. A feasible 45-variable certificate proves the matching upper bound.

The paper also proves the exact periodic hull, its support function, a complete robust weighted dual, cost-sensitive shot allocation, cyclotomic equality characterisation, and distinct calibrated and uncalibrated long-window limits.

## Files

- figures/: five PNG previews.
- src/reversible_tests.py: LP discovery and rational repair.
- scripts/recover_central.py: exact basis recovery.
- scripts/run_study.py: all 154 computational cases and synthetic experiments.
- scripts/verify_certificates.py: independent exact verifier, standard library only.
- scripts/make_figures.py: all figures.
- scripts/package_release.py: release ZIPs and checksums.
- data/: exact central certificate, 154 interval certificates, allocations, sampling results, and logs.
- wolfram/Computations.nb: Mathematica notebook.
- wolfram/verify.wl: independent exact Wolfram Language checker.
- wolfram/optimize.wl: independent native Mathematica LP implementation.
- RESEARCH_AUDIT.md: claim status and literature positioning.

## macOS reproduction

No GPU or laboratory access is needed. Use Terminal in this folder:

~~~bash
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -r requirements.txt
python3 scripts/recover_central.py
python3 scripts/run_study.py
python3 scripts/verify_certificates.py
python3 scripts/make_figures.py
~~~

Python 3.12 or 3.13 is suitable. The dependency versions are those executed during authoring. The certificate verifier can run alone with the standard library against the supplied data:

~~~bash
python3 scripts/verify_certificates.py
~~~

Install MacTeX or use Overleaf for LaTeX. The numerical study originally completed in about 43 seconds on its MacOS authoring environment; that is not a Mac speed claim.

## Mathematica and Wolfram Language

Open wolfram/Computations.nb in Mathematica, or run:

~~~bash
wolframscript -file wolfram/verify.wl
~~~

The exact checker was additionally independently executed under **Mathics3 10.0.1**, also passing 260 checks. Its actual engine and result are recorded in data/wolfram_checks.txt. The file optimise.wl supplies an additional native Mathematica optimisation that was not executed during authoring.

To reproduce the alternative Wolfram Language run:

~~~bash
python3 -m pip install -r requirements-wolfram-check.txt
python3 -u -m mathics --file wolfram/verify.wl
~~~

## Verification scope

- 154 rational primal/dual intervals, all narrower than 2e-8.
- Exact central optimum, with field-valued coordinates.
- 32 support comparisons against 10,188 directly enumerated small-controller cases.
- Five independent primal/explicit-dual comparisons.
- Direct matrix-power check of the target through 1,024 depths.
- 260 independent exact Wolfram Language checks, run using both Mathematica 13.3.0 and Mathics3.
- 20,000 synthetic data sets per law and shot count, plus evaluated Bernoulli distributions.

A zero dual lower bound does not by itself establish compatibility. The corresponding primal upper certificate must be checked. The other reported optima are certified intervals, not symbolic exact values.

The class excludes stochastic transitions, changes of controller during a run, depth-dependent readout, and controller mixtures correlated with the chosen test depth. The register count is not a bound on all physical resources or every classical quantum simulator.

## Links and provenance

The supplied manuscript embeds the DOI and GitHub:

- [DOI](https://doi.org/10.5281/zenodo.24025989)
- [GitHub](https://github.com/njblottly/finite-reversible-models-of-quantum-control-optimal-finite-window-tests)

The earlier paper, *Simultaneous Circuit Tests for Finite Reversible Models of Quantum Control*, arXiv:2610.06984, is cited explicitly. Its catalogue-specific 464-frame benchmark is not repackaged as the new eight-label result.