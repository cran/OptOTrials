\name{W_W}
\alias{W_W}
\title{
Calculation of W
}
\description{
This is the function to compute W, which is required for the Win Odds test.
}
\usage{
W_W(p1, p2, lambda = 1)
}
\arguments{
    \item{p1}{
A vector containing the probabilities of the outcome falling into each level of the control arm.
}
  \item{p2}{
A vector containging the probabilities of the outcome falling into each level of the control arm.
}
  \item{lambda}{
The ratio of sample sizes between the experimental and control groups, defined as sample size (experimental): sample size (control) = lambda:1. The default value is 1. 
}
}
\value{
The value of W.
}
