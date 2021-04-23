predicate isSmall(int i) {
    i in [1 .. 9]
}

predicate lessThanTen = isSmall/1;

from int i
where lessThanTen(i)
select i