#!/usr/bin/env zx

$.verbose = true;

const Cpus = Math.floor(os.cpus().length / 2);
const BuildDir = path.join(__dirname, 'build');

if (!fs.existsSync(BuildDir)) {
  fs.mkdirSync(BuildDir);
  echo(`Created dir ${chalk.green(BuildDir)}`);
}

cd(BuildDir);

// install busybox

const Busybox = 'busybox-1.35.0';
const BusyboxUrl = `https://busybox.net/downloads/${Busybox}.tar.bz2`
const BusyboxTarget = path.join(BuildDir, 'busybox');

if (fs.existsSync(BusyboxTarget)) {
  await echo(`${chalk.green(BusyboxTarget)} already exists.`);
} else {
  if (!fs.existsSync(Busybox)) {
    await $`wget ${BusyboxUrl}`;
    await $`tar -xvf ${Busybox}.tar.bz2`;
  }

  cd(Busybox);

  await $`make defconfig`;
  await $`sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/g' .config`; // build busybox with static link
  // https://lists.busybox.net/pipermail/busybox-cvs/2024-January/041752.html
  await $`sed -i '/^CONFIG_TC/s/^/#/' .config`;
  await $`make -j${Cpus}`;
  await $`cp busybox ${BusyboxTarget}`;
  await echo(`Copied busybox to ${chalk.green(BusyboxTarget)}`);
}
