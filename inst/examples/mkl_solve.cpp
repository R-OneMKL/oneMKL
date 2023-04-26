#include <oneMKL.h>
#include <mkl_lapacke.h>

// [[Rcpp::depends(oneMKL)]]
// [[Rcpp::export]]
arma::mat mkl_real_solve(const arma::mat & x, const arma::mat & b) {
  arma::mat copy_x(x.memptr(), x.n_rows, x.n_cols);
  arma::mat output(b.memptr(), b.n_rows, b.n_cols);
  arma::ivec ipiv(x.n_rows, arma::fill::zeros);
  LAPACKE_dgesv(
    LAPACK_COL_MAJOR, copy_x.n_rows, b.n_cols, copy_x.memptr(),
    copy_x.n_rows, ipiv.memptr(), output.memptr(), copy_x.n_rows
  );
  return output;
}

// [[Rcpp::export]]
arma::cx_mat mkl_cmpl_solve(const arma::cx_mat & x, const arma::cx_mat & b) {
  arma::cx_mat copy_x(x.memptr(), x.n_rows, x.n_cols);
  arma::cx_mat output(b.memptr(), b.n_rows, b.n_cols);
  arma::ivec ipiv(x.n_rows, arma::fill::zeros);
  LAPACKE_zgesv(
    LAPACK_COL_MAJOR, copy_x.n_rows, b.n_cols, copy_x.memptr(),
    copy_x.n_rows, ipiv.memptr(), output.memptr(), copy_x.n_rows
  );
  return output;
}

/* R Testing Script
 Rcpp::sourceCpp("mkl_solve.cpp")
 x <- matrix(c(1, 2, 3, 5), 2)
 mkl_real_solve(x, diag(1, 2, 2))
 mkl_real_solve(x, matrix(1, 2, 1))

 x <- matrix(c(1+2i, 2+2i, 3+1i, 5+1i), 2)
 mkl_cmpl_solve(x, diag(1+3i, 2, 2))
 mkl_cmpl_solve(x, matrix(1+1i, 2, 1))
 */
