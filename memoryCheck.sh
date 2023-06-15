#!/usr/bin/env bash

# check if is utf-8, if not, set it
if [ `locale charmap` != 'UTF-8' ]; then
    export LC_ALL=en_US.UTF-8
fi

echo "内存超售检测开始......"
echo ""

# Check SWAP oversold
memSize=`free -m | awk '/Mem/ {print $2}'`
speed=`dd if=/dev/zero of=/dev/null bs=1M count=$memSize 2>&1 | awk '/copied/ {print $(NF-1)}'`
speed=`echo $speed | awk '{printf("%.0f\n",$1)}'`
echo "内存io速度: $speed GB/s"
if [ $speed -lt 10 ]; then
    echo -e "\033[31mSWAP超售!\033[0m"
    echo "超售! 内存io速度低于 10 GB/s，存在SWAP超售可能"
else
    echo "内存io速度正常，未使用SWAP超售"
fi

# Check virtio_balloon oversold
echo ""
if lsmod | grep virtio_balloon > /dev/null; then
    echo -e "\033[31mballoon超售!\033[0m"
    echo "存在virtio_balloon模块，使用气球驱动Balloon超售内存"
else
    echo "不存在virtio_balloon模块，未使用气球驱动Balloon超售"
fi

# Check Kernel Samepage Merging (KSM) oversold
echo ""
if [ `cat /sys/kernel/mm/ksm/run` == 1 ]; then
    echo -e "\033[31mKSM超售!\033[0m"
    echo "Kernel Samepage Merging状态为1，使用KSM超售内存"
else
    echo "Kernel Samepage Merging状态正常，未使用KSM超售"
fi
