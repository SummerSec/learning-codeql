# Troubleshooting query performance[¶](https://codeql.github.com/docs/writing-codeql-queries/troubleshooting-query-performance/#troubleshooting-query-performance)

Improve the performance of your CodeQL queries by following a few simple guidelines.

> 通过遵循一些简单的准则来提高CodeQL查询的性能。

## About query performance

This topic offers some simple tips on how to avoid common problems that can affect the performance of your queries. Before reading the tips below, it is worth reiterating a few important points about CodeQL and the QL language:

> 本主题提供了一些简单的提示，说明如何避免可能影响查询性能的常见问题。在阅读下面的提示之前，值得重申一下关于CodeQL和QL语言的几个重要点:

* CodeQL [predicates](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates) and [classes](https://codeql.github.com/docs/ql-language-reference/types/#classes) are evaluated to database [tables](https://en.wikipedia.org/wiki/Table_(database)). Large predicates generate large tables with many rows, and are therefore expensive to compute.

    > CodeQL谓词和类是对数据库表进行评估的。大的谓词会生成有许多行的大表，因此计算成本很高。

* The QL language is implemented using standard database operations and [relational algebra](https://en.wikipedia.org/wiki/Relational_algebra) (such as join, projection, and union). For more information about query languages and databases, see “[About the QL language](https://codeql.github.com/docs/ql-language-reference/about-the-ql-language/#about-the-ql-language).”

    > QL语言使用标准的数据库操作和关系代数（如join、projection和union）来实现。有关查询语言和数据库的更多信息，请参阅 "关于QL语言"。

* Queries are evaluated *bottom-up*, which means that a predicate is not evaluated until *all* of the predicates that it depends on are evaluated. For more information on query evaluation, see “[Evaluation of QL programs](https://codeql.github.com/docs/ql-language-reference/evaluation-of-ql-programs/#evaluation-of-ql-programs).”

    > 查询是自下而上评估的，这意味着一个谓词在它所依赖的所有谓词被评估之前不会被评估。有关查询评估的更多信息，请参见 "QL程序的评估"。

## Performance tips

Follow the guidelines below to ensure that you don’t get tripped up by the most common CodeQL performance pitfalls.

> 按照下面的指南，确保你不会被最常见的CodeQL性能陷阱所绊倒。

### Eliminate cartesian products

The performance of a predicate can often be judged by considering roughly how many results it has. One way of creating badly performing predicates is by using two variables without relating them in any way, or only relating them using a negation. This leads to computing the [Cartesian product](https://en.wikipedia.org/wiki/Cartesian_product) between the sets of possible values for each variable, potentially generating a huge table of results. This can occur if you don’t specify restrictions on your variables. For instance, consider the following predicate that checks whether a Java method `m` may access a field `f`:

> 判断一个谓词的性能，往往可以考虑它的结果大概有多少。创建性能不好的谓词的一种方法是使用两个变量，而不以任何方式将它们联系起来，或者只使用否定式将它们联系起来。这将导致计算每个变量的可能值集之间的笛卡尔乘积，有可能产生一个巨大的结果表。如果你没有指定对变量的限制，就会出现这种情况。例如，考虑以下谓词，它检查一个Java方法m是否可以访问一个字段f。

```
predicate mayAccess(Method m, Field f) {
  f.getAnAccess().getEnclosingCallable() = m
  or
  not exists(m.getBody())
}
```

The predicate holds if `m` contains an access to `f`, but also conservatively assumes that methods without bodies (for example, native methods) may access *any* field.

> 如果m包含对f的访问，这个谓词就成立，但也保守地假设没有body的方法（例如，本地方法）可以访问任何字段。

However, if `m` is a native method, the table computed by `mayAccess` will contain a row `m, f` for *all* fields `f` in the codebase, making it potentially very large.

> 然而，如果m是一个本地方法，那么由mayAccess计算出来的表将包含代码库中所有字段f的m，f行，这就使得表可能非常大。

This example shows a similar mistake in a member predicate:

> 这个例子显示了一个成员谓词中的类似错误:

```
class Foo extends Class {
  ...
  // BAD! Does not use ‘this’
  Method getToString() {
    result.getName() = "ToString"
  }
  ...
}
```

Note that while `getToString()` does not declare any parameters, it has two implicit parameters, `result` and `this`, which it fails to relate. Therefore, the table computed by `getToString()` contains a row for every combination of `result` and `this`. That is, a row for every combination of a method named `"ToString"` and an instance of `Foo`. To avoid making this mistake, `this` should be restricted in the member predicate `getToString()` on the class `Foo`.

> 请注意，虽然getToString()没有声明任何参数，但它有两个隐式参数，即result和this，它没有将这两个参数关联起来。因此，由getToString()计算出的表格中，每一个result和this的组合都有一行。也就是说，名为 "ToString "的方法和Foo实例的每一个组合都有一行。为了避免犯这个错误，应该在类Foo上的成员谓词getToString()中限制这种情况。

### Use specific types

“[Types](https://codeql.github.com/docs/ql-language-reference/types/#types)” provide an upper bound on the size of a relation. This helps the query optimizer be more effective, so it’s generally good to use the most specific types possible. For example:

> "类型 "为关系的大小提供了一个上限。这有助于查询优化器更加有效，所以一般来说，尽可能使用最具体的类型是好的。例如:

```
predicate foo(LoggingCall e)
```

is preferred over:

> 是首选:

```
predicate foo(Expr e)
```

From the type context, the query optimizer deduces that some parts of the program are redundant and removes them, or *specializes* them.

> 从类型上下文中，查询优化器推断出程序的某些部分是多余的，并将其删除，或将其特殊化。

### Determine the most specific types of a variable

If you are unfamiliar with the library used in a query, you can use CodeQL to determine what types an entity has. There is a predicate called `getAQlClass()`, which returns the most specific QL types of the entity that it is called on.

> 如果你对查询中使用的库不熟悉，你可以使用CodeQL来确定一个实体有什么类型。有一个叫做getAQlClass()的谓词，它可以返回实体的最特定的QL类型。

For example, if you were working with a Java database, you might use `getAQlClass()` on every `Expr` in a callable called `c`:

> 例如，如果你正在使用一个Java数据库，你可能会在一个叫做c的可调用的Expr中使用getAQlClass()。

```
import java

from Expr e, Callable c
where
    c.getDeclaringType().hasQualifiedName("my.namespace.name", "MyClass")
    and c.getName() = "c"
    and e.getEnclosingCallable() = c
select e, e.getAQlClass()
```

The result of this query is a list of the most specific types of every `Expr` in that function. You will see multiple results for expressions that are represented by more than one type, so it will likely return a very large table of results.

> 这个查询的结果是该函数中每个Expr的最特定类型的列表。对于由多个类型表示的表达式，你会看到多个结果，所以它可能会返回一个非常大的结果表。

Use `getAQlClass()` as a debugging tool, but don’t include it in the final version of your query, as it slows down performance.

> 使用getAQlClass()作为调试工具，但不要将其包含在查询的最终版本中，因为它会降低性能。

### Avoid complex recursion

“[Recursion](https://codeql.github.com/docs/ql-language-reference/recursion/#recursion)” is about self-referencing definitions. It can be extremely powerful as long as it is used appropriately. On the whole, you should try to make recursive predicates as simple as possible. That is, you should define a *base case* that allows the predicate to *bottom out*, along with a single *recursive call*:

> "递归 "是关于自引定义的。只要使用得当，它的功能是非常强大的。总的来说，你应该尽量使递归谓词简单。也就是说，你应该定义一个允许谓词见底的基例，以及一次递归调用:

```
int depth(Stmt s) {
  exists(Callable c | c.getBody() = s | result = 0) // base case
  or
  result = depth(s.getParent()) + 1 // recursive call
}
```

> Note
>
> The query optimizer has special data structures for dealing with [transitive closures](https://codeql.github.com/docs/ql-language-reference/recursion/#transitive-closures). If possible, use a transitive closure over a simple recursive predicate, as it is likely to be computed faster.
>
> 查询优化器有特殊的数据结构来处理转式闭包。如果可能的话，在简单的递归谓词上使用转式闭包，因为它可能计算得更快。

### Fold predicates

Sometimes you can assist the query optimizer by “folding” parts of large predicates out into smaller predicates.

> 有时，你可以通过将大型谓词的一部分 "折叠 "出来，变成较小的谓词来协助查询优化器:

The general principle is to split off chunks of work that are:

> 一般的原则是将工作的大块分割开来，这些大块是:

* **linear**, so that there is not too much branching.

    > 线性的，这样就不会有太多的分支。

* **tightly bound**, so that the chunks join with each other on as many variables as possible.

    > 紧密绑定的，所以这些工作块在尽可能多的变量上相互连接。

In the following example, we explore some lookups on two `Element`s:

> 在下面的例子中，我们探讨了对两个元素的一些查找:

```
predicate similar(Element e1, Element e2) {
  e1.getName() = e2.getName() and
  e1.getFile() = e2.getFile() and
  e1.getLocation().getStartLine() = e2.getLocation().getStartLine()
}
```

Going from `Element -> File` and `Element -> Location -> StartLine` is linear–that is, there is only one `File`, `Location`, etc. for each `Element`.

> 从元素->文件和元素->位置->开始线是线性的，也就是说，每个元素只有一个文件，位置等。

However, as written it is difficult for the optimizer to pick out the best ordering. Joining first and then doing the linear lookups later would likely result in poor performance. Generally, we want to do the quick, linear parts first, and then join on the resultant larger tables. We can initiate this kind of ordering by splitting the above predicate as follows:

> 然而，就像所写的那样，优化器很难挑选出最佳的顺序。先加入，然后再进行线性查找，很可能会导致性能不佳。一般来说，我们希望先做快速、线性的部分，然后在结果较大的表上进行连接。我们可以通过将上面的谓词拆分如下来启动这种排序:

```
predicate locInfo(Element e, string name, File f, int startLine) {
  name = e.getName() and
  f = e.getFile() and
  startLine = e.getLocation().getStartLine()
}

predicate sameLoc(Element e1, Element e2) {
  exists(string name, File f, int startLine |
    locInfo(e1, name, f, startLine) and
    locInfo(e2, name, f, startLine)
  )
}
```

Now the structure we want is clearer. We’ve separated out the easy part into its own predicate `locInfo`, and the main predicate `sameLoc` is just a larger join.

> 现在我们想要的结构更加清晰了。我们已经把简单的部分分离出来，变成了自己的谓词 locInfo，而主谓词 sameLoc 只是一个更大的 join。

## Further reading

* “[QL language reference](https://codeql.github.com/docs/ql-language-reference/#ql-language-reference)”
* “[CodeQL tools](https://codeql.github.com/docs/codeql-overview/codeql-tools/#codeql-tools)”