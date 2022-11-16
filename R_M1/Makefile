VER = dev
SRCDIR = R-$(VER)
BUILDDIR = $(SRCDIR)-build

TAR_TCL = tcl8.6.12-darwin20.6-arm64.tar.gz
TAR_TK = tk8.6.12-xft-darwin20.6-arm64.tar.gz
TAR_TKTABLE = tktable2.10-darwin20.6-arm64.tar.gz
TAR_GFORTRAN = gfortran-12.0.1-20220312-is-darwin20-arm64.tar.xz
TAR_OPENMP = openmp-12.0.1-darwin20-Release.tar.gz
TAR_EXTRAS = $(TAR_TCL) $(TAR_TK) $(TAR_TKTABLE) $(TAR_GFORTRAN) $(TAR_OPENMP)

.PHONY : all install-deps install-deps-extra update configure \
	build build-extra build-all check check-all \
	install install-extra install-all uninstall 

all : configure build

install-deps : install-deps-extra
	cd recipes && bash build.sh all

install-deps-extra : $(TAR_EXTRAS)
	for filename in $^; do tar xvf $$filename -C /; done
	ln -sfn $$(eval xcrun --show-sdk-path) /opt/R/arm64/gfortran/SDK

$(TAR_TCL) :
	cd recipes/other/tcltk && sh build-tcl.sh && cp $@ ../../..

$(TAR_TK) :
	cd recipes/other/tcltk && sh build-tk.sh && cp $@ ../../..

$(TAR_TKTABLE) :
	cd recipes/other/tcltk && sh build-tktable.sh && cp $@ ../../..

$(TAR_GFORTRAN) :
	curl -LO https://mac.r-project.org/tools/$@

$(TAR_OPENMP) :
	curl -LO https://mac.r-project.org/openmp/$@

update :
	cd $(SRCDIR) && svn update

configure :
	rm -rf $(BUILDDIR)
	mkdir $(BUILDDIR)
	cp config.site $(BUILDDIR)
	cd $(BUILDDIR) && ../$(SRCDIR)/configure \
		--enable-R-shlib \
		--enable-lto \
		--enable-memory-profiling \
		--with-recommended-packages \
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
	$(BUILDDIR)/bin/R CMD javareconf

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

uninstall:
	$(MAKE) -C $(BUILDDIR) uninstall
