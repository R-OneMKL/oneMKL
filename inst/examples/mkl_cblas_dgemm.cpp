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

// [[Rcpp::depends(oneMKL)]]
// [[Rcpp::export]]
Rcpp::NumericMatrix mkl_cblas_dgemm(Rcpp::NumericMatrix x, Rcpp::NumericMatrix y) {
  double alpha = 1, beta = 0.0;
  Rcpp::NumericMatrix output(x.nrow(), y.ncol());
  cblas_dgemm(
    CblasColMajor, CblasNoTrans, CblasNoTrans,
    x.nrow(), y.ncol(), x.ncol(), alpha, x.begin(), x.nrow(), y.begin(), y.nrow(),
    beta, output.begin(), x.nrow()
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

