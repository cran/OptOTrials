p_minus <-
function(p1, p2){
  
  k = length(p1)
  p2_rev = rev(p2[-1])
  p2_sum = rev(cumsum(p2_rev))
  p1_short = p1[-k]
  res = sum(p1_short*p2_sum)
  return(res)
}
