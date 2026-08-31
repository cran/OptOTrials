.ruleF <-
function(alpha, beta, p1, p2, method, criterion, lambda = 1) {
  ## Input validation (Reviewer 1, comment 15): applied at every exported
  ## entry point, not only at rule() and op().
  .validate_probs(p1, p2)

  
  stopifnot(method %in% c("S", "M", "W"))
  stopifnot(criterion %in% c(1, 2, 3, 4, 5))
  
  alpha1 <- seq(alpha, 0.99, by=0.02)  
  beta1 <- seq(0.01, beta, by=0.01)   
  lalpha1 <- length(alpha1)
  lbeta1 <- length(beta1)
  
  EN0 <- matrix(rep(0, lalpha1*lbeta1), ncol=lbeta1)
  ENa <- matrix(rep(0, lalpha1*lbeta1), ncol=lbeta1)
  EN <- matrix(rep(0, lalpha1*lbeta1), ncol=lbeta1)
  maxsize <- matrix(rep(0, lalpha1*lbeta1), ncol=lbeta1)
  N1 = matrix(rep(0, lalpha1*lbeta1), ncol=lbeta1)
  for(i in 1:lalpha1){
    for (j in 1:lbeta1){
      if(method == "S"){
        res = .Decision_rule_S.F(p1, p2, alpha1[i], beta1[j], alpha, beta, lambda)
        n1 <- res[1]
        t1 <- res[2]
        n2 <- res[3]
        t2 <- res[4]
        
        # if(is.na(n1)==T & is.na(t1)==T & is.na(n2)==T & is.na(t2)==T){
        #   print("In this case, the proportional odds assumption does not hold. It is not desirable to use the Score test.")
        #   return(c(method, criterion, rep(NA, 6)))
        # }
      }
      if(method == "M"){
        res = .Decision_rule_M.F(p1, p2, alpha1[i], beta1[j], alpha, beta, lambda)
        n1 <- res[1]
        t1 <- res[2]
        n2 <- res[3]
        t2 <- res[4]
      }
      if(method == "W"){
        res = .Decision_rule_W.F(p1, p2, alpha1[i], beta1[j], alpha, beta, lambda)
        n1 <- res[1]
        t1 <- res[2]
        n2 <- res[3]
        t2 <- res[4]
      } 
      
      EN0[i,j] <- n1 + (n2-n1)*alpha1[i]
      ENa[i,j] <- n1 + (n2-n1)*(1-beta1[j])
      EN[i,j] <- n1 + 0.5*(n2-n1)*(alpha1[i]+1-beta1[j]) 
      maxsize[i,j] = n2 
      N1[i,j] <- n1
    }
  } 
  
  exclude <- which(N1 >= maxsize, arr.ind = TRUE)
  EN0[exclude] <- NA
  ENa[exclude] <- NA
  EN[exclude] <- NA
  maxsize[exclude] <- NA
  
  if(criterion %in% c(4, 5)){  
    
    ind <- which(maxsize <= maxsize[which(EN == min(EN, na.rm = TRUE), 
                                          arr.ind = TRUE)], arr.ind = TRUE)
    num_of_choice = nrow(ind)
    save = matrix(NA, nrow = num_of_choice, ncol = 5)
    colnames(save) <- c("n1", "t1", "n2", "t2", "ratio")
    
    for(iter in 1:num_of_choice){
      i=ind[iter,1]; j=ind[iter,2]
      if(method == "S"){
        res = .Decision_rule_S.F(p1, p2, alpha1[i], beta1[j], alpha, beta, lambda)
        n1 <- res[1]
        t1 <- res[2]
        n2 <- res[3]
        t2 <- res[4]
      }
      if(method == "M"){
        res = .Decision_rule_M.F(p1, p2, alpha1[i], beta1[j], alpha, beta, lambda)
        n1 <- res[1]
        t1 <- res[2]
        n2 <- res[3]
        t2 <- res[4]
      }
      if(method == "W"){
        res = .Decision_rule_W.F(p1, p2, alpha1[i], beta1[j], alpha, beta, lambda)
        n1 <- res[1]
        t1 <- res[2]
        n2 <- res[3]
        t2 <- res[4]
      } 
      save[iter, ] = c(n1, t1, n2, t2, NA)
    }
    save[,"ratio"] = ceiling(save[,"n1"])/ceiling(save[,"n2"])
    
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
    t1 <- save[choice, "t1"]; 
    n2 <- save[choice, "n2"]; 
    t2 <- save[choice, "t2"]; 
    
    res <-c(method, criterion, ceiling(n1), round(t1, digits = 3), ceiling(n2), round(t2, digits = 3))
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
  
  i=ind[1,1]; j=ind[1,2]
  chosen.alpha1 = alpha1[i];    
  chosen.beta1 = beta1[j];     
  
  za1 <- qnorm(alpha1[i],lower.tail = FALSE)
  zb1 <- qnorm(beta1[j],lower.tail = FALSE)
  za <- qnorm(alpha,lower.tail = FALSE)
  zb2 <- qnorm(beta-beta1[j],lower.tail = FALSE)
  
  if(method == "S"){
    res = .Decision_rule_S.F(p1, p2, alpha1[i], beta1[j], alpha, beta, lambda)
    n1 <- res[1]
    t1 <- res[2]
    n2 <- res[3]
    t2 <- res[4]
  }
  if(method == "M"){
    res = .Decision_rule_M.F(p1, p2, alpha1[i], beta1[j], alpha, beta, lambda)
    n1 <- res[1]
    t1 <- res[2]
    n2 <- res[3]
    t2 <- res[4]
  }
  if(method == "W"){
    res = .Decision_rule_W.F(p1, p2, alpha1[i], beta1[j], alpha, beta, lambda)
    n1 <- res[1]
    t1 <- res[2]
    n2 <- res[3]
    t2 <- res[4]
  } 
  
  res <-c(method, criterion, ceiling(n1), round(t1, digits = 3), ceiling(n2), round(t2, digits = 3))
  return(res)
}
