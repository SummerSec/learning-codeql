<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:72c28aca2eb8efd0babfe0cbd42051da756a948b7323f86be876611ce83f9d80
size 19538
=======
# Working with source locations[¶](https://codeql.github.com/docs/codeql-language-guides/working-with-source-locations/#working-with-source-locations)

You can use the location of entities within Java code to look for potential errors. Locations allow you to deduce the presence, or absence, of white space which, in some cases, may indicate a problem.

> 您可以使用Java代码中实体的位置来查找潜在的错误。通过位置，您可以推断出是否存在空白，在某些情况下，这些空白可能表明有问题。

## About source locations

Java offers a rich set of operators with complex precedence rules, which are sometimes confusing to developers. For instance, the class `ByteBufferCache` in the OpenJDK Java compiler (which is a member class of `com.sun.tools.javac.util.BaseFileManager`) contains this code for allocating a buffer:

> Java提供了一套丰富的运算符，具有复杂的优先规则，有时会让开发人员感到困惑。例如，OpenJDK Java编译器中的类ByteBufferCache（它是com.sun.tools.javac.util.BaseFileManager的一个成员类）包含了这样一段分配缓冲区的代码:

```
ByteBuffer.allocate(capacity + capacity>>1)
```

Presumably, the author meant to allocate a buffer that is 1.5 times the size indicated by the variable `capacity`. In fact, however, operator `+` binds tighter than operator `>>`, so the expression `capacity + capacity>>1` is parsed as `(capacity + capacity)>>1`, which equals `capacity` (unless there is an arithmetic overflow).

> 据推测，作者的意思是要分配一个缓冲区，这个缓冲区的大小是变量capacity所表示的1.5倍。但事实上，运算符+比运算符>>结合得更紧密，所以表达式capacity+capacity>>1被解析为(capacity+capacity)>>1，等于capacity(除非有算术溢出)。

Note that the source layout gives a fairly clear indication of the intended meaning: there is more white space around `+` than around `>>`, suggesting that the latter is meant to bind more tightly.

> 请注意，源码布局给出了相当明确的预期含义：+周围的空白空间比>>周围的空白空间更多，表明后者的目的是为了更紧密地绑定。

We’re going to develop a query that finds this kind of suspicious nesting, where the operator of the inner expression has more white space around it than the operator of the outer expression. This pattern may not necessarily indicate a bug, but at the very least it makes the code hard to read and prone to misinterpretation.

> 我们要开发一个查询来发现这种可疑的嵌套，即内部表达式的操作符比外部表达式的操作符周围有更多的白色空间。这种模式可能不一定表明是个bug，但至少会使代码难以阅读，容易被误解。

White space is not directly represented in the CodeQL database, but we can deduce its presence from the location information associated with program elements and AST nodes. So, before we write our query, we need an understanding of source location management in the standard library for Java.

> 白色空间在CodeQL数据库中并没有直接表示，但我们可以从与程序元素和AST节点相关联的位置信息推断出它的存在。所以，在编写查询之前，我们需要了解Java标准库中的源位置管理。

## Location API

For every entity that has a representation in Java source code (including, in particular, program elements and AST nodes), the standard CodeQL library provides these predicates for accessing source location information:

> 对于每一个在Java源代码中具有表示的实体（特别是包括程序元素和AST节点），标准的CodeQL库提供了这些谓词用于访问源位置信息:

* `getLocation` returns a `Location` object describing the start and end position of the entity.

    > getLocation返回一个Location对象，描述实体的开始和结束位置。

* `getFile` returns a `File` object representing the file containing the entity.

    > getFile返回一个File对象，表示包含实体的文件。

* `getTotalNumberOfLines` returns the number of lines the source code of the entity spans.

    > getTotalNumberOfLines 返回实体的源代码所跨越的行数。

* `getNumberOfCommentLines` returns the number of comment lines.

    > getNumberOfCommentLines 返回注释行数。

* `getNumberOfLinesOfCode` returns the number of non-comment lines.

    > getNumberOfLinesOfCode 返回非注释行的数量。

For example, let’s assume this Java class is defined in the compilation unit `SayHello.java`:

> 例如，我们假设这个Java类定义在编译单元SayHello.java中:

```
package pkg;

class SayHello {
    public static void main(String[] args) {
        System.out.println(
            // Display personalized message
            "Hello, " + args[0];
        );
    }
}
```

Invoking `getFile` on the expression statement in the body of `main` returns a `File` object representing the file `SayHello.java`. The statement spans four lines in total `(getTotalNumberOfLines`), of which one is a comment line (`getNumberOfCommentLines`), while three lines contain code (`getNumberOfLinesOfCode`).

> 在main主体的表达式语句上调用getFile，返回一个File对象，代表文件SayHello.java。该语句共跨四行（getTotalNumberOfLines），其中一行是注释行（getNumberOfCommentLines），而三行包含代码（getNumberOfLinesOfCode）。

Class `Location` defines member predicates `getStartLine`, `getEndLine`, `getStartColumn` and `getEndColumn` to retrieve the line and column number an entity starts and ends at, respectively. Both lines and columns are counted starting from 1 (not 0), and the end position is inclusive, that is, it is the position of the last character belonging to the source code of the entity.

> 类位置定义了成员谓词getStartLine、getEndLine、getStartColumn和getEndColumn，分别用于检索实体开始和结束的行号和列号。行和列都从1开始计算（不是0），结束位置是包含的，也就是属于实体源代码的最后一个字符的位置。

In our example, the expression statement starts at line 5, column 3 (the first two characters on the line are tabs, which each count as one character), and it ends at line 8, column 4.

> 在我们的例子中，表达式语句从第5行第3列开始（该行的前两个字符是tab，每个字符都算作一个字符），它的结束位置是第8行第4列。

Class `File` defines these member predicates:

> 类文件定义了这些成员谓词:

* `getAbsolutePath` returns the fully qualified name of the file.

    > getAbsolutePath 返回文件的完全限定名称。

* `getRelativePath` returns the path of the file relative to the base directory of the source code.

    > getRelativePath返回文件相对于源代码基本目录的路径。

* `getExtension` returns the extension of the file.

    > getExtension 返回文件的扩展名 

* `getStem` returns the base name of the file, without its extension.

    > getStem 返回文件的基本名称，不含扩展名。

In our example, assume file `A.java` is located in directory `/home/testuser/code/pkg`, where `/home/testuser/code` is the base directory of the program being analyzed. Then, a `File` object for `A.java` returns:

> 在我们的例子中，假设文件A.java位于目录/home/testuser/code/pkg中，其中/home/testuser/code是被分析程序的基础目录。然后，返回A.java的File对象:

* `getAbsolutePath` is `/home/testuser/code/pkg/A.java`.
* `getRelativePath` is `pkg/A.java`.
* `getExtension` is `java`.
* `getStem` is `A`.

## Determining white space around an operator

Let’s start by considering how to write a predicate that computes the total amount of white space surrounding the operator of a given binary expression. If `rcol` is the start column of the expression’s right operand and `lcol` is the end column of its left operand, then `rcol - (lcol+1)` gives us the total number of characters in between the two operands (note that we have to use `lcol+1` instead of `lcol` because end positions are inclusive).

> 让我们先考虑如何编写一个谓词，计算一个给定二进制表达式的操作符周围的空白空间总数。如果rcol是表达式右边操作数的起始列，lcol是左边操作数的结束列，那么rcol - (lcol+1)给出了两个操作数之间的总字符数（注意，我们必须使用lcol+1而不是lcol，因为结束位置是包含的）。 

This number includes the length of the operator itself, which we need to subtract out. For this, we can use predicate `getOp`, which returns the operator string, surrounded by one white space on either side. Overall, the expression for computing the amount of white space around the operator of a binary expression `expr` is:

> 这个数字包括运算符本身的长度，我们需要将其减去。为此，我们可以使用谓词getOp，它返回操作符字符串，两边各用一个空格包围。总的来说，计算二进制表达式expr的运算符周围的白格量的表达式是:

```
rcol - (lcol+1) - (expr.getOp().length()-2)
```

Clearly, however, this only works if the entire expression is on a single line, which we can check using predicate `getTotalNumberOfLines` introduced above. We are now in a position to define our predicate for computing white space around operators:

> 然而，很明显，只有当整个表达式都在一行上时，这才是有效的，我们可以使用上面介绍的谓词getTotalNumberOfLines来检查。现在我们可以定义用于计算运算符周围空白空间的谓词了。

```
int operatorWS(BinaryExpr expr) {
    exists(int lcol, int rcol |
        expr.getNumberOfLinesOfCode() = 1 and
        lcol = expr.getLeftOperand().getLocation().getEndColumn() and
        rcol = expr.getRightOperand().getLocation().getStartColumn() and
        result = rcol - (lcol+1) - (expr.getOp().length()-2)
    )
}
```

Notice that we use an `exists` to introduce our temporary variables `lcol` and `rcol`. You could write the predicate without them by just inlining `lcol` and `rcol` into their use, at some cost in readability.

> 请注意，我们使用了一个 exists 来引入我们的临时变量 lcol 和 rcol。你可以在写谓词时不使用它们，只在使用时内联lcol和rcol，但在可读性上会有一些损失。

## Find suspicious nesting

Here’s a first version of our query:

> 这是我们查询的第一个版本:

```
import java

// Compute whitespace around operators
int operatorWS(BinaryExpr expr) {
    exists(int lcol, int rcol |
        expr.getNumberOfLinesOfCode() = 1 and
        lcol = expr.getLeftOperand().getLocation().getEndColumn() and
        rcol = expr.getRightOperand().getLocation().getStartColumn() and
        result = rcol - (lcol+1) - (expr.getOp().length()-2)
    )
}

from BinaryExpr outer, BinaryExpr inner,
    int wsouter, int wsinner
where inner = outer.getAChildExpr() and
    wsinner = operatorWS(inner) and wsouter = operatorWS(outer) and
    wsinner > wsouter
select outer, "Whitespace around nested operators contradicts precedence."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/8141155897270480914/). This query is likely to find results on most projects.

> ➤ 在LGTM.com的查询控制台中可以看到。这个查询很可能在大多数项目上找到结果。

![image-20210327140925716](https://gitee.com/samny/images/raw/master/25u09er25ec/25u09er25ec.png)

![image-20210327140944489](https://gitee.com/samny/images/raw/master/48u09er48ec/48u09er48ec.png)

![image-20210327140955684](https://gitee.com/samny/images/raw/master/55u09er55ec/55u09er55ec.png)



The first conjunct of the `where` clause restricts `inner` to be an operand of `outer`, the second conjunct binds `wsinner` and `wsouter`, while the last conjunct selects the suspicious cases.

> where子句的第一个共轭限制了inner是 outer的操作数，第二个共轭绑定了wsinner和wsouter，而最后一个共轭选择了可疑的情况。

At first, we might be tempted to write `inner = outer.getAnOperand()` in the first conjunct. This, however, wouldn’t be quite correct: `getAnOperand` strips off any surrounding parentheses from its result, which is often useful, but not what we want here: if there are parentheses around the inner expression, then the programmer probably knew what they were doing, and the query should not flag this expression.

> 起初，我们可能会想在第一个共轭中写出inner = outer.getAnOperand()。然而，这并不完全正确：getAnOperand会从其结果中剥离任何周围的小括号，这通常是有用的，但不是我们在这里想要的：如果内在表达式周围有小括号，那么程序员可能知道他们在做什么，查询不应该标记这个表达式。

### Improving the query

If we run this initial query, we might notice some false positives arising from asymmetric white space. For instance, the following expression is flagged as suspicious, although it is unlikely to cause confusion in practice:

> 如果我们运行这个初始查询，我们可能会注意到一些不对称的白色空间产生的假阳性。例如，下面的表达式被标记为可疑，尽管它在实践中不太可能引起混淆:

```
i< start + 100
```

Note that our predicate `operatorWS` computes the **total** amount of white space around the operator, which, in this case, is one for the `<` and two for the `+`. Ideally, we would like to exclude cases where the amount of white space before and after the operator are not the same. Currently, CodeQL databases don’t record enough information to figure this out, but as an approximation we could require that the total number of white space characters is even:

> 请注意，我们的谓词 operatorWS 计算的是运算符周围的空白空间总量，在这种情况下，<的空白空间是一个，+的空白空间是两个。理想情况下，我们希望排除操作符前后留白量不一样的情况。目前，CodeQL数据库并没有记录足够的信息来弄清这一点，但作为近似值，我们可以要求空白字符的总数是偶数:

```
import java

// Compute whitespace around operators
int operatorWS(BinaryExpr expr) {
    exists(int lcol, int rcol |
        expr.getNumberOfLinesOfCode() = 1 and
        lcol = expr.getLeftOperand().getLocation().getEndColumn() and
        rcol = expr.getRightOperand().getLocation().getStartColumn() and
        result = rcol - (lcol+1) - (expr.getOp().length()-2)
    )
}

from BinaryExpr outer, BinaryExpr inner,
    int wsouter, int wsinner
where inner = outer.getAChildExpr() and
    wsinner = operatorWS(inner) and wsouter = operatorWS(outer) and
    wsinner % 2 = 0 and wsouter % 2 = 0 and
    wsinner > wsouter
select outer, "Whitespace around nested operators contradicts precedence."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/3151720037708691205/). Any results will be refined by our changes to the query.

> ➤ 在LGTM.com的查询控制台中可以看到。任何结果都将通过我们对查询的更改来完善。

![image-20210327141424528](https://gitee.com/samny/images/raw/master/24u14er24ec/24u14er24ec.png)

![image-20210327141545915](https://gitee.com/samny/images/raw/master/53u15er53ec/53u15er53ec.png)

![image-20210327141553168](https://gitee.com/samny/images/raw/master/53u15er53ec/53u15er53ec.png)

Another source of false positives are associative operators: in an expression of the form `x + y+z`, the first plus is syntactically nested inside the second, since + in Java associates to the left; hence the expression is flagged as suspicious. But since + is associative to begin with, it does not matter which way around the operators are nested, so this is a false positive. To exclude these cases, let us define a new class identifying binary expressions with an associative operator:

> 另一个误报的来源是关联运算符：在 x + y+z 这种形式的表达式中，第一个加号在语法上嵌套在第二个加号里面，因为在 Java 中 + 是向左关联的；因此该表达式被标记为可疑。但是由于+一开始就是关联的，所以运算符嵌套在哪个方向并不重要，所以这是一个假阳性。为了排除这些情况，让我们定义一个新的类来识别带有关联运算符的二进制表达式:

```
class AssociativeOperator extends BinaryExpr {
    AssociativeOperator() {
        this instanceof AddExpr or
        this instanceof MulExpr or
        this instanceof BitwiseExpr or
        this instanceof AndLogicalExpr or
        this instanceof OrLogicalExpr
    }
}
```

Now we can extend our query to discard results where the outer and the inner expression both have the same, associative operator:

> 现在，我们可以扩展我们的查询，以丢弃外在表达式和内在表达式都有相同的关联操作符的结果:

```
import java

// Compute whitespace around operators
int operatorWS(BinaryExpr expr) {
    exists(int lcol, int rcol |
        expr.getNumberOfLinesOfCode() = 1 and
        lcol = expr.getLeftOperand().getLocation().getEndColumn() and
        rcol = expr.getRightOperand().getLocation().getStartColumn() and
        result = rcol - (lcol+1) - (expr.getOp().length()-2)
    )
}

//Identify binary expressions with an associative operator
class AssociativeOperator extends BinaryExpr {
    AssociativeOperator() {
        this instanceof AddExpr or
        this instanceof MulExpr or
        this instanceof BitwiseExpr or
        this instanceof AndLogicalExpr or
        this instanceof OrLogicalExpr
    }
}

from BinaryExpr inner, BinaryExpr outer, int wsouter, int wsinner
where inner = outer.getAChildExpr() and
    not (inner.getOp() = outer.getOp() and outer instanceof AssociativeOperator) and
    wsinner = operatorWS(inner) and wsouter = operatorWS(outer) and
    wsinner % 2 = 0 and wsouter % 2 = 0 and
    wsinner > wsouter
select outer, "Whitespace around nested operators contradicts precedence."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/5714614966569401039/).

> ➤ 在LGTM.com的查询控制台中可以看到这一点。

![image-20210327141908239](https://gitee.com/samny/images/raw/master/8u19er8ec/8u19er8ec.png)

![image-20210327141931108](https://gitee.com/samny/images/raw/master/37u19er37ec/37u19er37ec.png)

![image-20210327141937373](https://gitee.com/samny/images/raw/master/37u19er37ec/37u19er37ec.png)



Notice that we again use `getOp`, this time to determine whether two binary expressions have the same operator. Running our improved query now finds the Java standard library bug described in the Overview. It also flags up the following suspicious code in [Hadoop HBase](https://hbase.apache.org/):

> 注意，我们再次使用 getOp，这次是为了确定两个二进制表达式是否具有相同的运算符。现在运行我们改进的查询可以找到概述中描述的 Java 标准库错误。它还在Hadoop HBase中标记出以下可疑代码:

```
KEY_SLAVE = tmp[ i+1 % 2 ];
```

Whitespace suggests that the programmer meant to toggle `i` between zero and one, but in fact the expression is parsed as `i + (1%2)`, which is the same as `i + 1`, so `i` is simply incremented.

> 空格表明程序员的意思是在0和1之间切换i，但事实上，该表达式被解析为i+（1%2），这与i+1相同，所以i只是简单地递增。
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
