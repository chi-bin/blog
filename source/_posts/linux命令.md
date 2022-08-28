---
title: linux命令总结篇
date: 2019-10-09 20:23:16
tags: linux
---
![赛博朋克儿](feiji.jpg)
<!--more-->
## 开关机
1.sync:把内存中的数据写到硬盘中(每次关机之前重启之前都要执行)
2.shutdown -r now或rebot:立刻重启
3.shutdown -h now：立刻关机
4.shutdown -h 20:00 预定时间关机，如果今天过了预定的时间则明天这个时候关机
5.shutdown -h +10:预定时间关机，10分钟后关机。
6.shutdown -c:取消关机
## 系统信息
1.who am i:查看当前使用的终端
```bash
[root@izwz9938t1plpjtmzr7adqz ~]# who am i
root     pts/0        2019-10-09 21:16 (117.152.78.143)
```
2.who 或 w :查看所有终端
3.uname -m:显示机器的处理器架构
4.cat/proc/version 查看linux版本信息
5.