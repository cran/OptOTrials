\name{ruleF}
\alias{ruleF}
\title{
Decision rule of the F design 
}
\description{
This is the function to determine the decision rule for the F design.
}
\usage{
ruleF(alpha, beta, p1, p2, method, criterion, lambda = 1)
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
"S", "M" or "W", denotes score test, Mann-Whitney-Wilcoxon test and win odds test
respectively.
}
  \item{criterion}{
1: minimizing the expected total sample size under the null hypothesis, 2: minimizing
the expected total sample size under the alternative hypothesis, 3: minimizing the
expected total sample size assuming that Pr(H0) = Pr(Ha), 4: balancing sample sizes of
the two stages prioritizing EN0, 5: balancing sample sizes of the two stages
prioritizing maximum sample size n2.
}
  \item{lambda}{
The ratio of sample sizes between the experimental and control groups, defined as sample
size (experimental): sample size (control) = lambda:1. The default value is 1.
}
}
\value{
\item{method}{
		Statistical test chosen.
	}
	\item{criterion}{
		 Criterion chosen.
	}
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
ruleF(alpha, beta, p1, p2, method="M", criterion="1", lambda = 1)
}

\keyword{internal}
