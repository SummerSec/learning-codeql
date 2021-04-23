<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:a433659d5c8e3603e25b0f207dd1de75166b9a8366d6a32cdcdebf1520951c13
size 365
=======
class OneTwoThree extends int {
    OneTwoThree() {
        this = 1 or this = 2 or this = 3
    }
}
module M {
    class OneTwo extends OneTwoThree {
        OneTwo() {
            this = 1
            or this = 2
        }
            string getAString() {
        // member predicate
            result = "One, two or three: " + this.toString()
        }
    }
}
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
