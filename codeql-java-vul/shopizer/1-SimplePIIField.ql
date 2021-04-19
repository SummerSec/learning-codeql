/**
 *@name SimplePIIField
 */

import java

from Field f
where 
    (f.getName().matches("%email%") or
    f.getName().matches("%phone%") or
    f.getName().matches("creditCard%")) and
    f.fromSource()
select f
