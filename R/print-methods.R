## Print methods.
## Added in 1.1.0. Both reviewers asked that output be self-explanatory to a
## novice user rather than an unnamed vector of numbers requiring the paper to
## interpret.

.test_label <- function(x) switch(x,
  "S" = "score test (proportional odds)",
  "M" = "Mann-Whitney-Wilcoxon test",
  "W" = "win odds test")

.criterion_label <- function(k) {
  if (is.na(k)) return(NA_character_)
  c("minimise E(N | H0)",
    "minimise E(N | Ha)",
    "minimise E(N) with Pr(H0) = Pr(Ha)",
    "balance stages, prioritise EN0",
    "balance stages, prioritise maximum N")[k]
}

print.OptOTrialsRule <- function(x, ...) {
  cat("Optimal design for an ordered categorical outcome\n")
  cat("-------------------------------------------------\n")
  cat("Test          :", .test_label(x$test), "\n")
  cat("Monitoring    :", switch(x$stopping,
      "F"    = "two-stage, futility only",
      "FS"   = "two-stage, futility and superiority",
      "none" = if (isTRUE(x$substituted))
                 "single stage (substituted for a degenerate two-stage optimum)"
               else "single stage"), "\n")
  if (!is.na(x$criterion))
    cat("Criterion     :", x$criterion, "-", .criterion_label(x$criterion), "\n")
  cat(sprintf("Error rates   : alpha = %.3f, beta = %.3f (power %.1f%%)\n",
              x$alpha, x$beta, 100 * (1 - x$beta)))
  cat("Allocation    : 1 :", x$lambda, "(control : experimental)\n\n")

  cat("Decision rule\n")
  if (x$stopping != "none") {
    cat(sprintf("  Stage 1: enrol %g patients in total\n", x$n1))
    cat(sprintf("    stop for futility     if T1 <= %.4f\n", x$t1f))
    if (!is.na(x$t1s))
      cat(sprintf("    stop for superiority  if T1 >  %.4f\n", x$t1s))
    cat(sprintf("    otherwise continue to stage 2\n"))
    cat(sprintf("  Stage 2: enrol up to %g patients in total\n", x$n2))
    cat(sprintf("    declare superiority   if T2 >  %.4f\n", x$t2))
  } else {
    cat(sprintf("  Enrol %g patients in total\n", x$n2))
    cat(sprintf("    declare superiority   if T  >  %.4f\n", x$t2))
  }

  if (!is.null(x$effect) && nrow(x$effect)) {
    cat("\nBoundaries on the effect-size scale\n")
    ef <- x$effect
    for (i in seq_len(nrow(ef)))
      cat(sprintf("  %-20s threshold %8.4f  ->  %s %s\n",
                  ef$stage[i], ef$threshold[i], ef$scale[i],
                  if (is.na(ef$effect[i])) "not interpretable (boundary outside attainable range)"
                  else sprintf("%.3f", ef$effect[i])))
  }

  if (isTRUE(x$degenerate)) {
    cat("\nNote: the optimum was degenerate (", x$degenerate_reason, ").\n", sep = "")
    if (isTRUE(x$substituted))
      cat("      The single-stage design shown above was substituted for it.\n")
  }
  invisible(x)
}

print.OptOTrialsOC <- function(x, ...) {
  d <- x$design
  cat("Operating characteristics\n")
  cat("-------------------------\n")
  cat("Test          :", .test_label(d$test), "\n")
  cat("Monitoring    :", switch(d$stopping,
      "F" = "futility only", "FS" = "futility and superiority",
      "none" = "single stage"), "\n")
  if (!is.na(d$criterion)) cat("Criterion     :", d$criterion, "\n")
  cat("Replicates    :", x$nsim,
      if (!is.null(x$seed)) paste0(" (seed ", x$seed, ")") else "", "\n\n")

  tb <- x$table
  cat(sprintf("%-12s %19s %10s %12s %12s %9s\n", "Scenario",
              "Reject H0 (MCSE)", "Stop fut.", "Stop super.", "Continue", "E(N)"))
  lab <- c("H0 (type I)", "Ha (power)")
  for (i in 1:2)
    cat(sprintf("%-12s %11.3f (%.3f) %10.3f %12.3f %12.3f %9.2f\n",
        lab[i], tb$reject[i], tb$se_reject[i], tb$p_stop_futility[i],
        tb$p_stop_superiority[i], tb$p_continue[i], tb$EN[i]))

  cat(sprintf("\n  EN0 = %.2f   ENa = %.2f   EN = %.2f\n", x$EN0, x$ENa, x$EN))
  ## The Monte Carlo standard error of each rejection probability is already in
  ## the table above, computed from that probability. A separate figure keyed to
  ## a nominal level would be wrong whenever alpha is not the value assumed, so
  ## none is printed.
  invisible(x)
}

## Convenience: assemble a table of designs and operating characteristics over
## several tests and criteria, replacing the expand.grid()/apply() idiom used in
## the manuscript, which required positional indexing of the returned vectors.
design_table <- function(alpha, beta, p1, p2, tests, criteria,
                         stopping = c("F", "FS"), lambda = 1,
                         nsim = 10000, seed = 1234,
                         on_degenerate = c("fallback", "warn", "error", "none"),
                         digits = NULL) {
  stopping      <- match.arg(stopping)
  on_degenerate <- match.arg(on_degenerate)
  rows <- list()
  for (tt in tests) for (cr in criteria) {
    d <- rule(alpha, beta, p1, p2, test = tt, stopping = stopping,
              criterion = cr, lambda = lambda, on_degenerate = on_degenerate)
    ## An unsubstituted degenerate optimum is reported with its decision rule
    ## but without operating characteristics, because those cannot be
    ## simulated meaningfully at a stage-1 size below two patients. The row is
    ## kept so that the degeneracy remains visible in the table. Only that one
    ## case is skipped: any other error from op() is passed on rather than
    ## silently turned into a row of NAs.
    o <- if (isTRUE(d$degenerate) && !isTRUE(d$substituted)) NULL
         else op(d, nsim = nsim, seed = seed)
    na <- NA_real_
    rows[[length(rows) + 1L]] <- data.frame(
      test = tt, criterion = cr,
      n1 = d$n1, t1f = d$t1f, t1s = d$t1s, n2 = d$n2, t2 = d$t2,
      alpha    = if (is.null(o)) na else o$alpha,
      se_alpha = if (is.null(o)) na else round(o$se_alpha, 4),
      power    = if (is.null(o)) na else o$power,
      se_power = if (is.null(o)) na else round(o$se_power, 4),
      p_fut_H0 = if (is.null(o)) na else o$table$p_stop_futility[1],
      p_sup_H0 = if (is.null(o)) na else o$table$p_stop_superiority[1],
      p_fut_Ha = if (is.null(o)) na else o$table$p_stop_futility[2],
      p_sup_Ha = if (is.null(o)) na else o$table$p_stop_superiority[2],
      EN0 = if (is.null(o)) na else o$EN0,
      ENa = if (is.null(o)) na else o$ENa,
      EN  = if (is.null(o)) na else o$EN,
      degenerate = d$degenerate,
      stringsAsFactors = FALSE)
  }
  out <- do.call(rbind, rows)
  if (stopping == "F") out$t1s <- NULL
  rownames(out) <- NULL

  ## When `digits` is supplied the table is rounded for display and EN is then
  ## recomputed from the rounded EN0 and ENa. This keeps the printed table
  ## internally consistent, so that a reader who checks EN = (EN0 + ENa)/2
  ## against the printed values reproduces the printed EN exactly.
  if (!is.null(digits)) {
    for (v in c("alpha", "power"))
      out[[v]] <- round(out[[v]], digits)
    for (v in c("EN0", "ENa"))
      out[[v]] <- round(out[[v]], 2)
    out$EN <- 0.5 * (out$EN0 + out$ENa)
    for (v in c("p_fut_H0", "p_sup_H0", "p_fut_Ha", "p_sup_Ha"))
      out[[v]] <- round(out[[v]], digits)
  }
  out
}
