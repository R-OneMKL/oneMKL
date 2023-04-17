## oneMKL

The `oneMKL` package establishes the connection between the R environment and **Intel oneAPI Math Kernel Library** (`oneMKL`) for the `oneMKL.MatrixCal` package. To enable the integration, the `oneMKL` package provides necessary header files and dynamic library files to R, and imported files from the packages `mkl`, `mkl-include`, and `intel-openmp` within `Anaconda`. It is important to note that the `oneMKL` and ` oneMKL.MatrixCal` packages are only compatible with Windows and Linux operating systems due to the limitations of Intel `oneMKL`. 

### Installation

1. To build the package from source, Windows users will need to have [Rtools](http://cran.csie.ntu.edu.tw/bin/windows/Rtools/) installed.

2. You can install this package through our `drat` repository:

```r
# for windows (Because we don't provide the binary package of oneMKL.)
install.packages(c("oneMKL"), repos="https://R-OneMKL.github.io/drat", type="source")
install.packages(c("oneMKL.MatrixCal"), repos="https://R-OneMKL.github.io/drat")

# for Linux
install.packages(c("oneMKL", "oneMKL.MatrixCal"), repos="https://R-OneMKL.github.io/drat")
```

Or, to get this package from github:

```r
# install.packages('remotes')
remotes::install_github("R-OneMKL/oneMKL")
remotes::install_github("R-OneMKL/oneMKL.MatrixCal") # install oneMKL.MatrixCal to resolve `solve` issue
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

### Hacking for UNIX system

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

### Get Ubuntu binary package

```
filename <- "oneMKL_0.1.2022_R_x86_64-pc-linux-gnu.tar.gz"
download.file(paste0("https://r-onemkl.github.io/drat/bin/linux/ubuntu/focal/", filename), filename)
install.packages(filename, repos = NULL)
```

### License

The `oneMKL` package is made available under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html) license.

The Intel MKL Library is licensed under the (Intel Simplified Software License)[https://www.intel.com/en-us/license/intel-simplified-software-license], as described at (Intel MKL License FAQ)[https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html].
