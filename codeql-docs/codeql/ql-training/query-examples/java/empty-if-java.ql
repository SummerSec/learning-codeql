<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:0686c68f742479cc61e946df7cc77182b65a92d2c4fe1a3f8b181941e66d8c46
size 155
=======
import java

from IfStmt ifstmt, Block block
where
  block = ifstmt.getThen() and
  block.getNumStmt() = 0
select ifstmt, "This if-statement is redundant."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
