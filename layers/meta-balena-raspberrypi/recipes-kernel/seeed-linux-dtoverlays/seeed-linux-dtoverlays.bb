SUMMARY = "seeed reterminal device tree overlay"
DESCRIPTION = "include all the device dtoverlay of reterminal"
HOMEPAGE = "https://github.com/Seeed-Studio/seeed-linux-dtoverlays"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

inherit linux-kernel-base module-base deploy

KERNEL_VERSION = "${@get_kernelversion_file("${STAGING_KERNEL_BUILDDIR}")}"

SRCREV = "${AUTOREV}"

SRC_URI = "git://github.com/Seeed-Studio/seeed-linux-dtoverlays.git;protocol=https;branch=master \
    file://0001-compatible-for-yocto.patch \
    "

DEPENDS += " dtc-native"


INSANE_SKIP:${PN} = "file-rdeps buildpaths"

do_compile() {

    # The R110x overlay's sdhost fragments (SD card slot on GPIO 22-27)
    # kill the 6.12 kernel before earlycon on CM4 boards: the serial
    # console stays silent right after "Starting kernel ..." and the
    # device looks completely dead. Drop the fragments and their
    # overrides; the slot is non-essential (OS boots from eMMC).
    python3 - <<'PYEOF'
p = "overlays/rpi/reComputer-R110x-overlay.dts"
s = open(p).read()
for name in ("fragment@1a", "fragment@1b"):
    start = s.find("\t" + name + " {")
    if start < 0:
        continue
    i = s.find("{", start)
    depth = 0
    for j in range(i, len(s)):
        if s[j] == "{":
            depth += 1
        elif s[j] == "}":
            depth -= 1
            if depth == 0:
                end = s.find("\n", j) + 1
                s = s[:start] + s[end:]
                break
s = "\n".join(l for l in s.split("\n") if "&frag0>" not in l)
open(p, "w").write(s)
PYEOF

    # Check if the source file exists before renaming
    if [ -f overlays/rpi/reComputer-R100x-overlay.dts ]; then
        mv overlays/rpi/reComputer-R100x-overlay.dts overlays/rpi/reComputer-R100x-1.1-overlay.dts
    else
        echo "File overlays/rpi/reComputer-R100x-overlay.dts does not exist"
        echo "Available .dts files in overlays/rpi/:"
        find overlays/rpi/ -name "*.dts" 2>/dev/null || echo "No .dts files found"
    fi
    oe_runmake \
        ARCH=${ARCH} \
        KBUILD=${STAGING_KERNEL_DIR} \
        O=${STAGING_KERNEL_BUILDDIR} \
        CROSS_COMPILE=${TARGET_PREFIX} \
        all_rpi
}

do_install() {
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/
    # Load ch34x before cdc_acm so WCH chips bind to it (ttyCH343USB*)
    # instead of racing cdc_acm (ttyACM*), same pattern as sd8887-nxp.
    install -d ${D}${sysconfdir}/modprobe.d
    echo "softdep cdc_acm pre: ch34x" > ${D}${sysconfdir}/modprobe.d/ch34x.conf
    oe_runmake \
        ARCH=${ARCH} \
        KBUILD=${STAGING_KERNEL_DIR} \
        CROSS_COMPILE=${TARGET_PREFIX} \
        KO_DIR=${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/ \
        install_rpi
    
    # Install device tree overlay files to package
    install -d ${D}${DEPLOYDIR}
    if [ -d overlays/rpi ]; then
        for dtbo in overlays/rpi/*.dtbo; do
            if [ -f "$dtbo" ]; then
                dtbo_name=$(basename "$dtbo")
                # Remove '-overlay' suffix if present for standard naming
                target_name=$(echo "$dtbo_name" | sed 's/-overlay\.dtbo$/.dtbo/')
                install -m 0644 "$dtbo" "${D}${DEPLOYDIR}/$target_name"
            fi
        done
    fi
}

do_deploy() {
    # Deploy device tree overlay files to main deploy directory
    if [ -d overlays/rpi ]; then
        for dtbo in overlays/rpi/*.dtbo; do
            if [ -f "$dtbo" ]; then
                dtbo_name=$(basename "$dtbo")
                # Remove '-overlay' suffix if present for standard naming
                target_name=$(echo "$dtbo_name" | sed 's/-overlay\.dtbo$/.dtbo/')
                install -m 0644 "$dtbo" "${DEPLOYDIR}/$target_name"
            fi
        done
    fi

    # The RPi boot firmware uses a dotted dtoverlay name verbatim (it never
    # appends .dtbo) and silently drops overlong dtoverlay lines, so deploy
    # the reComputer-R100x v1.1 overlay under a short, dot-free alias that
    # config.txt can load reliably.
    if [ "${MACHINE}" = "seeed-recomputer-r100x" ] && [ -f "${DEPLOYDIR}/reComputer-R100x-1.1.dtbo" ]; then
        install -m 0644 "${DEPLOYDIR}/reComputer-R100x-1.1.dtbo" "${DEPLOYDIR}/r100x-v11.dtbo"
    fi
}

addtask deploy before do_build after do_compile

FILES:${PN} += "${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/*"
FILES:${PN} += "${sysconfdir}/modprobe.d/ch34x.conf"
FILES:${PN} += "${DEPLOYDIR}/*"
