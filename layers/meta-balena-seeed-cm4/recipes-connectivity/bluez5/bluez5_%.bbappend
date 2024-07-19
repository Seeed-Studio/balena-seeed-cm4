FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove = "file://0004-Move-the-43xx-firmware-into-lib-firmware.patch"
SRC_URI:append = "file://0004-Move-the-hciattach-firmware-into-lib-firmware.patch"
