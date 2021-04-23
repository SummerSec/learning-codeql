<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:18f7c3a37f0b74b69f4831c3ac677e0ba479a0eb79670c5c2d7683a348a1990a
size 332
=======
import java
import semmle.code.java.dataflow.DataFlow

from Constructor fileReader, Call call, Parameter p
where
    fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
    call.getCallee() = fileReader and
    DataFlow::localFlow(DataFlow::parameterNode(p), DataFlow::exprNode(call.getArgument(0)))
select p
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
