## Copyright (C) 2014-2022   JJ Allaire, Romain Francois, Kevin Ushey, Gregory Vandenbrouck
## Copyright (C) 2022-2023   Ching-Chuan Chen
##
## This file is based on tbb.R from RcppParallel.
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

mklRoot <- function() {
  rArch <- .Platform$r_arch
  pathList <- c("lib", if (nzchar(rArch)) rArch)
  libDir <- paste(pathList, collapse = "/")
  system.file(libDir, package = "oneMKL")
}

#' Get the Path to Intel MKL Library
#'
#' @param name The name of Intel MKL library to be resolved.
#' It will be one of ``, ``, `` or ``.
#' When name is `NULL`, this function returns the path which contains Intel MKL.
#'
#' @export
mklLibraryPath <- function(name = NULL) {

  # library paths for different OSes
  sysname <- Sys.info()[["sysname"]]

  # find root for the path which contains Intel MKL
  mklRoot <- mklRoot()
  if (is.null(name))
    return(mklRoot)

  # form library names
  mklLibNames <- list(
    "Darwin"  = paste0("lib", name, ".dylib"),
    "Windows" = paste0(       name, c(".dll", ".2.dll")),
    "Linux"   = paste0("lib", name, c(".so.2", ".so"))
  )

  # skip systems that we know not to be compatible
  if (is.null(mklLibNames[[sysname]]))
    return(NULL)

  # find the request library (if any)
  libNames <- mklLibNames[[sysname]]
  for (libName in libNames) {
    mklName <- file.path(mklRoot, libName)
    if (file.exists(mklName))
      return(mklName)
  }
}
