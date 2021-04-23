<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:792b068ba86f0c909089f5991977704c98a429649651be4a9dbca5683852b013
size 1407
=======
/**
 * @name Unsafe shiro deserialization
 * @kind path-problem
 * @id java/unsafe-deserialization
 */
import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking


predicate isDes(Expr arg){
    exists(MethodAccess des |
    des.getMethod().hasName("deserialize") 
    and
    arg = des.getArgument(0))

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

class ShiroUnsafeDeserializationConfig extends DataFlow::Configuration {
    ShiroUnsafeDeserializationConfig() { 
        this = "ShiroUnsafeDeserializationConfig" 
    }

    override predicate isSource(DataFlow::Node source) {
        exists(MyindexTomenthod m |
            // m.
            source.asParameter() = m.getParameter(0)
        )
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
select sink, source, sink, "Unsafe Shiro deserialization"
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
