query int getProduct(int x, int y) {
    x = 4 and
    y in [0 .. 3] and
    result = x * y
  }

class MultipleOfThree extends int {
    MultipleOfThree() { this = getProduct(_, _) }
}