.op.FS <-
function(alpha, beta, p1, p2, method, n1, t1l, t1u, n2, t2, nsim = 10000, lambda = 1){
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  
  stopifnot(method %in% c("S", "M", "W"))
  if (is.na(n1) || is.na(t1l) || is.na(t1u) || is.na(n2) || is.na(t2)) {
    return(c(NA, NA))
  }
  
  # set.seed(1234)
  
  out1=pts <- c()
  
  for(sim in 1:nsim){
    n.interim <- c(n1, n2)  
    J <- length(p1)
    
    size.c = ceiling(n2/(lambda+1)); size.c.stg1 = ceiling(n1/(lambda+1))
    # by ceiling, size.c and size.c.stg1 must be at least 1
    nc <- sample(1:J, size=size.c, replace=TRUE, prob=p1)
    ncstg1 <- nc[sample(1:size.c, size=size.c.stg1, replace=F)]
    
    group11 <- sum(ncstg1 == 1)
    group12 <-  sum(nc == 1) 
    for(j in 2:J){
      aux1 <- sum(ncstg1 == j)
      group11 <- c(group11, aux1) 
      aux2 <- sum(nc == j)
      group12 <- c(group12, aux2) 
    }
    
    size.e = n2 - size.c; size.e.stg1 = n1-size.c.stg1 
    
    if(size.e == 0){size.e = 1}       
    if(size.e.stg1 == 0){size.e.stg1 = 1}     
    
    ne <- sample(1:J, size=size.e, replace=TRUE, prob=p2) 
    nestg1 <-ne[sample(1:size.e, size=size.e.stg1, replace=F)]
    
    group21 <- sum(nestg1 == 1)
    group22 <-  sum(ne == 1)
    for(j in 2:J){
      aux1 <- sum(nestg1 == j)
      group21 <- c(group21, aux1)  
      aux2 <- sum(ne == j)
      group22 <- c(group22, aux2)  
    }
    
    if(method == "S"){
      L <- c(0, cumsum(group11[-J]))
      U <- c(rev(cumsum(rev(group11[-1]))), 0)
      T1 <- sum(group21*(U-L)) / (sum(group11)+sum(group21))
      
      L <- c(0, cumsum(group12[-J]))
      U <- c(rev(cumsum(rev(group12[-1]))), 0)
      T2 <- sum(group22*(U-L)) / (sum(group12)+sum(group22))
    }
    if(method == "M"){
      num <- sum(group11[-1]*cumsum(group21[-J]))-sum(group21[-1]*cumsum(group11[-J]))
      denom <- sum(group11)*sum(group21)
      T1 <- num/denom 
      
      num <- sum(group12[-1]*cumsum(group22[-J]))-sum(group22[-1]*cumsum(group12[-J]))
      denom <- sum(group12)*sum(group22)
      T2 <- num/denom
    }
    if(method == "W"){
      count <- sum(outer(nestg1, ncstg1, FUN = function(x, y) ifelse(x < y, 1, ifelse(x == y, 0.5, 0))))
      T1 <- count/(sum(group11)*sum(group21))
      
      count <- sum(outer(ne, nc, FUN = function(x, y) ifelse(x < y, 1, ifelse(x == y, 0.5, 0))))
      T2 <- count/(sum(group12)*sum(group22))
    }
    
    ## One exhaustive rule, so that no value of T1 can fall through.  The
    ## superiority test is strict, matching Pr(T1 > t1s) in the paper, so that
    ## T1 exactly equal to the upper boundary continues to the second stage.
    if (T1 <= t1l) {
      out1[sim] <- "Early Stop for futility"
      pts[sim] <- n.interim[1]
    } else if (T1 > t1u) {
      out1[sim] <- "Early Stop for superiority"
      pts[sim] <- n.interim[1]
    } else {
      if (T2 > t2) {
        out1[sim] <- "Reject all"
        pts[sim] <- n.interim[2]
      } else{
        out1[sim] <- "Fail stage 2"
        pts[sim] <- n.interim[2]
      }
    }
  }
  
  phat <- length(which(out1 == "Reject all" | out1 == "Early Stop for superiority")) / nsim
  mpts <- mean(pts)
  
  res <-c(round(phat, digits = 3), round(mpts, digits = 2))
  return(res)
}
