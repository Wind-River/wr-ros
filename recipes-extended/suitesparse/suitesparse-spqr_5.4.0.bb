# Copyright (c) 2019 LG Electronics, Inc.

require suitesparse-5.4.0.inc

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM += "file://Doc/License.txt;md5=1c0c48edf24526b3cda72ce1a8a20b1d"

DEPENDS = " \
    suitesparse-config \
    suitesparse-amd \
    suitesparse-colamd \
    suitesparse-cholmod \
    lapack \
"

S = "${WORKDIR}/SuiteSparse/SPQR"

SRC_URI += " \
	file://fix_config.patch;patchdir=${WORKDIR}/SuiteSparse/SuiteSparse_config \
"
EXTRA_OEMAKE = "CC='${CC}' BLAS='-lopenblas -lblas' PREFIX='${prefix}' LIBDIR='${base_libdir}'"

do_compile() {
    # build only the library, not the demo
    oe_runmake library
}

do_install() {
    oe_runmake install INSTALL=${D}${prefix}
}

DEPENDS_append_class-target = " chrpath-replacement-native"
FILES_${PN}-dev += " ${libdir}/lib${PN}.so"
FILES_${PN} += "${nonarch_libdir}/lib*.so"
