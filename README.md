# memoryCheck

用于检测VPS内存是否超售的一键脚本，检测范围包括：

- 内存交换（Swap）
- 气球驱动（Balloon）
- Kernel Samepage Merging（KSM内存合并）

## 一键脚本
```
wget --no-check-certificate -O memoryCheck.sh https://raw.githubusercontent.com/uselibrary/memoryCheck/main/memoryCheck.sh && chmod +x memoryCheck.sh && bash memoryCheck.sh
```

## 详细介绍
### 内存交换（Swap）
当系统内存不够用时，宿主机把部分长时间未操作（读写）的内存交换到磁盘上配置的Swap分区，等相关程序需要运行时再恢复到内存中。

### 气球驱动（Balloon）
通过virtio_balloon驱动实现动态调整Guest与Host的可用内存空间。Balloon的工作原理是在虚拟机中安装一个kmod，KVM宿主机内存不足，会根据virtio_balloon判断哪些内存页面可以被回收，然后virtio_balloon将这些内存占用，返回给宿主机使用。

root用户执行`rmmod virtio_balloon`可以关闭virtio_balloon

### KSM（Kernel Samepage Merging 内存合并）
KSM是一种内存合并技术，它可以在KVM中实现内存共享，从而节省内存空间。是Linux kernel的一种内存共享机制，在2.6.32版本引入，用于合并具有相同内容的物理主存页面以减少页面冗余。在Kernel中KSM会定期扫描用户注册的内存区域，当有相同的页面就会将其合并，并用一个添加到页表中的新页面来代替原来的页面。当需要修改时，复制新的内存页，再做修改(将其标记为 copy-on-write)



## 备注
1. 基于nodeseek讨论内容，感谢原作者，详情：https://www.nodeseek.com/post-8417-1
2. 脚本已经在KVM架构的Debian 11/12系统上通过检测
3. 其他架构和系统理论上有用，具体检测没做