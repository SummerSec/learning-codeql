<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:b09fd986bf34f810b70d00b547b1895624d6deba36676bef9bf1372ad090f34d
size 214
=======
/**
 *@name Logger slf4j 记录器记录方法调用查询
 */

import java
import semmle.code.java.StringFormat

from LoggerFormatMethod lfm
select lfm.getAReference().getAnArgument()
// select lfm.getAReference()
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
