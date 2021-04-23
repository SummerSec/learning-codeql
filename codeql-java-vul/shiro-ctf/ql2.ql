import java
/* 找到调用exeCmd方法 */
from MethodAccess exeCmd 
where exeCmd.getMethod().hasName("exeCmd") 
select exeCmd