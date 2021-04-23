<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:1548be1fb656e249377739cab7956c80fe0363d468a7d317b13cb6f341df8d65
size 227
=======
import java

class GetenvSource extends MethodAccess {
    GetenvSource() {
        exists(Method m | m = this.getMethod() |
        m.hasName("getenv") and
        m.getDeclaringType() instanceof TypeSystem
        )
    }
}

>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
