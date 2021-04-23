<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:7d72d5e159943d1f66ad7aca2e64cc7582064bed4ee5ddda50fe95a9118d98fd
size 346
=======
import cpp

from ExprCall c, PointerDereferenceExpr deref, VariableAccess va,
     Access fnacc
where c.getLocation().getFile().getBaseName() = "cjpeg.c" and
      c.getLocation().getStartLine() = 640 and
      deref = c.getExpr() and
      va = deref.getOperand() and
      fnacc = va.getTarget().getAnAssignedValue()
select c, fnacc.getTarget()
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
