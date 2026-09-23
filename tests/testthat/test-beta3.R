## beta3 = Pr(T1 <= t1s | Ha), the continuation-side quantity the article
## defines when the interim rule of the FS design is introduced. It is not
## beta2 = beta - beta1, which belongs to the F design.
##
## The three tests differ in how the statistic scales with n: the score
## statistic has mean theta * V * n, whereas the Mann-Whitney-Wilcoxon and win
## odds statistics have means that do not depend on n. The expressions in the
## decision-rule functions must reflect that, and these tests pin them against
## the normal approximation they are meant to implement.

pa <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
pb <- p2_fun(pa, log(3.06))
pc <- c(1/3, 1/3, 1/3); pd <- c(1/2, 1/3, 1/6)
a1 <- 0.30; a2 <- 0.02; b1 <- 0.05; alpha <- 0.05; beta <- 0.2; lam <- 1

test_that("the score test returns Pr(T1 <= t1s | Ha), with the factor n1", {
  r  <- OptOTrials:::.Decision_rule_S.FS(pa, pb, a1, a2, b1, alpha, beta, lam)
  n1 <- r[1]; t1s <- r[3]; beta3 <- r[6]
  V2 <- V_S.over.nk(pa, pb, lam)
  ## The common log odds ratio is rounded to five decimals inside the package,
  ## so compare against the same value rather than log(3.06) itself.
  th <- Proportional_odds_assumption(pa, pb, verbose = FALSE)
  expect_equal(beta3, pnorm((t1s - th * V2 * n1) / sqrt(V2 * n1)), tolerance = 1e-8)
  ## The value without the factor n1 is what the function used to return; it is
  ## far from the truth, so this guards against the factor being dropped again.
  expect_false(isTRUE(all.equal(beta3, pnorm((t1s - th * V2) / sqrt(V2 * n1)),
                                tolerance = 1e-3)))
})

test_that("the rank-based tests return Pr(T1 <= t1s | Ha), without a factor n1", {
  rM <- OptOTrials:::.Decision_rule_M.FS(pc, pd, a1, a2, b1, alpha, beta, lam)
  n1 <- rM[1]; t1s <- rM[3]
  D2 <- OptOTrials:::p_plus(pc, pd) - OptOTrials:::p_minus(pc, pd)
  v  <- ((1 + lam) * QR_fun(pc, pd) + (1 + 1/lam) * QR_fun(pd, pc)) / n1
  expect_equal(rM[6], pnorm((t1s - D2) / sqrt(v)), tolerance = 1e-8)

  rW <- OptOTrials:::.Decision_rule_W.FS(pc, pd, a1, a2, b1, alpha, beta, lam)
  n1 <- rW[1]; t1s <- rW[3]
  expect_equal(rW[6], pnorm((t1s - theta(pc, pd)) / sqrt(W_W(pc, pd, lam) / n1)),
               tolerance = 1e-8)
})

test_that("beta3 is a probability and is not beta - beta1", {
  for (f in c(".Decision_rule_S.FS", ".Decision_rule_M.FS", ".Decision_rule_W.FS")) {
    p <- if (f == ".Decision_rule_S.FS") list(pa, pb) else list(pc, pd)
    r <- do.call(get(f, envir = asNamespace("OptOTrials")),
                 c(p, list(a1, a2, b1, alpha, beta, lam)))
    expect_gte(r[6], 0); expect_lte(r[6], 1)
    expect_false(isTRUE(all.equal(r[6], beta - b1, tolerance = 1e-3)))
  }
})

test_that("beta3 agrees with simulation for every test", {
  skip_on_cran()
  J <- 3; N <- 40000
  statM <- function(g1, g2)
    (sum(g1[-1]*cumsum(g2[-J])) - sum(g2[-1]*cumsum(g1[-J]))) / (sum(g1)*sum(g2))
  rM <- OptOTrials:::.Decision_rule_M.FS(pc, pd, a1, a2, b1, alpha, beta, lam)
  n1 <- round(rM[1]); t1s <- rM[3]
  nc <- round(n1/2); ne <- n1 - nc
  set.seed(4)
  T1 <- replicate(N, statM(tabulate(sample(1:J, nc, TRUE, pc), J),
                           tabulate(sample(1:J, ne, TRUE, pd), J)))
  expect_equal(rM[6], mean(T1 <= t1s), tolerance = 0.03)
})

test_that("the published tables are unchanged by the correction", {
  ## Example 1 uses the F design, which does not involve beta3; Example 2 uses
  ## the FS design with the rank-based tests, whose expressions were already
  ## correct. Neither table moves.
  t2 <- design_table(alpha, beta, pc, pd, tests = c("M", "W"), criteria = 1:5,
                     stopping = "FS", nsim = 10000, seed = 1234,
                     on_degenerate = "none", digits = 3)
  expect_equal(t2$n1, c(69, 83, 75, 88, 83, 69, 83, 75, 88, 83))
  expect_equal(t2$n2, c(232, 162, 177, 177, 162, 232, 162, 177, 177, 162))
  expect_equal(t2$EN0, c(114.80, 133.34, 121.52, 123.96, 133.34,
                         115.03, 133.32, 121.40, 123.96, 133.32))
})

test_that("the whole FS rule matches its normal approximation, for all tests", {
  ## Every probability the article attaches to the FS design, checked against
  ## the normal approximation the decision rule is built from. A failure here
  ## means the code and the article's equations have diverged.
  for (tt in c("S", "M", "W")) {
    r <- get(paste0(".Decision_rule_", tt, ".FS"),
             envir = asNamespace("OptOTrials"))(pa, pb, a1, a2, b1, alpha, beta, lam)
    n1 <- r[1]; t1f <- r[2]; t1s <- r[3]; n2 <- r[4]; t2 <- r[5]; beta3 <- r[6]

    if (tt == "S") {
      m0 <- 0; s1 <- sqrt(V_S.over.nk(pa, pa, lam) * n1)
      th <- Proportional_odds_assumption(pa, pb, verbose = FALSE)
      ma <- th * V_S.over.nk(pa, pb, lam) * n1; sa <- sqrt(V_S.over.nk(pa, pb, lam) * n1)
    } else if (tt == "M") {
      m0 <- 0
      s1 <- sqrt(((1+lam)*QR_fun(pa, pa) + (1+1/lam)*QR_fun(pa, pa))/n1)
      ma <- OptOTrials:::p_plus(pa, pb) - OptOTrials:::p_minus(pa, pb)
      sa <- sqrt(((1+lam)*QR_fun(pa, pb) + (1+1/lam)*QR_fun(pb, pa))/n1)
    } else {
      m0 <- theta(pa, pa); s1 <- sqrt(W_W(pa, pa, lam)/n1)
      ma <- theta(pa, pb);  sa <- sqrt(W_W(pa, pb, lam)/n1)
    }
    expect_equal(pnorm(t1f, m0, s1), 1 - a1,  tolerance = 1e-6, info = tt)
    expect_equal(1 - pnorm(t1s, m0, s1), a2,  tolerance = 1e-6, info = tt)
    expect_equal(pnorm(t1f, ma, sa), b1,      tolerance = 1e-6, info = tt)
    expect_equal(pnorm(t1s, ma, sa), beta3,   tolerance = 1e-6, info = tt)
  }
})
