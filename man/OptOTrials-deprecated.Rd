\name{OptOTrials-deprecated}
\alias{OptOTrials-deprecated}
\title{Functions deprecated in OptOTrials 1.0.3}
\description{
Version 1.0.3 introduces \code{\link{rule}} and \code{\link{op}}, which replace
the separate function provided for each combination of test statistic and
stopping rule. The earlier functions still work and still return exactly what
they always returned, but they warn, and they will be removed in version 1.1.0.
}
\details{
\tabular{ll}{
  \strong{Deprecated} \tab \strong{Replacement} \cr
  \code{ruleF}, \code{ruleFS} \tab \code{rule(..., stopping = "F"/"FS")} \cr
  \code{Decision_rule_\{S,M,W\}.F} \tab \code{rule(..., test = ..., stopping = "F")} \cr
  \code{Decision_rule_\{S,M,W\}.FS} \tab \code{rule(..., test = ..., stopping = "FS")} \cr
  \code{Decision_rule_\{S,M,W\}_1stage} \tab \code{rule(..., test = ..., stopping = "none")} \cr
  \code{op.F}, \code{op.FS}, \code{op.1stage} \tab \code{op(design, nsim, seed)} \cr
}
}
\seealso{\code{\link{rule}}, \code{\link{op}}, \code{\link{design_table}}}
\keyword{internal}
