<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:e33f45f0824a42db416c1bfdf53669eb82547f436e50ecad028c7735ca4b01ee
size 284
=======
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
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
