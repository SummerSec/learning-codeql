

## one step by one step学习CodeQL挖掘反序列化漏洞

### 前言



&emsp;&emsp; 本次实验项目源码来源之前我写的Shiro-CTF的源码https://github.com/SummerSec/JavaLearnVulnerability/tree/master/shiro/shiro-ctf ，项目需要database文件上传到GitHub项目**[ learning-codeql](https://github.com/SummerSec/learning-codeql)**上。

&emsp;&emsp; 本文的漏洞分析文章[一道shiro反序列化题目引发的思考](https://summersec.github.io/2021/03/05/%E4%B8%80%E9%81%93shiro%E5%8F%8D%E5%BA%8F%E5%88%97%E5%8C%96%E9%A2%98%E7%9B%AE%E5%BC%95%E5%8F%91%E7%9A%84%E6%80%9D%E8%80%83/) ，看本文之前看完这漏洞分析会更好的理解。但本文会从全新的角度去挖掘审计漏洞，但难免会有之前既定思维。如果你有兴趣和我一起交流学习CodeQL可以联系summersec#qq.com。

```
shiro-ctf
    │  demo.ql
    │  demo1.ql
    │  demo2.ql
    │  ql.ql
    │  ql1.ql
    │  ql2.ql
    │  ql3.ql
    │  ql4.ql
    │  ql5.ql
    │  ql6.ql
    │  ql7.ql
    │  ql8.ql
    │  ql9.ql
    │  qlpack.yml
    │  queries.xml
    │  README.md
    │  shiro-ctf-datas.zip
    │  workspace.code-workspace
```

----



### 找到可以序列化的类

&emsp;&emsp; 挖掘反序列化漏洞，首先得找到入口。可以反序列化的类首先肯定是实现了接口`Serializable`，其次会有一个字段`serialVersionUID`，所以我们可以从找字段或者找实现接口`Serializable`入手进行代码分析。

1. `TypeSerializable`  类，在JDK中声明

2. `instanceof` 断言

3. `fromSource` 谓词判断来着项目代码排除JDK自带

4. `getASupertype` 递归，父类类型

    

```ql
import java
/*找到可以序列化类，实现了Serializable接口 */
from Class cl 
where 
    cl.getASupertype() instanceof  TypeSerializable
    /* 递归判断类是不是实现Serializable接口*/
    and 
    cl.fromSource()
    /* 限制来源 */
select cl
/* 查询语句 */
```

![image-20210407165147780](https://gitee.com/samny/images/raw/master/47u51er47ec/47u51er47ec.png)



点击查询出来的结果可以看到对应的查询结果源码

![image-20210407165420324](https://gitee.com/samny/images/raw/master/20u54er20ec/20u54er20ec.png)



### 找User类实例化代码

使用`RefType.hasQualifiedName(string packageName, string className)`来识别具有给定包名和类名的类，这里使用一个类继承`RefType`，使代码可读性更高点。例如下面两端QL代码是等效的：

```
import java

from RefType r
where r.hasQualifiedName("com.summersec.shiroctf.bean", "User")
select r
```



```ql
import java
/* 找到实例化User的类 */
class MyUser extends RefType{
    MyUser(){
        this.hasQualifiedName("com.summersec.shiroctf.bean", "User")
    }
}



from ClassInstanceExpr clie
where 
    clie.getType() instanceof MyUser
select clie
```



![image-20210403161916030](https://gitee.com/samny/images/raw/master/16u19er16ec/16u19er16ec.png)

可以发现在`IndexController`类59行处实例化`User`类。

![image-20210407170528622](https://gitee.com/samny/images/raw/master/28u05er28ec/28u05er28ec.png)



`IndexController`：

```
package com.summersec.shiroctf.controller;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.summersec.shiroctf.Tools.LogHandler;
import com.summersec.shiroctf.Tools.Tools;
import com.summersec.shiroctf.bean.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class IndexController {
    public IndexController() {
    }

    @GetMapping({"/"})
    public String main() {
        return "redirect:login";
    }

    @GetMapping({"/index/{name}"})
    public String index(HttpServletRequest request, HttpServletResponse response, @PathVariable String name) throws Exception {
        Cookie[] cookies = request.getCookies();
        boolean exist = false;
        Cookie cookie = null;
        User user = null;
        if (cookies != null) {
            Cookie[] var8 = cookies;
            int var9 = cookies.length;

            for(int var10 = 0; var10 < var9; ++var10) {
                Cookie c = var8[var10];
                if (c.getName().equals("hacker")) {
                    exist = true;
                    cookie = c;
                    break;
                }
            }
        }

        if (exist) {

            byte[] bytes = Tools.base64Decode(cookie.getValue());
            user = (User)Tools.deserialize(bytes);


        } else {
            user = new User();
            user.setID(1);
            user.setUserName(name);
            cookie = new Cookie("hacker", Tools.base64Encode(Tools.serialize(user)));
            response.addCookie(cookie);
        }

        request.setAttribute("hacker", user);
        request.setAttribute("logs", new LogHandler());
        return "index";
    }
}
```

----

#### 查看Tools类源码是否存在问题

查看源码有`Base64`编码解码函数、序列化、反序列化以及`exeCmd`方法，该函数可以执行命令

对于`Tools#deserialize`方法可以编写规则：

```
import java

class Deserialize extends RefType{
    Deserialize(){
        this.hasQualifiedName("com.summersec.shiroctf.Tools", "Tools")
    }
}

class DeserializeTobytes extends Method{
    DeserializeTobytes(){
        this.getDeclaringType() instanceof Deserialize
        and
        this.hasName("deserialize")
    }

}

from DeserializeTobytes des
select des
```

![image-20210408111311362](https://gitee.com/samny/images/raw/master/11u13er11ec/11u13er11ec.png)



对于`Tools#exeCmd`方法的调用可以找到，可以发现`LogHandler`类调用了两次`exeCmd`方法。

```
import java
/* 找到调用exeCmd方法 */
from MethodAccess exeCmd 
where exeCmd.getMethod().hasName("exeCmd") 
select exeCmd
```



![image-20210408112348838](https://gitee.com/samny/images/raw/master/48u23er48ec/48u23er48ec.png)

![image-20210408112415555](https://gitee.com/samny/images/raw/master/15u24er15ec/15u24er15ec.png)



下面是`exeCmd`方法的源码，不能发现可以执行任何命令，传入的参数`commandStr`即是将被执行的命令。

```
public static String exeCmd(String commandStr) {
        BufferedReader br = null;
        String OS = System.getProperty("os.name").toLowerCase();


        try {
            Process p = null;
            if (OS.startsWith("win")){
                p = Runtime.getRuntime().exec(new String[]{"cmd", "/c", commandStr});
            }else {
                p = Runtime.getRuntime().exec(new String[]{"/bin/bash", "-c", commandStr});
            }

            br = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String line = null;
            StringBuilder sb = new StringBuilder();

            while((line = br.readLine()) != null) {
                sb.append(line + "\n");
            }

            return sb.toString();
        } catch (Exception var5) {
            var5.printStackTrace();
            return "error";
        }
    }
```





----

### 精简代码逻辑

对`IndexController`简单提炼处理逻辑，画出数据流流程图：

![image-20210407181153644](https://gitee.com/samny/images/raw/master/53u11er53ec/53u11er53ec.png)



```
HttpServletRequest request = null
Cookie[] cookies = request.getCookies();
Cookie cookie = c
byte[] bytes = Tools.base64Decode(cookie.getValue());
user = (User)Tools.deserialize(bytes);

```

目前就有以下几点：

1. `request`和`bytes`是有联系的
2. 预期是将`request`作为`source`，`sink`是`deserialize()#bytes`
3. `Tools#exeCmd`方法肯定是可以被利用的
4. `Loghandler`类的目的？



----



### 污点分析

#### 污点分析简单介绍

&emsp;&emsp; 现在已经确定了(a)程序中接收不受信任数据的地方和(b)程序中可能执行不安全的反序列化的地方。现在把这两个地方联系起来：未受信任的数据是否流向潜在的不安全的反序列化调用？在程序分析中，我们称之为`数据流`问题。数据流作用：这个表达式是否持有一个源程序中某一特定地方的值呢？

&emsp;&emsp; 污点分析是一种跟踪并分析污点信息在程序中流动的技术。在漏洞分析中，使用污点分析技术将所感兴趣的数据（通常来自程序的外部输入）标记为**污点数据**，然后通过跟踪和污点数据相关的信息的流向，可以知道它们是否会影响某些关键的程序操作，进而挖掘程序漏洞。

在CodeQL提供了数据流分析的模块，分为全局数据流、本地数据流、远程数据流。数据流分析有一般有以下几点：

* `source` 定义污染数据即污点

* `sink`  判断污点数据流出
* `sanitizers` 对数据流判断无害处理（可选）
* `additionalTaintStep` CodeQL增加判断污染额外步骤（可选）

Example：

```
int func(int tainted) {
   int x = tainted;
   if (someCondition) {
     int y = x;
     callFoo(y);
   } else {
     return x;
   }
   return -1;
}
```

&emsp;&emsp; 上面的方法的数据流图是下面这样子，这个图表示污点参数的数据流。图的节点代表有值的程序元素，如函数参数和表达式。该图的边代表流经这些节点的流量。变量 y 的取值依赖于变量 x 的取值，如果变量 x 是污染的，那么变量 y 也应该是污染的。



![img](https://gitee.com/samny/images/raw/master/20u06er20ec/20u06er20ec.png)



更多学习资料：

[污点分析简单介绍](https://0range228.github.io/%E6%B1%A1%E7%82%B9%E5%88%86%E6%9E%90%E7%AE%80%E5%8D%95%E4%BB%8B%E7%BB%8D/) 对污点分析做了详细的介绍

[CodeQL-数据流在Java中的使用](https://github.com/haby0/mark/blob/master/articles/2021/CodeQL-%E6%95%B0%E6%8D%AE%E6%B5%81%E5%9C%A8Java%E4%B8%AD%E7%9A%84%E4%BD%BF%E7%94%A8.md) 百度某大佬对CodeQL数据流分析的见解

[CodeQL workshop for Java Unsafe deserialization in Apache Struts](https://summersec.github.io/2021/03/28/CodeQL%20workshop%20for%20Java%20Unsafe%20deserialization%20in%20Apache%20Struts/) 官方对数据流分析简单介绍（中英对照翻译版）



----



#### 确定source和sink

&emsp;&emsp;  首先确定一下`source`和`sink`，现在可以知道的是`IndexController`类中的`index`函数的参数`request`是可以用户可控可以作为一个`source`。然后现在目前已知可以反序列化函数点在`Tools#deserialize`方法的传入参数`bytes`，可以作为一个`sink`。



##### Source部分



```
class Myindex extends RefType{
    Myindex(){
        this.hasQualifiedName("com.summersec.shiroctf.controller", "IndexController")
    }
}

class MyindexTomenthod extends Method{
    MyindexTomenthod(){
        this.getDeclaringType().getAnAncestor() instanceof Myindex
        and
        this.hasName("index")
    }
}
```

![image-20210408203416533](https://gitee.com/samny/images/raw/master/16u34er16ec/16u34er16ec.png)

##### Sink部分

```
predicate isDes(Expr arg){
    exists(MethodAccess des |
    des.getMethod().hasName("deserialize") 
    and
    arg = des.getArgument(0)
    )
}
```

![image-20210408203429010](https://gitee.com/samny/images/raw/master/29u34er29ec/29u34er29ec.png)



source部分可以查到request，sink部分可以查到bytes。



----

##### 全局数据流模板



```
/**
 * @name Unsafe shiro deserialization
 * @kind problem
 * @id java/unsafe-deserialization
 */
import java
import semmle.code.java.dataflow.DataFlow

// TODO add previous class and predicate definitions here

class ShiroUnsafeDeserializationConfig extends DataFlow::Configuration {
  ShiroUnsafeDeserializationConfig() { this = "ShiroUnsafeDeserializationConfig" }
  override predicate isSource(DataFlow::Node source) {
    exists(/** TODO fill me in **/ |
      source.asParameter() = /** TODO fill me in **/
    )
  }
  override predicate isSink(DataFlow::Node sink) {
    exists(/** TODO fill me in **/ |
      /** TODO fill me in **/
      sink.asExpr() = /** TODO fill me in **/
    )
  }
}

from ShiroUnsafeDeserializationConfig config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, "Unsafe Shiro deserialization"
```



---



### 第一次尝试



CodeQL的注释部分是对查询结果有影响的，`@kind`关键词将`problem`转换为 `path -problem`告诉CodeQL工具将这个查询的结果解释为路径结果。

第一次完整QL代码：

```
/**
 * @name Unsafe shiro deserialization
 * @kind path-problem
 * @id java/unsafe-deserialization
 */
import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking


predicate isDes(Expr arg){
    exists(MethodAccess des |
    des.getMethod().hasName("deserialize") 
    and
    arg = des.getArgument(0))

}

class Myindex extends RefType{
    Myindex(){
        this.hasQualifiedName("com.summersec.shiroctf.controller", "IndexController")
    }
}

class MyindexTomenthod extends Method{
    MyindexTomenthod(){
        this.getDeclaringType().getAnAncestor() instanceof Myindex
        and
        this.hasName("index")
    }
}

class ShiroUnsafeDeserializationConfig extends TaintTracking::Configuration {
    ShiroUnsafeDeserializationConfig() { 
        this = "ShiroUnsafeDeserializationConfig" 
    }

    override predicate isSource(DataFlow::Node source) {
        exists(MyindexTomenthod m |
            // m.
            source.asParameter() = m.getParameter(0)
        )
    }
    override predicate isSink(DataFlow::Node sink) {
        exists(Expr arg|
            isDes(arg) and
            sink.asExpr() = arg /* bytes */
        )
    }
    

    
    
}

from ShiroUnsafeDeserializationConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "Unsafe Shiro deserialization"
```

查询时报错：

```
Exception during results interpretation: Interpreting query results failed: A fatal error occurred: Could not process query metadata.
Error was: Expected result pattern(s) are not present for query kind "path-problem": Expected between two and four result patterns. [INVALID_RESULT_PATTERNS]
[2021-04-06 15:53:16] Exception caught at top level: Could not process query metadata.
                      Error was: Expected result pattern(s) are not present for query kind "path-problem": Expected between two and four result patterns. [INVALID_RESULT_PATTERNS]
                      com.semmle.cli2.bqrs.InterpretCommand.executeSubcommand(InterpretCommand.java:123)
                      com.semmle.cli2.picocli.SubcommandCommon.executeWithParent(SubcommandCommon.java:414)
                      com.semmle.cli2.execute.CliServerCommand.lambda$executeSubcommand$0(CliServerCommand.java:67)
                      com.semmle.cli2.picocli.SubcommandMaker.runMain(SubcommandMaker.java:201)
                      com.semmle.cli2.execute.CliServerCommand.executeSubcommand(CliServerCommand.java:67)
                      com.semmle.cli2.picocli.SubcommandCommon.call(SubcommandCommon.java:430)
                      com.semmle.cli2.picocli.SubcommandMaker.runMain(SubcommandMaker.java:201)
                      com.semmle.cli2.picocli.SubcommandMaker.runMain(SubcommandMaker.java:209)
                      com.semmle.cli2.CodeQL.main(CodeQL.java:91)
. Will show raw results instead.
```

当时询问了几个大佬，没解决之后，去GitHub实验室的Discussion去提问老外帮忙解决的。[Discussion332](https://github.com/github/securitylab/discussions/332) 大致意思时导入`import DataFlow::PathGraph`而不是`import semmle.code.java.dataflow.TaintTracking`



![image-20210408203006971](https://gitee.com/samny/images/raw/master/7u30er7ec/7u30er7ec.png)



### 第二次尝试



```
/**
 * @name Unsafe shiro deserialization
 * @kind path-problem
 * @id java/unsafe-deserialization
 */
import java
import semmle.code.java.dataflow.DataFlow
//import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

predicate isDes(Expr arg){
    exists(MethodAccess des |
    des.getMethod().hasName("deserialize") 
    and
    arg = des.getArgument(0))

}

class Myindex extends RefType{
    Myindex(){
        this.hasQualifiedName("com.summersec.shiroctf.controller", "IndexController")
    }
}

class MyindexTomenthod extends Method{
    MyindexTomenthod(){
        this.getDeclaringType().getAnAncestor() instanceof Myindex
        and
        this.hasName("index")
    }
}

// class ShiroUnsafeDeserializationConfig extends TaintTracking::Configuration {
class ShiroUnsafeDeserializationConfig extends DataFlow::Configuration {
    ShiroUnsafeDeserializationConfig() { 
        this = "ShiroUnsafeDeserializationConfig" 
    }

    override predicate isSource(DataFlow::Node source) {
        exists(MyindexTomenthod m |
            // m.
            source.asParameter() = m.getParameter(0)
        )
    }
    override predicate isSink(DataFlow::Node sink) {
        exists(Expr arg|
            isDes(arg) and
            sink.asExpr() = arg /* bytes */
        )
    }
    

    
    
}

from ShiroUnsafeDeserializationConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "Unsafe Shiro deserialization"
```



第二次尝试并没有任何报错，但没有任何结果，遗憾收场。



----

### 第三次尝试

第二次尝试之后，我把全部代码逻辑在脑子进行无数次演算，不断的推敲逻辑是否可行。实在没办法之后咨询了某度大佬之后，师傅建议使用`RemoteFlowSource`，在翻开博客之后成功解决。后期大佬解释了`RemoteFlowSource`的作用，该类考虑了很多种用户输入数据的情况。

```
/**
 * @name Unsafe shiro deserialization
 * @kind path-problem
 * @id java/unsafe-shiro-deserialization
 */


import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

predicate isDes(Expr arg){
    exists(MethodAccess des |
    des.getMethod().hasName("deserialize") 
    and
    arg = des.getArgument(0)
    )
}

class ShiroUnsafeDeserializationConfig extends TaintTracking::Configuration {
    ShiroUnsafeDeserializationConfig() { 
        this = "StrutsUnsafeDeserializationConfig" 
    }

    override predicate isSource(DataFlow::Node source) {
        source instanceof RemoteFlowSource
    }
    override predicate isSink(DataFlow::Node sink) {
        exists(Expr arg|
            isDes(arg) and
            sink.asExpr() = arg /* bytes */
        )
    }
}

from ShiroUnsafeDeserializationConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe shiro deserialization" ,source.getNode(), "this user input"
// select sink, source, sink, "Unsafe shiro deserialization" ,source, "this user input"
```



![image-20210408204606897](https://gitee.com/samny/images/raw/master/18u46er18ec/18u46er18ec.png)



其实查到这里并没有达到我心理的预期，预期结果是将：`request->cookies->cookie->bytes`整个路径查询出来。于是我又去Discussion去提问了，[Disuccsion334](https://github.com/github/securitylab/discussions/334) ，起初我没看懂老外的意思，老外也没有懂我的意思，语言的障碍，下面是对话内容：

![image-20210408205610338](https://gitee.com/samny/images/raw/master/10u56er10ec/10u56er10ec.png)

老外给的答案，大致意思这样子已经很好，没有必要去追求。实在想的话，得把source部分改了并且增加谓词`isAdditionTaintStep`。

![image-20210408205635743](https://gitee.com/samny/images/raw/master/35u56er35ec/35u56er35ec.png)



----

### 补充



```
private Object target;
private String readLog = "tail  accessLog.txt";
private String writeLog = "echo /test >> accessLog.txt";

public LogHandler() {
}

public LogHandler(Object target) {
    this.target = target;
}

@Override
public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {

    Tools.exeCmd(this.writeLog.replaceAll("/test", (String)args[0]));
    return method.invoke(this.target, args);
}

@Override
public String toString() {
    return Tools.exeCmd(this.readLog);
}
```



----

### 总结





---

### 参考

https://xz.aliyun.com/t/7789#toc-0

https://summersec.github.io/2021/03/28/CodeQL%20workshop%20for%20Java%20Unsafe%20deserialization%20in%20Apache%20Struts/

https://xz.aliyun.com/t/7789#toc-8

https://0range228.github.io/%E6%B1%A1%E7%82%B9%E5%88%86%E6%9E%90%E7%AE%80%E5%8D%95%E4%BB%8B%E7%BB%8D/

https://github.com/github/securitylab/discussions/334

https://github.com/haby0/mark/blob/master/articles/2021/CodeQL-%E6%95%B0%E6%8D%AE%E6%B5%81%E5%9C%A8Java%E4%B8%AD%E7%9A%84%E4%BD%BF%E7%94%A8.md