import java

// Represent deprecated methods
class DeprecatedMethod extends Method {
    DeprecatedMethod() {
        this.getAnAnnotation() instanceof DeprecatedAnnotation
    }
}

// Represent `@SuppressWarnings` annotations with `deprecation`
class SuppressDeprecationWarningAnnotation extends Annotation {
    SuppressDeprecationWarningAnnotation() {
        this.getType().hasQualifiedName("java.lang", "SuppressWarnings") and
        ((Literal)this.getAValue()).getLiteral().regexpMatch(".*deprecation.*")
    }
}

from Call call
where call.getCallee() instanceof DeprecatedMethod
    and not call.getCaller() instanceof DeprecatedMethod
    and not call.getCaller().getAnAnnotation() instanceof SuppressDeprecationWarningAnnotation
select call, "This call invokes a deprecated method."