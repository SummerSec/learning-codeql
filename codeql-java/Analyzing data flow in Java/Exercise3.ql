import semmle.code.java.dataflow.DataFlow

class GetenvSource extends DataFlow::ExprNode {
    GetenvSource() {
        exists(Method m | m = this.asExpr().(MethodAccess).getMethod() |
        m.hasName("getenv") and
        m.getDeclaringType() instanceof TypeSystem
        )
    }
}

class GetenvToURLConfiguration extends DataFlow::Configuration {
    GetenvToURLConfiguration() {
        this = "GetenvToURLConfiguration"
    }

    override predicate isSource(DataFlow::Node source) {
        source instanceof GetenvSource
    }

    override predicate isSink(DataFlow::Node sink) {
        exists(Call call |
        sink.asExpr() = call.getArgument(0) and
        call.getCallee().(Constructor).getDeclaringType().hasQualifiedName("java.net", "URL")
        )
    }
}

from DataFlow::Node src, DataFlow::Node sink, GetenvToURLConfiguration config
where config.hasFlow(src, sink)
select src, "This environment variable constructs a URL $@.", sink, "here"