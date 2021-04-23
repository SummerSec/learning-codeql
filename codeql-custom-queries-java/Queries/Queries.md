## Queries -- 查询

Queries are the output of a QL program. They evaluate to sets of results.

> Queries是QL程序的输出，执行的结果集合。

There are two kinds of queries. For a given [query module](https://codeql.github.com/docs/ql-language-reference/modules/#query-modules), the queries in that module are:

> 有两种Queries。对于给定的[查询模块](https://codeql.github.com/docs/ql-language-reference/modules/#query-modules)，该模块中的查询是

* The [select clause](https://codeql.github.com/docs/ql-language-reference/queries/#select-clauses), if any, defined in that module.

* > select 子句（如果有的话）在该模块中定义。

*  Any [query predicates](https://codeql.github.com/docs/ql-language-reference/queries/#query-predicates) in that module’s predicate [namespace](https://codeql.github.com/docs/ql-language-reference/name-resolution/#namespaces). That is, they can be defined in the module itself, or imported from a different module.

* > 在该模块的谓词空间中的任何查询谓词，也就是说，它们可以在模块本身定义，也可以从其他模块导入

We often also refer to the whole QL program as a query.

> 通常也把整个QL程序称为查询。



---

### Select clauses

When writing a query module, you can include a **select clause** (usually at the end of the file) of the following form:

> 在编写查询模块时，你可以包含一个**选择子句**（通常在文件的末尾），其形式如下:
>
> (from 和 where 部分可以省略)

```
from /* ... variable declarations ... */
where /* ... logical formula ... */
select /* ... expressions ... */
```

Apart from the expressions described in “[Expressions](https://codeql.github.com/docs/ql-language-reference/expressions/#expressions),” you can also include:

> 除了 "表达式 "中描述的表达式外，你还可以包括:

* The `as` keyword, followed by a name. This gives a “label” to a column of results, and allows you to use them in subsequent select expressions.

* > `as`关键字，后面跟着一个名字。这给一列结果打上了 "标签"，并允许你在随后的选择表达式中使用它们。

* The `order by` keywords, followed by the name of a result column, and optionally the keyword `asc` or `desc`. This determines the order in which to display the results.

* > ORDER BY关键字，后跟结果列的名称，还可以选择关键字`asc`或`desc` 。这决定了显示结果的顺序。

[Queries.ql](./Queries.ql)

```
from int x, int y
where x = 3 and y in [0 .. 2]
select x, y, x * y as product, "product: " + product
```

![image-20210314144433274](https://gitee.com/samny/images/raw/master//33u44er33ec/33u44er33ec.png)

````
from int x, int y
where x = 3 and y in [0 .. 2]
select x, y, x * y as product, "product: " + product
as res order by  res desc
````

![image-20210314144734388](https://gitee.com/samny/images/raw/master//34u47er34ec/34u47er34ec.png)



---

### Query predicates -- 查询谓词

 A query predicate is a [non-member predicate](https://codeql.github.com/docs/ql-language-reference/predicates/#non-member-predicates) with a `query` annotation. It returns all the tuples that the predicate evaluates to.

> 查询谓词是具有查询注释的非成员谓词。 它返回谓词求值的所有元组。
>
> 个人理解。再非成员谓词前面加上一个 `query`注释就代表这个非成员谓词是要被查询的，如果不加`query` 注释就会报错

[Queries1.ql](./Queries1.ql)

```
query int getProduct(int x, int y) {
  x = 3 and
  y in [0 .. 2] and
  result = x * y
}
```

![image-20210314145130939](https://gitee.com/samny/images/raw/master//30u51er30ec/30u51er30ec.png)

A benefit of writing a query predicate instead of a select clause is that you can call the predicate in other parts of the code too. For example, you can call `getProduct` inside the body of a [class](https://codeql.github.com/docs/ql-language-reference/types/#classes):

> 编写查询谓词而不是选择子句(select clause)的一个好处是，你也可以在代码的其他部分调用该谓词。

[Queries2.ql](./Queries2.ql)

```
query int getProduct(int x, int y) {
    x = 4 and
    y in [0 .. 3] and
    result = x * y
  }

class MultipleOfThree extends int {
    MultipleOfThree() { this = getProduct(_, _) }
}
```

![image-20210314145749808](https://gitee.com/samny/images/raw/master//49u57er49ec/49u57er49ec.png)