require python-pyqt5.inc

inherit python3native python3-dir native

DEPENDS += "sip3 sip3-native python3 qtdeclarative-native"

RDEPENDS_${PN} += "python3-core python3-sip3"

DISABLED_FEATURES += "PyQt_SSL"

B = "${S}"

# qmake5_base_native_do_install_prepend() {
#    # Fix install paths for all
#    find . -name "Makefile*" | xargs -r sed -i "s,(INSTALL_ROOT)${D},(INSTALL_ROOT),g"
# }

qmake5_base_native_do_install() {
    # oe_runmake install INSTALL_ROOT=${D}
    oe_runmake install
    find "${D}" -ignore_readdir_race -name "*.la" -delete
    if ls ${D}${libdir}/pkgconfig/Qt5*.pc >/dev/null 2>/dev/null; then
        sed -i "s@-L${STAGING_LIBDIR}@-L\${libdir}@g" ${D}${libdir}/pkgconfig/Qt5*.pc
    fi
}
