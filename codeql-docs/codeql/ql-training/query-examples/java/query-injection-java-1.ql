<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:2afd75687eb9c30a206682f58eacd459346e1a41bf2cf954938fcfde1905642a
size 125
=======
import java

from Method m, MethodAccess ma
where
  m.getName().matches("sparql%Query") and
  ma.getMethod() = m
select ma, m
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
