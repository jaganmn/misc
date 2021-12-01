# Installing R packages with OpenMP support on Apple silicon

These instructions are intended for Apple silicon users wanting to
compile R packages from their sources with OpenMP support. They are
based on a careful reading of
[R-admin](https://cran.r-project.org/doc/manuals/r-release/R-admin.html),
but may become out of date at any time and come with no warranty!

1.  Download and install a native R binary from CRAN,
	[here](https://cran.r-project.org/bin/macosx/).
	
2.  Install Apple's Command Line Tools. Running
    
    ```
    xcode-select --install
    ```
	
	on the command line will install the most recent version, provided
    no version is currently installed.

2.  Install the [LLVM](https://llvm.org/) `clang` toolchain, which
    unlike Apple `clang`, supports OpenMP. At the time of writing,
    LLVM only supplies binaries for the `x86_64` architecture 
	(see [here](https://github.com/llvm/llvm-project/releases/tag/llvmorg-12.0.0)).
    Fortunately, Homebrew has the `arm64` build:

    ```
	brew update
    brew install llvm
    ```

3. Add the following to `$(HOME)/.R/Makevars`, creating the file if
   necessary. Here, `$(HOME)` is what is printed when you run `echo
   $HOME` on the command line.

   ```
   LIBS_DIR=/opt/R/arm64
   LLVM_DIR=/opt/homebrew/opt/llvm
   SDK_PATH=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
   
   CC=$(LLVM_DIR)/bin/clang -isysroot $(SDK_PATH) -target arm64-apple-macos11
   CXX=$(LLVM_DIR)/bin/clang++ -isysroot $(SDK_PATH) -target arm64-apple-macos11
   
   CFLAGS=-falign-functions=8 -g -O2 -Wall -pedantic -Wno-implicit-function-declaration
   CXXFLAGS=-g -O2 -Wall -pedantic
   
   SHLIB_OPENMP_CFLAGS=-fopenmp
   SHLIB_OPENMP_CXXFLAGS=-fopenmp
   
   CPPFLAGS=-I$(LLVM_DIR)/include -I$(LIBS_DIR)/include
   LDFLAGS=-L$(LLVM_DIR)/lib -L$(LIBS_DIR)/lib
   ```
   
4. Start an R session and try installing from sources an R package that 
   makes use of OpenMP. Hopefully, that package comes with a way to
   test whether support is actually enabled. By way of example:
   
   ```r
   install.packages("TMB", type = "source")
   TMB::openmp() # positive number if supported, zero if not
   ```
