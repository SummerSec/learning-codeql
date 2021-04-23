/**
 *@name TaintTracking configuration
 *@kind path-problem
 *@derscription 
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/*
source
Map overrides of isValid method from ConstraintValidator
*/
class ConstraintValidator extends RefType {
	ConstraintValidator() {
		this.hasQualifiedName("javax.validation", "ConstraintValidator") 
	}
}

class ConstraintValidatorIsValid extends Method {
	ConstraintValidatorIsValid() {
		this.getName() = "isValid" and
		this.getDeclaringType().getASourceSupertype() instanceof ConstraintValidator
        and this.isOverridable()
        // this.getASourceOverriddenMethod().getDeclaringType() instanceof ConstraintValidator
        
	}
}

/*
sink 
 */
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

class MyTraintTrackConfig extends TaintTracking::Configuration{
    MyTraintTrackConfig(){
        this = "MyTraintTrackConfig"
    }

    override predicate isSource(DataFlow::Node source){
        exists(ConstraintValidatorIsValid isValidMethod |
		source.asParameter() = isValidMethod.getParameter(0)
	)
    }

    override predicate isSink(DataFlow::Node sink){
        exists(MethodAccess ma| 
        isBuildConstraintViolationWithTemplate(ma) 
        and 
        ma.getArgument(0) = sink.asExpr()
    )
    }

}

from MyTraintTrackConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink, "Custom constraint error message contains unsanitized user data"
