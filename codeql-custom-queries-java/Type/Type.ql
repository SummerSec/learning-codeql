<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:b14a8198b860f707ba6a521b70fd44c70add97ad640da2025682064a56e20684
size 439
=======
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
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
