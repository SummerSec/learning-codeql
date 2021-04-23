<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:76aeaa25fe9b44ae209e504d01b407949b6030d7aa318085e283219bf2875f87
size 1184
=======
/**
 *@name PIIQuery
 *@kind problem
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.StringFormat

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



from MySenInfoTaintConfig config, DataFlow::Node source, DataFlow::Node sink, SenInfoField f
where 
    config.hasFlow(source, sink) 
    // and
    // source.asExpr() = f.getAnAccess()
    // f.getAnAccess() = source.asExpr()
// select sink, "PII data from field $@ is written to long here",f , f.getName()
select sink,"PII data from field $@ is written to long here",source, source.asExpr().toString()
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
