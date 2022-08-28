---
title: Spring学习篇
date: 2019-10-16 16:00:23
tags: Spring
---
![spring](spring.jpg)
<!--more-->
# 前提知识
+ POJO编程模型：plain Old java Objects 就是简单的java对象,旨在简化java应用程序的编码，测试以及部署等阶段

+ EJB：EJB技术最先于1997年提出。他提供了一种与运行时平台相结合的分布式业务组件，该运行时平台提供了执行Ejb组件所需的所有中间件服务。在当时，Ejb是J2ee规范中的主要规范。但是他有很大的缺陷，1. 为了实现开发人员编写的代码和组件接口之间实现紧耦合，要实现很多组件的接口写一个应用程序类2. 可测试性是原来Ejb编程模型最大的问题之一。3.将开发人员转向了过程程序设计风格，随着时间的推移，EJB也在不断地改进
+ POJO模型的优点：写应用程序类那是非常简单。在一个，好测试，Junit在自己的IDE中就可以测试，

+ 轻量级容器：可以向应用程序提供一些基本的服务来保证应用程序的正常运行，如生命周期管理啊依赖解析什么的，当然要是能提供一些事务管理或是安全性的功能的话就更好了。而一个轻量级的容器，包括所有的上面说道的功能而不需要为了依赖这些api而编写应用程序代码。没有侵入的特性，启动很快。在企业级的java世界中，SpringApplicationFramework是最著名的轻量级容器之一。

+ 控制反转（IOC）：容器和组件能提供的最大的好处就是可以插拔的体系结构，容器的工作就是创建这些组件以及所依赖的服务，并将这些组件装配到一起。在组件类中，不需要新的操作符来实例化依赖组件，而是在运行时由容器实例将依赖组件注入组件，因此，对依赖项的控制由组件转到容器。就是把控制权交给了容器，我们把这种模式叫做控制反转（IOC），控制反转被认为是任何容器都 需要提供的基本功能之一，他主要有两种形式：依赖查找和依赖注入。 依赖查找中，容器向其管理的组件提供了回调方法，依赖注入中，组件提供了合适的额构造函数，或者Setter方法，以便容器可以注入依赖组件
最重要：解耦

+ Aop：面向切面IoC的目标是为了管理对象，通过依赖注入达到了对象之间的解耦，但是很多情况是面向对象没有办法处理的，比如生产部门的订单，生产部门，财务部门，三者是对象昂，但是财务部门发现预算超支，那么就不是财务部门一个的事了，还会影响到前面生产部门所做的审批，要把他们作废。我们把预算超支这个条件，叫做切面。面向切面的编程来去管理在切面上某些对象之间的协作。
	通常用来做数据库的事务编程，用异常作为消息，默认情况下接到了异常消息就会把数据库事务回滚，从而保证数据的一致性。

+ Setter注入：当一个对象在实例化之后就会马上调用setter方法，该注入在组件的创建或初始化阶段发生，并且在处理业务方法调用之前完成，最大的优点是运行时可以对组件进行重新配置，组件的依赖项可以在运行时更改，缺点：并不是所有的所需要的依赖项都可以在使用前被注入，从而使组件处于一种版配置的状态

+ 构造函数注入：使用构造函数的参数来表达依赖项，可以一次使容器中被管理的各个组件都处于同样的状态，并且在创建之后可以马上使用。代码量也会小一点。但是无法再对组件进行配置。

# Spring 依赖注入
## SpringIOC容器
SpringApplicationFramework的核心是他的IOC容器，介个容器的工作职责包括对应用程序的对象进行实例化、初始化、装配以及在对象的整个生命周期中提供其他的Spring功能。
**配置元数据**
啥是元数据：就是扫描bean包的那个xml就叫元数据，就是告诉容器去哪里找到我的组件，元数据有两种形式一种就是xml的那种另外就是注解的方式
```java
@Service("accountService")
public class AccountServiceImpl implements AccountService{
	private AccountsDao accountdao;
	@Autowired
	public void setAccountDao(AccountDao accountDao){
		this.accountdao=accountDao;
	}
}
@Repository("accountDao")
public class AccountDaoInMemoryImpl implements AccountDao{
	
}
```
上面这种就是使用了java注解的方式定义Bean，@Service和@Repository被用来定义两个bean，而实际上他们又是注解@Component的具体形式。此外@Autowired通常用来指定在运行时被Spring容器所注入的Bean依赖

**配置和使用容器**
Spring容器也是一个java对象，在某些特定的时间点被创建，并允许管理应用程序的其他部分，可以使用两种方法来实例化Spring容器。在独立的应用程序中，可是用编程的方法，而在web应用程序中，使用声明方法则是更好的选择

## 依赖注入
**setter**
+ setter注入是在Bean实例创建完毕之后执行，通过调用与bean的配置元数据中定义的所有属性相对应的Setter方法注入这些属性。此外还可以注入其他Bean依赖项和简单值，比如字符串，类，枚举等
+ 可以使用<property>的ref特性指定对其他bean的引用。
+ 还可以使用<property>的value特性注入其他依赖值，如int，boolean等等
+ Spring还允许注入Collection或是map值
**构造函数注入**
+ 构造函数注入依赖的一个缺点是无法处理循环依赖，假如有两个Bean ：a,b而这两个Bean通过各自的构造函数互相为依赖项，那么Spring容器就无法实例化这两个Bean，有点儿像死锁的感觉
**依赖的解析过程**
+ Spring容器的启动过程大致可以分成连个主要的阶段，第一个阶段，容器处理配置元数据，并建立元数据中存在的Bean定义，在该过程中还会对这些Bean定义进行验证。但是在这个阶段中，Bean还没有被创建，相关的属性也没有被注入。  第二个阶段，首先完成Bean的创建，然后完成依赖的注入。实际上，不是所有的Bean都被创建，有关Bean的作用域的问题，我们以后再讨论。
## Spring管理的Bean
被Spring创建和管理的对象被称为Bean。这些对象都是pojo，但是却在Spring中进行管理。
**命名Bean**
+ 通过名称进行区分，每个Bean至少有一个名称，如果开发人员没有为他命名，那么Spring容器将会为他分配一个内部名称。通过这个名称，可以从其他Bean定义中或者用显式查找从应用程序代码中应用Bean在基于xml的配置中，使用id特性将一个名称分给一个Bean，在相同的xml中不能复制同一个名称。
**Bean实例化方法**
+ 创建Bean最常用的方法是调用相关类中的一个可用的构造函数，就是实例化这个类
+ 第二种方法是调用可用的静态方法或实例工厂方法
+ 使用spring自带的FactoryBean接口。
**Bean的作用域**
由spring容器创造的Bean的生存周期叫做Bean的作用域。
+ SpringApplicationframework支持的内置作用域
| 作用域名称 | 作用域定义 |
|:--:|:--:|
|singleton|从Bean定义中仅创建一个实例。这是默认的作用域|
|prototype|每一次对Bean定义的访问，都会创建一个新的Bean实例，类似于java中的new关键字|
|request|整个web请求过程中使用相同的Bean实例。每个web请求都会创建一个新的Bean实例，仅适用于支持web的ApplicationContext|
|session|针对一个特定的HTTP会话使用相同的Bean实例。每一个Web请求都会创建一个新的Bean实例。仅适用支持Web的ApplicationContexts|

**延迟初始化**
    默认的情况下，Spring容器在启动阶段创建Bean，该过程被称为预先Bean初始化，优点是可以尽早的发现配置错误。但是另一方面，如果存在大量的Bean定义，那么初始化就会占用很长的时间，而一些Bean可能只会在特定的场景中才会用到，预先初始化就会造成不必要的堆内存消耗。
	Spring支持延迟Bean的初始化。
	如果开发人员将Bean设置称为延迟创建，呢么Bean就会只有在被使用到的时候才会创建。
	在基于XML的配置中，可在<bean>元素中使用lazy-init属性把Bean定义为延迟。（ps:我感觉就是懒汉模式）
	优点：加快了容器启动时间，并且占用较少的内存量。
---
*接下来进入正题*
# 使用SpringMvc构建web应用程序
## SpringMvc的功能和优点
**什么是SpringMvc**
+ 是一个分层的javaWeb开发框架。
![mvc](mvc.png)
**好处**
+ 框架突出了http协议中的请求响应的特性
+ 因为SpringMvc是Spring的一个子项目，所以说它完全集成了Spring的核心功能，比如依赖注入的机制。你可以非常容易的为控制器配置和使用基于注解的定义。
+ SpringMvc提供了一种绑定机制。通过该机制可以从用户请求中提取数据。然后将数据转换成预定义的数据格式。最后映射到一个模型类，从而创建一个对象。
+ SpringMvc是视图不可知（view-agnostic)的，对于视图层，不一定要使用jsp

**使用DispatcherServlet**
+ 可以说SpringMvc的核心就是dispatcherServlet,它是主要的Servlet，负责处理所有的请求。并将请求调度到合适的通道。SpringMvc采用了 一种前端控制器模式（front controller pattern）,该模式提供了一个入口点来处理web应用程序的所有请求。具体的工作细节，可以参考那一篇  SpringMvc学习总结

**定义servlet**
+ DispatcherServlet的定义包含在web.xml文件中
```xml
<servlet>
	<servlet-name>springmvc</servlet-name>
	<servlet-class>
	org.springframework.web.servlet.DispatcherServlet
	</servlet-class>
	<load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
	<servlet-name>springmvc</servlet-name>
	<url-pattern>*.mvc</url-pattern>
</servlet-mapping>
```

