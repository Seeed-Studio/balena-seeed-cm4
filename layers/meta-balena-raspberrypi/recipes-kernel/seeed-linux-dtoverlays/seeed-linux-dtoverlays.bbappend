# balenaOS-specific additions to the seeed-linux-dtoverlays recipe owned by
# the meta-seeed-cm4 submodule. The recipe itself (source, patches, compile
# and install flow) lives in meta-seeed-cm4; this append carries only what
# the balenaOS boot flow needs on top of it.

INSANE_SKIP:${PN} += "buildpaths"

do_compile:prepend() {
    # Rename the R100x overlay source to its v1.1 identity before the
    # tree is built, so the deployed artifact is
    # reComputer-R100x-1.1.dtbo.
    if [ -f overlays/rpi/reComputer-R100x-overlay.dts ]; then
        mv overlays/rpi/reComputer-R100x-overlay.dts overlays/rpi/reComputer-R100x-1.1-overlay.dts
    else
        echo "File overlays/rpi/reComputer-R100x-overlay.dts does not exist"
        echo "Available .dts files in overlays/rpi/:"
        find overlays/rpi/ -name "*.dts" 2>/dev/null || echo "No .dts files found"
    fi
}

do_install:append() {
    # Load ch34x before cdc_acm so WCH chips bind to it (ttyCH343USB*)
    # instead of racing cdc_acm (ttyACM*).
    install -d ${D}${sysconfdir}/modprobe.d
    echo "softdep cdc_acm pre: ch34x" > ${D}${sysconfdir}/modprobe.d/ch34x.conf
}

do_deploy:append() {
    # The RPi boot firmware uses a dotted dtoverlay name verbatim (it never
    # appends .dtbo) and silently drops overlong dtoverlay lines, so deploy
    # the reComputer-R100x v1.1 overlay under a short, dot-free alias that
    # config.txt (this layer's rpi-config bbappend) can load reliably.
    if [ "${MACHINE}" = "seeed-recomputer-r100x" ] && [ -f "${DEPLOYDIR}/reComputer-R100x-1.1.dtbo" ]; then
        install -m 0644 "${DEPLOYDIR}/reComputer-R100x-1.1.dtbo" "${DEPLOYDIR}/r100x-v11.dtbo"
    fi

    # On reComputer-R2x the meta-seeed-cm4 kernel bbappend copies the
    # reComputer-R2x-base and reComputer-R21 overlay sources into the
    # kernel tree, and this layer's do_overlays then builds and deploys
    # them with the kernel. Deploying them here as well makes
    # linux-raspberrypi:do_deploy fail with "trying to install files into
    # a shared area when those files already exist", so leave these two to
    # the kernel. BALENA_BOOT_PARTITION_FILES only names the files, not
    # the recipe that deploys them.
    if [ "${MACHINE}" = "seeed-recomputer-r2x" ]; then
        rm -f "${DEPLOYDIR}/reComputer-R2x-base.dtbo" "${DEPLOYDIR}/reComputer-R21.dtbo"
    fi
}
