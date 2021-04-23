<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:2aeb1591e74e000b941803bf05beca41853438407d84970c493d66bdb61a9e9a
size 239
=======
import java

class EmptyBlock extends Block {
  EmptyBlock() { this.getNumStmt() = 0 }
}

from IfStmt ifstmt
where
  ifstmt.getThen() instanceof EmptyBlock and
  not exists(ifstmt.getElse())
select ifstmt, "This if-statement is redundant."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
