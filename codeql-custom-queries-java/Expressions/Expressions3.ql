import java

from Type t
where t.(Class).getASupertype().hasName("List")
select t