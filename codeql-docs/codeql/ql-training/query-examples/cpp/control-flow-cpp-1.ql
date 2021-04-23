<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:ad4ef9d971aceeffe97b561badbca238e8990de9b3895b16078b37ddb72d0c91
size 237
=======
import cpp
  
from FunctionCall alloc, FunctionCall free, LocalScopeVariable v
where allocationCall(alloc)
  and alloc = v.getAnAssignedValue()
  and freeCall(free, v.getAnAccess())
  and alloc.getASuccessor+() = free
select alloc, free
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
