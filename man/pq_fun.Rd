\name{pq_fun}
\alias{pq_fun}
\title{
Calculation of pq
}
\description{
This is the function to compute \eqn{p_{jk}} and \eqn{q_{ik}}, which are required for
the Win Odds test.
}
\usage{
pq_fun(p1, p2)
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
}
\value{
The value of  \eqn{p_{jk}} and \eqn{q_{ik}}.
}
\keyword{internal}
