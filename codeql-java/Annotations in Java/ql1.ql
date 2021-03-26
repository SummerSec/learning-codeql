import java

from Annotation ann
where ann.getType().hasQualifiedName("java.lang", "Override")
select ann