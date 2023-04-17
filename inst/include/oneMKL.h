// Copyright (C)  2022-2023     Ching-Chuan Chen
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
// along with oneMKL.  If not, see <http://www.gnu.org/licenses/>.

#ifndef onemkl__onemkl__h
#define onemkl__onemkl__h

// For RcppArmadillo
#ifndef MKL_Complex16
#include <complex>
typedef std::complex<double> MKL_Complex16;
#define MKL_Complex16 std::complex<double>
#endif
#ifndef MKL_Complex8
#include <complex>
typedef std::complex<float> MKL_Complex8;
#define MKL_Complex8 std::complex<float>
#endif

// include MKL headers
#include <mkl.h>
#include <mkl_types.h>

// For RcppArmadillo
#define ARMA_USE_MKL_TYPES
#define ARMA_BLAS_NOEXCEPT
#define ARMA_LAPACK_NOEXCEPT
#define ARMA_DONT_USE_FORTRAN_HIDDEN_ARGS
#define ARMA_FORTRAN_CHARLEN_TYPE blas_int

// include RcppArmadillo first
#include <RcppArmadillo.h>

#endif
