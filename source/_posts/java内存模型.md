---
title: java内存模型
date: 2019-10-09 19:34:46
tags: java
---
![wind](mei.jpg)
<!--more-->
![jvm](jvm.jpg)
1. 程序计数器：线程私有，记录的是正在执行的虚拟机字节码指令的地址。如果执行的是Native方法，则这个计数器的值为（undefined）,这是jvm中唯一一个不会有内存溢出的错误的区域
2. 虚拟机栈：线程私有，生命周期和线程一致，描述的是java方法的内存模型，每个方法在执行的时候都会创建一个栈帧，用于存储局部变量表操作数栈，动态链接，方法出口等消息，每个方法从调用到执行结束，都是对应着一个栈帧从虚拟机中从入栈到出栈的过程。可能出现的错误：1. StackOverflowError(请求的栈的深度大于虚拟机的规定的栈的深度)2. OutOfMemoryError(虚拟机无法申请到足够的内存)
3. java堆：jvm中最大的一块儿，线程共享，主要是存放实例对象和数组。内部可以划分出多个线程私有的分配缓冲区，可以物理上不连续但是逻辑结构上需要连续。
4. java本地方法栈：为虚拟机使用到的本地方法服务，也会有StackOverflowError和OutOfMemoryError
5. 方法区：属于共享内存区域，存储已经被虚拟机加载的类信息，常量，静态变量，即时编译器编译后的代码等数据。
6. 运行时常量池：方法区的一部分，用于存放编译期生成的各种字面量和符号引用，编译期和运行期（Sting的intern（）都可以将常量放到内存中）

# java类加载机制
1. 类加载器作用
类加载器本身作用就是用于加载类的，将类转换成java.lang.Class的实例；类加载器是通过类的全限定名来获取类的二进制字节流进而实现加载类。当我们比较两个类是否相等的时候，首先必须要确认是否由同一个类加载器加载，否则就算是使用相同class文件，被不同加载器加载比较结果还是不相等的。（相等可以指equals方法、isAssignableFrom方法、isInstance方法、instanceof方法等）。
2. 有哪些
+ **BootStrap ClassLoader**：称为启动类加载器，是Java类加载层次中最顶层的类加载器，负责加载JDK中的核心类库，如：rt.jar、resources.jar、charsets.jar等。

+ **Extension ClassLoader**：称为扩展类加载器，负责加载Java的扩展类库，默认加载JAVA_HOME/jre/lib/ext/目下的所有jar。
+ **App ClassLoader**：称为系统类加载器，负责加载应用程序classpath目录下的所有jar和class文件。
+ **CustomClassLoader**： 用户自定义类加载器，对于用户自定义的加载器，不管你是直接实现ClassLoader,还是继承URLClassLoader,或者其他的子类。它的父类加载器都是AppClassLoader ，因为不管调用哪个父类构造器，创建的对象都必须最终调用getSystemClassLoader()作为父加载器，而getSystemClassLoader()方法获取到的正是AppClassLoader 。

3. 当JVM运行过程中，用户需要加载某些类时，会按照下面的步骤（父类委托机制）：

+ 用户自己的类加载器，把加载请求传给父加载器，父加载器再传给其父加载器，一直到加载器树的顶层。
+ 最顶层的类加载器首先针对其特定的位置加载，如果加载不到就转交给子类。
+ 如果一直到底层的类加载都没有加载到，那么就会抛出异常ClassNotFoundException。
