FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://disable-host-system-dirs.patch \
            file://enable-linking-octomap.patch"

inherit pkgconfig

FILES_${PN} += "${datadir}/mrpt* ${datadir}/metainfo/* ${datadir}/mime/packages/*"

EXTRA_OECMAKE += "-DCMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES:PATH='${STAGING_INCDIR}'"
