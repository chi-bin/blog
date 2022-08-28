---
title: Spring流程图解
date: 2019-09-27 10:30:01
tags: SpringMvc
---
## 流程图解
![图解](SpringMvc流程.png)
<!--more-->
### 流程详解
1. 客户端发送请求到DispatcherServlet(拦截器)
+ 要了解为什么DispatcherServlet可以拦截所有的请求和底层，就要先了解servlet是什么。[servlet大概](/serlet大概)
![DispatcherServlet](diceng.png)
+ 而继承了HTTPServlet的DispatcherServlet，在其父类FrameWorkServlet中实现了HTTPServlet的doGet，doPost等方法，代码实现如下
```java
@Override
protected final void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    processRequest(request, response);
}
@Override
protected final void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    processRequest(request, response);
} 
```
+ 因为实现了这些方法，所以拦截器DispatcherServlet可以拦截所有的请求。

2. DispatcherServlet根据请求信息调用HandlerMapping，解析请求对应的Handler或是controller。返回一个Handler或是controller。
+ 因为有次面试被为什么给折磨到崩裂开来，现在碰到这种问题，我都要问问自己为什么
![HandlerMapping](handelermapping.png)
SimpleUrlHandlerMapping类通过配置文件把url映射到Controller类
DefaultAnnotationHandlerMapping通过注解把URL映射到Controller类

3. 解析到对应的Handler或者是controller后开始由HandlerAdapter适配器处理。帮助DispatcherServlet处理映射请求处理程序的适配器。他的作用是根据HandlerMapping返回的Handler对象（controller对象）然后去适配具体的方法。
![HandlerAdapter](HandlerAdapter.png)
AnnotationMethodHandlerAdapter：通过注解，把请求URL映射到Controller类的方法上。

4.处理器完成任务了之后，会返回一个ModeAndView对象，Mode是返回的数据对象，而view是逻辑上的view。
+ 什么是modeAndview呢？
ModelAndView是Spring中标准的类，完全是Spring自己封装的对象。
实际上是两个部分一个是view，在我的理解来看就是一个标识id的作用，用来告知viewResolver去哪里找到view文件。而Mode由addObject()来决定的，他的本质是HashMap，键值对；

5.ViewResolver会根据逻辑上的view来查找实际上的view
+ 就是根据那个标识id来去查找实际的view。具体怎么实现的呢？
![viewResolver](vrs.png)
首先InternalResourceViewResolver extends（继承）了 UrlBasedViewResolver；然后顺便说，把用于显示（view）的jsp文件放在WEB-INF文件夹下是一种安全的做法，这样不能通过url直接access这些jsp，只能通过Controller java类来访问它们。

6.DispatcherServlet 会根据找到的实际的view然后把mode给它，通过浏览器表达给用户。
