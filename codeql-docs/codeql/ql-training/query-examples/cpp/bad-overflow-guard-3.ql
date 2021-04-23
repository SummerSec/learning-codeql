<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:bd8e38042aa8e1f40a324ff7488120737401699de22a54fcc20d12c7c58aa4c2
size 374
=======
import cpp

predicate isSmall(Expr e) { e.getType().getSize() < 4 }

from AddExpr a, Variable v, RelationalOperation cmp
where
  a.getAnOperand() = v.getAnAccess() and
  cmp.getAnOperand() = a and
  cmp.getAnOperand() = v.getAnAccess() and
  forall(Expr op | op = a.getAnOperand() | isSmall(op)) and
  not isSmall(a.getExplicitlyConverted())
select cmp, "Bad overflow check"
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
