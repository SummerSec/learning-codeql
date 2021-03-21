import java

from GenericInterface map, ParameterizedType pt
where map.hasQualifiedName("java.util", "Map") and
    pt.getSourceDeclaration() = map
select pt