## Translation of decision boundaries from the test-statistic scale onto a
## clinically interpretable effect-size scale.
## Added in 1.1.0 in response to Reviewer 1: data monitoring committees and
## trialists reason about boundaries as effect sizes, not test statistics.

## For the score test the statistic T at total sample size n satisfies
##   E(T | theta) ~= theta * V * n   and   sd(T) = sqrt(V * n),
## with V = V_S.over.nk(p1, p1, lambda) the null variance factor, so the log
## odds ratio implied by a boundary t is theta = t / (V * n) -- the usual
## score-statistic-to-estimate relation theta_hat = U / I.
##
## For the Mann-Whitney-Wilcoxon test T estimates
##   D = P(Y_E < Y_C) - P(Y_E > Y_C),
## so a boundary t implies win probability (t + 1) / 2.
##
## For the win odds test T is already the win probability, so a boundary t
## implies win probability t directly.
##
## In both nonparametric cases the win odds are wp / (1 - wp).

.effect_at_boundary <- function(test, t, n, p1, lambda = 1) {
  if (is.na(t) || is.na(n)) return(list(scale = NA_character_, value = NA_real_))
  if (test == "S") {
    V <- V_S.over.nk(p1, p1, lambda)
    return(list(scale = "odds ratio", value = exp(t / (V * n))))
  }
  wp <- if (test == "M") (t + 1) / 2 else t
  ## A boundary far outside the attainable range of the statistic -- which
  ## happens for a degenerate optimum -- has no meaningful effect-size
  ## interpretation, so report NA rather than a nonsensical value.
  if (!is.finite(wp) || wp <= 0 || wp >= 1)
    return(list(scale = "win odds", value = NA_real_))
  list(scale = "win odds", value = wp / (1 - wp))
}

.effect_table <- function(x) {
  bounds <- list(
    c(name = "t1f", label = "interim futility",    t = x$t1f, n = x$n1),
    c(name = "t1s", label = "interim superiority", t = x$t1s, n = x$n1),
    c(name = "t2",  label = "final analysis",      t = x$t2,  n = x$n2))
  keep <- vapply(bounds, function(b) !is.na(b[["t"]]), logical(1))
  bounds <- bounds[keep]
  if (!length(bounds))
    return(data.frame(boundary = character(0), stage = character(0),
                      threshold = numeric(0), scale = character(0),
                      effect = numeric(0), stringsAsFactors = FALSE))
  do.call(rbind, lapply(bounds, function(b) {
    e <- .effect_at_boundary(x$test, as.numeric(b[["t"]]), as.numeric(b[["n"]]),
                             x$p1, x$lambda)
    data.frame(boundary  = b[["name"]],
               stage     = b[["label"]],
               threshold = round(as.numeric(b[["t"]]), 4),
               scale     = e$scale,
               effect    = round(e$value, 3),
               stringsAsFactors = FALSE)
  }))
}
