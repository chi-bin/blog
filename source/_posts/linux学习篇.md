---
title: linux学习篇
date: 2019-10-15 16:56:05
tags: linux
---
![linux](linux.jpg)
<!--more-->
# 预备知识
## 首先，要准备一个linux的系统，不管是虚拟机，或者是云端的服务器，或者是win10商店中的Ubuntu，都可以试一试
win10 下开启 控制面板->程序->启用或关闭windows功能->适用于Linux的windows子系统->重启。
应用商店里搜索：linux，下载Ubuntu启动就可以了。
![ubuntu](ubuntu.png)
做一个简简单单的小测试吧，使用ps命令查看自己的控制台是哪个程序
```bash
gss@DESKTOP-4H90EP2:~$ ps
  PID TTY          TIME CMD
   34 tty1     00:00:00 bash
   49 tty1     00:00:00 ps
gss@DESKTOP-4H90EP2:~$
```
**我们都知道文档是很重要的，那么Linux系统早期发布的系统是通常没有纸质版的参考手册，可是联机文档一直是他的强项之一，怎么找到和使用之呢？**
+ 大多数的GUN实用程序都有-help命令显示帮助信息
+ 使用man 如man man,man git,空格翻页，man password 将找到password在man页中对应的内容
+ appropos 使用关键字和appropos 可以查找某个任务的命令，appropos会在man页的顶行信息中找到搜索关键字，whatis 可以准确搜索，结果会是完全匹配的
+ info程序：显示使用程序的说明文档，空格翻页，/+字符串进行查找
**linux更改密码**
+ 在命令行中输入passwd即可修改密码，系统会先询问你旧密码，之后输入新密码

# 实用程序
## 关于shell
**shell的特殊字符**
```shell
& ; | * ? ' " ` [] () $ <> {} # / \ ! ~
```
## 基本工具
**ls**
+ 显示文件名和目录名
+ 可以执行 info ls 来看文档
**cat**
+ 显示文本文件的内容
```bash
gss@DESKTOP-4H90EP2:~$ vi gss
gss@DESKTOP-4H90EP2:~$ ls
gss
gss@DESKTOP-4H90EP2:~$ cat gss
各位小伙伴们大家好呀！
gss@DESKTOP-4H90EP2:~$
```
**rm**
+ 删除文件
+ 跟文件名在后面会直接删除，
+ rm -i file 这种命令会有提示询问是否删除
**less,more**
+ 分页程序，当文件的内容超过一页的时候，使用之
+ less filename
+ more filename
**hostname**
+ 显示正在使用的主机名字
```bash
gss@DESKTOP-4H90EP2:~$ hostname
DESKTOP-4H90EP2
```
## 文件操作
**cp**
+ 复制文件，对任何文件进行复制，包括文本文件或是可执行文件（二进制文件）
+ cp source-file(源文件) destinnation-file（目标文件名）
+ 如果cp的目标文件是一个已经存在的文件，那么cp会重写这个文件，没有提示，所以要慎重的使用cp,同理使用 -i后缀可以有提示
**mv**
+ 更改文件名
+ mv afilename newfilename
+ mv 也会覆盖文件，建议加-i
**lpr**
+ 把文件放到打印序列中按行打印
+ lpr -P machenname filename 选择打印机打印file
+ lpq可以查看打印队列中的作业
+ lprm 88：把序号是88的作业删除
**grep**
+ 查找字符串
+ grep '关键字' filename
+ 不止可以在文件中找
**head**
+ 默认显示文件的前10行信息
+ month -数字 filename:显示文件的前几行
+ 还可以按照块儿或者字符显示
**tail**
+ 显示文件的尾部
+ 与head类似
+ 可以用这个监控逐渐增长的某个文件的内容
**sort**
+ 将文件内容按行排序之后输出来，但是不改变文件内容
+ -u:使得排序列表的每一行都唯一
+ -n:对一列数排序
**uniq**
+ 用来显示文件内容，对于重复的行只显示一行，不会改变源文件的内容
+ sort+uniq等同于带u的sort
**diff**
+ 比较两个文件显示两者所有的不同之处
+ 带上-u会说明比较得是哪两个文件
+ 查看更多信息可以info
**file**
+ 获得Linux系统中任何文件的内容信息
```bash
gss@DESKTOP-4H90EP2:~$ file gss
gss: UTF-8 Unicode text
gss@DESKTOP-4H90EP2:~$
```
## 管道：实现进程间的通信
+ 表示：|
+ 把一个进程的结果当成另一个进程的输入传递进去
+ 如sort months | head -4  把拍好序的month的前四行输出
+ 管道是linux不可缺少的功能
## 重要的四个程序
**echo**
+ 显示文本
+ echo把命令行中除了echo的所有东西复制到屏幕上
```bash
gss@DESKTOP-4H90EP2:~$ echo hi
hi
gss@DESKTOP-4H90EP2:~$ echo i love linux
i love linux
gss@DESKTOP-4H90EP2:~$ echo

gss@DESKTOP-4H90EP2:~$ echo 复读机
复读机
gss@DESKTOP-4H90EP2:~$
```
+ 通过echo可以把输出重定向到文件中，如echo 'hello' > gss,就是把echo放到gss中
**date**
+ 显示当前的日期和时间
```bash
gss@DESKTOP-4H90EP2:~$ date
Tue Oct 15 20:20:20 CST 2019
```
+ 跟一些参数
```bash
gss@DESKTOP-4H90EP2:~$ date +"%A %B %d"
Tuesday October 15
gss@DESKTOP-4H90EP2:~$ date +"%A %b %d"
Tuesday Oct 15
gss@DESKTOP-4H90EP2:~$ date +"%A %b %D"
Tuesday Oct 10/15/19
gss@DESKTOP-4H90EP2:~$ date +"%a %b %D"
Tue Oct 10/15/19
gss@DESKTOP-4H90EP2:~$
```
**script**
+ 记录shell会话信息
+ 键入script,就开始记录，键入exit结束记录
+ 可以记下来命令行之间的交互内容，如
```bash
gss@DESKTOP-4H90EP2:~$ script
Script started, file is typescript
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

gss@DESKTOP-4H90EP2:~$ whoami
gss
gss@DESKTOP-4H90EP2:~$ pwd
/home/gss
gss@DESKTOP-4H90EP2:~$ exit
exit
Script done, file is typescript
gss@DESKTOP-4H90EP2:~$ cat typescript
Script started on 2019-10-15 20:33:27+0800
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

gss@DESKTOP-4H90EP2:~$ whoami
gss
gss@DESKTOP-4H90EP2:~$ pwd
/home/gss
gss@DESKTOP-4H90EP2:~$ exit
exit

Script done on 2019-10-15 20:33:54+0800
```
**todos**
+ 把linux中的文本文件转换成Windows格式
+ todos gss.txt
##压缩和归档文件
**bzip2**
+ 这个软件适合重复信息很多的图片，如文本和图像，压缩效果很好
+ 但是使用的时候，会删掉原来的文件，可以使用 bzip -k filename 来保留源文件
+ bzip2 filename   会自动生成一个filename.bz2压缩包
```bash
gss@DESKTOP-4H90EP2:~$ bzip2 gss2
gss@DESKTOP-4H90EP2:~$ ls
gss  gss2.bz2  sfile  typescript
gss@DESKTOP-4H90EP2:~$ 
```
**bunzip2和bzcat**
+ 用来解压文件
+ 同样的用法，注意也会删掉压缩包
**tar**
+ 打包和解包文件
+ 打包：tar -cvf afile bfile cfile
+ 解包：tar -xvf xxx.tar
+ 使用man可以查看更多的内容
## 定位命令
**which和whereis**
+ 定位实用程序
+ 一个概念：搜索路径：输入一个linux命令之后，shell将在一组目录下查找具有该名称的程序，并运行找到的第一个，这组目录被叫做搜索路径，可以更改，日后再讲（猜测是环境变量类似的），如果不改变，就只在标准路径下搜索，然后停止。
+ which：通过显示程序的完整路径来帮助查找之
```bash
gss@DESKTOP-4H90EP2:~$ which tar
/bin/tar
```
+ whereis:在标准路径下搜索与实用程序相关的文件
+ 这俩只能报告在磁盘上的程序路劲，无法找到内置命令，要是想要确认命令是不是内置命令，可以使用type 如：type echo
```bash
gss@DESKTOP-4H90EP2:~$ type locate
locate is hashed (/usr/bin/locate)
gss@DESKTOP-4H90EP2:~$ type echo
echo is a shell builtin
```
**slocate/locate**
+ 搜索文件
+ 用于在本地文件系统上搜索文件
+ locate file
## 获取用户和系统信息
怎么显示正在使用系统的用户，以及显示他们在做什么，和系统如何运行的信息
**who**
+ 最老的实用程序，给出登录到本地系统的用户列表，每个用户在使用的设备，和每个用户登录的时间。
**w**
+ 当希望和本地系统上的其他用户通信的时候，会很有用，比who的功能更加强大，
## 与其他用户进行通信
**write** 
+ 给另一个登录用户发送消息
**mesg**
+ 拒绝或接受消息

# Linux文件系统
文件系统是一组数据结构，驻留在磁盘中用来组织和管理文件的目录
## 目录树
linux文件系统也被称为树，由一系列相互关联的文件组成，树状结构方便了文件的组织与查找。在标准linux系统上，每个用户都有自己的一个目录，在这个目录下，用户可以添加多个子目录来尽可能满足自己的需求。
## 文件和文件名
使用 ls -a 可以显示隐藏文件（以.开始的文件名）一般启动文件的文件名都是以.开始的
**工作目录**
+ pwd:显示当前的工作目录
+ 主目录：/home/具体用户
```bash
gss@DESKTOP-4H90EP2:~$ pwd
/home/gss
```
## 目录操作
**mkdir**
+ 创建目录
+ 可以使用mkdir + 目录名
+ 也可以使用mkdir+绝对路径
**cd**
+ 更改工作目录
+ mkdir在创建目录的时候，会自动创建两个目录.和..这两个，.代表该目录本身。..代表上一级
**rmdir**
+ 用来删除目录
+ 注意，要是想要删除的文件目录中含有文件，那么只有在删掉了其中的文件之后才能删掉这个目录
+ 使用rm -r可以递归的删除文件目录和文件目录的子目录
+ 但是务必要慎重使用rm -r
**mv/cp**
+ 移动和复制文件
+ 上一个标题中，我们有提到过mv可以重命名，事实上，移动文件也是使用这个命令
+ mv filelist directory:把一组文件（列表显示）移动到一个目录中
+ 同理可以移动目录，只要把文件列表改成目录列表就行了
## 重要的标准目录和文件
```bash
gss@DESKTOP-4H90EP2:/$ ls
bin   dev  home  lib    media  opt   root  sbin  srv  tmp  var
boot  etc  init  lib64  mnt    proc  run   snap  sys  usr
gss@DESKTOP-4H90EP2:/$
```
| 目录名 | 说明 |
|:---|:---:|
|/|根目录|
|/bin|基本命令的二进制文件|
|/boot|引导加载程序的静态文件|
|/dev|设备文件|
|/etc|本地计算机系统配置文件|
|/etc/opt|包含/opt目录下插件软件的配置文件|
|/home|用户目录的爹目录|
|/lib|共享库|
|/lib/modules|可加载的内核模块|
|/mnt|临时挂载文件系统的挂载点|
|/opt|可选的插件软件包|
|/proc|虚拟文件系统的内核和进程信息|
|/root|root账户的主目录|
|/sbin|基本的二进制系统文件|
|/sys|设备的伪文件系统|
|/tmp|临时文件夹|
|/usr|辅助层次结构|
|/usr/bin|大多数的用户命令|
|/usr/game|游戏和教学程序|
|/usr/include|c程序包含的头文件|
|/usr/lib|库|
|/usr/local|本地层次结构|
|/usr/sbin|用于系统管理的次要二进制文件|
|/usr/share|与体系结构无关的数据|
|/var|变量数据，系统运行时内容会改变的文件，像是日志文件啦，临时文件啦等等|
## 访问权限
**ls -l**
+ 显示访问权限
```bash
gss@DESKTOP-4H90EP2:~$ ls -l
total 0
-rw-rw-rw- 1 gss gss  34 Oct 15 19:29 gss
-rw-rw-rw- 1 gss gss  75 Oct 15 19:40 gss2.bz2
-rw-rw-rw- 1 gss gss   0 Oct 15 20:30 sfile
-rw-rw-rw- 1 gss gss 476 Oct 15 20:33 typescript
```
+ 第一个字符是文件类型，普通文件是-,目录文件是d
+ 后九个是访问权限
+ 链接数目
+ 所有者
+ 组用户（对文件有访问权限的组）
+ 文件大小
+ 时间戳
+ 文件名
**chmod**
+ 改变文件权限
+ 具有root权限的用户可以访问任何文件
+ 读写执行（4+2+1）
## 链接
+ 链接表示指向文件的指针
+ 链接共有两种：硬链接和符号链接（软连接），硬链接较老，已经过时啦
+ 创建硬链接 In file /lujing/mingzi
+ 软链接的优点：可以指向不存在的文件，如果有一个文件删除了，然后重新创建了，那么软连接还可以指向这个新创建的文件。硬链接就只能一直指向那个旧的链接
+ 包含-s或是--symbolc的In命令可以创建一个符号链接
+ 使用rm删除链接
# shell
## 执行命令行
**进程**
+ 如果shell找到了与命令行上的命令具有相同名称的可执行文件，那么shell将启动一个新的进程，并且将命令行上的参数，命令名，传给调用的程序，所有的错误信息或者是返回信息都是程序的，有的程序会忽略错误的东东。
## 标准输入输出
**标准输入**
+ 是程序或者命令获得数据信息的地方
**标准输出**
+ 是程序输出输出数据的地方
+ 在linux中，各种设备是被当做文件进行读取或者写入的，都挂在dev的下面。
+ 以cat为例，如果cat file那么file将会被cat当做是他的输入，如果cat后面没有参数，那么cat将会从标准输入中获得输入，就是默认的键盘，因此，输入一些东西之后按回车，cat将会把输入的东西打印出来。
## 重定向
**标准输出的重定向**
+ 符号：>
+ 可以使shell将命令的输出重定向到指定的文件而不是屏幕
+ 如 ls -l >filename
+ 注意，如果文件已经存在那么会覆盖掉
+ 使用>>符号可以向文件尾部追加信息
**标准输入的重定向**
+ 符号： <
+ 使用这个可以让shell把命令的输入重定向到指定的文件而不是键盘，
+ 如 cat < filenaem
**/dev/null**
+ 垃圾桶，可以把不想看到的或是不想保存的数据重新定位到这里来，就销毁了
## 管道
shell使用管道将一条命令的标准输出作为另一条命令的标准输入。
语法格式有提到过：command_a something | command_b
**过滤器**
+ filter是将输入数据流处理后再输出数据流的一类命令。
+ 像who|sort|lpr这条命令中，把who的结果sort之后给打印机，那么sort就是一个过滤器
**tee**
+ tee 可以把标准输入复制到文件和标准输出，只有一个输入，但是双向输出
+ 如 who| tee who.out|grep root
## 后台运行程序
**作业**
+ 是指一系列的命令组成的序列，前台只能有一个作业位于窗口或是屏幕中，但是后台可以有很多作业运行，同一时间运行多个作业是linux的重要特性，这常称为多任务特性
**作业编号与PID**
+ 在命令行的末尾输入&后回车，那么该作业就会转为后台作业，linux会给他分配一个PID
+ 当该作业运行结束的时候，shell会显示一条信息，这条信息的内容是已结束的作业PID和该命令的结果
```bash
gss@DESKTOP-4H90EP2:~$ ll &
[1] 30
gss@DESKTOP-4H90EP2:~$ total 16
drwxr-xr-x 1 gss  gss   512 Oct 15 20:43 ./
drwxr-xr-x 1 root root  512 Oct 15 17:41 ../
-rw------- 1 gss  gss  1066 Oct 15 21:46 .bash_history
-rw-r--r-- 1 gss  gss   220 Oct 15 17:41 .bash_logout
-rw-r--r-- 1 gss  gss  3771 Oct 15 17:41 .bashrc
-rw-r--r-- 1 gss  gss   807 Oct 15 17:41 .profile
-rw------- 1 gss  gss  1226 Oct 15 20:35 .viminfo
-rw-rw-rw- 1 gss  gss    34 Oct 15 19:29 gss
-rw-rw-rw- 1 gss  gss    75 Oct 15 19:40 gss2.bz2
-rw-rw-rw- 1 gss  gss     0 Oct 15 20:30 sfile
-rw-rw-rw- 1 gss  gss   476 Oct 15 20:33 typescript
```
**后台转前台**
+ 输入fg可以把后台唯一的作业转到前台，如果fg后面跟了参数，那么就是PID的作业会被转到前台
**kill**
+ 终止后台作业，输入kill和PID终止该进程
**ps**
+ 确定PID
+ 如，使用tail -f outfile,监视gss,把它放到后台
```bash
gss@DESKTOP-4H90EP2:~$ tail -f gss&
[1] 32
gss@DESKTOP-4H90EP2:~$ 各位小伙伴们大家好呀
```
+ ps一下
```bash
gss@DESKTOP-4H90EP2:~$ ps
  PID TTY          TIME CMD
    7 tty1     00:00:00 bash
   32 tty1     00:00:00 tail
   50 tty1     00:00:00 ps
gss@DESKTOP-4H90EP2:~$
```
+ kill 一下
```bash
gss@DESKTOP-4H90EP2:~$ kill 32
gss@DESKTOP-4H90EP2:~$ ps
  PID TTY          TIME CMD
    7 tty1     00:00:00 bash
   51 tty1     00:00:00 ps
[1]+  Terminated              tail -f gss
gss@DESKTOP-4H90EP2:~$
```
目前这篇博文就到这里啦，关于vim和一些命令的总结会有单独的文章出来的。
