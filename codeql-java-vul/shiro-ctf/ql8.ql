<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:ee4184835c116d26b0392454115eea583375848b30dd97e047205a292ecc18cc
size 383
=======
import java

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

from MyindexTomenthod m
select m.getParameter(0)
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
