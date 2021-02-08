# Copyright (c) 2020 LG Electronics, Inc.

# Make this conditional on meta-qt5, because otherwise builds without
# meta-qt5 give the error "Could not inherit file classes/cmake_qt5.bbclass"
inherit ${@bb.utils.contains('BBFILE_COLLECTIONS', 'qt5-layer', 'cmake_qt5', '', d)}

# Copyright (c) 2020 Wind River Systems, Inc.
export PYTHONPATH = "${STAGING_DIR_HOST}${PYTHON_SITEPACKAGES_DIR}"
