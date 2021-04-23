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