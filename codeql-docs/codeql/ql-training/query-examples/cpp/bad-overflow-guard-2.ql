<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:f4c6c9c536452ca3c1b6e912641fc01950ee8f5b03021e3a043213c5d5364d9b
size 272
=======
import cpp

from AddExpr a, Variable v, RelationalOperation cmp
where
  a.getAnOperand() = v.getAnAccess() and
  cmp.getAnOperand() = a and
  cmp.getAnOperand() = v.getAnAccess() and
  forall(Expr op | op = a.getAnOperand() | isSmall(op))
select cmp, "Bad overflow check."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
