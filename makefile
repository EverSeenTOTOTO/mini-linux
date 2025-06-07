.PHONY: clean
clean:
	@rm -rf build

.PHONY: prepare
prepare:
	zx build-kernel.js
	zx build-busybox.js
	zx mkfs.js

.PHONY: start
start: prepare
	@qemu-system-aarch64 -M virt \
		-cpu cortex-a76 -smp 4 -m 2G \
		-kernel build/kernel.img \
		-initrd build/initramfs.cpio.gz \
		-append "loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0" \
		-no-reboot \
		-nographic

