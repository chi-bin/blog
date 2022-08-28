---
title: Hexo上传的图片在网页上无法显示的解决办法
date: 2019-06-01 21:46:59
tags: 博客
---
## 问题
hexo 建立的博客，想传图片进去，就在source目录下面创建了一个image发现不行，然后又在头像的目录下面创建了一个sorimg的目录，把图片放进去了，这次运行起来主页终于有图片了，可是当点进“展开全文”的标签时，内容页图片丢失..
想要完美的插入一张图片
<!--more-->
## 解决
1. 找到你自己博客根目录下的_config.yml里的post_asset_folder，把这个选项从false改成true。
``	post_asset_folder: true``
2. 根目录下下载 上传图片的插件，运行npm（或者cnpm）
``npm install hexo-asset-image --save``
3. 创建你的文章，就会发现现在的source目录下面不只有md文件，还会多出来一个文件夹
`` PS C:\Users\GSS\git\chi-bin_bo> hexo new "windows 当前目录下打开控制台"``
![开始的地方](a.png)
4. 把想要添加的图片放进该文件夹中，md中如下调用
`` ![alt](a.png)``
