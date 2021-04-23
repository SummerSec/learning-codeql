<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:6f03dfacd3519173c4fbe26719690e95ee3fc87335b950d4dc898a604bfae461
size 1080
=======
/**
 *@name PIIQueryPath
 *@kind path-problem
 *@description 污染路径
 */

import java
import semmle.code.java.StringFormat
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph


class SenInfoField extends Field{
    SenInfoField(){
        (this.getName().matches("%email%") or
        this.getName().matches("%phone%") or
        this.getName().matches("creditCard%")) and
        this.fromSource()
    }
}

class MySenInfoTaintConfig extends TaintTracking::Configuration{
    MySenInfoTaintConfig(){
        this = "MySenInfoTaintConfig"

    }

    override predicate isSource(DataFlow::Node source){
        source.asExpr() = any(SenInfoField sif).getAnAccess()
    }
    override predicate isSink(DataFlow::Node sink){
        sink.asExpr() = any(LoggerFormatMethod lfm).getAReference().getAnArgument()
    }
}

from MySenInfoTaintConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "PII data from field $@ is written to long here", source, source.getNode().toString()
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
