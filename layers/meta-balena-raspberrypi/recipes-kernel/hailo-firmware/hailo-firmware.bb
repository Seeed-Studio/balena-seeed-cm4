SUMMARY = "Hailo8 firmware"
LICENSE = "CLOSED"
SRC_URI = "file://hailo8_fw.bin"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/usr/lib/firmware/hailo
    install -m 0644 ${WORKDIR}/hailo8_fw.bin ${D}/usr/lib/firmware/hailo/
}

FILES:${PN} += "/usr/lib/firmware/hailo/hailo8_fw.bin"
