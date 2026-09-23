\name{W_W}
\alias{W_W}
\title{Variance factor of the win odds statistic}
\description{
Returns the variance factor \eqn{W_k^{(W)}} of the win odds statistic, so that
its asymptotic variance at total size \eqn{n} is \eqn{W_k^{(W)}/n}.
}
\usage{
W_W(p1, p2, lambda = 1)
}
\arguments{
  \item{p1}{A vector of outcome-category probabilities for the control arm.}
  \item{p2}{A vector of outcome-category probabilities for the experimental
    arm; supply \code{p1} twice for the null value.}
  \item{lambda}{A finite positive allocation ratio, experimental to control
    (default 1).}
}
\value{A single number.}
\seealso{\code{\link{theta}} for the win probability itself,
  \code{\link{V_S.over.nk}} and \code{\link{QR_fun}} for the other tests.}
\examples{
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)

## The win odds statistic is centred at 0.5 under the null; the threshold at a
## total size of 28 for a nominal one-sided level of 0.05 is
0.5 + qnorm(0.05, lower.tail = FALSE) * sqrt(W_W(p1, p1) / 28)
}
