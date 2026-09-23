\name{V_S.over.nk}
\alias{V_S.over.nk}
\title{Variance factor of the score statistic}
\description{
Returns the asymptotic variance of the score test statistic per patient, that
is \eqn{\mathrm{Var}(T_k^{(S)}) / n_{\cdot\cdot k}}, under the proportional
odds model. Because the factor does not depend on the sample size, the variance
at any total size \eqn{n} is obtained by multiplying by \eqn{n}, which is what
makes the sample-size equations solvable in closed form.
}
\usage{
V_S.over.nk(p1, p2, lambda = 1)
}
\arguments{
  \item{p1}{A vector of outcome-category probabilities for the control arm.}
  \item{p2}{A vector of outcome-category probabilities for the experimental
    arm; supply \code{p1} twice for the null value.}
  \item{lambda}{A finite positive allocation ratio, experimental to control
    (default 1).}
}
\value{A single number, the variance per patient.}
\seealso{\code{\link{QR_fun}} and \code{\link{W_W}} for the rank-based tests.}
\examples{
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
p2 <- p2_fun(p1, log(3.06))

## Null variance factor, and the threshold a fixed total size n implies for a
## nominal one-sided level of 0.05
v <- V_S.over.nk(p1, p1)
qnorm(0.05, lower.tail = FALSE) * sqrt(v * 28)

## Under the alternative the factor differs
V_S.over.nk(p1, p2)
}
