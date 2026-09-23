## Input validation (Reviewer 1, comment 15).
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
p2 <- p2_fun(p1, log(3.06))

test_that("rule() and op() reject improper probability vectors", {
  expect_error(rule(0.05, 0.2, c(.5, .5), c(.3, .3, .4), test = "M", stopping = "F"),
               "same length")
  expect_error(rule(0.05, 0.2, c(.5, .6), c(.3, .7), test = "M", stopping = "F"),
               "sum to 1")
  expect_error(rule(0.05, 0.2, c(-.1, 1.1), c(.3, .7), test = "M", stopping = "F"),
               "non-negative")
  expect_error(rule(0.05, 0.2, c(NA, 1), c(.3, .7), test = "M", stopping = "F"),
               "missing values")
  expect_error(rule(0.05, 0.2, "a", p2, test = "M", stopping = "F"), "numeric")
  expect_error(rule(0.05, 0.2, 1, 1, test = "M", stopping = "F"), "at least 2")
})

test_that("validation reaches the internal design and helper functions too", {
  bad1 <- c(.5, .6); bad2 <- c(.3, .7)
  expect_error(OptOTrials:::.ruleF(0.05, 0.2, bad1, bad2, "M", "1", 1), "sum to 1")
  expect_error(OptOTrials:::.ruleFS(0.05, 0.2, bad1, bad2, "M", "1", 1), "sum to 1")
        expect_error(OptOTrials:::.Decision_rule_S.F(bad1, bad2, .05, .1, .05, .2, 1), "sum to 1")
  expect_error(OptOTrials:::.Decision_rule_M.FS(bad1, bad2, .3, .02, .05, .05, .2, 1), "sum to 1")
  expect_error(OptOTrials:::.Decision_rule_W_1stage(bad1, bad2, .05, .2, 1), "sum to 1")
  expect_error(OptOTrials:::QR_fun(bad1, bad2), "sum to 1")
  expect_error(theta(bad1, bad2), "sum to 1")
  expect_error(p2_fun(bad1, log(2)), "sum to 1")
})

test_that("design arguments are validated", {
  expect_error(rule(0, 0.2, p1, p2, test = "M", stopping = "F"), "alpha")
  expect_error(rule(0.05, 1, p1, p2, test = "M", stopping = "F"), "beta")
  expect_error(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", lambda = -1), "lambda")
  expect_error(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", lambda = Inf), "lambda")
  expect_error(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", criterion = 9), "criterion")
})

test_that("advanced exported helpers validate their scalar arguments", {
  expect_error(V_S.over.nk(p1, p2, lambda = 0), "lambda")
  expect_error(W_W(p1, p2, lambda = Inf), "lambda")
  expect_error(p2_fun(p1, Inf), "finite")
})

test_that("exact fractions pass without difficulty", {
  ## c(1/3, 1/3, 1/3) does not sum to 1 in floating point; the documented
  ## tolerance of 1e-6 must let it through.
  expect_error(rule(0.05, 0.2, c(1/3, 1/3, 1/3), c(1/2, 1/3, 1/6),
                    test = "M", stopping = "FS", criterion = 1), NA)
  expect_error(theta(c(1/3, 1/3, 1/3), c(1/2, 1/3, 1/6)), NA)
})
