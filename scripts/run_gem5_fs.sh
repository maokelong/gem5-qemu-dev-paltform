#!/bin/bash
set -e
source config.sh

if [ ! -f $CONFIG_GEM5_EXECUTABLE ]; then
  echo -e "${COLOR_RED} Please build gem5 before running! ${COLOR_NORMAL}"
  exit -1
fi

cd $CONFIG_DIR_DISKS

if [ ! -f linux-bigswap2.img ]; then
  dd if=/dev/zero of=linux-bigswap2.img bs=512 count=102400
fi

if [ ! -f $CONFIG_DIR_BINARIES/x86_64-vmlinux-2.6.22.9 ]; then
  # A dummy kernel to cope with hardcode
  touch $CONFIG_DIR_BINARIES/x86_64-vmlinux-2.6.22.9
fi

if [ ! -f $CONFIG_DIR_FS_SCRIPTS/on-boot.sh ]; then
  mkdir -p $CONFIG_DIR_FS_SCRIPTS
  touch $CONFIG_DIR_FS_SCRIPTS/on-boot.sh
fi

echo -e "${COLOR_GREEN}Note: Execte 'cd $CONFIG_DIR_GEM5/util/term && sudo ./m5term 127.0.0.1 3456' to listen to gem5.${COLOR_NORMAL}"

CONFIG_PM_BASE=$((CONFIG_DRAM_SIZE + 1))

cd $CONFIG_DIR_GEM5
$CONFIG_GEM5_EXECUTABLE \
  configs/example/fs.py \
  --cpu-type TimingSimpleCPU \
  --dram-size=${CONFIG_DRAM_SIZE}GB \
  --dram-type=SimpleMemory \
  --pm-size=${CONFIG_PM_SIZE}GB \
  --pm-type=SimplePM \
  --kernel=x86_64-vm$CONFIG_KERNEL \
  --disk-image=${CONFIG_OS/iso/img} \
  --command-line="earlyprintk=ttyS0 console=ttyS0 lpj=7999923 root=/dev/hda1 memmap=${CONFIG_PM_BASE}G!${CONFIG_PM_SIZE}G" \
  # --script="$CONFIG_DIR_FS_SCRIPTS/on-boot-up.sh"