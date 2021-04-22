import java
import semmle.code.java.dataflow.DataFlow

// predicate isSource(DataFlow::Node source) {
//     exists(Method m |
//         m.getASourceOverriddenMethod().getQualifiedName().matches("ConstraintValidator.isValid") and
//         source.asParameter() = m.getParameter(0)
//     )
// }
predicate isSource(DataFlow::Node source) {
    exists(Method m |
        m.getASourceOverriddenMethod().getQualifiedName() = "ConstraintValidator.isValid"
        and
        source.asParameter() = m.getParameter(0)
    )
}

select "Quick-eval isSource" 