#!/usr/bin/env bash

echo -e "\033[33m内存超售检测开始\033[0m"
echo -e "\033[0m====================\033[0m"

# 检查是否使用了 SWAP 超售内存
echo -e "\033[36m检查是否使用了 SWAP 超售内存\033[0m"
memSize=`free -m | awk '/Mem/ {print $2}'`
speed=`dd if=/dev/zero of=/dev/null bs=1M count=$memSize 2>&1 | awk '{print $(NF-1)}' | awk 'END {print}' | awk -F '，' '{print $NF}'`
speed=`echo $speed | awk '{printf("%.0f\n",$1)}'`
echo -e "\033[34m内存 IO 速度: $speed GB/s\033[0m"
if [ $speed -lt 10 ]; then
    echo -e "\033[31m内存 IO 速度低于 10 GB/s\033[0m"
    echo -e "\033[31m可能存在 SWAP 超售内存\033[0m"
else
    echo -e "\033[32m内存 IO 速度正常\033[0m"
    echo -e "\033[32m未使用 SWAP 超售内存\033[0m"
fi
echo -e "\033[0m====================\033[0m"

# 检查是否使用了气球驱动 Balloon 超售内存
echo -e "\033[36m检查是否使用了 气球驱动 Balloon 超售内存\033[0m"
if lsmod | grep virtio_balloon > /dev/null; then
    echo -e "\033[31m存在 virtio_balloon 模块\033[0m"
    echo -e "\033[31m可能使用了 气球驱动 Balloon 超售内存\033[0m"
else
    echo -e "\033[32m不存在 virtio_balloon 模块\033[0m"
    echo -e "\033[32m未使用 气球驱动 Balloon 超售内存\033[0m"
fi
echo -e "\033[0m====================\033[0m"

# 检查是否使用了 Kernel Samepage Merging (KSM) 超售内存
echo -e "\033[36m检查是否使用了 Kernel Samepage Merging (KSM) 超售内存\033[0m"
if [ `cat /sys/kernel/mm/ksm/run` == 1 ]; then
    echo -e "\033[31mKernel Samepage Merging 状态为 1\033[0m"
    echo -e "\033[31m可能使用了 Kernel Samepage Merging (KSM) 超售内存\033[0m"
else
    echo -e "\033[32mKernel Samepage Merging 状态正常\033[0m"
    echo -e "\033[32m未使用 Kernel Samepage Merging (KSM) 超售内存\033[0m"
fi
echo -e "\033[0m====================\033[0m"