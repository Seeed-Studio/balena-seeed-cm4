SUMMARY = "Hailo8 firmware"
LICENSE = "CLOSED"
SRC_URI = "file://hailo8_fw.bin"

S = "${UNPACKDIR}"

do_install() {
    install -d ${D}/usr/lib/firmware/hailo
    install -m 0644 ${UNPACKDIR}/hailo8_fw.bin ${D}/usr/lib/firmware/hailo/
}

FILES:${PN} += "/usr/lib/firmware/hailo/hailo8_fw.bin"
