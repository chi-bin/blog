---
title: 关于git的自动部署
date: 2019-11-20 11:31:50
tags: linux
---
![封面](fengpi.jpg)
<!--more-->
## 目标
	完成项目的自动部署，当git提交上去了之后，就不用人为部署了
**思路**
1. 主要通过git项目设置的webhook来实现，能在得到git -push被触发之后发送到一个接口 来传递参数。
2. 本地上传项目，即执行git -push项目
3. 服务器端需要一个shell脚本。来存放部署的命令。比如，`cd /root/webapps/xiang_mu`,`git pull`
4. 服务器端要有一个服务接口，用来接收git webhook发来的信息以及执行shell脚本，比如node.js来跑脚本
5. 安装pm2来管理node项目的运行等等。

**博客自动部署试验**
先到服务器，去设置好基本目录，比如使用nginx设置/root/webapps/xiang_mu 为项目目录

1. 在自己想要的地方存放脚本等文件。比如/root
2. 生成一个deploy.sh的shell脚本,存放想要执行的命令
```shell
cd /root/webapps/xiang_mu
git pull
```
3. 生成一个deploy.js的js脚本
```js
var http = require('http')
var spawn = require('child_process').spawn
var createHandler = require('/usr/local/lib/node_modules/github-webhook-handler')
var handler = createHandler({
  path: '/gitpush',
  secret: 'c74262464'
})
http.createServer(function (req, res) {
  handler(req, res, function (err) {
    res.statusCode = 404;
    res.end('no such location')
  })
}).listen(8100)

handler.on('error', function (err) {
  console.error('Error:', err.message)
})
handler.on('push', function (event) {
  console.log('Received a push event for %s to %s',
    event.payload.repository.name,
    event.payload.ref)
  rumCommand('sh', ['./deployed.sh'], function (txt) {
    console.log(txt)
  })
})
function rumCommand(cmd, args, callback) {
  var child = spawn(cmd, args)
  var response = ''
  child.stdout.on('data', function (buffer) {
    response += buffer.toString()
  })
  child.stdout.on('end', function () {
    callback(response)
  })
}
//这里要注意自己/usr/local/lib/node_modules/github-webhook-handler，就是安装github-webhook-handler的位置。不然会报错
```
4. 安装好了pm2之后运行起来pm2.json脚本`pm2 start pm2.json`
内容如下：
```js
[{
  "name": "test",
  "script": "deployed.js",
  "env_dev": {
    "NODE_ENV": "development"
  },
  "env_production": {
    "NODE_ENV": "production"
  }
}]

```
使用`pm2 list`查看服务是否启动了
```shell
[root@izwz9938t1plpjtmzr7adqz ~]# pm2 list
┌────┬────────────────────┬──────────┬──────┬──────────┬──────────┬──────────┐
│ id │ name               │ mode     │ ↺    │ status   │ cpu      │ memory   │
├────┼────────────────────┼──────────┼──────┼──────────┼──────────┼──────────┤
│ 0  │ test               │ fork     │ 15   │ online   │ 0.1%     │ 33.3mb   │
└────┴────────────────────┴──────────┴──────┴──────────┴──────────┴──────────┘
[root@izwz9938t1plpjtmzr7adqz ~]# 
```
5. 去github项目设置的webhook中设置接口。

