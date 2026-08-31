\name{op}
\alias{op}
\alias{print.OptOTrialsOC}
\title{Operating characteristics of a design}
\description{
Estimates the operating characteristics of a design produced by
\code{\link{rule}} by Monte Carlo simulation. Both hypotheses are evaluated in
a single call, and every returned quantity is named, so the meaning of the
output does not depend on how the function was called.
}
\usage{
op(design, nsim = 10000, seed = NULL, p1 = NULL, p2 = NULL,
   allow_degenerate = FALSE)
}
\arguments{
  \item{design}{An object returned by \code{\link{rule}}.}
  \item{nsim}{Number of simulation replicates (default 10000).}
  \item{seed}{Optional integer. If supplied, the random number generator is
    seeded immediately before each scenario, so the result is reproducible
    independently of the state of the stream when \code{op()} is reached.}
  \item{p1, p2}{Optional category probabilities overriding those stored in
    \code{design}, for evaluating a design under a scenario other than the one
    it was built for.}
  \item{allow_degenerate}{Logical. A degenerate two-stage optimum that has
    not been replaced by its single-stage substitute cannot be simulated
    meaningfully, because its stage-1 size is too small to allocate
    patients to both arms; such a design is refused by default. Set to
    \code{TRUE} to override the check.}
}
\value{
An object of class \code{"OptOTrialsOC"} containing \code{alpha} and
\code{power} with their Monte Carlo standard errors \code{se_alpha} and
\code{se_power}, the expected sample sizes \code{EN0}, \code{ENa} and
\code{EN}, and a data frame \code{table} reporting, under each hypothesis, the
rejection probability, the probability of stopping early for futility, the
probability of stopping early for superiority, the probability of continuing to
the second stage, and the expected sample size. Futility and superiority
stopping are reported separately rather than pooled.
}
\seealso{\code{\link{rule}}, \code{\link{design_table}}}
\examples{
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
p2 <- p2_fun(p1, log(3.06))
d <- rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", criterion = 1)
op(d, nsim = 1000, seed = 1234)
}
