pq_fun <-
function(p1, p2){
  
  k = length(p1)
  res <- sapply(1:(k-1), function(i) sum(p1[(i+1):k]) + p1[i] * 0.5)
  res <- c(res, p1[k] * 0.5)
  return(res)
}
