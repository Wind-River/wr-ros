FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://add_aarch64_check.patch"

FILES_${PN} += "${nonarch_libdir}/lib*.so"
ROS_BUILD_DEPENDS += "freeglut"
ROS_EXEC_DEPENDS += "freeglut"
