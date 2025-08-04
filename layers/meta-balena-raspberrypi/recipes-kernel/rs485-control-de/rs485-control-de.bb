SUMMARY = "A software tool for automated control of the DE pin state on RS485 devices"

LICENSE = "CLOSED"

DEPENDS += "libgpiod"

SRC_URI = "file://rs485_DE.c"

S = "${WORKDIR}"

LDFLAGS += " -Wl,--hash-style=gnu"

do_compile() {
    ${CC} ${CFLAGS} ${CPPFLAGS} -c rs485_DE.c -o rs485_DE.o
    ${CC} ${LDFLAGS} rs485_DE.o -o rs485_de -lutil -lgpiod
}

do_install() {
    install -d ${D}/usr/bin
    install -m 0777 rs485_de ${D}/usr/bin/rs485_de

}

FILES_${PN} = "/usr/bin/rs485_de"