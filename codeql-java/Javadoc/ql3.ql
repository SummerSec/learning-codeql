<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:da497c18ff69b84feaef013158af0643ac1af7e8056a814e401499c53ccd8745
size 180
=======
import java

from Callable c, ParamTag pt
where c.getDoc().getJavadoc() = pt.getParent() and
    not c.getAParameter().hasName(pt.getParamName())
select pt, "Spurious @param tag." 
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
