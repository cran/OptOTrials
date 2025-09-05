\name{V_S.over.nk}
\alias{V_S.over.nk}
\title{
Calcualtion of V
}
\description{
This is the function to compute the value of V over \eqn{n_{..k}}, which is requited for the score test, where \eqn{n_{..k}} denotes the total sample size at the kth analysis. 
}
\usage{
V_S.over.nk(p1, p2, lambda = 1)
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
The value of V over \eqn{n_{..k}}. 
}
