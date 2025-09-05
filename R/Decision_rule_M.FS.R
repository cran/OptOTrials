Decision_rule_M.FS <-
function(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1) {

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
  t1l <-
    za1 * sqrt(((1 + lambda) * Q1 + (1 + 1 / lambda) * R1) / n1)
  t1u <-
    za2 * sqrt(((1 + lambda) * Q1 + (1 + 1 / lambda) * R1) / n1)
  n2 <- (zaa2 * sqrt((1 + lambda) * Q1 + (1 + 1 / lambda) * R1)
         + zbb1 * sqrt((1 + lambda) * Q2 + (1 + 1 / lambda) * R2)) ^ 2 / D2 ^ 2
  t2 <-
    zaa2 * sqrt(((1 + lambda) * Q1 + (1 + 1 / lambda) * R1) / n2)
  
  z.beta2 <-
    (D2 - t1u) / sqrt(((1 + lambda) * Q2 + (1 + 1 / lambda) * R2) / n1)
  beta2 <- pnorm(z.beta2, mean = 0, sd = 1, lower.tail = FALSE)
  
  return(c(n1, t1l, t1u, n2, t2, beta2))
}
