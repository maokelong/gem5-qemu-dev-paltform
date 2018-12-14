#!/bin/bash
set -e
source config.sh

# check kernel source
if [ ! -f $CONFIG_DIR_KERNEL/$CONFIG_KERNEL.tar.gz -o ! -d $CONFIG_DIR_KERNEL/$CONFIG_KERNEL ]; then
  mkdir -p $CONFIG_DIR_KERNEL && cd $_
  wget $CONFIG_KERNEL_SRC -O $CONFIG_KERNEL.tar.gz && tar -xvzf $_
fi