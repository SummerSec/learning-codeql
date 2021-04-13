import java

from MethodAccess des,Expr arg
where des.getMethod().getName() = "deserialize"
and
    arg = des.getArgument(0)
select arg