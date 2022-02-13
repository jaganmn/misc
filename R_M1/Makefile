SRCDIR=R-devel
LIBDIR=R-devel-deps
BUILDDIR=R-devel-build

## Command Line Tools for Xcode
## XQuartz
## MacTeX

all: update build

update-deps-tmp:
	rm -rf $(LIBDIR)
	mkdir -p $(LIBDIR)
	wget -P $(LIBDIR) -r -np -nH -A "*.tar.gz" -R "cairo-1.14.12*","fontconfig-2.13.1*","freetype-2.10.0*","gdal-3.1.4*","gdal-3.2.1*","openssl-1.1.1h*","pixman-0.38.4*","proj-6.3.1*","tcltk-8.6*","tiff-4.1.0*","xz-5.2.4*" --cut-dirs=1 -e robots=off https://mac.r-project.org/libs-arm64/
	wget -P $(LIBDIR) https://mac.r-project.org/libs-4/zlib-system-stub-darwin.17-x86_64.tar.gz
	wget -P $(LIBDIR) https://mac.r-project.org/openmp/openmp-11.0.1-darwin20-Release.tar.gz

install-deps-tmp:
	rm -rf /opt/R/arm64
	mkdir -p /opt/R/arm64
	for filename in $$(ls -d $(LIBDIR)/*.tar.gz); do tar xvf "$$filename" -C /; done
	ln -sfn $$(eval xcrun -show-sdk-path) /opt/R/arm64/gfortran/SDK

update-deps:
	rm -rf $(LIBDIR)
	mkdir -p $(LIBDIR)
	wget -P $(LIBDIR) -r -np -nH -A "*.tar.xz" --cut-dirs=2 -e robots=off https://mac.r-project.org/bin/darwin20/arm64/
	wget -P $(LIBDIR) https://mac.r-project.org/libs-arm64/gfortran-f51f1da0-darwin20.0-arm64.tar.gz
	wget -P $(LIBDIR) https://mac.r-project.org/libs-arm64/pandoc-2.14.2-darwin.20-arm64.tar.gz
	wget -P $(LIBDIR) https://mac.r-project.org/libs-arm64/tcl8.6.11-darwin20.4-arm64.tar.gz
	wget -P $(LIBDIR) https://mac.r-project.org/libs-arm64/tk8.6.11-xft-darwin20.4-arm64.tar.gz
	wget -P $(LIBDIR) https://mac.r-project.org/libs-arm64/Tktable2.10-darwin20.4-arm64.tar.gz
	wget -P $(LIBDIR) https://mac.r-project.org/libs-4/zlib-system-stub-darwin.17-x86_64.tar.gz
	wget -P $(LIBDIR) https://mac.r-project.org/openmp/openmp-11.0.1-darwin20-Release.tar.gz

install-deps:
	rm -rf /opt/R/arm64
	mkdir -p /opt/R/arm64
	for filename in $$(ls -d $(LIBDIR)/arm64/*.tar.xz); do tar xvf "$$filename" -C /; done
	for filename in $$(ls -d $(LIBDIR)/*.tar.gz); do tar xvf "$$filename" -C /; done
	ln -sfn $$(eval xcrun -show-sdk-path) /opt/R/arm64/gfortran/SDK

update:
	cd $(SRCDIR) && svn update

configure:
	rm -rf $(BUILDDIR)
	mkdir $(BUILDDIR)
	cp config.site $(BUILDDIR)
	cd $(BUILDDIR) && ../$(SRCDIR)/configure \
		--enable-R-shlib \
		--enable-BLAS-shlib \
		--enable-lto \
		--enable-memory-profiling \
		--enable-prebuilt-html \
		--without-recommended-packages \
		--disable-java \
		--build=aarch64-apple-darwin20 \
		--x-includes=/opt/X11/include \
		--x-libraries=/opt/X11/lib \
		--with-blas="-framework Accelerate" \
		--with-tcl-config=/opt/R/arm64/lib/tclConfig.sh \
		--with-tk-config=/opt/R/arm64/lib/tkConfig.sh \
		PKG_CONFIG=/opt/R/arm64/bin/pkg-config \
		PKG_CONFIG_PATH=/opt/R/arm64/lib/pkgconfig:/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig
	cp $(BUILDDIR)/config.log .

build:
	$(MAKE) -C $(BUILDDIR) 2>&1 | tee build.log

build-extra:
	$(MAKE) -C $(BUILDDIR) pdf
	$(MAKE) -C $(BUILDDIR) info

build-all: build build-extra

check:
	$(MAKE) -C $(BUILDDIR) check 2>&1 | tee check.log

check-all:
	$(MAKE) -C $(BUILDDIR) check-devel 2>&1 | tee check.log

install:
	$(MAKE) -C $(BUILDDIR) install

install-extra:
	$(MAKE) -C $(BUILDDIR) install-pdf
	$(MAKE) -C $(BUILDDIR) install-info
	$(MAKE) -C $(BUILDDIR) install-tests

install-all: install install-extra

install-patched:
	rm -rf /Library/Frameworks/R.framework
	wget https://mac.r-project.org/big-sur/R-4.1-branch/arm64/R-4.1-branch.tar.gz
	tar xvf R-4.1-branch.tar.gz -C /
	rm -f R-4.1-branch.tar.gz
