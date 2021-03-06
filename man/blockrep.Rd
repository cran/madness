% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/blockrep.r
\name{blockrep}
\alias{blockrep}
\alias{repto}
\title{Replicate blocks of multidimensional value.}
\usage{
blockrep(x, nreps)

repto(x, newdim)

repto(x, newdim)
}
\arguments{
\item{x}{a \code{madness} object, representing a k-dimensional object.}

\item{nreps}{an l-vector of positive integers, representing how
many times to copy the object.}

\item{newdim}{an l-vector of positive integers of the new dimension
of the output object. These must be integer multiples of the 
input dimensions.}
}
\value{
A \code{madness} object replicated out.
}
\description{
Replicates a multidimensional object a number of times along
given dimensions.
}
\details{
Given a k-dimensional object, and an l-vector of positive
integers, for l >= k, copy the input object l_i times in
the ith dimension. Useful for replication and (slow, fake)
outer products.

\code{repto} replicates to the given dimension, assuming the
given dimension are integer multiples of the input dimensions.
}
\note{
An error will be thrown if \code{nreps} or \code{newdim} are improper.
}
\examples{
set.seed(123)
y <- array(rnorm(3*3),dim=c(3,3))
dy <- matrix(rnorm(length(y)*2),ncol=2)
dx <- crossprod(matrix(rnorm(ncol(dy)*100),nrow=100))
obj0 <- madness(val=y,vtag='y',xtag='x',dvdx=dy,varx=dx)

anobj <- blockrep(obj0,c(1,2,1))
anobj <- blockrep(obj0,c(1,1,2))
anobj <- repto(obj0,c(9,12,4))
}
\author{
Steven E. Pav \email{shabbychef@gmail.com}
}
