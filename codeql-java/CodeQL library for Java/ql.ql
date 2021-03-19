import java

from Variable v, PrimitiveType pt
where pt = v.getType() and
    pt.hasName("int")
select v