#!/bin/bash
set -e

pkgs="qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils"
sudo apt install -y $pkgs