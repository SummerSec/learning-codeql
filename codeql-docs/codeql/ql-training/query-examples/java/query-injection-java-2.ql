<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:47b20f1c440f787aef8cbde4883ce379e83547de26d725829e9baf31366c0d54
size 165
=======
import java

from Method m, MethodAccess ma
where
  m.getName().matches("sparql%Query") and
  ma.getMethod() = m and
  isStringConcat(ma.getArgument(0))
select ma, m
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
