## Functions deprecated in version 1.0.3.
##
## Version 1.0.3 introduces rule() and op() and keeps the earlier interface
## working, so that existing scripts continue to run while their authors move
## across. Each of the names below still computes what it always did, but warns
## and names its replacement. They are removed in 1.1.0.
##
## The wrappers repeat the original argument lists rather than using `...`, so
## that the help pages and the code agree and R CMD check is satisfied.

.dep <- function(old, new) {
  warning(sprintf(paste0("'%s' is deprecated and will be removed in OptOTrials 1.1.0. ",
                         "Use '%s' instead; see help(\"OptOTrials-deprecated\")."), old, new),
          call. = FALSE)
}

ruleF <- function(alpha, beta, p1, p2, method, criterion, lambda = 1) {
  .dep("ruleF", "rule")
  .ruleF(alpha, beta, p1, p2, method, criterion, lambda)
}

ruleFS <- function(alpha, beta, p1, p2, method, criterion, lambda = 1) {
  .dep("ruleFS", "rule")
  .ruleFS(alpha, beta, p1, p2, method, criterion, lambda)
}

op.F <- function(alpha, beta, p1, p2, method, n1, t1, n2, t2, nsim = 10000, lambda = 1) {
  .dep("op.F", "op")
  .op.F(alpha, beta, p1, p2, method, n1, t1, n2, t2, nsim, lambda)
}

op.FS <- function(alpha, beta, p1, p2, method, n1, t1l, t1u, n2, t2, nsim = 10000, lambda = 1) {
  .dep("op.FS", "op")
  .op.FS(alpha, beta, p1, p2, method, n1, t1l, t1u, n2, t2, nsim, lambda)
}

op.1stage <- function(alpha, beta, p1, p2, method, n2, t2, nsim = 10000, lambda = 1) {
  .dep("op.1stage", "op")
  .op.1stage(alpha, beta, p1, p2, method, n2, t2, nsim, lambda)
}

Decision_rule_S.F <- function(p1, p2, alpha1, beta1, alpha, beta, lambda = 1) {
  .dep("Decision_rule_S.F", "rule")
  .Decision_rule_S.F(p1, p2, alpha1, beta1, alpha, beta, lambda)
}

Decision_rule_S.FS <- function(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1) {
  .dep("Decision_rule_S.FS", "rule")
  .Decision_rule_S.FS(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda)
}

Decision_rule_S_1stage <- function(p1, p2, alpha, beta, lambda = 1) {
  .dep("Decision_rule_S_1stage", "rule")
  .Decision_rule_S_1stage(p1, p2, alpha, beta, lambda)
}

Decision_rule_M.F <- function(p1, p2, alpha1, beta1, alpha, beta, lambda = 1) {
  .dep("Decision_rule_M.F", "rule")
  .Decision_rule_M.F(p1, p2, alpha1, beta1, alpha, beta, lambda)
}

Decision_rule_M.FS <- function(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1) {
  .dep("Decision_rule_M.FS", "rule")
  .Decision_rule_M.FS(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda)
}

Decision_rule_M_1stage <- function(p1, p2, alpha, beta, lambda = 1) {
  .dep("Decision_rule_M_1stage", "rule")
  .Decision_rule_M_1stage(p1, p2, alpha, beta, lambda)
}

Decision_rule_W.F <- function(p1, p2, alpha1, beta1, alpha, beta, lambda = 1) {
  .dep("Decision_rule_W.F", "rule")
  .Decision_rule_W.F(p1, p2, alpha1, beta1, alpha, beta, lambda)
}

Decision_rule_W.FS <- function(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1) {
  .dep("Decision_rule_W.FS", "rule")
  .Decision_rule_W.FS(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda)
}

Decision_rule_W_1stage <- function(p1, p2, alpha, beta, lambda = 1) {
  .dep("Decision_rule_W_1stage", "rule")
  .Decision_rule_W_1stage(p1, p2, alpha, beta, lambda)
}
