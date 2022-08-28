---
title: Mybatis学习篇
date: 2019-10-17 16:34:38
tags: 
- Mybatis
- JavaEE
---
![mybatis](mybatis.jpg)
<!--more-->
+ Mybatis的前身是Apache的开源项目iBatis。是一个基于java的持久层框架。

+ 优势：灵活，几乎可以替代jdbc。同时提供了接口编程，目前mybatis的数据访问层DAO是不需要实现类的，它只需要一个接口和xml。mybatis提供自动映射，动态sql，级联，缓存，注解，代码和sql分离等特性，还能对sql进行优化，使他取代Hibernate成为了java互联网中首选的持久层框架。

+ Hibernate：也是一个持久层的框架，那么区别在哪呢？都是提供把数据库中的表和pojo映射起来，就是关系映射（Object Relational Mapping）。简称ORM，那么Mybatis和Hibernate都是ORM框架，只是Hibernate的设计理念是完全面向pojo的，而Mybatis不是，Hibernate基本上是不需要再写sql语句就可以完成数据表到pojo的映射，可是Mybatis需要我们提供SQL去运行。
```xml
<hibernate-mapping>
	<class name="com.learn.chapter1.pojo.Role" table="t-role">
		<id name="id"type="java.lang.Integer">
			<column name="id"/>
			<generator class="identity"/>
		</id>
		<property name="rolelName" type="string">
			<column name-"role_nane"1ength="60"not-nul1="true"/>
		</property>
		<property name="note" type="string">
			<column name="note"1ength="512"/>
		</property>
	</class>
</hibernate-mapping>
```
# Mybatis
+ 在移动互联网时代，Mybatis成了目前互联网java持久框架的首选，与Hibernate消除了Sql不同，Mybatis不屏蔽SQL，程序员就能自己定义SQL，无需Hibernate自动生成规则，这样能更加精确的定义SQL从而优化性能。更符合互联网高并发，大数据高响应的要求。

+ 由于不用SQL，当多表关联超过三个的时候，通过Hibernate的级联，会造成太多性能的丢失，但是同样的Mybatis支持的工具也很有限，不想Hibernate那样有很多插件可以用。
---
# 认识一下Mybatis的核心组件
+ **先看看外在呈现给我们的组件，回头再讨论原理**
+ SqlSessionFactoryBuilder(构造器):它会根据配置或者代码来生成SqlSessionFactory,采用的是分步构建的Builder模式
+ SqlSessionFactory:(工厂接口)：依靠他来生成SqlSession使用的是工厂模式
+ SqlSession(会话)：一个既可以发送SQL执行返回结果，也可以获取Mapper的接口。在现有的技术中一般我们会让其在业务逻辑代码中消失，而使用的是Mybatis提供的SQL Mapper接口编程技术。
![组件](zujian.jpg)
+ 无论是SqlSession还是映射器，都可以发送SQL到数据库中执行。
## SQLSessionFactory
+ 使用Mybatis首先是使用配置或是代码去生产SqlSessionFactory,而Mybatis提供构造器SqlSessionFactoryBuilder。他提供了一个类org.apache.ibatis.session.Configuration作为引导，采用的是Builder模式，具体的分步则是在Configuration类里面完成的。
+ 在Mybatis中，既可以通过读取配置的xml文件的形式生成SqlSessionFactory,也可以通过java代码的方式去生成SQLSessionFactory。
**使用xml构建sqlSessionFactory**
+ 首先，在Mybatis中xml分为两类，一类是基础配置文件，通常只有一个，主要是配置一些最基本的上下文参数和运行环境，另一类是映射文件，它可以配置映射关系，sql参数，等信息，先看一份简单的基础配置文件，我们把它命名为mybatis-config.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3 //EN" "http://mybatis.org/dtd/mybatis-3-config.dtd">  
<configuration>
	<typeAliases><!--别名-->
		<typeAlias alias="role" type="com.learn.ssm.chapter.pojo.Role">
	</typeAliases>
	<!--数据库环境-->
	<enviroments default ="development">
	 <enviroment id="development">
	  <transactionManager type="JDBC"/>
	     <dataSource type="POOLED">
	    <property name="driver" value="com.mysql.jdbc.Driver"/>
		<property name="url" value="jdbc:mysql://localhost:3306/ssm"/>
		<property name="userneme" value="root">
		<property name-"password" value="123456">
	     </dataSource>
	  </transactionManager>
	 </enviroment>
	</enviroments>
	<mappers>
	  <mapper resource="com/learn/ssm/chapter3/mapper/RoleMapper.xml">
	</mappers>
</configuration>
```
+ 我们来简单的看一下xml中各个标签的含义和作用。
+ + `<typeAlias>`:元素定义了一个别名role。他是"com.learn.ssm.chapter.pojo.Role"这个的别名，有了这个东西，就可以用哪个role代替全限定名了
+ + `<enviroment>`:元素定义的是数据库，它里面的<transactionManager>是配置事务管理器。这里采用的是Mybatis的JDBC管理器方式。然后采用<dataSource></dataSource>来配置数据库，其中“POOLED”代表采用Mybatis内部提供的连接池的方式。最后定义一些关于JDBC的属性信息。

**SqlSession**
+ 在Mybatis中，SqlSession是其核心接口，Mybatis中有两个实现类，DefaultSqlSess和SqlSessionManager,DefaultSQLSession是单线程使用的，而SqlSession在多线程环境下使用，SqlSession的作用类似于有一个JDBC中的Connection对象，代表着一个连接资源的启用。具体而言，他的作用有三个
+ + 获取Mapper接口
+ + 发送SQL给数据库。
+ + 控制数据库事务。
+ 注意，SqlSession只是一个门面接口，他有很多种方法，可以直接发送SQL，就好像是一家软件公司的商务人员，是一个门面，而实际干活的人是软件工程师。在Mybatis中，真正干活的是Excutor，我们会在底层看到他。这里也有很多事物处理的方法，如commit,或者是rollback。

**映射器**
+ 映射器是Mybatis中最重要最复杂的组件，它由一个接口和对应的xml组成。可以配置以下内容
+ + 描述映射规则
+ + 提供SQL语句，并可以配置SQL参数类型，返回类型，缓存刷新等等。
+ + 配置缓存。
+ + 提供动态SQL
+ 我们只需要提供一个pojo和一个接口，Mybatis会用动态代理技术使得接口可以运行起来，其实是生成了一个代理对象，代理对象会去处理相关的逻辑。
+ **xml实现映射器没啥好说的**
+ 来看看注解实现映射器咋做的
+ 只需要一个接口就可以实现Mybatis使用注解来注入SQL
```java
import com.learn.ssm.chapter3.pojo.Role;
public interface RoleMapper2{
	@Select("select id,name from t_role where id=#{id}")
	public Role getRole(Long id);
}
```
+ 当xml和注解同时存在的时候，xml会覆盖掉注解，所以官方推荐的是xml方式。
**SqlSession发送SQL**
+ 用Mapper接口发送SQL
```java
RoleMapper roleMapper=sqlSession.getMapper(RoleMapper.class);
Role role=roleMapper.getRole(1L);
```
## 生命周期
+ 生命周期是组建的重要问题，尤其是在多线程的环境中，比如互联网应用，socket请求等等。而Mybatis也常常用于多线程中，错误使用会造成严重的多线程并发问题。为了正确，我们要了解生命周期的问题。
+ SqlSessionFactoryBuilder的作用在于创建SqlSessionFactory,创建成功就失去了作用
+ SqlSessionFactory可以被认为是一个数据库连接池，他的作用是创建SqlSession接口对象。因为事实上Mybatis就是对数据库操作，所以可以认为SqlSession的生命周期就是等同于Mybatis的生命周期。
+ SqlSession，相当于一个Connection，你可以在一个事务里面执行多条SQL，然后通过他的commitrollback等方法，所以SqlSession应该存在于一个业务请求中，处理完整个请求之后，就应该关闭这条连接。
+ Mapper应该小于等于SQLSession。
---
基础的就是上面的啦，接下来学习一下Mybatis的配置。我之前用的时候好像都没有配置来着。。。
---
# Mybatis配置
+ propert子元素：改写数据库链接的相关配置
+ 使用properties是比较普遍的用法，创建一个jdbc.poperties文件放到classpath的路径下面。然后在Mybatis中通过`<properties resource="jdbc.properties"/>`来引入文件。
+ 实际的生成过程中可能会涉及到其中密码的加解密问题，这时候就要把密码解密，然后重置到我们的properties中。
## **settings**：
+ Mybatis中最复杂的配置，它可以影响到Mybatis底层的运行，但是在大部分情况下默认就可以运行。只需要修改一些常用的规则就可以了，比如说自动映射，驼峰名映射，级联规则，是否启动缓存，执行器等等。
| 配置项 | 作用 | 配置选项说明 | 默认值 |
|:--:|:--:|:--:|:--:|
|casheEnabled|该配置影响所有映射器中配置缓存的全局开关|true/false|true|
|lazyLoadingEnabled|延迟加载的全局开关，开了之后，所有的关联对象都会延迟加载，在特定的关联关系中可以通过设置fetchType来覆盖该项的开关状态|true/false|false|
|agressiveLazyLoading|当启用的时候，对任意延迟属性的调用会使带有延迟加载属性的对象完整加载；反之，每种属性将会按需加载|true/false|3.4.1前true,后false|

事实上还有很多配置项，但是全列出来背下来也不现实，用的时候再找吧。

## typeHandler类型转换器
+ 负责转换javaType和jdbcType，其中jdbcType是用于定义数据库类型，而java是用来定义java类型的。一般不用配置就可以，Mybatis会自动探测到应该使用什么类型的TypeHandler进行处理，但是对于那些需要使用自定义枚举的场景，或者数据库使用特殊数据类型的场景，就是可以使用自定义的typehandler去处理类型之间的转换问题。
+ 系统定义的typeHandler可以自己查表都有。
+ 当需要自己创建typeHandler的时候，要实现接口：org.apache.ibatis.type.TypeHandler。
+ 那么Mybatis系统的typeHandler是怎么实现的呢。第一就是继承了这个接口，然后实现一些抽象类和方法，完成存储过程啦注册过程啦等等。我们自己写typeHandler的时候一般是通过配置或者是扫描的方式进行注册的。

+ 自定义typeHandler的时候，继承完接口之后，要去配置typeHandler,配置完了之后，系统才会去读取他
```xml
<typeHandlers>
	<typeHandler jdbcType="VERCHAR" javaType="String"
	   handler="自己的类的地址"/>
</typeHandlers>
```
如果说，我们自定义的typeHandler很多呢，那要怎么办，不能一个一个配置吧，就要用到扫描配置的方法
```xml
<typeHandlertype>
	<package name="com.learn.sssm.chapter4.typeHandler">
</typeHandlertype>
```
可是如果一但这样，大家就会发现一个问题，就是我没有办法指定我用的javatype和jdbcType了,不用担心，可以在自己写的类里面用注解的方式去处理他
```java
@MappedTypes(String.class)
@MappedjdbcTypes(jdbcType.VARCHAR)
public class MyTypeHandler implements TypeHandler<string>{
	.....
}
```
## 运行环境
+ mybatis中，运行环境主要的作用是配置数据库信息，它可以配置多个数据库，一般而言一个就够了。他下面又分成了两个可配置的元素：事务管理器，数据源。在实际的工作中，大部分情况下会采用Spring对数据库的事务进行管理，这里我们聊一下Mybatis自身实现的类。
+ **transactionManager(事务管理器)**
+ 他主要提供了两个实现类，和实现了一个接口，接口如下所示
```java
public interface Transaction{
	Connection getConnection() throws SQLException;
	
	void commit() throws SQLException;
	
	void rollback() throws SQLException;
	
	void close() throws SQLException;
	
	Integer getTimeout() throws SQLException;
}
```
+ **数据源环境**
+ 按照我的理解，就是配置Mybatis用不用数据库池子的地方。
## 引入映射器的方法
**文件路径引入映射器**
```xml
<mappers>
	<mapper resource ="文件路径"/>
</mappers>
```
**包名引入映射器**
```xml
<mappers>
	<package name="包的名字"/>
</mappers>
```
**类注册引入映射器**
```xml
<mappers>
	<mapper class="类的地方"/>
</mappers>
```
**用userMapper.xml引入映射器**
```xml
<mappers>
	<mapper url="balabalbalba"/>
</mappers>
```
---

# 映射器
+ 在Mybatis应用程序开发中，映射器的开发工作占全部工作的80%
+ 话不多说，先来看看有什么**元素**
|元素名称|描述|备注|
|:--:|:--:|:--:|
|select|查询语句，最复杂，最常用的元素之一|可以自定义参数|
|sql|允许定义一部分SQL，然后在各个地方引用他|例如一张表列名，一次定义可以在多个sql语句中使用|
|resultMap|用来描述从数据库结果集中来加载对象，它是最复杂，最强大的元素|他将提供映射规则|
|cache|给定命名空间的缓存配置|-|
|cache-ref|其他命名空间的缓存配置的引用|-|

## 映射器中，select元素代表SQL的select语句，用于查询。在SQL中，select语句是用的最多的语句，强大，复杂，先来看看select元素的配置
|元素|说明|备注|
|:--:|:--:|:--:|
|id|他和Mapper的命名空间组合起来是唯一的，供Mybatis调用|如果id和命名空间组合起来不唯一，那么将会报异常|
|parameterType|可以给出类的全命名，也可以给出别名，但是别名必须是Mybatis内部定义或是自定义的|可以选择javaBean,Map等简单的参数类型传递给Sql|
|resultType|定义类的全路径，在允许自动匹配的情况下，结果集将通过javaBean的规范映射，或定义为int，double，float，map等参数，也可以使用别名但是要符合别名规范，且不能和resultmap同时使用|常用的参数之一，比如统计条数的时候可以把它的值设置成int|
|resultMap|它是映射集的引用，将执行强大的映射功能，我们可以使用result和resultMap其中的一个，resultMap可以提供自定义映射规则的机会|Mybatis最复杂的元素，可以配置映射规则，级联，typeHandler等|
|flushCache|它的作用是在调用SQL后，是否要求Mybatis清空之前查询本地缓存和二级缓存|取值为布尔值，true/false.默认值是false|
|useCache|启动二级缓存的开关，是否要求Mybatis将此次结果缓存|取值是布尔值，true/false默认值是true|
|timeout|设置超时参数，超时将会抛出异常单位是秒|默认值是数据库厂商提供的jdbc默认值|
|fetchSize|获取记录的总条数规定|默认值是数据库厂商提供的jdbc设置的条数|
|statementType|告诉jdbc的statement工作，取值是statement。prepared,callable|默认值是prepared|
|resultSetType|这是对jdbc的resultSet接口而言，它的值包括forward_onlyscore(游标允许向前访问)，score_sensitive(双向滚动但是不及时更新，就是如果数据库里的值修改过，并不在resultSet中反映出来)Score_INsensitive(双向滚动，并及时的跟踪数据库的更新，以便更改resultSet中的数据)|默认值是数据库厂商体统的jdbc驱动所设置的|
|databaseId|可以参考databaseIdprovider数据库厂商标识这一部分|提供多种数据库的支持|
|resultOrdered|这个设置仅适用于嵌套结果select语句，如果为true，就是假设包含了嵌套结果集或是分组了，当返回一个主结果行时，就 不能引用前面结果集了，这就确保了在获取嵌套结果集时不至于导致内存不够用|取值为布尔值，true/false|
|resultSets|适用于多个结果集的情况，它将列出执行SQL后每个结果集的名称，每个名称之间用逗号分隔|很少使用|

+ 在实际的工作中用的最多的是id，parameterType，resultType，resultMap，如果要用到缓存还要用到flushCache，useCache,其他都是不常用的功能。

**自动映射和驼峰映射**
+ 默认情况下自动映射功能是开启的，使用它的好处是能有效减少大量的映射配置。从而减少工作量，在setting元素中有两个可以配置的选项，autoMappingBehavior和mapUnderscoreToCamelCase，她们是控制自动映射和驼峰映射的开关，一般而言自动映射会使用的多一点，因为可以通过SQL别名机制处理一些细节，比较灵活，驼峰映射比较严格，不是很常用
+ 如果有一个pojo和编写好的SQL，SQL的列名和属性列名保持一致，可以用别名，想`select id role_name as rolename`那么他就会形成自动映射，不用别的配置就可以吧数据库中的相关列映射到pojo中，明显减少了工作量。
+ 如果是驼峰的话，就不存在说能不一样的名字了，数据库中的名字必须严格和pojo对应。
**传递多个参数**
+ 在Mybatis中允许map接口通过键值对传递多个参数，把接口方法定义为：`public List<role> findRolesByMap(Map<String,Object> parameterMap);`此时传递给映射器的是个map对象，使用他再sql中设置对应的参数
+ **使用注解传递**：用map传递参数有个问题，就是可读性很差，因此Mybatis为开发者提供了一个注解@param,可以通过他去定义映射器的参数名称。使用它可以得到更好的可读性，接口方法就可以这么定义`public List<role> find(@Param("roleName") String rolename,@Param("note") String note);`
+ 还可以使用javaBean作为参数，然后查询。

**分页参数RowBounds**
+ Mybatis不仅支持分页，它还内置了一个专门处理分页的类，RowBounds,使用它十分简单，只要给接口增加一个RowBounds参数就行了，但是这个对于小数据量的支持会更好一些，如果是较大的数据查询，那么可以使用分页插件去处理。

## 相关元素
**insert**
+ 语句:`insert into role(role_name,note) values(#{rolename},#{note})`
+ **主键回填**
+ jdbc中的Statement对象在执行了插入的SQL之后，可以通过getGeneratedKeys方法获得数据库生成的主键，那么Mybatis也可以，在`<insert useGeneratedKeys="true">`这个开关来决定是否打开这个功能。如果选择这一项的值是打开，那么还要使用keyProperty或者keyColumn告诉系统把生成的主键放在哪个属性中如果存在多个主键，就用，把他们隔开

**update和delete**
+ 用法相似，在相关的元素标签里面配置好SQL语句之后会执行返回一个整数代表修改或者删除的条数。

**sql**
+ 作用就在于它可以定义个SQL的一部分，然后在select或者是insert等语句中反复使用他们。特别是那些字段比较多的表更是如此。
```xml
<sql id="roleCols">
	id,role_name,note
</sql>
```

**特殊字符串的替换和处理**
+ “$”:这种是拼接在sql语句上面的，不咋安全
+ “#”:这种是字符串的处理，更加安全，是把后面括号中的数据做了处理的额，可以防止sql注入攻击。

## resultMap元素
**元素的构成**
```xml
<resultMap>
	<constructor>
		<idArg/>
		<arg/>
	</constructor>
	<id>
	<result/>
	<association/>
	<collection/>
	<discriminator>
		<case/>
	</discriminator>
</resultMap>
```
其中constructor元素用于配置构造方法。一个pojo可能不存在没有参数的构造方法，可以使用constructor进行配置。假设有一个类RoleBean，不存在没有参数的构造方法，他的构造方法声明是这样的`public RoleBean(Integer id,String roleName)`,那么就要配置结果集了
```xml
<resultMap ......>
	<constructor>
		<idArg column="id" javaType="int"/>
		<arg column="role_name" javaType="String">
	</constructor>
	...
</resultMap>
```
这样子Mybatis就会用对应的构造方法来构造pojo了。
id元素表示哪个列是主键，允许多个主键，多个主键则称为联合主键。result是配置pojo到SQL列名的映射关系。result和idArg元素的属性如下表

|元素名称|说明|备注|
|:--:|:--:|:--:|
|property|映射到列结果的字段或是属性。如果pojo的属性匹配的存在的且与给定的SQL列名是相同的，那么Mybatis就会映射到pojo上|可以实用导航式的字段，比如访问一个学生对象Student，需要访问学生证的发放日期，可以写成selfcard.issueDate|
|column|对应的是SQL的列|-|
|javaType|配置java类型|可以是特定的类完全限定名或者Mybatis上下文的别名|
|jdbcType|配置数据库类型|这是一个jdbc的类型，Mybatis已经做了限定，支持大部分常用的数据库类型|
|typeHandler|类型处理器|允许用特定的处理器来覆盖Mybatis默认的处理器。这就要制定jdbcType和javaType相互转化的规则。|

除此之外还有一些级联设置的相关元素，稍候会详细讨论级联的相关知识
**使用map存储结果集**
一般而言，任何select语句都可以使用map存储 `<select id="findColorByNote" parameterType="String" resultType="map"> select id,color,note from t_color where note like concat('%',#{note},'%')</select>`
使用map原则上是可是匹配所有结果集，但是使用map接口就意味着可读性的下降，因为使用Map时要进一步了解map键值的构成和数据类型，所以这不是一种推荐的方式。更多的时候会推荐使用pojo的方式
**使用pojo存储结果集**
pojo是最长常用的方式。一方面可以使用自动映射，正如使用resultType一样，但是有的时候需要更为复杂的映射或者级联。这个时候还可以使用select的resultMap 属性配置映射集合，只是使用之前要配置resultmap。

## 级联
目的：实现数据的关联
好处：获取数据十分方便
坏处：当级联过多的时候，会增加系统的复杂度和耦合性，同时会降低系统的性能，所以当级联超过三层的时候就不应该使用级联了
**mybatis中的级联**
Mybatis中的级联分为三种
+ 鉴别器（discriminator）：它是一个根据某些条件决定采用具体实现类级联的方案，比如体检表要根据性别去区分
+ 一对一（association）：比如学生证和学生就是一对一的级联关系，
+ 一对多（collection）：班主任和学生就是一对多的级联
值得注意的是，Mybatis没有多对多的级联，因为太过复杂使用困难，而可以使用一对多来代替。
下面使用一个案例来说明
![级联案例](jilian.jpg)
分析一下雇员的级联模型：
+ 该模型是以雇员表为中心得。
+ 雇员表和工牌表是一对一的关系
+ 雇员表和员工任务表是一对多的级联关系
+ 员工任务表和任务表是一对一的级联关系
+ 每个雇员会有一个体检表，随着雇员表字段性别的取值不同会有不一样的关联表
建表代码过程略
**建立pojo**
1. 男女体检表应该继承一个抽象的体检表。getter和setter略，各设置私有的体检属性。
	显然这个挂你应该是通过Mybatis的鉴别器去完成的
2. 设计工牌表和任务表的pojo，工牌表以员工表为核心
3. 接下来是雇员任务表，是雇员表和任务表的连接点。
4. 最后是雇员表
**配置映射文件**
配置映射文件是级联的核心内容，而对于Mapper的接口就不给出了。
```xml
<mapper namespace="路径" >
	<select id="getTask" parameterType="long" resultType="com.路径.pojo.task">
		select id,title,context,note from t_task where id=#{id}
	</select>







