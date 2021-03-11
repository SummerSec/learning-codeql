/**
 * @name Empty block
 * @kind problem
 * @problem.severity warning
 * @id java/example/empty-block
 */

import java

predicate isSmall(int i) {
    i in [1 .. 9]
}

from int x
where x = 2 and isSmall(x)
select x