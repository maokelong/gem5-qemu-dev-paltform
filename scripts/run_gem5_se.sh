#!/bin/bash
set -e
source config.sh

if [ ! -f $CONFIG_DIR_GEM5/build/X86/gem5.opt ]; then
  echo -e "${COLOR_RED} Please build gem5 before running! ${COLOR_NORMAL}"
  exit -1
fi

##################################################################
# SET BENCHMARKS
##################################################################
BENCHMARKS=(
429.mcf
434.zeusmp
435.gromacs
436.cactusADM
437.leslie3d
450.soplex
458.sjeng
462.libquantum
470.lbm
471.omnetpp
483.xalancbmk
)

FASTFORWARD_INSTS=$((200000000/$CONFIG_VM_NUM_CPUS))
MAXINSTS=$((1000000000/$CONFIG_VM_NUM_CPUS))

##################################################################
# EXECUTION
##################################################################

for benchmark in ${BENCHMARKS[@]}; do
  BENCH_OUT=$CONFIG_DIR_OUTPUT_SE/$benchmark

  mkdir -p $BENCH_OUT/stdout
  mkdir -p $BENCH_OUT/stderr

  $CONFIG_DIR_GEM5/build/X86/gem5.opt \
    --outdir=$BENCH_OUT \
    $CONFIG_DIR_GEM5/configs/example/se.py \
      --path_spec=$CONFIG_DIR_SPEC/${CONFIG_SPEC/.*/}/benchspec/CPU2006/ \
      --benchmark=$benchmark \
      --benchmark_stdout=$BENCH_OUT/stdout/$benchmark.out \
      --benchmark_stderr=$BENCH_OUT/stderr/$benchmark.err \
      --fast-forward=$FASTFORWARD_INSTS --maxinsts=$MAXINSTS \
      --num-cpus=$CONFIG_VM_NUM_CPUS \
      --cpu-type=$CONFIG_VM_CPU_TYPE --cpu-clock=$CONFIG_VM_CPU_CLK \
      --caches --cacheline_size=$CONFIG_VM_CACHELINE_LEN \
      --l1i_size=$CONFIG_VM_L1I_SIZE --l1i_assoc=$CONFIG_VM_L1I_ASSOC \
      --l1d_size=$CONFIG_VM_L1D_SIZE --l1d_assoc=$CONFIG_VM_L1D_ASSOC \
      --l2cache --l2_size=$CONFIG_VM_L2_SIZE --l2_assoc=$CONFIG_VM_L2_ASSOC \
      --mem-type=$CONFIG_MEM_TYPE \
      --mem-size=$((CONFIG_VM_DRAM_SIZE + CONFIG_VM_PM_SIZE))GB \
      | tee -a $BENCH_OUT/log
done
