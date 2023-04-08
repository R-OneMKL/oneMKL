// Copyright (C) 2022        Ching-Chuan Chen
//
// This file is part of oneMKL.
//
// oneMKL is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// oneMKL is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with oneMKL. If not, see <http://www.gnu.org/licenses/>.

#include <oneMKL.h>
#include <mkl_cblas.h>
#include <RcppArmadillo.h>
#undef ARMA_USE_WRAPPER

// [[Rcpp::depends(oneMKL)]]
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
arma::mat mkl_cblas_dgemm(const arma::mat & x, const arma::mat & y) {
  double alpha = 1, beta = 0.0;
  arma::mat output(x.n_rows, y.n_cols, arma::fill::zeros);
  cblas_dgemm(
    CblasColMajor, CblasNoTrans, CblasNoTrans,
    x.n_rows, y.n_cols, x.n_cols, alpha, x.memptr(), x.n_rows, y.memptr(), y.n_rows,
    beta, output.memptr(), x.n_rows
  );
  return output;
}

/* R Testing Script
Rcpp::sourceCpp("mkl_mkl_cblas.cpp")
x <- matrix(rnorm(1e5), 500, 200)
z <- matrix(rnorm(1e5), 200, 500)
all.equal(mkl_cblas_dgemm(x, z), x %*% z)

if (require("microbenchmark")) {
  microbenchmark(
    default = x %*% z,
    cblas = mkl_cblas_dgemm(x, z),
    times = 100L
  )
}
*/

