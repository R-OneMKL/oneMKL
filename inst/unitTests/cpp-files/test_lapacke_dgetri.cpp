#include <oneMKL.h>
#include <mkl_lapacke.h>

// [[Rcpp::depends(oneMKL)]]
// [[Rcpp::export]]
Rcpp::NumericMatrix test_lapacke_dgetri(Rcpp::NumericMatrix x) {
  Rcpp::IntegerMatrix ipiv(x.nrow(), x.ncol());
  Rcpp::NumericMatrix output(x.nrow(), x.ncol(), x.begin());
  LAPACKE_dgetrf(LAPACK_COL_MAJOR, output.nrow(), output.ncol(), output.begin(), ipiv.nrow(), ipiv.begin());
  LAPACKE_dgetri(LAPACK_COL_MAJOR, output.nrow(), output.begin(), ipiv.nrow(), ipiv.begin());
  return output;
}
