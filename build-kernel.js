#!/usr/bin/env zx

$.verbose = true;

const KernelImg = path.resolve("build/kernel.img");

if (!fs.existsSync("linux")) {
  await $`git clone --depth=1 https://github.com/raspberrypi/linux`;
}

cd('linux');

if (!fs.existsSync(KernelImg)) {
  process.env.KERNEL = 'kernel';

  await $`make bcm2712_defconfig`;

  process.env.CONFIG_LOCALVERSION = "-v7l-MYPI"

  await $`make -j6 Image.gz modules dtbs`
  await $`cp arch/arm64/boot/Image.gz ${KernelImg}`
} else {
  await echo(`${chalk.green(KernelImg)} already exists.`)
}
