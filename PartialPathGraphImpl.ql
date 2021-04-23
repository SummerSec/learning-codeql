/** 
 *@name PartialPathGraphImpl
 *@kind path-problem
 *@derscription DataFlow::PartialPathGraph  模板
 */
import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PartialPathGraph // this is different!

class MyTaintTrackingConfig extends TaintTracking::Configuration {
    MyTaintTrackingConfig() { ... } // same as before
    override predicate isSource(DataFlow::Node source) { ... } // same as before
    override predicate isSink(DataFlow::Node sink) { ... } // same as before
    override int explorationLimit() { result =  10} // this is different!
}
from MyTaintTrackingConfig cfg, DataFlow::PartialPathNode source, DataFlow::PartialPathNode sink
where
  cfg.hasPartialFlow(source, sink, _) and
  source.getNode() = ... // TODO restrict to the one source we are interested in, for ease of debugging
select sink, source, sink, "Partial flow from unsanitized user data"

predicate partial_flow(PartialPathNode n, Node src, int dist) {
  exists(MyTaintTrackingConfig conf, PartialPathNode source |
    conf.hasPartialFlow(source, n, dist) and
    src = source.getNode() and
    source =  // TODO - restrict to THE source we are interested in
  )
}