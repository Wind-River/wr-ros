# From omxplayer_git.bb
# Needed in ffmpeg configure
export TEMPDIR = "${B}/tmp"

do_configure_prepend() {
    # Needed for compiler test in ffmpeg's configure
    mkdir -p ${B}/tmp
}
