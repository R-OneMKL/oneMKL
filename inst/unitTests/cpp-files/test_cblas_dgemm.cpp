#include <oneMKL.h>
#include <mkl_cblas.h>

// [[Rcpp::depends(oneMKL)]]
// [[Rcpp::export]]
Rcpp::NumericMatrix test_cblas_dgemm(Rcpp::NumericMatrix x, Rcpp::NumericMatrix y) {
  double alpha = 1, beta = 0.0;
  Rcpp::NumericMatrix output(x.nrow(), y.ncol());
  cblas_dgemm(
    CblasColMajor, CblasNoTrans, CblasNoTrans,
    x.nrow(), y.ncol(), x.ncol(), alpha, x.begin(), x.nrow(), y.begin(), y.nrow(),
    beta, output.begin(), x.nrow()
  );
  return output;
}
