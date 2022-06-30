.PHONY: clean
clean:
	@rm -rf build

.PHONY: initramfs
initramfs:
	@cd initramfs && find . -print0 \
		| cpio --null -ov --format=newc \
		| gzip -9 > ../build/initramfs.cpio.gz
	@echo

.PHONY: start
start: initramfs
	@qemu-system-riscv64 \
		-machine virt \
		-bios none \
		-kernel build/vmlinux \
		-m 128M \
		-smp 4 \
		-nographic \
		-initrd build/initramfs.cpio.gz \
		-append "rd.shell rd.debug rd.udev.debug log_buf_len=1M console=tty0 console=ttyS0,9600 rd.retry=60 rd.timeout=120"
