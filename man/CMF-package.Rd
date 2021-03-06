\name{CMF-package}
\alias{CMF-package}
\docType{package}
\title{
Collective Matrix Factorization (CMF)
}
\description{
Collective matrix factorization (CMF) finds joint low-rank
representations for a collection of matrices with shared
row or column entities. This package learns a variational
Bayesian approximation for CMF, supporting multiple
likelihood potentials and missing data, while identifying
both factors shared by multiple matrices and factors
private for each matrix.
}
\details{
\tabular{ll}{
Package: \tab CMF\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2014-03-25\cr
License: \tab GPL (>= 2)\cr
}
The package implements variational Bayesian approximation for
CMF, following the presentation in "Group-sparse embeddings in
collective matrix factorization".

The main functionality is provided by the function
\code{CMF} that is used for learning the model, and by the
function \code{predictCMF} that estimates missing entries
based on the learned model. These functions take as input
lists of matrices in a specific sparse format that stores
only the observed entries but that explicitly stores
zeroes (unlike most sparse matrix representations).
For converting between regular matrices and this sparse
format see \code{matrix_to_triplets} and \code{triplets_to_matrix}.

The package can also be used to learn Bayesian canonical
correlation analysis (CCA) and group factor analysis (GFA)
models, both of which are special cases of CMF. This is likely to be useful for people looking for
CCA and GFA solutions supporting missing data and non-Gaussian
likelihoods.
}
\author{
Arto Klami and Lauri Väre

Maintainer: Arto Klami <arto.klami@cs.helsinki.fi>
}
\references{
Arto Klami, Guillaume Bouchard, and Abhishek Tripathi.
Group-sparse embeddings in collective matrix factorization.
arXiv:1312.5921, 2013.

Arto Klami, Seppo Virtanen, and Samuel Kaski.
Bayesian canonical correlation analysis. Journal of Machine
Learning Research, 14(1):965--1003, 2013.

Seppo Virtanen, Arto Klami, Suleiman A. Khan, and Samuel Kaski.
Bayesian group factor analysis. In Proceedings of the 15th
International Conference on Artificial Intelligence and Statistics,
volume 22 of JMLR:W&CP, pages 1269-1277, 2012.
}
\keyword{ package }
\examples{
 require("CMF")
 # Create data for a circular setup with three matrices and three
 # object sets of varying sizes.
 X <- list()
 D <- c(10,20,30)
 inds <- matrix(0,nrow=3,ncol=2)
 
 # Matrix 1 is between sets 1 and 2 and has continuous data
 inds[1,] <- c(1,2)
 X[[1]] <- matrix(rnorm(D[inds[1,1]]*D[inds[1,2]],0,1),nrow=D[inds[1,1]])

 # Matrix 2 is between sets 1 and 3 and has binary data
 inds[2,] <- c(1,3)
 X[[2]] <- matrix(round(runif(D[inds[2,1]]*D[inds[2,2]],0,1)),nrow=D[inds[2,1]])

 # Matrix 3 is between sets 2 and 3 and has count data
 inds[3,] <- c(2,3)
 X[[3]] <- matrix(round(runif(D[inds[3,1]]*D[inds[3,2]],0,6)),nrow=D[inds[3,1]])

 # Convert the data into the right format
 triplets <- list()
 for(m in 1:3) triplets[[m]] <- matrix_to_triplets(X[[m]])

 # Missing entries correspond to missing rows in the triple representation
 # so they can be removed from training data by simply taking a subset
 # of the rows.
 train <- list()
 test <- list()
 keepForTraining <- c(100,200,300)
 for(m in 1:3) {
   subset <- sample(nrow(triplets[[m]]))[1:keepForTraining[m]]
   train[[m]] <- triplets[[m]][subset,]
   test[[m]] <- triplets[[m]][setdiff(1:nrow(triplets[[m]]),subset),]
 }

 # Learn the model with the correct likelihoods
 K <- 4
 likelihood <- c("gaussian","bernoulli","poisson")
 opts <- getCMFopts()
 opts$iter.max <- 10 # Less iterations for faster computation
 model <- CMF(train,inds,K,likelihood,D,test=test,opts=opts)

 # Check the predictions
 # Note that the data created here has no low-rank structure,
 # so we should not expect good accuracy.
 print(test[[1]][1:3,])
 print(model$out[[1]][1:3,])

 # predictions for the test set using the previously learned model
 out <- predictCMF(test, model)
 print(out$out[[1]][1:3,])
 print(out$error[[1]])
 # ...this should be the same as the output provided by CMF()
 print(model$out[[1]][1:3,])
}













