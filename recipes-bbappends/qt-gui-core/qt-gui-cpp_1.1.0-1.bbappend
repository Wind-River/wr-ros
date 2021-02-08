# Copyright (c) 2021 Wind River Systems, Inc.
OECMAKE_GENERATOR="Unix Makefiles"

# Add python3-pyqt5-native to import QtCore from PyQt5 error
ROS_BUILD_DEPENDS += " python3-pyqt5-native"

# Add sip3 for sipconfig.py
ROS_BUILD_DEPENDS += " sip3"

# Patch git/src/qt_gui_cpp_sip/CMakeLists.txt to add SIP_CONFIGURE in build_sip_binding
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://set-sip-configure.patch"

# sip_configure.py calls "qmake -query" for variables to generate the src/qt_gui_cpp_sip/Makefile
# Inherit qmake5 to generate qt.conf so that qmake overrides the built-in paths
inherit qmake5_base

do_configure_append() {
    generate_qt_config_file_paths
    generate_qt_config_file_effective_paths

    # Copy sip_configure.py from recipe-sysroot-native to ${S}/src/qt_gui_cpp_sip
    # ./recipe-sysroot/usr/share/python_qt_binding/cmake/sip_configure.py
    cp ${RECIPE_SYSROOT}${datadir}/python_qt_binding/cmake/sip_configure.py ${S}/src/qt_gui_cpp_sip/sip_configure.py
    sed -i -e "s@'-query'@'-query','-qtconf','${OE_QMAKE_QTCONF_PATH}'@g" ${S}/src/qt_gui_cpp_sip/sip_configure.py

    # Copy sipconfig.py from recipe-sysroot to ${S}/src/qt_gui_cpp_sip
    # ./recipe-sysroot/usr/lib64/python3.7/site-packages/sipconfig.py
    cp ${RECIPE_SYSROOT}${PYTHON_SITEPACKAGES_DIR}/sipconfig.py ${S}/src/qt_gui_cpp_sip/sipconfig.py

    # Ensure that sipconfig execute the native sip binary
    sed -i -e 's@${RECIPE_SYSROOT}${bindir}/sip@${RECIPE_SYSROOT_NATIVE}${bindir}/sip@g' ${S}/src/qt_gui_cpp_sip/sipconfig.py

    # Add the recipe-sysroot prefix for X11R6 and OpenGL include and library directories
    sed -i -e "s@'/usr/X11R6/@'${RECIPE_SYSROOT}/usr/X11R6/@g" ${S}/src/qt_gui_cpp_sip/sipconfig.py
}

DEPENDS_append_class-target = " chrpath-replacement-native"

do_install_append() {
    # Ensure the host rpath doesn't get included in libqt_gui_cpp_sip.so
    chrpath --delete ${D}${PYTHON_SITEPACKAGES_DIR}/qt_gui_cpp/libqt_gui_cpp_sip.so
}
