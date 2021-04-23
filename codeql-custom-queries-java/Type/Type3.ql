<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:1562de47411e7bd99dfb6d27ccd4a15eb259f50b0a36935b7e555101cf55a6c1
size 741
=======
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
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
