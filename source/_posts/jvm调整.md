---
title: jvm调整
date: 2019-11-19 12:49:15
tags: jvm
---
![封皮](jvm.jpg)
<!--more-->
##有关jvm堆内存的一次调整记录
	项目中需要一次读入一个很大的列表，大概5-6万条左右，本地跑着没有啥问题，然后拉到生产环境上面去，就只返回一个200的code，啥都没有，赶紧去翻log，发现有一个异常java.lang.outofMemory,按理说应该就没啥好说的了，动手到tomcat的catelina.bat或者是linux的catelina.sh
```shell
set "JAVA_OPTS=-Xms512m -Xmx1024m" 
```
按理说这么一搞，重启一下，应该就没问题了，堆的大小应该就够用了
然而事情哪有这么简单，有的人用winserver做服务器，启动，关闭，重启都在系统服务里做了，倒是方便，可是你会发现不管怎么配置catelina.bat，那个讨人厌的oom都不会消失折腾了好久终于发现，windowsserver系统服务中的启动关闭，用的都是tomcat.exe,读取的设置压根就不是catelina，而是系统的注册表，而且这个注册表的结构和普通的windows的结构还不是很一样，最终在这个目录下面
`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0\Tomcat\Parameters\Java`
找到了那两个值的设置位置。
啥都不想说了，心中一万个草泥马飞奔而过。。。

