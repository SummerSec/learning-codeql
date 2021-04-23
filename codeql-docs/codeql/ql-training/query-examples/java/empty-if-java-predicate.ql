<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:6d6a69330da0d7375546883f5251cd7b38252f2d4fe44e4b66884fdf81fa9ea2
size 138
=======
import java

predicate isEmpty(Block block) {
  block.getNumStmt() = 0
}

from IfStmt ifstmt
where isEmpty(ifstmt.getThen())
select ifstmt
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
