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

// select 1.(OneTwoThree).getAString()
from int x
where x = 1 and x.(OneTwoThree).isEven()
select x.(OneTwoThree).getAString(), x
