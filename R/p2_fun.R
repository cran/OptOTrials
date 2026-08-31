p2_fun <-
function(p1, theta){
  ## Input validation (Reviewer 1, comment 15).
  .validate_prob_vector(p1, "p1")
  if (!is.numeric(theta) || length(theta) != 1L || is.na(theta))
    stop("`theta` must be a single number (the log odds ratio).", call. = FALSE)

  
  Q1j = cumsum(p1)
  Q2j = Q1j / (Q1j+(1-Q1j)*exp(-theta))
  
  p2 = c(Q2j[1], diff(Q2j))
  return(p2)
}
