<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:550d0146ab23f23f251d76415b0cddc5547de2ed76ff2472e28fe2305b29732d
size 683
=======
import semmle.code.java.dataflow.DataFlow

class Configuration extends DataFlow::Configuration {
    Configuration() {
        this = "LiteralToURL Configuration"
    }

    override predicate isSource(DataFlow::Node source) {
        source.asExpr() instanceof StringLiteral
    }

    override predicate isSink(DataFlow::Node sink) {
        exists(Call call |
        sink.asExpr() = call.getArgument(0) and
        call.getCallee().(Constructor).getDeclaringType().hasQualifiedName("java.net", "URL")
        )
    }
}

from DataFlow::Node src, DataFlow::Node sink, Configuration config
where config.hasFlow(src, sink)
select src, "This string constructs a URL $@.", sink, "here"
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
