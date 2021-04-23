<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:e1d5c384e8273b69a594ac1f751a4aa309663d6eceee25c24dcc6448f43a33c7
size 215
=======
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
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
