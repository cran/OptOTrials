p2_fun <-
function(p1, theta){
  
  Q1j = cumsum(p1)
  Q2j = Q1j / (Q1j+(1-Q1j)*exp(-theta))
  
  p2 = c(Q2j[1], diff(Q2j))
  return(p2)
}
