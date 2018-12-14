#!/bin/bash
set -e
source config.sh

if [ ! -f $CONFIG_DIR_GEM5/build/X86/gem5.opt ]; then
  echo -e "${COLOR_RED} Please build gem5 before running! ${COLOR_NORMAL}"
  exit -1
fi

if [ ! -d $CONFIG_DIR_SE_BINARIES ]; then
  echo -e "${COLOR_RED} Make sure that the se binaries to be executed were put into $CONFIG_DIR_SE_BINARIES! ${COLOR_NORMAL}"
  exit -1
fi

##################################################################
# CONFIGURATIONS for SE Mode
##################################################################

# MACHINE
NUM_CPUS=8
CPU_TYPE=DerivO3CPU
CPU_CLK=3GHz

L1I_SIZE=32kB
L1I_ASSOC=8
L1D_SIZE=32kB
L1D_ASSOC=8
L2_SIZE=256kB
L2_ASSOC=8
CACHELINE_SIZE=64

MEM_SIZE=$((2*NUM_CPUS))GB
MEM_TYPE=SimpleMemory

##################################################################
# EXECUTION
##################################################################

cd $CONFIG_DIR_GEM5
for binary in binaries/*; do
    if [[ $binary == *.out ]]; then
      ./build/X86/gem5.opt \
      ../gem5-repo/configs/example/se.py \
        --cpu-type=$CPU_TYPE --cpu-clock=$CPU_CLK \
        --caches --cacheline_size=$CACHELINE_SIZE \
        --l1i_size=$L1I_SIZE --l1i_assoc=$L1I_ASSOC --l1d_size=$L1D_SIZE --l1d_assoc=$L1D_ASSOC \
        --l2cache --l2_size=$L2_SIZE --l2_assoc=$L2_ASSOC \
        --mem-type=$MEM_TYPE --mem-size=$MEM_SIZE \
        -c $binary
        # --l3cache --l3_size=$L3_SIZE --l3_assoc=$L3_ASSOC
  fi
done