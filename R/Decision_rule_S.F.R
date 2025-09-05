Decision_rule_S.F <-
function(p1, p2, alpha1, beta1, alpha, beta, lambda = 1){

  if(is.na(Proportional_odds_assumption(p1, p2))){
    # print("In this case, the proportional odds assumption does not hold. It is not desirable to use the Score test.")
    return(c(NA, NA, NA, NA))
  }else{
    theta_S = Proportional_odds_assumption(p1, p2)  # log odds ratio
  }
  
  za1 = qnorm(alpha1, lower.tail = FALSE)
  zb1 = qnorm(beta1, lower.tail = FALSE)
  za = qnorm(alpha, lower.tail = FALSE)
  zb2 = qnorm(beta - beta1, lower.tail = FALSE)
  
  V_S.over.nk1 = V_S.over.nk(p1, p1, lambda)
  V_S.over.nk2 = V_S.over.nk(p1, p2, lambda)
  
  theta0 = 0 # theta_S under null hypothesis
  
  n1 <- ((za1*sqrt(V_S.over.nk1)+zb1*sqrt(V_S.over.nk2))/(theta_S*V_S.over.nk2-theta0*V_S.over.nk1))^2 
  t1 <- theta0*V_S.over.nk1*n1+za1*sqrt(V_S.over.nk1*n1)
  
  n2 <- ((za*sqrt(V_S.over.nk1)+zb2*sqrt(V_S.over.nk2))/(theta_S*V_S.over.nk2-theta0*V_S.over.nk1))^2 
  t2 <- theta0*V_S.over.nk1*n2+za*sqrt(V_S.over.nk1*n2)
  
  return(c(n1, t1, n2, t2))
}
