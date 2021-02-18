FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI = "git://github.com/foonathan/memory.git;protocol=https;branch=main;name=main \
    git://github.com/foonathan/compatibility.git;protocol=https;name=comp;destsuffix=git/cmake/comp \
    git://github.com/catchorg/Catch2.git;protocol=https;branch=v2.x;name=catch;destsuffix=git/catch-upstream \
    file://catch_header.patch \
"

SRCREV_catch = "ff349a50bfc6214b4081f4ca63c7de35e2162f60"

do_configure_prepend() {
    mkdir -p ${S}/test
    cp -v ${S}/catch-upstream/single_include/catch2/catch.hpp ${S}/test
}
