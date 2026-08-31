## Notation follows the article: t1f is the interim futility boundary,
## t1s the interim superiority boundary, t2 the final boundary, and
## beta3 = Pr(T1 <= t1s | Ha) the continuation-side quantity of the FS
## design. beta2 = beta - beta1 belongs to the F design and does not
## appear here.
## The score statistic has mean theta_S * V * n and standard deviation
## sqrt(V * n), so both scale with the sample size and the mean term below
## carries the factor n1. The rank-based tests use statistics whose mean
## does not depend on n, which is why their expressions differ.
.Decision_rule_S.FS <-
function(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1) {
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  
  if (is.na(.po_logor(p1, p2))) {
    return(rep(NA, 6))
  } else{
    theta_S <- .po_logor(p1, p2)  # log odds ratio
  }
  
  za1 <- qnorm(alpha1, lower.tail = FALSE)
  za2 <- qnorm(alpha2, lower.tail = FALSE)
  zb1 <- qnorm(beta1, lower.tail = FALSE)
  zbb1 <- qnorm(beta - beta1, lower.tail = FALSE)
  zaa2 <- qnorm(alpha - alpha2, lower.tail = FALSE)
  
  V_S.over.nk1 <- (lambda / (3 * (lambda + 1) ^ 2)) * (1 - sum(((p1 + lambda * p1) / (1 + lambda)) ^ 3))
  V_S.over.nk2 <- (lambda / (3 * (lambda + 1) ^ 2)) * (1 - sum(((p1 + lambda * p2) / (1 + lambda)) ^ 3))
  
  theta0 <- 0   # the value of theta_S under null hypothesis
  
  n1 <- ((za1 * sqrt(V_S.over.nk1) + zb1 * sqrt(V_S.over.nk2)) / (theta_S * V_S.over.nk2 - theta0 * V_S.over.nk1)) ^ 2
  t1f <- theta0 * V_S.over.nk1 * n1 + za1 * sqrt(V_S.over.nk1 * n1)
  t1s <- theta0 * V_S.over.nk1 * n1 + za2 * sqrt(V_S.over.nk1 * n1)
  
  n2 <- ((zaa2 * sqrt(V_S.over.nk1) + zbb1 * sqrt(V_S.over.nk2)) / (theta_S * V_S.over.nk2 - theta0 * V_S.over.nk1)) ^ 2
  t2 <- theta0 * V_S.over.nk1 * n2 + zaa2 * sqrt(V_S.over.nk1 * n2)
  
  ## beta3 = Pr(T1 <= t1s | Ha), the quantity the article defines where the
  ## interim rule is introduced. It is NOT beta2 = beta - beta1, which belongs
  ## to the F design. The score statistic has mean theta_S * V * n and standard
  ## deviation sqrt(V * n), so the mean term carries the factor n1. The
  ## rank-based tests use statistics whose mean does not scale with n, which is
  ## why their expressions have no such factor.
  z.beta3 <- (theta_S * V_S.over.nk2 * n1 - t1s) / sqrt(V_S.over.nk2 * n1)
  beta3 <- pnorm(z.beta3, mean = 0, sd = 1, lower.tail = FALSE)
  
  return(c(n1, t1f, t1s, n2, t2, beta3))
}
