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

#' Create a skeleton for a new package depending on oneMKL
#'
#' \code{onemkl.package.skeleton} automates the creation of a new source
#' package that intends to use features of `oneMKL`.
#' It is based on the \link[pkgKitten]{kitten} function which it executes
#' first and append some options for \link[roxygen2]{roxygenize} function.
#' It will automatically generate a package document with needed `roxygen2`
#' parameters for a packaged based on `oneMKL`.
#'
#' @param name The name of your R package.
#' @param path The path of your R package.
#' @return Nothing.
#' @seealso \link[pkgKitten]{kitten}
#' @examples
#' \dontrun{
#' onemkl.package.skeleton("testOneMKLPkg")
#' }
#' @importFrom utils packageDescription
#' @importFrom Rcpp compileAttributes
#' @export
onemkl.package.skeleton <- function(
    name = "anRpackage",
    path = "."
) {
  if(!requireNamespace("pkgKitten", quietly = TRUE)) {
    stop("You need to install R package pkgKitten before using onemkl.package.skeleton!")
  }

  if(!requireNamespace("roxygen2", quietly = TRUE)) {
    stop("You need to install R package roxygen2 before using onemkl.package.skeleton!")
  }

  env <- parent.frame(1)
  call <- match.call()
  call[[1]] <- pkgKitten::kitten
  tryCatch(
    eval(call, envir = env),
    error = function(e) {
      cat(paste(e, "\n")) # print error
      stop(paste("error while calling `pkgKitten::kitten`", sep=""))
    }
  )

  ## clean up
  root <- file.path(path, name)
  unlink(file.path(root, "man"), recursive = TRUE)
  file.remove(file.path(root, "R", "hello.R"))

  message("\nAdding onemkl settings")

  ## Add Rcpp to the DESCRIPTION
  DESCRIPTION <- file.path(root, "DESCRIPTION")
  if (file.exists(DESCRIPTION)) {
    x <- cbind(
      read.dcf(DESCRIPTION),
      "Imports" = sprintf("Rcpp (>= %s), RcppEigen (>= %s), oneMKL (>= %s)",
                          packageDescription("RcppEigen")[["Version"]],
                          packageDescription("Rcpp")[["Version"]],
                          packageDescription("oneMKL")[["Version"]]),
      "LinkingTo" = "Rcpp, RcppEigen, oneMKL"
    )
    write.dcf(x, file = DESCRIPTION)
    message(" >> added Imports: Rcpp, RcppEigen, oneMKL")
    message(" >> added LinkingTo: Rcpp, RcppEigen, oneMKL")
  }

  ## Add package document
  pkgDoc <- file.path(root, "R", paste0(name, "-package.R"))
  message("\n >> Adding package document")
  lines <- c(
    "#' anRpackage-package",
    "#' @docType package",
    paste0("#' @name ", name, "-package"),
    paste0("#' @useDynLib ", name),
    "#' @importFrom Rcpp evalCpp",
    "#' @importFrom oneMKL CxxFlags",
    "#' @importFrom oneMKL LdFlags",
    "NULL"
  )
  writeLines(lines, con = pkgDoc)
  message(" >> added useDynLib, importFrom and flags directives to NAMESPACE")

  ## lay things out in the src directory
  src <- file.path(root, "src")
  if (!file.exists(src)) {
    dir.create(src)
  }
  skeleton <- system.file("skeleton", package = "oneMKL")

  ## add Makevars
  message(" >> added src/Makevars")
  Makevars <- file.path(src, "Makevars")
  lines <- c(
    'PKG_CXXFLAGS += $(shell "${R_HOME}/bin/Rscript" -e "oneMKL::onemklIncFlags()")',
    'PKG_LIBS += $(shell "${R_HOME}/bin/Rscript" -e "oneMKL::onemklLibFlags()")'
  )
  writeLines(lines, con = Makevars)

  ## copy example codes
  file.copy(file.path(skeleton, "onemkl_hello_world.cpp"), src)
  message(" >> added example src file using Intel MKL")

  ## call Rcpp::compileAttributes to output cpp functions
  Rcpp::compileAttributes(root)
  message(" >> inoked Rcpp::compileAttributes to create wrappers")

  ## call roxygen2::roxygenize to output documents
  roxygen2::roxygenize(root)
  message(" >> inoked roxygen2::roxygenize to generate documents")

  ## call roxygen2::roxygenize to rewrite NAMESPACE
  file.remove(file.path(root, "NAMESPACE"))
  roxygen2::roxygenize(root)
  message(" >> inoked roxygen2::roxygenize to rewrite NAMESPACE")

  invisible(NULL)
}
