<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:dbb43c1c2367d0306c42e5894c20eb8733a2e1965bf005a72287d8dfc452db68
size 198
=======
import java

from Constructor fileReader, Call call
where
    fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
    call.getCallee() = fileReader
select call.getArgument(0)
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
