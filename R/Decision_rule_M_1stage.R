.Decision_rule_M_1stage <-
function(p1, p2, alpha, beta, lambda = 1){
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  za = qnorm(alpha, lower.tail = FALSE)
  zb = qnorm(beta, lower.tail = FALSE)
  
  Q1 = QR_fun(p1,p1)
  R1 = QR_fun(p1,p1)
  Q2 = QR_fun(p1,p2)
  R2 = QR_fun(p2,p1)
  D2 = p_plus(p1,p2)-p_minus(p1,p2)
  D1 = 0
  
  n2 <- (za*sqrt((1+lambda)*Q1+(1+1/lambda)*R1)+zb*sqrt((1+lambda)*Q2+(1+1/lambda)*R2))^2/D2^2
  t2 <- za*sqrt(((1+lambda)*Q1+(1+1/lambda)*R1)/n2)
  
  return(c(n2, t2))
}
