## Unified operating-characteristic function.
## Added in 1.1.0. Replaces op.F / op.FS / op.1stage with a single entry point
## (Reviewer 3, "Code"), reports futility and superiority stopping separately
## (Reviewers 1 and 3), attaches Monte Carlo standard errors (Reviewer 1), and
## evaluates both hypotheses in one call so that the returned quantities can no
## longer be mislabelled (Reviewer 1).
##
## The simulation loop reproduces the draw sequence of op.F / op.FS / op.1stage
## exactly, so designs evaluated with op() return the same numbers as before.

.sim_core <- function(pc, pe, test, stopping, n1, t1f, t1s, n2, t2,
                      nsim, lambda) {
  out1 <- pts <- character(nsim)
  pts  <- numeric(nsim)
  J    <- length(pc)

  for (sim in seq_len(nsim)) {

    if (stopping == "none") {
      size.c <- ceiling(n2 / (lambda + 1))
      nc <- sample(1:J, size = size.c, replace = TRUE, prob = pc)
      group12 <- sum(nc == 1)
      for (j in 2:J) group12 <- c(group12, sum(nc == j))
      size.e <- n2 - size.c
      ne <- sample(1:J, size = size.e, replace = TRUE, prob = pe)
      group22 <- sum(ne == 1)
      for (j in 2:J) group22 <- c(group22, sum(ne == j))
      T1 <- NA_real_
    } else {
      size.c <- ceiling(n2 / (lambda + 1)); size.c.stg1 <- ceiling(n1 / (lambda + 1))
      nc <- sample(1:J, size = size.c, replace = TRUE, prob = pc)
      ncstg1 <- nc[sample(1:size.c, size = size.c.stg1, replace = FALSE)]
      group11 <- sum(ncstg1 == 1); group12 <- sum(nc == 1)
      for (j in 2:J) {
        group11 <- c(group11, sum(ncstg1 == j))
        group12 <- c(group12, sum(nc == j))
      }
      size.e <- n2 - size.c; size.e.stg1 <- n1 - size.c.stg1
      if (size.e == 0) size.e <- 1
      if (size.e.stg1 == 0) size.e.stg1 <- 1
      ne <- sample(1:J, size = size.e, replace = TRUE, prob = pe)
      nestg1 <- ne[sample(1:size.e, size = size.e.stg1, replace = FALSE)]
      group21 <- sum(nestg1 == 1); group22 <- sum(ne == 1)
      for (j in 2:J) {
        group21 <- c(group21, sum(nestg1 == j))
        group22 <- c(group22, sum(ne == j))
      }
    }

    if (test == "S") {
      if (stopping != "none") {
        L <- c(0, cumsum(group11[-J])); U <- c(rev(cumsum(rev(group11[-1]))), 0)
        T1 <- sum(group21 * (U - L)) / (sum(group11) + sum(group21))
      }
      L <- c(0, cumsum(group12[-J])); U <- c(rev(cumsum(rev(group12[-1]))), 0)
      T2 <- sum(group22 * (U - L)) / (sum(group12) + sum(group22))
    }
    if (test == "M") {
      if (stopping != "none") {
        num <- sum(group11[-1] * cumsum(group21[-J])) - sum(group21[-1] * cumsum(group11[-J]))
        T1  <- num / (sum(group11) * sum(group21))
      }
      num <- sum(group12[-1] * cumsum(group22[-J])) - sum(group22[-1] * cumsum(group12[-J]))
      T2  <- num / (sum(group12) * sum(group22))
    }
    if (test == "W") {
      if (stopping != "none") {
        count <- sum(outer(nestg1, ncstg1,
                     function(x, y) ifelse(x < y, 1, ifelse(x == y, 0.5, 0))))
        T1 <- count / (sum(group11) * sum(group21))
      }
      count <- sum(outer(ne, nc,
                   function(x, y) ifelse(x < y, 1, ifelse(x == y, 0.5, 0))))
      T2 <- count / (sum(group12) * sum(group22))
    }

    if (stopping == "none") {
      out1[sim] <- if (T2 > t2) "Reject all" else "Fail stage 2"
      pts[sim]  <- n2
    } else if (stopping == "F") {
      if (T1 <= t1f) { out1[sim] <- "Early Stop for futility"; pts[sim] <- n1 }
      else {
        out1[sim] <- if (T2 > t2) "Reject all" else "Fail stage 2"
        pts[sim]  <- n2
      }
    } else {
      ## Same exhaustive rule as op.FS(); T1 == t1s continues to stage 2.
      if (T1 <= t1f) { out1[sim] <- "Early Stop for futility";    pts[sim] <- n1 }
      else if (T1 > t1s) { out1[sim] <- "Early Stop for superiority"; pts[sim] <- n1 }
      else {
        out1[sim] <- if (T2 > t2) "Reject all" else "Fail stage 2"
        pts[sim]  <- n2
      }
    }
  }

  p_fut <- mean(out1 == "Early Stop for futility")
  p_sup <- mean(out1 == "Early Stop for superiority")
  reject <- mean(out1 == "Reject all" | out1 == "Early Stop for superiority")
  list(reject = reject, se_reject = sqrt(reject * (1 - reject) / nsim),
       p_stop_futility = p_fut, p_stop_superiority = p_sup,
       p_continue = 1 - p_fut - p_sup, EN = mean(pts))
}

op <- function(design, nsim = 10000, seed = NULL, p1 = NULL, p2 = NULL, allow_degenerate = FALSE) {

  if (!inherits(design, "OptOTrialsRule"))
    stop("`design` must be an object returned by rule().", call. = FALSE)
  if (!is.numeric(nsim) || length(nsim) != 1L || nsim < 1)
    stop("`nsim` must be a single positive integer.", call. = FALSE)
  nsim <- as.integer(nsim)

  ## A degenerate two-stage optimum that has not been substituted cannot be
  ## simulated honestly: with n1 = 1 the stage-1 allocation cannot put one
  ## patient in each arm, and the simulation would silently enrol two while
  ## the design still reports n1 = 1.  Refuse it unless the user insists.
  if (isTRUE(design$degenerate) && !isTRUE(design$substituted) &&
      !isTRUE(allow_degenerate))
    stop("This design is a degenerate two-stage optimum (",
         design$degenerate_reason, "), and its operating characteristics ",
         "cannot be simulated meaningfully: the stage-1 size is too small to ",
         "allocate patients to both arms. Use rule(..., on_degenerate = ",
         "\"fallback\") to obtain the single-stage design, or ",
         "op(..., allow_degenerate = TRUE) to override this check.",
         call. = FALSE)

  if (is.null(p1)) p1 <- design$p1
  if (is.null(p2)) p2 <- design$p2
  .validate_probs(p1, p2)

  args <- list(test = design$test, stopping = design$stopping,
               n1 = design$n1, t1f = design$t1f, t1s = design$t1s,
               n2 = design$n2, t2 = design$t2,
               nsim = nsim, lambda = design$lambda)

  ## Seeding each scenario separately makes every call reproducible on its own,
  ## rather than depending on the state of the stream when it was reached.
  ## This is what the referee report and the editor asked for.
  if (!is.null(seed)) set.seed(seed)
  null_res <- do.call(.sim_core, c(list(pc = p1, pe = p1), args))
  if (!is.null(seed)) set.seed(seed)
  alt_res  <- do.call(.sim_core, c(list(pc = p1, pe = p2), args))

  tab <- data.frame(
    hypothesis         = c("H0", "Ha"),
    reject             = c(null_res$reject, alt_res$reject),
    se_reject          = c(null_res$se_reject, alt_res$se_reject),
    p_stop_futility    = c(null_res$p_stop_futility, alt_res$p_stop_futility),
    p_stop_superiority = c(null_res$p_stop_superiority, alt_res$p_stop_superiority),
    p_continue         = c(null_res$p_continue, alt_res$p_continue),
    EN                 = c(null_res$EN, alt_res$EN),
    stringsAsFactors = FALSE)

  structure(list(
    design = design, nsim = nsim, seed = seed, table = tab,
    alpha = null_res$reject, se_alpha = null_res$se_reject,
    power = alt_res$reject,  se_power = alt_res$se_reject,
    EN0 = null_res$EN, ENa = alt_res$EN,
    EN  = 0.5 * (null_res$EN + alt_res$EN)),
    class = "OptOTrialsOC")
}
