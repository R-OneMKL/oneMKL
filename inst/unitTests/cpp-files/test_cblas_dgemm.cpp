#include <oneMKL.h>
#include <mkl_cblas.h>
#include <RcppArmadillo.h>

// [[Rcpp::depends(oneMKL)]]
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
arma::mat test_cblas_dgemm(const arma::mat & x, const arma::mat & y) {
  double alpha = 1, beta = 0.0;
  arma::mat output(x.n_rows, y.n_cols, arma::fill::zeros);
  cblas_dgemm(
    CblasColMajor, CblasNoTrans, CblasNoTrans,
    x.n_rows, y.n_cols, x.n_cols, alpha, x.memptr(), x.n_rows, y.memptr(), y.n_rows,
    beta, output.memptr(), x.n_rows
  );
  return output;
}
