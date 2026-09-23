\name{OptOTrials-package}
\alias{OptOTrials-package}
\alias{OptOTrials}
\docType{package}
\title{
\packageTitle{OptOTrials}
}
\description{
\packageDescription{OptOTrials}
}
\details{
The workflow runs through two functions. \code{\link{rule}} constructs a
decision rule: the test statistic, the monitoring scheme and the optimality
criterion are chosen by argument, and the result is a named object with a
\code{print} method. \code{\link{op}} takes that object and estimates the
operating characteristics by simulation, reporting the type I error rate,
the power, the interim stopping probabilities and the expected sample size
under both hypotheses in a single call.

\code{\link{design_table}} sweeps a set of tests and criteria and returns a
data frame with one row per design. \code{\link{Proportional_odds_assumption}}
checks whether the score test is appropriate, \code{\link{p2_fun}} constructs
the experimental-group probabilities from a specified odds ratio, and
\code{\link{theta}} returns the win probability.

For advanced calculations, \code{\link{V_S.over.nk}}, \code{\link{QR_fun}},
and \code{\link{W_W}} evaluate the asymptotic variance quantities for the
score, Mann--Whitney--Wilcoxon, and win odds statistics, respectively. These
helpers reproduce the Appendix calculations in the accompanying article and
permit boundary calculations at a prespecified sample size.

Versions up to 1.0.2 provided a separate function for each combination of test
and stopping rule. Those functions were deprecated in 1.0.3 and removed in
1.1.0; \code{NEWS.md} and the vignette tabulate the correspondence.
}
\author{
\packageAuthor{OptOTrials}

Maintainer: \packageMaintainer{OptOTrials}
}
\references{
Park, Y. (2025). Optimal two-stage group sequential designs based on
Mann-Whitney-Wilcoxon test. PloS one, 20(2), e0318211.
}
%\keyword{Adaptive design, Mann-Whitney-Wilcoxon test, score test, sample size, win odds test}

%% Uncomment below to imitate parts of library(help = OptOTrials)
%\section{The \file{DESCRIPTION} File}{\packageDESCRIPTION{OptOTrials}}
%\section{Documentation Index}{\packageIndices{OptOTrials}}

