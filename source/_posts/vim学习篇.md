---
title: vim学习篇
date: 2019-10-16 11:49:56
tags: linux
---
![vim-linux文本程序](vim.jpg)
<!--more-->
在Linux上干活，没有个顺手的编辑器怎么行，之前对vim的了解都浅的发指，这次准备深耕一下。
vim是最早的一种交互式的可视化文本编辑器，功能很强大
## 用vim创建和编辑文本文件
**启动vim**
+ 使用vim filename 可以创建一个名字是filename的文件。
+ vi也可以
**Esc**
+ 进入命令模式
**：**
+ 最后一行模式，光标将始终处于屏幕底部。当按下return后才会回到他在文本中的位置
**i**
+ 输入模式，输入文本之前要按
**移动光标**
+ 删除，插入和校准都需要在屏幕上移动光标。当vim处于命令模式时间，可以使用return，空格，和方向键，没有方向键的也可使用h,j,k,l
**删除**
+ 删除字符：x
+ 删除字：dw
+ 删除行：dd
**撤销操作**
+ 命令行输入：u
+ 重做当撤销了某条命令后又想重新执行该命令：redo
**添加文本**
+ 向已有文本内容的文本中插入新文本的步骤是：首先将光标移动到新文本位置之后的字符上，然后输入i,使vim处于输入模式
+ 光标移动到位，使用a进行追加内容
**结束**
+ 在编辑的过程中，vim将编辑的文本放到工作缓冲区中，当结束编辑时，必须将工作缓冲区的内容写入磁盘
+ 在命令模式下输入ZZ（大写），将新写入的内容写到磁盘中，这样才能保存已经编辑的文本。
+ 不想保存：q！
## vim的操作模式有几种：
+ vim命令模式 按下esc而没有按：的那种模式
+ vim输入模式 按下i的模式
+ 最后一行模式 按下：的模式
+ 最后一行模式和命令模式的不同点在于：光标位置不同，命令模式中结束命令不必按return
## 显示
**状态行**
+ 会在底部显示状态信息
**重绘屏幕**
+ 命令模式下 CONTROL+L
有的时候乱了就用这个扭曲啊啥的
**代字符**
+ ~ :一个波浪线
+ 到达文件的末尾的时候会显示一个代字符
**行长度和文件大小**
+ vim对两个换行符中间的长度没有限制，它仅售可用内存的影响
**窗口**
+ vim允许打开，关闭，和隐藏多个窗口，每个窗口可以分别用于编辑不同的文件。多数窗口命令由CONTROL+W和另一个字母组成。
+ CONTROL+W s:打开另一个窗口分割屏幕来编辑同一个文件
+ CONTROL+W n:打开一个窗口来编辑一个空文件；
+ CONTROL+W w:将光标在窗口中移动
+ CONTROL+W q:关闭或退出窗口
**崩溃后的文本回复**
+ vim会把操作过得交换文件零食存储起来，如果系统突然崩溃，那么可以根据这些临时文件对文件进行恢复。
+ 使用vim -r来确认交换文件是否存在
**光标移动**
+ H键将光标定位到屏幕顶部一行的最左端；M键将光标定位到屏幕的中间一行；L键将光标定位到底部一行。
**替换文本**
+ 命令r
**查找替换**
+ 查找：f:在当前行查找指定字符并将光标移动到他下一次出现的位置
+ t/T：与查找命令具有相同的用法。
+ 查找字符串：按/键输入要查找的字符串。
+ 按n键找下一个
+ ^:如/^the:将搜索以the开始的下一行
+ $:行尾匹配符如/end$以end结束的句子
+ .：任意字符如：l..t可以是loit,loot等等中间的两个字符随便
+ /*:0次或多次出现，这个字符是一个修饰符，如/dis\*m,匹配di+0个或多个s的字符串
+ []:将两个或者多个字符括起来的方括号，与方括号内的单个字符匹配。如/dis[ck],找disc或disk
---
暂且留住，日后用到的时候继续补充。。。