\name{Decision_rule_W.FS}
\alias{Decision_rule_W.FS}
\title{
Decision rule of the FS design based on the Win Odds test with the specified values of alpha1, alpha2, and beta1
}
\description{
This is the function to determine the decision rule for the FS design based on the Win Odds test with the specified values of alpha1, alpha2, and beta1. 
}
\usage{
Decision_rule_W.FS(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1)
}
\arguments{
  \item{p1}{
A vector containing the probabilities of the outcome falling into each level of the control arm.
}
  \item{p2}{
A vector containging the probabilities of the outcome falling into each level of the control arm.
}
  \item{alpha1}{
The parameter used to define futility monitoring. Under the null hypothesis, 1 - alpha1 corresponds to the probability of stopping for futility at the interim analysis.
}
  \item{alpha2}{
The probability of stopping for superiority at the interim analysis when the null hypothesis is true.
}
  \item{beta1}{
The probability of stopping for futility at the interim analysis when the alternative hypothesis is true. 
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
	\item{n1}{
		The total sample size of the control and experimental groups required at the 1st analysis.
	}
	\item{t1l}{
		The lower threshold of the test statistic at the 1st analysis. 
	}
	\item{t1u}{
		The upper threshold of the test statistic at the 1st analysis.
	}
	\item{n2}{
		The cumulative total sample size of the control and experimental groups required at the 2nd analysis.
	}
	\item{t2}{
		The threshold of the test statistic at the 2nd analysis.
	}
	\item{beta2}{
		Under the null hypothesis, 1 - beta2 denotes the probability of stopping for superiority at the interim analysis.
	}
}
\examples{
alpha = 0.05; beta = 0.2; 
p1 = c(0.2, 0.5, 0.2, 0.1)
p2 = c(0.4, 0.3, 0.2, 0.1)
alpha1 <- 0.2
alpha2 <- 0.025
beta1 <- 0.1
Decision_rule_W.FS(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1)
}
