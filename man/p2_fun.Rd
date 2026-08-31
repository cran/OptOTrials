\name{p2_fun}
\alias{p2_fun}
\title{
p2
}
\description{
This is the function to calculate the probability p2 when p1 and odds ratio are given. 
}
\usage{
p2_fun(p1, theta)
}
\arguments{
  \item{p1}{
A vector containing the probabilities of the outcome falling into each level of the
control arm.
}
  \item{theta}{
The log odds ratio according to expected effect of the experimental treatment.
}
}
\value{
A numeric vector representing the expected probability distribution of outcomes across
levels for the experimental group.
}
