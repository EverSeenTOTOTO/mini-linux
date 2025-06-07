#!/usr/bin/env zx

$.verbose = true;

if (!fs.existsSync("linux")) {
  await $`git clone --depth=1 https://github.com/raspberrypi/linux`;
}

cd('linux');

process.env.KERNEL = 'kernel';

await $`make bcm2711_defconfig`;

process.env.CONFIG_LOCALVERSION = "-v7l-MYPI"

await $`make -j6 Image.gz modules dtbs`
