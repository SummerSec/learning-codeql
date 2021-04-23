import java

predicate isSmall(int i) {
    i in [1 .. 9]
}

from int x
where x = 2  and isSmall(x) //x = 10
select x 

