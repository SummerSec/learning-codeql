<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:f996be1f5a4bf0fdb7f73248d122e19ee22b98680b9e22595c6403c21b3f5574
size 329
=======
import java

from Class c, Javadoc jdoc, JavadocTag authorTag, JavadocTag versionTag
where jdoc = c.getDoc().getJavadoc() and
    authorTag.getTagName() = "@author" and authorTag.getParent() = jdoc and
    versionTag.getTagName() = "@version" and versionTag.getParent() = jdoc
select c, authorTag.getText(), versionTag.getText() 
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
