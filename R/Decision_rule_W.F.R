Decision_rule_W.F <-
function(p1, p2, alpha1, beta1, alpha, beta, lambda = 1){
  
  za1 = qnorm(alpha1, lower.tail = FALSE)
  zb1 = qnorm(beta1, lower.tail = FALSE)
  za = qnorm(alpha, lower.tail = FALSE)
  zb2 = qnorm(beta - beta1, lower.tail = FALSE)
  
  theta1 = theta(p1, p1)
  theta2 = theta(p1, p2)
  W_W1 = W_W(p1, p1, lambda)
  W_W2 = W_W(p1, p2, lambda)
  
  n1 <- ((za1*sqrt(W_W1)+zb1*sqrt(W_W2))/(theta2-theta1))^2
  t1 <- theta1+za1*sqrt(W_W1/n1)
  n2 <- ((za*sqrt(W_W1)+zb2*sqrt(W_W2))/(theta2-theta1))^2
  t2 <- theta1+za*sqrt(W_W1/n2)
  return(c(n1, t1, n2, t2))
}
