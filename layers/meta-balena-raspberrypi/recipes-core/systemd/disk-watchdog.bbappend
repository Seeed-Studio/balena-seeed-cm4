# On CM4-based Seeed boards the /dev/disk/by-state/* udev links never get
# created, so the ExecStart sector-size substitution expands to an empty
# string and disk-watchdogd exits with a usage error ("-b" without
# argument). Three start attempts then hit StartLimitAction=reboot-force,
# which reboots the board in a loop until the disk-watchdog-boot-history
# self-heal disables the service. Keep the machines off that path until
# the missing by-state links are understood.
SYSTEMD_AUTO_ENABLE:seeed-recomputer-r100x = "disable"
