Decision_rule_W.FS <-
function(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1) {
  
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
  t1l <- theta1 + za1 * sqrt(W_W1 / n1)
  t1u <- theta1 + za2 * sqrt(W_W1 / n1)
  n2 <-
    ((zaa2 * sqrt(W_W1) + zbb1 * sqrt(W_W2)) / (theta2 - theta1)) ^ 2
  t2 <- theta1 + zaa2 * sqrt(W_W1 / n2)
  
  z.beta2 <- (theta2 - t1u) / sqrt(W_W2 / n1)
  beta2 <- pnorm(z.beta2, mean = 0, sd = 1, lower.tail = FALSE)
  
  return(c(n1, t1l, t1u, n2, t2, beta2))
}
