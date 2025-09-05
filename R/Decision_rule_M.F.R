Decision_rule_M.F <-
function(p1, p2, alpha1, beta1, alpha, beta, lambda = 1){
  
  za1 = qnorm(alpha1, lower.tail = FALSE)
  zb1 = qnorm(beta1, lower.tail = FALSE)
  za = qnorm(alpha, lower.tail = FALSE)
  zb2 = qnorm(beta - beta1, lower.tail = FALSE)
  
  Q1 = QR_fun(p1,p1)
  R1 = QR_fun(p1,p1)
  Q2 = QR_fun(p1,p2)
  R2 = QR_fun(p2,p1)
  D2 = p_plus(p1,p2)-p_minus(p1,p2)
  D1 = 0
  
  n1 <- (za1*sqrt((1+lambda)*Q1+(1+1/lambda)*R1)+zb1*sqrt((1+lambda)*Q2+(1+1/lambda)*R2))^2/D2^2
  t1 <- za1*sqrt(((1+lambda)*Q1+(1+1/lambda)*R1)/n1)
  n2 <- (za*sqrt((1+lambda)*Q1+(1+1/lambda)*R1)+zb2*sqrt((1+lambda)*Q2+(1+1/lambda)*R2))^2/D2^2
  t2 <- za*sqrt(((1+lambda)*Q1+(1+1/lambda)*R1)/n2)
  return(c(n1, t1, n2, t2))
}
