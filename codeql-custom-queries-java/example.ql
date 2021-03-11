/**
 * @name Empty block
 * @kind problem
 * @problem.severity warning
 * @id java/example/empty-block
 */

import java

int getProduct(int x, int y) {
    x = 1 and
    y in [0 .. 2] and
    result = x * y
}

class MultipleOfThree extends int {
    MultipleOfThree() { this = getProduct(_, _) }
}