/**
 *@name SimplePIIClass
 */

import java
import semmle.code.java.dataflow.DataFlow

class SenInfoField extends Field{
    SenInfoField(){
        (this.getName().matches("%email%") or
        this.getName().matches("%phone%") or
        this.getName().matches("creditCard%")) and
        this.fromSource()
    }
}

from SenInfoField sif,DataFlow::Node source
// where any(sif).getAnAccess()
// select any(sif).getAnAccess()
where source.asExpr() = any(sif).getAnAccess()
select sif.getAnAccess()
