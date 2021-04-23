<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:76b2844e0561bada6ed535f40d3556d1b3dffe38005addef4b9b2a0d71316da3
size 328
=======
import java
import semmle.code.java.dataflow.DataFlow

from Constructor fileReader, Call call, Expr src
where
    fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
    call.getCallee() = fileReader and
    DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(call.getArgument(0)))
select src
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
