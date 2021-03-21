import java
import semmle.code.java.dataflow.DataFlow

from Constructor fileReader, Call call, Parameter p
where
    fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
    call.getCallee() = fileReader and
    DataFlow::localFlow(DataFlow::parameterNode(p), DataFlow::exprNode(call.getArgument(0)))
select p