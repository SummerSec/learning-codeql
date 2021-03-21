import java
import semmle.code.java.dataflow.DataFlow

from Constructor fileReader, Call call, Expr src
where
    fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
    call.getCallee() = fileReader and
    DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(call.getArgument(0)))
select src