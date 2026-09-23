\name{QR_fun}
\alias{QR_fun}
\title{Variance component of the Mann-Whitney-Wilcoxon statistic}
\description{
Returns the quantity \eqn{Q} (equivalently \eqn{R}, by symmetry of the
arguments) appearing in the asymptotic variance of the Mann-Whitney-Wilcoxon
statistic, \eqn{\mathrm{Var}(T_k^{(M)}) \approx Q/n_{1 \cdot k} + R/n_{2 \cdot k}}.
}
\usage{
QR_fun(p1, p2)
}
\arguments{
  \item{p1}{A vector of outcome-category probabilities for the control arm.}
  \item{p2}{A vector of outcome-category probabilities for the experimental
    arm; supply \code{p1} twice for the null value.}
}
\value{A single number.}
\seealso{\code{\link{V_S.over.nk}}, \code{\link{W_W}}.}
\examples{
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
lambda <- 1

## Null variance of the statistic at a total size of 28, and the threshold it
## implies for a nominal one-sided level of 0.05
v <- ((1 + lambda) * QR_fun(p1, p1) + (1 + 1/lambda) * QR_fun(p1, p1)) / 28
qnorm(0.05, lower.tail = FALSE) * sqrt(v)
}
