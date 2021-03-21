import java

class GetenvSource extends MethodAccess {
    GetenvSource() {
        exists(Method m | m = this.getMethod() |
        m.hasName("getenv") and
        m.getDeclaringType() instanceof TypeSystem
        )
    }
}

