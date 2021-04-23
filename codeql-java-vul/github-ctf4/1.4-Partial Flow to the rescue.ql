/**
 *@name Partial Flow to the rescue
 *@kind path-problem
 *@derscription 
 */

import java
import semmle.code.java.dataflow.TaintTracking
// import DataFlow::PathGraph
import DataFlow::PartialPathGraph

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

    override int explorationLimit(){
        result = 10
    }

}

from MyTraintTrackConfig config, DataFlow::PartialPathNode source, DataFlow::PartialPathNode sink
where 
    config.hasPartialFlow(source, sink, _) and
    source.getNode().asParameter().getName() = "container"
select sink, source, sink, "Partial flow from unsanitized user data"

predicate partial_flow(DataFlow::PartialPathNode n, DataFlow::Node src, int dist) {
    exists(MyTraintTrackConfig conf, DataFlow::PartialPathNode source |
    conf.hasPartialFlow(source, n, dist) and
    src = source.getNode() and
    source.getNode().asParameter().getName() = "container"
    )
}