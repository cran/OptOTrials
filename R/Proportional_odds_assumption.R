Proportional_odds_assumption <-
function(p1, p2){
  
  J = length(p1)
  theta_S = rep(NA, J-1)
  
  for(j in 1:(J-1)){
    Q1j = sum(p1[1:j])
    Q2j = sum(p2[1:j])
    theta_S[j] = log(Q2j*(1-Q1j)/(Q1j*(1-Q2j)))
  }
  
  theta_S = round(theta_S, digits = 5)
  if(all(theta_S == theta_S[1])){
    return(theta_S[1])
  }else{
    return(NA)
  }
  
}
