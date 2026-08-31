## Notation follows the article: t1f is the interim futility boundary,
## t1s the interim superiority boundary, t2 the final boundary, and
## beta3 = Pr(T1 <= t1s | Ha) the continuation-side quantity of the FS
## design. beta2 = beta - beta1 belongs to the F design and does not
## appear here.
## The Mann-Whitney-Wilcoxon statistic is a difference of proportions, so
## its mean does not scale with n and no factor n1 appears in the mean term
## below; compare Decision_rule_S.FS, where the score statistic does scale.
.Decision_rule_M.FS <-
function(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1) {
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)


  za1 <- qnorm(alpha1, lower.tail = FALSE)
  za2 <- qnorm(alpha2, lower.tail = FALSE)
  zb1 <- qnorm(beta1, lower.tail = FALSE)
  zbb1 <- qnorm(beta - beta1, lower.tail = FALSE)
  zaa2 <- qnorm(alpha - alpha2, lower.tail = FALSE)
  
  Q1 <- QR_fun(p1, p1)
  R1 <- QR_fun(p1, p1)
  Q2 <- QR_fun(p1, p2)
  R2 <- QR_fun(p2, p1)
  D2 <- p_plus(p1, p2) - p_minus(p1, p2)
  D1 <- 0
  
  n1 <- (za1 * sqrt((1 + lambda) * Q1 + (1 + 1 / lambda) * R1)
         + zb1 * sqrt((1 + lambda) * Q2 + (1 + 1 / lambda) * R2)) ^ 2 / D2 ^ 2
  t1f <-
    za1 * sqrt(((1 + lambda) * Q1 + (1 + 1 / lambda) * R1) / n1)
  t1s <-
    za2 * sqrt(((1 + lambda) * Q1 + (1 + 1 / lambda) * R1) / n1)
  n2 <- (zaa2 * sqrt((1 + lambda) * Q1 + (1 + 1 / lambda) * R1)
         + zbb1 * sqrt((1 + lambda) * Q2 + (1 + 1 / lambda) * R2)) ^ 2 / D2 ^ 2
  t2 <-
    zaa2 * sqrt(((1 + lambda) * Q1 + (1 + 1 / lambda) * R1) / n2)
  
  ## beta3 = Pr(T1 <= t1s | Ha); see Decision_rule_S.FS. The mean of this
  ## statistic does not scale with n, so no factor n1 appears here.
  z.beta3 <-
    (D2 - t1s) / sqrt(((1 + lambda) * Q2 + (1 + 1 / lambda) * R2) / n1)
  beta3 <- pnorm(z.beta3, mean = 0, sd = 1, lower.tail = FALSE)
  
  return(c(n1, t1f, t1s, n2, t2, beta3))
}
