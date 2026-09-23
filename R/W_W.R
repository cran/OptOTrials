W_W <-
function(p1, p2, lambda = 1){
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)
  .validate_lambda(lambda)

  
  part1 = sum(p2*(pq_fun(p1, p2) - theta(p1, p2))^2)
  part2 = sum(p1*(pq_fun(p2, p1) - 1 + theta(p1, p2))^2)
  res = part1*(lambda+1)/lambda + part2*(lambda+1)
  return(res)
}
