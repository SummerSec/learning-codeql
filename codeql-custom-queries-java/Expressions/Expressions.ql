<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:4ad23ac46d4178b09f55f3eb05ff6004c3e13d6444828c94336604c045706d5a
size 371
=======
class A extends int {
    A() { this = 1 }
    int getANumber() { result = 2 }
}

class B extends int {
    B() { this = 1 }
    int getANumber() { result = 3 }
}

class C extends A, B {
  // Need to define `int getANumber()`; otherwise it would be ambiguous
    override int getANumber() {
        result = B.super.getANumber()
    }
}

from C c
select c, c.getANumber()
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
