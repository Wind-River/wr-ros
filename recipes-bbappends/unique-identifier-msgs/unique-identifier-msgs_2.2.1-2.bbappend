FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://fix-dependencies.patch"

FILES_${PN} += "${nonarch_libdir}/lib*.so"

ROS_BUILD_DEPENDS += " \
    builtin-interfaces \
    rosidl-typesupport-fastrtps-c-native \
    rosidl-typesupport-fastrtps-cpp-native \
"

ROS_EXPORT_DEPENDS += " \
    builtin-interfaces \
"

ROS_EXEC_DEPENDS += " \
    builtin-interfaces \
"
