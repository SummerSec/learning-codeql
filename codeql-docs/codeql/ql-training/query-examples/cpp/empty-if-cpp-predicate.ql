<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:8f1fda0f62aa41675310614897fe9ddbd3e7be51125450645982b6acee48a692
size 165
=======
import cpp

predicate isEmpty(Block block) {
  block.isEmpty()
}

from IfStmt ifstmt
where isEmpty(ifstmt.getThen())
select ifstmt, "This if-statement is redundant."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
