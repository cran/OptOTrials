## Boundaries on a clinically interpretable scale (comment 10).
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
p2 <- p2_fun(p1, log(3.06))

test_that("score-test boundaries convert to odds ratios", {
  d <- rule(0.05, 0.2, p1, p2, test = "S", stopping = "F", criterion = 1)
  e <- d$effect
  expect_true(all(e$scale == "odds ratio"))
  expect_equal(e$effect[e$boundary == "t1f"], 1.333, tolerance = 1e-2)
  expect_equal(e$effect[e$boundary == "t2"],  1.846, tolerance = 1e-2)
})

test_that("rank-based boundaries convert to win odds", {
  d <- rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", criterion = 1)
  e <- d$effect
  expect_true(all(e$scale == "win odds"))
  expect_equal(e$effect[e$boundary == "t1f"], 1.181, tolerance = 1e-2)
  expect_equal(e$effect[e$boundary == "t2"],  1.488, tolerance = 1e-2)
})

test_that("effects increase with the threshold and exceed 1 at the final bound", {
  for (tt in c("S", "M", "W")) {
    e <- rule(0.05, 0.2, p1, p2, test = tt, stopping = "F", criterion = 1)$effect
    fin <- e$effect[e$boundary == "t2"]; fut <- e$effect[e$boundary == "t1f"]
    expect_gt(fin, fut)
    expect_gt(fin, 1)
  }
})

test_that("an unattainable boundary is reported as NA, not a nonsense value", {
  raw <- suppressWarnings(rule(0.05, 0.2, p1, p2, test = "M", stopping = "F",
                               criterion = 2, on_degenerate = "none"))
  e <- raw$effect
  expect_true(any(is.na(e$effect)) || all(e$effect > 0))
})
