<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:2a11e6eb642e5a37974e1521fafb53e25250029abbf5e6a2bcf358cb0f4bd1a5
size 384
=======
import java

string getANeighbor(string country) {
    country = "France" and result = "Belgium"
    or
    country = "France" and result = "Germany"
    or
    country = "Germany" and result = "Austria"
    or
    country = "Germany" and result = "Belgium"
    or
    country = "shahai" and  result = "beij"
    or
    country = getANeighbor(result)
}

select 
getANeighbor("beij") 
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
