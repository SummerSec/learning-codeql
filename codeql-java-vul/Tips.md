## 编写CodeQL过程中学习到小TIPS



### fromSource

`fromSource`谓词会排除JDK下一下类、方法、字段等



### GetAReference 



`getAReference`谓词是Call下的一个谓词

```
  /** Gets a call site that references this callable. */
  Call getAReference() { result.getCallee() = this }
```

使用参考案例

```
import java

from MethodAccess cl

select cl.getCallee().getAReference()
// select cl.getCallee()

```

运行结果：

`select cl.getCallee().getAReference()`

![image-20210417095420909](https://gitee.com/samny/images/raw/master/21u54er21ec/21u54er21ec.png)

` select cl.getCallee()`

![image-20210417095453531](https://gitee.com/samny/images/raw/master/53u54er53ec/53u54er53ec.png)



可以进而使用`getArgument()`谓词获取方法参数

```
import java

from MethodAccess cl

select cl.getCallee().getAReference().getArgument(0)
// select cl.getCallee()

```

![image-20210417095721610](https://gitee.com/samny/images/raw/master/21u57er21ec/21u57er21ec.png)



### where clause `=`

在CodeQL中会陷入一个思维死局中！

where clause中的`=`是其他高级语言不一样，比如说下面两段QL代码是一样的。

```
import java

from Field f, Field y
where f.getAnAccess() = y.getAnAccess()
select f
```



```
import java

from Field f, Field y
where y.getAnAccess() = f.getAnAccess()
select y
```



在看一段代码

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

在这段QL代码中，`f.getAnAccess() =  source.asExpr()`完全和`source.asExpr() = f.getAnAccess()`效果是一样，这就意味着`=`是判断相同或者是判断相等并不是赋值。



---

### Defining the results of a query

关于`$@`参考[Defining the results of a query](https://github.com/SummerSec/learning-codeql/tree/main/CodeQL%20Queries/Defining%20the%20results%20of%20a%20query)

---

