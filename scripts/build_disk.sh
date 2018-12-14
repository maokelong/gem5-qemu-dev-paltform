#!/bin/bash
set -e
source config.sh

if [ ! -f $CONFIG_DIR_OS/$CONFIG_OS ]; then
  echo -e "${COLOR_RED} Please download os to continue! ${COLOR_NORMAL}"
  exit -1
fi

if [ ! -f $CONFIG_DIR_DISKS/${CONFIG_OS/iso/img} ]; then
  mkdir -p $CONFIG_DIR_DISKS && cd $_
  # NEVER USE OTHER FORMATS THAN RAW
  qemu-img create ${CONFIG_OS/iso/img} 20G -f raw

  sudo qemu-system-x86_64  \
    -cdrom $CONFIG_DIR_OS/$CONFIG_OS \
    -hda $CONFIG_DIR_DISKS/${CONFIG_OS/iso/img} \
    -m 2G \
    -k en-us \
    -boot d \
    -enable-kvm;
  
  read -p "${RED}Did you install OS successfully? [Y/n] ${NORMAL}" -n 1 -r
  echo # to start a new line
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    rm -rf $CONFIG_DIR_DISKS/${CONFIG_OS/iso/img}
  fi
fi