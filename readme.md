# readme

## 简介

该版本在 Master 的基础上作了修改，具体而言注释掉了 Qemu、OS、Kernel 的下载、安装及运行，并添加了对 SPEC CPU 2006（以下简称为 SPEC）的支持。现在你只需将 SPEC 的压缩包（支持 tar.gz 及 iso 两种格式）拷贝到 dependencies/spec 目录下，并命名为 cpu2006.tar.gz（或 cpu2006.iso），即可快速构建 GEM5 SE + SPEC 开发测试平台。

> 该分支与 [gem5-mkl 的 with-spec 分支](https://github.com/maokelong/gem5-mkl/tree/with-spec)配套使用。该 gem5 版本所作修改见 commit，其在 [gem5 官方文档](http://gem5.org/SPEC_CPU2006_benchmarks)与魏博指导下完成。

## 步骤

确保你的系统（Host）是 Ubuntu，最好是 Ubuntu 16.04，如果是，你只需要按照如下步骤操作即可：

1. `chmod +x ./run.sh`
1. `./run.sh -b` 
   1. [手动] 请先把 SPEC 的压缩包（支持 tar.gz 及 iso 两种格式）拷贝到 dependencies/spec 目录下，并将 scripts/config.sh 中的 `CONFIG_SPEC` 修改为文件名，如 cpu2006.iso（或 cpu2006.tar.gz）。
      > 注1: 压缩包名称里不要包含 "."。我是取第一个 "." 之前的字符串作为文件名的。

      > 注2: 目前仅支持 1.2。SPEC 1.0 及 1.1 正在适配。
   1. [自动] 解压 SPEC，修改源码以适配 Ubuntu Xenial，安装 SPEC
      > 注3: 适用于 SPEC 1.2- 的补丁原作者为 [sjp38](https://github.com/sjp38/spec_on_ubuntu_xenial/blob/master/patch-for-ubuntu16.04.sh)。该补丁目前尚未经过测试。
   1. [自动] 克隆并安装修改过的 GEM5
1. `./run.sh -r gem5`
   1. [自动] 运行 GEM5 SE，运行结果将保存在 outputs/se_outputs 目录下
