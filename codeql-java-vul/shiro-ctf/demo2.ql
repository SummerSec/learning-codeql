<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:fc9640e032149668f332dc9e184df8ca0ed65b7caefdfd724c2b1f70cc139bfe
size 1129
=======
/**
 * @name Unsafe shiro deserialization
 * @kind path-problem
 * @id java/unsafe-shiro-deserialization
 */


import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

predicate isDes(Expr arg){
    exists(MethodAccess des |
    des.getMethod().hasName("deserialize") 
    and
    arg = des.getArgument(0)
    )
}




class ShiroUnsafeDeserializationConfig extends TaintTracking::Configuration {
    ShiroUnsafeDeserializationConfig() { 
        this = "StrutsUnsafeDeserializationConfig" 
    }

    override predicate isSource(DataFlow::Node source) {
        source instanceof RemoteFlowSource
    }
    override predicate isSink(DataFlow::Node sink) {
        exists(Expr arg|
            isDes(arg) and
            sink.asExpr() = arg /* bytes */
        )
    }
}


from ShiroUnsafeDeserializationConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe shiro deserialization" ,source.getNode(), "this user input"
// select sink, source, sink, "Unsafe shiro deserialization" ,source, "this user input"
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
