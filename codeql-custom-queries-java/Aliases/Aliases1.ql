int getSuccessor(int i) {
    result = i + 1 and
    i in [1 .. 9]
}

predicate succ = getSuccessor/1;

from int i
select succ(i)