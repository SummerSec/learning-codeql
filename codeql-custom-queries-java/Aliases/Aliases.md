## Aliases[¶](https://codeql.github.com/docs/ql-language-reference/aliases/#aliases)

An alias is an alternative name for an existing QL entity.

> 别名是现有QL实体的替代名称。

Once you’ve defined an alias, you can use that new name to refer to the entity in the current module’s [namespace](https://codeql.github.com/docs/ql-language-reference/name-resolution/#namespaces).

> 一旦你定义了一个别名，你就可以使用这个新名字来引用当前模块命名空间中的实体。

---

### Defining an alias[¶](https://codeql.github.com/docs/ql-language-reference/aliases/#defining-an-alias)定义别名

You can define an alias in the body of any [module](https://codeql.github.com/docs/ql-language-reference/modules/#modules). To do this, you should specify:

> 您可以在任何[模块](https://codeql.github.com/docs/ql-language-reference/modules/#modules)的主体中定义别名。要做到这一点，您应该指定：

1. The keyword `module`, `class`, or `predicate` to define an alias for a [module](https://codeql.github.com/docs/ql-language-reference/modules/#modules), [type](https://codeql.github.com/docs/ql-language-reference/types/#types), or [non-member predicate](https://codeql.github.com/docs/ql-language-reference/predicates/#non-member-predicates) respectively.

    > 关键字，或分别定义[模块](https://codeql.github.com/docs/ql-language-reference/modules/#modules)、[类型](https://codeql.github.com/docs/ql-language-reference/types/#types)或[非成员谓词的](https://codeql.github.com/docs/ql-language-reference/predicates/#non-member-predicates)别名。`module``class``predicate`

2. The name of the alias. This should be a valid name for that kind of entity. For example, a valid predicate alias starts with a lowercase letter.

    > 别名的名字。这应该是此类实体的有效名称。例如，有效的谓词别名以小写字母开头。

3. A reference to the QL entity. This includes the original name of the entity and, for predicates, the arity of the predicate.

    > 对QL实体的引用。这包括实体的原始名称，对于谓词，包括谓词的原名。

You can also annotate an alias. See the list of [annotations](https://codeql.github.com/docs/ql-language-reference/annotations/#annotations-overview) available for aliases.

> 您还可以注释别名。请参阅可用于别名的[注释](https://codeql.github.com/docs/ql-language-reference/annotations/#annotations-overview)列表。

Note that these annotations apply to the name introduced by the alias (and not the underlying QL entity itself). For example, an alias can have different visibility to the name that it aliases.

> 请注意，这些注释适用于别名引入的名称（而不是基础 QL 实体本身）。例如，别名可以与它所别名的名称具有不同的可见性。

----

### Module aliases[¶](https://codeql.github.com/docs/ql-language-reference/aliases/#module-aliases)模块别名

Use the following syntax to define an alias for a [module](https://codeql.github.com/docs/ql-language-reference/modules/#modules):

> 使用以下语法定义[模块](https://codeql.github.com/docs/ql-language-reference/modules/#modules)的别名：

```
module ModAlias = ModuleName;
```

For example, if you create a new module `NewVersion` that is an updated version of `OldVersion`, you could deprecate the name `OldVersion` as follows:

> 例如，如果您创建了更新版本的新模块，则可以将名称弃用如下：`NewVersion``OldVersion``OldVersion`

```
deprecated module OldVersion = NewVersion;
```

That way both names resolve to the same module, but if you use the name `OldVersion`, a deprecation warning is displayed.

> 这样，两个名称都会解决到同一模块，但如果您使用该名称，将显示弃用警告。`OldVersion`

----

### Type aliases[¶](https://codeql.github.com/docs/ql-language-reference/aliases/#type-aliases)类型别名

Use the following syntax to define an alias for a [type](https://codeql.github.com/docs/ql-language-reference/types/#types):

> 使用以下语法定义[一种类型的](https://codeql.github.com/docs/ql-language-reference/types/#types)别名：

```
class TypeAlias = TypeName;
```

Note that `class` is just a keyword. You can define an alias for any type—namely, [primitive types](https://codeql.github.com/docs/ql-language-reference/types/#primitive-types), [database types](https://codeql.github.com/docs/ql-language-reference/types/#database-types) and user-defined [classes](https://codeql.github.com/docs/ql-language-reference/types/#classes).

> 请注意，这只是一个关键字。您可以为任何类型定义别名，即[原始类型](https://codeql.github.com/docs/ql-language-reference/types/#primitive-types)、[数据库类型](https://codeql.github.com/docs/ql-language-reference/types/#database-types)和用户定义[的类](https://codeql.github.com/docs/ql-language-reference/types/#classes)。`class`

For example, you can use an alias to abbreviate the name of the primitive type `boolean` to `bool`:

> 例如，可以使用别名将基元类型`boolean`的名称缩写为`bool`。

```
class bool = boolean;
```

Or, to use a class `OneTwo` defined in a [module](https://codeql.github.com/docs/ql-language-reference/modules/#explicit-modules) `M` in `OneTwoThreeLib.qll`, you could create an alias to use the shorter name `OT` instead:

> 或者，如果要使用OneTwoThreeLib.qll中M模块中定义的OneTwo类，你可以创建一个别名，使用更短的名字OT来代替。

```ql
import OneTwoThreeLib

class OT = M::OneTwo;

...

from OT ot
select ot


```

![image-20210316160600475](https://gitee.com/samny/images/raw/master/0u06er0ec/0u06er0ec.png)

----



### Predicate aliases[¶](https://codeql.github.com/docs/ql-language-reference/aliases/#predicate-aliases)谓词别名

Use the following syntax to define an alias for a [non-member predicate](https://codeql.github.com/docs/ql-language-reference/predicates/#non-member-predicates):

> 使用以下语法来定义[非成员谓词](https://codeql.github.com/docs/ql-language-reference/predicates/#non-member-predicates)的别名：

```
predicate PredAlias = PredicateName/Arity;
```

This works for predicates [with](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates-with-result) or [without](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates-without-result) result.

> 这适用于有结果或无结果的谓词。

For example, suppose you frequently use the following predicate, which calculates the successor of a positive integer less than ten:

> 例如，假设你经常使用下面的谓词，它计算一个小于10的正整数getSuccessor:

```
int getSuccessor(int i) {
  result = i + 1 and
  i in [1 .. 9]
}
```

You can use an alias to abbreviate the name to `succ`:

> 你可以用别名来缩写名字`succ`

```
predicate succ = getSuccessor/1;
```

示例：

```
int getSuccessor(int i) {
    result = i + 1 and
    i in [1 .. 9]
}

predicate succ = getSuccessor/1;

from int i
select succ(i)
```

![image-20210316161029513](https://gitee.com/samny/images/raw/master/29u10er29ec/29u10er29ec.png)

As an example of a predicate without result, suppose you have a predicate that holds for any positive integer less than ten:

> 另一个没有结果的谓词的例子，假设你有一个对任何小于10的正整数都成立的谓词。

```
predicate isSmall(int i) {
  i in [1 .. 9]
}
```

You could give the predicate a more descriptive name as follows:

>您可以给谓词一个更描述性的名称如下：

```
predicate lessThanTen = isSmall/1;
```

示例：

```
predicate isSmall(int i) {
    i in [1 .. 9]
}

predicate lessThanTen = isSmall/1;

from int i
where lessThanTen(i)
select i
```



![image-20210316162008023](https://gitee.com/samny/images/raw/master/8u20er8ec/8u20er8ec.png)

