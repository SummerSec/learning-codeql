<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:ce0e4365aefdbdacdea2b8bef3925919ae8dae96c0c7864565073ad89649350d
size 127
=======
class SmallInt extends int {
    SmallInt() { this = [1 .. 10] }
}

from SmallInt x
where  x % 2 = 0 implies x % 4 = 0
select x
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
