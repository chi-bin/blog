---
title: Tomcat
date: 2019-10-09 13:04:16
tags: Tomcat
---
![tomcat](tom.png)
<!--more-->
## 什么是Tomcat
Tomcat 服务器是一个免费的开放源代码的Web 应用服务器，属于轻量级应用服务器，也是一个Servlet/JSP容器。Tomcat作为Servlet容器，负责处理客户端请求，把请求传送给Servlet，并将Servlet的响应返回给客户端。同时也具备处理静态页面的能力。多与Apache或是nginx搭配使用
## Tomcat的构成和处理请求的流程
+ Tomcat是一个基于组件的服务器，它的构成组件都是可配置的。其各个组件都在Tomcat安装目录下的../conf/server.xml文件中配置。
+ 通过之后的配置文件的源码解读，我们将会了解到tomcat的核心组件主要有两个，一个是Connector,还有一个是Container

+ 根据我的理解就是，connector负责在某一个指定的端口上面监听客户的请求，接受浏览器发过来的tcp链接请求，创建一个request和response对象负责交换数据，然后会产生一个线程来处理这个请求，并把这两个对象传给Engine,从Engine中获得相应再传给客户端。多线程的思想是Connector设计的核心。
+ 而container是什么呢？就是容器的父接口，简单理解的话就是搭载了servlet应用程序的地方。他的体系结构如下图
![jiegou](jiegou.jpg)
+ 是一个责任链的设计模式主要由4个子容器组件构成，分别是Engine,Host,Context,Wrapper
	1. Engine容器比较简单，定义了一些基本的关联关系链接到host容器。
	2. Host是Engine容器的子容器，一个Host在Engine中代表着一个虚拟主机。这个虚拟主机的作用就是运行多个应用，他负责安装和展开这些应用。并且标识这个应用以便能够区分它们，他的子容器通常是Context它除了关联子容器之外还有一些主机的相关的信息。
	3. Context代表了servlet的Context，他具备了servlet运行的基本条件，理论上有了context就可以运行servlet了，他最重要的功能就是管理里面的servlet实例，而servlet的实例在Context中是以wrapper的形式出现的。Context通过request来找到对应的wrapper来执行。
	4. Wrapper，代表了一个servlet的实例，负责管理一个servlet的生命周期，包括装载，初始化，执行，以及资源的回收，他的实现类是StandardWrapper，他实现了一个初始servlet的信息类servletconfig。wrapper就是tomcat的最底层了，他没有子容器。

+ 除此之外，Tomcat中还有其他重要的组件，如安全组件security、logger日志组件、session、mbeans、naming等其他组件。这些组件共同为Connector和Container提供必要的服务。

+ 接下来我们模拟一下当有一个请求来到tomcat时会发生什么
![流程](liucheng.jpg)
	1. 用户在浏览器中输入网址localhost:8080/test/index.jsp，请求被发送到本机端口8080，被在那里监听的Coyote HTTP/1.1 Connector获得；
	2. Connector把该请求交给它所在的Service的Engine（Container）来处理，并等待Engine的回应；
	3. Engine获得请求localhost/test/index.jsp，匹配所有的虚拟主机Host；
	4. .Engine匹配到名为localhost的Host（即使匹配不到也把请求交给该Host处理，因为该Host被定义为该Engine的默认主机），名为localhost的Host获得请求/test/index.jsp，匹配它所拥有的所有Context。Host匹配到路径为/test的Context（如果匹配不到就把该请求交给路径名为“ ”的Context去处理）；
	5. path=“/test”的Context获得请求/index.jsp，在它的mapping table中寻找出对应的Servlet。Context匹配到URL Pattern为*.jsp的Servlet，对应于JspServlet类；
	6. 程序地干活
	7. Context把执行完之后的HttpServletResponse对象返回给Host
	8. 层层返回





## 配置文件的用途和含义
![peizhi](peizhi.png)
可以看到有Context.xml,Server.xml,tomcat-users.xml,以及web.xml这些配置文件。
### Context.xml文件解释
首先需要明确Context.xml是做什么的，他是Tomcat公用的环境配置文件，tomcat会定时的去扫描这个文件，发现文件被修改了之后（时间戳改变）就会自动的重新加载这个文件，而不需要重启tomcat，推荐在$CATALINA_BASEconf/context.xml进行独立配置。就是说在单独的context中进行配置而不在server.xml中去做配置。因为server.xml是不可动态加载的资源。要重启服务器才可以重新加载。
```xml
<Context path="/eml" docBase="eml" debug="0" reloadbale="true" privileged="true">  
       
    <WatchedResource>WEB-INF/web.xml</WatchedResource>  
       
    <WatchedResource>WEB-INF/eml.xml</WatchedResource> #监控资源文件，如果web.xml || eml.xml改变了，则自动重新加载改应用。  
    <Resource name="jdbc/testSiteds" 　　#表示指定的jndi名称  
    auth="Container" 　　#表示认证方式，一般为Container  
    type="javax.sql.DataSource"  
    maxActive="100" 　　#连接池支持的最大连接数  
    maxIdle="40" 　　　　#连接池中最多可空闲maxIdle个连接  
    maxWait="30000" 　　#连接池中连接用完时,新的请求等待时间,毫秒  
    username="txl" 　　　#表示数据库用户名  
    password="123456" 　　#表示数据库用户的密码  
    driverClassName="com.mysql.jdbc.Driver" 　　#表示JDBC DRIVER  
    url="jdbc:mysql://localhost:3306/testSite" /> 　　#表示数据库URL地址  
 
</Context>
```
context.xml的三个作用范围
+ tomcat server级别：  在/conf/context.xml里配置
+ Host级别：  在/conf/Catalina/${hostName}里添加context.xml，继而进行配置
+ web app 级别：  在/conf/Catalina/${hostName}里添加${webAppName}.xml，继而进行配置

### Server.xml文件解释
server.xml是对tomcat的设置，可以设置端口号，添加虚拟机这些的，是对服务器的设置
```xml
<?xml version="1.0" encoding="UTF-8"?>
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />
  <GlobalNamingResources>
  <!-- 全局命名资源，来定义一些外部访问资源，其作用是为所有引擎应用程序所引用的外部资源的定义 --!> 
    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>
  <Service name="Catalina">
      <Connector port="80" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" /> 
   <!-- 修改HTTP/1.1的Connector监听端口为80.客户端通过浏览器访问的请求，只能通过HTTP传递给tomcat。还可以设置server与URIEncoding参数 --> 
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
    <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />
    <Engine name="Catalina" defaultHost="localhost">
	   <!-- <Engine name="Catalina" defaultHost="test.com">--> 
	    <!-- 修改当前Engine，默认主机是，localhost  --> 
      <Realm className="org.apache.catalina.realm.LockOutRealm">
	   # Realm组件，定义对当前容器内的应用程序访问的认证，通过外部资源UserDatabase进行认证 
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>
      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
			<!--定义了一个主机，域名是localhost，应用程序的目录是/webapps,设置自动部署解压-->
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
		 <!--   定义一个Valve组件，用来记录tomcat的访问日志，日志存放目录为：/web/www/logs如果定义为相对路径则是相当于$CATALINA_HOME，并非相对于appBase，这个要注意。定义日志文件前缀为www_access.并以.log结尾，pattern定义日志内容格式，具体字段表示可以查看tomcat官方文档   --> 
               prefix="localhost_access_log" suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />
			   <!--可以在这里添加别名<Alias>www.test.com</Alias> -->
		<!--<Context path="" docBase="www/" reloadable="true" /> 
		定义该应用程序，访问路径""，即访问www.test.com即可访问，网页目录为：相对于appBase下的www/，即/web/www，并且当该应用程序下web.xml或者类等有相关变化时，自动重载当前配置，即不用重启tomcat使部署的新应用程序生效  --> 
      </Host>
	  Host name="manager.test.com" appBase="webapps" unpackWARs="true" autoDeploy="true"> 
	        <!--   定义一个主机名为man.test.com，应用程序目录是$CATALINA_HOME/webapps,自动解压，自动部署   --> 
	          <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="172.16.100.*" /> 
	          <!--   定义远程地址访问策略，仅允许172.16.100.*网段访问该主机，其他的将被拒绝访问  --> 
	          <Valve className="org.apache.catalina.valves.AccessLogValve" directory="/web/bbs/logs" 
	                 prefix="bbs_access." suffix=".log" 
	                 pattern="%h %l %u %t &quot;%r&quot; %s %b" /> 
	          <!--   定义该主机的访问日志      --> 
	        </Host> 
    </Engine>
  </Service>
</Server>
```
一个 server 有一个 service，一个 service 里有多个 connector 和一个 engine，不同的 connector 除了端口可能不同，协议也可能不同。多个connector 对应一个 engine。　　engine 代表我们应用程序的容器。一个 engine 中有一个到多个 host，一个host 代表我们的一个虚拟主机。host 里又有一个到多个 context，一个 context 代表了一个应用程序的虚拟子站点。

### tomcat-users.xml文件解释
这个是使用tomcatMannager才需要配置的属性。
### web.xml文件解释
Web应用程序描述文件，都是关于是Web应用程序的配置文件。所有Web应用的 web.xml 文件的父文件。
这个文件是基本不用配置的，如果要支持cgi的话，要在这里面吧cgi的那一段儿注释掉。
```xml
<servlet>
        <servlet-name>default</servlet-name>
        <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
        <init-param>
            <param-name>debug</param-name>
            <param-value>0</param-value>
        </init-param>
        <init-param>
            <param-name>listings</param-name>
            <param-value>false</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
```
