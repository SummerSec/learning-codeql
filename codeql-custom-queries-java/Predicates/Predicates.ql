<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:2c4e643d0041695abcd4e45a6a837e28aaa6c9015d5788f9f35d416141328bb8
size 120
=======
import java

predicate isSmall(int i) {
    i in [1 .. 9]
}

from int x
where x = 2  and isSmall(x) //x = 10
select x 

>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
