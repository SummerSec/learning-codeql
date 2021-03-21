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