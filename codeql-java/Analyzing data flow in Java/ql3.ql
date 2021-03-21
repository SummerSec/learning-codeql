import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.StringFormat

from StringFormatMethod format, MethodAccess call, Expr formatString
where
    call.getMethod() = format and
    call.getArgument(format.getFormatStringIndex()) = formatString and
    not exists(DataFlow::Node source, DataFlow::Node sink |
        DataFlow::localFlow(source, sink) and
        source.asExpr() instanceof StringLiteral and
        sink.asExpr() = formatString
    )
select call, "Argument to String format method isn't hard-coded."