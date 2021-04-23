<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:2983dfd4918453ecb385c13b809f2057b2ca10628d30cd89d1f8d5b906e47b2b
size 252
=======
import java
/* 找到实例化User的类 */
class MyUser extends RefType{
    MyUser(){
        this.hasQualifiedName("com.summersec.shiroctf.bean", "User")
    }
}



from ClassInstanceExpr clie
where 
    clie.getType() instanceof MyUser
select clie
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
