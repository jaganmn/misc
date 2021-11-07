MAJOR=4
MINOR=1
PATCH=2
VERSION=$(MAJOR).$(MINOR).$(PATCH)
SRCDIR=R-$(VERSION)
BLDDIR=$(SRCDIR)-build
TARBALL=$(SRCDIR).tar.gz
MAKEFILE=$(BLDDIR)/Makefile

all: clean preconfigure

$(TARBALL):
	curl -O https://cran.r-project.org/src/base/R-$(MAJOR)/$@

$(SRCDIR): $(TARBALL)
	rm -rf $@
	tar xvf $<

$(BLDDIR): config.site
	rm -rf $@
	mkdir $@
	cp $< $@

preconfigure: $(BLDDIR) $(SRCDIR)

configure:
	cd $(BLDDIR) && ../$(SRCDIR)/configure \
		--enable-R-framework \
		--enable-prebuilt-html \
		--enable-memory-profiling \
		--enable-lto \
		--x-includes=/opt/X11/include \
		--x-libraries=/opt/X11/lib \
		--with-blas="-framework Accelerate" \
		--with-tcl-config=/Library/Frameworks/Tcl.framework/tclConfig.sh \
		--with-tk-config=/Library/Frameworks/Tk.framework/tkConfig.sh \
		PKG_CONFIG=/opt/R/arm64/bin/pkg-config \
		PKG_CONFIG_PATH=/opt/R/arm64/lib/pkgconfig:/opt/homebrew/opt/zlib/lib/pkgconfig

deconfigure:
	$(MAKE) -C $(BLDDIR) distclean

build:
	$(MAKE) -C $(BLDDIR)
	$(MAKE) -C $(BLDDIR) pdf
	$(MAKE) -C $(BLDDIR) info

check:
	$(MAKE) -C $(BLDDIR) check-all

install:
	$(MAKE) -C $(BLDDIR) install
	$(MAKE) -C $(BLDDIR) install-pdf
	$(MAKE) -C $(BLDDIR) install-info
	$(MAKE) -C $(BLDDIR) install-tests

clean:
	rm -rf $(TARBALL) $(BLDDIR) *~
