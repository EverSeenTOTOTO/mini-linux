$(shell mkdir -p build)

.PHONY: initramfs
initramfs:
	@cd initramfs && find . -print0 \
		| cpio --null -ov --format=newc \
		| gzip -9 > ../build/initramfs.cpio.gz

.PHONY: start
start: initramfs
	@qemu-system-x86_64 -nographic \
		-serial mon:stdio\
		-m 128\
		-kernel vmlinuz\
		-initrd build/initramfs.cpio.gz\
		-append "console=ttyS0 quiet acpi=off"

.PHONY: clean
clean:
	@rm -rf build
