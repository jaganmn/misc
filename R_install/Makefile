MAJOR=4
MINOR=1
PATCH=2
VERSION=$(MAJOR).$(MINOR).$(PATCH)
SRCDIR=R-$(VERSION)
BUILDDIR=$(SRCDIR)/BUILDDIR
TARBALL=$(SRCDIR).tar.gz
MAKEFILE=$(BUILDDIR)/Makefile

all: new set-up

$(TARBALL):
	curl -O https://cran.r-project.org/src/base/R-$(MAJOR)/$@

$(SRCDIR): $(TARBALL)
	rm -rf $@
	tar xvf $<

$(BUILDDIR): config.site
	rm -rf $@
	mkdir $@
	cp $< $@

set-up: $(SRCDIR) $(BUILDDIR)

configure:
	cd $(BUILDDIR) && ../configure \
		--enable-R-framework \
		--enable-memory-profiling \
		--enable-lto \
		--enable-prebuilt-html \
		--disable-java \
		--build=aarch64-apple-darwin20 \
		--x-includes=/opt/X11/include \
		--x-libraries=/opt/X11/lib \
		--with-blas="-framework Accelerate" \
		--with-tcl-config=/Library/Frameworks/Tcl.framework/tclConfig.sh \
		--with-tk-config=/Library/Frameworks/Tk.framework/tkConfig.sh \
		PKG_CONFIG=/opt/R/arm64/bin/pkg-config \
		PKG_CONFIG_PATH=/opt/R/arm64/lib/pkgconfig:/opt/X11/lib/pkgconfig:/opt/homebrew/opt/readline/lib/pkgconfig:/opt/homebrew/opt/zlib/lib/pkgconfig

build:
	$(MAKE) -C $(BUILDDIR)

build-extra:
	$(MAKE) -C $(BUILDDIR) pdf
	$(MAKE) -C $(BUILDDIR) info

build-all: build build-extra

check:
	$(MAKE) -C $(BUILDDIR) check

check-all:
	$(MAKE) -C $(BUILDDIR) check-devel

install:
	$(MAKE) -C $(BUILDDIR) install

install-extra:
	$(MAKE) -C $(BUILDDIR) install-pdf
	$(MAKE) -C $(BUILDDIR) install-info
	$(MAKE) -C $(BUILDDIR) install-tests

install-all: install install-extra

clean:
	$(MAKE) -C $(BUILDDIR) distclean

new:
	rm -rf $(TARBALL) $(BUILDDIR) $(SRCDIR)
