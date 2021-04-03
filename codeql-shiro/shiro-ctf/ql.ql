import java
/*找到可以序列化类，实现了Serializable接口 */
from Class cl 
where cl.getASupertype() instanceof  TypeSerializable
    and 
    cl.fromSource()
select cl