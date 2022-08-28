---
title: java设计模式
date: 2019-10-17 20:02:31
tags: java
---
![设计模式](meat.jpg)
<!--more-->
# Java设计模式
## java反射技术
+ java反射技术的应用十分广泛，它可以配置：类的全限定名，方法，和参数，完成对象的初始化，甚至是反射某些方法，IOC的基本原理也是基于反射。

**通过反射构建对象**
+ java中允许通过反射配置信息来构建对象，比如ReflectServiceImpl类，如下代码所示
```java
package com.lean.ssm.chapter2.reflect
public class ReflectServiceImpl{
	public void sayHello(String name){
		System.err.println("hello"+name);
	}
}
```
+ 然后通过反射的方式去构建这个类
```java
public ReflectServiceImp getInstance(){
	ReflectServiceImp object =null;
	try{
		object =(ReflectServiceImp)
		Class.forName("com.lean.ssm.chapter2.reflect.ReflectServiceImpl").newInstance;
		//这个方法传入一个类型的全路径的名字(也就是带包的完整名字)，会返回一个字节码类型(也就是Class类型)的实例
		//然后再用这个字节码类型的实例clazz调用newInstance()方法会返回一个Object类型的对象
	}catch(ClassNotFoundException|InstantiationException|IllegalAccessException ex){
		ex.printStackTrace();
	}
	return object;
}
```
+ 这里的代码，就是生成一个对象，然后将其返回。先是给object注册了一个全限定名，然后通过newInstance方法初始化了一个类对象。

+ 如果构造函数是有参的构造函数，就要做一下改动了
```java
Class.forName("com.lean.ssm.chapter2.reflect.ReflectServiceImpl").getConstructor(String.class).newInstance;
```
**为啥要用反射，我直接new一个不行吗？**
当然可以，事实上反射生成对象和你new一个对象是等价的，而且可能反射生成对象的开销还会更大一点，但是如果你的对象类不是写死的呢，可能后面更新换了更好的一个类，而各种类里头new了多少你不知道，那咋更新文件嘞，一个个去找显然不现实，可是这里classforname后面跟的是个参数，如果我直接更改这个参数，事情就会周很多。

+ 刚刚描述的就是反射的优点--解耦。降低程序的耦合度这很重要。比如SpringIOC容器，就是使用反射的。

**反射方法** 
+ 之前有讲过，不仅类可以反射来实例化，方法也可反射，反射方法之前要获取方法对象。得到了方法才能够去反射。

## 动态代理模式和责任链模式
**动态代理模式和责任链模式不管是在Spring还是说在Mybatis中都有重要的应用。**
+ 动态代理的意义在于生成一个占位（又称代理对象），来代理真实对象，从而控制真实对象的访问。就是公司商务和程序员的关系，客户肯定是找商务谈事情，而不是找程序员，商务和程序员就是代理的关系。。
+ 代理他要分成两个步骤
++ 代理对象和真实对象建立代理关系
++ 实现代理对象的代理逻辑方法。
java中有多种动态代理技术，比如JDK,CGLIB,javassist，ASM，其中最常用的有两种：JDK，CGLIB理论相似
**JDK动态代理**
+ 是java.lang.reflect.*包提供的方式，它必须借助一个接口才能产生代理对象。所以先定义接口
```java
public interface HelloWord{
	public void sayHelloWorld();
}
```
+ 然后提供一个实现类来实现接口
```java
public class HelloWorldImp implements HelloWorld{
	@Override
	public void sayHelloWorld(){
		System.out.println("HelloWorld");
	}
}
```
+ 这是最简单的java接口和实现类的关系，此时可以开始动态代理了，按照我们之前的分析，我们需要先建立起来代理对象和真实的服务对象的关系，然后实现代理逻辑

+ 在JDK动态代理中，要实现代理逻辑类必须去实现java.lang.reflect.InvocationHandler接口，它里面定义了一个invoke方法，并提供接口数组用于下挂代理对象。
```java
public class JdkProxyExample implements InvocationHandler{
	//真实对象
	private Object target=null;
	/*
	建立代理对象和真实对象之间的关系，并且返回一个代理对象
	@param target 真实对象
	*/
   public object bind(Object target){
	   this.target=target;
	   return Proxy.newProxyInstance(target.getclass().getClassLoader(),targre.getClass().getInterfaces,this);
   }
   
   /*
   *代理方法逻辑，
   @param proxy：代理对象
   @param method:当前调度方法。
   @param args :当前方法参数
   @return 代理结果返回
   @throws Throwable:异常
   */
  @Override
  public Object invoke(Object proxy,Method method,Object[] args) throws Throwable{
	  System.out.println("进入代理逻辑方法");
	  System.out.println("在调度真实对象之前的服务");
	  Object obj=method.invoke(target,args);
	  System.out.println("在调度真实对象之后的服务");
	  return obj;
  }
	
}
```
+ 上述代码中，bind建立了代理对象和真实对象之间的关系。
+ invoke方法实现了代理逻辑方法

**CGLIB**
+ JDK动态代理必须提供接口才能使用， 在一些不能提供接口的环境中，只能采用其他第三方的技术，比如CGLIB动态代理他的优点在于不需要提供接口。只要一个非抽象类就可以实现动态代理

**拦截器**
+ 由于动态代理一般都比较难以理解，所以程序设计者会设计一个拦截器接口供开发者使用。开发者只要知道拦截器接口的方法含义和作用就可以了，不用知道动态代理是怎样实现的。
+ 就是封装了动态代理的具体方法，而只暴露出来拦截器的相关接口供开发人员使用

**责任链模式**
+ 当一个对象在一条链上被多个拦截器拦截处理时，我们把这种设计模式称为拦截器处理。
+ 优点，可以在传递链上增加新的拦截器，增加拦截逻辑，缺点是会增加反射和代理，性能不高。

**观察者模式**
+ 又叫做发布订阅模式，是对象的行为模式，定义了一种多对多的依赖关系，让多个观察者对象同时监视着被观察者对象的状态，当被观察者装袋发生变化的时候，会通知所有的观察者，让他自动更新自己。
+ 可以解耦，更加易于拓展。

**工厂模式和抽象工厂模式**
+ 在大部分情况下，我们都是用new来创建对象的,而工厂模式就是你告诉我需要什么样的类，我来给你生产
+ 普通工厂模式:只需要知道工厂的产对象的方法，告诉工厂要什么对象，就可以得到结果
+ 抽象工厂模式：向客户端提供一个接口，使得客户端在不必指定产品的具体情况下创建多个产品族中的产品对象。就是把各种工厂抽象成一个抽象工厂，这个工厂可以进行管理就想nginx代理各种服务器，外部只访问到nginx

**建造者模式**
+ 建造者模式属于对象的创建模式，可以将一个产品内部和产品的生成过程分割开来。从而使一个建造过程生成具有不同的内部表象的产品对象。
+ 解决可能一种对象有太多种不同的表现形式不好使用工厂或是new的问题
+ 通过一步一步构建个体对象而把整体对象构建出来。


**单例模式**
+ 就是一个类只有一个实例
+ 单例类必须自己创建自己的实例
+ 单例类必须为其他对象提供唯一的实例
+ **好处**：节省内存，方便垃圾回收。
+ 它可以保证一个类只有一个实例，并且提供全局访问点。
+ 懒汉式：只有在有对象要访问的时候才会创建实例。
+ 饿汉式：一开始就创建。
+ 什么情况下使用单例模式：控制资源的使用。通过线程同步的方式来控制资源的并发访问。节约资源，通信媒介。
+ 实际上，配置信息类、管理类、控制类、门面类、代理类通常被设计为单例类。像Java的Struts、Spring框架，.Net的Spring.Net框架，以及Php的Zend框架都大量使用了单例模式。
