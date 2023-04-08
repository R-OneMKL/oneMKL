if (require("RUnit", quietly = TRUE)) {
  pkg <- "oneMKL"
  require(pkg, character.only = TRUE)
  path <- system.file("unitTests", package = pkg)
  stopifnot(file.exists(path), file.info(path.expand(path))$isdir)

  Sys.setenv(R_TESTS = "")
  source(file.path(path, "runTests.R"), echo = TRUE)
} else {
  print( "package RUnit not available, cannot run unit tests" )
}
