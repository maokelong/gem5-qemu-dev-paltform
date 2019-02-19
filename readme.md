# readme

## 简介

只需要很简单的步骤即可在最短的时间内搭建 GEM5 FS + QEMU 平台，并构建能被二者共用的操作系统（默认 Ubuntu 16.04.5 server）及内核（默认 4.15.18）。

## 步骤

确保你的系统（Host）是 Ubuntu，最好是 Ubuntu 16.04，如果是，你只需要按照如下步骤操作即可：

1. `chmod +x ./run.sh`
1. `./run.sh -b`
   1. [自动] 克隆并构建 GEM5。注意 GEM5 的版本将被切换至特定 Baseline；
   1. [自动] 下载内核，内核将保存在「dependencies/kernels」目录下；
   1. [自动] 从网络下载 Jason 提供的 config 文件，在向其中添加有关[支持 DAX 的选项]((https://software.intel.com/en-us/articles/how-to-emulate-persistent-memory-on-an-intel-architecture-server))后，以此编译内核。编译结束后将 vmlinux 和 bzImage 拷贝到 「dependencies/binaries」目录下，且名称将分别更改为 x86_64-vmlinux-\${Kernel-Version} 和 x86_64-bzImage-linux-\${Kernel-Version}。前者用于启动 GEM5，后者用于启动 QEMU；
      >  **注**：自动进行到配置内核这一步时，将弹出 Menuconfig，以帮助你确认实际配置。我一般用这步来检查我所需要的配置是否成功加载，此步大可跳过。
   1. [自动] 下载操作系统，操作系统将保存在「dependencies//oss」目录下；
   1. [半自动] 创建虚拟硬盘（RAW 格式）并向其中安装操作系统，虚拟磁盘将保存在「dependencies/disks」目录下；
      > **注 1**：自动进行到安装操作系统这一步时，安装界面将自动弹出，你需要手动操作 GUI 以完成操作系统的安装。安装过程中记得 **手动分区，不要设置交换区！**。GEM5 的 IDE 控制器有问题，否则内核便因无法挂载根文件系统而无法启动。另外也不要忘记将主分区设置为 Bootable，虽然我并不知道如若不这样做会有什么坏影响。安装完成后关闭 QEMU 虚拟机即可，由于脚本很难检测到操作系统是否安装成功，因此我设置了确认安装的步骤，当且仅当你输入 n 或 N 的时候脚本将移除方才建立的磁盘镜像；
      >
      > **注 2**：不要试图采用 Qcow2 磁盘格式，否则 GEM5 也将无法挂载根文件系统。
2. `./run.sh -r qemu`
   1. [自动] 运行 QEMU 虚拟机
      > **注 1**：为了方便向虚拟机传输文件，你可以在 GUEST 的 \$HOME 下创建「shared_dir」，并在 GUEST 中执行 `mount -t 9p -o trans=virtio,version=9p2000.L shared_dir $HOME/shared_dir`。如此，你只需在 HOST 的「shared_dir」中丢入文件，就可以实时地在 Guest 的「shared_d_ir」中找到相应文件。你能这样做，是因为我在 QEMU 的启动参数中添加了表示挂载虚拟文件系统的选项。以上提示也将在虚拟机启动之前，以绿字打印在屏幕上；
      >
      > **注 2**：但是，当虚拟机使用采用 Jason 提供的 config 文件编译的新内核后，系统将无法使用上述实时文件共享功能，因为此时内核无法提供 9P FileSystem；
      >
      > **注 3**：你不能 Ping，但可以上网。在 QEMU 默认的网络配置下，即如是。
   1. [全手动] 按照 [Jason 的教程](http://www.lowepower.com/jason/setting-up-gem5-full-system.html)，在 GUEST 上完成环境配置，使 GUEST 在启动后自动执行 GEM5 要求执行的脚本。该项功能未经验证。
        <!-- >TODO：[听说](https://simplessd.org/build_kernel.html)高版本（4.9+）的内核无需使用特殊的 config 即可运行在 GEM5 上，这个需要在将来验证； -->
3. `./run.sh -r gem5`
   1. [自动] 运行 GEM5 虚拟机
   1. [全手动] 监听 GEM5 虚拟机。默认情况下打开新的终端并执行 `cd $GEM5_DIR/util/term && sudo ./m5term 127.0.0.1 3456` 即可。该命令也将在运行 GEM5 虚拟机之前以绿字打印在屏幕上。
      > **注**：可使用 [TMUX](https://blog.csdn.net/maokelong95/article/details/82667047) 维护一个 Session，从而使得 XShell 断开后 GEM5 虚拟机仍能继续运行。

## 相关

1. 如何使用 Eclipse 调试 GEM5 代码。[传送门](https://blog.csdn.net/maokelong95/article/details/85333905)
1. GEM5 源码阅读：O3 处理器的访存流程与错误处理。[传送门](https://github.com/maokelong/CSDN-maokelong95/blob/master/%E5%85%B1%E4%BA%AB%E8%B5%84%E6%BA%90/GEM5%20%E6%BA%90%E7%A0%81%E9%98%85%E8%AF%BB%EF%BC%9AO3%20%E5%A4%84%E7%90%86%E5%99%A8%E7%9A%84%E8%AE%BF%E5%AD%98%E6%B5%81%E7%A8%8B%E4%B8%8E%E9%94%99%E8%AF%AF%E5%A4%84%E7%90%86.pdf)
