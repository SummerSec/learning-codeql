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