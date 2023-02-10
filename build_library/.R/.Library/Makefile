PREFIX = /opt/R/arm64

AUTOFLAGS = --prefix=$(PREFIX) --with-pic --enable-static --disable-shared

AUTOFLAGS_MESON = --prefix $(PREFIX) --buildtype release --default-library static -Dc_args="$(CPPFLAGS) $(CFLAGS)" -Dcpp_args="$(CPPFLAGS) $(CXXFLAGS)" -Dc_link_args="$(LDFLAGS) $(LIBS)" -Dcpp_link_args="$(LDFLAGS) $(LIBS)"

AUTOFLAGS_CMAKE = -DCMAKE_INSTALL_PREFIX=$(PREFIX) -DCMAKE_INSTALL_NAME_DIR=$(PREFIX)/lib -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="$(CPPFLAGS) $(CFLAGS)" -DCMAKE_CXX_FLAGS="$(CPPFLAGS) $(CXXFLAGS)" -DCMAKE_EXE_LINKER_FLAGS="$(LDFLAGS) $(LIBS)" -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0

CC = clang

CXX = clang++

CFLAGS = -arch arm64 -mmacosx-version-min=11.0 -g -O2 -falign-functions=8 -fpic -Wno-error=implicit-function-declaration

CXXFLAGS = -arch arm64 -mmacosx-version-min=11.0 -g -O2 -falign-functions=8 -fpic

CPPFLAGS = -I$(PREFIX)/include -I/usr/local/include

LDFLAGS = -L$(PREFIX)/lib -L/usr/local/include -framework CoreFoundation -framework SystemConfiguration

LIBS =

PKG_CONFIG_PATH = $(PREFIX)/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig


export CC
export CXX
export CFLAGS
export CXXFLAGS
export CPPFLAGS
export LDFLAGS
export LIBS
export PKG_CONFIG_PATH


all:
	# do nothing

.PHONY: toutes
toutes:
	$(MAKE) boost
	$(MAKE) szip
	$(MAKE) hdf
	$(MAKE) hdf5
	$(MAKE) netcdf
	$(MAKE) proj
	$(MAKE) libgeotiff
	$(MAKE) geos
	$(MAKE) openjpeg
	$(MAKE) poppler
	$(MAKE) postgresql
	$(MAKE) unixODBC
	$(MAKE) gdal
	$(MAKE) fftw
	$(MAKE) nlopt
	$(MAKE) udunits
	$(MAKE) zeromq

.PHONY: apache-arrow
apache-arrow: ver = 11.0.0
apache-arrow: cfg = $(AUTOFLAGS_CMAKE) -DARROW_INSTALL_NAME_RPATH=OFF
apache-arrow:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver)/cpp && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install
# FIXME: seems to need shared openssl

.PHONY: boost
boost: ver = 1_81_0
boost: cfg = --prefix=$(PREFIX) variant=release link=static cflags="$(CFLAGS)" cxxflags="$(CXXFLAGS)" include="$(CPPFLAGS)" linkflags="$(LDFLAGS) $(LIBS)"
boost:
	rm -rf $@_$(ver)
	tar -xvf $@_$(ver).tar.*
	cd $@_$(ver) && ./bootstrap.sh && ./b2 $(cfg) && ./b2 install

.PHONY: szip
szip: ver = 2.1.1
szip: cfg = $(AUTOFLAGS)
szip:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: hdf
hdf: ver = 4.2.13
hdf: cfg = $(AUTOFLAGS) --with-jpeg=/usr/local --with-zlib=/usr/local --with-szlib=$(PREFIX) --enable-production --disable-fortran --disable-netcdf
hdf:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: hdf5
hdf5: ver = 1.10.9
hdf5: cfg = $(AUTOFLAGS) --with-zlib=/usr/local --with-szlib=$(PREFIX) --enable-build-mode=production --enable-cxx
hdf5:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: netcdf
netcdf: ver = c-4.9.0
netcdf: cfg = $(AUTOFLAGS) --enable-netcdf-4
netcdf: export CPPFLAGS += $(shell pkg-config --cflags libxml-2.0)
netcdf: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other libxml-2.0)
netcdf: export LIBS += $(shell pkg-config --static --libs-only-l libxml-2.0) -lsz -lhdf5
netcdf:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: proj
proj: ver = 9.1.1
proj: cfg = $(AUTOFLAGS_CMAKE)
proj: export CPPFLAGS += $(shell pkg-config --cflags libcurl libtiff-4)
proj: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other libcurl libtiff-4)
proj: export LIBS += $(shell pkg-config --static --libs-only-l libcurl libtiff-4)
proj:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: libgeotiff
libgeotiff: ver = 1.7.1
libgeotiff: cfg = $(AUTOFLAGS) --with-jpeg --with-zlib --with-proj
libgeotiff: export CPPFLAGS += $(shell pkg-config --cflags proj)
libgeotiff: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other proj)
libgeotiff: export LIBS += $(shell pkg-config --static --libs-only-l proj)
libgeotiff:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	patch -p0 < $@-$(ver).patch
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: geos
geos: ver = 3.11.1
geos: cfg = $(AUTOFLAGS_CMAKE)
geos:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: openjpeg
openjpeg: ver = 2.5.0
openjpeg: cfg = $(AUTOFLAGS_CMAKE)
openjpeg: export CPPFLAGS += $(shell pkg-config --cflags libtiff-4)
openjpeg: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other libtiff-4)
openjpeg: export LIBS += $(shell pkg-config --static --libs-only-l libtiff-4)
openjpeg:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: poppler
poppler: ver = 23.02.0
poppler: cfg = $(AUTOFLAGS_CMAKE) -DENABLE_UNSTABLE_API_ABI_HEADERS:BOOL=On
poppler: export CPPFLAGS += $(shell pkg-config --cflags libcurl libtiff-4 cairo)
poppler: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other libcurl libtiff-4 cairo)
poppler: export LIBS += $(shell pkg-config --static --libs-only-l libcurl libtiff-4 cairo)
poppler:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: postgresql
postgresql: ver = 15.1
postgresql: cfg = $(AUTOFLAGS)
postgresql:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure && $(MAKE) MAKELEVEL=0 && $(MAKE) install

.PHONY: unixODBC
unixODBC: ver = 2.3.11
unixODBC: cfg = $(AUTOFLAGS)
unixODBC:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: gdal
gdal: ver = 3.5.3
gdal: cfg = $(AUTOFLAGS) --with-liblzma --with-poppler
gdal: export CPPFLAGS += $(shell pkg-config --cflags libtiff-4 fontconfig proj)
gdal: export LDFLAGS += $(shell pkg-config --static --libs-only-L --libs-only-other libtiff-4 fontconfig proj)
gdal: export LIBS += $(shell pkg-config --static --libs-only-l libtiff-4 fontconfig proj)
gdal:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: fftw
fftw: ver = 3.3.10
fftw: cfg = $(AUTOFLAGS)
fftw:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: nlopt
nlopt: ver = 2.7.1
nlopt: cfg = $(AUTOFLAGS_CMAKE)
nlopt:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && mkdir _build && cd _build && cmake .. $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: udunits
udunits: ver = 2.2.28
udunits: cfg = $(AUTOFLAGS)
udunits:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: zeromq
zeromq: ver = 4.3.4
zeromq: cfg = $(AUTOFLAGS)
zeromq:
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: CoinUtils
CoinUtils: ver = releases-2.11.6
CoinUtils: cfg = $(AUTOFLAGS)
CoinUtils: 
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: Osi
Osi: ver = releases-0.108.7
Osi: cfg = $(AUTOFLAGS)
Osi: 
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: Clp
Clp: ver = releases-1.17.7
Clp: cfg = $(AUTOFLAGS)
Clp: 
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: Cgl
Cgl: ver = releases-0.60.6
Cgl: cfg = $(AUTOFLAGS)
Cgl: 
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install

.PHONY: SYMPHONY
SYMPHONY: ver = releases-5.6.19
SYMPHONY: cfg = $(AUTOFLAGS)
SYMPHONY: 
	rm -rf $@-$(ver)
	tar -xvf $@-$(ver).tar.*
	cd $@-$(ver) && ./configure $(cfg) && $(MAKE) && $(MAKE) install
