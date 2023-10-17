## autoconf/configure script for oneMKL
## Copyright (c) 2013-2022, Ching-Chuan Chen

echo "Run configure..."

# Process this file with autoconf to produce a configure script.
AC_INIT([oneMKL], [0.1.0], [zw12356@gmail.com])

# Ensure C++ is set up as R expects
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
    AC_MSG_ERROR([Could not determine R_HOME.])
fi

###### DOWNLOAD INTEL MKL FROM ANACONDA ######################################

AC_MSG_CHECKING([Download Intel MKL from Anaconda])
   "${R_HOME}/bin/Rscript" --vanilla --slave -e "source(\"R/install.R\"); installMKL(\"2023\")"

AC_OUTPUT

echo "Intel MKL Library download complete"
