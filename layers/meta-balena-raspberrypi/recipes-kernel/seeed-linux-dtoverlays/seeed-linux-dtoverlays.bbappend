# balenaOS-specific additions to the seeed-linux-dtoverlays recipe owned by
# the meta-seeed-cm4 submodule. The recipe itself (source, patches, compile
# and install flow) lives in meta-seeed-cm4; this append carries only what
# the balenaOS boot flow needs on top of it.

INSANE_SKIP:${PN} += "buildpaths"

do_install:append() {
    # Load ch34x before cdc_acm so WCH chips bind to it (ttyCH343USB*)
    # instead of racing cdc_acm (ttyACM*).
    install -d ${D}${sysconfdir}/modprobe.d
    echo "softdep cdc_acm pre: ch34x" > ${D}${sysconfdir}/modprobe.d/ch34x.conf
}
