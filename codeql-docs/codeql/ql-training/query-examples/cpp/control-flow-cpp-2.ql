<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:ac8c66b268bc90404606e028c9681ba06e8c40a3ec0911207e321e0fdddfaa7c
size 206
=======
import cpp
  
from FunctionCall free, LocalScopeVariable v, VariableAccess u
where freeCall(free, v.getAnAccess())
  and u = v.getAnAccess()
  and u.isRValue()
  and free.getASuccessor+() = u
select free, u
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
