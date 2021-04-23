<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:7d5f8bf4940bc7c853c980e246ded68da1db6ba3983d508ad65c15907675c5e8
size 184
=======
query int getProduct(int x, int y) {
    x = 4 and
    y in [0 .. 3] and
    result = x * y
  }

class MultipleOfThree extends int {
    MultipleOfThree() { this = getProduct(_, _) }
}
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
