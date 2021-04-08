

## one step by one step学习codeql挖掘反序列化漏洞

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



对于`Tools#exeCmd`方法的调用可以找到



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



### 确定source和sink

&emsp;&emsp;  首先确定一下`source`和`sink`，现在可以知道的是`IndexController`类中的`index`函数的参数`request`是可以用户可控可以作为一个`source`。然后现在目前已知可以反序列化函数点在`Tools#deserialize`函数，可以作为一个`sink`。











```java
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





```
HttpServletRequest request = null
Cookie[] cookie = request.getCookies();
byte[] bytes = Tools.base64Decode(cookie.getValue());
user = (User)Tools.deserialize(bytes);

师傅们，有没有办法将request和bytes联系起来
1. 目前来说我这个查不到任何结果。
2. 我的预期是将request作为source，sink是deserialize()函数
3. 但目前中间会有转化是会有影响的吗？
4. 然后我这样子写肯定是存在问题的，但目前来说我逻辑感觉是没有问题的，我也不知道问题的所在。
```





```
/**
 * @name Unsafe shiro deserialization
 * @kind path-problem
 * @id java/unsafe-shiro-deserialization
 */
import java
import semmle.code.java.dataflow.DataFlow
// import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph


predicate isDes(Expr arg){
    exists(MethodAccess des |
    des.getMethod().hasName("deserialize") 
    and
    arg = des.getArgument(0)
    )
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

class ShiroUnsafeDeserializationConfig extends DataFlow::Configuration {
    ShiroUnsafeDeserializationConfig() { 
        this = "StrutsUnsafeDeserializationConfig" 
    }

    override predicate isSource(DataFlow::Node source) {
        exists(MyindexTomenthod m |
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
select sink, source, sink, "Unsafe shiro deserialization"


```









---

### 参考

https://xz.aliyun.com/t/7789#toc-0

https://summersec.github.io/2021/03/28/CodeQL%20workshop%20for%20Java%20Unsafe%20deserialization%20in%20Apache%20Struts/

https://xz.aliyun.com/t/7789#toc-8