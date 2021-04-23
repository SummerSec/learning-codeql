<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:f51496892cc5e1dbca93702546c69fa899ef928e4e8e7bebb562436b31088811
size 231
=======
import cpp

class EmptyBlock extends Block {
  EmptyBlock() { this.isEmpty() }
}

from IfStmt ifstmt
where
  ifstmt.getThen() instanceof EmptyBlock and
  not exists(ifstmt.getElse())
select ifstmt, "This if-statement is redundant."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
