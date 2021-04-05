import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking

class CallTaintStep extends TaintTracking::AdditionalTaintStep{
    override predicate step(DataFlow::Node n1, DataFlow::Node n2){
        exists(Call call | 
        n1.asExpr() = call.getAnArgument() and 
        n2.asExpr() = call)

    }

}