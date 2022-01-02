# Installing R from sources with OpenMP support on Apple silicon

Rough notes based on a drunken reading of `R-admin`...


## Dependencies

Take the following steps to make sure that all dependencies are
satisfied before proceeding with installation.

1.  Download all prerequisite binaries from
    [R for macOS Developers](https://mac.r-project.org/libs-arm64/)
    and install by unpacking to root:
    
    ```
    wget -r -np -nH -A "*.tar.gz" https://mac.r-project.org/libs-arm64/
    # remove `<lib>-a.b.c-<arch>.tar.gz` if `<lib>-x.y.z-<arch>.tar.gz` exists and `x.y.z > a.b.c`
    sudo mkdir -p /opt/R/arm64
    for filename in $(ls -d libs-arm64/*); do tar xvf "$filename" -C /; done
    ```

    Fortran compiler `gfortran` is included among these.
    `readline` and `zlib` are not, so install with Homebrew instead:
    
    ```
    brew update
    brew install readline
    brew install zlib
    ```

    See `R-admin` C.3.10.1 _Native builds_.
    
2.  Install the [LLVM](https://llvm.org/) `clang` toolchain, which,
    unlike Apple `clang`, supports OpenMP. At the time of writing,
    LLVM only supplies binaries for the `x86_64` architecture
    (see [here](<https://github.com/llvm/llvm-project/releases/tag/llvmorg-12.0.0>)).
    Fortunately, Homebrew has the `arm64` build:

    ```
    brew update
    brew install llvm
    ```

    See `R-admin` C.3.3 _Other C/C++ compilers_.

3.  Install Apple's Command Line Tools:
    
    ```
    xcode-select --install
    ```

    See `R-admin` C.3.1 _Prerequisites_.
    
4.  Modify symbolic link in `gfortran` installation to point to SDK.

    ```
    ln -sfn $(eval xcrun -show-sdk-path) /opt/R/arm64/gfortran/SDK
    ```

    See `R-admin` C.3.10.1 _Native builds_.

5.  Install an X Window System implementation from
    [XQuartz](https://www.xquartz.org/) disk image:

    ```
    curl -O https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.1/XQuartz-2.8.1.dmg
    ```

    See `R-admin` C.3.1 _Prerequisites_.

6.  Install a full TeX distribition from [MacTeX](https://tug.org/mactex/):

    ```
    curl -O https://mirror.ctan.org/systems/mac/mactex/MacTeX.pkg
    ```

    See `R-admin` C.3.4 _Other libraries_.

7.  For Cairo graphics, ensure that all required libraries exist:
    
    ```
    pkg-config pangocairo --exists --print-errors
    ```

    See `R-admin` C.3.2 _Cairo graphics_.


## Installation

Run

```
make clean
make preconfigure
```

to download and unpack the R sources into
`SRCDIR=R-<major>.<minor>.<patch>` (version set in `Makefile`) and 
create a build directory `BLDDIR=R-<major>.<minor>.<patch>-build`
containing a copy of `config.site`. Run

```
make configure
```

to configure `BLDDIR` and create a Makefile there. `configure` 
flags can be set beforehand in `Makefile`; for documentation, 
run `SRCDIR/configure --help`. Compiler flags and other options 
can be set beforehand in `BLDDIR/config.site`; comments there 
provide _some_ documentation, though `R-admin` should be scanned 
for platform-specific notes. To reconfigure with modified flags, 
do `make deconfigure` before repeating `make configure`.
Finally, run

```
make build
make check
sudo make install
```

to build R in `BLDDIR` and check and install the build. Note that the
installation is optional, as R can be run directly from `BLDDIR/bin`.
