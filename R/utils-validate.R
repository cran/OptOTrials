## Input validation and small internal helpers.
## Added in 1.1.0 in response to referee comments on silent acceptance of
## improper inputs (Reviewer 1, "Code / edge cases").

.validate_probs <- function(p1, p2, tol = 1e-6) {
  nm <- c("p1", "p2")
  for (i in seq_len(2)) {
    p <- list(p1, p2)[[i]]
    if (!is.numeric(p))
      stop(sprintf("`%s` must be a numeric vector, not %s.", nm[i], class(p)[1]),
           call. = FALSE)
    if (length(p) < 2L)
      stop(sprintf("`%s` must have at least 2 outcome categories (got %d).",
                   nm[i], length(p)), call. = FALSE)
    if (anyNA(p))
      stop(sprintf("`%s` must not contain missing values.", nm[i]), call. = FALSE)
    if (any(p < 0))
      stop(sprintf("`%s` must be non-negative; found %d negative value(s).",
                   nm[i], sum(p < 0)), call. = FALSE)
    if (abs(sum(p) - 1) > tol)
      stop(sprintf("`%s` must sum to 1 (sums to %.6f, difference %.2e > tol %.0e).",
                   nm[i], sum(p), abs(sum(p) - 1), tol), call. = FALSE)
  }
  if (length(p1) != length(p2))
    stop(sprintf("`p1` and `p2` must have the same length (got %d and %d).",
                 length(p1), length(p2)), call. = FALSE)
  invisible(TRUE)
}

## Single-vector version, used by p2_fun() where the second argument is a
## log odds ratio rather than a probability vector.
.validate_prob_vector <- function(p, nm = "p") {
  if (!is.numeric(p))
    stop(sprintf("`%s` must be a numeric vector, not %s.", nm, class(p)[1]), call. = FALSE)
  if (length(p) < 2L)
    stop(sprintf("`%s` must have at least 2 outcome categories (got %d).", nm, length(p)),
         call. = FALSE)
  if (anyNA(p))
    stop(sprintf("`%s` must not contain missing values.", nm), call. = FALSE)
  if (any(p < 0))
    stop(sprintf("`%s` must be non-negative; found %d negative value(s).",
                 nm, sum(p < 0)), call. = FALSE)
  if (abs(sum(p) - 1) > 1e-6)
    stop(sprintf("`%s` must sum to 1 (sums to %.6f).", nm, sum(p)), call. = FALSE)
  invisible(TRUE)
}

.validate_design_args <- function(alpha, beta, lambda) {
  if (!is.numeric(alpha) || length(alpha) != 1L || is.na(alpha) || !is.finite(alpha) ||
      alpha <= 0 || alpha >= 1)
    stop("`alpha` must be a single number strictly between 0 and 1.", call. = FALSE)
  if (!is.numeric(beta) || length(beta) != 1L || is.na(beta) || !is.finite(beta) ||
      beta <= 0 || beta >= 1)
    stop("`beta` must be a single number strictly between 0 and 1.", call. = FALSE)
  .validate_lambda(lambda)
  invisible(TRUE)
}

.validate_lambda <- function(lambda) {
  if (!is.numeric(lambda) || length(lambda) != 1L || is.na(lambda) ||
      !is.finite(lambda) || lambda <= 0)
    stop("`lambda` must be a single positive number.", call. = FALSE)
  invisible(TRUE)
}

## Silent internal version of Proportional_odds_assumption(), used inside the
## grid searches. The exported function messages and warns; calling that
## version from the grid would emit thousands of identical warnings.
.po_logor <- function(p1, p2) {
  J <- length(p1)
  theta_S <- rep(NA_real_, J - 1L)
  for (j in seq_len(J - 1L)) {
    Q1j <- sum(p1[1:j]); Q2j <- sum(p2[1:j])
    theta_S[j] <- log(Q2j * (1 - Q1j) / (Q1j * (1 - Q2j)))
  }
  theta_S <- round(theta_S, digits = 5)
  if (all(theta_S == theta_S[1])) theta_S[1] else NA_real_
}
