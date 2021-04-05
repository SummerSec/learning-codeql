## one step by one step学习codeql挖掘反序列化漏洞

### 找到可以序列化的类



```ql
import java

from Class cl 
where cl.getASupertype() instanceof  TypeSerializable
select cl
```



![image-20210403145916528](https://gitee.com/samny/images/raw/master/16u59er16ec/16u59er16ec.png)



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

&emsp;&emsp;  首先确定一下`source`和`sink`，现在可以知道的是`IndexController`类中的`index`函数的参数`request`是可以用户可控可以作为一个`source`。然后现在目前已知可以反序列化函数点在`Tools#deserialize`函数，可以作为一个`sink`。

```java
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
```







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
```



---

### 参考

https://xz.aliyun.com/t/7789#toc-0