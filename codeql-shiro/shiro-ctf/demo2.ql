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

class Deserialize extends RefType{
    Deserialize(){
        this.hasQualifiedName("com.summersec.shiroctf.Tools", "Tools")
    }
}

class DeserializeTobytes extends Method{
    DeserializeTobytes(){
        this.getDeclaringType() instanceof Deserialize
        and
        this.hasName("deserialize")
    }
}

class Myindex extends RefType{
    Myindex(){
        this.hasQualifiedName("com.summersec.shiroctf.controller", "IndexController")
    }
}

class MyindexTomenthod extends Method{
    MyindexTomenthod(){
        this.getDeclaringType().getAnAncestor() instanceof Myindex
        and
        this.hasName("index")
    }
}

class ShiroUnsafeDeserializationConfig extends TaintTracking::Configuration {
    ShiroUnsafeDeserializationConfig() { 
        this = "StrutsUnsafeDeserializationConfig" 
    }

    override predicate isSource(DataFlow::Node source) {
        // exists(MyindexTomenthod m |
        //     source.asParameter() = m.getParameter(0)
        //     and
        //     source instanceof RemoteFlowSource
        // )
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
// select sink.getNode(), source, sink, "Unsafe shiro deserialization" ,source.getNode(), "this user input"
select sink, source, sink, "Unsafe shiro deserialization" ,source, "this user input"
