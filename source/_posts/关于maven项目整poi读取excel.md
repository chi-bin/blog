---
title: 关于maven项目整poi读取excel
date: 2019-11-17 09:45:52
tags: JavaEE
---
![封皮](winter.jpg)
<!--more-->
# 关于ssm的maven项目整合poi读取excel
   记录一下项目中用到poi读取excel的一次经历吧，防止日后需要
## 整体思路
	+ maven方式导入poi相关包
	+ controller中获取到要上传的文件，转化成输入流。
	+ 准备一个工具类根据文件后缀名称识别excel版本
	+ 根据不同的版本采用不同的构造方式得到Workbook对象
	+ 根据传入的Workbook对象，得到相关的sheet，和行还有单元格，读入相关的对象，存到数据库中。
## 相关代码
**maven导入**
```xml
		<dependency>
			<groupId>org.apache.poi</groupId>
			<artifactId>poi</artifactId>
			<version>3.8</version>
			<exclusions>
				<exclusion>
					<artifactId>commons-codec</artifactId>
					<groupId>commons-codec</groupId>
				</exclusion>
			</exclusions>
		</dependency>
		<dependency>
			<groupId>org.apache.poi</groupId>
			<artifactId>poi-ooxml</artifactId>
			<version>3.8</version>
		</dependency>
```
SXSSHWorkbook适用于处理大量数据。

**判断版本的工具类**
```java
public class ExcelUtils {
	
	/** 
     * 验证EXCEL文件 
     *  
     * @param filePath 
     * @return 
     */  
    public  static boolean validateExcel(String filePath) {  
        if (filePath == null || !(isExcel2003(filePath) || isExcel2007(filePath))) {   
            return false;  
        }  
        return true;  
    }  
      
    // @描述：是否是2003的excel，返回true是2003   
    public static boolean isExcel2003(String filePath)  {    
         return filePath.matches("^.+\\.(?i)(xls)$");    
     }    
     
    //@描述：是否是2007的excel，返回true是2007   
    public static boolean isExcel2007(String filePath)  {    
         return filePath.matches("^.+\\.(?i)(xlsx)$");    
     }    
	
}
```

**controller中获得相关的输入流和文件的文件名**
```java
public Msg uploadExcel(@RequestBody MultipartFile file,HttpServletRequest request){
		
		//获取到上传文件名称
		String fileName=file.getOriginalFilename();
		if(!ExcelUtils.validateExcel(fileName)) {
			return  Msg.error("文件错误！");
		}
		try {
			
		Workbook wb = null;
		
        InputStream is = file.getInputStream();
        
		if(ExcelUtils.isExcel2003(fileName)) {
			wb=new HSSFWorkbook(is);
		}else {
			wb=new XSSFWorkbook(is);
		}
		List<LearnedStudent> list=getlist(wb);
		int num=upservice.insertForeach(list);
		return Msg.success("成功清空并导入！").add("number", num);
		
		}catch (Exception e)  {
            e.printStackTrace();
            return Msg.error("导入失败，请检查表格格式！");
        }
	
	}
```
**得到sheet和row还有cell的方法**
```java
		Sheet sheet=wb.getSheetAt(0);
		 //得到第一个sheet
		int rownum=sheet.getPhysicalNumberOfRows();
		//得到sheet表的行数
		cellnum  =sheet.getRow(0).getPhysicalNumberOfCells();
		//得到sheet表的列数
		 Row row = sheet.getRow(i);
		 //得到行
		 Cell cell = row.getCell(j);
		//得到cell
//根据需要采用循环的方式一行一行读cell
```

另外考虑到以后可能会用到更大数据量的情况，附上大数据量处理的连接
[csdn的一位博主](https://blog.csdn.net/whandgdh/article/details/80267674)