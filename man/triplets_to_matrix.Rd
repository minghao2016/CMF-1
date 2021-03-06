\name{triplets_to_matrix}
\alias{triplets_to_matrix}
\title{Conversion from triplet/coordinate format to matrix}
\usage{
triplets_to_matrix(triplets)
}
\arguments{
  \item{triplets}{A matrix in triplet/coordinate format}
}
\value{
The input matrix as a normal matrix of class \code{matrix}
}
\description{
This function is the inverse of \code{matrix_to_triplets}.
It converts a matrix represented as a set of triplets into
an object of the class \code{matrix}. The missing entries
(the ones not present in the triplet representation) are
filled in as NA.
}
\details{
See \code{matrix_to_triplets} for a description of the
representation.
}
\examples{
x <- matrix(c(1,2,NA,NA,5,6),nrow=3)
triplet <- matrix_to_triplets(x)
print(triplet)
xnew <- triplets_to_matrix(triplet)
print(xnew)
}
\author{
Arto Klami and Lauri Väre
}




