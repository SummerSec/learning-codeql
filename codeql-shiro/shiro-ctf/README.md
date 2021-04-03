## 优雅的学习codeql挖掘反序列化漏洞

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