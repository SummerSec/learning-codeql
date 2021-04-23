<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:45bfa30aa9838ec1aa5af299a24ee1f87bd7c39eeea6625b1b4c302947df0f42
size 525
=======
import cpp
import semmle.code.cpp.dataflow.TaintTracking

class TaintedFormatConfig extends TaintTracking::Configuration {
  TaintedFormatConfig() { this = "TaintedFormatConfig" }
  override predicate isSource(DataFlow::Node source) { /* TBD */ }
  override predicate isSink(DataFlow::Node sink) { /* TBD */ }
}

from TaintedFormatConfig cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, "This format string may be derived from a $@.",
              source, "user-controlled value"
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
