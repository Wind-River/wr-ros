# Copyright (c) 2020 LG Electronics, Inc.

# Make this conditional on meta-qt5, because otherwise builds without
# meta-qt5 give the error "Could not inherit file classes/cmake_qt5.bbclass"
inherit ${@bb.utils.contains('BBFILE_COLLECTIONS', 'qt5-layer', 'cmake_qt5', '', d)}

# Copyright (c) 2020 Wind River Systems, Inc.
DEPENDS_append_class-target = " chrpath-replacement-native"

do_install_append() {
    # Ensure the host rpath doesn't get included in libqt_gui_cpp_sip.so
    chrpath --delete ${D}${nonarch_libdir}/rviz2/rviz2 ${D}${bindir}/rviz2
}
