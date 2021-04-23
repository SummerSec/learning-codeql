<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:0e9eaf20322bec1b0b2fb8040c0981de59a3b414801921c1aef52cfc2f0fc92f
size 364
=======
import cpp
import semmle.code.cpp.dataflow.TaintTracking

from FunctionCall call, DataFlow::Node source, DataFlow::Node sink
where
  call.getTarget().getName() = "snprintf" and
  call.getArgument(2).getValue().regexpMatch("(?s).*%s.*") and
  TaintTracking::localTaint(source, sink) and
  source.asExpr() = call and
  sink.asExpr() = call.getArgument(1)
select call
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
