# Variables[¶](https://codeql.github.com/docs/ql-language-reference/variables/#variables)变量

Variables in QL are used in a similar way to variables in algebra or logic. They represent sets of values, and those values are usually restricted by a formula.

> 在QL中，变量的使用方式与代数或逻辑中的变量类似。它们代表一组值，这些值通常受公式限制。

This is different from variables in some other programming languages, where variables represent memory locations that may contain data. That data can also change over time. For example, in QL, `n = n + 1` is an equality [formula](https://codeql.github.com/docs/ql-language-reference/formulas/#formulas) that holds only if `n` is equal to `n + 1` (so in fact it does not hold for any numeric value). In Java, `n = n + 1` is not an equality, but an assignment that changes the value of `n` by adding `1` to the current value.

> 这与其他一些编程语言中的变量不同，在其他语言中，变量代表可能包含数据的内存位置。这些数据也可以随着时间的推移而改变。例如，在QL中，n = n + 1是一个平等公式，只有当n等于n + 1时才成立（所以事实上它对任何数值都不成立）。在Java中，n = n + 1不是一个等式，而是一个赋值，通过在当前值上加1来改变n的值。



## Declaring a variable[¶](https://codeql.github.com/docs/ql-language-reference/variables/#declaring-a-variable)变量声明

All variable declarations consist of a [type](https://codeql.github.com/docs/ql-language-reference/types/#types) and a name for the variable. The name can be any [identifier](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#identifiers) that starts with an uppercase or lowercase letter.

> 所有的变量声明都由变量的类型和名称组成，名称可以是任何大写或小写字母开头的标识符。名称可以是任何以大写或小写字母开头的标识符。

For example, `int i`, `SsaDefinitionNode node`, and `LocalScopeVariable lsv` declare variables `i`, `node`, and `lsv` with types `int`, `SsaDefinitionNode`, and `LocalScopeVariable` respectively.

> 例如，int i、SsaDefinitionNode node和LocalScopeVariable lsv分别声明类型为int、SsaDefinitionNode和LocalScopeVariable的变量i、node和lsv。

Variable declarations appear in different contexts, for example in a [select clause](https://codeql.github.com/docs/ql-language-reference/queries/#select-clauses), inside a [quantified formula](https://codeql.github.com/docs/ql-language-reference/formulas/#quantified-formulas), as an argument of a [predicate](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates), and many more.

> 变量声明出现在不同的上下文中，例如在选择子句中，在量化公式中，作为谓词的一个参数，等等。

Conceptually, you can think of a variable as holding all the values that its type allows, subject to any further constraints.

> 从概念上讲，你可以把一个变量看作是持有其类型所允许的所有值，并受到任何进一步的约束。

For example, consider the following select clause:

```
from int i
where i in [0 .. 9]
select i
```

Just based on its type, the variable `i` could contain all integers. However, it is constrained by the formula `i in [0 .. 9]`. Consequently, the result of the select clause is the ten numbers between `0` and `9` inclusive.

> 仅仅根据其类型，变量i可以包含所有的整数。然而，它受到公式i在[0 ... 9]中的限制。因此，选择子句的结果是0到9（含）之间的十个数字。

As an aside, note that the following query leads to a compile-time error:

```
from int i
select i
```

In theory, it would have infinitely many results, as the variable `i` is not constrained to a finite number of possible values. For more informaion, see “[Binding](https://codeql.github.com/docs/ql-language-reference/evaluation-of-ql-programs/#binding).”

> 理论上，它将会有无限多的结果，因为变量i不受限于有限的可能值。更多信息，请参见 "绑定"。

----



## Free and bound variables[¶](https://codeql.github.com/docs/ql-language-reference/variables/#free-and-bound-variables)自由变量和约束变量



Variables can have different roles. Some variables are **free**, and their values directly affect the value of an [expression](https://codeql.github.com/docs/ql-language-reference/expressions/#expressions) that uses them, or whether a [formula](https://codeql.github.com/docs/ql-language-reference/formulas/#formulas) that uses them holds or not. Other variables, called **bound** variables, are restricted to specific sets of values.

> 变量可以有不同的作用。有些变量是自由的，它们的值直接影响使用它们的表达式的值，或者使用它们的公式是否成立。另一些变量，称为约束变量，被限制在特定的值集合中。

It might be easiest to understand this distinction in an example. Take a look at the following expressions:

> 在一个例子中可能最容易理解这种区别。来看看下面的表达式:

```
"hello".indexOf("l")

min(float f | f in [-3 .. 3])

(i + 7) * 3

x.sqrt()
```

The first expression doesn’t have any variables. It finds the (zero-based) indices of where `"l"` occurs in the string `"hello"`, so it evaluates to `2` and `3`.

> 第一个表达式没有任何变量。它找到了字符串 "hello "中 "l "出现的位置的（基于零的）指数，所以它的值是2和3。

The second expression evaluates to `-3`, the minimum value in the range `[-3 .. 3]`. Although this expression uses a variable `f`, it is just a placeholder or “dummy” variable, and you can’t assign any values to it. You could replace `f` with a different variable without changing the meaning of the expression. For example, `min(float f | f in [-3 .. 3])` is always equal to `min(float other | other in [-3 .. 3])`. This is an example of a **bound variable**.

> 第二个表达式的值是-3，即[-3 ... 3]范围内的最小值。虽然这个表达式使用了一个变量 f，但它只是一个占位符或 "虚 "变量，你不能给它分配任何值。你可以在不改变表达式含义的情况下，用不同的变量替换f。例如，min(float f | f in [-3 ... 3])总是等于min(float other | other in [-3 ... 3])。这就是一个约束变量的例子。

What about the expressions `(i + 7) * 3` and `x.sqrt()`? In these two cases, the values of the expressions depend on what values are assigned to the variables `i` and `x` respectively. In other words, the value of the variable has an impact on the value of the expression. These are examples of **free variables**.

> 那么表达式(i + 7) * 3和x.sqrt()呢？在这两种情况下，表达式的值取决于分别分配给变量i和x的值。换句话说，变量的值对表达式的值有影响。这些都是自由变量的例子。

Similarly, if a formula contains free variables, then the formula can hold or not hold depending on the values assigned to those variables [[1\]](https://codeql.github.com/docs/ql-language-reference/variables/#id3). For example:

> 同样，如果一个公式中包含自由变量，那么这个公式可以成立或不成立，取决于分配给这些变量的值[1]。例如：

```
"hello".indexOf("l") = 1

min(float f | f in [-3 .. 3]) = -3

(i + 7) * 3 instanceof int

exists(float y | x.sqrt() = y)
```

The first formula doesn’t contain any variables, and it never holds (since `"hello".indexOf("l")` has values `2` and `3`, never `1`).

> 存在(float y | x.sqrt() = y)
> 第一个公式不包含任何变量，而且它永远不会成立（因为 "hello".indexOf("l")的值是2和3，而不是1）。

The second formula only contains a bound variable, so is unaffected by changes to that variable. Since `min(float f | f in [-3 .. 3])` is equal to `-3`, this formula always holds.

> 第二个公式只包含一个约束变量，所以不受该变量变化的影响。由于min(float f | f in [-3 ... 3])等于-3，所以这个公式总是成立。

The third formula contains a free variable `i`. Whether or not the formula holds, depends on what values are assigned to `i`. For example, if `i` is assigned `1` or `2` (or any other `int`) then the formula holds. On the other hand, if `i` is assigned `3.5`, then it doesn’t hold.

> 第三个公式包含一个自由变量i。公式是否成立，取决于分配给i的值。例如，如果i被分配给1或2（或任何其他int），那么公式成立。另一方面，如果给i赋值为3.5，那么公式就不成立。

The last formula contains a free variable `x` and a bound variable `y`. If `x` is assigned a non-negative number, then the final formula holds. On the other hand, if `x` is assigned `-9` for example, then the formula doesn’t hold. The variable `y` doesn’t affect whether the formula holds or not.

> 最后一个公式包含一个自由变量x和一个约束变量y，如果x被赋值为非负数，那么最后的公式成立。另一方面，比如x被赋值为-9，那么这个公式就不成立。变量y并不影响公式是否成立。

For more information about how assignments to free variables are computed, see “[evaluation of QL programs](https://codeql.github.com/docs/ql-language-reference/evaluation-of-ql-programs/#evaluation-of-ql-programs).”

> 关于如何计算对自由变量的赋值的更多信息，请参阅 "QL程序的评估"。

Footnotes

> 脚注

| [[1\]](https://codeql.github.com/docs/ql-language-reference/variables/#id2) | This is a slight simplification. There are some formulas that are always true or always false, regardless of the assignments to their free variables. However, you won’t usually use these when you’re writing QL. For example, and `a = a` is always true (known as a [tautology](https://en.wikipedia.org/wiki/Tautology_(logic))), and `x and not x` is always false. |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [1]                                                          | 这是一种轻微的简化。有一些公式总是真或假，不管它们的自由变量的赋值如何。然而，你在编写QL时通常不会使用这些公式。例如，and a = a总是真（称为同义词），x而不是x总是假。 |