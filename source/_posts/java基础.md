---
title: java基础
date: 2019-10-11 11:06:31
tags: java
---
![封面](fengmian.jpg)
<!--more-->
## java类的修饰词
有 public ,private,protected,default
![修饰词作用域](zuyongyu.png)
+ public：无论是否在同一个包，谁都可以访问
+ protected:只有自己包的类，或是别的包的子类可以访问，别的包的非子类是不可以访问的，
+ default:当前类和同个包的文件可以访问。别的包不可以访问
+ private:只要自己才可以访问。只有内部类菜会用到但是不建议这么写
## 成员变量修饰符
+ public：指定该变量为公共的他可以被任何对象的方法访问
+ private：指定该变量只允许自己的类的方法访问，其他任何类中的方法（包括子类）都不能访问

