## Copyright (C) 2010 - 2013 Dirk Eddelbuettel, Romain Francois and Douglas Bates
## Copyright (C) 2014        Dirk Eddelbuettel
## Copyright (C) 2022-2023   Ching-Chuan Chen
##
## This file is based on flags.R and inline.R from RcppParallel, RcppArmadillo and RcppEigen.
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

#' Compilation flags for oneMKL
#'
#' Output the compiler or linker flags required to build against `oneMKL`.
#' These functions are typically called from `Makevars` as follows:
#' ```
#' PKG_CXXFLAGS += $(shell "${R_HOME}/bin/Rscript" -e "oneMKL::onemklIncFlags()")
#' PKG_LIBS += $(shell "${R_HOME}/bin/Rscript" -e "oneMKL::onemklLibFlags()")
#' ```
#' \R packages using `oneMKL` should also add the following to their `NAMESPACE` file:
#' ```
#' importFrom(oneMKL, onemklIncFlags)
#' importFrom(oneMKL, onemklLibFlags)
#' ```
#' This is necessary to ensure that \pkg{oneMKL} is loaded and available.
#'
#' @name flags
#' @rdname flags
#' @aliases mklCxxFlags mklLdFlags onemklLibFlags onemklIncFlags
NULL

#' @name flags
#' @export
mklCxxFlags <- function() {
  pkgIncDir <- system.file("include", package = "oneMKL")
  paste0("-I'", pkgIncDir, "' -I'", pkgIncDir, "/mkl'")
}

#' @name flags
#' @export
mklLdFlags <- function() {
  linkLibs <- if(Sys.info()[["sysname"]] == "Windows") {
    "-lmkl_intel_thread.2 -lmkl_rt.2 -lmkl_core.2 -liomp5md"
  } else {
    "-lmkl_intel_thread -lmkl_rt -lmkl_core -liomp5"
  }
  sprintf("-L%s %s", mklRoot(), linkLibs)
}

#' @name flags
#' @export
onemklLibFlags <- function(){
  cat(mklLdFlags())
}

#' @name flags
#' @export
onemklIncFlags <- function(){
  cat(mklCxxFlags())
}

#' @importFrom Rcpp Rcpp.plugin.maker
inlineCxxPlugin <- function() {
  getSettings <- Rcpp.plugin.maker(
    include.before = "#include <oneMKL.h>",
    libs = "$(FLIBS)",
    package = c("oneMKL", "Rcpp")
  )
  settings <- getSettings()
  settings$env$PKG_CXXFLAGS <- paste(settings$env$PKG_CXXFLAGS, mklCxxFlags())
  settings$env$PKG_LIBS <- paste(settings$env$PKG_LIBS, mklLdFlags())
  return(settings)
}
