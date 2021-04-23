<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:91fbfad3583abaf7940fff3f6c3e56667f4790d6fc0b8ef2884c7b71cafdcb43
size 652
=======
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
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
