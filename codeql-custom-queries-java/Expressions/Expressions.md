# Expressions[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#expressions)表达式

An expression evaluates to a set of values and has a type.

> 表达式对一组值进行评估，并有一个类型。

For example, the expression `1 + 2` evaluates to the integer `3` and the expression `"QL"` evaluates to the string `"QL"`. `1 + 2` has [type](https://codeql.github.com/docs/ql-language-reference/types/#types) `int` and `"QL"` has type `string`.

> 例如，表达式1 + 2的值是整数3，表达式 "QL "的值是字符串 "QL"。1 + 2 的类型是 int，"QL "的类型是字符串。

The following sections describe the expressions that are available in QL.

> 下面的章节将描述QL中可用的表达式。

## Variable references[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#variable-references)变量引用

A variable reference is the name of a declared [variable](https://codeql.github.com/docs/ql-language-reference/variables/#variables). This kind of expression has the same type as the variable it refers to.

> 变量引用是一个声明变量的名称。这种表达式的类型与它所引用的变量的类型相同。

For example, if you have [declared](https://codeql.github.com/docs/ql-language-reference/variables/#variable-declarations) the variables `int i` and `LocalScopeVariable lsv`, then the expressions `i` and `lsv` have types `int` and `LocalScopeVariable` respectively.

> 例如，如果你声明了变量int i和LocalScopeVariable lsv，那么表达式i和lsv的类型分别为int和LocalScopeVariable。

You can also refer to the variables `this` and `result`. These are used in [predicate](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates) definitions and act in the same way as other variable references.

> 您还可以引用变量this和result。这些变量在谓词定义中使用，其作用与其他变量引用相同。



## Literals[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#literals)字符



You can express certain values directly in QL, such as numbers, booleans, and strings.

> 你可以直接在QL中表达某些值，如数字、布尔和字符串。

* [Boolean](https://codeql.github.com/docs/ql-language-reference/types/#boolean) literals: These are the values `true` and `false`.

* > 布尔值：真和假。

* [Integer](https://codeql.github.com/docs/ql-language-reference/types/#int) literals: These are sequences of decimal digits (`0` through `9`), possibly starting with a minus sign (`-`). For example:

* > 整数字面意义：这些是十进制数字（0到9）的序列，可能以减号（-）开始

    ```
    0
    42
    -2048
    ```

* [Float](https://codeql.github.com/docs/ql-language-reference/types/#float) literals: These are sequences of decimal digits separated by a dot (`.`), possibly starting with a minus sign (`-`). For example:

* > 浮点数。这些是由点（...）分隔的十进制数字序列，可能以减号（-）开头。例如：

    ```
    2.0
    123.456
    -100.5
    ```

* [String](https://codeql.github.com/docs/ql-language-reference/types/#string) literals: These are finite strings of 16-bit characters. You can define a string literal by enclosing characters in quotation marks (`"..."`). Most characters represent themselves, but there are a few characters that you need to “escape” with a backslash. The following are examples of string literals:

* > 字符串。这些是16位字符的有限字符串。你可以通过用引号("...")括起字符来定义一个字符串字面意义。大多数字符代表自己，但也有一些字符需要用反斜杠 "转义"。下面是字符串文字的例子:

    ```
    "hello"
    "They said, \"Please escape quotation marks!\""
    ```

    See [String literals](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#string-literals-string) in the QL language specification for more details.

    > 更多细节请参见QL语言规范中的字符串

    Note: there is no “date literal” in QL. Instead, to specify a [date](https://codeql.github.com/docs/ql-language-reference/types/#date), you should convert a string to the date that it represents using the `toDate()` predicate. For example, `"2016-04-03".toDate()` is the date April 3, 2016, and `"2000-01-01 00:00:01".toDate()` is the point in time one second after New Year 2000.

    > 注意：QL中没有 "日期文字"。相反，要指定一个日期，应该使用toDate()谓词将一个字符串转换为它所代表的日期。例如，"2016-04-03".toDate()是2016年4月3日的日期，"2000-01-01 00:00:01".toDate()是2000年新年后一秒钟的时间点。
  
    * The following string formats are recognized as dates:
    
    * > 以下的字符串格式可以识别为日期。
    
        **ISO dates**, such as `"2016-04-03 17:00:24"`. The seconds part is optional (assumed to be `"00"` if it’s missing), and the entire time part can also be missing (in which case it’s assumed to be `"00:00:00"`).**Short-hand ISO dates**, such as `"20160403"`.**UK-style dates**, such as `"03/04/2016"`.**Verbose dates**, such as `"03 April 2016"`.
        
        > ISO日期，如 "2016-04-03 17:00:24"。秒的部分是可选的（如果缺失，则假定为 "00"），整个时间部分也可以缺失（在这种情况下，假定为 "00:00:00"）。
        > 短手ISO日期，如 "20160403"。
        > 英国式日期，如 "03/04/2016"。
        > 啰嗦的日期，如 "03 April 2016"。

## Parenthesized expressions[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#parenthesized-expressions)括号表达式

A parenthesized expression is an expression surrounded by parentheses, `(` and `)`. This expression has exactly the same type and values as the original expression. Parentheses are useful for grouping expressions together to remove ambiguity and improve readability.

> 小括号表达式是指用括号,（和）包围的表达式。该表达式的类型和值与原始表达式完全相同。圆括号对于将表达式分组以消除歧义和提高可读性非常有用。

## Ranges[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#ranges)范围

A range expression denotes a range of values ordered between two expressions. It consists of two expressions separated by `..` and enclosed in brackets (`[` and `]`). For example, `[3 .. 7]` is a valid range expression. Its values are any integers between `3` and `7` (including `3` and `7` themselves).

> 范围表达式表示两个表达式之间排序的数值范围。它由两个表达式组成，用...隔开，并用括号（[和]）括起来。例如，[3 ... 7]是一个有效的范围表达式。它的值是3和7之间的任何整数（包括3和7本身）。

In a valid range, the start and end expression are integers, floats, or dates. If one of them is a date, then both must be dates. If one of them is an integer and the other a float, then both are treated as floats.

> 在一个有效的范围中，开始和结束表达式是整数、浮点数或日期。如果其中一个是日期，那么两个都必须是日期。如果其中一个是整数，另一个是浮点数，那么两者都被视为浮点数。

---



## Set literal expressions[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#set-literal-expressions)设置文本表达式

A set literal expression allows the explicit listing of a choice between several values. It consists of a comma-separated collection of expressions that are enclosed in brackets (`[` and `]`). For example, `[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]` is a valid set literal expression. Its values are the first ten prime numbers.

> set-literal 表达式允许明确地列出几个值之间的选择。它由一个逗号分隔的表达式集合组成，这些表达式用括号（[ 和 ]）括起来。例如，[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]是一个有效的集合文字表达式。它的值是前十个质数。

The values of the contained expressions need to be of [compatible types](https://codeql.github.com/docs/ql-language-reference/types/#type-compatibility) for a valid set literal expression. Furthermore, at least one of the set elements has to be of a type that is a supertype of the types of all the other contained expressions.

> 对于一个有效的set-literal 表达式来说，所包含的表达式的值必须是兼容类型。此外，至少有一个集合元素的类型必须是所有其他包含的表达式类型的超类型。

Set literals are supported from release 2.1.0 of the CodeQL CLI, and release 1.24 of LGTM Enterprise.

> 从CodeQL CLI的2.1.0版本和LGTM Enterprise的1.24版本开始，就支持集合文字表达式。



## Super expressions[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#super-expressions)超级表达式



Super expressions in QL are similar to super expressions in other programming languages, such as Java. You can use them in predicate calls, when you want to use the predicate definition from a supertype. In practice, this is useful when a predicate inherits two definitions from its supertypes. In that case, the predicate must [override](https://codeql.github.com/docs/ql-language-reference/types/#overriding-member-predicates) those definitions to avoid ambiguity. However, if you want to use the definition from a particular supertype instead of writing a new definition, you can use a super expression.

> QL中的超级表达式类似于其他编程语言中的超级表达式，例如Java。当你想使用来自超级类型的谓词定义时，你可以在谓词调用中使用它们。在实践中，当一个谓词从其超类型中继承了两个定义时，这很有用。在这种情况下，谓词必须覆盖这些定义以避免歧义。然而，如果你想使用来自特定超类型的定义，而不是编写一个新的定义，你可以使用超级表达式。

In the following example, the class `C` inherits two definitions of the predicate `getANumber()`—one from `A` and one from `B`. Instead of overriding both definitions, it uses the definition from `B`.

> 在下面的示例中，类C继承了谓词getANumber()的两个定义--一个来自于A，一个来自于B，它没有覆盖这两个定义，而是使用了B的定义。

```
class A extends int {
    A() { this = 1 }
    int getANumber() { result = 2 }
}

class B extends int {
    B() { this = 1 }
    int getANumber() { result = 3 }
}

class C extends A, B {
  // Need to define `int getANumber()`; otherwise it would be ambiguous
    override int getANumber() { // 最新版必须加override关键字
        result = B.super.getANumber()
    }
}

from C c
select c, c.getANumber()
```

![image-20210316195903686](https://gitee.com/samny/images/raw/master/3u59er3ec/3u59er3ec.png)





## Calls to predicates (with result)[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#calls-to-predicates-with-result)谓词调用(带结果)

Calls to [predicates with results](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates-with-result) are themselves expressions, unlike calls to [predicates without results](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates-without-result) which are formulas. For more information, see “[Calls to predicates](https://codeql.github.com/docs/ql-language-reference/formulas/#calls).”

> 对有结果的谓词的调用本身就是表达式，不像对没有结果的谓词的调用是公式。更多信息，请参见 "对谓词的调用"。

A call to a predicate with result evaluates to the values of the `result` variable of the called predicate.

> 对带结果的谓词的调用会评估到被调用的谓词的结果变量的值。

For example `a.getAChild()` is a call to a predicate `getAChild()` on a variable `a`. This call evaluates to the set of children of `a`.

> 例如，a.getAChild()是对变量a的谓词getAChild()的调用，该调用的值是a的子集。



## Aggregations[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#aggregations)聚合



An aggregation is a mapping that computes a result value from a set of input values that are specified by a formula.

> 聚合是一种映射，它从一组由公式指定的输入值中计算出一个结果值。

The general syntax is:

> 一般语法：

```
<aggregate>(<variable declarations> | <formula> | <expression>)
```

The variables [declared](https://codeql.github.com/docs/ql-language-reference/variables/#variable-declarations) in `<variable declarations>` are called the **aggregation variables**.

> 在<变量声明>中声明的变量称为聚合变量。

Ordered aggregates (namely `min`, `max`, `rank`, `concat`, and `strictconcat`) are ordered by their `<expression>` values by default. The ordering is either numeric (for integers and floating point numbers) or lexicographic (for strings). Lexicographic ordering is based on the [Unicode value](https://en.wikipedia.org/wiki/List_of_Unicode_characters#Basic_Latin) of each character.

> 有序聚合（即min、max、rank、concat和strictconcat）默认按照它们的<expression>值排序。排序方式可以是数字排序（对于整数和浮点数），也可以是词法排序（对于字符串）。词法排序是基于每个字符的Unicode值。

To specify a different order, follow `<expression>` with the keywords `order by`, then the expression that specifies the order, and optionally the keyword `asc` or `desc` (to determine whether to order the expression in ascending or descending order). If you don’t specify an ordering, it defaults to `asc`.

> 要指定不同的顺序，请在<expression>后面加上关键字order by，然后是指定顺序的表达式，以及可选的关键字asc或desc（用于确定表达式是按升序还是降序排列）。如果你没有指定排序，它默认为升序。

The following aggregates are available in QL:

> QL中提供了以下聚合。

* `count`: This aggregate determines the number of distinct values of `<expression>` for each possible assignment of the aggregation variables.

* > count。该聚合确定了<expression>的每个可能的聚合变量赋值的不同值的数量。

    For example, the following aggregation returns the number of files that have more than `500` lines:

    > 例如，下面的聚合返回的是超过500行的文件数。

    ```
    count(File f | f.getTotalNumberOfLines() > 500 | f)
    ```

    If there are no possible assignments to the aggregation variables that satisfy the formula, as in `count(int i | i = 1 and i = 2 | i)`, then `count` defaults to the value `0`.

    > count(File f | f.getTotalNumberOfLines() > 500 | f)
    > 如果没有满足公式的聚合变量的可能赋值，如count(int i | i = 1 and i = 2 | i)，那么count默认为值0。

* `min` and `max`: These aggregates determine the smallest (`min`) or largest (`max`) value of `<expression>` among the possible assignments to the aggregation variables. In this case, `<expression>` must be of numeric type or of type `string`.

* > min和max。这些聚合变量决定了<expression>在可能的聚合变量赋值中的最小（最小）或最大（最大）值。在这种情况下，<expression>必须是数字类型或字符串类型。

  For example, the following aggregation returns the name of the `.js` file (or files) with the largest number of lines:

  > 例如，以下聚合返回行数最多的.js文件（或文件）的名称

    ```
  max(File f | f.getExtension() = "js" | f.getBaseName() order by f.getTotalNumberOfLines())
    ```

  The following aggregation returns the minimum string `s` out of the three strings mentioned below, that is, the string that comes first in the lexicographic ordering of all the possible values of `s`. (In this case, it returns `"De Morgan"`.)

  > 下面的聚合返回下面提到的三个字符串中最小的字符串s，即在所有可能的s值的词法排序中排在第一位的字符串（在本例中，它返回 "德摩根"）。

    ```
  min(string s | s = "Tarski" or s = "Dedekind" or s = "De Morgan" | s)
    ```

* `avg`: This aggregate determines the average value of `<expression>` for all possible assignments to the aggregation variables. The type of `<expression>` must be numeric. If there are no possible assignments to the aggregation variables that satisfy the formula, the aggregation fails and returns no values. In other words, it evaluates to the empty set.

    > avg：该集合确定<expression>对所有可能的集合变量分配的平均值。<expression>的类型必须是数字型。如果聚合变量没有满足公式的可能赋值，则聚合失败，不返回任何值。换句话说，它评估为空集。

    For example, the following aggregation returns the average of the integers `0`, `1`, `2`, and `3`:

    > 例如，下面的聚合返回的是整数0、1、2和3的平均值。

    ```
    avg(int i | i = [0 .. 3] | i)
    ```

* `sum`: This aggregate determines the sum of the values of `<expression>` over all possible assignments to the aggregation variables. The type of `<expression>` must be numeric. If there are no possible assignments to the aggregation variables that satisfy the formula, then the sum is `0`.

* > sum:该集合确定<expression>值在所有可能的集合变量分配中的总和。<expression>的类型必须是数字型。如果没有满足公式的聚合变量的可能赋值，那么总和为0。

    For example, the following aggregation returns the sum of `i * j` for all possible values of `i` and `j`:

    > 例如，下面的聚合返回i*j的所有可能的i和j的值之和。

    ```
    sum(int i, int j | i = [0 .. 2] and j = [3 .. 5] | i * j)
    ```

* `concat`: This aggregate concatenates the values of `<expression>` over all possible assignments to the aggregation variables. Note that `<expression>` must be of type `string`. If there are no possible assignments to the aggregation variables that satisfy the formula, then `concat` defaults to the empty string.

* > concat:该聚合将<expression>的值与所有可能的聚合变量分配相连接。注意<expression>必须是字符串类型。如果聚合变量没有满足公式的可能赋值，那么concat默认为空字符串。

    For example, the following aggregation returns the string `"3210"`, that is, the concatenation of the strings `"0"`, `"1"`, `"2"`, and `"3"` in descending order:

    > 例如，下面的聚合返回字符串 "3210"，也就是字符串 "0"、"1"、"2 "和 "3 "的降序连接

    ```
    concat(int i | i = [0 .. 3] | i.toString() order by i desc)
    ```

    The `concat` aggregate can also take a second expression, separated from the first one by a comma. This second expression is inserted as a separator between each concatenated value.

    > concat aggregate也可以使用第二个表达式，用逗号与第一个表达式隔开。这第二个表达式被插入作为每个连接值之间的分隔符。

    For example, the following aggregation returns `"0|1|2|3"`:

    > 例如，下面的聚合返回 "0|1|2|3"。

    ```
    concat(int i | i = [0 .. 3] | i.toString(), "|")
    ```

* `rank`: This aggregate takes the possible values of `<expression>` and ranks them. In this case, `<expression>` must be of numeric type or of type `string`. The aggregation returns the value that is ranked in the position specified by the **rank expression**. You must include this rank expression in brackets after the keyword `rank`.

* > rank: 这个集合将<expression>的可能值进行排序。在这种情况下，<expression>必须是数字类型或字符串类型。聚合将返回排名在rank表达式指定位置的值。您必须在关键字 rank 后面的括号中包含这个 rank 表达式。

    For example, the following aggregation returns the value that is ranked 4th out of all the possible values. In this case, `8` is the 4th integer in the range from `5` through `15`:

    > 例如，以下聚合返回在所有可能的值中排名第4的值。在这种情况下，8是5到15范围内的第4个整数。

    ```
    rank[4](int i | i = [5 .. 15] | i)
    ```

    Note that the rank indices start at `1`, so `rank[0](...)` returns no results.

    > 请注意，rank指数从1开始，所以rank\[0\](...)不返回结果。

* `strictconcat`, `strictcount`, and `strictsum`: These aggregates work like `concat`, `count`, and `sum` respectively, except that they are *strict*. That is, if there are no possible assignments to the aggregation variables that satisfy the formula, then the entire aggregation fails and evaluates to the empty set (instead of defaulting to `0` or the empty string). This is useful if you’re only interested in results where the aggregation body is non-trivial.

* > strictconcat、strictcount和stictsum。这些聚合的工作原理分别和concat, count, sum一样, 除了它们是严格的. 也就是说，如果聚合变量没有满足公式的可能赋值，那么整个聚合就会失败，并评估为空集（而不是默认为0或空字符串）。如果你只对聚合体是非平凡的结果感兴趣，这很有用。

* `unique`: This aggregate depends on the values of `<expression>` over all possible assignments to the aggregation variables. If there is a unique value of `<expression>` over the aggregation variables, then the aggregate evaluates to that value. Otherwise, the aggregate has no value.

* > `unique`: 取决于<expression>在所有可能的聚合变量赋值上的值。如果<expression>在聚合变量上有一个唯一的值，那么聚合体就会评估为该值。否则，聚合就没有值。

    For example, the following query returns the positive integers `1`, `2`, `3`, `4`, `5`. For negative integers `x`, the expressions `x` and `x.abs()` have different values, so the value for `y` in the aggregate expression is not uniquely determined.

    > 例如，下面的查询返回正整数1，2，3，4，5。对于负整数x，表达式x和x.abs()具有不同的值，因此聚合表达式中y的值不是唯一确定的。
    
    ```
    from int x
    where x in [-5 .. 5] and x != 0
select unique(int y | y = x or y = x.abs() | y)
    ```
    
    ![image-20210316203313463](https://gitee.com/samny/images/raw/master/13u33er13ec/13u33er13ec.png)
    
    The `unique` aggregate is supported from release 2.1.0 of the CodeQL CLI, and release 1.24 of LGTM Enterprise.
    
    > 从CodeQL CLI的2.1.0版本和LGTM Enterprise的1.24版本开始支持`unique` 的聚合。

### Evaluation of aggregates[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#evaluation-of-aggregates)聚合合计

In general, aggregate evaluation involves the following steps:

> 一般来说，集合评价包括以下步骤:

1. Determine the input variables: these are the aggregation variables declared in `<variable declarations>` and also the variables declared outside of the aggregate that are used in some component of the aggregate.

    > 确定输入变量：这些变量是在<变量声明>中声明的集合变量，也是在集合之外声明的、用于集合的某些组成部分的变量。

2. Generate all possible distinct tuples (combinations) of the values of input variables such that the `<formula>` holds true. Note that the same value of an aggregate variable may appear in multiple distinct tuples. All such occurrences of the same value are treated as distinct occurrences when processing tuples.

    > 生成所有可能的输入变量值的不同元组（组合），使<公式>成立。请注意，一个集合变量的同一个值可能出现在多个不同的元组中。当处理元组时，所有这些相同值的出现都被视为不同的出现。

3. Apply `<expression>` on each tuple and collect the generated (distinct) values. The application of `<expression>` on a tuple may result in generating more than one value.

    > 在每个元组上应用<expression>并收集生成的（不同的）值。在一个元组上应用<expression>可能会导致生成一个以上的值。

4. Apply the aggregation function on the values generated in step 3 to compute the final result.

    > 在步骤3中生成的值上应用聚合函数来计算最终结果。

Let us apply these steps to the `sum` aggregate in the following query:

> 让我们在下面的查询中把这些步骤应用到sum聚合中:

```
select sum(int i, int j |
    exists(string s | s = "hello".charAt(i)) and exists(string s | s = "world!".charAt(j)) | i)
```

![image-20210316205427265](https://gitee.com/samny/images/raw/master/27u54er27ec/27u54er27ec.png)

1. Input variables: `i`, `j`.

    > 输入变量：i，j。

2. All possible tuples `(<value of i>, <value of j>)` satisfying the given condition: `(0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (1, 0), (1, 1), ..., (4, 5)`.

    > 满足给定条件的所有可能的元组（<i的值>，<j的值>）。(0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5), (1, 0), (1, 1), ..., (4, 5).

    30 tuples are generated in this step.

    > 在这一步骤中会生成30个元组。

3. Apply the `<expression> i` on all tuples. This means selecting all values of `i` from all tuples: `0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4.`

    > 在所有元组上应用<表达式>i。这意味着从所有元组中选择i的所有值。0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4.

4. Apply the aggregation function `sum` on the above values to get the final result `60`.

    > 在上述数值上应用聚合函数sum，得到最终结果60。

If we change `<expression>` to `i + j` in the above query, the query result is `135` since applying `i + j` on all tuples results in following values: `0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7, 8, 4, 5, 6, 7, 8, 9`.

> 如果我们将上述查询中的<expression>改为i+j，则查询结果为135，因为将i+j应用于所有元组上的结果如下。0, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7, 8, 4, 5, 6, 7, 8, 9.

Next, consider the following query:

> 接下来，考虑下面的查询: 

```
select count(string s | s = "hello" | s.charAt(_))
```

1. `s` is the input variable of the aggregate.

    > s是集合的输入变量。

2. A single tuple `"hello"` is generated in this step.

    > 在这一步骤中会生成一个单一元组 "hello"。

3. The `<expression> charAt(_)` is applied on this tuple. The underscore `_` in `charAt(_)` is a [don’t-care expression](https://codeql.github.com/docs/ql-language-reference/expressions/#don-t-care-expressions), which represents any value. `s.charAt(_)` generates four distinct values `h, e, l, o`.

    > <表达式> charAt(_)被应用在这个元组上。s.charAt(_)中的下划线_是一个无所谓的表达式，它代表任何值。s.charAt(_)生成四个不同的值h、e、l、o。

4. Finally, `count` is applied on these values, and the query returns `4`.

    > 最后，对这些值应用count，查询返回4。

    

### Omitting parts of an aggregation[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#omitting-parts-of-an-aggregation)省略聚会的部分内容



The three parts of an aggregation are not always required, so you can often write the aggregation in a simpler form:

> 聚合的三个部分并不总是必需的，所以你通常可以用更简单的形式来写聚合。

1. If you want to write an aggregation of the form `<aggregate>(<type> v | <expression> = v | v)`, then you can omit the `<variable declarations>` and `<formula>` parts and write it as follows:

    > 如果你想写一个<aggregate>(<type> v | <expression> = v | v)这种形式的聚合，那么你可以省略<变量声明>和<公式>部分，写成如下:

    ```
    <aggregate>(<expression>)
    ```

    For example, the following aggregations determine how many times the letter `l` occurs in string `"hello"`. These forms are equivalent:

    > 例如，下面的聚合确定了字母l在字符串 "hello "中出现的次数。这些形式是等价的。

    ```
    count(int i | i = "hello".indexOf("l") | i)
    count("hello".indexOf("l"))
    ```

2. If there is only one aggregation variable, you can omit the `<expression>` part instead. In this case, the expression is considered to be the aggregation variable itself. For example, the following aggregations are equivalent:

    > 如果只有一个聚合变量，你可以省略<expression>部分。在这种情况下，表达式被认为是聚合变量本身。例如，下面的聚合变量是等价的。

    ```
    avg(int i | i = [0 .. 3] | i)
    avg(int i | i = [0 .. 3])
    ```

3. As a special case, you can omit the `<expression>` part from `count` even if there is more than one aggregation variable. In such a case, it counts the number of distinct tuples of aggregation variables that satisfy the formula. In other words, the expression part is considered to be the constant `1`. For example, the following aggregations are equivalent:

    > 作为一种特殊情况，您可以省略 count 中的 <expression> 部分，即使有一个以上的聚合变量。在这种情况下，它计算满足公式的聚合变量的不同元组的数量。换句话说，表达式部分被认为是常数1。例如，下面的聚合是等价的。

    ```
    count(int i, int j | i in [1 .. 3] and j in [1 .. 3] | 1)
    count(int i, int j | i in [1 .. 3] and j in [1 .. 3])
    ```

4. You can omit the `<formula>` part, but in that case you should include two vertical bars:

    > 你可以省略<公式>部分，但在这种情况下，你应该包括两个竖条。

    ```
    <aggregate>(<variable declarations> | | <expression>)
    ```

    This is useful if you don’t want to restrict the aggregation variables any further. For example, the following aggregation returns the maximum number of lines across all files:

    > 如果你不想进一步限制聚合变量，这很有用。例如，下面的聚合返回所有文件的最大行数。

    ```
    max(File f | | f.getTotalNumberOfLines())
    ```

5. Finally, you can also omit both the `<formula>` and `<expression>` parts. For example, the following aggregations are equivalent ways to count the number of files in a database:

    > 最后，你也可以省略<公式>和<表达式>两部分。例如，下面的聚合是计算数据库中文件数量的等价方法。

    ```
    count(File f | any() | 1)
    count(File f | | 1)
    count(File f)
    ```



### Monotonic aggregates[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#monotonic-aggregates)单调聚合

In addition to standard aggregates, QL also supports monotonic aggregates. Monotonic aggregates differ from standard aggregates in the way that they deal with the values generated by the `<expression>` part of the formula:

> 除了标准聚合，QL还支持单调聚合。单调聚合与标准聚合的不同之处在于它们处理公式中<expression>部分产生的值。

* Standard aggregates take the `<expression>` values for each `<formula>` value and flatten them into a list. A single aggregation function is applied to all the values.

* > 标准聚合是将每个<公式>值的<expression>值扁平化为一个列表。一个单一的聚合函数被应用于所有的值。

* Monotonic aggregates take an `<expression>` for each value given by the `<formula>`, and create combinations of all the possible values. The aggregation function is applied to each of the resulting combinations.

* > 单调聚合对<公式>给出的每个值取一个<expression>，并创建所有可能的值的组合。聚合函数被应用于每个产生的组合。

In general, if the `<expression>` is total and functional, then monotonic aggregates are equivalent to standard aggregates. Results differ when there is not precisely one `<expression>` value for each value generated by the `<formula>`:

> 一般来说，如果<表达式>是总的和函数的，那么单调聚合相当于标准聚合。当<公式>生成的每一个值没有精确的一个<expression>值时，结果就会有所不同:

* If there are missing `<expression>` values (that is, there is no `<expression>` value for a value generated by the `<formula>`), monotonic aggregates won’t compute a result, as you cannot create combinations of values including exactly one `<expression>` value for each value generated by the `<formula>`.

* > 如果缺少<expression>值（也就是说，<formula>生成的值中没有<expression>值），单调聚合不会计算结果，因为你不能为<formula>生成的每个值创建包括一个<expression>值的组合。

* If there is more than one `<expression>` per `<formula>` result, you can create multiple combinations of values including exactly one `<expression>` value for each value generated by the `<formula>`. Here, the aggregation function is applied to each of the resulting combinations.

* > 如果每个<formula>结果有一个以上的<expression>，您可以为<formula>生成的每个值创建多个值的组合，包括正好一个<expression>值。在这里，聚合函数被应用到每个结果组合中。

---



#### Recursive monotonic aggregates[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#recursive-monotonic-aggregates)递归单调聚合



Monotonic aggregates may be used [recursively](https://codeql.github.com/docs/ql-language-reference/recursion/#recursion), but the recursive call may only appear in the expression, and not in the range. The recursive semantics for aggregates are the same as the recursive semantics for the rest of QL. For example, we might define a predicate to calculate the distance of a node in a graph from the leaves as follows:

> 单调聚合可以递归使用，但递归调用只能出现在表达式中，而不能出现在范围内。聚合体的递归语义与QL其他部分的递归语义相同。例如，我们可以定义一个谓词来计算图中一个节点与叶子的距离，如下所示: 

```
int depth(Node n) {
  if not exists(n.getAChild())
  then result = 0
  else result = 1 + max(Node child | child = n.getAChild() | depth(child))
}
```

Here the recursive call is in the expression, which is legal. The recursive semantics for aggregates are the same as the recursive semantics for the rest of QL. If you understand how aggregates work in the non-recursive case then you should not find it difficult to use them recursively. However, it is worth seeing how the evaluation of a recursive aggregation proceeds.

> 这里的递归调用是在表达式中，这是合法的。聚合体的递归语义与QL的其他递归语义是一样的。如果你理解了聚合体在非递归情况下的工作原理，那么你应该不会觉得递归地使用聚合体有什么困难。然而，值得看看递归聚合的评估是如何进行的。

Consider the depth example we just saw with the following graph as input (arrows point from children to parents):

> 考虑一下我们刚刚看到的深度例子，以下面的图作为输入（箭头从子代指向父代）。

![image0](https://gitee.com/samny/images/raw/master/0u33er0ec/0u33er0ec.png)

Then the evaluation of the `depth` predicate proceeds as follows:

> 那么谓词的`depth`计算过程如下：

| **Stage** | **depth**                                | **Comments**                                                 |
| :-------- | :--------------------------------------- | :----------------------------------------------------------- |
| 0         |                                          | We always begin with the empty set.                                        从空集开始。 |
| 1         | `(0, b),             (0, d), (0, e)`     | The nodes with no children have depth 0. The recursive step for **a** and **c** fails to produce a value, since some of their children do not have values for `depth`.                                                     没有子节点的节点的深度为0.a和c的递归步骤没有产生一个值，因为它们的一些子节点没有深度值。 |
| 2         | `(0, b), (0, d), (0, e), (1, c)`         | The recursive step for **c** succeeds, since `depth` now has a value for all its children (**d** and **e**). The recursive step for **a** still fails.                                                                    c的递归步骤成功，因为深度现在对所有子节点（d和e）都有一个值。a的递归步骤仍然失败。 |
| 3         | `(0, b), (0, d), (0, e), (1, c), (2, a)` | The recursive step for **a** succeeds, since `depth` now has a value for all its children (**b** and **c**).a的递归步骤成功，因为深度现在对所有的子代（b和c）都有一个值。 |

Here, we can see that at the intermediate stages it is very important for the aggregate to fail if some of the children lack a value - this prevents erroneous values being added.

> 在这里，我们可以看到，在中间阶段，如果一些子代缺少一个值，那么聚合失败是非常重要的--这可以防止错误的值被添加。



## Any[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#any)

The general syntax of an `any` expression is similar to the syntax of an [aggregation](https://codeql.github.com/docs/ql-language-reference/expressions/#aggregations), namely:

> Any表达式的一般语法与聚合的语法相似，即: 

```
any(<variable declarations> | <formula> | <expression>)
```

You should always include the [variable declarations](https://codeql.github.com/docs/ql-language-reference/variables/#variable-declarations), but the [formula](https://codeql.github.com/docs/ql-language-reference/formulas/#formulas) and [expression](https://codeql.github.com/docs/ql-language-reference/expressions/#expressions) parts are optional.

> 你应该始终包含变量声明，但公式和表达式部分是可选的。

The `any` expression denotes any values that are of a particular form and that satisfy a particular condition. More precisely, the `any` expression:

> Any表达式表示任何具有特定形式并满足特定条件的值。更准确地说，任何表达式。

1. Introduces temporary variables. 引入临时变量

2. Restricts their values to those that satisfy the `<formula>` part (if it’s present). 将它们的值限制为满足<公式>部分的值（如果有的话）。

3. Returns `<expression>` for each of those variables. If there is no `<expression>` part, then it returns the variables themselves.

    > 返回这些变量中每个变量的<expression>。如果没有<expression>部分，则返回变量本身。

The following table lists some examples of different forms of `any` expressions:

> 下表列出了一些不同形式的任意表达式的例子:

| Expression                          | Values                                      |
| :---------------------------------- | :------------------------------------------ |
| `any(File f)`                       | all `File`s in the database                 |
| `any(Element e | e.getName())`      | the names of all `Element`s in the database |
| `any(int i | i = [0 .. 3])`         | the integers `0`, `1`, `2`, and `3`         |
| `any(int i | i = [0 .. 3] | i * i)` | the integers `0`, `1`, `4`, and `9`         |

> Note
>
> There is also a [built-in predicate](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#non-member-built-ins) `any()`. This is a predicate that always holds.
>
> 还有一个内置的谓词any()。这是一个始终保持的谓词。



## Unary operations[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#unary-operations)一元操作



A unary operation is a minus sign (`-`) or a plus sign (`+`) followed by an expression of type `int` or `float`. For example:

> 单元运算是指一个减号(-)或加号(+)，后面跟着一个int或float类型的表达式。例如：

```
-6.28
+(10 - 4)
+avg(float f | f = 3.4 or f = -9.8)
-sum(int i | i in [0 .. 9] | i * i)
```

A plus sign leaves the values of the expression unchanged, while a minus sign takes the arithmetic negations of the values.

> 加号使表达式的值保持不变，而负号则对值进行算术求反。

## Binary operations[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#binary-operations)二元操作



A binary operation consists of an expression, followed by a binary operator, followed by another expression. For example:

> 二进制运算由一个表达式、一个二进制运算符和另一个表达式组成。例如：

```
5 % 2
(9 + 1) / (-2)
"Q" + "L"
2 * min(float f | f in [-3 .. 3])
```

You can use the following binary operators in QL:

> 可以在 QL 中使用以下二进制运算符：

| Name                            | Symbol |
| :------------------------------ | :----- |
| Addition/concatenation加法/串联 | `+`    |
| Multiplication乘法              | `*`    |
| Division除法                    | `/`    |
| Subtraction减法                 | `-`    |
| Modulo取模                      | `%`    |

If both expressions are numbers, these operators act as standard arithmetic operators. For example, `10.6 - 3.2` has value `7.4`, `123.456 * 0` has value `0`, and `9 % 4` has value `1` (the remainder after dividing `9` by `4`). If both operands are integers, then the result is an integer. Otherwise the result is a floating-point number.

> 如果两个表达式都是数字，这些运算符的作用就是标准的算术运算符。例如，10.6 - 3.2 的值是 7.4，123.456 * 0 的值是 0，9 % 4 的值是 1（9 除以 4 后的余数）。如果两个操作数都是整数，那么结果就是一个整数。否则结果是一个浮点数。

You can also use `+` as a string concatenation operator. In this case, at least one of the expressions must be a string—the other expression is implicitly converted to a string using the `toString()` predicate. The two expressions are concatenated, and the result is a string. For example, the expression `221 + "B"` has value `"221B"`.

> 你也可以使用+作为一个字符串连接操作符。在这种情况下，至少有一个表达式必须是字符串--另一个表达式使用toString()谓词隐式转换为字符串。这两个表达式被连接起来，结果是一个字符串。例如，表达式221 + "B "的值是 "221B"。

----



## Casts[¶](https://codeql.github.com/docs/ql-language-reference/expressions/#casts)类型转化

A cast allows you to constrain the [type](https://codeql.github.com/docs/ql-language-reference/types/#types) of an expression. This is similar to casting in other languages, for example in Java.

> 强制转换允许您约束表达式的类型。这与其他语言中的强制转换类似，例如在 Java 中。

You can write a cast in two ways:

> 两种方式写一个类型转化

* As a “postfix” cast: A dot followed by the name of a type in parentheses. For example, `x.(Foo)` restricts the type of `x` to `Foo`.

    > 作为一个 "后缀 "类型: 一个圆点后面是括号里的类型名称。例如，x.(Foo)将x的类型限制为Foo。

* As a “prefix” cast: A type in parentheses followed by another expression. For example, `(Foo)x` also restricts the type of `x` to `Foo`.

    > 作为一个 "前缀 "投递。在括号里的类型后面跟着另一个表达式. 例如，(Foo)x 也将 x 的类型限制为 Foo。

Note that a postfix cast is equivalent to a prefix cast surrounded by parentheses—`x.(Foo)` is exactly equivalent to `((Foo)x)`.

> 请注意，后缀式等同于被括号包围的前缀式-x。(Foo)完全等同于((Foo)x)。

Casts are useful if you want to call a [member predicate](https://codeql.github.com/docs/ql-language-reference/types/#member-predicates) that is only defined for a more specific type. For example, the following query selects Java [classes](https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Type.qll/type.Type$Class.html) that have a direct supertype called “List”:

> 如果你想调用一个只为特定类型定义的成员谓词，那么转置是很有用的。例如，下面的查询选择了具有直接超类型 "List "的Java类。

```
import java

from Type t
where t.(Class).getASupertype().hasName("List")
select t
```

![image-20210316221719485](https://gitee.com/samny/images/raw/master/19u17er19ec/19u17er19ec.png)

Since the predicate `getASupertype()` is defined for `Class`, but not for `Type`, you can’t call `t.getASupertype()` directly. The cast `t.(Class)` ensures that `t` is of type `Class`, so it has access to the desired predicate.

> 由于谓词getASupertype()是为Class定义的，而不是为Type定义的，所以不能直接调用t.getASupertype()。浇铸 t.(Class) 确保 t 是 Class 类型的，所以它可以访问所需的谓词。

If you prefer to use a prefix cast, you can rewrite the `where` part as:

> 如果你更喜欢使用前缀转码，你可以将where部分重写为。

```
where ((Class)t).getASupertype().hasName("List")
```



---



## Don’t-care expressions

This is an expression written as a single underscore `_`. It represents any value. (You “don’t care” what the value is.)

> 这是一个写成下划线_的表达式。它代表任何值。(你 "不关心 "这个值是什么。)

Unlike other expressions, a don’t-care expression does not have a type. In practice, this means that `_` doesn’t have any [member predicates](https://codeql.github.com/docs/ql-language-reference/types/#member-predicates), so you can’t call `_.somePredicate()`.

> 与其他表达式不同，don't-care表达式没有类型。在实践中，这意味着_没有任何成员谓词，所以你不能调用_.somePredicate()。

For example, the following query selects all the characters in the string `"hello"`:

> 例如，下面的查询选择了字符串 "hello "中的所有字符。

```
from string s
where s = "hello".charAt(_)
select s
```

The `charAt(int i)` predicate is defined on strings and usually takes an `int` argument. Here the don’t care expression `_` is used to tell the query to select characters at every possible index. The query returns the values `h`, `e`, `l`, and `o`.

> charAt(int i) 谓词定义在字符串上，通常取一个int参数。这里使用了don't care表达式_来告诉查询在每个可能的索引中选择字符。查询返回的值是h、e、l和o。