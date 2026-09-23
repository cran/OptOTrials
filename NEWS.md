# OptOTrials 1.1.0

## Interface

The many separate design and simulation functions are replaced by two entry
points, in response to the referee reports on the accompanying article.

* `rule()` constructs a decision rule. The test statistic (`test`), the
  monitoring scheme (`stopping`) and the optimality criterion (`criterion`)
  are arguments.
* `op()` evaluates a design by simulation, taking the object returned by
  `rule()` and reporting both hypotheses in a single call.
* `design_table()` sweeps a set of tests and criteria and returns a data frame.

Both return classed objects with named components and `print()` methods, so
the output no longer has to be indexed by position.

## Removed

The functions below were deprecated in 1.0.3, which warned on every call, and
are removed here. If a script written for 1.0.2 stops working, the replacement is listed below.

* `ruleF()` and `ruleFS()` become `rule(..., stopping = "F")` and
  `rule(..., stopping = "FS")`.
* `Decision_rule_S.F()`, `Decision_rule_M.F()` and `Decision_rule_W.F()` become
  `rule(..., test = "S"/"M"/"W", stopping = "F")`.
* `Decision_rule_S.FS()`, `Decision_rule_M.FS()` and `Decision_rule_W.FS()`
  become `rule(..., test = "S"/"M"/"W", stopping = "FS")`.
* `Decision_rule_S_1stage()`, `Decision_rule_M_1stage()` and
  `Decision_rule_W_1stage()` become
  `rule(..., test = "S"/"M"/"W", stopping = "none")`.
* `op.F()`, `op.FS()` and `op.1stage()` become `op(design, nsim, seed)`, where
  `design` is the object returned by `rule()`.

The helpers `p_plus()`, `p_minus()` and `pq_fun()` are no longer exported.
They are intermediate quantities inside the variance calculations rather than
part of the interface, and they are still used internally.

`V_S.over.nk()`, `QR_fun()` and `W_W()` remain exported and are now documented
with examples. They give the asymptotic variance of the score,
Mann-Whitney-Wilcoxon and win odds statistics, the quantities defined in the
appendix of the accompanying article, and they let a threshold be computed at a
sample size of the user's choosing rather than at the optimal one.

Designs and operating characteristics are unchanged: the new interface
reproduces every value the old one produced, and the package test suite checks
this against the tables published in the article.

## Fixed

* `design_table()` and `print()` on an operating-characteristic object now
  round the expected sample sizes the same way. `EN0`, `ENa` and `EN` are each
  shown to two decimal places, rounded once from the value actually simulated;
  `EN` is no longer recomputed from the already-rounded `EN0` and `ENa`, which
  made `design_table()` print a third decimal that `op()` did not. Because each
  column is rounded independently, `(EN0 + ENa)/2` taken from the printed
  columns can differ from the printed `EN` by up to 0.01.

* The printed operating-characteristic summary no longer reports a Monte
  Carlo standard error keyed to a nominal level of 0.05, which was wrong for
  any other choice of `alpha`. The table already gives the standard error of
  each rejection probability, computed from that probability.

* The FS design's continuation probability under the alternative,
  `beta3 = Pr(T1 <= t1s | Ha)`, was computed for the score test without the
  factor `n1` in the mean of the statistic. The score statistic has mean
  `theta * V * n`, unlike the rank-based statistics, whose means do not scale
  with the sample size, so the omission made the value far too large (0.98
  against a true 0.45 in the article's Example 1 configuration). This entered
  the expected sample size under the alternative and therefore the objective
  of criteria 2, 3 and 5, so `rule(..., test = "S", stopping = "FS")` could
  return a design that did not minimise what it was asked to minimise. The
  Mann-Whitney-Wilcoxon and win odds expressions were already correct, and the
  F design does not use this quantity, so neither table in the accompanying
  article is affected. The internal variable is now named `beta3`, matching the
  article's notation, rather than `beta2`, which denotes `beta - beta1` in the
  F design.

## New

* Input validation on all exported functions: `p1` and `p2` are checked for
  numeric type, equal length, at least two categories, absence of missing
  values, non-negativity, and summation to one within `1e-6`.
* `Proportional_odds_assumption()` explains itself and warns instead of
  returning a bare `NA`.
* `rule()` detects a degenerate optimum, warns, and by default substitutes the
  single-stage design; controlled by `on_degenerate`.
* `op()` reports futility and superiority stopping probabilities separately,
  with Monte Carlo standard errors on the rejection probabilities, and refuses
  to simulate an unsubstituted degenerate design unless `allow_degenerate`.
* Decision boundaries are reported on an interpretable effect-size scale, the
  odds ratio for the score test and the win odds for the rank-based tests.
* A vignette, "Designing two-stage trials with ordered categorical outcomes".
* An automated test suite under `tests/testthat`.

# OptOTrials 1.0.3

Transitional release. Adds `rule()`, `op()` and `design_table()`, and deprecates
the earlier design and simulation functions: they continue to work and to return
exactly what they always returned, but warn that they will be removed in 1.1.0.
No function is removed in this version.

# OptOTrials 1.0.2

Initial CRAN release.
