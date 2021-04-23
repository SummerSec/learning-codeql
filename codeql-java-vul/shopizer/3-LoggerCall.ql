/**
 *@name Logger slf4j 记录器记录方法调用查询
 */

import java
import semmle.code.java.StringFormat

from LoggerFormatMethod lfm
select lfm.getAReference().getAnArgument()
// select lfm.getAReference()