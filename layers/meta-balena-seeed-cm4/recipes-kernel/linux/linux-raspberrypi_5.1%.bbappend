FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
        file://0001-modify-makefile-for-reterminal.patch \
        "

do_configure[network] = "1"
do_configure:append(){
        if [ -d ${WORKDIR}/seeed/ ]; then
                rm -r ${WORKDIR}/seeed/
        fi
        mkdir -p ${WORKDIR}/seeed/

        wget -P ${WORKDIR}/seeed/ \
                https://raw.githubusercontent.com/Seeed-Studio/seeed-linux-dtoverlays/master/overlays/rpi/reComputer-R100x-overlay.dts
        cp ${WORKDIR}/seeed/reComputer-R100x-overlay.dts ${S}/arch/arm/boot/dts/overlays/
}
