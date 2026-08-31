V_S.over.nk <-
function(p1, p2, lambda = 1){
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  
  part1 = lambda / (3*(lambda+1)^2) 
  part2 = 1 - sum(((p1 + lambda*p2)/(1 + lambda))^3)
  res = part1*part2
  return(res)
}
