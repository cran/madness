% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/theta.r
\name{theta}
\alias{theta}
\title{Estimate the symmetric second moment array of values.}
\usage{
theta(X, vcov.func=vcov, xtag=NULL)
}
\arguments{
\item{X}{a multidimensional array (or a data frame) of observed values.}

\item{vcov.func}{a function which takes an object of class \code{lm},
and computes a variance-covariance matrix. If equal to the string
"normal", we assume multivariate normal returns.}

\item{xtag}{an optional string tag giving the name of the input data.
defaults to figuring it out from the input expression.}
}
\value{
A \code{madness} object representing the mean of the outer
product of the tail dimensions of \code{X}.
}
\description{
Given rows of observations of some vector (or multidimensional
data), estimates the second moment by taking a simple mean,
returning a \code{madness} object.
}
\details{
Given a 
\eqn{n\times k_1 \times k_2 \times ... \times k_l}{n x k_1 x k_2 ... x k_l}
array whose 'rows' are independent observations of \eqn{X}{X}, computes the 
\eqn{k_1 \times k_2 \times ... \times k_l \times k_1 \times k_2 ... k_l}{k_1 x k_2 x ... x k_l x k_1 x k_2 ... k_l}
array of the mean of \eqn{\mathrm{outer}(X,X)}{outer(X,X)} based on \eqn{n}{n} observations,
returned as a \code{\link{madness}} object. The variance-covariance
is also estimated, and stored in the object.

One may use the default method for computing covariance,
via the \code{\link{vcov}} function, or via a 'fancy' estimator,
like \code{sandwich:vcovHAC}, \code{sandwich:vcovHC}, \emph{etc.}
}
\examples{
set.seed(123)
X <- matrix(rnorm(1000*3),ncol=3)
th <- theta(X)

\dontrun{
if (require(sandwich)) {
 th2 <- theta(X,vcov.func=vcovHC)
}
}
# works on data frames too:
set.seed(456)
X <- data.frame(a=runif(100),b=rnorm(100),c=1)
th <- theta(X)
}
\seealso{
\code{\link{twomoments}}
}
\author{
Steven E. Pav \email{shabbychef@gmail.com}
}
