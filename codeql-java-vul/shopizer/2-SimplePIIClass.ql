<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:3e253b2b539a295d5a6394835f03dff0f7bf68d4661562817882ea5931c961fd
size 499
=======
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
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
