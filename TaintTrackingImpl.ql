/** 
 *@name TaintTrackingImpl
 *@kind path-problem
 *@derscription TaintTracking::Configuration 模板
 */
import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

class MyTaintTrackingConfig extends TaintTracking::Configuration {
    MyTaintTrackingConfig() { this = "MyTaintTrackingConfig" }

    override predicate isSource(DataFlow::Node source) {
        // TODO 
    }

    override predicate isSink(DataFlow::Node sink) {
        // TODO 
    }
}

from MyTaintTrackingConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Custom constraint error message contains unsanitized user data"