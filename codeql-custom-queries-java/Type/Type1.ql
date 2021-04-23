<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:00106703bd05a61751e957ea902f83768954b27ed697c439a9bfa70fdef5959b
size 309
=======
class SmallInt extends int {
    SmallInt() { this = [1 .. 10] }
}

class DivisibleInt extends SmallInt {
    SmallInt divisor; // declaration of the field `divisor`

    DivisibleInt() { this % divisor = 0  }

    SmallInt getADivisor() { result = divisor }
}

from DivisibleInt i 
select i, i.getADivisor()
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
