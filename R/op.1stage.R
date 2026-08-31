.op.1stage <-
function(alpha, beta, p1, p2, method, n2, t2, nsim = 10000, lambda = 1){
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  
  stopifnot(method %in% c("S", "M", "W"))
  if (is.na(n2) || is.na(t2)) {
    return(c(NA, NA))
  }
  
  # set.seed(1234)
  
  out1=pts <- c()
  
  for(sim in 1:nsim){
    n.interim <- n2  
    J <- length(p1)
    
    size.c = ceiling(n2/(lambda+1))
    
    nc <- sample(1:J, size=size.c, replace=TRUE, prob=p1)
    
    group12 <-  sum(nc == 1) 
    for(j in 2:J){
      aux2 <- sum(nc == j)
      group12 <- c(group12, aux2) 
    }
    
    size.e = n2 - size.c
    
    ne <- sample(1:J, size=size.e, replace=TRUE, prob=p2) 
    
    group22 <-  sum(ne == 1)
    for(j in 2:J){
      aux2 <- sum(ne == j)
      group22 <- c(group22, aux2)  
    }
    
    if(method == "S"){
      L <- c(0, cumsum(group12[-J]))
      U <- c(rev(cumsum(rev(group12[-1]))), 0)
      T2 <- sum(group22*(U-L)) / (sum(group12)+sum(group22))
    }
    if(method == "M"){
      num <- sum(group12[-1]*cumsum(group22[-J]))-sum(group22[-1]*cumsum(group12[-J]))
      denom <- sum(group12)*sum(group22)
      T2 <- num/denom
    }
    if(method == "W"){
      count <- sum(outer(ne, nc, FUN = function(x, y) ifelse(x < y, 1, ifelse(x == y, 0.5, 0))))
      T2 <- count/(sum(group12)*sum(group22))
    }
    
    if(T2>t2){
      out1[sim] <- "Reject all"
      pts[sim] <- n.interim
    }else{
      out1[sim] <- "Fail stage 2"
      pts[sim] <- n.interim
    }
  }
  
  phat <- length(which(out1=="Reject all"))/nsim
  mpts <- mean(pts)
  
  res <-c(round(phat, digits = 3), round(mpts, digits = 2))
  return(res)
}
