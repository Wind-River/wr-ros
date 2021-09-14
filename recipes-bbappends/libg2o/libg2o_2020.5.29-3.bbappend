FILES_${PN} += "${nonarch_libdir}/lib*.so"
ROS_BUILD_DEPENDS += "freeglut"
ROS_EXEC_DEPENDS += "freeglut"

# Same as ypspur:
#   stage bindir as well, because g2oTargets-release.cmake checks for g2o,
#   g2o_simulator2d, g2o_simulator3d, g2o_anonymize_observations even when it's not
#   called during the build (so we don't need to use libg2o-native to provide them)
#
SYSROOT_DIRS:append = " \
    ${bindir} \
"
