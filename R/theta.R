theta <-
function(p1, p2){
  
  k = length(p1)
  p1_rev = rev(p1[-1])
  p1_sum = rev(cumsum(p1_rev))
  p2_short = p2[-k]
  p_less = sum(p2_short*p1_sum)
  p2_rev = rev(p2[-1])
  p2_sum = rev(cumsum(p2_rev))
  p1_short = p1[-k]
  p_larger = sum(p1_short*p2_sum)
  p_equal = 1 - p_less - p_larger
  res = p_less + 0.5*p_equal
  return(res)
}
