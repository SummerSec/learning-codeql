<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:2afafa24d1fed4f7a5cac21a3cfcfa9c0068b577e1ddf92e297692919e0ce96b
size 282
=======
import java

class StringConcat extends AddExpr {
  StringConcat() { getType() instanceof TypeString }
}

from MethodAccess ma
where
  ma.getMethod().getName().matches("sparql%Query") and
  ma.getArgument(0) instanceof StringConcat
select ma, "SPARQL query vulnerable to injection."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
