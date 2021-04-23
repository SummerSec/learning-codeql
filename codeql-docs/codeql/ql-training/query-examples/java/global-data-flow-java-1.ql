<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:7e0aadb6d7104f059c900dee20f16a11ccdfc2f1146b41a12b08b6f2c085414e
size 516
=======
import java
import semmle.code.java.dataflow.TaintTracking

class TaintedOGNLConfig extends TaintTracking::Configuration {
  TaintedOGNLConfig() { this = "TaintedOGNLConfig" }
  override predicate isSource(DataFlow::Node source) { /* TBD */ }
  override predicate isSink(DataFlow::Node sink) { /* TBD */ }
}

from TaintedOGNLConfig cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select source,
       "This untrusted input is evaluated as an OGNL expression $@.",
       sink, "here"
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
