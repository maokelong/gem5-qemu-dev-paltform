#!/bin/bash
set -e
source config.sh

if [ ! -d $CONFIG_DIR_GEM5 ]; then
  pkgs="git build-essential m4 scons zlib1g zlib1g-dev libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev python-dev python"
  sudo apt install -y $pkgs
  git clone $CONFIG_GEM5_SRC $CONFIG_DIR_GEM5 && cd $_
  if [ ! -z $CONFIG_GEM5_VERSION ]; then
    git reset --hard $CONFIG_GEM5_VERSION
  fi
fi
