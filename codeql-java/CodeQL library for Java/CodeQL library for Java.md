<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:09c430ba7ae94a8f55aefd8a7d957594c0bb73e3da190efbbbfcdced503d682a
size 36089
=======
# CodeQL library for Java[¶](https://codeql.github.com/docs/codeql-language-guides/codeql-library-for-java/#codeql-library-for-java)

When you’re analyzing a Java program, you can make use of the large collection of classes in the CodeQL library for Java.

> 当你在分析一个Java程序时，你可以利用Java的CodeQL库中的大量类的集合。

## About the CodeQL library for Java

There is an extensive library for analyzing CodeQL databases extracted from Java projects. The classes in this library present the data from a database in an object-oriented form and provide abstractions and predicates to help you with common analysis tasks.

> 有一个广泛的库用于分析从Java项目中提取的CodeQL数据库。该库中的类以面向对象的形式呈现数据库中的数据，并提供抽象和谓词来帮助你完成常见的分析任务。

The library is implemented as a set of QL modules, that is, files with the extension `.qll`. The module `java.qll` imports all the core Java library modules, so you can include the complete library by beginning your query with:

> 该库以一组QL模块的形式实现，也就是扩展名为.qll的文件。java.qll模块导入了所有的核心Java库模块，所以你可以通过以以下方式开始查询来包含完整的库。

```
import java
```

The rest of this article briefly summarizes the most important classes and predicates provided by this library.

> 本文其余部分简要总结了这个库提供的最重要的类和谓词。

> Note
>
> The example queries in this article illustrate the types of results returned by different library classes. The results themselves are not interesting but can be used as the basis for developing a more complex query. The other articles in this section of the help show how you can take a simple query and fine-tune it to find precisely the results you’re interested in.
>
> 本文的示例查询说明了不同库类返回的结果类型。这些结果本身并不有趣，但可以作为开发更复杂查询的基础。本节帮助中的其他文章展示了如何将一个简单的查询进行微调，以精确地找到你感兴趣的结果。

## Summary of the library classes

The most important classes in the standard Java library can be grouped into five main categories:

> 标准Java库中最重要的类可以分为五大类。

1. Classes for representing program elements (such as classes and methods)

    > 代表程序元素的类（如类和方法）。

2. Classes for representing AST nodes (such as statements and expressions)

    > 用于表示AST节点（如语句和表达式）的类。

3. Classes for representing metadata (such as annotations and comments)

    > 用于表示元数据（如注释和评论）的类。

4. Classes for computing metrics (such as cyclomatic complexity and coupling)

    > 计算度量的类（如循环复杂度和耦合度

5. Classes for navigating the program’s call graph

    > 用于导航程序的调用图的类。

We will discuss each of these in turn, briefly describing the most important classes for each category.

> 我们将依次讨论这些内容，简要介绍每一类最重要的类别。

## Program elements

These classes represent named program elements: packages (`Package`), compilation units (`CompilationUnit`), types (`Type`), methods (`Method`), constructors (`Constructor`), and variables (`Variable`).

> 这些类表示命名的程序元素：包（Package）、编译单元（CompilationUnit）、类型（Type）、方法（Method）、构造器（Constructor）和变量（Variable）。

Their common superclass is `Element`, which provides general member predicates for determining the name of a program element and checking whether two elements are nested inside each other.

> 它们共同的超类是Element，它提供了一般的成员谓词，用于确定程序元素的名称和检查两个元素内部是否相互嵌套。

It’s often convenient to refer to an element that might either be a method or a constructor; the class `Callable`, which is a common superclass of `Method` and `Constructor`, can be used for this purpose.

> 通常，引用一个可能是方法或构造函数的元素是很方便的；类Callable是Method和Constructor的共同超类，可以用于这个目的。

### Types

Class `Type` has a number of subclasses for representing different kinds of types:

> 类Type有许多子类，用于表示不同种类的类型:

* `PrimitiveType` represents a [primitive type](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html), that is, one of `boolean`, `byte`, `char`, `double`, `float`, `int`, `long`, `short`; QL also classifies `void` and `<nulltype>` (the type of the `null` literal) as primitive types.

    > PrimitiveType表示一个基元类型，即布尔、字节、char、double、float、int、long、short中的一种；QL还将void和<nulltype>（null文字的类型）归为基本类型。	

* `RefType` represents a reference (that is, non-primitive) type; it in turn has several subclasses:
    
    >  代表一个引用（即非基本）类型；它又有几个子类：

    * `Class` represents a Java class. Class代表一个Java类。
* `Interface` represents a Java interface.  Interface代表一个Java接口。
    * `EnumType` represents a Java `enum` type.  EnumType代表一个Java枚举类型。
* `Array` represents a Java array type. Array代表一个Java数组类型。
    


For example, the following query finds all variables of type `int` in the program:

> 例如，下面的查询可以找到程序中所有类型为int的变量:



```
import java

from Variable v, PrimitiveType pt
where pt = v.getType() and
    pt.hasName("int")
select v
```



➤ [See this in the query console on LGTM.com](https://lgtm.com/query/860076406167044435/). You’re likely to get many results when you run this query because most projects contain many variables of type `int`.



>  在LGTM.com的查询控制台中可以看到。运行此查询时，很可能会得到许多结果，因为大多数项目都包含许多类型为int的变量。



![image-20210319172755510](https://gitee.com/samny/images/raw/master/55u27er55ec/55u27er55ec.png)



Reference types are also categorized according to their declaration scope:

> 引用类型也根据其声明范围进行分类:

* `TopLevelType` represents a reference type declared at the top-level of a compilation unit.

    > TopLevelType表示在编译单元的顶层声明的引用类型。

* `NestedType` is a type declared inside another type.

    > NestedType是在另一个类型里面声明的类型。

For instance, this query finds all top-level types whose name is not the same as that of their compilation unit:

> 例如，这个查询可以找到所有名称与其编译单元名称不同的顶层类型:

```
import java

from TopLevelType tl
where tl.getName() != tl.getCompilationUnit().getName()
select tl
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/4340983612585284460/). This pattern is seen in many projects. When we ran it on the LGTM.com demo projects, most of the projects had at least one instance of this problem in the source code. There were many more instances in the files referenced by the source code.

> ➤ 在LGTM.com的查询控制台中可以看到。这种模式在很多项目中都能看到。当我们在LGTM.com演示项目上运行时，大多数项目的源代码中至少有一个这种问题的实例。在源代码引用的文件中，还有很多实例。

![image-20210319172840606](https://gitee.com/samny/images/raw/master/40u28er40ec/40u28er40ec.png)

Several more specialized classes are available as well:

> 有几个更专业的类。

* `TopLevelClass` represents a class declared at the top-level of a compilation unit.

    > TopLevelClass表示在编译单元的顶层声明的类。

* `NestedClass`represents a class declared inside another type , such as:

    > NestedClass代表一个在另一个类型里面声明的类，如:

    * A `LocalClass`, which is [a class declared inside a method or constructor](https://docs.oracle.com/javase/tutorial/java/javaOO/localclasses.html).

        > LocalClass是一个在方法或构造函数里面声明的类。

    * An `AnonymousClass`, which is an [anonymous class](https://docs.oracle.com/javase/tutorial/java/javaOO/anonymousclasses.html).

        > AnonymousClass是一个匿名类。

Finally, the library also has a number of singleton classes that wrap frequently used Java standard library classes: `TypeObject`, `TypeCloneable`, `TypeRuntime`, `TypeSerializable`, `TypeString`, `TypeSystem` and `TypeClass`. Each CodeQL class represents the standard Java class suggested by its name.

> 最后，该库还有一些单子类，这些单子类包裹了常用的Java标准库类。TypeObject、TypeCloneable、TypeRuntime、TypeSerializable、TypeString、TypeSystem和TypeClass。每一个CodeQL类都代表了其名称所建议的标准Java类。

As an example, we can write a query that finds all nested classes that directly extend `Object`:

> 作为一个例子，我们可以写一个查询，找到所有直接扩展Object的嵌套类:



```
import java

from NestedClass nc
where nc.getASupertype() instanceof TypeObject
select nc
```



➤ [See this in the query console on LGTM.com](https://lgtm.com/query/8482509736206423238/). You’re likely to get many results when you run this query because many projects include nested classes that extend `Object` directly.

> ➤ 在LGTM.com的查询控制台中可以看到。运行此查询时，可能会得到许多结果，因为许多项目都包含直接扩展 Object 的嵌套类。 



![image-20210320173224433](https://gitee.com/samny/images/raw/master/24u32er24ec/24u32er24ec.png)



### Generics

There are also several subclasses of `Type` for dealing with generic types.

> Type还有几个子类用于处理通用类型。

A `GenericType` is either a `GenericInterface` or a `GenericClass`. It represents a generic type declaration such as interface `java.util.Map` from the Java standard library:

> 一个GenericType是一个GenericInterface或一个GenericClass。它代表一个通用类型声明，如Java标准库中的java.util.Map接口:

```
package java.util.;

public interface Map<K, V> {
    int size();

    // ...
}
```

Type parameters, such as `K` and `V` in this example, are represented by class `TypeVariable`.

> 类型参数，如本例中的K和V，由类TypeVariable表示。

A parameterized instance of a generic type provides a concrete type to instantiate the type parameter with, as in `Map<String, File>`. Such a type is represented by a `ParameterizedType`, which is distinct from the `GenericType` representing the generic type it was instantiated from. To go from a `ParameterizedType` to its corresponding `GenericType`, you can use predicate `getSourceDeclaration`.

> 一个通用类型的参数化实例提供了一个具体的类型来实例化类型参数，如Map<String, File>。这样的类型由ParameterizedType表示，它与代表它被实例化的通用类型的GenericType不同。要从一个ParameterizedType到它对应的GenericType，可以使用谓词getSourceDeclaration。

For instance, we could use the following query to find all parameterized instances of `java.util.Map`:

> 例如，我们可以使用下面的查询来查找 java.util.Map.的所有参数化实例:

```
import java

from GenericInterface map, ParameterizedType pt
where map.hasQualifiedName("java.util", "Map") and
    pt.getSourceDeclaration() = map
select pt
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/7863873821043873550/). None of the LGTM.com demo projects contain parameterized instances of `java.util.Map` in their source code, but they all have results in reference files.

> ➤ 在LGTM.com的查询控制台中可以看到。LGTM.com 演示项目的源代码中都不包含 java.util.Map 的参数化实例，但它们在参考文件中都有结果。



![image-20210320173428831](https://gitee.com/samny/images/raw/master/28u34er28ec/28u34er28ec.png)



In general, generic types may restrict which types a type parameter can be bound to. For instance, a type of maps from strings to numbers could be declared as follows:

> 一般来说，通用类型可能会限制类型参数可以绑定到哪些类型。例如，从字符串到数字的映射类型可以声明如下:

```
class StringToNumMap<N extends Number> implements Map<String, N> {
    // ...
}
```

This means that a parameterized instance of `StringToNumberMap` can only instantiate type parameter `N` with type `Number` or one of its subtypes but not, for example, with `File`. We say that N is a bounded type parameter, with `Number` as its upper bound. In QL, a type variable can be queried for its type bound using predicate `getATypeBound`. The type bounds themselves are represented by class `TypeBound`, which has a member predicate `getType` to retrieve the type the variable is bounded by.

> 这意味着StringToNumberMap的参数化实例只能用Number类型或它的一个子类型实例化类型参数N，而不能用例如File类型实例化类型参数N。我们说N是一个有界的类型参数，Number是它的上界。在QL中，可以使用谓词getATypeBound查询一个类型变量的类型边界。类型约束本身由类TypeBound表示，它有一个成员谓词getType来检索变量被约束的类型。

As an example, the following query finds all type variables with type bound `Number`:

> 作为一个例子，下面的查询可以找到所有类型绑定Number的类型变量:

```
import java

from TypeVariable tv, TypeBound tb
where tb = tv.getATypeBound() and
    tb.getType().hasQualifiedName("java.lang", "Number")
select tv
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/6740696080876162817/). When we ran it on the LGTM.com demo projects, the *neo4j/neo4j*, *hibernate/hibernate-orm* and *apache/hadoop* projects all contained examples of this pattern.

> ➤ 在LGTM.com的查询控制台中可以看到。当我们在LGTM.com的演示项目上运行时，neo4j/neo4j、hibernate/hibernate-orm和apache/hadoop项目都包含了这种模式的例子。

![image-20210403140840778](https://gitee.com/samny/images/raw/master/40u08er40ec/40u08er40ec.png)

![image-20210403140900760](https://gitee.com/samny/images/raw/master/0u09er0ec/0u09er0ec.png)

![image-20210403140909188](https://gitee.com/samny/images/raw/master/9u09er9ec/9u09er9ec.png)



For dealing with legacy code that is unaware of generics, every generic type has a “raw” version without any type parameters. In the CodeQL libraries, raw types are represented using class `RawType`, which has the expected subclasses `RawClass` and `RawInterface`. Again, there is a predicate `getSourceDeclaration` for obtaining the corresponding generic type. As an example, we can find variables of (raw) type `Map`:

> 对于处理不了解泛型的遗留代码，每个泛型都有一个没有任何类型参数的 "原始 "版本。在CodeQL库中，原始类型用类RawType表示，它有预期的子类RawClass和RawInterface。同样，有一个谓词getSourceDeclaration用于获取相应的通用类型。作为一个例子，我们可以找到（原始）类型Map的变量:

```
import java

from Variable v, RawType rt
where rt = v.getType() and
    rt.getSourceDeclaration().hasQualifiedName("java.util", "Map")
select v
```



➤ [See this in the query console on LGTM.com](https://lgtm.com/query/4032913402499547882/). Many projects have variables of raw type `Map`.

> ➤ 在LGTM.com的查询控制台中可以看到。许多项目都有原始类型Map的变量。



![image-20210403140742484](https://gitee.com/samny/images/raw/master/42u07er42ec/42u07er42ec.png)

![image-20210403140759377](https://gitee.com/samny/images/raw/master/59u07er59ec/59u07er59ec.png)

![image-20210403140817058](https://gitee.com/samny/images/raw/master/17u08er17ec/17u08er17ec.png)



For example, in the following code snippet this query would find `m1`, but not `m2`:

> 例如，在下面的代码片段中，这个查询将找到 m1，但找不到 m2:

```
Map m1 = new HashMap();
Map<String, String> m2 = new HashMap<String, String>();
```

Finally, variables can be declared to be of a [wildcard type](https://docs.oracle.com/javase/tutorial/java/generics/wildcards.html):

> 最后，变量可以被声明为通配符类型:

```
Map<? extends Number, ? super Float> m;
```

The wildcards `? extends Number` and `? super Float` are represented by class `WildcardTypeAccess`. Like type parameters, wildcards may have type bounds. Unlike type parameters, wildcards can have upper bounds (as in `? extends Number`), and also lower bounds (as in `? super Float`). Class `WildcardTypeAccess` provides member predicates `getUpperBound` and `getLowerBound` to retrieve the upper and lower bounds, respectively.

> 通配符? extends Number和? super Float由类WildcardTypeAccess表示。和类型参数一样，通配符可以有类型边界。与类型参数不同的是，通配符可以有上界（如?extends Number），也可以有下界（如?super Float）。类WildcardTypeAccess提供了成员谓词getUpperBound和getLowerBound来分别检索上界和下界。

For dealing with generic methods, there are classes `GenericMethod`, `ParameterizedMethod` and `RawMethod`, which are entirely analogous to the like-named classes for representing generic types.

> 对于处理通用方法，有GenericMethod、ParameterizedMethod和RawMethod等类，它们完全类似于表示通用类型的同名类。

For more information on working with types, see the [Types in Java](https://codeql.github.com/docs/codeql-language-guides/types-in-java/).

> 有关使用类型的更多信息，请参阅Java中的类型。

### Variables

Class `Variable` represents a variable [in the Java sense](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html), which is either a member field of a class (whether static or not), or a local variable, or a parameter. Consequently, there are three subclasses catering to these special cases:

> 类变量表示Java意义上的变量，它既可以是一个类的成员字段（不管是静态的还是非静态的），也可以是一个局部变量，或者是一个参数。因此，有三个子类迎合了这些特殊情况:

* `Field` represents a Java field. Field代表一个Java字段。
* `LocalVariableDecl` represents a local variable.  LocalVariableDecl代表一个局部变量。
* `Parameter` represents a parameter of a method or constructor. Parameter代表一个方法或构造函数的参数。

## Abstract syntax tree

Classes in this category represent abstract syntax tree (AST) nodes, that is, statements (class `Stmt`) and expressions (class `Expr`). For a full list of expression and statement types available in the standard QL library, see “[Abstract syntax tree classes for working with Java programs](https://codeql.github.com/docs/codeql-language-guides/abstract-syntax-tree-classes-for-working-with-java-programs/).”

> 这一类的类代表抽象语法树（AST）节点，即语句（类Stmt）和表达式（类Expr）。关于标准QL库中可用的表达式和语句类型的完整列表，请参见 "用于处理Java程序的抽象语法树类"。

Both `Expr` and `Stmt` provide member predicates for exploring the abstract syntax tree of a program:

> Expr和Stmt都提供了用于探索程序的抽象语法树的成员谓词。

* `Expr.getAChildExpr` returns a sub-expression of a given expression. 

    > Expr.getAChildExpr返回一个给定表达式的子表达式。

* `Stmt.getAChild` returns a statement or expression that is nested directly inside a given statement.

    > Stmt.getAChild返回一个直接嵌套在给定语句中的语句或表达式。

* `Expr.getParent` and `Stmt.getParent` return the parent node of an AST node.

    > Expr.getParent和Stmt.getParent返回一个AST节点的父节点。

For example, the following query finds all expressions whose parents are `return` statements:

> 例如，下面的查询可以找到所有父母是返回语句的表达式:

```
import java

from Expr e
where e.getParent() instanceof ReturnStmt
select e
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/1947757851560375919/). Many projects have examples of `return` statements with child expressions.

> ➤ 在LGTM.com的查询控制台中可以看到。很多项目都有返回语句与子表达式的例子。

![image-20210403140957983](https://gitee.com/samny/images/raw/master/58u09er58ec/58u09er58ec.png)

![image-20210403141011087](https://gitee.com/samny/images/raw/master/11u10er11ec/11u10er11ec.png)





Therefore, if the program contains a return statement `return x + y;`, this query will return `x + y`.

> 因此，如果程序中包含一个返回语句return x + y;，这个查询将返回x + y。

As another example, the following query finds statements whose parent is an `if` statement:

> 作为另一个例子，下面的查询可以找到父语句是if语句的语句:

```
import java

from Stmt s
where s.getParent() instanceof IfStmt
select s
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/1989464153689219612/). Many projects have examples of `if` statements with child statements.

> ➤ 在LGTM.com的查询控制台中可以看到。很多项目都有if语句与子语句的例子。



![image-20210403141127739](https://gitee.com/samny/images/raw/master/27u11er27ec/27u11er27ec.png)

![image-20210403141143544](https://gitee.com/samny/images/raw/master/43u11er43ec/43u11er43ec.png)



This query will find both `then` branches and `else` branches of all `if` statements in the program.

> 这个查询可以找到程序中所有if语句的then分支和 else分支。

Finally, here is a query that finds method bodies:

> 最后，这里是一个查找方法体的查询:

```
import java

from Stmt s
where s.getParent() instanceof Method
select s
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/1016821702972128245/). Most projects have many method bodies.

> ➤ 在LGTM.com的查询控制台中可以看到。大多数项目都有许多方法体。



![image-20210403141206903](https://gitee.com/samny/images/raw/master/23u12er23ec/23u12er23ec.png)

![image-20210403141218104](https://gitee.com/samny/images/raw/master/20u12er20ec/20u12er20ec.png)



As these examples show, the parent node of an expression is not always an expression: it may also be a statement, for example, an `IfStmt`. Similarly, the parent node of a statement is not always a statement: it may also be a method or a constructor. To capture this, the QL Java library provides two abstract class `ExprParent` and `StmtParent`, the former representing any node that may be the parent node of an expression, and the latter any node that may be the parent node of a statement.

> 正如这些示例所示，一个表达式的父节点并不总是一个表达式：它也可能是一个语句，例如，一个 IfStmt。同样，一个语句的父节点也不总是一个语句：它也可能是一个方法或构造函数。为了抓住这一点，QL Java库提供了两个抽象类ExprParent和StmtParent，前者代表任何可能是表达式的父节点，后者代表任何可能是语句的父节点。

For more information on working with AST classes, see the [article on overflow-prone comparisons in Java](https://codeql.github.com/docs/codeql-language-guides/overflow-prone-comparisons-in-java/).

> 有关使用AST类的更多信息，请参见 [article on overflow-prone comparisons in Java](https://codeql.github.com/docs/codeql-language-guides/overflow-prone-comparisons-in-java/).。

## Metadata

Java programs have several kinds of metadata, in addition to the program code proper. In particular, there are [annotations](https://docs.oracle.com/javase/tutorial/java/annotations/) and [Javadoc](https://en.wikipedia.org/wiki/Javadoc) comments. Since this metadata is interesting both for enhancing code analysis and as an analysis subject in its own right, the QL library defines classes for accessing it.

> Java程序除了程序代码本身外，还有几种元数据。特别是有注释和Javadoc注释。由于这些元数据对于增强代码分析和作为分析对象本身都很有趣，QL库定义了用于访问这些元数据的类。

For annotations, class `Annotatable` is a superclass of all program elements that can be annotated. This includes packages, reference types, fields, methods, constructors, and local variable declarations. For every such element, its predicate `getAnAnnotation` allows you to retrieve any annotations the element may have. For example, the following query finds all annotations on constructors:

> 对于注释，类Annotatable是所有可以注释的程序元素的超类。这包括包、引用类型、字段、方法、构造器和局部变量声明。对于每一个这样的元素，它的谓词getAnAnnotation允许你检索该元素可能拥有的任何注释。例如，下面的查询可以找到所有关于构造函数的注解:

```
import java

from Constructor c
select c.getAnAnnotation()
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/3206112561297137365/). The LGTM.com demo projects all use annotations, you can see examples where they are used to suppress warnings and mark code as deprecated.

> ➤ 在 LGTM.com 的查询控制台中可以看到。LGTM.com 演示项目都使用了注解，您可以看到使用注解来抑制警告和将代码标记为废弃的例子。



![image-20210403141254733](https://gitee.com/samny/images/raw/master/54u12er54ec/54u12er54ec.png)

![image-20210403141306146](https://gitee.com/samny/images/raw/master/6u13er6ec/6u13er6ec.png)

![image-20210403141313866](https://gitee.com/samny/images/raw/master/13u13er13ec/13u13er13ec.png)



These annotations are represented by class `Annotation`. An annotation is simply an expression whose type is an `AnnotationType`. For example, you can amend this query so that it only reports deprecated constructors:

> 这些注解由类Annotation表示。注释是一个简单的表达式，其类型是AnnotationType。例如，你可以修改这个查询，使它只报告废弃的构造函数:

```
import java

from Constructor c, Annotation ann, AnnotationType anntp
where ann = c.getAnAnnotation() and
    anntp = ann.getType() and
    anntp.hasQualifiedName("java.lang", "Deprecated")
select ann
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/5393027107459215059/). Only constructors with the `@Deprecated` annotation are reported this time.

> ➤ 在LGTM.com的查询控制台中可以看到。这次只报告带有 @Deprecated 注解的构造函数。



![image-20210403141336606](https://gitee.com/samny/images/raw/master/36u13er36ec/36u13er36ec.png)

![image-20210403141348167](https://gitee.com/samny/images/raw/master/48u13er48ec/48u13er48ec.png)

![image-20210403141356069](https://gitee.com/samny/images/raw/master/56u13er56ec/56u13er56ec.png)



For more information on working with annotations, see the [article on annotations](https://codeql.github.com/docs/codeql-language-guides/annotations-in-java/).

> 有关使用注解的更多信息，请参阅关于注解的文章。

For Javadoc, class `Element` has a member predicate `getDoc` that returns a delegate `Documentable` object, which can then be queried for its attached Javadoc comments. For example, the following query finds Javadoc comments on private fields:

> 对于Javadoc来说，类Element有一个成员谓词getDoc，它可以返回一个委派的Documentable对象，然后可以查询其附加的Javadoc注释。例如，下面的查询可以找到私有字段的Javadoc注释:

```
import java

from Field f, Javadoc jdoc
where f.isPrivate() and
    jdoc = f.getDoc().getJavadoc()
select jdoc
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/6022769142134600659/). You can see this pattern in many projects.

> ➤ 在LGTM.com的查询控制台中可以看到。在很多项目中都可以看到这种模式。



![image-20210403141421800](https://gitee.com/samny/images/raw/master/21u14er21ec/21u14er21ec.png)

![image-20210403141431722](https://gitee.com/samny/images/raw/master/31u14er31ec/31u14er31ec.png)



Class `Javadoc` represents an entire Javadoc comment as a tree of `JavadocElement` nodes, which can be traversed using member predicates `getAChild` and `getParent`. For instance, you could edit the query so that it finds all `@author` tags in Javadoc comments on private fields:

> 类 Javadoc 将整个 Javadoc 注释表示为 JavadocElement 节点的树，可以使用成员谓词 getAChild 和 getParent 遍历。例如，你可以编辑查询，使其找到私有字段的Javadoc注释中的所有@author标签:

```
import java

from Field f, Javadoc jdoc, AuthorTag at
where f.isPrivate() and
    jdoc = f.getDoc().getJavadoc() and
    at.getParent+() = jdoc
select at
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/2510220694395289111/). None of the LGTM.com demo projects uses the `@author` tag on private fields.

> ➤ 在 LGTM.com 的查询控制台中可以看到。LGTM.com 演示项目中没有一个在私有字段上使用 @author 标签。





> Note
>
> On line 5 we used `getParent+` to capture tags that are nested at any depth within the Javadoc comment.
>
> 在第5行，我们使用getParent+来捕获Javadoc注释中任意深度嵌套的标签。

For more information on working with Javadoc, see the [article on Javadoc](https://codeql.github.com/docs/codeql-language-guides/javadoc/).

> 关于使用 Javadoc 的更多信息，请看关于 Javadoc 的文章。

## Metrics

The standard QL Java library provides extensive support for computing metrics on Java program elements. To avoid overburdening the classes representing those elements with too many member predicates related to metric computations, these predicates are made available on delegate classes instead.

> 标准QL Java库为Java程序元素的度量计算提供了广泛的支持。为了避免与度量计算相关的成员谓词过多而给代表这些元素的类造成过重的负担，这些谓词被放在委托类上。

Altogether, there are six such classes: `MetricElement`, `MetricPackage`, `MetricRefType`, `MetricField`, `MetricCallable`, and `MetricStmt`. The corresponding element classes each provide a member predicate `getMetrics` that can be used to obtain an instance of the delegate class, on which metric computations can then be performed.

> 一共有六个这样的类。MetricElement、MetricPackage、MetricRefType、MetricField、MetricCallable和MetricStmt。相应的元素类都提供了一个成员谓词getMetrics，可以用来获取委托类的实例，然后在这个实例上进行度量计算。

For example, the following query finds methods with a [cyclomatic complexity](https://en.wikipedia.org/wiki/Cyclomatic_complexity) greater than 40:

> 例如，下面的查询可以找到循环复杂度大于40的方法:

```
import java

from Method m, MetricCallable mc
where mc = m.getMetrics() and
    mc.getCyclomaticComplexity() > 40
select m
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/6566950741051181919/). Most large projects include some methods with a very high cyclomatic complexity. These methods are likely to be difficult to understand and test.

> ➤ 在LGTM.com的查询控制台中可以看到。大多数大型项目都包括一些具有非常高循环复杂性的方法。这些方法可能难以理解和测试。



![image-20210403141526423](https://gitee.com/samny/images/raw/master/26u15er26ec/26u15er26ec.png)

![image-20210403141546581](https://gitee.com/samny/images/raw/master/46u15er46ec/46u15er46ec.png)

![](https://gitee.com/samny/images/raw/master/38u15er38ec/38u15er38ec.png)





## Call graph

CodeQL databases generated from Java code bases include precomputed information about the program’s call graph, that is, which methods or constructors a given call may dispatch to at runtime.

> 由Java代码库生成的CodeQL数据库中包含了关于程序调用图的预计算信息，即一个给定的调用在运行时可能会派发给哪些方法或构造函数。

The class `Callable`, introduced above, includes both methods and constructors. Call expressions are abstracted using class `Call`, which includes method calls, `new` expressions, and explicit constructor calls using `this` or `super`.

> 上文介绍的类Callable既包括方法，也包括构造器。调用表达式是用类Call抽象出来的，它包括方法调用、新表达式和使用this或super的显式构造函数调用。

We can use predicate `Call.getCallee` to find out which method or constructor a specific call expression refers to. For example, the following query finds all calls to methods called `println`:

> 我们可以使用谓词Call.getCallee来查找一个特定的调用表达式指的是哪个方法或构造函数。例如，下面的查询可以找到所有调用println的方法:

```
import java

from Call c, Method m
where m = c.getCallee() and
    m.hasName("println")
select c
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/5861255162551917595/). The LGTM.com demo projects all include many calls to methods of this name.

> ➤ 在LGTM.com的查询控制台中可以看到。LGTM.com 的演示项目都包含许多对这个名称的方法的调用。



![image-20210403141611245](https://gitee.com/samny/images/raw/master/11u16er11ec/11u16er11ec.png)

![image-20210403141623796](https://gitee.com/samny/images/raw/master/23u16er23ec/23u16er23ec.png)



Conversely, `Callable.getAReference` returns a `Call` that refers to it. So we can find methods and constructors that are never called using this query:

> 反之，Callable.getAReference返回一个引用它的Call。所以我们可以使用这个查询找到从未被调用的方法和构造函数:

```
import java

from Callable c
where not exists(c.getAReference())
select c
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/7261739919657747703/). The LGTM.com demo projects all appear to have many methods that are not called directly, but this is unlikely to be the whole story. To explore this area further, see “[Navigating the call graph](https://codeql.github.com/docs/codeql-language-guides/navigating-the-call-graph/).”

> ➤ 在LGTM.com的查询控制台中可以看到。LGTM.com 演示项目似乎都有许多方法没有被直接调用，但这不可能是全部。要进一步探索这个领域，请参见 "导航调用图"。



![image-20210403141639213](https://gitee.com/samny/images/raw/master/39u16er39ec/39u16er39ec.png)

![image-20210403141650173](https://gitee.com/samny/images/raw/master/57u16er57ec/57u16er57ec.png)

![image-20210403141657082](https://gitee.com/samny/images/raw/master/57u16er57ec/57u16er57ec.png)



For more information about callables and calls, see the [article on the call graph](https://codeql.github.com/docs/codeql-language-guides/navigating-the-call-graph/).

> 关于可调用和调用的更多信息，请参见关于调用图的文章。

## Further reading

* [CodeQL queries for Java](https://github.com/github/codeql/tree/main/java/ql/src)
* [Example queries for Java](https://github.com/github/codeql/tree/main/java/ql/examples)
* [CodeQL library reference for Java](https://codeql.github.com/codeql-standard-libraries/java/)

* “[QL language reference](https://codeql.github.com/docs/ql-language-reference/#ql-language-reference)”
* “[CodeQL tools](https://codeql.github.com/docs/codeql-overview/codeql-tools/#codeql-tools)”
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
