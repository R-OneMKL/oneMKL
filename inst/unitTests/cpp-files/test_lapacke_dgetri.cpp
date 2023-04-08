#include <oneMKL.h>
#include <mkl_lapacke.h>
#include <RcppArmadillo.h>

// [[Rcpp::depends(oneMKL)]]
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
arma::mat test_lapacke_dgetri(const arma::mat & x) {
  arma::imat ipiv(x.n_rows, x.n_cols, arma::fill::zeros);
  arma::mat output(x);
  LAPACKE_dgetrf(LAPACK_COL_MAJOR, output.n_rows, output.n_cols, output.memptr(), ipiv.n_rows, ipiv.memptr());
  LAPACKE_dgetri(LAPACK_COL_MAJOR, output.n_rows, output.memptr(), ipiv.n_rows, ipiv.memptr());
  return output;
}
