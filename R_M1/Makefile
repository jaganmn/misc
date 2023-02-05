VER = 4.2
SRCDIR = R-$(VER)
BUILDDIR = $(SRCDIR)-build

.PHONY : all update configure \
	build build-extra build-all check check-all \
	install install-extra install-all uninstall 

all : configure build

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
		PKG_CONFIG=/usr/local/bin/pkg-config \
		PKG_CONFIG_PATH=/opt/R/arm64/lib/pkgconfig:/opt/X11/lib/pkgconfig:/opt/X11/share/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig
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
