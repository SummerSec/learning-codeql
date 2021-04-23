<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:cb0e532bf862ad0a852c251fdc8b3dc184a3d817c15c7cfc4742099c254526f4
size 197
=======
import java

predicate isDes(Expr arg){
    exists(MethodAccess des |
    des.getMethod().hasName("deserialize") 
    and
    arg = des.getArgument(0))

}

from Expr arg
where isDes(arg)
select arg
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
