## Seeding (comment 8) and behaviour-preserving refactoring (comment 45).
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
p2 <- p2_fun(p1, log(3.06))

test_that("op() is reproducible from its seed and independent of call order", {
  d <- rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", criterion = 1)
  a <- op(d, nsim = 2000, seed = 1234)
  invisible(runif(1000))                       # disturb the RNG stream
  b <- op(d, nsim = 2000, seed = 1234)
  expect_equal(a$alpha, b$alpha)
  expect_equal(a$power, b$power)
  expect_equal(a$EN0, b$EN0)
})

test_that("every row of design_table() is reproducible, not only the first", {
  f <- function() design_table(0.05, 0.2, p1, p2, tests = "M", criteria = 1:3,
                               stopping = "F", nsim = 1000, seed = 1234,
                               on_degenerate = "none")
  x <- suppressWarnings(f()); invisible(runif(500)); y <- suppressWarnings(f())
  expect_equal(x$alpha, y$alpha)
  expect_equal(x$power, y$power)
  expect_equal(x$EN0, y$EN0)
})

test_that("rule() reproduces the legacy design functions exactly", {
  for (tt in c("S", "M", "W")) for (cr in 1:5) {
    new <- suppressWarnings(rule(0.05, 0.2, p1, p2, test = tt, stopping = "F",
                                 criterion = cr, on_degenerate = "none"))
    old <- OptOTrials:::.ruleF(0.05, 0.2, p1, p2, tt, as.character(cr), 1)
    expect_equal(new$n1,  as.numeric(old[3]), info = paste(tt, cr))
    expect_equal(new$t1f, as.numeric(old[4]), info = paste(tt, cr))
    expect_equal(new$n2,  as.numeric(old[5]), info = paste(tt, cr))
    expect_equal(new$t2,  as.numeric(old[6]), info = paste(tt, cr))
  }
})

test_that("the single-stage path matches the legacy 1-stage functions", {
  for (tt in c("S", "M", "W")) {
    new <- rule(0.05, 0.2, p1, p2, test = tt, stopping = "none")
    old <- get(paste0(".Decision_rule_", tt, "_1stage"), envir = asNamespace("OptOTrials"))(p1, p2, 0.05, 0.2, 1)
    expect_equal(new$n2, ceiling(old[1]), info = tt)
    expect_equal(new$t2, round(old[2], 3), info = tt)
  }
})
