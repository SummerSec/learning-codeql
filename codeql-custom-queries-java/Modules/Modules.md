## Modules[¶](https://codeql.github.com/docs/ql-language-reference/modules/#modules)模块

Modules provide a way of organizing QL code by grouping together related types, predicates, and other modules.

> 模块提供了一种组织QL代码的方式，将相关的类型、谓词和其他模块组合在一起。

You can import modules into other files, which avoids duplication, and helps structure your code into more manageable pieces.

>您可以将模块导入到其他文件中，这样可以避免重复，并有助于将您的代码结构成更容易管理的片段。



---

### Defining a module[¶](https://codeql.github.com/docs/ql-language-reference/modules/#defining-a-module)定义模块

There are various ways to define modules—here is an example of the simplest way, declaring an [explicit module](https://codeql.github.com/docs/ql-language-reference/modules/#explicit-modules) named `Example` containing a class `OneTwoThree`:

> 定义模块的方法有很多种--这里举一个最简单的例子，声明一个名为Example的显式模块，包含一个类OneTwoThree。

The name of a module can be any [identifier](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#identifiers) that starts with an uppercase or lowercase letter.

> 模块的名称可以是任何以大写或小写字母开头的标识符。

`.ql` or `.qll` files also implicitly define modules. For more information, see “[Kinds of modules](https://codeql.github.com/docs/ql-language-reference/modules/#kinds-of-modules).”

> .ql或.ql文件也隐式定义模块。更多信息，请参阅 "模块的种类"。

You can also annotate a module. For more information, see of “[Overview of annotations](https://codeql.github.com/docs/ql-language-reference/annotations/#annotations-overview).”

> 您也可以对模块进行注释。有关更多信息，请参见 "注释概述"。

Note that you can only annotate [explicit modules](https://codeql.github.com/docs/ql-language-reference/modules/#explicit-modules). File modules cannot be annotated.

> 注意，您只能对显式模块进行注释。不能对文件模块进行注释。



----

### Kinds of modules[¶](https://codeql.github.com/docs/ql-language-reference/modules/#kinds-of-modules)模块的种类

#### File modules[¶](https://codeql.github.com/docs/ql-language-reference/modules/#file-modules)文件模块

Each query file (extension `.ql`) and library file (extension `.qll`) implicitly defines a module. The module has the same name as the file, but any spaces in the file name are replaced by underscores (`_`). The contents of the file form the [body of the module](https://codeql.github.com/docs/ql-language-reference/modules/#module-bodies).

> 每个查询文件(扩展名.ql)和库文件(扩展名.ql)都隐含地定义了一个模块。模块的名称与文件相同，但文件名中的任何空格都用下划线（_）代替。文件的内容构成模块的主体。

---

#### Library modules[¶](https://codeql.github.com/docs/ql-language-reference/modules/#library-modules)库模块

A library module is defined by a .qll file. It can contain any of the elements listed in Module bodies below, apart from select clauses.

> 一个库模块由一个.qll文件定义。除了选择子句外，它可以包含下面模块体中列出的任何元素。



**OneTwoThreeLib.qll**

```
class OneTwoThree extends int {
  OneTwoThree() {
    this = 1 or this = 2 or this = 3
  }
}
```

This file defines a library module named `OneTwoThreeLib`. The body of this module defines the class `OneTwoThree`.

> 这个文件定义了一个名为OneTwoThreeLib的库模块。这个模块的主体定义了OneTwoThree类。



----

#### Query modules[¶](https://codeql.github.com/docs/ql-language-reference/modules/#query-modules)查询模块

A query module is defined by a `.ql` file. It can contain any of the elements listed in [Module bodies](https://codeql.github.com/docs/ql-language-reference/modules/#module-bodies) below.

> 一个查询模块是由一个.ql文件定义的。它可以包含下面模块体中列出的任何元素。

Query modules are slightly different from other modules:

> 查询模块与其他模块略有不同:

* A query module can’t be imported.

* > 查询模块不能被导入

* A query module must have at least one query in its [namespace](https://codeql.github.com/docs/ql-language-reference/name-resolution/#namespaces). This is usually a [select clause](https://codeql.github.com/docs/ql-language-reference/queries/#select-clauses), but can also be a [query predicate](https://codeql.github.com/docs/ql-language-reference/queries/#query-predicates).

* > 一个查询模块必须在其命名空间中至少有一个查询。这通常是一个选择子句，但也可以是一个查询谓词。



**OneTwoQuery.ql**

```
import OneTwoThreeLib

from OneTwoThree ott
where ott = 1 or ott = 2
select ott
```

This file defines a query module named `OneTwoQuery`. The body of this module consists of an [import statement](https://codeql.github.com/docs/ql-language-reference/modules/#importing-modules) and a [select clause](https://codeql.github.com/docs/ql-language-reference/queries/#select-clauses).

> 这个文件定义了一个名为OneTwoQuery的查询模块。这个模块的主体由一个导入语句和一个选择子句组成。

![image-20210316144906027](https://gitee.com/samny/images/raw/master/6u49er6ec/6u49er6ec.png)



---

### Explicit modules[¶](https://codeql.github.com/docs/ql-language-reference/modules/#explicit-modules)显示模块

You can also define a module within another module. This is an explicit module definition.

> 您也可以在另一个模块中定义一个模块。这是一个明确的模块定义。

An explicit module is defined with the keyword `module` followed by the module name, and then the module body enclosed in braces. It can contain any of the elements listed in “[Module bodies](https://codeql.github.com/docs/ql-language-reference/modules/#module-bodies)” below, apart from select clauses.

> 一个显式模块的定义是用关键字模块和模块名称，然后是用括号括起来的模块主体。除了选择句之外，它可以包含下文 "模块体 "中所列的任何元素。

For example, you could add the following QL snippet to the library file **OneTwoThreeLib.qll** defined [above](https://codeql.github.com/docs/ql-language-reference/modules/#library-modules):

> 例如，你可以在上面定义的库文件OneTwoThreeLib.qll中添加以下QL代码段。

```
import OneTwoThreeLib
import M

from OneTwoThree ott, OneTwo ot
where ott = 1 or ott = 2 
select ott, ot.getAString()
```

![image-20210316151228090](https://gitee.com/samny/images/raw/master/28u12er28ec/28u12er28ec.png)

This defines an explicit module named `M`. The body of this module defines the class `OneTwo`.

> 这定义了一个名为M的显式模块，这个模块的主体定义了OneTwo类。



---

### Module bodies[¶](https://codeql.github.com/docs/ql-language-reference/modules/#module-bodies)模块主体

The body of a module is the code inside the module definition, for example the class `OneTwo` in the [explicit module](https://codeql.github.com/docs/ql-language-reference/modules/#explicit-modules) `M`.

> 模块的主体是模块定义里面的代码，例如显式模块M中的OneTwo类。

In general, the body of a module can contain the following constructs:

> 一般来说，一个模块的主体可以包含以下结构：

* [Import statements](https://codeql.github.com/docs/ql-language-reference/modules/#import-statements) 导入语句
* [Predicates ](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates)谓词
* [Types](https://codeql.github.com/docs/ql-language-reference/types/#types) (including user-defined [classes](https://codeql.github.com/docs/ql-language-reference/types/#classes))  类型（自定义类型）
* [Aliases](https://codeql.github.com/docs/ql-language-reference/aliases/#aliases)别名
* [Explicit modules](https://codeql.github.com/docs/ql-language-reference/modules/#explicit-modules)显示模块
* [Select clauses](https://codeql.github.com/docs/ql-language-reference/queries/#select-clauses) (only available in a [query module](https://codeql.github.com/docs/ql-language-reference/modules/#query-modules))select 子句



---

### Importing modules[¶](https://codeql.github.com/docs/ql-language-reference/modules/#importing-modules)导入模块

The main benefit of storing code in a module is that you can reuse it in other modules. To access the contents of an external module, you can import the module using an [import statement](https://codeql.github.com/docs/ql-language-reference/modules/#import-statements).

> 在模块中存储代码的主要好处是可以在其他模块中重复使用。要访问外部模块的内容，你可以使用导入语句来导入模块

When you import a module this brings all the names in its namespace, apart from [private](https://codeql.github.com/docs/ql-language-reference/annotations/#private) names, into the [namespace](https://codeql.github.com/docs/ql-language-reference/name-resolution/#namespaces) of the current module.

> 当您导入一个模块时，除了私有名称外，会将其名称空间中的所有名称带入当前模块的名称空间。

---



#### Import statements[¶](https://codeql.github.com/docs/ql-language-reference/modules/#import-statements)导入语句

Import statements are used for importing modules. They are of the form:

> 导入语句用于导入模块。它们的形式是：

```
import <module_expression1> as <name>
import <module_expression2>
```

Import statements are usually listed at the beginning of the module. Each import statement imports one module. You can import multiple modules by including multiple import statements (one for each module you want to import). An import statement can also be [annotated](https://codeql.github.com/docs/ql-language-reference/annotations/#private) with `private`.

> 导入语句通常列在模块的开头。每个导入语句导入一个模块。您可以通过包含多个导入语句来导入多个模块（每个要导入的模块一个）。一个导入语句也可以用private来注释。

You can import a module under a different name using the `as` keyword, for example `import javascript as js`.

> 您可以使用as关键字以不同的名称导入一个模块，例如导入javascript为js。

The `<module_expression>` itself can be a module name, a selection, or a qualified reference. For more information, see “[Name resolution](https://codeql.github.com/docs/ql-language-reference/name-resolution/#name-resolution).”

> <module_expression>本身可以是一个模块名，一个选择，或者一个限定引用。更多信息，请参阅 "名称解析"。

For information about how import statements are looked up, see “[Module resolution](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#module-resolution)” in the QL language specification.

> 关于如何查询导入语句的信息，请参见QL语言规范中的 "模块解析"。