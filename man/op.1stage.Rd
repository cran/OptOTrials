\name{op.1stage}
\alias{op.1stage}
\title{
Performance evaluation of a one-stage design
}
\description{
This is the function to calculate the operating characteristics for a one-stage design,
including type I error, power, and expected sample size.
}
\usage{
op.1stage(alpha, beta, p1, p2, method, n2, t2, nsim = 10000, lambda = 1)
}
\arguments{
  \item{alpha}{
Target type I error rate.
}
  \item{beta}{
Target type II error rate.
}
  \item{p1}{
A vector containing the probabilities of the outcome falling into each level of the
control arm.
}
  \item{p2}{
A vector containing the probabilities of the outcome falling into each level of the
experimental arm.
}
  \item{method}{
"S", "M" or "W", denotes score test, Mann-Whitney-Wilcoxon test and wi
n odds test respectively. 
}
  \item{n2}{
                The cumulative total sample size of the control and experimental groups
required at the 2nd analysis.
}
  \item{t2}{
The threshold of the test statistic at the 2nd analysis.
}
  \item{nsim}{
The number of simulations. nsim = 10000 by default
}
  \item{lambda}{
The ratio of sample sizes between the experimental and control groups, defined as sample
size (experimental): sample size (control) = lambda:1. The default value is 1.
}
}
\value{
A numeric vector of length 2. The first element is the probability of
rejecting the null hypothesis: this is the type I error rate when the
simulation is run under the null (i.e. when \code{p2} is set equal to
\code{p1}) and the power when it is run under the alternative. The second
element is the corresponding expected total sample size. Note that this is a
rejection probability, not a probability of an incorrect decision.

For named, self-describing output that reports both hypotheses in a single
call together with Monte Carlo standard errors and separate futility and
superiority stopping probabilities, use \code{\link{op}} instead.
}
\note{
This function is deprecated as of \pkg{OptOTrials} 1.0.3 and will be removed
in version 1.1.0. It still returns exactly what it always returned, but it now
warns. Use \code{\link{op}} instead; \code{help("OptOTrials-deprecated")}
tabulates every replacement.
}

\examples{
set.seed(1234)
alpha = 0.05; beta = 0.2; 
p1 = c(0.2, 0.5, 0.2, 0.1)
p2 = c(0.4, 0.3, 0.2, 0.1)
out <- Decision_rule_W_1stage(p1, p2, alpha, beta, lambda = 1)
# report the power and EN_a
op.1stage(alpha, beta, p1, p2, method="W", n2=out[1], t2=out[2], nsim = 1000, lambda = 1)
# report the overall type I error rate and EN_0
op.1stage(alpha, beta, p1, p1, method="W", n2=out[1], t2=out[2], nsim = 1000, lambda = 1)
}
\keyword{internal}
