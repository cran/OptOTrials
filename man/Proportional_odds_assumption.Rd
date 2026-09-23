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
 Validated as for \code{\link{rule}}: numeric, equal length, at least two
    categories, no missing or negative values, and summing to one within
    \code{1e-6}.}
\value{
Indicates whether the proportional odds assumption holds. If the assumption holds, the
function returns the log-odds ratio from the score test. If the assumption does not
hold, the function
returns \code{NA} and additionally emits a message and a warning explaining
that the score test is not advisable and suggesting the Mann-Whitney-Wilcoxon
or win odds test, so that the condition is not missed in scripted use.
}
\examples{
## The assumption holds when p2 is built from p1 by a common odds ratio
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
p2 <- p2_fun(p1, log(3.06))
Proportional_odds_assumption(p1, p2)

## and fails otherwise, with a message and a warning rather than a bare NA
q1 <- c(1/3, 1/3, 1/3)
q2 <- c(1/2, 1/3, 1/6)
try(Proportional_odds_assumption(q1, q2))
}
