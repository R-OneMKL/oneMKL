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

#' @importFrom utils download.file untar

# helper function to extract strings
extractSubstring <- function(str, pattern, general=FALSE) {
  if (general) {
    regmatches(str, gregexpr(pattern, str))[[1]]
  } else {
    regmatches(str, regexpr(pattern, str))
  }
}

installMKL <- function(mklVersion, rArch = .Platform$r_arch, downloadedRArch = c()) {
  sysname <- Sys.info()[["sysname"]]

  # check whether to download MKL from Anaconda
  if (file.exists("inst/include/mkl/mkl.h")) {
    if (sysname == "Windows" && file.exists(paste0("inst/lib/", rArch, "/mkl_core.2.dll")) &&
        file.exists(paste0("inst/lib/", rArch, "/libiomp5md.dll"))) {
      cat(paste0("Intel MKL library for ", rArch, " has downloaded.\n"))
      return(invisible(NULL))
    } else if (sysname != "Windows" && file.exists("inst/lib/libmkl_core.so.2") &&
               file.exists("inst/lib/libiomp5.so")) {
      cat("Intel MKL library has downloaded.\n")
      return(invisible(NULL))
    }
  }

  # get the repodata.json.bz2 (index file) from Anaconda by different system and arch
  repodataBz2BaseUrl <- "https://conda.anaconda.org/anaconda/%s/repodata.json.bz2"
  if (sysname == "Windows") {
    condaArch <- "win-64"
  } else if (sysname == "Linux") {
    condaArch <- "linux-64"
  } else {
    stop("Sorry, your system,", sysname, ", is unsupported!")
  }

  if (!dir.exists("inst/lib")) {
    dir.create("inst/lib")
  }

  # download repodata.json.bz2
  tempDir <- ifelse(
    Sys.getenv("TMPDIR") != "",
    Sys.getenv("TMPDIR"),
    ifelse(
      Sys.getenv("TMP") != "",
      Sys.getenv("TMP"),
      ifelse(
        Sys.getenv("TEMP") != "",
        Sys.getenv("TEMP"),
        ifelse(sysname == "Windows", Sys.getenv("R_USER"), "/tmp")
      )
    )
  )
  repodataJsonBz2 <- file.path(tempDir, "repodata.json.bz2")
  if (!file.exists(repodataJsonBz2) || (difftime(Sys.time(), file.info(repodataJsonBz2)$mtime, "days") >= 7)) {
    cat("Download repodata...\n")
    download.file(sprintf(repodataBz2BaseUrl, condaArch), repodataJsonBz2, quiet = TRUE)
  } else {
    cat("repodata exists, skipped!\n")
  }

  # extract packages from index
  repodata <- paste0(readLines(zz <- bzfile(repodataJsonBz2)), collapse = "\n")
  close(zz)
  mklPkg <- extractSubstring(repodata, sprintf('"mkl-%s[^"]+":\\s+\\{[^\\}]+\\}', mklVersion), TRUE)
  mklIncPkg <- extractSubstring(repodata, sprintf('"mkl-include-%s[^"]+":\\s+\\{[^\\}]+\\}', mklVersion), TRUE)
  intelOmpPkg <- extractSubstring(repodata, sprintf('"intel-openmp-%s[^"]+":\\s+\\{[^\\}]+\\}', mklVersion), TRUE)

  # find the version string from index
  fnPattern <- '"[^:]+'
  versionPattern <- '"version":\\s+"[^"]+"'
  buildNumberPattern <- '"build_number":\\s+\\d+'
  pkgMat <- do.call(rbind, lapply(c(mklPkg, mklIncPkg, intelOmpPkg), function(i) {
    gsub('build_number|version|:|"| ', "",
    c(
      extractSubstring(i, fnPattern),
      extractSubstring(i, versionPattern),
      extractSubstring(i, buildNumberPattern)
      )
    )
  }))

  # find the files to download
  if (nrow(pkgMat) > 3) {
    versionCnts <- tapply(rep(1, nrow(pkgMat)), pkgMat[,2], sum)
    downloadVersion <- max(names(versionCnts[versionCnts >= 3]))
  } else {
    downloadVersion <- max(pkgMat[, 2])
  }

  downloadFns <- pkgMat[pkgMat[,2] == downloadVersion, ]
  downloadFns <- cbind(downloadFns, gsub("-[0-9\\.]+-[^\\.]+.tar.bz2", "", downloadFns[, 1]))
  if (nrow(downloadFns) > 3) {
    filterFns <- tapply(downloadFns[, 1], downloadFns[,4], max)
    downloadFns <- downloadFns[downloadFns[,1] %in% filterFns, ]
  }

  # download packages from Anaconda, un-tar and move to inst/
  downloadFileBaseUrl <- "https://anaconda.org/anaconda/%s/%s/download/%s/%s"
  apply(downloadFns, 1, function(v){
    bzFile <- file.path(tempDir, v[1])
    if (!file.exists(bzFile)) {
      cat(sprintf("Download %s from Anaconda repo...\n", v[1]))
      download.file(sprintf(downloadFileBaseUrl, v[3], v[2], condaArch, v[1]), bzFile, quiet = TRUE)
    } else {
      cat(paste(v[1], " exists, skipped!\n"))
    }

    destDir <- paste0(tempDir, "/", v[4])
    cat(sprintf("Untar %s and copy...\n", v[1]))
    untar(bzFile, exdir = destDir)
    if (sysname != "Windows") {
      Sys.chmod(list.dirs(destDir), "777")
      f <- list.files(destDir, all.files = TRUE, full.names = TRUE, recursive = TRUE)
      Sys.chmod(f, (file.info(f)$mode | "664"))
    }
    if (grepl("include", v[3])) {
      if (sysname == "Windows") {
        file.copy(paste0(destDir, "/Library/include/"), "inst/include", recursive = TRUE)
      } else {
        file.copy(paste0(destDir, "/include/"), "inst/include", recursive = TRUE)
      }
    } else {
      if (sysname == "Windows") {
        file.copy(paste0(destDir, "/Library/bin/"), "inst/lib", recursive = TRUE)
      } else {
        file.copy(paste0(destDir, "/lib"), "inst", recursive = TRUE)
      }
    }
  })

  cat("Copy and rename include folder...\n")
  incDir <- "inst/include/mkl"
  unlink(incDir, recursive = TRUE)
  file.rename("inst/include/include", incDir)

  if (sysname == "Windows") {
    cat("Copy and rename lib folder...\n")
    libDir <- paste(c("inst", "lib", if (nzchar(rArch)) rArch), collapse = "/")
    unlink(libDir, recursive = TRUE)
    file.rename("inst/lib/bin", libDir)
  }

  cat("Intel MKL is downloaded and untar from Anaconda successfully!\n")
}
