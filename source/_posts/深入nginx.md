---
title: 深入nginx
date: 2019-10-16 21:37:36
tags: nginx
---
![nginx](nginx.jpg)
<!--more-->
# 主要模块
+ cacheloader
+ master
+ worker

# 反向代理（Reverse Proxy）：

    什么是反向代理呢？本人最直接的理解是 将外部的请求，通过 Nginx 软件转向内部请求当中，并响应相关请求。Nginx接收外部的连接请求，然后将请求转发给内部服务器，并将结果反馈请求客户端，此时代理服务器的表现为一个反向代理服务器。目的就是为了真实的内部服务器不能直接外部网络访问。代理服务器的前提条件是该服务器能被外部网络访问的同时又跟真实服务器在同一个网络环境。
反向代理简单配置方式：
```xml
server {

　　listen　　80;

　　server_name　　localhost;

　　client_max_body_size 1024M;

　　location / {

　　　　proxy_pass　　http://localhost:8080;

　　　　proxy_set_header Host $host:$server:$server_port;

　　}
}
```
# 负载均衡
+ 2台或以上的应用服务器时，根据相应规则将请求分发到某台服务器上处理。负载均衡配置一般都需要跟反向代理同时配置，通过反向代理跳转到负载均衡。（目前负载均衡的技术点：硬件层面有F5负载均衡器，网络层层面有LVS(Linux Virtual Server)，应用层层面就是nginx、Haproxy等。）
+ 常用的 Nginx 负载均衡策略（RR（默认）、轮询、ip\_hash，fair、url\_hash）：
+ RR:一台一台轮着来。
```xml
upstream test {

　　server 192.168.1.22:8080;
　　server 192.168.1.23:8080;
}
server　　{　

　　listen　　80;

　　server_name localhost;

　　client_max_size 1024;

　　location / {

　　　　proxy_pass http://test;

　　　　proxy_set header  Host  $host:$server:$server_post;

　　　　}
}
```
+ 轮询策略：
　　RR （默认）:upstream按照轮询（默认）方式进行负载，每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除。虽然这种方式简便、成本低廉。但缺点是：可靠性低和负载分配不均衡。
　　weight(按权重轮询):指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况而设定。
```xml
upstream test {
   server 192.168.1.22 weight = 6； ---将 60% 的请求分配到该服务器中 
   server 192.168.1.23 weight = 4； ---将 40% 的请求分配到该服务器中
}
```
+ ip_hash方式：
每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题。配置只需要在upstream中加入"ip_hash;"即可。
```xml
upstream test {
　　ip_hash;
　　server 192.168.1.22:8080;
　　server 192.168.1.23 8080;
}
```
+ far方式（第三方）
  按后端服务器的响应时间来分配请求，响应时间短的优先分配。与weight分配策略类似。
  ```xml
  upstream test {
  　　far;
  　　server 192.168.1.22:8080;
  　　server 192.168.1.23 8080;
  }
  ```
+ url_hash（第三方）
   按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，后端服务器为缓存时比较有效。 在upstream中加入hash语句，server语句中不能写入weight等其他的参数，hash_method是使用的hash算法。
  ```xml
  upstream test {
  　hash $request_url;
　　hash_method crc32;

  　　server 192.168.1.22:8080;
  　　server 192.168.1.23 8080;
  }
  ```


