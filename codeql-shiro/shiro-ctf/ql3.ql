import java

from Method method
where method.hasName("index") and method.fromSource()
select method , method.getDeclaringType()