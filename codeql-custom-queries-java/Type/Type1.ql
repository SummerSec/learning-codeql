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
