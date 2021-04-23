<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:c02dcfd6a1fed1d586f05c0d59745f37975ff75f3e5053c6b48cb1eb6604b078
size 214
=======
/**
 *@name SimplePIIField
 */

import java

from Field f
where 
    (f.getName().matches("%email%") or
    f.getName().matches("%phone%") or
    f.getName().matches("creditCard%")) and
    f.fromSource()
select f
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
