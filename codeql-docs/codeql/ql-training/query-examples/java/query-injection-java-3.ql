<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:38373be9c9cc42ec3f993589b009de9969097281323f327a1314ae75dce56b04
size 282
=======
import java

predicate isStringConcat(AddExpr ae) {
  ae.getType() instanceof TypeString
}

from Method m, MethodAccess ma
where
  m.getName().matches("sparql%Query") and
  ma.getMethod() = m and
  isStringConcat(ma.getArgument(0))
select ma, "SPARQL query vulnerable to injection."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
