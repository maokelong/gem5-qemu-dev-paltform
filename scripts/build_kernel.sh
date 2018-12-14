#!/bin/bash
set -e
source config.sh

if [ ! -d $CONFIG_DIR_KERNEL/$CONFIG_KERNEL ]; then
  echo -e "${COLOR_RED} Please download kernel before build! ${COLOR_NORMAL}"
  exit -1
fi

cd $CONFIG_DIR_KERNEL/$CONFIG_KERNEL

if [ ! -f $CONFIG_DIR_BINARIES/x86_64-vm$CONFIG_KERNEL -o ! -f $CONFIG_DIR_BINARIES/x86_64-bzImage-$CONFIG_KERNEL ]; then 
  pkgs="chrpath gawk texinfo libsdl1.2-dev whiptail diffstat cpio libssl-dev ncurses-dev libelf-dev bc" 
  sudo apt install -y $pkgs
  wget $CONFIG_KERNEL_CONFIG_SRC -O .config
  echo "$CONFIG_EXTRA_CONFIGS" >> .config
  make menuconfig olddefconfig
  make vmlinux -j$(cat /proc/cpuinfo | grep "processor" | wc -l)
  make bzImage -j$(cat /proc/cpuinfo | grep "processor" | wc -l)
  mkdir -p $CONFIG_DIR_BINARIES
  cp vmlinux $CONFIG_DIR_BINARIES/x86_64-vm$CONFIG_KERNEL -f
  cp arch/x86/boot/bzImage $CONFIG_DIR_BINARIES/x86_64-bzImage-$CONFIG_KERNEL -f
fi