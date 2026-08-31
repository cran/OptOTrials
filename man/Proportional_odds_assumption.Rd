\name{Proportional_odds_assumption}
\alias{Proportional_odds_assumption}
\title{
Checking proportional odds assumption
}
\description{
This is the function to check the proportional odds assumption for the score test. 
}
\usage{
Proportional_odds_assumption(p1, p2, verbose = TRUE)
}
\arguments{
  \item{p1}{
A vector containing the probabilities of the outcome falling into each level of the
control arm.
}
  \item{p2}{
A vector containing the probabilities of the outcome falling into each level of the
experimental arm.
}
  \item{verbose}{
Logical. If \code{TRUE} (the default) an explanatory message is printed
stating whether the assumption holds and, if so, the implied common odds ratio.
}
}
\value{
Indicates whether the proportional odds assumption holds. If the assumption holds, the
function returns the log-odds ratio from the score test. If the assumption does not
hold, the function
returns \code{NA} and additionally emits a message and a warning explaining
that the score test is not advisable and suggesting the Mann-Whitney-Wilcoxon
or win odds test, so that the condition is not missed in scripted use.
}
