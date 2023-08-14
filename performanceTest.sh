#!/usr/bin/env bash

# check if is utf-8, if not, set it
# if [ `locale charmap` != 'UTF-8' ]; then
#     export LC_ALL=en_US.UTF-8
# fi

# check if has wget
if ! [ -x "$(command -v wget)" ]; then
    echo 'Error: wget is not installed.' >&2
    exit 1
fi

echo "CPU和内存性能测试开始......"
echo ""

# download file
cd ~
wget --no-check-certificate -O performanceTest https://raw.githubusercontent.com/uselibrary/memoryCheck/main/performanceTest
chmod +x performanceTest
./performanceTest
