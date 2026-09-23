\name{p2_fun}
\alias{p2_fun}
\title{Experimental-group probabilities from a specified odds ratio}
\description{
Constructs the category probabilities for the experimental arm from those of
the control arm and a specified log odds ratio, under the proportional odds
model. It is a convenience for setting up an alternative hypothesis in terms of
a clinically meaningful effect size rather than by writing out a second
probability vector.
}
\usage{
p2_fun(p1, theta)
}
\arguments{
  \item{p1}{A vector containing the probabilities of the outcome falling into
    each level for the control arm. Validated on every call: numeric, at least two categories, no missing or
    negative values, and summing to one within \code{1e-6}.}
  \item{theta}{The log odds ratio representing the expected effect of the
    experimental treatment. A single finite number.}
}
\value{
A numeric vector of the same length as \code{p1}, giving the probability of
each outcome level for the \emph{experimental} arm.
}
\seealso{\code{\link{Proportional_odds_assumption}} to check that a pair of
vectors is consistent with a common odds ratio.}
\examples{
## Example 1 of the article: six ordered categories, odds ratio 3.06
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
p2 <- p2_fun(p1, log(3.06))
p2
sum(p2)

## The construction is consistent by definition, so the diagnostic recovers
## the odds ratio it was given
exp(Proportional_odds_assumption(p1, p2, verbose = FALSE))
}
