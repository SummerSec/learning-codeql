/**
 *@name Source
 *@derscription 
 */
import java
import semmle.code.java.dataflow.DataFlow

/*
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

predicate isSource(DataFlow::Node source) {
	exists(ConstraintValidatorIsValid isValidMethod |
		source.asParameter() = isValidMethod.getParameter(0)
	)
}

//There has to be a query in scope even when you use Quick Evaluation
select "Quick-eval isSource" 