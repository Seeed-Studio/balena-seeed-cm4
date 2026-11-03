# Build only the LLVM backends this BSP needs: AArch64 for the target
# boards (every seeed machine here is 64-bit) and X86 for the x86_64
# build host. meta-balena-rust builds ARM;AArch64;Mips;PowerPC;RISCV;X86,
# and rust-llvm-native -> rust-native is the critical path of a cold
# balenaOS build (~2.5-4 h of a 330 min CI budget on 4-vCPU runners).
#
# rustc_llvm only enables the LLVM components that llvm-config reports,
# so rustc builds fine against the reduced backend set; it just cannot
# generate code for the dropped architectures.
#
# The :remove drops the upstream list; the appended define comes later on
# the cmake command line, so it wins even if the upstream list changes.
EXTRA_OECMAKE:remove = "-DLLVM_TARGETS_TO_BUILD='ARM;AArch64;Mips;PowerPC;RISCV;X86'"
EXTRA_OECMAKE:append = " -DLLVM_TARGETS_TO_BUILD='AArch64;X86'"
