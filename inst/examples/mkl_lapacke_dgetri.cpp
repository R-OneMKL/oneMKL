#include <oneMKL.h>
#include <mkl_lapacke.h>

// [[Rcpp::depends(oneMKL)]]
// [[Rcpp::export]]
arma::mat mkl_lapacke_dgetri(const arma::mat & x) {
  arma::imat ipiv(x.n_rows, x.n_cols, arma::fill::zeros);
  arma::mat output(x);
  LAPACKE_dgetrf(LAPACK_COL_MAJOR, output.n_rows, output.n_cols, output.memptr(), ipiv.n_rows, ipiv.memptr());
  LAPACKE_dgetri(LAPACK_COL_MAJOR, output.n_rows, output.memptr(), ipiv.n_rows, ipiv.memptr());
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
