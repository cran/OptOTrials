## Degenerate criterion-2 optimum must be detected, not left to the user
## (Reviewers 1 and 3, comments 6, 14, 34).
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
p2 <- p2_fun(p1, log(3.06))

test_that("the default falls back to the single-stage design and says so", {
  expect_warning(d <- rule(0.05, 0.2, p1, p2, test = "M", stopping = "F",
                           criterion = 2), "degenerate")
  d <- suppressWarnings(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F",
                             criterion = 2))
  expect_true(d$degenerate)
  expect_true(d$substituted)
  expect_identical(d$stopping, "none")
  expect_equal(d$n2, 65)
  expect_equal(d$t2, 0.229, tolerance = 1e-6)
  expect_true(nzchar(d$degenerate_reason))
})

test_that("on_degenerate is honoured", {
  raw <- suppressWarnings(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F",
                               criterion = 2, on_degenerate = "none"))
  expect_equal(raw$n1, 1)
  expect_false(raw$substituted)
  expect_warning(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F",
                      criterion = 2, on_degenerate = "warn"), "degenerate")
  expect_error(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F",
                    criterion = 2, on_degenerate = "error"), "degenerate")
})

test_that("non-degenerate designs are not flagged", {
  d <- rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", criterion = 1)
  expect_false(d$degenerate)
  expect_false(d$substituted)
})

test_that("design_table() defaults to the fallback, and passes other errors on", {
  ## The default must match rule(): a degenerate optimum is substituted, not
  ## reported as NA, so that the recommended workflow needs no extra argument.
  tb <- suppressWarnings(design_table(0.05, 0.2, p1, p2, tests = "M",
                                      criteria = 2, stopping = "F",
                                      nsim = 200, seed = 1))
  expect_true(tb$degenerate)
  expect_true(is.na(tb$n1))          # substituted design is single stage
  expect_false(is.na(tb$alpha))      # and its OC are reported

  ## With on_degenerate = "none" the raw optimum is shown and only its
  ## operating characteristics are withheld.
  raw <- suppressWarnings(design_table(0.05, 0.2, p1, p2, tests = "M",
                                       criteria = 2, stopping = "F",
                                       nsim = 200, seed = 1,
                                       on_degenerate = "none"))
  expect_equal(raw$n1, 1)
  expect_true(is.na(raw$alpha))

  ## An unrelated error must not be swallowed into a row of NAs.
  expect_error(design_table(0.05, 0.2, p1, p2, tests = "M", criteria = 1,
                            stopping = "F", nsim = 0, seed = 1),
               "nsim")
})
