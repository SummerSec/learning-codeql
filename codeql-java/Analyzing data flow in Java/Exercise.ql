<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:a40e657b628619cdf99dad4c3056c1d56bbc5343a726f44b005dfbe816ee2553
size 298
=======
import semmle.code.java.dataflow.DataFlow

from Constructor url, Call call, StringLiteral src
where
    url.getDeclaringType().hasQualifiedName("java.net", "URL") and
    call.getCallee() = url and
    DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(call.getArgument(0)))
select src
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
