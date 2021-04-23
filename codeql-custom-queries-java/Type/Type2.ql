<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:e40b7d11a0341b23f43e9461cb33a0cba75cb54af241bb14faba1562fb255bdd
size 544
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
        this = 1 or this = 2 or this = 3
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

from OneTwoThree o
select o, o.getAString()
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
