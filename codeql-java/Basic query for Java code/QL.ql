<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:167b3b666f5928ee30a5d7a72ba241ffb2f58f2c8e078159cb37315c3299ea03
size 194
=======
import java

from IfStmt ifstmt, Block block
where ifstmt.getThen() = block and
    block.getNumStmt() = 0 and
    not exists(ifstmt.getElse())
select ifstmt, "This 'if' statement is redundant."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
