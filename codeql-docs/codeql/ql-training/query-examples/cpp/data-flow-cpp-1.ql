<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:d2e2b1b502426ab8c24f6f858b66d025c8307aeb140ef894708c8f564511000d
size 276
=======
import cpp
import semmle.code.cpp.commons.Printf

from Call c, FormattingFunction ff, Expr format
where c.getTarget() = ff and
      format = c.getArgument(ff.getFormatParameterIndex()) and
      not format instanceof StringLiteral
select format, "Non-constant format string."
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
