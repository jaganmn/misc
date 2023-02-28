PREFIX = /usr/local

AUTOFLAGS = --prefix=$(PREFIX) --with-pic --enable-static --disable-shared

AUTOFLAGS_MESON = --prefix $(PREFIX) --buildtype release --default-library static -Dc_args="$(CPPFLAGS) $(CFLAGS)" -Dcpp_args="$(CPPFLAGS) $(CXXFLAGS)" -Dc_link_args="$(LDFLAGS) $(LIBS)" -Dcpp_link_args="$(LDFLAGS) $(LIBS)"

AUTOFLAGS_CMAKE = -DCMAKE_INSTALL_PREFIX=$(PREFIX) -DCMAKE_INSTALL_NAME_DIR=$(PREFIX)/lib -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="$(CPPFLAGS) $(CFLAGS)" -DCMAKE_CXX_FLAGS="$(CPPFLAGS) $(CXXFLAGS)" -DCMAKE_EXE_LINKER_FLAGS="$(LDFLAGS) $(LIBS)" -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0

CC = clang

CXX = clang++

CFLAGS = -arch arm64 -mmacosx-version-min=11.0 -g -O2 -falign-functions=8 -fpic -Wno-error=implicit-function-declaration

CXXFLAGS = -arch arm64 -mmacosx-version-min=11.0 -g -O2 -falign-functions=8 -fpic

CPPFLAGS = -I$(PREFIX)/include

LDFLAGS = -L$(PREFIX)/lib -framework CoreFoundation -framework SystemConfiguration

LIBS =

PKG_CONFIG_PATH = $(PREFIX)/lib/pkgconfig:$(PREFIX)/share/pkgconfig:/usr/lib/pkgconfig


export CC
export CXX
export CFLAGS
export CXXFLAGS
export CPPFLAGS
export LDFLAGS
export LIBS
export PKG_CONFIG_PATH


.PHONY: all
all:
	# do nothing

.PHONY: toutes
toutes:
	$(MAKE) JAGS
	$(MAKE) MacTeX
	$(MAKE) XQuartz
	$(MAKE) pandoc
	$(MAKE) pkg-config
	$(MAKE) make
	$(MAKE) libiconv
	$(MAKE) gettext
	$(MAKE) libiconv
	$(MAKE) gettext
	$(MAKE) make
	$(MAKE) libunistring
	$(MAKE) icu
	$(MAKE) texinfo
	$(MAKE) readline
	$(MAKE) m4
	$(MAKE) autoconf
	$(MAKE) automake
	$(MAKE) gmp
	$(MAKE) mpfr
	$(MAKE) mpc
	$(MAKE) isl
	$(MAKE) gsl
	$(MAKE) glpk
	$(MAKE) libdeflate
	$(MAKE) zlib
	$(MAKE) pcre2
	$(MAKE) libidn2
	$(MAKE) openssl
	$(MAKE) wget
	$(MAKE) brotli
	$(MAKE) bzip2
	$(MAKE) lz4
	$(MAKE) xz
	$(MAKE) zstd
	$(MAKE) libssh2
	$(MAKE) libxml2
	$(MAKE) expat
	$(MAKE) curl
	$(MAKE) libpng
	$(MAKE) jpeg
	$(MAKE) tiff
	$(MAKE) libwebp
	$(MAKE) tiff
	$(MAKE) libffi
	$(MAKE) pixman
	$(MAKE) glib
	$(MAKE) freetype
	$(MAKE) harfbuzz
	$(MAKE) freetype
	$(MAKE) fontconfig
	$(MAKE) fribidi
	$(MAKE) cairo
	$(MAKE) harfbuzz
	$(MAKE) pango
	$(MAKE) ghostscript
	$(MAKE) qpdf
	$(MAKE) sqlite
	$(MAKE) apr
	$(MAKE) apr-util
	$(MAKE) serf
	$(MAKE) subversion
	$(MAKE) tidy-html5

.PHONY: JAGS
JAGS: ver = 4.3.1
JAGS:
	installer -pkg $@-$(ver).pkg -target /

.PHONY: MacTeX
MacTeX: ver =
MacTeX:
	installer -pkg $@.pkg -target /

.PHONY: XQuartz
XQuartz: ver = 2.8.5
XQuartz:
	installer -pkg $@-$(ver).pkg -target /

.PHONY: pandoc
pandoc: ver = 3.0.1
pandoc:
	installer -pkg $@-$(ver)-macOS.pkg -target /

.PHONY: pkg-config
pkg-config: ver = 0.29.2
pkg-config: cfg = $(AUTOFLAGS) --with-internal-glib
pkg-config:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: make
make: ver = 4.4
make: cfg = $(AUTOFLAGS)
make:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: libiconv
libiconv: ver = 1.17
libiconv: cfg = $(AUTOFLAGS)
libiconv:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: gettext
gettext: ver = 0.21.1
gettext: cfg = $(AUTOFLAGS)
gettext:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install
# circular dependency on libiconv

.PHONY: libunistring
libunistring: ver = 1.1
libunistring: cfg = $(AUTOFLAGS)
libunistring:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: icu
icu: ver = release-72-1
icu: cfg = $(AUTOFLAGS) --disable-renaming
icu:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	patch -p0 < $@-$(ver).patch
	cd $@-$(ver)/icu4c/source && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: texinfo
texinfo: ver = 7.0
texinfo: cfg = $(AUTOFLAGS)
texinfo:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: readline
readline: ver = 8.2
readline: cfg = $(AUTOFLAGS)
readline:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: m4
m4: ver = 1.4.19
m4: cfg = $(AUTOFLAGS)
m4:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: autoconf
autoconf: ver = 2.71
autoconf: cfg = $(AUTOFLAGS)
autoconf:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: automake
automake: ver = 1.16.5
automake: cfg = $(AUTOFLAGS)
automake:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: bison
bison: ver = 3.8
bison: cfg = $(AUTOFLAGS)
bison:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install
# FIXME: error due to duplicate symbols in libbison.a, libtextstyle.a

.PHONY: gmp
gmp: ver = 6.2.1
gmp: cfg = $(AUTOFLAGS)
gmp:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: mpfr
mpfr: ver = 4.2.0
mpfr: cfg = $(AUTOFLAGS)
mpfr:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: mpc
mpc: ver = 1.3.1
mpc: cfg = $(AUTOFLAGS)
mpc:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: isl
isl: ver = 0.25
isl: cfg = $(AUTOFLAGS)
isl:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: gsl
gsl: ver = 2.7
gsl: cfg = $(AUTOFLAGS)
gsl:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: glpk
glpk: ver = 5.0
glpk: cfg = $(AUTOFLAGS) --with-gmp
glpk:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: libdeflate
libdeflate: ver = 1.17
libdeflate: cfg = $(AUTOFLAGS_CMAKE)
libdeflate:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: zlib
zlib: ver = 1.2.13
zlib: cfg = --prefix=$(PREFIX) --static
zlib:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: pcre2
pcre2: ver = 10.42
pcre2: cfg = $(AUTOFLAGS) --disable-jit
pcre2:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: libidn2
libidn2: ver = 2.3.4
libidn2: cfg = $(AUTOFLAGS)
libidn2:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: openssl
openssl: ver = 3.0.7
openssl: cfg = --prefix=$(PREFIX) enable-pic no-shared
openssl:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./Configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: wget
wget: ver = 1.21
wget: cfg = $(AUTOFLAGS) --with-ssl=openssl
# wget: export CPPFLAGS += $(shell pkg-config --cflags libidn2)
# wget: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other libidn2)
# wget: export LIBS += $(shell pkg-config --static --libs-only-l libidn2)
wget:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	patch -p0 < $@-$(ver).patch
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install
# FIXME: error due to duplicate symbols in libgnu.a, libidn2.a

.PHONY: brotli
brotli: ver = 1.0.9
brotli: cfg = $(AUTOFLAGS_CMAKE)
brotli:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: bzip2
bzip2: ver = 1.0.8
bzip2: cfg =
bzip2:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && $(MAKE) && $(MAKE) install prefix=$(PREFIX)

.PHONY: lz4
lz4: ver = 1.9.4
lz4: cfg =
lz4:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	patch -p0 < $@-$(ver).patch
	cd $@-$(ver) && $(MAKE) && $(MAKE) install prefix=$(PREFIX)

.PHONY: xz
xz: ver = 5.4.1
xz: cfg = $(AUTOFLAGS)
xz:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: zstd
zstd: ver = 1.5.2
zstd: cfg =
zstd:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	patch -p0 < $@-$(ver).patch
	cd $@-$(ver) && $(MAKE) && $(MAKE) install prefix=$(PREFIX)

.PHONY: libssh2
libssh2: ver = 1.10.0
libssh2: cfg = $(AUTOFLAGS) --with-crypto=openssl
libssh2:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: libxml2
libxml2: ver = 2.10.3
libxml2: cfg = $(AUTOFLAGS)
libxml2: export PKG_CONFIG_PATH := $(PKG_CONFIG_PATH):/System/Library/Frameworks/Python.framework/Versions/2.7/lib/pkgconfig
libxml2:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: expat
expat: ver = 2.5.0
expat: cfg = $(AUTOFLAGS)
expat:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: curl
curl: ver = 7.87.0
curl: cfg = $(AUTOFLAGS) --with-openssl --with-zlib --with-zstd --with-libssh2
curl: export CPPFLAGS += $(shell pkg-config --cflags libidn2)
curl: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other libidn2)
curl: export LIBS += $(shell pkg-config --static --libs-only-l libidn2)
curl:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: libpng
libpng: ver = 1.6.39
libpng: cfg = $(AUTOFLAGS)
libpng:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: jpeg
jpeg: ver = 9e
jpeg: cfg = $(AUTOFLAGS)
jpeg:
	rm -rf $@-$(ver)
	tar -xvf $@src.v$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: tiff
tiff: ver = 4.5.0
tiff: cfg = $(AUTOFLAGS)
tiff: export CPPFLAGS += -I/opt/X11/include
tiff: export LDFLAGS += -L/opt/X11/lib
tiff:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: libwebp
libwebp: ver = 1.3.0
libwebp: cfg = $(AUTOFLAGS)
libwebp: export CPPFLAGS += $(shell pkg-config --cflags libpng)
libwebp: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other libpng)
libwebp: export LIBS += $(shell pkg-config --static --libs-only-l libpng)
libwebp:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install
# circular dependency on tiff

.PHONY: libffi
libffi: ver = 3.4.4
libffi: cfg = $(AUTOFLAGS)
libffi:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: pixman
pixman: ver = 0.42.2
pixman: cfg = $(AUTOFLAGS) --disable-arm-neon --disable-arm-a64-neon
pixman:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: glib
glib: ver = 2.74.5
glib: cfg = $(AUTOFLAGS_MESON)
glib:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && meson setup $(cfg) _build && meson compile -C _build && meson install -C _build

.PHONY: freetype
freetype: ver = 2.12.1
freetype: cfg = $(AUTOFLAGS)
freetype:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: harfbuzz
harfbuzz: ver = 6.0.0
harfbuzz: cfg = $(AUTOFLAGS_MESON)
harfbuzz: export CPPFLAGS += $(shell pkg-config --silence-errors --cflags cairo)
harfbuzz: export LDFLAGS += $(shell pkg-config --silence-errors --static --libs-only-L --libs-only-other cairo)
harfbuzz: export LIBS += $(shell pkg-config --silence-errors --static --libs-only-l cairo)
harfbuzz:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && meson setup $(cfg) _build && meson compile -C _build && meson install -C _build
# circular dependency on freetype

.PHONY: fontconfig
fontconfig: ver = 2.14.2
fontconfig: cfg = $(AUTOFLAGS) --with-default-fonts=/usr/X11/lib/X11/fonts --with-add-fonts=/System/Library/Fonts,/Library/Fonts,~/Library/Fonts
fontconfig:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: fribidi
fribidi: ver = 1.0.12
fribidi: cfg = $(AUTOFLAGS)
fribidi:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: cairo
cairo: ver = 1.16.0
cairo: cfg = $(AUTOFLAGS) --x-includes=/opt/X11/include --x-libraries=/opt/X11/lib --disable-qt --disable-quartz --disable-quartz-font --disable-quartz-image
cairo:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install
# circular dependency on harfbuzz

.PHONY: pango
pango: ver = 1.50.12
pango: cfg = $(AUTOFLAGS_MESON)
pango: export CPPFLAGS += $(shell pkg-config --cflags cairo)
pango: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other cairo)
pango: export LIBS += $(shell pkg-config --static --libs-only-l cairo)
pango:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && meson setup $(cfg) _build && meson compile -C _build && meson install -C _build

.PHONY: ghostscript
ghostscript: ver = 10.0.0
ghostscript: cfg = $(AUTOFLAGS) --x-includes=/opt/X11/include --x-libraries=/opt/X11/lib
ghostscript: export CPPFLAGS += $(shell pkg-config --static --cflags fontconfig)
ghostscript: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other fontconfig)
ghostscript: export LIBS += $(shell pkg-config --static --libs-only-l fontconfig)
ghostscript:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: qpdf
qpdf: ver = 11.2.0
qpdf: cfg = $(AUTOFLAGS_CMAKE)
qpdf:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: sqlite
sqlite: ver = autoconf-3400100
sqlite: cfg = $(AUTOFLAGS) --enable-rtree
sqlite: export CPPFLAGS += -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_COLUMN_METADATA
sqlite:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: apr
apr: ver = 1.7.2
apr: cfg = $(AUTOFLAGS)
apr:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: apr-util
apr-util: ver = 1.6.3
apr-util: cfg = $(AUTOFLAGS) --with-apr=/usr/local --with-crypto --with-openssl=/usr/local
apr-util:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: serf
serf: ver = 1.3.9
serf: cfg = PREFIX=$(PREFIX) APR=$(PREFIX) APU=$(PREFIX) OPENSSL=$(PREFIX)
serf:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	patch -p0 < $@-$(ver).patch
	cd $@-$(ver) && scons $(cfg) && scons install
# FIXME: scons does not see environment variables

.PHONY: subversion
subversion: ver = 1.14.2
subversion: cfg = $(AUTOFLAGS) --with-utf8proc=internal
subversion:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: tidy-html5
tidy-html5: ver = 5.8.0
tidy-html5: cfg = $(AUTOFLAGS_CMAKE)
tidy-html5:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install
