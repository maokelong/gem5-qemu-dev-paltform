#!/bin/bash
set -e
source config.sh

if [ ! -f $CONFIG_DIR_OS/$CONFIG_OS ]; then
  mkdir -p $CONFIG_DIR_OS && cd $_
  wget $CONFIG_OS_SRC -O $CONFIG_OS;
fi