QR_fun <-
function(p1, p2){
  
  k = length(p1)
  DD2 = (p_plus(p1,p2) - p_minus(p1,p2))^2
  
  # compute the first part
  p2_rev = rev(p2[-1])
  p2_sum = rev(cumsum(p2_rev))
  p1_short = p1[-k]
  part1 = sum(p1_short*(p2_sum^2))
  
  # compute the second part
  p1_short2 = p1[-1]
  p2_short = p2[-k]
  p2_sum2 = cumsum(p2_short)
  part2 = sum(p1_short2*(p2_sum2^2))
  
  # compute the third part
  p1_short3 =  p1_short[-1]
  p2_short2 =  p2_short[-(k-1)]
  p2_rev2 = rev(p2[-c(1,2)])
  p2_sum3 = cumsum(p2_short2)
  p2_sum4 = rev(cumsum(p2_rev2))
  part3 = 2*sum(p1_short3*p2_sum3*p2_sum4)
  res = part1+part2-part3-DD2
  return(res)
}
