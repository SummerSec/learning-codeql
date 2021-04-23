<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:312d74b2d14d8ec84e12f47804b203d53b9106167d72ada9b370099c9767b013
size 1510
=======
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
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
