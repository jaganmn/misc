SRCDIR=R-devel
BUILDDIR=R-devel-build

## Command Line Tools for Xcode
## XQuartz
## MacTeX

all: update build

install-deps:
	#cd recipes && bash build.sh all && cd -
	cd recipes/other/tcltk && \
		sh build-tcl.sh && \
		sh build-tk.sh && \
		sh build-tktable.sh && \
		cp tcl8.6.12-darwin20.6-arm64.tar.gz tk8.6.12-xft-darwin20.6-arm64.tar.gz tktable2.10-darwin20.6-arm64.tar.gz ../../.. && \
		cd -
	wget https://mac.r-project.org/libs-arm64/gfortran-f51f1da0-darwin20.0-arm64.tar.gz
	wget https://mac.r-project.org/openmp/openmp-12.0.1-darwin20-Release.tar.gz
	for filename in $$(ls *.tar.gz); do tar xvf "$$filename" -C /; done
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
