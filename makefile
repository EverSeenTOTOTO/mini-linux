.PHONY: clean
clean:
	@rm -rf build

.PHONY: prepare
prepare:
	zx install-third-party.js
	zx mkfs.js

.PHONY: start
start: prepare
	@qemu-system-riscv64 \
		-M virt \
		-bios none \
		-kernel build/vmlinux \
		-m 128M \
		-smp 4 \
		-nographic \
		-drive file=build/rootfs.img,format=raw,id=hd0 \
		-device virtio-blk-device,drive=hd0 \
		-append "root=/dev/vda console=tty0 console=ttyS0,9600"
