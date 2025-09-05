Decision_rule_S.FS <-
function(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1) {
  
  if (is.na(Proportional_odds_assumption(p1, p2))) {
    return(rep(NA, 6))
  } else{
    theta_S <- Proportional_odds_assumption(p1, p2)  # log odds ratio
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
  t1l <- theta0 * V_S.over.nk1 * n1 + za1 * sqrt(V_S.over.nk1 * n1)
  t1u <- theta0 * V_S.over.nk1 * n1 + za2 * sqrt(V_S.over.nk1 * n1)
  
  n2 <- ((zaa2 * sqrt(V_S.over.nk1) + zbb1 * sqrt(V_S.over.nk2)) / (theta_S * V_S.over.nk2 - theta0 * V_S.over.nk1)) ^ 2
  t2 <- theta0 * V_S.over.nk1 * n2 + zaa2 * sqrt(V_S.over.nk1 * n2)
  
  z.beta2 <- (theta_S * V_S.over.nk2 - t1u) / sqrt(V_S.over.nk2 * n1)
  beta2 <- pnorm(z.beta2, mean = 0, sd = 1, lower.tail = FALSE)
  
  return(c(n1, t1l, t1u, n2, t2, beta2))
}
