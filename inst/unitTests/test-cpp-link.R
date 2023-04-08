library(oneMKL)
library(Rcpp)

cblasCppFile <- "test_cblas_dgemm.cpp"
if (file.exists(file.path("cpp-files", cblasCppFile))) {
  sourceCpp(file.path("cpp-files", cblasCppFile))
} else {
  sourceCpp(system.file("unitTests", "cpp-files", cblasCppFile, package = "oneMKL"))
}

testCppLink <- function() {
  x <- matrix(rnorm(1e3), 50, 20)
  y <- matrix(rnorm(1e3), 20, 50)
  checkEquals(test_cblas_dgemm(x, y), x %*% y)
}

lapackeCppFile <- "test_lapacke_dgetri.cpp"
if (file.exists(file.path("cpp-files", lapackeCppFile))) {
  sourceCpp(file.path("cpp-files", lapackeCppFile))
} else {
  sourceCpp(system.file("unitTests", "cpp-files", lapackeCppFile, package = "oneMKL"))
}

testCppLink <- function() {
  x <- matrix(rnorm(1e4), 200, 50)
  XtX <- fMatTransProd(x, x)+ diag(0.05, 50)
  checkEquals(test_lapacke_dgetri(XtX) %*% XtX, diag(50))
}
