# MemoryCheck

用于检测VPS内存是否超售的一键脚本，检测范围包括：

- 内存交换（Swap）
- 气球驱动（Balloon）
- Kernel Samepage Merging（KSM内存合并）

## 一键脚本
```
curl https://raw.githubusercontent.com/0x648/memoryCheck/main/memoryCheck.sh | bash
```

如果上述执行出错，可以尝试以下命令：
```
wget --no-check-certificate -O memoryCheck.sh https://raw.githubusercontent.com/0x648/memoryCheck/main/memoryCheck.sh && chmod +x memoryCheck.sh && bash memoryCheck.sh
```

## 详细介绍
### 内存交换（Swap）
当系统内存不够用时，宿主机把部分长时间未操作（读写）的内存交换到磁盘上配置的Swap分区，等相关程序需要运行时再恢复到内存中。

### 气球驱动（Balloon）
通过virtio_balloon驱动实现动态调整Guest与Host的可用内存空间。Balloon的工作原理是在虚拟机中安装一个kmod，KVM宿主机内存不足，会根据virtio_balloon判断哪些内存页面可以被回收，然后virtio_balloon将这些内存占用，返回给宿主机使用。

root用户执行`rmmod virtio_balloon`可以关闭virtio_balloon。事实上，大多数使用Proxmox VE的厂商都会开启virtio_balloon进行超售。

### KSM（Kernel Samepage Merging 内存合并）
KSM是一种内存合并技术，它可以在KVM中实现内存共享，从而节省内存空间。是Linux kernel的一种内存共享机制，在2.6.32版本引入，用于合并具有相同内容的物理主存页面以减少页面冗余。在Kernel中KSM会定期扫描用户注册的内存区域，当有相同的页面就会将其合并，并用一个添加到页表中的新页面来代替原来的页面。当需要修改时，复制新的内存页，再做修改(将其标记为 copy-on-write)



## 备注
1. 基于nodeseek讨论内容，感谢原作者，详情：https://www.nodeseek.com/post-8417-1
2. 脚本已经在KVM架构的Debian 11/12系统上通过检测
3. 其他架构和系统理论上有用，具体检测没做


# performanceTest

用于快速检测VPS的CPU和内存性能的程序，基于Golang编写。功能和测试内容都很简单，出发点是因为UnixBench和Geekbench大而全，耗时太多了，不适合上手简测。

实现方法如下：

- 计算i++到2000000000时i*i的耗时
- 计算i++到100000000时内存顺序赋值的耗时

## 一键脚本
```
curl -s https://raw.githubusercontent.com/uselibrary/memoryCheck/main/performanceTest.sh | bash
```

## 输入结果
输出结果，包括CPU和内存的操作耗时，越小越好。
以E5V4 KVM VPS为例：
```
Starting CPU and RAM performance test...
Calculations took: 864.414482ms
Memory operations took: 1.26858103s
```
短期内多次运行，时间可能会大幅缩短，因为系统、内存和CPU都有缓存，加快了运行速度。
```
Starting CPU and RAM performance test...
Calculations took: 842.915184ms # CPU运行时间缩短了
Memory operations took: 363.394008ms # 内存时间大幅减小
```
