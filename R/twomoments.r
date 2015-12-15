# /usr/bin/r
#
# Copyright 2015-2015 Steven E. Pav. All Rights Reserved.
# Author: Steven E. Pav
#
# This file is part of madness.
#
# madness is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# madness is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with madness.  If not, see <http://www.gnu.org/licenses/>.
#
# Created: 2015.12.11
# Copyright: Steven E. Pav, 2015
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

#' @include AllClass.r
#' @include utils.r
NULL

#' @title Estimate the mean and covariance of values.
#'
#' @description 
#'
#' Given rows of observations of some vector (or multidimensional
#' data), estimates the mean and covariance of the values,
#' returning two \code{madness} objects. These have a common covariance
#' and 'xtag', so can be combined together.
#'
#' @details
#'
#' Given a 
#' \eqn{n\times k_1 \times k_2 \times ... \times k_l}{n x k_1 x k_2 ... x k_l}
#' array whose 'rows' are independent observations of \eqn{X}{X}, computes the 
#' \eqn{k_1 \times k_2 \times ... \times k_l}{k_1 x k_2 x ... x k_l}
#' array of the mean of \eqn{X}{X} and the 
#' \eqn{k_1 \times k_2 \times ... \times k_l \times k_1 \times k_2 ... k_l}{k_1 x k_2 x ... x k_l x k_1 x k_2 ... k_l}
#' array of the covariance, based on \eqn{n}{n} observations,
#' returned as two \code{\link{madness}} objects. The variance-covariance
#' of each is estimated. The two objects have the same 'xtag', and so
#' may be combined together.
#'
#' One may use the default method for computing covariance,
#' via the \code{\link{vcov}} function, or via a 'fancy' estimator,
#' like \code{sandwich:vcovHAC}, \code{sandwich:vcovHC}, \emph{etc.}
#'
#' @usage
#'
#' twomoments(X, vcov.func=vcov, xtag=NULL, df=NULL)
#'
#' @inheritParams theta
#' @param df the number of degrees of freedom to subtract
#' from the sample size in the denominator of the covariance
#' matrix estimate. The default value is the number of elements in
#' the mean, the so-called Bessel's correction.
#' @return A two element list. The first is the 'mu', representing the mean,
#' a \code{madness} object, the second is 'Sigma', representing the covariance,
#' also a \code{madness} object.
#' @template etc
#' @seealso \code{\link{theta}}
#' @examples 
#' set.seed(123)
#' X <- matrix(rnorm(1000*8),ncol=8)
#' alst <- twomoments(X)
#' markowitz <- solve(alst$Sigma,alst$mu)
#' vcov(markowitz)
#'
#' @export
#' @rdname twomoments
twomoments <- function(X,vcov.func=vcov,xtag=NULL, df=NULL) {
	if (missing(xtag)) {
		xtag <- deparse(substitute(X))
	}
	X <- na.omit(X)
	if (is.data.frame(X)) {
		X <- as.matrix(X)
	}
	dimX <- dim(X)
	n <- dimX[1]
	p <- prod(dimX[2:length(dimX)])
	dim(X) <- c(n,p)
	X <- cbind(1,X)
	# delegate
	tht <- theta(X,vcov.func=vcov.func,xtag=xtag)
	# interpret
	mu <- tht[1 + (1:p),1]
	# 2FIX: allow df instead of always chosing p here.
	if (missing(df)) { df <- p }
	Sigma <- (n/(n-df)) * (tht[1 + (1:p),1 + (1:p)] - mu %*% t(mu))
	
	if (length(dimX) <= 2) {
		# not entirely necessary, I think:
		dim(mu) <- c(p,1)
		dim(Sigma) <- c(p,p)
	} else {
		dim(mu) <- dimX[2:length(dimX)]
		dim(Sigma) <- c(dimX[2:length(dimX)],dimX[2:length(dimX)])
	}
	mu@vtag <- 'mu'
	Sigma@vtag <- 'Sigma'
	retv <- list(mu=mu,Sigma=Sigma)
	retv
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
