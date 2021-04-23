<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:649568a59e820228aa19455b4c5902fc34e63f006c9f99d85f4c19615528367f
size 152
=======
import cpp  
   
from IfStmt ifstmt, Block block
where
  block = ifstmt.getThen() and
  block.isEmpty()
select ifstmt, "This if-statement is redundant."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
