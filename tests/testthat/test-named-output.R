## Self-describing, named output with print() methods (comments 12, 13, 47).
p1 <- c(0.2, 0.5, 0.2, 0.1); p2 <- c(0.4, 0.3, 0.2, 0.1)

test_that("rule() returns a classed object with named components", {
  d <- rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", criterion = 1)
  expect_s3_class(d, "OptOTrialsRule")
  expect_true(all(c("n1", "t1f", "n2", "t2", "effect", "test", "criterion")
                  %in% names(d)))
  out <- capture.output(print(d))
  expect_true(any(grepl("Mann-Whitney-Wilcoxon", out)))
  expect_true(any(grepl("Stage 1: enrol 169", out)))
  expect_true(any(grepl("Boundaries on the effect-size scale", out)))
})

test_that("op() names both hypotheses and reports MCSE for rejection", {
  d <- rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", criterion = 1)
  o <- op(d, nsim = 2000, seed = 1234)
  expect_s3_class(o, "OptOTrialsOC")
  expect_true(all(c("alpha", "se_alpha", "power", "se_power",
                    "EN0", "ENa", "EN", "table") %in% names(o)))
  expect_true(all(c("p_stop_futility", "p_stop_superiority", "p_continue")
                  %in% names(o$table)))
  expect_equal(nrow(o$table), 2)
  expect_equal(o$EN, 0.5 * (o$EN0 + o$ENa), tolerance = 1e-8)
})

test_that("printed OC table columns line up", {
  d <- rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", criterion = 1)
  out <- capture.output(print(op(d, nsim = 500, seed = 1)))
  i <- grep("^Scenario", out)
  expect_length(i, 1)
  expect_equal(nchar(out[i]), nchar(out[i + 1]))
  expect_equal(nchar(out[i]), nchar(out[i + 2]))
})
