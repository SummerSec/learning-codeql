/**
 * @name Unsafe shiro deserialization
 * @kind problem
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
        this = "StrutsUnsafeDeserializationConfig" 
    }

    override predicate isSource(DataFlow::Node source) {
        exists(MyindexTomenthod m |
            /* request */
            source.asParameter() = m.getParameter(0)
        )
    }
    override predicate isSink(DataFlow::Node sink) {
        exists(Expr arg|
            isDes(arg) and
            sink.asExpr() = arg /* bytes */
        )
    }
    
    override predicate isAdditionalFlowStep(DataFlow::Node n1 ,DataFlow::Node n2){
        exists(Call call |
            n1.asExpr() = call.getAnArgument() and
            n2.asExpr() = call
        )
    }
    
    
}

class CallTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
        exists(Call call |
        n1.asExpr() = call.getAnArgument() and
        n2.asExpr() = call
        )
    }
}




from ShiroUnsafeDeserializationConfig config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, "Unsafe shiro deserialization"