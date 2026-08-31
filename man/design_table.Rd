\name{design_table}
\alias{design_table}
\title{Table of designs and operating characteristics}
\description{
Builds a data frame of decision rules and simulated operating characteristics
over a set of tests and optimality criteria, replacing the
\code{expand.grid()} and \code{apply()} idiom that required positional
indexing of returned vectors. The random number generator is re-seeded for
every row, so each row is reproducible on its own.
}
\usage{
design_table(alpha, beta, p1, p2, tests, criteria,
             stopping = c("F", "FS"), lambda = 1, nsim = 10000,
             seed = 1234, on_degenerate = c("fallback", "warn", "error", "none"),
             digits = NULL)
}
\arguments{
  \item{alpha, beta, p1, p2, lambda}{As in \code{\link{rule}}.}
  \item{tests}{Character vector of tests, a subset of \code{c("S", "M", "W")}.}
  \item{criteria}{Numeric vector of optimality criteria, a subset of 1 to 5.}
  \item{stopping}{\code{"F"} or \code{"FS"}.}
  \item{nsim}{Number of simulation replicates per row.}
  \item{seed}{Seed applied before each scenario of each row.}
  \item{on_degenerate}{Passed to \code{\link{rule}}, with the same default,
    \code{"fallback"}: a degenerate optimum is replaced by the corresponding
    single-stage design and the substitution is reported. Set to
    \code{"none"} to report the raw optimum instead, in which case the
    \code{degenerate} column flags the affected rows and their operating
    characteristics are returned as \code{NA}, because a stage-1 total below
    two patients cannot be allocated to two arms and so cannot be simulated.
    That is the only case in which the operating characteristics are omitted;
    any other error from \code{\link{op}} is passed on.}
  \item{digits}{Optional number of digits for rounding the estimated
    probabilities. When supplied, EN0 and ENa are rounded to two decimals and
    EN is recomputed from the rounded values, so that a reader checking
    EN = (EN0 + ENa)/2 against the printed table reproduces the printed EN
    exactly. The default \code{NULL} returns full precision.}
}
\value{
A data frame with one row per (test, criterion) combination, containing the
decision rule, the estimated type I error rate and power with Monte Carlo
standard errors, the futility and superiority stopping probabilities under each
hypothesis, the expected sample sizes, and a \code{degenerate} flag.
}
\seealso{\code{\link{rule}}, \code{\link{op}}}
\examples{
p1 <- c(1/3, 1/3, 1/3)
p2 <- c(1/2, 1/3, 1/6)
design_table(0.05, 0.2, p1, p2, tests = "M", criteria = 1,
             stopping = "FS", nsim = 500)
}
