import java

from TopLevelType tl
where tl.getName() != tl.getCompilationUnit().getName()
select tl