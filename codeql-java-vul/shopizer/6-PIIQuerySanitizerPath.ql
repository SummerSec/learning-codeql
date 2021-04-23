<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:1eff00bd46466392120d7c44c7d31b825273a2cfa4f394b1e4cfc5e783d0a7a3
size 1440
=======
/**
 *@name PIIQuerySanitizerPath
 *@kind path-problem
 *@description 排除一些无效查询
 */

import java
import semmle.code.java.StringFormat
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

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
    override predicate isSanitizer(DataFlow::Node sanitizer){
        sanitizer.asExpr() = any(
            Method m| m.getName().matches("mask%")
        ).getAReference().getAnArgument()
    }
}

from MySenInfoTaintConfig config, DataFlow::PathNode source, DataFlow::PathNode sink, SenInfoField f
where 
    config.hasFlowPath(source, sink) and
    source.getNode().asExpr() = f.getAnAccess()
select sink,source,sink ,"PII data from field $@ is written to long here",f ,f.getName()
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
