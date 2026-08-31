## Notation follows the article: t1f is the interim futility boundary,
## t1s the interim superiority boundary, t2 the final boundary, and
## beta3 = Pr(T1 <= t1s | Ha) the continuation-side quantity of the FS
## design. beta2 = beta - beta1 belongs to the F design and does not
## appear here.
## The win odds statistic is a probability, so its mean does not scale with
## n and no factor n1 appears in the mean term below; compare
## Decision_rule_S.FS, where the score statistic does scale.
.Decision_rule_W.FS <-
function(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1) {
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  
  za1 <- qnorm(alpha1, lower.tail = FALSE)
  za2 <- qnorm(alpha2, lower.tail = FALSE)
  zb1 <- qnorm(beta1, lower.tail = FALSE)
  zbb1 <- qnorm(beta - beta1, lower.tail = FALSE)
  zaa2 <- qnorm(alpha - alpha2, lower.tail = FALSE)
  
  theta1 <- theta(p1, p1)
  theta2 <- theta(p1, p2)
  W_W1 <- W_W(p1, p1, lambda)
  W_W2 <- W_W(p1, p2, lambda)
  
  n1 <-
    ((za1 * sqrt(W_W1) + zb1 * sqrt(W_W2)) / (theta2 - theta1)) ^ 2
  t1f <- theta1 + za1 * sqrt(W_W1 / n1)
  t1s <- theta1 + za2 * sqrt(W_W1 / n1)
  n2 <-
    ((zaa2 * sqrt(W_W1) + zbb1 * sqrt(W_W2)) / (theta2 - theta1)) ^ 2
  t2 <- theta1 + zaa2 * sqrt(W_W1 / n2)
  
  ## beta3 = Pr(T1 <= t1s | Ha); see Decision_rule_S.FS. The mean of this
  ## statistic does not scale with n, so no factor n1 appears here.
  z.beta3 <- (theta2 - t1s) / sqrt(W_W2 / n1)
  beta3 <- pnorm(z.beta3, mean = 0, sd = 1, lower.tail = FALSE)
  
  return(c(n1, t1f, t1s, n2, t2, beta3))
}
