## oneMKL

The `oneMKL` package aims to provide header files and dynamic library files to R for usage.
We imported files from packages on Anaconda,  `mkl`, `mkl-include` and `intel-openmp`.
`oneMKL` supports windows and Linux only because the availablity of Anaconda `mkl` package. 

### Installation

To build the package from source, Windows users will need to have [Rtools](http://cran.csie.ntu.edu.tw/bin/windows/Rtools/) installed.

Because the availability of Anaconda `mkl` package, we only support Windows and Linux.
Also, note that this package does not support Mac because Intel MKL does not support Mac M1/M2 CPUs.

To get this package from github:

```r
install.packages('remotes')
remotes::install_github("ChingChuan-Chen/R-oneMKL")
```

### Speed-Up Performance for the Matrix Multiplication

You may get the following results by running `inst/example/link_mkl_cblas.cpp`.

```
Unit: milliseconds
    expr     min       lq      mean   median       uq     max neval
 default 22.2112 22.39580 24.531914 22.56680 25.16425 42.7146   100
    arma  2.1251  2.48840  3.397931  2.62585  2.77550 18.7268   100
   cblas  1.5832  1.74695  2.174011  1.89105  2.01385 13.1898   100
   
# This results are run on R-4.2.3 (Windows 11) with AMD 2990WX.
```

### Pre-requirement for UNIX system

Since MKL `.so` files are unable to load in R with `dyn.load`, you will need to modify `.Renviron` to add the path to `LD_LIBRARY_PATH` with the following script.

```shell
# install Rcpp
Rscript -e "install.packages('Rcpp', repos = 'https://cloud.r-project.org')"
# locate package installation path
oneMKLPath=$(Rscript -e 'cat(paste0(sub("Rcpp/libs", "oneMKL/", system.file("libs", package = "Rcpp")), "lib/"))')
# append oneMKL package location to .Renviron
tee -a ~/.Renviron << EOF
LD_LIBRARY_PATH=${oneMKLPath}:\${LD_LIBRARY_PATH}
EOF
```

### Known Issues

1. `solve` in vanilla R will be broken for solving inverse matrices (large size) after loading MKL in UNIX system.
   MKL uses INT64 ipiv in `dgesv`, but R uses INT32. Hence, it causes the issue.

### License

The `oneMKL` package is made available under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) license.

The Intel MKL Library is licensed under the (Intel Simplified Software License)[https://www.intel.com/en-us/license/intel-simplified-software-license], as described at (Intel MKL License FAQ)[https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html].