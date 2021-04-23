<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:979420acc4622b27ae3efabba95d8b0b9337bacba5697ba69f458f7c734addab
size 792
=======
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
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
