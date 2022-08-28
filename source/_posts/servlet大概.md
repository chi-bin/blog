---
title: servlet大概
date: 2019-09-29 11:48:37
tags: servlet
---
## servlet是作为来自web浏览器或者是其他http客户端的请求和http服务器上的数据库或是应用程序的中间层。
<!--more-->
## 首先，servlet不是一个框架，他是服务器端运行的一个程序，是个被编译好的java类，web容器（web服务器）的启动需要依靠servlet，当web服务器开始执行的时候，servlet类就被初始化，
## Java Servlet 是运行在带有支持 Java Servlet 规范的解释器的 web 服务器上的 Java 类。
1. Servlet 可以使用 javax.servlet 和 javax.servlet.http 包创建，它是 Java 企业版的标准组成部分，Java 企业版是支持大型开发项目的 Java 类库的扩展版本。
2. 这些类实现 Java Servlet 和 JSP 规范。在写本教程的时候，二者相应的版本分别是 Java Servlet 2.5 和 JSP 2.1。
3. Java Servlet 就像任何其他的 Java 类一样已经被创建和编译。在您安装 Servlet 包并把它们添加到您的计算机上的 Classpath 类路径中之后，您就可以通过 JDK 的 Java 编译器或任何其他编译器来编译 Servlet。
## Java Servlet 通常情况下与使用 CGI（Common Gateway Interface，公共网关接口）实现的程序可以达到异曲同工的效果。但是相比于 CGI，Servlet 有以下几点优势：
1. 性能明显更好。
2. Servlet 在 Web 服务器的地址空间内执行。这样它就没有必要再创建一个单独的进程来处理每个客户端请求。
3. Servlet 是独立于平台的，因为它们是用 Java 编写的。
4. 服务器上的 Java 安全管理器执行了一系列限制，以保护服务器计算机上的资源。因此，Servlet 是可信的。
5. Java 类库的全部功能对 Servlet 来说都是可用的。它可以通过 sockets 和 RMI 机制与 applets、数据库或其他软件进行交互。
