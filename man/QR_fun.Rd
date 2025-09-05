\name{QR_fun}
\alias{QR_fun}
\title{
Calculateion of Q or R
}
\description{
This is the function to compute Q or R, which is required for the Mann-Whitney-Wilcoxon test.
}
\usage{
QR_fun(p1, p2)
}
\arguments{
  \item{p1}{
A vector containing the probabilities of the outcome falling into each level of the control arm.
}
  \item{p2}{
A vector containging the probabilities of the outcome falling into each level of the control arm.
}
}
\value{
The value of Q or R.
}
