p_plus <-
function(p1, p2){
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  
  k = length(p1)
  p1_rev = rev(p1[-1])
  p1_sum = rev(cumsum(p1_rev))
  p2_short = p2[-k]
  res = sum(p2_short*p1_sum)
  return(res)
}
