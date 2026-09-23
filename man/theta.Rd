\name{theta}
\alias{theta}
\title{Win probability for two ordered categorical distributions}
\description{
Computes the win probability
\eqn{\theta = \Pr(\eta < \xi) + 0.5\Pr(\eta = \xi)}, the expectation of the win
odds statistic, where \eqn{\xi} is a draw from the control distribution and
\eqn{\eta} a draw from the experimental distribution. Categories are ordered
from most to least desirable, so \eqn{\theta > 0.5} favours the experimental
treatment. The win odds are \eqn{\theta / (1 - \theta)}.
}
\usage{
theta(p1, p2)
}
\arguments{
  \item{p1}{A vector containing the probabilities of the outcome falling into
    each level for the control arm. It must be numeric, contain at least two
    categories and no missing or negative values, and sum to one within
    \code{1e-6}.}
  \item{p2}{A vector containing the probabilities of the outcome falling into
    each level for the experimental arm. It is validated as for \code{p1} and
    must have the same length.}
}
\value{
A single number, the win probability \eqn{\theta}.
}
\seealso{\code{\link{rule}} for designs based on the win odds test.}
\examples{
p1 <- c(1/3, 1/3, 1/3)
p2 <- c(1/2, 1/3, 1/6)

## Win probability and the corresponding win odds
th <- theta(p1, p2)
th
th / (1 - th)

## Under the null the two distributions coincide and theta is 0.5
theta(p1, p1)
}
