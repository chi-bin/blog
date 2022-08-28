---
title: springboot学习
date: 2019-11-26 16:21:24
tags: 
- SpringBoot
- JavaEE
---
tu
<!--more-->
##学习SpringBoot的一些记录
**运行方式：**
1. 创建好了项目之后在idea中或eclipse中启动
2. 在项目目录下打开控制台使用命令：mvn spring-boot:run
3. 打成jar包之后使用java -jar sss.jar
	打包方法：使用 mvn clean package
**项目配置**
1. application.properties中修改。默认是空的。假设修改如下

```xml
server.port=8181
server.context-path=/luckymoney
```
2. 使用.yml格式的配置文件进行书写。效果等同于第一种但是更加简洁易于阅读。位置放到application.properties这里就可以了
```xml
server
	port: 8181
	servlet:
		context-path: /luckymoney
		
minMoney: 2
description: 最少发${minMoney}元
```