<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:952346623ac466175f6b1cbaf5aab8bb56696563db23a9f1abdcbd858a04b558
size 12282
=======
# Overflow-prone comparisons in Java[¶](https://codeql.github.com/docs/codeql-language-guides/overflow-prone-comparisons-in-java/#overflow-prone-comparisons-in-java)

You can use CodeQL to check for comparisons in Java code where one side of the comparison is prone to overflow.

> 你可以使用CodeQL来检查Java代码中的比较，比较的一方容易溢出。

## About this article

In this tutorial article you’ll write a query for finding comparisons between integers and long integers in loops that may lead to non-termination due to overflow.

> 在这篇教程文章中，你将写一个查询，用于查找循环中整数和长整数之间的比较，这些比较可能会由于溢出而导致非终止。

To begin, consider this code snippet:

> 首先，考虑这个代码片段:

```
void foo(long l) {
    for(int i=0; i<l; i++) {
        // do something
    }
}
```

If `l` is bigger than 231- 1 (the largest positive value of type `int`), then this loop will never terminate: `i` will start at zero, being incremented all the way up to 231- 1, which is still smaller than `l`. When it is incremented once more, an arithmetic overflow occurs, and `i` becomes -231, which also is smaller than `l`! Eventually, `i` will reach zero again, and the cycle repeats.

> 如果l大于231- 1（int类型的最大正值），那么这个循环将永远不会终止：i将从零开始，一直递增到231- 1，这仍然小于l.当它再次递增时，发生算术溢出，i变成-231，这也小于l！最终，i将再次达到零，并重复循环。最终，i将再次达到零，循环往复。

> More about overflow
>
> All primitive numeric types have a maximum value, beyond which they will wrap around to their lowest possible value (called an “overflow”). For `int`, this maximum value is 231- 1. Type `long` can accommodate larger values up to a maximum of 263- 1. In this example, this means that `l` can take on a value that is higher than the maximum for type `int`; `i` will never be able to reach this value, instead overflowing and returning to a low value.
>
> 所有的基元数字类型都有一个最大值，超过这个最大值，它们就会被包围到可能的最低值（称为 "溢出"），对于int来说，这个最大值是231- 1，long类型可以容纳更大的值，最大为263- 1。对于int来说，这个最大值是231- 1，而long类型可以容纳更大的值，最大值是263- 1。在这个例子中，这意味着l可以接受一个比int类型的最大值更高的值；i将永远无法达到这个值，而是溢出并返回一个低值。

We’re going to develop a query that finds code that looks like it might exhibit this kind of behavior. We’ll be using several of the standard library classes for representing statements and functions. For a full list, see “[Abstract syntax tree classes for working with Java programs](https://codeql.github.com/docs/codeql-language-guides/abstract-syntax-tree-classes-for-working-with-java-programs/).”

> 我们将开发一个查询，找到看起来可能表现出这种行为的代码。我们将使用几个标准库类来表示语句和函数。有关完整的列表，请参见 "用于处理Java程序的抽象语法树类"。

## Initial query

We’ll start by writing a query that finds less-than expressions (CodeQL class `LTExpr`) where the left operand is of type `int` and the right operand is of type `long`:

> 我们先写一个查找小于表达式的查询(CodeQL类LTExpr)，其中左操作数的类型是int，右操作数的类型是long:

```
import java

from LTExpr expr
where expr.getLeftOperand().getType().hasName("int") and
    expr.getRightOperand().getType().hasName("long")
select expr
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/490866529746563234/). This query usually finds results on most projects.

> ➤ 在LGTM.com的查询控制台中可以看到。这个查询通常能在大多数项目上找到结果。



![image-20210324163948437](C:%5CUsers%5CSamny%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5Cimage-20210324163948437.png)

![image-20210324163958286](C:%5CUsers%5CSamny%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5Cimage-20210324163958286.png)

![image-20210324164025185](https://gitee.com/samny/images/raw/master/25u40er25ec/25u40er25ec.png)

Notice that we use the predicate `getType` (available on all subclasses of `Expr`) to determine the type of the operands. Types, in turn, define the `hasName` predicate, which allows us to identify the primitive types `int` and `long`. As it stands, this query finds *all* less-than expressions comparing `int` and `long`, but in fact we are only interested in comparisons that are part of a loop condition. Also, we want to filter out comparisons where either operand is constant, since these are less likely to be real bugs. The revised query looks like this:

> 请注意，我们使用谓词 getType（可用于 Expr 的所有子类）来确定操作数的类型。Types则定义了hasName谓词，它允许我们识别基元类型int和long。目前来看，这个查询可以找到所有比较int和long的小于表达式，但实际上我们只对作为循环条件一部分的比较感兴趣。另外，我们希望过滤掉操作数为常数的比较，因为这些比较不太可能是真正的错误。修改后的查询是这样的:

```
import java

from LTExpr expr
where expr.getLeftOperand().getType().hasName("int") and
    expr.getRightOperand().getType().hasName("long") and
    exists(LoopStmt l | l.getCondition().getAChildExpr*() = expr) and
    not expr.getAnOperand().isCompileTimeConstant()
select expr
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/4315986481180063825/). Notice that fewer results are found.

> ➤ 在LGTM.com的查询控制台中看到。注意，发现的结果较少。

![image-20210324164138891](https://gitee.com/samny/images/raw/master/38u41er38ec/38u41er38ec.png)

![image-20210324164211737](https://gitee.com/samny/images/raw/master/11u42er11ec/11u42er11ec.png)





The class `LoopStmt` is a common superclass of all loops, including, in particular, `for` loops as in our example above. While different kinds of loops have different syntax, they all have a loop condition, which can be accessed through predicate `getCondition`. We use the reflexive transitive closure operator `*` applied to the `getAChildExpr` predicate to express the requirement that `expr` should be nested inside the loop condition. In particular, it can be the loop condition itself.

> LoopStmt 类是所有循环的共同超类，特别是包括我们上面例子中的 for 循环。虽然不同种类的循环有不同的语法，但它们都有一个循环条件，可以通过谓词getCondition访问。我们使用应用于getAChildExpr谓词的反身转义闭合操作符*来表达expr应该嵌套在循环条件里面的要求。特别是，它可以是循环条件本身。

The final conjunct in the `where` clause takes advantage of the fact that [predicates](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates) can return more than one value (they are really relations). In particular, `getAnOperand` may return *either* operand of `expr`, so `expr.getAnOperand().isCompileTimeConstant()` holds if at least one of the operands is constant. Negating this condition means that the query will only find expressions where *neither* of the operands is constant.

> where子句中的最后一个连词利用了谓词可以返回多个值的事实（它们实际上是关系）。特别是，getAnOperand可以返回expr的任何一个操作数，所以expr.getAnOperand().isCompileTimeConstant()在操作数中至少有一个是常数时成立。否定这个条件意味着查询将只找到操作数都不是常数的表达式。

## Generalizing the query

Of course, comparisons between `int` and `long` are not the only problematic case: any less-than comparison between a narrower and a wider type is potentially suspect, and less-than-or-equals, greater-than, and greater-than-or-equals comparisons are just as problematic as less-than comparisons.

> 当然，int和long之间的比较并不是唯一有问题的情况：窄类型和宽类型之间的任何小于等于的比较都有可能是可疑的，小于或等于、大于等于和大于等于的比较和小于等于的比较一样有问题。

In order to compare the ranges of types, we define a predicate that returns the width (in bits) of a given integral type:

> 为了比较类型的范围，我们定义了一个谓词来返回给定积分类型的宽度（以位为单位）:

```
int width(PrimitiveType pt) {
    (pt.hasName("byte") and result=8) or
    (pt.hasName("short") and result=16) or
    (pt.hasName("char") and result=16) or
    (pt.hasName("int") and result=32) or
    (pt.hasName("long") and result=64)
}
```

We now want to generalize our query to apply to any comparison where the width of the type on the smaller end of the comparison is less than the width of the type on the greater end. Let’s call such a comparison *overflow prone*, and introduce an abstract class to model it:

> 我们现在想把我们的查询泛化为适用于任何比较，在比较中较小端类型的宽度小于较大端类型的宽度。让我们把这样的比较称为溢出式比较，并引入一个抽象类来模拟它。

```
abstract class OverflowProneComparison extends ComparisonExpr {
    Expr getLesserOperand() { none() }
    Expr getGreaterOperand() { none() }
}
```

There are two concrete child classes of this class: one for `<=` or `<` comparisons, and one for `>=` or `>` comparisons. In both cases, we implement the constructor in such a way that it only matches the expressions we want:

> 这个类有两个具体的子类：一个用于<=或<比较，另一个用于>=或>比较。在这两种情况下，我们以这样的方式实现构造函数，使它只匹配我们想要的表达式。

```
class LTOverflowProneComparison extends OverflowProneComparison {
    LTOverflowProneComparison() {
        (this instanceof LEExpr or this instanceof LTExpr) and
        width(this.getLeftOperand().getType()) < width(this.getRightOperand().getType())
    }
}

class GTOverflowProneComparison extends OverflowProneComparison {
    GTOverflowProneComparison() {
        (this instanceof GEExpr or this instanceof GTExpr) and
        width(this.getRightOperand().getType()) < width(this.getLeftOperand().getType())
    }
}
```

Now we rewrite our query to make use of these new classes:

> 现在我们重写我们的查询来使用这些新类:

```
import java

// Return the width (in bits) of a given integral type 
int width(PrimitiveType pt) {
  (pt.hasName("byte") and result=8) or
  (pt.hasName("short") and result=16) or
  (pt.hasName("char") and result=16) or
  (pt.hasName("int") and result=32) or
  (pt.hasName("long") and result=64)
}

// Find any comparison where the width of the type on the smaller end of 
// the comparison is less than the width of the type on the greater end
abstract class OverflowProneComparison extends ComparisonExpr {
  Expr getLesserOperand() { none() }
  Expr getGreaterOperand() { none() }
}

// Return `<=` and `<` comparisons
class LTOverflowProneComparison extends OverflowProneComparison {
  LTOverflowProneComparison() {
    (this instanceof LEExpr or this instanceof LTExpr) and
    width(this.getLeftOperand().getType()) < width(this.getRightOperand().getType())
  }
}

// Return `>=` and `>` comparisons
class GTOverflowProneComparison extends OverflowProneComparison {
  GTOverflowProneComparison() {
    (this instanceof GEExpr or this instanceof GTExpr) and
    width(this.getRightOperand().getType()) < width(this.getLeftOperand().getType())
  }
}

from OverflowProneComparison expr
where exists(LoopStmt l | l.getCondition().getAChildExpr*() = expr) and
      not expr.getAnOperand().isCompileTimeConstant()
select expr
```

➤ [See the full query in the query console on LGTM.com](https://lgtm.com/query/506868054626167462/).

> ➤ 在LGTM.com的查询控制台中查看完整的查询。

![image-20210324164413796](https://gitee.com/samny/images/raw/master/13u44er13ec/13u44er13ec.png)
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
