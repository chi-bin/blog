---
title: 关于mybatis的批量插入
date: 2019-11-19 12:48:49
tags: 
- Mybatis
- JavaEE
---
![封面](fengpi.jpg)
<!--more-->
##关于mybatis向数据库中批量插入数据的问题
    最近项目中有一个需求是通过读入一个excel生成对象插入到mysql中，项目结合了mybatis，在导入数据量很少的情况下，一切都显得其乐融融，很完美，但是数据量变成了5w条之后，就出现了各种各样的问题，写一下记录一下。
**实现思路：**
1. 文件读取之后对excel进行解析，得到一个对象的list。
2. mybatis中配置一个foreach的插入。
3. 写好dao接口和service之后在controller中进行调用
关键的代码是foreach的插入
```xml
	<insert id="insertForeach">
		insert into learnedstudent(stu_id,stu_name,stu_class,stu_college,stu_school)
		values
		   <foreach collection="list" item="stu" separator=",">
    				(
    					#{stu.stu_no},
    					#{stu.stu_name},
    					#{stu.stu_class},
    					#{stu.stu_college},
    					#{stu.stu_school}
    				)
    		</foreach>
	</insert>
```
**碰到的问题**
小数据量的情况下速度很快，一点问题没有，但是5w多条之后就会报一个query.package过长的错误，估计意思就是中间的对象过多，一次的语句量过大。
解决的方法就是去数据库中，打开命令窗口
```sql
mysql> show VARIABLES like '%max_allowed_packet%';
+--------------------------+------------+
| Variable_name | Value |
+--------------------------+------------+
| max_allowed_packet | 4194304 |
| slave_max_allowed_packet | 1073741824 |
+--------------------------+------------+
2 rows in set (0.00 sec)
```
max_allowed_packet就是有关这一项的设置参数，做如下设置
```sql
mysql> set max_allowed_packet=100*1024*1024;
```
即大小设为100M报错消失

## 思考：

当数据量更大的时候怎么办，内存的大小终究是有限的，网络上有一种解决方法
思路：
Mybatis内置的ExecutorType有3种，默认为simple,该模式下它为每个语句的执行创建一个新的预处理语句，单条提交sql；而batch模式重复使用已经预处理的语句，并且批量执行所有更新语句，显然batch性能将更优； 但batch模式也有自己的问题，比如在Insert操作时，在事务没有提交之前，是没有办法获取到自增的id，这在某型情形下是不符合业务要求的


(1)在全局配置文件Mybatis-springmvc.xml(根据个人的配置方式不同写入)中加入
```xml
    <!-- 配置一个可以批量执行的sqlSession -->
        <bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate">
            <constructor-arg name="sqlSessionFactory" ref="sqlSessionFactory"></constructor-arg>
             <constructor-arg name="executorType" value="BATCH"></constructor-arg>
        </bean>
```
 
(2)在serviceImpl中加入
```java
    @Autowired
	//批量保存员工
    private SqlSession sqlSession;

    @Override
    public Integer batchEmp() {
        // TODO Auto-generated method stub
    
            //批量保存执行前时间
            long start=System.currentTimeMillis();
    
            EmployeeMapper mapper=    sqlSession.getMapper(EmployeeMapper.class);
            for (int i = 0; i < 10000; i++) {
                mapper.addEmp(new Employee(UUID.randomUUID().toString().substring(0,5),"b","1"));
    
            }
            long end=  System.currentTimeMillis();
            long time2= end-start;
            //批量保存执行后的时间
            System.out.println("执行时长"+time2);
            
           
        return (int) time2;    
    }
```
mapper和mapper.xml如下：
```java
    public interface EmployeeMapper {    
    //批量保存员工
    public Long addEmp(Employee employee);

    }
```
```xml
<mapper namespace="com.agesun.mybatis.dao.EmployeeMapper"
     <!--批量保存员工 -->
    <insert id="addEmp">
        insert into employee(lastName,email,gender)
        values(#{lastName},#{email},#{gender})
    </insert>
</mapper>
```
