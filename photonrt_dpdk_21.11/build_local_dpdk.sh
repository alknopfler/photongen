#!/bin/bash

# All dev dependancies we need to compile DPDK, kernel mods etc
# Melanox DPKD build for PhotonOS.

# Author Mustafa Bayramov 

yum install -y  gdb valgrind systemtap ltrace strace python3-devel \
 tar lshw libnuma numactl \
 libnuma libnuma-devel numactl \
 zip zlib zlib-devel \
 git util-linux-devel libxml2-devel curl-devel zlib-devel \
 elfutils-devel libgcrypt-devel libxml2-devel linux-devel \
 lua-devel dtc-devel tuned tcpdump netcat cmake meson \
 build-essential wget \
 gdb valgrind systemtap ltrace strace \
 linux-esx-devel  kmod pciutils findutils iproute \
 rdma-core-devel doxgen libvirt libvirt-devel \
 libudev-devel \
# Python dependancies 
yum install -y python-sphinx python3-sphinxyum

# Tuned dependancies 
systemctl enable tuned
systemctl start tuned
tuned-adm profile latency-performance

# DPKD (change if you need adjust verionld.)
ln -sf /usr/src/kernels/$(uname -r) /lib/modules/$(uname -r)/build
wget http://fast.dpdk.org/rel/dpdk-21.11.tar.xz -P build
cd build || exit
tar xf dpdk*

# we can't run it in RT
#yum update
#yum install linux-drivers-gpu

#yum install ncurses
#wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
#sudo sh cuda_11.6.0_510.39.01_linux.run

pip3 install pyelftools
pip3 install nvidia-pyindex
pip3 install install nvidia-cuda-runtime-cu11
pip3 install nvidia-pyindex
pip3 install install nvidia-cuda-runtime-cu11
pip3 install nvidia-cuda-nvcc-cu11
pip3 install nvidia-nvjpeg-cu11
pip3 install nvidia-cuda-cupti-cu11
pip3 install nvidia-nvml-dev-cu11
pip3 install nvidia-cuda-sanitizer-api-cu11
pip3 install nvidia-npp-cu11

cd dpdk-21.11 || exit
kernel_ver=$(uname -r)
meson -Dplatform=native -Dexamples=all -Denable_kmods=true \
    -Dkernel_dir=/lib/modules/"$kernel_ver" \
    -Dibverbs_link=shared -Dwerror=true build
ninja -C build install
