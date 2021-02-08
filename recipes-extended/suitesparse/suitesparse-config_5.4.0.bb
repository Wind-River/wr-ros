# Copyright (c) 2019 LG Electronics, Inc.

require suitesparse-5.4.0.inc

LICENSE = "PD"
LIC_FILES_CHKSUM += "file://README.txt;md5=9da0dd2832f2ab6d304cae1d28eecc11"

S = "${WORKDIR}/SuiteSparse/SuiteSparse_config"

SRC_URI += " \
	file://fix_rpath.patch \
	file://fix_libdir.patch \
	"

EXTRA_OEMAKE = "CC='${CC}' LIBDIR='${libdir}'"

do_compile() {
    # build only the library, not the demo
    oe_runmake config
    oe_runmake library
}

do_install() {
    oe_runmake install INSTALL=${D}${prefix} INSTALL_LIB=${D}${prefix}/${baselib}
}

DEPENDS_append_class-target = " chrpath-replacement-native"
