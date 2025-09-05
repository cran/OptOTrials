Decision_rule_S_1stage <-
function(p1, p2, alpha, beta, lambda = 1){
  
  if(is.na(Proportional_odds_assumption(p1, p2))){
    # print("In this case, the proportional odds assumption does not hold. It is not desirable to use the Score test.")
    return(c(NA, NA))
  }else{
    theta_S = Proportional_odds_assumption(p1, p2)  # log odds ratio
  }
  
  za = qnorm(alpha, lower.tail = FALSE)
  zb = qnorm(beta, lower.tail = FALSE)
  
  V_S.over.nk1 = V_S.over.nk(p1, p1, lambda)  # under H0
  V_S.over.nk2 = V_S.over.nk(p1, p2, lambda)  # under Ha
  
  theta0 = 0 # theta_S under null hypothesis
  
  n2 <- ((za*sqrt(V_S.over.nk1)+zb*sqrt(V_S.over.nk2))/(theta_S*V_S.over.nk2-theta0*V_S.over.nk1))^2 
  t2 <- theta0*V_S.over.nk1*n2+za*sqrt(V_S.over.nk1*n2)
  
  return(c(n2, t2))
}
