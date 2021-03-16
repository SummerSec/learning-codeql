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