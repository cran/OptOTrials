V_S.over.nk <-
function(p1, p2, lambda = 1){
  
  part1 = lambda / (3*(lambda+1)^2) 
  part2 = 1 - sum(((p1 + lambda*p2)/(1 + lambda))^3)
  res = part1*part2
  return(res)
}
