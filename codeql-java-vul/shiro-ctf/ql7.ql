<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:8ee3fbad693437dd21ce4fa521d9839f8996915288c0ba7bd21d30c461e1ac65
size 370
=======
import java



class Deserialize extends RefType{
    Deserialize(){
        this.hasQualifiedName("com.summersec.shiroctf.Tools", "Tools")
    }
}

class DeserializeTobytes extends Method{
    DeserializeTobytes(){
        this.getDeclaringType() instanceof Deserialize
        and
        this.hasName("deserialize")
    }

}




from DeserializeTobytes des
select des
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
