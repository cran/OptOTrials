## FS parity, op() versus the legacy simulators, and the boundary convention.
p1 <- c(1/3, 1/3, 1/3); p2 <- c(1/2, 1/3, 1/6)
pa <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166); pb <- p2_fun(pa, log(3.06))

test_that("rule() reproduces OptOTrials:::.ruleFS() exactly for every test and criterion", {
  for (tt in c("M", "W")) for (cr in 1:5) {
    new <- suppressWarnings(rule(0.05, 0.2, p1, p2, test = tt, stopping = "FS",
                                 criterion = cr, on_degenerate = "none"))
    old <- OptOTrials:::.ruleFS(0.05, 0.2, p1, p2, tt, as.character(cr), 1)
    expect_equal(new$n1,  as.numeric(old[3]), info = paste(tt, cr))
    expect_equal(new$t1f, as.numeric(old[4]), info = paste(tt, cr))
    expect_equal(new$t1s, as.numeric(old[5]), info = paste(tt, cr))
    expect_equal(new$n2,  as.numeric(old[6]), info = paste(tt, cr))
    expect_equal(new$t2,  as.numeric(old[7]), info = paste(tt, cr))
  }
})

## The legacy simulators round their return values (3 and 2 digits), so the
## comparison rounds op()'s values the same way.

test_that("T1 exactly on a boundary follows the documented convention", {
  ## Futility uses <=, superiority uses >, so T1 == t1f stops for futility and
  ## T1 == t1s continues.  Both simulators must agree on this.
  d <- rule(0.05, 0.2, p1, p2, test = "M", stopping = "FS", criterion = 1)
  src_new <- paste(deparse(OptOTrials:::.sim_core), collapse = " ")
  expect_true(grepl("T1 <= t1f", src_new, fixed = TRUE))
  expect_true(grepl("T1 > t1s",  src_new, fixed = TRUE))
  expect_false(grepl("T1 >= t1s", src_new, fixed = TRUE))
})

test_that("a degenerate design is refused by op() unless overridden", {
  raw <- suppressWarnings(rule(0.05, 0.2, pa, pb, test = "M", stopping = "F",
                               criterion = 2, on_degenerate = "none"))
  expect_true(raw$degenerate)
  expect_error(op(raw, nsim = 200, seed = 1), "degenerate")
  expect_error(op(raw, nsim = 200, seed = 1, allow_degenerate = TRUE), NA)
})
