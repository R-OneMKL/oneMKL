#include <oneMKL.h>
#include <mkl_lapacke.h>

// [[Rcpp::depends(oneMKL)]]
// [[Rcpp::export]]
Rcpp::NumericMatrix mkl_lapacke_dgetri(Rcpp::NumericMatrix x) {
  Rcpp::IntegerMatrix ipiv(x.nrow(), x.ncol());
  Rcpp::NumericMatrix output(x.nrow(), x.ncol(), x.begin());
  LAPACKE_dgetrf(LAPACK_COL_MAJOR, output.nrow(), output.ncol(), output.begin(), ipiv.nrow(), ipiv.begin());
  LAPACKE_dgetri(LAPACK_COL_MAJOR, output.nrow(), output.begin(), ipiv.nrow(), ipiv.begin());
  return output;
}

/* R Testing Script
 Rcpp::sourceCpp("mkl_lapacke_dgetri.cpp")
 x <- matrix(rnorm(15000), 300, 50)
 z <- t(x) %*% x + diag(0.05, 50)
 all.equal(mkl_lapacke_dgetri(z) %*% z, diag(50))

 if (require("microbenchmark")) {
   microbenchmark(
     default = solve(z),
     lapacke = mkl_lapacke_dgetri(z),
     times = 100L
   )
 }
 */
