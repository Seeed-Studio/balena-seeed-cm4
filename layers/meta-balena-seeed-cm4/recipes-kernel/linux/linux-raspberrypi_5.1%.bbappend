FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:seeed-recomputer-r100x:= " \
        file://0001-modify-makefile-for-recomputer-r100x.patch \
"

SRC_URI:append:seeed-recomputer-r110x:= " \
        file://0001-modify-makefile-for-recomputer-r110x.patch \
"

do_configure[network] = "1"
do_configure:append(){
        if [ -d ${WORKDIR}/seeed/ ]; then
                rm -r ${WORKDIR}/seeed/
        fi
        mkdir -p ${WORKDIR}/seeed/
        if ${@bb.utils.contains('MACHINE', 'seeed-recomputer-r100x-mender', 'true', 'false', d)} \
            || ${@bb.utils.contains('MACHINE', 'seeed-recomputer-r100x', 'true', 'false', d)}; then
            wget -P ${WORKDIR}/seeed/ \
                https://raw.githubusercontent.com/Seeed-Studio/seeed-linux-dtoverlays/master/overlays/rpi/reComputer-R100x-overlay.dts
            cp ${WORKDIR}/seeed/reComputer-R100x-overlay.dts ${S}/arch/arm/boot/dts/overlays/
        elif ${@bb.utils.contains('MACHINE', 'seeed-recomputer-r110x-mender', 'true', 'false', d)} \
            || ${@bb.utils.contains('MACHINE', 'seeed-recomputer-r110x', 'true', 'false', d)}; then
            wget -P ${WORKDIR}/seeed/ \
                https://raw.githubusercontent.com/Seeed-Studio/seeed-linux-dtoverlays/master/overlays/rpi/reComputer-R110x-overlay.dts
            cp ${WORKDIR}/seeed/reComputer-R110x-overlay.dts ${S}/arch/arm/boot/dts/overlays/
        else
            bbdebug 1 "No target device tree specified, check your MACHINE config"
        fi
}
