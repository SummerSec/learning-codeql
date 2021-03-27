import java

from Callable c, ParamTag pt
where c.getDoc().getJavadoc() = pt.getParent() and
    not c.getAParameter().hasName(pt.getParamName())
select pt, "Spurious @param tag." 