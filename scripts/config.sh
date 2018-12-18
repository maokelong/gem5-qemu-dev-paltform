#!/bin/bash
set -e

# to avoid multiple source
if [ -z $HAS_LOAD_CONFIG ]; then
  HAS_LOAD_CONFIG=true;
else
  exit;
fi

# SRC
# =================================================================

# to specify which kernel to download
CONFIG_KERNEL="linux-4.15.18"
CONFIG_KERNEL_SRC="https://mirrors.tuna.tsinghua.edu.cn/kernel/v4.x/$CONFIG_KERNEL.tar.gz" # the suffix must be ".tar.gz"

# to specify the well tuned kernel config file helping to run gem5
CONFIG_KERNEL_CONFIG_SRC="http://www.lowepower.com/jason/files/config"

# the extra kernel config fragmentation
CONFIG_EXTRA_CONFIGS="
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=y
CONFIG_BLK_DEV_PMEM=y
CONFIG_NVDIMM_DAX=y
CONFIG_DAX=y
CONFIG_DEV_DAX=y
CONFIG_DEV_DAX_PMEM=y
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_ARCH_HAS_PMEM_API=y"

# to specify which os to download
CONFIG_OS="ubuntu-16.04.5-server-amd64.iso" # with .iso suffix
CONFIG_OS_SRC="https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/16.04.5/ubuntu-16.04.5-server-amd64.iso" # .iso

# to specify the source and version of gem5
CONFIG_GEM5_SRC="https://github.com/maokelong/gem5-mkl"
CONFIG_GEM5_VERSION="HEAD"

# DIR
# =================================================================

CONFIG_ROOT_DIR=$PWD/..

CONFIG_DIR_RUNTIMES=$CONFIG_ROOT_DIR/runtimes/
CONFIG_DIR_FS_SCRIPTS=$CONFIG_DIR_RUNTIMES/fs_scripts
CONFIG_DIR_SE_BINARIES=$CONFIG_DIR_RUNTIMES/se_binaries
CONFIG_DIR_SHARED="$CONFIG_DIR_RUNTIMES/share_dir"

CONFIG_DIR_DEP=$CONFIG_ROOT_DIR/dependencies
CONFIG_DIR_GEM5=$CONFIG_DIR_DEP/gem5
CONFIG_DIR_KERNEL=$CONFIG_DIR_DEP/kernels
CONFIG_DIR_BINARIES=$CONFIG_DIR_DEP/binaries
CONFIG_DIR_OS=$CONFIG_DIR_DEP/oss
CONFIG_DIR_DISKS=$CONFIG_DIR_DEP/disks

export M5_PATH=$CONFIG_DIR_DEP

# Hybrid Memory
# =================================================================\
CONFIG_DRAM_SIZE=4 # in GiB
CONFIG_PM_SIZE=4 # in GiB

# OUTPUT
# =================================================================

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_NORMAL='\033[0m'