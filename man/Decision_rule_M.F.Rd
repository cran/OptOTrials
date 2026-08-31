\name{Decision_rule_M.F}
\alias{Decision_rule_M.F}
\title{
Decision rule for the F design based on the Mann-Whitney-Wilcoxon test with specified
values of alpha1 and beta1
}
\description{
This is to determine the decision rule for a two-stage design based on the
Mann-Whitney-Wilcoxon test with the specified values of alpha1 and beta1.
}
\usage{
Decision_rule_M.F(p1, p2, alpha1, beta1, alpha, beta, lambda = 1)
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
  \item{alpha1}{
The parameter used to define futility monitoring. Under the null hypothesis, 1 - alpha1
corresponds to the probability of stopping for futility at the interim analysis.
}
  \item{beta1}{
The probability of stopping for futility at the interim analysis when the alternative
hypothesis is true.
}
  \item{alpha}{
Target type I error rate.
}
  \item{beta}{
Target type II error rate.
}
  \item{lambda}{
The ratio of sample sizes between the experimental and control groups, defined as sample
size (experimental): sample size (control) = lambda:1. The default value is 1.
}
}
\value{
	\item{n1}{
                The total sample size of the control and experimental groups required at
the 1st analysis.
	}
	\item{t1}{
		The threshold of the test statistic at the 1st analysis. 
	}
	\item{n2}{
                The cumulative total sample size of the control and experimental groups
required at the 2nd analysis.
	}
	\item{t2}{
		The threshold of the test statistic at the 2nd analysis.
	}
}
\references{
Park, Y. (2025). Optimal two-stage group sequential designs based on
Mann-Whitney-Wilcoxon test. PloS one, 20(2), e0318211.
}
\note{
This function is deprecated as of \pkg{OptOTrials} 1.0.3 and will be removed
in version 1.1.0. It still returns exactly what it always returned, but it now
warns. Use \code{\link{rule}} instead; \code{help("OptOTrials-deprecated")}
tabulates every replacement.
}

\examples{
alpha = 0.05; beta = 0.2; 
p1 = c(0.2, 0.5, 0.2, 0.1)
p2 = c(0.4, 0.3, 0.2, 0.1)
alpha1 <- 0.2
beta1 <- 0.1
Decision_rule_M.F(p1, p2, alpha1, beta1, alpha, beta, lambda = 1)
}

\keyword{internal}
