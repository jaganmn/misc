# Installing R packages with OpenMP support on Apple silicon

These instructions are intended for Apple silicon users wanting to
compile R packages from their sources with OpenMP support. They are
based on a careful reading of
[R-admin](https://cran.r-project.org/doc/manuals/r-release/R-admin.html),
but may become out of date at any time and come with no warranty!

1. Download an R binary from CRAN 
   [here](https://cran.r-project.org/bin/macosx/) 
   and install. 
   Be sure to select the binary built for Apple silicon.

2. Run

   ```bash
   $ xcode-select --install
   ```

   in Terminal to download and install the latest version of Xcode, 
   which includes Apple's Command Line Tools. You can also obtain 
   Xcode directly from your browser 
   [here](https://developer.apple.com/xcode/). 
   Earlier versions of Xcode are available 
   [here](https://developer.apple.com/download/all/), 
   but I would start with the latest. 
   (There _might_ be a good reason to install the exact version of 
   Xcode than CRAN used to build your R binary. That version might
   not be the latest.)

3. Install the [LLVM](https://llvm.org/) `clang` toolchain with
   Homebrew. Unlike Apple's `clang`, it supports OpenMP.

   ```bash
   $ brew update
   $ brew install llvm 
   ```
   
   It should unpack into `/opt/homebrew/opt`.

4. Download a `gfortran` binary built for your macOS version and
   architecture, then install. This step differs by macOS version:
   
   **Monterey:** Download the disk image file hosted 
   [here](https://github.com/fxcoudert/gfortran-for-macOS/releases/tag/12-arm-alpha) 
   and `open` to install. The installer will unpack into `/usr/local`;
   you should move the installation into `/opt/R/arm64`.
   
   ```bash
   $ sudo mkdir -p /opt/R/arm64/bin
   $ sudo mv /usr/local/gfortran /opt/R/arm64
   $ sudo mv /usr/local/bin/gfortran /opt/R/arm64/bin
   $ sudo ln -sfn /opt/R/arm64/gfortran/bin/gfortran /opt/R/arm64/bin/gfortran
   ```
   
   **Big Sur:** Download the tarball hosted 
   [here](https://github.com/fxcoudert/gfortran-for-macOS/releases/tag/11-arm-alpha2) 
   and unpack directly into `/opt/R/arm64`.
   
   ```bash
   $ sudo mkdir -p /opt/R/arm64
   $ sudo tar xvf path/to/tarball -C /opt/R/arm64
   ```

5. Add the following lines to `$(HOME)/.R/Makevars`, creating the file if necessary.

   ```make
   LLVM_DIR=/opt/homebrew/opt/llvm
   LIBS_DIR=/opt/R/arm64
   GFORTRAN_DIR=$(LIBS_DIR)/gfortran
   SDK_DIR=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
   
   CC=$(LLVM_DIR)/bin/clang -isysroot $(SDK_DIR) -target arm64-apple-macos12
   CXX=$(LLVM_DIR)/bin/clang++ -isysroot $(SDK_DIR) -target arm64-apple-macos12
   FC=$(GFORTRAN_DIR)/bin/gfortran -mtune=native
   
   CFLAGS=-falign-functions=64 -g -O2 -Wall -pedantic -Wno-implicit-function-declaration
   CXXFLAGS=-falign-functions=64 -g -O2 -Wall -pedantic
   FFLAGS=-g -O2 -Wall -pedantic

   SHLIB_OPENMP_CFLAGS=-fopenmp
   SHLIB_OPENMP_CXXFLAGS=-fopenmp
   SHLIB_OPENMP_FFLAGS=-fopenmp
   
   CPPFLAGS=-I$(LLVM_DIR)/include -I$(LIBS_DIR)/include
   LDFLAGS=-L$(LLVM_DIR)/lib -L$(LIBS_DIR)/lib
   FLIBS=-L$(GFORTRAN_DIR)/lib/gcc/aarch64-apple-darwin21/12.0.0 -L$(GFORTRAN_DIR)/lib -lgfortran -lemutls_w -lm
   ```

   `CC`, `CXX`, and `FLIBS` need to be tweaked on Big Sur:
   
   ```make
   CC=$(LLVM_DIR)/bin/clang -isysroot $(SDK_DIR) -target arm64-apple-macos11
   CXX=$(LLVM_DIR)/bin/clang++ -isysroot $(SDK_DIR) -target arm64-apple-macos11
   FLIBS=-L$(GFORTRAN_DIR)/lib/gcc/aarch64-apple-darwin20.2.0/11.0.0 -L$(GFORTRAN_DIR)/lib -lgfortran -lemutls_w -lm
   ```

6. Run R and test that you can compile a program with OpenMP support. 
   For example:
   
   ```r
   if (!requireNamespace("RcppArmadillo", quietly = TRUE)) {
       install.packages("RcppArmadillo")
   }
   Rcpp::sourceCpp(code = '
   #include <RcppArmadillo.h>
   #ifdef _OPENMP
   # include <omp.h>
   #endif
   
   // [[Rcpp::depends(RcppArmadillo)]]
   // [[Rcpp::plugins(openmp)]]
   // [[Rcpp::export]]
   void omp_test()
   {
   #ifdef _OPENMP
       Rprintf("OpenMP threads available: %d\\n", omp_get_max_threads());
   #else
       Rprintf("OpenMP not supported\\n");
   #endif
   }
   ')
   omp_test()
   ```
   ```none
   OpenMP threads available: 8
   ```
   
   If this fails to compile, or if it compiles without error but you
   get the message saying that OpenMP is not supported, then something
   is wrong. Please report any issues!
