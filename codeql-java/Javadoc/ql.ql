<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:74e2d97f2bdc6ff77ac64dde51031b048aaf933dc786216555cb31b8b2949d48
size 204
=======
import java

from Class c, Javadoc jdoc, string author, string version
where jdoc = c.getDoc().getJavadoc() and
    author = jdoc.getAuthor() and
    version = jdoc.getVersion()
select c, author, version 
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
