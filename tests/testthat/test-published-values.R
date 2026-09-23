## Regression tests against the values published in the article. These pin the
## numbers a reader will try to reproduce, and they do not depend on the
## interface that was removed in 1.1.0.
alpha <- 0.05; beta <- 0.2
pA <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166); pB <- p2_fun(pA, log(3.06))
pC <- c(1/3, 1/3, 1/3); pD <- c(1/2, 1/3, 1/6)

test_that("Example 1 reproduces the published F-design table", {
  t1 <- suppressWarnings(design_table(alpha, beta, pA, pB, tests = c("S","M"),
        criteria = 1:5, stopping = "F", nsim = 10000, seed = 1234,
        on_degenerate = "none", digits = 3))
  expect_equal(t1$n1,  c(29, 1, 31, 34, 32, 28, 1, 30, 35, 33))
  expect_equal(t1$t1f, c(0.654, -0.009, -0.510, -0.371, -0.876,
                         0.083, -4.715, -0.058, -0.024, -0.087))
  expect_equal(t1$n2,  c(91, 65, 67, 67, 65, 89, 67, 69, 69, 67))
  expect_equal(t1$t2,  c(4.378, 3.698, 3.753, 3.753, 3.698,
                         0.196, 0.226, 0.223, 0.223, 0.226))
  expect_equal(t1$alpha, c(0.040, NA, 0.054, 0.053, 0.053,
                           0.040, NA, 0.054, 0.047, 0.048))
  expect_equal(t1$power, c(0.832, NA, 0.815, 0.818, 0.805,
                           0.832, NA, 0.824, 0.816, 0.808))
  expect_equal(t1$EN0, c(50.22, NA, 53.53, 53.46, 55.27,
                         49.14, NA, 54.26, 53.70, 55.51))
  expect_equal(t1$ENa, c(84.55, NA, 66.32, 66.28, 64.71,
                         82.47, NA, 68.13, 68.21, 66.54))
  ## EN is rounded from its own full-precision value, not recomputed from the
  ## rounded EN0 and ENa, so three of these differ in the last digit from the
  ## average of the two columns above.
  expect_equal(t1$EN,  c(67.38, NA, 59.92, 59.87, 59.99,
                         65.80, NA, 61.20, 60.96, 61.03))
})

test_that("Example 2 reproduces the published FS-design table", {
  t2 <- design_table(alpha, beta, pC, pD, tests = c("M","W"), criteria = 1:5,
        stopping = "FS", nsim = 10000, seed = 1234,
        on_degenerate = "none", digits = 3)
  expect_equal(t2$n1,  c(69, 83, 75, 88, 83, 69, 83, 75, 88, 83))
  expect_equal(t2$n2,  c(232, 162, 177, 177, 162, 232, 162, 177, 177, 162))
  expect_equal(t2$alpha, c(0.035, 0.045, 0.047, 0.040, 0.045,
                           0.035, 0.046, 0.047, 0.040, 0.046))
  expect_equal(t2$power, c(0.835, 0.819, 0.832, 0.836, 0.819,
                           0.834, 0.819, 0.832, 0.836, 0.819))
  expect_equal(t2$EN0, c(114.80, 133.34, 121.52, 123.96, 133.34,
                         115.03, 133.32, 121.40, 123.96, 133.32))
  expect_equal(t2$ENa, c(170.71, 136.48, 144.88, 143.93, 136.48,
                         170.50, 136.22, 144.85, 143.93, 136.22))
  expect_equal(t2$EN,  c(142.76, 134.91, 133.20, 133.95, 134.91,
                         142.77, 134.77, 133.12, 133.95, 134.77))
})

test_that("the criterion 2* substitutions match the published rows", {
  for (spec in list(list("S", 63, 3.645, 0.050, 0.796),
                    list("M", 65, 0.229, 0.049, 0.804))) {
    d <- suppressWarnings(rule(alpha, beta, pA, pB, test = spec[[1]],
                               stopping = "F", criterion = 2))
    expect_true(d$substituted)
    expect_equal(d$n2, spec[[2]]); expect_equal(d$t2, spec[[3]])
    o <- op(d, nsim = 10000, seed = 1234)
    expect_equal(round(o$alpha, 3), spec[[4]])
    expect_equal(round(o$power, 3), spec[[5]])
  }
})

test_that("the single-stage comparator for Example 2 is n = 145", {
  d <- rule(alpha, beta, pC, pD, test = "M", stopping = "none")
  expect_equal(d$n2, 145)
})

test_that("the three statistics share the published thresholds at n = 28", {
  za <- qnorm(0.05, lower.tail = FALSE); n <- 28; lam <- 1
  expect_equal(round(za * sqrt(V_S.over.nk(pA, pA, lam) * n), 3), 2.439)
  expect_equal(round(za * sqrt(((1+lam)*QR_fun(pA, pA) +
                                (1+1/lam)*QR_fun(pA, pA))/n), 3), 0.348)
  expect_equal(round(0.5 + za * sqrt(W_W(pA, pA, lam)/n), 3), 0.674)
})
