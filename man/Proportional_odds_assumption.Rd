\name{Proportional_odds_assumption}
\alias{Proportional_odds_assumption}
\title{
Checking proportional odds assumption
}
\description{
This is the function to check the proportional odds assumption for the score test. 
}
\usage{
Proportional_odds_assumption(p1, p2)
}
\arguments{
  \item{p1}{
A vector containing the probabilities of the outcome falling into each level of the control arm.
}
  \item{p2}{
A vector containging the probabilities of the outcome falling into each level of the control arm.
}
}
\value{
Indicates whether the proportional odds assumption holds. If the assumption holds, the function returns the log-odds ratio from the score test. If the assumption does not hold, the function returns NA.
}
