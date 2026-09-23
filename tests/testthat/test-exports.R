## Version 1.1.0 exposes nine functions and nothing else. The separate function
## provided for each combination of test and stopping rule up to 1.0.2 was
## deprecated in 1.0.3 and is removed here; NEWS.md records the correspondence.
API <- c("rule", "op", "design_table",
         "Proportional_odds_assumption", "p2_fun", "theta",
         "V_S.over.nk", "QR_fun", "W_W")

test_that("the package exports exactly the nine documented functions", {
  expect_setequal(getNamespaceExports("OptOTrials"), API)
})

test_that("the removed names are not exported", {
  gone <- c("ruleF", "ruleFS", "op.F", "op.FS", "op.1stage",
            "Decision_rule_S.F", "Decision_rule_S.FS", "Decision_rule_S_1stage",
            "Decision_rule_M.F", "Decision_rule_M.FS", "Decision_rule_M_1stage",
            "Decision_rule_W.F", "Decision_rule_W.FS", "Decision_rule_W_1stage",
            "p_plus", "p_minus", "pq_fun")
  expect_false(any(gone %in% getNamespaceExports("OptOTrials")))
})

test_that("every exported function is callable", {
  p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
  p2 <- p2_fun(p1, log(3.06))
  expect_s3_class(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F",
                       criterion = 1), "OptOTrialsRule")
  expect_s3_class(op(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F",
                          criterion = 1), nsim = 200, seed = 1), "OptOTrialsOC")
  expect_s3_class(design_table(0.05, 0.2, p1, p2, tests = "M", criteria = 1,
                               stopping = "F", nsim = 200, seed = 1), "data.frame")
  expect_type(suppressMessages(Proportional_odds_assumption(p1, p2)), "double")
  expect_length(p2_fun(p1, log(2)), length(p1))
  expect_type(theta(p1, p2), "double")
  expect_type(V_S.over.nk(p1, p1), "double")
  expect_type(QR_fun(p1, p1), "double")
  expect_type(W_W(p1, p1), "double")
})

test_that("the exported variance kernels reproduce the published thresholds", {
  p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
  za <- qnorm(0.05, lower.tail = FALSE); n <- 28; lam <- 1
  expect_equal(round(za * sqrt(V_S.over.nk(p1, p1, lam) * n), 3), 2.439)
  expect_equal(round(za * sqrt(((1+lam)*QR_fun(p1, p1) +
                                (1+1/lam)*QR_fun(p1, p1))/n), 3), 0.348)
  expect_equal(round(0.5 + za * sqrt(W_W(p1, p1, lam)/n), 3), 0.674)
})
