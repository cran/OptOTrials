\name{op.FS}
\alias{op.FS}
\title{
Performance evaluation of the FS design
}
\description{
This is the function to calculate the operating characteristics for the FS design, including type I error, power, and expected sample size.
}
\usage{
op.FS(alpha, beta, p1, p2, method, n1, t1l, t1u, n2, t2, nsim = 10000, lambda = 1)
}
\arguments{
  \item{alpha}{
Target type I error rate.
}
  \item{beta}{
Target type II error rate.
}
  \item{p1}{
A vector containing the probabilities of the outcome falling into each level of the control arm.
}
  \item{p2}{
A vector containging the probabilities of the outcome falling into each level of the control arm.
}
  \item{method}{
"S", "M" or "W", denotes score test, Mann-Whitney-Wilcoxon test and win odds test respectively. 
}
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
  \item{nsim}{
The number of simulations. nsim = 10000 by default
}
  \item{lambda}{
The ratio of sample sizes between the experimental and control groups, defined as sample size (experimental): sample size (control) = lambda:1. The default value is 1. 
}
}
\value{
The probability of wrong decision and the expected total sample size under the true hypothesis.  
}
\examples{
set.seed(1234)	
alpha = 0.05; beta = 0.2; 
p1 = c(0.2, 0.5, 0.2, 0.1)
p2 = c(0.4, 0.3, 0.2, 0.1)
alpha1 <- 0.2
alpha2 <- 0.025
beta1 <- 0.1
out <- Decision_rule_W.FS(p1, p2, alpha1, alpha2, beta1, alpha, beta, lambda = 1)

\donttest{
	# heavier example for illustration (skipped on CRAN timing checkes)
# report the power and EN_a
op.FS(alpha, beta, p1, p2, method="W", n1=out[1], t1l=out[2], 
	t1u=out[3], n2=out[4], t2=out[5], nsim = 10000, lambda = 1)
# report the overall type I error rate and EN_0
op.FS(alpha, beta, p1, p1, method="W", n1=out[1], t1l=out[2], 
	t1u=out[3], n2=out[4], t2=out[5], nsim = 10000, lambda = 1)
	}
}

