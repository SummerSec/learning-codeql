import java
/*找到可以序列化类，实现了Serializable接口 */
from Class cl 
where 
    cl.getASupertype() instanceof  TypeSerializable
    /* 递归判断类是不是实现Serializable接口*/
    // and 
    // cl.fromSource()
    /* 限制来源 */
select cl
/* 查询语句 */