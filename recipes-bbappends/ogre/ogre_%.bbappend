FILES_${PN} += "${nonarch_libdir}/OGRE ${nonarch_libdir}/lib*.so"

DEPENDS += "virtual/libsdl2 freetype virtual/libgl libglu qtbase"

# matches with tag 1.12.6
# SRCREV = "c1ead4007d6f5552bacd9934a289e4f78b8ecbc2"
SRCREV = ""
SRC_URI = "git://github.com/OGRECave/ogre;protocol=https;tag=v1.12.8;name=ogre \
    file://0001-CMakeLists.txt-don-t-set-RPATH.patch \
    git://github.com/ocornut/imgui;protocol=https;tag=v1.79;name=imgui;destsuffix=git/Components/Overlay/src/imgui \
"
