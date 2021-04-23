class SmallInt extends int {
    SmallInt() { this = [1 .. 10] }
}

from SmallInt x
where  x % 2 = 0 implies x % 4 = 0
select x