.Decision_rule_W_1stage <-
function(p1, p2, alpha, beta, lambda = 1){
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  
  za = qnorm(alpha, lower.tail = FALSE)
  zb = qnorm(beta, lower.tail = FALSE)
  
  theta1 = theta(p1, p1)
  theta2 = theta(p1, p2)
  W_W1 = W_W(p1, p1, lambda)
  W_W2 = W_W(p1, p2, lambda)
  
  n2 <- ((za*sqrt(W_W1)+zb*sqrt(W_W2))/(theta2-theta1))^2
  t2 <- theta1+za*sqrt(W_W1/n2)
  
  return(c(n2, t2))
}
