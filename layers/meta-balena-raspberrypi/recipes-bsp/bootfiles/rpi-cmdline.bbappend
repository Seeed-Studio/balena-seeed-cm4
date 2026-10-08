# Set console accordingly to build type
CMDLINE += " dwc_otg.lpm_enable=0 rootwait"
CMDLINE += "${OS_KERNEL_CMDLINE}"

# Add earlycon with OS_DEVELOPMENT=1
# PL011 earlycon: the debug UART on the CM4-based Seeed boards is GPIO14/15
# owned by the PL011 (ttyAMA0); the mini-UART at 0xfe215040 has no pins there.
CMDLINE:prepend:raspberrypi4-64 = " ${@bb.utils.contains('DISTRO_FEATURES','osdev-image',"earlycon=pl011,mmio32,0xfe201000 console=tty1","",d)}"
CMDLINE:prepend:raspberrypi400-64 = " ${@bb.utils.contains('DISTRO_FEATURES','osdev-image',"earlycon=uart8250,mmio32,0xfe215040 console=tty1","",d)}"
CMDLINE:prepend:raspberrypicm4-ioboard = " ${@bb.utils.contains('DISTRO_FEATURES','osdev-image',"earlycon=uart8250,mmio32,0xfe215040 console=tty1","",d)}"

# See https://github.com/raspberrypi/linux/commit/9b0efcc1ec497b2985c6aaa60cd97f0d2d96d203
CMDLINE += " cgroup_enable=memory"
CMDLINE:remove = "root=/dev/mmcblk0p2"
CMDLINE_DEBUG = ""

CMDLINE:append:raspberrypi5 := " balena_stage2 maxcpus=0"
