/**
 *@name Sink
 *@derscription
 */

import java
import semmle.code.java.dataflow.DataFlow

class TypeConstraintValidatorContext extends RefType {
    TypeConstraintValidatorContext() { 
        this.hasQualifiedName("javax.validation", "ConstraintValidatorContext") 
    }
}


predicate isBuildConstraintViolationWithTemplate(MethodAccess ma){
    ma.getMethod().hasName("buildConstraintViolationWithTemplate") 
    and
    ma.getMethod().getDeclaringType() instanceof TypeConstraintValidatorContext
}

predicate isSink(DataFlow::Node sink){
    exists(MethodAccess ma| 
        isBuildConstraintViolationWithTemplate(ma) 
        and 
        ma.getArgument(0) = sink.asExpr()
    )
}



select "Quick-eval isSink" 
