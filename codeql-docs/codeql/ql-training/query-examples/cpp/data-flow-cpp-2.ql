<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:ac8222c61f3a1c910c053be9b69af6035f778c6fb98e32aeb918947a086517b4
size 442
=======
import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.commons.Printf

class SourceNode extends DataFlow::Node { /* ... */ }

from FormattingFunction f, Call c, SourceNode src, DataFlow::Node arg
where c.getTarget() = f and
      arg.asExpr() = c.getArgument(f.getFormatParameterIndex()) and
      DataFlow::localFlow(src, arg) and
      not src.asExpr() instanceof StringLiteral
select arg, "Non-constant format string."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
