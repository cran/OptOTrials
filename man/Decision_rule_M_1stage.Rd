\name{Decision_rule_M_1stage}
\alias{Decision_rule_M_1stage}
\title{
One-stage clinical trial design based on the Mann-Whitney-Wilcoxon test 
}
\description{
This is the function to determine the decision rule for a one-stage clinical trial designs based on the Mann-Whitney-Wilcoxon test.
}
\usage{
Decision_rule_M_1stage(p1, p2, alpha, beta, lambda = 1)
}
\arguments{
  \item{p1}{
A vector containing the probabilities of the outcome falling into each level of the control arm.
}
  \item{p2}{
A vector containging the probabilities of the outcome falling into each level of the control arm.
}
  \item{alpha}{
Target type I error rate.
}
  \item{beta}{
Target type II error rate.
}
  \item{lambda}{
The ratio of sample sizes between the experimental and control groups, defined as sample size (experimental): sample size (control) = lambda:1. The default value is 1. 
}
}
\value{
\item{n2}{
	The total sample size at the final analysis including both the control and experimental groups. 
}
\item{t2}{
	The threshold of the test statistic at the analysis.
}
}
\references{
Park, Y. (2025). Optimal two-stage group sequential designs based on Mann-Whitney-Wilcoxon test. PloS one, 20(2), e0318211. 
}
\examples{
alpha = 0.05; beta = 0.2; 
p1 = c(0.2, 0.5, 0.2, 0.1)
p2 = c(0.4, 0.3, 0.2, 0.1)
Decision_rule_M_1stage(p1, p2, alpha, beta, lambda = 1)
}
