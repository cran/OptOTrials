Proportional_odds_assumption <-
function(p1, p2, verbose = TRUE){

  .validate_probs(p1, p2)

  theta_S <- .po_logor(p1, p2)

  ## Previously this returned a bare NA when the assumption failed, leaving the
  ## user to test for it and compose their own message. It now explains itself
  ## and warns, so the condition cannot pass unnoticed in scripted use
  ## (Reviewers 1 and 3).
  if (is.na(theta_S)) {
    if (verbose)
      message("The proportional odds assumption does not hold for the supplied ",
              "probabilities. It is not advisable to use the score test; ",
              "consider the Mann-Whitney-Wilcoxon test (\"M\") or the win odds ",
              "test (\"W\").")
    warning("Proportional odds assumption does not hold; returning NA.",
            call. = FALSE)
    return(NA_real_)
  }

  if (verbose)
    message(sprintf(paste0("The proportional odds assumption holds. ",
                           "Common log odds ratio = %.5f (odds ratio = %.4f); ",
                           "the score test is appropriate."),
                    theta_S, exp(theta_S)))
  theta_S
}
