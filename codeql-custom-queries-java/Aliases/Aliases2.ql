<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:fea8da1c94525813da5feed32673a9ea00398ed48fc46b1166800e84d829b61d
size 124
=======
predicate isSmall(int i) {
    i in [1 .. 9]
}

predicate lessThanTen = isSmall/1;

from int i
where lessThanTen(i)
select i
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
