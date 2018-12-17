#!/bin/bash
set -e
source config.sh

if [ ! -f $CONFIG_DIR_BINARIES/x86_64-bzImage-$CONFIG_KERNEL -o ! -f $CONFIG_DIR_DISKS/${CONFIG_OS/iso/img} ]; then
  echo -e "${COLOR_RED} Please build disk and kernel before running qemu! ${COLOR_NORMAL}"
  exit -1
fi

# run tip on how to enable real time files sharing between qemu and disk-img
echo -e  "${COLOR_GREEN}Execute 'mount -t 9p -o trans=virtio,version=9p2000.L share_dir /share_dir' on boot to enable real time files sharing between host and guest via $(CONFIG_DIR_SHARED).${COLOR_NORMAL}"
if [ ! -d $CONFIG_DIR_SHARED ]; then
  mkdir $CONFIG_DIR_SHARED
  sudo chown libvirt-qemu $CONFIG_DIR_SHARED
fi

CONFIG_TOTAL_SIZE=$((CONFIG_DRAM_SIZE + CONFIG_PM_SIZE))
CONFIG_PM_BASE=$((CONFIG_DRAM_SIZE + 1))

sudo qemu-system-x86_64 \
  -machine type=pc,accel=kvm \
  -cpu host \
  -smp 10 \
  -m ${CONFIG_TOTAL_SIZE}G \
  -fsdev local,id=fsdev0,path=$CONFIG_DIR_SHARED,security_model=passthrough -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag="shared_dir" \
  -k en-us \
  -drive file=$CONFIG_DIR_DISKS/${CONFIG_OS/iso/img},format=raw,index=0,if=ide,media=disk \
  -kernel $CONFIG_DIR_BINARIES/x86_64-bzImage-$CONFIG_KERNEL \
  -append "root=/dev/hda1 memmap=${CONFIG_PM_BASE}G!${CONFIG_PM_SIZE}G"
  # 不需要任何参数就能连接网络: https://www.linux-kvm.org/page/Networking。只是无法 PING。
  # 进入 Host 后使用如下指令挂载共享文件系统: `mount -t 9p -o trans=virtio,version=9p2000.L share_dir /share_dir`. 
  # 注意，采用 Jason 的 config 文件之后我无法在编译内核时开启 9p 选项，因此运行编译后的内核后无法采用该种方式共享文件