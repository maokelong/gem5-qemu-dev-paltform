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
# EXECUTION
##################################################################

cd $CONFIG_DIR_GEM5
for binary in $CONFIG_DIR_SE_BINARIES/*; do
    if [[ $binary == *.out ]]; then
      $CONFIG_DIR_GEM5/build/X86/gem5.opt \
      --outdir=$CONFIG_DIR_OUTPUT_SE/$binary \
      $CONFIG_DIR_GEM5/configs/example/se.py \
        --num-cpus=$CONFIG_VM_NUM_CPUS \
        --cpu-type=$CONFIG_VM_CPU_TYPE --cpu-clock=$CONFIG_VM_CPU_CLK \
        --caches --cacheline_size=$CONFIG_VM_CACHELINE_LEN \
        --l1i_size=$CONFIG_VM_L1I_SIZE --l1i_assoc=$CONFIG_VM_L1I_ASSOC \
        --l1d_size=$CONFIG_VM_L1D_SIZE --l1d_assoc=$CONFIG_VM_L1D_ASSOC \
        --l2cache --l2_size=$CONFIG_VM_L2_SIZE --l2_assoc=$CONFIG_VM_L2_ASSOC \
        --mem-type=$CONFIG_MEM_TYPE \
        --mem-size=$((CONFIG_VM_DRAM_SIZE + CONFIG_VM_PM_SIZE))GB \
        -c $binary | tee -a $CONFIG_DIR_OUTPUT_SE/$binary/log
  fi
done
