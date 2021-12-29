## PII[^1]泄露--用CodeQL识别日志中的PII数据

 [shopizer](https://www.shopizer.com/)是一款开源电子商务系统，使用Java语言开发。[shopizer‘s github](https://github.com/shopizer-ecommerce/shopizer)

本次实验所以内容代码都会上传至https://github.com/SummerSec/learning-codeql

----

## Source--敏感字段

已知敏感有：

* email
* phone
* creditCare

CodeQL的`Field`获取字段名再根据正则模糊匹配的方式

```
/**
 *@name SimplePIIField
 */

import java

from Field f
where 
    (f.getName().matches("%email%") or
    f.getName().matches("%phone%") or
    f.getName().matches("creditCard%")) and
    f.fromSource()
select f
```

![image-20210418173835827](https://gitee.com/samny/images/raw/master/46u38er46ec/46u38er46ec.png)

转化成类的形式

```
/**
 *@name SimplePIIClass
 */

import java

class SenInfoField extends Field{
    SenInfoField(){
        (this.getName().matches("%email%") or
        this.getName().matches("%phone%") or
        this.getName().matches("creditCard%")) and
        this.fromSource()
    }
}

from SenInfoField sif
select sif 
```

![image-20210418173846083](https://gitee.com/samny/images/raw/master/46u38er46ec/46u38er46ec.png)

---

## Sink--日志输出调用



`shopizer`使用的是`slf4j`日志框架输出日志，`StringFormatMethod`是CodeQL对该日志框架处理其定义是：

```
/**
 * A format method using the `org.slf4j.Logger` format string syntax. That is,
 * the placeholder string is `"{}"`.
 */
```

查询`slf4j`调用

```
/**
 *@name Logger slf4j 记录器记录方法调用查询
 */

import java
import semmle.code.java.StringFormat

from LoggerFormatMethod lfm
// select lfm.getAReference().getAnArgument()
select lfm.getAReference()
```

![image-20210418173902809](https://gitee.com/samny/images/raw/master/2u39er2ec/2u39er2ec.png)

![image-20210418173927488](https://gitee.com/samny/images/raw/master/27u39er27ec/27u39er27ec.png)



---

## 污点数据流追踪

`source`以PII字段`email`、`phone`和`creditCard`，`sink`是`slf4j`的参数。



```
/**
 *@name PIIQuery
 *@kind problem
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.StringFormat

class SenInfoField extends Field{
    SenInfoField(){
        (this.getName().matches("%email%") or
        this.getName().matches("%phone%") or
        this.getName().matches("creditCard%")) and
        this.fromSource()
    }
}

class MySenInfoTaintConfig extends TaintTracking::Configuration{
    MySenInfoTaintConfig(){
        this = "MySenInfoTaintConfig"

    }

    override predicate isSource(DataFlow::Node source){
        source.asExpr() = any(SenInfoField sif).getAnAccess()
    }
    override predicate isSink(DataFlow::Node sink){
        sink.asExpr() = any(LoggerFormatMethod lfm).getAReference().getAnArgument()
    }
}



from MySenInfoTaintConfig config, DataFlow::Node source, DataFlow::Node sink, SenInfoField f
where 
    config.hasFlow(source, sink) and
    // source.asExpr() = f.getAnAccess()
    f.getAnAccess() = source.asExpr()
select sink, "PII data from field $@ is written to long here",f , f.getName()
// select sink,"PII data from field $@ is written to long here",source, source.asExpr().toString()

```

![image-20210418165443032](https://gitee.com/samny/images/raw/master/43u54er43ec/43u54er43ec.png)

![image-20210418165519019](https://gitee.com/samny/images/raw/master/19u55er19ec/19u55er19ec.png)

在where clause中38和39行是一样的效果，因为在CodeQL中`=`的作用是判断左右两边是否是相同、相等，所以左右的顺序是没有区别。

或者也可以这样子写：

```
from MySenInfoTaintConfig config, DataFlow::Node source, DataFlow::Node sink
where 
    config.hasFlow(source, sink) 
select sink,"PII data from field $@ is written to long here",source, source.asExpr().toString()
```

![image-20210418174013455](https://gitee.com/samny/images/raw/master/13u40er13ec/13u40er13ec.png)

PS：关于`$@`参考[Defining the results of a query](https://github.com/SummerSec/learning-codeql/tree/main/CodeQL%20Queries/Defining%20the%20results%20of%20a%20query)

----

### 完整路径显示

显示路径需要将`@kind problem`改成`@kind path-problem`，并且导入`import DataFlow::PathGraph`。

```
/**
 *@name PIIQueryPath
 *@kind path-problem
 *@description 污染路径
 */

import java
import semmle.code.java.StringFormat
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph


class SenInfoField extends Field{
    SenInfoField(){
        (this.getName().matches("%email%") or
        this.getName().matches("%phone%") or
        this.getName().matches("creditCard%")) and
        this.fromSource()
    }
}

class MySenInfoTaintConfig extends TaintTracking::Configuration{
    MySenInfoTaintConfig(){
        this = "MySenInfoTaintConfig"

    }

    override predicate isSource(DataFlow::Node source){
        source.asExpr() = any(SenInfoField sif).getAnAccess()
    }
    override predicate isSink(DataFlow::Node sink){
        sink.asExpr() = any(LoggerFormatMethod lfm).getAReference().getAnArgument()
    }
}

from MySenInfoTaintConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "PII data from field $@ is written to long here", source, source.getNode().toString()

```

 ![image-20210418174047087](https://gitee.com/samny/images/raw/master/47u40er47ec/47u40er47ec.png)



---

###　无害处理

在路径查询结果中，我们查看的时候可以发现`creditCard`被`mask%`方法处理了，`mask%`方法是`马赛克`的意思。排除这个有这个方法路径，让结果更少的误报，这就需要重写`isSanitizer`谓词。在污点追踪里，`Sanitizer`即是无害处理。

![image-20210418165612231](https://gitee.com/samny/images/raw/master/12u56er12ec/12u56er12ec.png)



重写谓词`isSanitizer`，这里只需要排除方法名有`mask%`即可。

```
/**
 *@name PIIQuerySanitizerPath
 *@kind path-problem
 *@description 排除一些无效查询
 */

import java
import semmle.code.java.StringFormat
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.StringFormat

class SenInfoField extends Field{
    SenInfoField(){
        (this.getName().matches("%email%") or
        this.getName().matches("%phone%") or
        this.getName().matches("creditCard%")) and
        this.fromSource()
    }
}

class MySenInfoTaintConfig extends TaintTracking::Configuration{
    MySenInfoTaintConfig(){
        this = "MySenInfoTaintConfig"

    }

    override predicate isSource(DataFlow::Node source){
        source.asExpr() = any(SenInfoField sif).getAnAccess()
    }
    override predicate isSink(DataFlow::Node sink){
        sink.asExpr() = any(LoggerFormatMethod lfm).getAReference().getAnArgument()
    }
    override predicate isSanitizer(DataFlow::Node sanitizer){
        sanitizer.asExpr() = any(
            Method m| m.getName().matches("mask%")
        ).getAReference().getAnArgument()
    }
}

from MySenInfoTaintConfig config, DataFlow::PathNode source, DataFlow::PathNode sink, SenInfoField f
where 
    config.hasFlowPath(source, sink) and
    source.getNode().asExpr() = f.getAnAccess()
select sink,source,sink ,"PII data from field $@ is written to long here",f ,f.getName()
```

![image-20210418171150005](https://gitee.com/samny/images/raw/master/50u11er50ec/50u11er50ec.png)



---

## 总结

确定`Sources`、`Sink`编写污点追踪数据流-->完善和进一步找到路径-->无害处理。



----

## 参考

https://youtu.be/hHaOxbyqy44

[1]: `personally identifiable information(PII)` 个人身份信息