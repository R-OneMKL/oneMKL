## Copyright (C) 2022-2023   Ching-Chuan Chen
##
## This file is part of oneMKL.
##
## oneMKL is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 2 of the License, or
## (at your option) any later version.
##
## oneMKL is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with oneMKL. If not, see <http://www.gnu.org/licenses/>.

#' `oneMKL` Package
#'
#'  The `oneMKL` package establishes the connection between the R environment and
#' Intel oneAPI Math Kernel Library (`oneMKL`) for the `oneMKL.MatrixCal` package. To enable
#' the integration, the `oneMKL` package provides necessary header files and dynamic library
#' files to R, and imported files from the packages `mkl`, `mkl-include`, and `intel-openmp`
#' within `Anaconda`. It is important to note that the `oneMKL` and ` oneMKL.MatrixCal`
#' packages are only compatible with Windows and Linux operating systems due to the limitations
#' of Intel `oneMKL`.
#'
#' @docType package
#' @name onemkl-package
NULL
