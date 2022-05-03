.PHONY: check
check: clean
	-@mkdir -p build
	-@mkdir -p initramfs/bin
	test -f initramfs/bin/busybox || wget https://busybox.net/downloads/binaries/1.21.1/busybox-x86_64 -O initramfs/bin/busybox
	test -f vmlinuz || cp /mnt/lfs/boot/vmlinuz-* vmlinuz
	# chmod +x initramfs/bin/busybox

.PHONY: clean
clean:
	@rm -rf build

.PHONY: initramfs
initramfs:
	@cd initramfs && find . -print0 \
		| cpio --null -ov --format=newc \
		| gzip -9 > ../build/initramfs.cpio.gz

.PHONY: start
start: check initramfs 
	@qemu-system-x86_64 \
		-nographic \
		-serial mon:stdio\
		-m 128\
		-kernel vmlinuz\
		-initrd build/initramfs.cpio.gz\
		-append "rd.shell rd.debug rd.udev.debug log_buf_len=1M console=tty0 console=ttyS0,9600 rd.retry=60 rd.timeout=120"

.PHONY: lfs
lfs:
	# cp /mnt/lfs/boot/initramfs-5.16.12.img build/initramfs.img
	@qemu-system-x86_64 \
		-nographic\
		-serial mon:stdio\
		-m 1G\
		-kernel vmlinuz\
		-initrd  build/initramfs.img\
		-hdb /dev/nvme0n1p2\
		-append "root=/dev/sda rootflags=rw,relatime,discard,data=ordered rootfstype=ext4 panic=10 rd.shell rd.debug rd.udev.debug log_buf_len=1M console=tty0 console=ttyS0,9600 rd.retry=60 rd.timeout=120"
