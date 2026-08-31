.ruleFS <-
function(alpha, beta, p1, p2, method, criterion, lambda = 1) {
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  
  stopifnot(method %in% c("S", "M", "W"))
  stopifnot(criterion %in% c(1, 2, 3, 4, 5))
  
  alpha1 <- seq(alpha, 0.99, by=0.02) 
  alpha2 <- seq(0.01, alpha-0.005, by = 0.005)
  beta1 <- seq(0.01, beta-0.01, by=0.01) 
  lalpha1 <- length(alpha1)
  lalpha2 <- length(alpha2)
  lbeta1 <- length(beta1)
  
  EN0 <- array(rep(0, lalpha1*lalpha2*lbeta1), dim = c(lalpha1, lalpha2, lbeta1))
  ENa <- array(rep(0, lalpha1*lalpha2*lbeta1), dim = c(lalpha1, lalpha2, lbeta1))
  EN <- array(rep(0, lalpha1*lalpha2*lbeta1), dim = c(lalpha1, lalpha2, lbeta1))
  maxsize <- array(rep(0, lalpha1*lalpha2*lbeta1), dim = c(lalpha1, lalpha2, lbeta1))
  N1 <- array(rep(0, lalpha1*lalpha2*lbeta1), dim = c(lalpha1, lalpha2, lbeta1))
  beta3.beta1 <- array(rep(0, lalpha1*lalpha2*lbeta1), dim = c(lalpha1, lalpha2, lbeta1))
  
  for(i in 1:lalpha1){
    for(j in 1:lalpha2){
      for(l in 1:lbeta1){
        if(method == "S"){
          res <- .Decision_rule_S.FS(p1, p2, alpha1[i], alpha2[j], beta1[l], alpha, beta, lambda)
          n1 <- res[1]
          t1f <- res[2]
          t1s <- res[3]
          n2 <- res[4]
          t2 <- res[5]
          beta3 <- res[6]
          if(is.na(n1)==T & is.na(t1f)==T & is.na(t1s)==T & is.na(n2)==T & is.na(t2)==T){
            stop("In this case, the proportional odds assumption does not hold. It is not desirable to use the Score test.")  
          }
        }
        if(method == "M"){
          res = .Decision_rule_M.FS(p1, p2, alpha1[i], alpha2[j], beta1[l], alpha, beta, lambda)
          n1 <- res[1]
          t1f <- res[2]
          t1s <- res[3]
          n2 <- res[4]
          t2 <- res[5]
          beta3 <- res[6]
        }
        if(method == "W"){
          res = .Decision_rule_W.FS(p1, p2, alpha1[i], alpha2[j], beta1[l], alpha, beta, lambda)
          n1 <- res[1]
          t1f <- res[2]
          t1s <- res[3]
          n2 <- res[4]
          t2 <- res[5]
          beta3 <- res[6]
        } 
        
        EN0[i,j,l] <- n1 + (n2-n1)*(alpha1[i] - alpha2[j])
        ENa[i,j,l] <- n1 + (n2-n1)*(beta3 - beta1[l])
        EN[i,j,l] <- n1 + 0.5*(n2-n1)*(alpha1[i] - alpha2[j] + beta3 - beta1[l]) 
        maxsize[i,j,l] <- n2 
        N1[i,j,l] <- n1
        beta3.beta1[i,j,l] <- beta3 - beta1[l]
      }
    }
  } 
  
  exclude <- which(N1 >= maxsize | beta3.beta1 <= 0, arr.ind = TRUE)
  EN0[exclude] <- NA
  ENa[exclude] <- NA
  EN[exclude] <- NA
  maxsize[exclude] <- NA
  
  if(criterion %in% c(4, 5)){   # balanced design
    ind <- which(maxsize <= maxsize[which(EN == min(EN, na.rm = TRUE), 
                                          arr.ind = TRUE)], arr.ind = TRUE)
    
    num_of_choice <- nrow(ind)
    
    save <- matrix(NA, nrow = num_of_choice, ncol = 6)
    colnames(save) <- c("n1", "t1f", "t1s", "n2", "t2", "ratio")
    
    for(iter in 1:num_of_choice){
      i <- ind[iter,1]; j <- ind[iter,2]; l <- ind[iter,3]
      
      if(method == "S"){
        res <- .Decision_rule_S.FS(p1, p2, alpha1[i], alpha2[j], beta1[l], alpha, beta, lambda)
        n1 <- res[1]
        t1f <- res[2]
        t1s <- res[3]
        n2 <- res[4]
        t2 <- res[5]   
      }
      if(method == "M"){
        res <- .Decision_rule_M.FS(p1, p2, alpha1[i], alpha2[j], beta1[l], alpha, beta, lambda)
        n1 <- res[1]
        t1f <- res[2]
        t1s <- res[3]
        n2 <- res[4]
        t2 <- res[5]
      }
      if(method == "W"){
        res <- .Decision_rule_W.FS(p1, p2, alpha1[i], alpha2[j], beta1[l], alpha, beta, lambda)
        n1 <- res[1]
        t1f <- res[2]
        t1s <- res[3]
        n2 <- res[4]
        t2 <- res[5]
      } 
      
      save[iter, ] <- c(n1, t1f, t1s, n2, t2, NA)
    }
    
    save[,"ratio"] <- ceiling(save[,"n1"])/ceiling(save[,"n2"])
    if(criterion == 4 | criterion == 5){
      index_closest_to_0.5 <- 
        which(abs(save[,"ratio"] - 0.5) <= 0.02)  # [0.48, 0.52]
    }
    
    if(length(index_closest_to_0.5) == 1){
      choice = index_closest_to_0.5
    }else{
      if(criterion == 4){
        choice = 
          index_closest_to_0.5[which.min(EN0[ind[index_closest_to_0.5, ]])]
      }
      if(criterion == 5){
        choice <- index_closest_to_0.5[which.min(maxsize[ind[index_closest_to_0.5, ]])]
      }
    } 
    
    n1 <- save[choice, "n1"]; 
    t1f <- save[choice, "t1f"]; 
    t1s <- save[choice, "t1s"]; 
    n2 <- save[choice, "n2"]; 
    t2 <- save[choice, "t2"]; 
    
    res <-c(method, criterion, ceiling(n1), round(t1f, digits = 3), round(t1s, digits = 3), ceiling(n2), round(t2, digits = 3))
    return(res)
    
  }
  
  if(criterion == 1){
    ind <- which(EN0 == min(EN0, na.rm=T), arr.ind = TRUE)
  }
  if(criterion == 2){
    ind <- which(ENa == min(ENa, na.rm=T), arr.ind = TRUE)
  }
  if(criterion == 3){
    ind <- which(EN == min(EN, na.rm=T), arr.ind = TRUE)
  }
  
  i <- ind[1,1]; j <- ind[1,2]; l <- ind[1,3]
  
  if(method == "S"){
    res <- .Decision_rule_S.FS(p1, p2, alpha1[i], alpha2[j], beta1[l], alpha, beta, lambda)
    n1 <- res[1]
    t1f <- res[2]
    t1s <- res[3]
    n2 <- res[4]
    t2 <- res[5]
  }
  if(method == "M"){
    res <- .Decision_rule_M.FS(p1, p2, alpha1[i], alpha2[j], beta1[l], alpha, beta, lambda)
    n1 <- res[1]
    t1f <- res[2]
    t1s <- res[3]
    n2 <- res[4]
    t2 <- res[5]
  }
  if(method == "W"){
    res <- .Decision_rule_W.FS(p1, p2, alpha1[i], alpha2[j], beta1[l], alpha, beta, lambda)
    n1 <- res[1]
    t1f <- res[2]
    t1s <- res[3]
    n2 <- res[4]
    t2 <- res[5]
  } 
  
  res <-c(method, criterion, ceiling(n1), round(t1f, digits = 3), round(t1s, digits = 3), ceiling(n2), round(t2, digits = 3))
  
  return(res)
}
