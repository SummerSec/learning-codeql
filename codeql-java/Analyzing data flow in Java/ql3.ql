import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.StringFormat

from StringFormatMethod format, MethodAccess call, Expr formatString
where
    // call.getMethod() = format and   //官方给的案例
    call.getMethod() instanceof StringFormatMethod and  // haby0给的建议更合适
    call.getArgument(format.getFormatStringIndex()) = formatString and
    not exists(DataFlow::Node source, DataFlow::Node sink |
        DataFlow::localFlow(source, sink) and
        source.asExpr() instanceof StringLiteral and
        sink.asExpr() = formatString
    )
select call, "Argument to String format method isn't hard-coded."
