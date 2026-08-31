## Unified design function.
## Added in 1.1.0. Replaces the eleven separate decision-rule functions with a
## single entry point whose test and stopping rule are chosen by argument
## (Reviewer 3, "Code"). The earlier functions remain exported so that existing
## user code continues to work.

rule <- function(alpha, beta, p1, p2,
                 test     = c("S", "M", "W"),
                 stopping = c("F", "FS", "none"),
                 criterion = 1,
                 lambda   = 1,
                 on_degenerate = c("fallback", "warn", "error", "none"),
                 min_n1   = 10) {

  test          <- match.arg(test)
  stopping      <- match.arg(stopping)
  on_degenerate <- match.arg(on_degenerate)

  .validate_design_args(alpha, beta, lambda)
  .validate_probs(p1, p2)

  if (stopping != "none") {
    if (!(length(criterion) == 1L && as.character(criterion) %in% as.character(1:5)))
      stop("`criterion` must be one of 1, 2, 3, 4, 5.", call. = FALSE)
  }

  if (test == "S" && is.na(.po_logor(p1, p2)))
    stop("The proportional odds assumption does not hold for `p1` and `p2`, ",
         "so the score test (test = \"S\") is not appropriate here. ",
         "Use test = \"M\" or test = \"W\", or call ",
         "Proportional_odds_assumption(p1, p2) to inspect the assumption.",
         call. = FALSE)

  out <- list(test = test, stopping = stopping, stopping_requested = stopping,
              criterion = if (stopping == "none") NA_integer_ else as.integer(criterion),
              alpha = alpha, beta = beta, lambda = lambda, p1 = p1, p2 = p2,
              n1 = NA_real_, t1f = NA_real_, t1s = NA_real_,
              n2 = NA_real_, t2 = NA_real_,
              degenerate = FALSE, degenerate_reason = NA_character_,
              substituted = FALSE)

  if (stopping == "none") {
    f <- get(paste0(".Decision_rule_", test, "_1stage"), envir = asNamespace("OptOTrials"))
    r <- f(p1, p2, alpha, beta, lambda)
    out$n2 <- ceiling(r[1]); out$t2 <- round(r[2], 3)

  } else if (stopping == "F") {
    r <- .ruleF(alpha, beta, p1, p2, test, as.character(criterion), lambda)
    out$n1  <- as.numeric(r[3]); out$t1f <- as.numeric(r[4])
    out$n2  <- as.numeric(r[5]); out$t2  <- as.numeric(r[6])

  } else {
    r <- .ruleFS(alpha, beta, p1, p2, test, as.character(criterion), lambda)
    out$n1  <- as.numeric(r[3]); out$t1f <- as.numeric(r[4])
    out$t1s <- as.numeric(r[5])
    out$n2  <- as.numeric(r[6]); out$t2  <- as.numeric(r[7])
  }

  ## ---- degeneracy detection -------------------------------------------
  ## Minimising the expected sample size under the alternative (criterion 2)
  ## can drive the optimum to n1 = 1 with an interim boundary so far into the
  ## lower tail that the interim analysis cannot change any decision: the
  ## design is then two-stage in name only. Previously the user had to notice
  ## this; the software now detects it (Reviewers 1 and 3).
  if (stopping != "none" && !is.na(out$n1)) {
    reasons <- character(0)
    if (out$n1 < min_n1)
      reasons <- c(reasons, sprintf("stage-1 sample size n1 = %g is below min_n1 = %g",
                                    out$n1, min_n1))
    if (!is.na(out$t1f)) {
      pfut <- .p_stop_futility_null(test, out$t1f, out$n1, p1, lambda)
      if (!is.na(pfut) && pfut < 0.005)
        reasons <- c(reasons, sprintf(
          "the interim futility boundary t1f = %g is so extreme that the trial stops early with probability %.4f under H0",
          out$t1f, pfut))
    }
    if (length(reasons)) {
      out$degenerate <- TRUE
      out$degenerate_reason <- paste(reasons, collapse = "; ")
      msg <- sprintf(
        "The optimum for test = \"%s\", criterion = %s has collapsed to a degenerate two-stage design (%s).",
        test, criterion, out$degenerate_reason)
      if (on_degenerate == "error") {
        stop(msg, call. = FALSE)
      } else if (on_degenerate %in% c("warn", "fallback")) {
        if (on_degenerate == "fallback") {
          warning(msg, " Returning the single-stage design instead; ",
                  "set on_degenerate = \"none\" to obtain the raw optimum.",
                  call. = FALSE)
          ss <- rule(alpha, beta, p1, p2, test = test, stopping = "none",
                     lambda = lambda)
          out$n1 <- NA_real_; out$t1f <- NA_real_; out$t1s <- NA_real_
          out$n2 <- ss$n2;    out$t2  <- ss$t2
          out$substituted <- TRUE
          ## The returned design really is single stage now, so record that:
          ## print() and op() then treat it correctly without special-casing.
          out$stopping_requested <- out$stopping
          out$stopping <- "none"
        } else {
          warning(msg, call. = FALSE)
        }
      }
    }
  }

  out$effect <- .effect_table(out)
  class(out) <- "OptOTrialsRule"
  out
}

## Probability of stopping for futility at the interim under H0, used only to
## flag degenerate designs.
.p_stop_futility_null <- function(test, t1f, n1, p1, lambda) {
  if (is.na(t1f) || is.na(n1) || n1 <= 0) return(NA_real_)
  sdT <- switch(test,
    "S" = sqrt(V_S.over.nk(p1, p1, lambda) * n1),
    "M" = sqrt(((1 + lambda) * QR_fun(p1, p1) + (1 + 1/lambda) * QR_fun(p1, p1)) / n1),
    "W" = sqrt(W_W(p1, p1, lambda) / n1))
  meanT <- if (test == "W") 0.5 else 0
  if (!is.finite(sdT) || sdT <= 0) return(NA_real_)
  stats::pnorm(t1f, mean = meanT, sd = sdT)
}
