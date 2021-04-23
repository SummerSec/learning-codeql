import java

predicate isDes(Expr arg){
    exists(MethodAccess des |
    des.getMethod().hasName("deserialize") 
    and
    arg = des.getArgument(0))

}

from Expr arg
where isDes(arg)
select arg