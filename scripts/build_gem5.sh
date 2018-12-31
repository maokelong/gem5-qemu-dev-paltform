#!/bin/bash
set -e
source config.sh

if [ ! -d $CONFIG_DIR_GEM5 ]; then
  echo -e "${COLOR_RED} Please download gem5 before build! ${COLOR_NORMAL}"
  exit -1
fi

cd $CONFIG_DIR_GEM5
scons $CONFIG_GEM5_EXECUTABLE -j$(cat /proc/cpuinfo | grep "processor" | wc -l)
cd util/term
make && sudo make install