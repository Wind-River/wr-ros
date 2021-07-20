# wr-ros

## Overview

wr-ros provides recipes for integrated the meta-ros layer with Wind River Linux.

## Project License

The source code for this project is provided under the MIT license.
Text for any dependencies and other applicable license notices can be found in
the LICENSE-NOTICES.txt file in the project top level directory. Different
files may be under different licenses. Each source file should include a
license notice that designates the licensing terms for the respective file.

## Prerequisites

```
URI: git://github.com/ros/meta-ros.git
branch: hardknott
```

```
URI: https://github.com/meta-qt5/meta-qt5.git
branch: hardknott
```

```
URI: https://github.com/schnitzeltony/meta-qt5-extra.git
branch: master
```

```
URI: https://github.com/IntelRealSense/meta-intel-realsense
branch: hardknott
```

## Maintenance

* Maintained by Rob Woolley <rob.woolley@windriver.com>
* Initial work done by Brendan Engleman

## Instructions

1. Download Wind River Linux LTS 21.

    Clone the Wind River Linux repository into a new project directory.
    ```
    git clone -b WRLINUX_10_21_BASE https://github.com/WindRiver-Labs/wrlinux-x.git
    ```

2. Configure Wind River Linux in a new build directory.

    ```
    mkdir wrlinux-ros2
    cd wrlinux-ros2
    ```

    For Raspberry Pi 4 use:

    ```
    ../wrlinux-x/setup.sh --machines=bcm-2xxx-rpi4 --distros=wrlinux --dl-layers
    ```

    For Intel 64 use:

    ```
    ../wrlinux-x/setup.sh --machines=intel-x86-64 --distros=wrlinux --dl-layers
    ```

3. Add the additional layers.

    ```
    cd layers
    git clone -b hardknott https://github.com/ros/meta-ros.git
    git clone https://github.com/Wind-River/meta-robot.git
    git clone https://github.com/Wind-River/wr-ros.git
    git clone -b hardknott https://github.com/IntelRealSense/meta-intel-realsense.git
    ```

4. (Optional Qt) Add the Qt5 layers.

    ```
    git clone -b hardknott https://github.com/meta-qt5/meta-qt5.git
    git clone -b master https://github.com/schnitzeltony/meta-qt5-extra.git
    ```

5. Return to the wrlinux-ros2 directory.
    ```
    cd ..
    ```

6. Initialize the build environment.
    ```
    . ./environment-setup-x86_64-wrlinuxsdk-linux
    . ./oe-init-build-env wrlinux-lts21-ros2
    ```

7. Configure Bitbake layers.
    Use bitbake-layers to add the ROS2 layers to your BitBake configuration.

    This section assumes that you have sourced the OpenEmbedded build environment in the previous step.
    ```
    cd $BUILDDIR
    bitbake-layers add-layer $(readlink -f $BUILDDIR/../layers)/meta-ros/meta-ros-common
    bitbake-layers add-layer $(readlink -f $BUILDDIR/../layers)/meta-ros/meta-ros2
    bitbake-layers add-layer $(readlink -f $BUILDDIR/../layers)/meta-ros/meta-ros2-galactic
    bitbake-layers add-layer $(readlink -f $BUILDDIR/../layers)/wr-ros
    bitbake-layers add-layer $(readlink -f $BUILDDIR/../layers)/meta-intel-realsense
    ```

9. (Optional Qt) Add the Qt5 layers.
    ```
    bitbake-layers add-layer $(readlink -f $BUILDDIR/../layers)/meta-qt5
    bitbake-layers add-layer $(readlink -f $BUILDDIR/../layers)/meta-qt5-extra
    ```

10. (Optional Qt) Download and patch the unsupported Qt5 integration for Wind River Linux.  XXX probably not needed

    ```
    cd $BUILDDIR/../layers/wrlinux

    curl -O https://labs.windriver.com/downloads/0001-wrlinux-template-add-template-qt5-for-wrlinux.patch
    git am 0001-wrlinux-template-add-template-qt5-for-wrlinux.patch

    curl -O https://labs.windriver.com/downloads/0002-wrlinux-template-add-lxqt-support-for-wrlinux.patch
    git am 0002-wrlinux-template-add-lxqt-support-for-wrlinux.patch

    cd $BUILDDIR/../layers/meta-qt5-extra

    curl -O https://labs.windriver.com/downloads/0001-polkit-qt-1-fix-compile-error.patch
    git am 0001-polkit-qt-1-fix-compile-error.patch

    cd $BUILDDIR
    ```

11. Modify local configuration.

    Enable network access for fetching source tarballs and disable all the whitelist layers.

    Add the following to the end of conf/local.conf
    ```
    BB_NO_NETWORK = '0'
    PNWHITELIST_LAYERS = ""
    DISTRO_FEATURES_append = " x11 opengl vulkan polkit"
    IMAGE_INSTALL_append += " packagegroup-ros-world"

    SYSROOT_DIRS_append += " ${nonarch_libdir} "
    FILES_${PN}-dbg += "${nonarch_libdir}/.debug"
    FILES_${PN}-dev += "${nonarch_libdir}/pkgconfig ${nonarch_libdir}/cmake"
    FILES_${PN} += "${nonarch_libdir}/lib*.so*"
    FILES_${PN} += "${nonarch_libdir}/${ROS_BPN}"
    FILES_${PN} += "${nonarch_libdir}/${PYTHON_DIR}"
    FILES_${PN}-dev += "${nonarch_libdir}/${PYTHON_DIR}/site-packages/*.la"
    FILES_${PN}-staticdev += "${nonarch_libdir}/lib*.a"
    FILES_${PN}-staticdev += "${nonarch_libdir}/${PYTHON_DIR}/site-packages/*.a"
    INSANE_SKIP_${PN}-dbg += "libdir"
    INSANE_SKIP_${PN} += "dev-so libdir"
    ```

12. (Optional Graphics) Add support for OpenGL graphics with demo examples.

    ```
    IMAGE_INSTALL_append += "\
    xserver-xorg \
    xserver-xorg-extension-glx \
    mesa \
    mesa-demos"
    ```

13. (Optional) For building applications on the device add the following lines.
    ```
    IMAGE_INSTALL_append += "\
    packagegroup-core-buildessential \
    git"
    ```

14. (Optional Qt) Add qt5 to the configuration.

    Edit the conf/local.conf again to add the following lines:
    ```
    WRTEMPLATE = "feature/qtbase"
    ROS_WORLD_SKIP_GROUPS_remove = "world-license"
    ROS_WORLD_SKIP_GROUPS_remove = "turtlebot3"
    ROS_WORLD_SKIP_GROUPS_remove = "qt-gui-cpp"
    ROS_WORLD_SKIP_GROUPS_remove = "world-license-faad"
    PACKAGECONFIG_append_pn-qtbase-native = " gui"
    ```
15. (Optional Qt) Temporarily skip qt5 and gazebo to workaround a build failure with gazebo-ros-pkgs.
    ```
    ROS_WORLD_SKIP_GROUPS += " qt5"
    # ROS_WORLD_SKIP_GROUPS_remove = "gazebo"
    ```

15. Set the license flags whitelist to allow the use of commercial graphics drivers.
    ```
    LICENSE_FLAGS_WHITELIST = "commercial"
    ```

16. Remove webots from packagegroup-ros-world-galactic.

    Edit the conf/local.conf again to add the following lines:
    ```
    ROS_WORLD_SKIP_GROUPS += "webots-python-modules"

    RDEPENDS_packagegroup-ros-world-galactic_remove += " \
        webots-ros2-epuck \
        webots-ros2-tiago \
        webots-ros2-universal-robot \
    "
    ```

17. (Optional Raspberry Pi) Edit cmdline.txt to adjust the kernel parameters.

    ```
    $ cat ../layers/bcm-2xxx-rpi/recipes-bsp/bootfiles/rpi-cmdline.bbappend
    CMDLINE_bcm-2xxx-rpi4 = "${@bb.utils.contains("DISTRO_FEATURES", "ostree", "dwc_otg.lpm_enable=0 rootwait", \
                        "dwc_otg.lpm_enable=0 console=serial0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait ip=dhcp", d)}"

    PACKAGE_ARCH_bcm-2xxx-rpi4 = "${MACHINE_ARCH}"
    $ sed -i -e 's/ ip=dhcp//' ../layers/bcm-2xxx-rpi/recipes-bsp/bootfiles/rpi-cmdline.bbappend
    ```
    Note: These changes ensure that the console output appears on the HDMI display and that the boot sequence doesn't wait for a DHCP connection.

18. Build Wind River Linux standard filesystem

    ```
    bitbake wrlinux-image-std
    ```

19. (Optional Graphics) Build Wind River Linux with graphics.
    ```
    bitbake wrlinux-image-std-sato
    ```



# Legal Notices

All product names, logos, and brands are property of their respective owners. All company,
product and service names used in this software are for identification purposes only.
Wind River and VxWorks are registered trademarks of Wind River Systems, Inc. UNIX is a
registered trademark of The Open Group.

Disclaimer of Warranty / No Support: Wind River does not provide support
and maintenance services for this software, under Wind River’s standard
Software Support and Maintenance Agreement or otherwise. Unless required
by applicable law, Wind River provides the software (and each contributor
provides its contribution) on an “AS IS” BASIS, WITHOUT WARRANTIES OF ANY
KIND, either express or implied, including, without limitation, any warranties
of TITLE, NONINFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR
PURPOSE. You are solely responsible for determining the appropriateness of
using or redistributing the software and assume any risks associated with
your exercise of permissions under the license.

