\name{rule}
\alias{rule}
\alias{print.OptOTrialsRule}
\title{Optimal design for a trial with an ordered categorical outcome}
\description{
Constructs the decision rule for a one- or two-stage randomised trial with an
ordered categorical outcome. This is the recommended entry point to the
package: the test statistic and the monitoring scheme are selected by argument,
so a single function replaces the eleven separate decision-rule functions
provided up to version 1.0.2.
}
\usage{
rule(alpha, beta, p1, p2, test = c("S", "M", "W"),
     stopping = c("F", "FS", "none"), criterion = 1, lambda = 1,
     on_degenerate = c("fallback", "warn", "error", "none"), min_n1 = 10)
}
\arguments{
  \item{alpha}{Target type I error rate.}
  \item{beta}{Target type II error rate; power is \code{1 - beta}.}
  \item{p1}{Numeric vector of outcome category probabilities for the control
    group. Must be non-negative and sum to 1.}
  \item{p2}{Numeric vector of outcome category probabilities for the
    experimental group. Must be the same length as \code{p1}, non-negative,
    and sum to 1.}
  \item{test}{Test statistic: \code{"S"} the score test under the proportional
    odds model, \code{"M"} the Mann-Whitney-Wilcoxon test, \code{"W"} the win
    odds test.}
  \item{stopping}{Monitoring scheme: \code{"F"} allows early stopping for
    futility only, \code{"FS"} for futility and superiority, \code{"none"}
    gives a single-stage design.}
  \item{criterion}{Optimality criterion, 1 to 5. 1: minimise the expected total
    sample size under the null; 2: under the alternative; 3: assuming
    \code{Pr(H0) = Pr(Ha)}; 4: balance the two stages prioritising EN0;
    5: balance the two stages prioritising the maximum sample size. Ignored
    when \code{stopping = "none"}.}
  \item{lambda}{Ratio of experimental to control sample sizes (default 1).}
  \item{on_degenerate}{How to handle a degenerate optimum (see Details).
    \code{"fallback"} (default) warns and returns the single-stage design;
    \code{"warn"} warns and returns the degenerate design; \code{"error"}
    raises an error; \code{"none"} returns the raw optimum silently.}
  \item{min_n1}{Smallest stage-1 sample size regarded as usable when detecting
    degeneracy (default 10).}
}
\details{
Minimising the expected sample size under the alternative (\code{criterion = 2})
can drive the optimum to a design with a stage-1 sample size of 1 and an
interim boundary so far into the lower tail that the interim analysis cannot
change any decision: the design is then two-stage in name only. Intuitively,
the criterion rewards designs under which continuation to the final analysis is
almost certain when the treatment works, so the optimiser commits essentially
all information to the final analysis. \code{rule()} detects this and, by
default, substitutes the corresponding single-stage design, recording the
substitution in the returned object rather than making it silently.
}
\value{
An object of class \code{"OptOTrialsRule"}: a list with components \code{test},
\code{stopping}, \code{criterion}, \code{alpha}, \code{beta}, \code{lambda},
\code{p1}, \code{p2}, the stage-1 size \code{n1}, the interim futility and
superiority boundaries \code{t1f} and \code{t1s}, the maximum size \code{n2},
the final boundary \code{t2}, a data frame \code{effect} giving each boundary
on a clinically interpretable effect-size scale (odds ratio for the score test,
win odds for the rank-based tests), and the flags \code{degenerate},
\code{degenerate_reason} and \code{substituted}. A \code{print} method displays
these with labels.
}
\note{
The name \code{rule} is also used by the \pkg{cli} package, which \pkg{MAMS}
and several other packages attach. If \pkg{cli} is attached after
\pkg{OptOTrials}, \code{cli::rule} masks this function for the rest of the
session. Attach \pkg{OptOTrials} last, or call \code{OptOTrials::rule()}
explicitly.
}
\seealso{\code{\link{op}}, \code{\link{design_table}}}
\examples{
p1 <- c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166)
p2 <- p2_fun(p1, log(3.06))
rule(0.05, 0.2, p1, p2, test = "M", stopping = "F", criterion = 1)
}
