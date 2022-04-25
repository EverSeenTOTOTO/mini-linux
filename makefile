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
		-append "panic=30 rd.shell rd.debug rd.udev.debug log_buf_len=1M console=tty0 console=ttyS0,9600 rd.retry=60 rd.timeout=120"

.PHONY: clean
clean:
	@rm -rf build
