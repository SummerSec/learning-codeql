<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:f91e6aa041bdb112da41ad39e572ddfd1cd73c684703eba9e6f412ea11a539a4
size 289
=======
import java
import semmle.code.java.dataflow.DataFlow::DataFlow

from MethodAccess ma, StringConcat stringConcat
where
  ma.getMethod().getName().matches("sparql%Query") and
  localFlow(exprNode(stringConcat), exprNode(ma.getArgument(0)))
select ma, "SPARQL query vulnerable to injection."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
