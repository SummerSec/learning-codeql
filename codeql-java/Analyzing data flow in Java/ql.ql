import java

from Constructor fileReader, Call call
where
    fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
    call.getCallee() = fileReader
select call.getArgument(0)