<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:f9df67ba4a667f748f2cd9575dc585eeafea1723340b12e54c42d70459bb2579
size 208
=======
import cpp

from AddExpr a, Variable v, RelationalOperation cmp
where
  a.getAnOperand() = v.getAnAccess() and
  cmp.getAnOperand() = a and
  cmp.getAnOperand() = v.getAnAccess()
select cmp, "Overflow check."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
