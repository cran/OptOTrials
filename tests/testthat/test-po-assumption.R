## Proportional odds diagnostic must not fail silently (comments 16, 26, 38).
test_that("failure produces a message, a warning and NA", {
  p1 <- c(1/3, 1/3, 1/3); p2 <- c(1/2, 1/3, 1/6)
  expect_message(suppressWarnings(Proportional_odds_assumption(p1, p2)),
                 "does not hold")
  expect_warning(Proportional_odds_assumption(p1, p2), "does not hold")
  expect_true(is.na(suppressWarnings(suppressMessages(
    Proportional_odds_assumption(p1, p2)))))
})

test_that("success reports the common log odds ratio", {
  p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
  p2 <- p2_fun(p1, log(2))
  expect_message(Proportional_odds_assumption(p1, p2), "holds")
  val <- suppressMessages(Proportional_odds_assumption(p1, p2))
  expect_equal(val, log(2), tolerance = 1e-4)
})

test_that("the score test is refused when the assumption fails", {
  expect_error(rule(0.05, 0.2, c(1/3, 1/3, 1/3), c(1/2, 1/3, 1/6),
                    test = "S", stopping = "F"), "proportional odds")
})
