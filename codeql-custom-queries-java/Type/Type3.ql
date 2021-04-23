class OneTwo extends OneTwoThree {
    OneTwo() {
    this = 1 or this = 2
    }

    override string getAString() {
        result = "One or two: " + this.toString()
    }
}
class OneTwoThree extends int {
    OneTwoThree() {
    // characteristic predicate
        this = 1 or this = 2 or this = 3 or this = 4
    }

    string getAString() {
    // member predicate
        result = "One, two or three: " + this.toString()
    }

    predicate isEven() {
    // member predicate
        this = 1
    }
    
}
class TwoThree extends OneTwoThree {
    TwoThree() {
        this = 2 or this = 3
    }

    override string getAString() {
        result = "Two or three: " + this.toString()
    }
}

from OneTwoThree x
select x, x.getAString()