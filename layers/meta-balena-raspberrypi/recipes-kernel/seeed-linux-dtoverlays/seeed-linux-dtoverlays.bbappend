# balenaOS-specific additions to the seeed-linux-dtoverlays recipe owned by
# the meta-seeed-cm4 submodule. The recipe itself (source, patches, compile
# and install flow) lives in meta-seeed-cm4; this append carries only what
# the balenaOS boot flow needs on top of it.

INSANE_SKIP:${PN} += "buildpaths"

do_compile:prepend() {
    # The R110x overlay's sdhost fragments (SD card slot on GPIO 22-27)
    # kill the 6.12 kernel before earlycon on CM4 boards: the serial
    # console stays silent right after "Starting kernel ..." and the
    # device looks completely dead. Drop the fragments and their
    # overrides; the slot is non-essential (OS boots from eMMC).
    # (balenaOS runs the 6.12 kernel pinned by this layer's layer.conf;
    # the standalone build on main uses a newer kernel where this does
    # not apply.)
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
}
