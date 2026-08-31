# OptOTrials 1.0.3

Transitional release. It adds the unified interface and deprecates the earlier
one; **nothing is removed in this version**, and every function exported by
1.0.2 still works exactly as before.

## New

* `rule()` constructs a decision rule. The test statistic (`test`), the
  monitoring scheme (`stopping`) and the optimality criterion (`criterion`) are
  arguments, so one function replaces the eleven separate decision-rule
  functions.
* `op()` evaluates a design by simulation, taking the object returned by
  `rule()` and reporting both hypotheses in a single call, with the futility
  and superiority stopping probabilities separated and Monte Carlo standard
  errors on the rejection probabilities.
* `design_table()` sweeps a set of tests and criteria and returns a data frame.
* `rule()` and `op()` return classed objects with named components and
  `print()` methods, so their output need not be indexed by position.
* Input validation wherever probabilities are received: `p1` and `p2` are
  checked for numeric type, equal length, at least two categories, absence of
  missing values, non-negativity, and summation to one within `1e-6`.
* `Proportional_odds_assumption()` explains itself and warns instead of
  returning a bare `NA`.
* `rule()` detects a degenerate optimum and, by default, substitutes the
  single-stage design; controlled by `on_degenerate`.
* Decision boundaries are reported on an interpretable effect-size scale, the
  odds ratio for the score test and the win odds for the rank-based tests.
* A vignette, "Designing two-stage trials with ordered categorical outcomes".

## Deprecated

The functions below still work and still return exactly what they always
returned, but each now warns that it will be removed in version 1.1.0 and
names its replacement. See `help("OptOTrials-deprecated")`.

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

Two habits change when converting a script. `rule()` returns a named object, so
`res[3]` becomes `res$n1`, and the object is passed straight to `op()` instead
of its elements being transcribed. `op()` evaluates both hypotheses in one
call, so the old pattern of calling the simulator twice, once with `(p1, p2)`
and once with `(p1, p1)`, is no longer needed.

## Fixed

* The printed operating-characteristic summary no longer reports a Monte
  Carlo standard error keyed to a nominal level of 0.05, which was wrong for
  any other choice of `alpha`. The table already gives the standard error of
  each rejection probability, computed from that probability.

* The FS design's continuation probability under the alternative,
  `beta3 = Pr(T1 <= t1s | Ha)`, was computed for the score test without the
  factor `n1` in the mean of the statistic. The score statistic has mean
  `theta * V * n`, unlike the rank-based statistics, whose means do not scale
  with the sample size, so the omission made the value far too large. It
  entered the expected sample size under the alternative and therefore the
  objective of criteria 2, 3 and 5, so a score-test FS design could fail to
  minimise what it was asked to minimise. The Mann-Whitney-Wilcoxon and win
  odds expressions were already correct, and the F design does not use this
  quantity.
* Internal variable names now follow the article: `t1f` and `t1s` for the
  interim futility and superiority boundaries, and `beta3` for
  `Pr(T1 <= t1s | Ha)`, in place of `t1l`, `t1u` and `beta2`.

* Typographical errors in the help-page titles of `QR_fun()`,
  `V_S.over.nk()`, `Decision_rule_M.F()`, `ruleF()` and `ruleFS()`.
* The description of the value returned by `op.F()`, `op.FS()` and
  `op.1stage()`: the first element is the rejection probability, not the
  probability of an incorrect decision.

# OptOTrials 1.0.2

Initial CRAN release.
