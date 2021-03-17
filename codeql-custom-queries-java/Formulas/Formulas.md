# Formulas[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#formulas)公式

Formulas define logical relations between the free variables used in expressions.

> 公式定义了表达式中使用的自由变量之间的逻辑关系。

Depending on the values assigned to those [free variables](https://codeql.github.com/docs/ql-language-reference/variables/#free-variables), a formula can be true or false. When a formula is true, we often say that the formula *holds*. For example, the formula `x = 4 + 5` holds if the value `9` is assigned to `x`, but it doesn’t hold for other assignments to `x`. Some formulas don’t have any free variables. For example `1 < 2` always holds, and `1 > 2` never holds.

> 根据分配给这些自由变量的值，一个公式可以是真或假。当一个公式为真时，我们经常说这个公式成立。例如，如果给x分配了数值9，则公式x = 4 + 5成立，但对于x的其他分配则不成立。例如，1 < 2 总是成立，而 1 > 2 从不成立。

You usually use formulas in the bodies of classes, predicates, and select clauses to constrain the set of values that they refer to. For example, you can define a class containing all integers `i` for which the formula `i in [0 .. 9]` holds.

> 你通常在类、谓词和选择子句的主体中使用公式来限制它们所引用的值集。例如，您可以定义一个包含所有整数 i 的类，其中公式 i 在 [0 ... 9] 中成立。

The following sections describe the kinds of formulas that are available in QL.

> 下面的章节描述了QL中可用的公式的种类。

## Comparisons[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#comparisons)比较



A comparison formula is of the form:

> 比较公式的形式是

```
<expression> <operator> <expression>
```

See the tables below for an overview of the available comparison operators.

> 请看下面的表格，了解可用的比较运算符的概况。

### Order运算符

To compare two expressions using one of these order operators, each expression must have a type and those types must be [compatible](https://codeql.github.com/docs/ql-language-reference/types/#type-compatibility) and [orderable](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#ordering).

> 要使用这些顺序运算符中的一个来比较两个表达式，每个表达式必须有一个类型，而且这些类型必须是兼容和可排序的。

| Name                     | Symbol |
| :----------------------- | :----- |
| Greater than             | `>`    |
| Greater than or equal to | `>=`   |
| Less than                | `<`    |
| Less than or equal to    | `<=`   |

For example, the formulas `"Ann" < "Anne"` and `5 + 6 >= 11` both hold.

> 例如，公式 "Ann"<"Anne "和5+6>=11都成立。

### Equality[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#equality)平等



To compare two expressions using `=`, at least one of the expressions must have a type. If both expressions have a type, then their types must be [compatible](https://codeql.github.com/docs/ql-language-reference/types/#type-compatibility).

> 要使用=比较两个表达式，至少其中一个表达式必须有一个类型。如果两个表达式都有一个类型，那么它们的类型必须是兼容的。

To compare two expressions using `!=`, both expressions must have a type. Those types must also be [compatible](https://codeql.github.com/docs/ql-language-reference/types/#type-compatibility).

> 要使用 != 比较两个表达式，两个表达式必须有一个类型。这些类型也必须是兼容的。

| Name         | Symbol |
| :----------- | :----- |
| Equal to     | `=`    |
| Not equal to | `!=`   |

For example, `x.sqrt() = 2` holds if `x` is `4`, and `4 != 5` always holds.

> 例如，如果 x 是 4，x.sqrt() = 2 成立，而 4 !=5 总是成立。

For expressions `A` and `B`, the formula `A = B` holds if there is a pair of values—one from `A` and one from `B`—that are the same. In other words, `A` and `B` have at least one value in common. For example, `[1 .. 2] = [2 .. 5]` holds, since both expressions have the value `2`.

> 对于表达式 A 和 B，如果有一对值--一个来自 A，一个来自 B--相同，则公式 A = B 成立。换句话说，A和B至少有一个共同的值。例如，[1 ... 2]=[2 ... 5]成立，因为两个表达式的值都是2。

As a consequence, `A != B` has a very different meaning to the [negation](https://codeql.github.com/docs/ql-language-reference/formulas/#negation) `not A = B` [[1\]](https://codeql.github.com/docs/ql-language-reference/formulas/#id10):

> 因此，A !=B与否定式not A = B [1]的意义截然不同: 

* `A != B` holds if there is a pair of values (one from `A` and one from `B`) that are different.

    > 如果有一对不同的值(一个来自A, 一个来自B), 则A != B成立.

* `not A = B` holds if it is *not* the case that there is a pair of values that are the same. In other words, `A` and `B` have no values in common.

    > 如果不是存在一对数值相同的情况，则not A = B成立。换句话说，A和B没有共同的值。

**Examples**

1. * If both expressions have a single value (for example `1` and `0`), then comparison is straightforward:

        > 如果两个表达式都只有一个值（例如1和0），那么比较就很直接:

        `1 != 0` holds.`1 = 0` doesn’t hold.`not 1 = 0` holds.

2. * Now compare `1` and `[1 .. 2]`:

        `1 != [1 .. 2]` holds, because `1 != 2`.`1 = [1 .. 2]` holds, because `1 = 1`.`not 1 = [1 .. 2]` doesn’t hold, because there is a common value (`1`).

3. * Compare `1` and `none()` (the “empty set”):

        `1 != none()` doesn’t hold, because there are no values in `none()`, so no values that are not equal to `1`.`1 = none()` also doesn’t hold, because there are no values in `none()`, so no values that are equal to `1`.`not 1 = none()` holds, because there are no common values.



## Type checks[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#type-checks)类型检查

A type check is a formula that looks like:

> 范围检查是一个公式就像:

```
<expression> instanceof <type>
```

You can use a type check formula to check whether an expression has a certain type. For example, `x instanceof Person` holds if the variable `x` has type `Person`.

> 你可以使用类型检查公式来检查一个表达式是否具有某种类型。例如，如果变量x的类型为Person，则x instanceof Person成立。

## Range checks[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#range-checks)范围检查



A range check is a formula that looks like:

> 范围检查是一个公式就像:

```
<expression> in <range>
```

You can use a range check formula to check whether a numeric expression is in a given [range](https://codeql.github.com/docs/ql-language-reference/expressions/#ranges). For example, `x in [2.1 .. 10.5]` holds if the variable `x` is between the values `2.1` and `10.5` (including `2.1` and `10.5` themselves).

> 你可以使用范围检查公式来检查一个数字表达式是否在给定的范围内。例如，x在[2.1 ... 10.5]中，如果变量x在值2.1和10.5之间（包括2.1和10.5本身），则该变量成立。

Note that `<expression> in <range>` is equivalent to `<expression> = <range>`. Both formulas check whether the set of values denoted by `<expression>` is the same as the set of values denoted by `<range>`.

> 注意，<range>中的<expression>相当于<expression>=<range>。两个公式都检查<expression>表示的值集是否与<range>表示的值集相同。



## Calls to predicates[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#calls-to-predicates)调用谓词

A call is a formula or [expression](https://codeql.github.com/docs/ql-language-reference/expressions/#expressions) that consists of a reference to a predicate and a number of arguments.

> 调用是一个公式或表达式，它由对谓词的引用和一些参数组成。

For example, `isThree(x)` might be a call to a predicate that holds if the argument `x` is `3`, and `x.isEven()` might be a call to a member predicate that holds if `x` is even.

> 例如，isThree(x)可能是对一个谓词的调用，如果参数x是3，这个谓词就成立；x.isEven()可能是对一个成员谓词的调用，如果x是偶数，这个谓词就成立。

A call to a predicate can also contain a closure operator, namely `*` or `+`. For example, `a.isChildOf+(b)` is a call to the [transitive closure](https://codeql.github.com/docs/ql-language-reference/recursion/#transitive-closures) of `isChildOf()`, so it holds if `a` is a descendent of `b`.

> 对谓词的调用也可以包含一个闭合操作符，即 * 或 +。例如，a.isChildOf+(b)是对isChildOf()的转义闭包的调用，所以如果a是b的后裔，它就成立。

The predicate reference must resolve to exactly one predicate. For more information about how a predicate reference is resolved, see “[Name resolution](https://codeql.github.com/docs/ql-language-reference/name-resolution/#name-resolution).”

> 谓词引用必须精确地解析到一个谓词。有关如何解析谓词引用的更多信息，请参阅 "名称解析"。

If the call resolves to a predicate without result, then the call is a formula.

> 如果调用解析到一个没有结果的谓词，那么这个调用就是一个公式。

It is also possible to call a predicate with result. This kind of call is an expression in QL, instead of a formula. For more information, see “[Calls to predicates (with result)](https://codeql.github.com/docs/ql-language-reference/expressions/#calls-with-result).”

> 也可以调用一个有结果的谓词。这种调用是QL中的表达式，而不是公式。更多信息，请参阅 "对谓词的调用（带结果）"。



## Parenthesized formulas[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#parenthesized-formulas)括号公式

A parenthesized formula is any formula surrounded by parentheses, `(` and `)`. This formula has exactly the same meaning as the enclosed formula. The parentheses often help to improve readability and group certain formulas together.

> 括号公式是指任何用括号、（和）包围的公式。这个公式与被包围的公式具有完全相同的含义。小括号通常有助于提高可读性，并将某些公式组合在一起。



## Quantified formulas[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#quantified-formulas)量化公式

A quantified formula introduces temporary variables and uses them in formulas in its body. This is a way to create new formulas from existing ones.

> 量化公式引入了临时变量，并在其主体的公式中使用它们。这是一种从现有公式创建新公式的方法。



### Explicit quantifiers[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#explicit-quantifiers)显示量词

The following explicit “quantifiers” are the same as the usual existential and universal quantifiers in mathematical logic.

> 以下明确的 "量词 "与数理逻辑中常用的存在量词和普遍量词相同。

#### `exists`



This quantifier has the following syntax:

> 此量词具有以下语法：

```
exists(<variable declarations> | <formula>)
```

You can also write `exists(<variable declarations> | <formula 1> | <formula 2>)`. This is equivalent to `exists(<variable declarations> | <formula 1> and <formula 2>)`.

> 你也可以写 exist(<变量声明> | <公式1> | <公式2>)。这相当于 exists(<变量声明> | <公式1> 和 <公式2>)。

This quantified formula introduces some new variables. It holds if there is at least one set of values that the variables could take to make the formula in the body true.

> 这个量化公式引入了一些新的变量。如果至少有一组变量的值可以使正文中的公式为真，它就成立。

For example, `exists(int i | i instanceof OneTwoThree)` introduces a temporary variable of type `int` and holds if any value of that variable has type `OneTwoThree`.

> 例如，exists(int i | i instanceof OneTwoThree)引入了一个类型为int的临时变量，如果该变量的任何值具有OneTwoThree类型，则该变量成立。

#### `forall`

This quantifier has the following syntax:

> 此量词具有以下语法：

```
forall(<variable declarations> | <formula 1> | <formula 2>)
```

`forall` introduces some new variables, and typically has two formulas in its body. It holds if `<formula 2>` holds for all values that `<formula 1>` holds for.

> forall 引入了一些新的变量，通常在它的正文中有两个公式。如果<公式2>对<公式1>的所有值都成立，那么它就成立。

For example, `forall(int i | i instanceof OneTwoThree | i < 5)` holds if all integers that are in the class `OneTwoThree` are also less than `5`. In other words, if there is a value in `OneTwoThree` that is greater than or equal to `5`, then the formula doesn’t hold.

> 例如，forall(int i | i instanceof OneTwoThree | i < 5) 如果所有在 OneTwoThree 类中的整数也小于 5，则 forall(int i | i instanceof OneTwoThree | i < 5) 成立。换句话说，如果 OneTwoThree 中有一个值大于或等于 5，那么这个公式就不成立。

Note that `forall(<vars> | <formula 1> | <formula 2>)` is logically the same as `not exists(<vars> | <formula 1> | not <formula 2>)`.

> 请注意，forall(<vars> | <公式1> | <公式2>)在逻辑上与不存在(<vars> | <公式1> | 不<公式2>)是一样的。

#### `forex`

This quantifier has the following syntax:

> 此量词具有以下语法：

```
forex(<variable declarations> | <formula 1> | <formula 2>)
```

This quantifier exists as a shorthand for:

> 这个量化符是作为以下函数的简写而存在:

```
forall(<vars> | <formula 1> | <formula 2>) and
exists(<vars> | <formula 1> | <formula 2>)
```

In other words, `forex` works in a similar way to `forall`, except that it ensures that there is at least one value for which `<formula 1>` holds. To see why this is useful, note that the `forall` quantifier could hold trivially. For example, `forall(int i | i = 1 and i = 2 | i = 3)` holds: there are no integers `i` which are equal to both `1` and `2`, so the second part of the body `(i = 3)` holds for every integer for which the first part holds.

> 换句话说，forex的工作方式与forall类似，只是它确保至少有一个值的<公式1>成立。要知道为什么这很有用，请注意forall量化符可以琐碎地保持。例如，forall(int i | i = 1 and i = 2 | i = 3)成立：没有整数i既等于1又等于2，所以主体的第二部分(i = 3)对第一部分成立的每个整数都成立。

Since this is often not the behavior that you want in a query, the `forex` quantifier is a useful shorthand.

> 由于这往往不是你在查询中想要的行为，所以外汇量化符是一个有用的速记符。



### Implicit quantifiers[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#implicit-quantifiers)隐式量词

Implicitly quantified variables can be introduced using “don’t care expressions.” These are used when you need to introduce a variable to use as an argument to a predicate call, but don’t care about its value. For further information, see “[Don’t-care expressions](https://codeql.github.com/docs/ql-language-reference/expressions/#don-t-care-expressions).”

> 可以使用 "不在乎表达式 "引入隐式量词的变量。当您需要引入一个变量作为谓词调用的参数，但不关心它的值时，就会使用这些变量。有关更多信息，请参阅 "不在乎表达式"。

## Logical connectives[¶](https://codeql.github.com/docs/ql-language-reference/formulas/#logical-connectives)逻辑连接词

You can use a number of logical connectives between formulas in QL. They allow you to combine existing formulas into longer, more complex ones.

> 在QL中，您可以在公式之间使用一些逻辑连接。它们允许您将现有的公式组合成更长、更复杂的公式。

To indicate which parts of the formula should take precedence, you can use parentheses. Otherwise, the order of precedence from highest to lowest is as follows:

> 为了指示公式的哪些部分应该优先，您可以使用括号。否则，从高到低的优先顺序如下:

1. Negation ([not](https://codeql.github.com/docs/ql-language-reference/formulas/#negation))
2. Conditional formula ([if … then … else](https://codeql.github.com/docs/ql-language-reference/formulas/#conditional))
3. Conjunction ([and](https://codeql.github.com/docs/ql-language-reference/formulas/#conjunction))
4. Disjunction ([or](https://codeql.github.com/docs/ql-language-reference/formulas/#disjunction))
5. Implication ([implies](https://codeql.github.com/docs/ql-language-reference/formulas/#implication))

For example, `A and B implies C or D` is equivalent to `(A and B) implies (C or D)`.

> 例如，A和B意味着C或D相当于（A and B）意味着（C or D）。

Similarly, `A and not if B then C else D` is equivalent to `A and (not (if B then C else D))`.

>   同理，A and not if B then C else D等同于A and (not (if B then C else D))。

Note that the [parentheses](https://codeql.github.com/docs/ql-language-reference/formulas/#parenthesized-formulas) in the above examples are not necessary, since they highlight the default precedence. You usually only add parentheses to override the default precedence, but you can also add them to make your code easier to read (even if they aren’t required).

> 请注意，上述例子中的括号不是必须的，因为它们突出了默认的优先级。您通常只添加括号来覆盖默认的优先级，但您也可以添加括号来使您的代码更容易阅读（即使它们不是必需的）。

The logical connectives in QL work similarly to Boolean connectives in other programming languages. Here is a brief overview:

> QL中的逻辑连接符的工作原理与其他编程语言中的布尔连接符类似。下面是一个简单的概述:



### `not`

You can use the keyword `not` before a formula. The resulting formula is called a negation.

`not A` holds exactly when `A` doesn’t hold.

> 你可以在公式前使用关键字not。由此产生的公式称为否定式。

**Example**

The following query selects files that are not HTML files.

> 下面的查询选择非HTML文件的文件。	

```
from File f
where not f.getFileType().isHtml()
select f
```

> Note
>
> You should be careful when using `not` in a recursive definition, as this could lead to non-monotonic recursion. For more information, “[Non-monotonic recursion](https://codeql.github.com/docs/ql-language-reference/recursion/#non-monotonic-recursion).”
>
> 在递归定义中使用not时应该小心，因为这可能导致非单调递归。更多信息，"非单调递归"。



### `if ... then ... else`

You can use these keywords to write a conditional formula. This is another way to simplify notation: `if A then B else C` is the same as writing `(A and B) or ((not A) and C)`.

>  你可以用这些关键字来写一个条件公式。这是另一种简化符号的方法：如果 A 那么 B else C 与写 (A and  B) or ((not A) and C) 是一样的。

**Example**

With the following definition, `visibility(c)` returns `"public"` if `x` is a public class and returns `"private"` otherwise:

> 通过下面的定义，如果x是一个公共类，则visibility(c)返回 "public"，否则返回 "private":

```
string visibility(Class c){
  if c.isPublic()
  then result = "public"
  else result = "private"
}
```



### `and`

You can use the keyword `and` between two formulas. The resulting formula is called a conjunction.

`A and B` holds if, and only if, both `A` and `B` hold.

> 你可以在两个公式之间使用关键字和。由此产生的公式称为连词。

**Example**

The following query selects files that have the `js` extension and contain fewer than 200 lines of code:

> 下面的查询选择了以js为扩展名且包含少于200行代码的文件:

```
from File f
where f.getExtension() = "js" and
  f.getNumberOfLinesOfCode() < 200
select f
```



### `or`

You can use the keyword `or` between two formulas. The resulting formula is called a disjunction.

> 可以在两个公式之间使用关键字或。由此产生的公式称为析取。

`A or B` holds if at least one of `A` or `B` holds.

> 如果 A 或 B 中至少有一个成立，则 A 或 B 成立。

**Example**

With the following definition, an integer is in the class `OneTwoThree` if it is equal to `1`, `2`, or `3`:

> 在下面的定义中，如果整数等于 1、2 或 3，则该整数属于 OneTwoThree 类：

```
class OneTwoThree extends int {
  OneTwoThree() {
    this = 1 or this = 2 or this = 3
  }
}
```



### `implies`

You can use the keyword `implies` between two formulas. The resulting formula is called an implication. This is just a simplified notation: `A implies B` is the same as writing `(not A) or B`.

> 你可以在两个公式之间使用关键字 implies。由此产生的公式称为内涵式。这只是一个简化的符号。A暗示B和写（不是A）或B是一样的。

**Example**

The following query selects any `SmallInt` that is odd, or a multiple of `4`.

> 下面的查询选择了任何一个奇数或4的倍数的SmallInt。

```
class SmallInt extends int {
  SmallInt() { this = [1 .. 10] }
}

from SmallInt x
where x % 2 = 0 implies x % 4 = 0
select x
```

![image-20210317181938737](https://gitee.com/samny/images/raw/master/38u19er38ec/38u19er38ec.png)

Footnotes

| [[1\]](https://codeql.github.com/docs/ql-language-reference/formulas/#id3) | The difference between `A != B` and `not A = B` is due to the underlying quantifiers. If you think of `A` and `B` as sets of values, then `A != B` means: |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [1]                                                          | A != B和不是A = B之间的区别是由于底层的量词。如果你把A和B看作是值的集合，那么A != B的意思是。 |

```
exists( a, b | a in A and b in B | a != b )
```

On the other hand, `not A = B` means:

> 另一方面，不存在A=B意味着:

```
not exists( a, b | a in A and b in B | a = b )
```

This is equivalent to `forall( a, b | a in A and b in B | a != b )`, which is very different from the first formula.

> 这相当于forall( a, b | a in A and b in B | a != b )，这与第一个公式有很大不同。