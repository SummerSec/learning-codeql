import java

int getSuccessor(int i) {
    result = i + 1 and // i=3
    i in [1 .. 9] // i=2
}

from int x
where x = 10 
select getSuccessor(x) //x =3
