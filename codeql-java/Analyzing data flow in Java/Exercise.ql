import semmle.code.java.dataflow.DataFlow

from Constructor url, Call call, StringLiteral src
where
    url.getDeclaringType().hasQualifiedName("java.net", "URL") and
    call.getCallee() = url and
    DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(call.getArgument(0)))
select src