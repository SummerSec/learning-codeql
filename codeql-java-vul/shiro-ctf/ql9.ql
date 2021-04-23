<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:67f1dd8dead61fc5b44526d2cab747e18bff22da062bfb563cc452ab056e4148
size 442
=======
import java

class HttpServletRequest extends RefType{
    HttpServletRequest(){
        this.hasQualifiedName("javax.servlet.http", "HttpServletRequest")
    }
}

class HttpServletRequestToBytes extends Field{
    HttpServletRequestToBytes(){
        this.getDeclaringType() instanceof HttpServletRequest
        // and
        // this.hasName("request")
    }
}

from HttpServletRequestToBytes hsrtb
// where hsrtb.fromSource()
select hsrtb
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
