<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:33efb2635d8d0d292d65f3f2a2b9ad33d13d4578ec0ffabe93ef1c8f4b9e0434
size 135
=======
import java

from MethodAccess des,Expr arg
where des.getMethod().getName() = "deserialize"
and
    arg = des.getArgument(0)
select arg
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
