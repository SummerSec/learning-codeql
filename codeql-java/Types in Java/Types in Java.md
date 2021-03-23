# Types in Java[¶](https://codeql.github.com/docs/codeql-language-guides/types-in-java/#types-in-java)

You can use CodeQL to find out information about data types used in Java code. This allows you to write queries to identify specific type-related issues.

> 您可以使用CodeQL来查找Java代码中使用的数据类型的信息。这允许您编写查询以确定特定的类型相关问题。

## About working with Java types

The standard CodeQL library represents Java types by means of the `Type` class and its various subclasses.

> 标准CodeQL库通过Type类及其各种子类来表示Java类型。

In particular, class `PrimitiveType` represents primitive types that are built into the Java language (such as `boolean` and `int`), whereas `RefType` and its subclasses represent reference types, that is classes, interfaces, array types, and so on. This includes both types from the Java standard library (like `java.lang.Object`) and types defined by non-library code.

> 特别是，类PrimitiveType表示Java语言中内置的基元类型（如boolean和int），而RefType及其子类则表示引用类型，即类、接口、数组类型等。其中既包括Java标准库中的类型（如java.lang.Object），也包括非库代码定义的类型。

Class `RefType` also models the class hierarchy: member predicates `getASupertype` and `getASubtype` allow you to find a reference type’s immediate super types and sub types. For example, consider the following Java program:

> 类RefType还对类的层次结构进行了建模：成员谓词getASupertype和getASubtype允许你找到一个引用类型的直属超类型和子类型。例如，考虑以下Java程序:

```
class A {}

interface I {}

class B extends A implements I {}
```

Here, class `A` has exactly one immediate super type (`java.lang.Object`) and exactly one immediate sub type (`B`); the same is true of interface `I`. Class `B`, on the other hand, has two immediate super types (`A` and `I`), and no immediate sub types.

> 在这里，类A正好有一个直系超级类型（java.lang.Object）和一个直系子类型（B）；接口I也是如此；而类B则有两个直系超级类型（A和I），没有直系子类型。

To determine ancestor types (including immediate super types, and also *their* super types, etc.), we can use transitive closure. For example, to find all ancestors of `B` in the example above, we could use the following query:

> 为了确定祖先类型（包括直系超类型，也包括它们的超类型等），我们可以使用转义闭包。例如，要找到上面例子中B的所有祖先，我们可以使用下面的查询:

```
import java

from Class B
where B.hasName("B")
select B.getASupertype+()
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/1506430738755934285/). If this query were run on the example snippet above, the query would return `A`, `I`, and `java.lang.Object`.

> ➤ 在LGTM.com的查询控制台中可以看到。如果在上面的示例片段上运行此查询，查询将返回 A、I 和 java.lang.Object。

> Tip
>
> If you want to see the location of `B` as well as `A`, you can replace `B.getASupertype+()` with `B.getASupertype*()` and re-run the query.
>
> 如果想查看B的位置以及A的位置，可以将B.getASupertype+()替换为B.getASupertype*()，然后重新运行查询。

Besides class hierarchy modeling, `RefType` also provides member predicate `getAMember` for accessing members (that is, fields, constructors, and methods) declared in the type, and predicate `inherits(Method m)` for checking whether the type either declares or inherits a method `m`.

> 除了类的层次结构建模，RefType还提供了成员谓词getAMember用于访问在类型中声明的成员(即字段、构造函数和方法)，以及谓词 inherits(Method m)用于检查类型是否声明或继承了方法m。

## Example: Finding problematic array casts

As an example of how to use the class hierarchy API, we can write a query that finds downcasts on arrays, that is, cases where an expression `e` of some type `A[]` is converted to type `B[]`, such that `B` is a (not necessarily immediate) subtype of `A`.

> 作为如何使用类层次结构 API 的一个例子，我们可以写一个查询来查找数组上的降维，也就是将某个类型 A[]的表达式 e 转换为类型 B[]的情况，这样 B 就是 A 的一个（不一定是直接）子类型。

This kind of cast is problematic, since downcasting an array results in a runtime exception, even if every individual array element could be downcast. For example, the following code throws a `ClassCastException`:

> 这种类型的转码是有问题的，因为即使每个数组元素都可以被转码，但降码一个数组会导致一个运行时异常。例如，下面的代码会抛出一个ClassCastException:

```
Object[] o = new Object[] { "Hello", "world" };
String[] s = (String[])o;
```

If the expression `e` happens to actually evaluate to a `B[]` array, on the other hand, the cast will succeed:

> 另一方面，如果表达式e恰好真的评估为一个B[]数组，那么投值就会成功:

```
Object[] o = new String[] { "Hello", "world" };
String[] s = (String[])o;
```

In this tutorial, we don’t try to distinguish these two cases. Our query should simply look for cast expressions `ce` that cast from some type `source` to another type `target`, such that:

> 在本教程中，我们不试图区分这两种情况。我们的查询应该简单地寻找从某个类型的源投射到另一个类型的目标的投射表达式ce，这样:

* Both `source` and `target` are array types. 源和目标都是数组类型
* The element type of `source` is a transitive super type of the element type of `target`. source的元素类型是target的元素类型的转义超类型。

This recipe is not too difficult to translate into a query:

> 这个口诀翻译成查询并不难:

```
import java

from CastExpr ce, Array source, Array target
where source = ce.getExpr().getType() and
    target = ce.getType() and
    target.getElementType().(RefType).getASupertype+() = source.getElementType()
select ce, "Potentially problematic array downcast."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/8378564667548381869/). Many projects return results for this query.

> ➤ 在LGTM.com的查询控制台中可以看到。许多项目都会返回此查询的结果。

Note that by casting `target.getElementType()` to a `RefType`, we eliminate all cases where the element type is a primitive type, that is, `target` is an array of primitive type: the problem we are looking for cannot arise in that case. Unlike in Java, a cast in QL never fails: if an expression cannot be cast to the desired type, it is simply excluded from the query results, which is exactly what we want.

> 请注意，通过将 target.getElementType() 铸造为 RefType，我们消除了元素类型是基元类型的所有情况，即 target 是基元类型的数组：在这种情况下不能出现我们要找的问题。与Java中不同的是，QL中的转置永远不会失败：如果一个表达式不能被转置到所需的类型，它就会被排除在查询结果之外，这正是我们想要的。

### Improvements

Running this query on old Java code, before version 5, often returns many false positive results arising from uses of the method `Collection.toArray(T[])`, which converts a collection into an array of type `T[]`.

> 在版本5之前的旧Java代码上运行这个查询，经常会返回许多假阳性结果，这是因为使用了Collection.toArray(T[])方法，该方法将一个集合转换为T[]类型的数组。

In code that does not use generics, this method is often used in the following way:

> 在不使用泛型的代码中，这个方法经常以如下方式使用:

```
List l = new ArrayList();
// add some elements of type A to l
A[] as = (A[])l.toArray(new A[0]);
```

Here, `l` has the raw type `List`, so `l.toArray` has return type `Object[]`, independent of the type of its argument array. Hence the cast goes from `Object[]` to `A[]` and will be flagged as problematic by our query, although at runtime this cast can never go wrong.

> 这里，l具有原始类型List，所以l.toArray的返回类型是Object[]，与其参数数组的类型无关。因此，从Object[]到A[]的转码会被我们的查询标记为有问题，尽管在运行时这个转码永远不会出错。

To identify these cases, we can create two CodeQL classes that represent, respectively, the `Collection.toArray` method, and calls to this method or any method that overrides it:

> 为了识别这些情况，我们可以创建两个CodeQL类，分别代表Collection.toArray方法，以及对这个方法或任何覆盖它的方法的调用。

```
/** class representing java.util.Collection.toArray(T[]) */
/**代表java.util.Collection.toArray(T[])的类 */

class CollectionToArray extends Method {
    CollectionToArray() {
        this.getDeclaringType().hasQualifiedName("java.util", "Collection") and
        this.hasName("toArray") and
        this.getNumberOfParameters() = 1
    }
}

/** class representing calls to java.util.Collection.toArray(T[]) */
/**代表对java.util.Collection.toArray(T[])的调用的类 ***

class CollectionToArrayCall extends MethodAccess {
    CollectionToArrayCall() {
        exists(CollectionToArray m |
            this.getMethod().getSourceDeclaration().overridesOrInstantiates*(m)
        )
    }

    /** the call's actual return type, as determined from its argument */
        /** 调用的实际返回类型，由其参数决定*/*。

    Array getActualReturnType() {
        result = this.getArgument(0).getType()
    }
}
```

Notice the use of `getSourceDeclaration` and `overridesOrInstantiates` in the constructor of `CollectionToArrayCall`: we want to find calls to `Collection.toArray` and to any method that overrides it, as well as any parameterized instances of these methods. In our example above, for instance, the call `l.toArray` resolves to method `toArray` in the raw class `ArrayList`. Its source declaration is `toArray` in the generic class `ArrayList<T>`, which overrides `AbstractCollection<T>.toArray`, which in turn overrides `Collection<T>.toArray`, which is an instantiation of `Collection.toArray` (since the type parameter `T` in the overridden method belongs to `ArrayList` and is an instantiation of the type parameter belonging to `Collection`).

> 注意在CollectionToArrayCall的构造函数中使用了getSourceDeclaration和overridesOrInstantiates：我们要找到对Collection.toArray和任何覆盖它的方法的调用，以及这些方法的任何参数化实例。例如，在我们上面的例子中，调用l.toArray解析到原始类ArrayList中的方法toArray。它的源声明是通用类ArrayList<T>中的toArray，它覆盖了AbstractCollection<T>.toArray，而AbstractCollection<T>.toArray又覆盖了Collection<T>.toArray，它是Collection.toArray的一个实例化（因为覆盖方法中的类型参数T属于ArrayList，是属于Collection的类型参数的实例化）。

Using these new classes we can extend our query to exclude calls to `toArray` on an argument of type `A[]` which are then cast to `A[]`:

> 使用这些新的类，我们可以扩展我们的查询，以排除对A[]类型参数的toArray的调用，然后将其投向A[]:

```
import java

// Insert the class definitions from above

from CastExpr ce, Array source, Array target
where source = ce.getExpr().getType() and
    target = ce.getType() and
    target.getElementType().(RefType).getASupertype+() = source.getElementType() and
    not ce.getExpr().(CollectionToArrayCall).getActualReturnType() = target
select ce, "Potentially problematic array downcast."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/3150404889854131463/). Notice that fewer results are found by this improved query.

> ➤ 在LGTM.com的查询控制台中可以看到。请注意，通过这种改进的查询找到的结果较少。

## Example: Finding mismatched contains checks

We’ll now develop a query that finds uses of `Collection.contains` where the type of the queried element is unrelated to the element type of the collection, which guarantees that the test will always return `false`.

> 现在我们将开发一个查询，找到Collection.contains的用法，其中被查询的元素类型与集合的元素类型无关，这就保证了测试将总是返回false。

For example, [Apache Zookeeper](https://zookeeper.apache.org/) used to have a snippet of code similar to the following in class `QuorumPeerConfig`:

> 例如，Apache Zookeeper曾经在类QuorumPeerConfig中，有一段类似于下面的代码:

```
Map<Object, Object> zkProp;

// ...

if (zkProp.entrySet().contains("dynamicConfigFile")){
    // ...
}
```

Since `zkProp` is a map from `Object` to `Object`, `zkProp.entrySet` returns a collection of type `Set<Entry<Object, Object>>`. Such a set cannot possibly contain an element of type `String`. (The code has since been fixed to use `zkProp.containsKey`.)

> 由于zkProp是一个从Object到Object的映射，所以zkProp.entrySet返回一个类型为Set<Entry<Object，Object>>的集合。这样的集合不可能包含一个String类型的元素。(这段代码后来被修正为使用zkProp.containsKey)。

In general, we want to find calls to `Collection.contains` (or any of its overriding methods in any parameterized instance of `Collection`), such that the type `E` of collection elements and the type `A` of the argument to `contains` are unrelated, that is, they have no common subtype.

> 一般来说，我们希望找到对Collection.contains的调用（或者在Collection的任何参数化实例中找到它的任何覆盖方法），这样集合元素的类型E和contains参数的类型A是不相关的，也就是说，它们没有共同的子类型。

We start by creating a class that describes `java.util.Collection`:

> 我们先创建一个描述java.util.Collection的类:

```
class JavaUtilCollection extends GenericInterface {
    JavaUtilCollection() {
        this.hasQualifiedName("java.util", "Collection")
    }
}
```

To make sure we have not mistyped anything, we can run a simple test query:

> 为了确保我们没有输入错误，我们可以运行一个简单的测试查询:

```
from JavaUtilCollection juc
select juc
```

This query should return precisely one result.

> 这个查询应该正好返回一个结果。

Next, we can create a class that describes `java.util.Collection.contains`:

> 接下来，我们可以创建一个描述java.util.Collection.contains的类。

```
class JavaUtilCollectionContains extends Method {
    JavaUtilCollectionContains() {
        this.getDeclaringType() instanceof JavaUtilCollection and
        this.hasStringSignature("contains(Object)")
    }
}
```

Notice that we use `hasStringSignature` to check that:

> 注意，我们使用hasStringSignature来检查:

* The method in question has name `contains`. 这个方法的名字`contains`..
* It has exactly one argument.它正好有一个参数。
* The type of the argument is `Object`.参数的类型是Object。

Alternatively, we could have implemented these three checks more verbosely using `hasName`, `getNumberOfParameters`, and `getParameter(0).getType() instanceof TypeObject`.

> 另外，我们还可以使用hasName、getNumberOfParameters和getParameter(0).getType()instanceofTypeObject更详细地实现这三个检查。

As before, it is a good idea to test the new class by running a simple query to select all instances of `JavaUtilCollectionContains`; again there should only be a single result.

> 和之前一样，通过运行一个简单的查询来选择JavaUtilCollectionContains的所有实例来测试新类是个好主意；同样应该只有一个结果。

Now we want to identify all calls to `Collection.contains`, including any methods that override it, and considering all parameterized instances of `Collection` and its subclasses. That is, we are looking for method accesses where the source declaration of the invoked method (reflexively or transitively) overrides `Collection.contains`. We encode this in a CodeQL class `JavaUtilCollectionContainsCall`:

> 现在我们要识别所有对Collection.contains的调用，包括任何覆盖它的方法，并考虑Collection及其子类的所有参数化实例。也就是说，我们要寻找被调用方法的源声明（反射性的或过渡性的）覆盖Collection.contains的方法访问。我们将其编码在一个CodeQL类JavaUtilCollectionContainsCall中:

```
class JavaUtilCollectionContainsCall extends MethodAccess {
    JavaUtilCollectionContainsCall() {
        exists(JavaUtilCollectionContains jucc |
            this.getMethod().getSourceDeclaration().overrides*(jucc)
        )
    }
}
```

This definition is slightly subtle, so you should run a short query to test that `JavaUtilCollectionContainsCall` correctly identifies calls to `Collection.contains`.

> 这个定义略显微妙，所以你应该运行一个简短的查询来测试JavaUtilCollectionContainsCall是否能正确识别对Collection.contains的调用。

For every call to `contains`, we are interested in two things: the type of the argument, and the element type of the collection on which it is invoked. So we need to add two member predicates `getArgumentType` and `getCollectionElementType` to class `JavaUtilCollectionContainsCall` to compute this information.\

> 对于每一个对contains的调用，我们对两件事感兴趣：参数的类型，以及它被调用的集合的元素类型。所以我们需要在类JavaUtilCollectionContainsCall中添加两个成员谓词getArgumentType和getCollectionElementType来计算这些信息。

The former is easy:

> 前者很简单:

```
Type getArgumentType() {
    result = this.getArgument(0).getType()
}
```

For the latter, we proceed as follows:

> 对于后者，我们的操作如下:

* Find the declaring type `D` of the `contains` method being invoked. 找到被调用的包含方法的声明类型D.
* Find a (reflexive or transitive) super type `S` of `D` that is a parameterized instance of `java.util.Collection`.找到D的一个（反射型或转义型）超级类型S，它是java.util.Collection的参数化实例。
* Return the (only) type argument of `S`.返回S的（唯一）类型参数。

We encode this as follows:

> 我们将其编码如下:

```
Type getCollectionElementType() {
    exists(RefType D, ParameterizedInterface S |
        D = this.getMethod().getDeclaringType() and
        D.hasSupertype*(S) and S.getSourceDeclaration() instanceof JavaUtilCollection and
        result = S.getTypeArgument(0)
    )
}
```

Having added these two member predicates to `JavaUtilCollectionContainsCall`, we need to write a predicate that checks whether two given reference types have a common subtype:

> 在给JavaUtilCollectionContainsCall添加了这两个成员谓词后，我们需要写一个谓词来检查两个给定的引用类型是否有共同的子类型:

```
predicate haveCommonDescendant(RefType tp1, RefType tp2) {
    exists(RefType commondesc | commondesc.hasSupertype*(tp1) and commondesc.hasSupertype*(tp2))
}
```

Now we are ready to write a first version of our query:

> 现在我们准备好写第一个版本的查询:

```
import java

// Insert the class definitions from above

from JavaUtilCollectionContainsCall juccc, Type collEltType, Type argType
where collEltType = juccc.getCollectionElementType() and argType = juccc.getArgumentType() and
    not haveCommonDescendant(collEltType, argType)
select juccc, "Element type " + collEltType + " is incompatible with argument type " + argType
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/7947831380785106258/).

> ➤ 在LGTM.com的查询控制台中查看。

### Improvements

For many programs, this query yields a large number of false positive results due to type variables and wild cards: if the collection element type is some type variable `E` and the argument type is `String`, for example, CodeQL will consider that the two have no common subtype, and our query will flag the call. An easy way to exclude such false positive results is to simply require that neither `collEltType` nor `argType` are instances of `TypeVariable`.

> 对于很多程序来说，由于类型变量和通配符的原因，这个查询会产生大量的假阳性结果：例如，如果集合元素类型是某个类型变量E，而参数类型是String，CodeQL会认为两者没有共同的子类型，我们的查询就会标记调用。排除这种假阳性结果的一个简单方法是简单地要求 collEltType 和 argType 都不是 TypeVariable 的实例。

Another source of false positives is autoboxing of primitive types: if, for example, the collection’s element type is `Integer` and the argument is of type `int`, predicate `haveCommonDescendant` will fail, since `int` is not a `RefType`. To account for this, our query should check that `collEltType` is not the boxed type of `argType`.

> 另一个误报的来源是基元类型的自动装箱：例如，如果集合的元素类型是Integer，而参数的类型是int，那么谓词haveCommonDescendant将失败，因为int不是RefType。为了说明这一点，我们的查询应该检查 collEltType 不是 argType 的框定类型。

Finally, `null` is special because its type (known as `<nulltype>` in the CodeQL library) is compatible with every reference type, so we should exclude it from consideration.

> 最后，null是特殊的，因为它的类型（在CodeQL库中称为<nulltype>）与每个引用类型都是兼容的，所以我们应该把它排除在考虑范围之外。

Adding these three improvements, our final query becomes:

> 加上这三项改进，我们的最终查询就变成了。

```
import java

// Insert the class definitions from above
// 插入上面的类定义
from JavaUtilCollectionContainsCall juccc, Type collEltType, Type argType
where collEltType = juccc.getCollectionElementType() and argType = juccc.getArgumentType() and
    not haveCommonDescendant(collEltType, argType) and
    not collEltType instanceof TypeVariable and not argType instanceof TypeVariable and
    not collEltType = argType.(PrimitiveType).getBoxedType() and
    not argType.hasName("<nulltype>")
select juccc, "Element type " + collEltType + " is incompatible with argument type " + argType
```

➤ [See the full query in the query console on LGTM.com](https://lgtm.com/query/8846334903769538099/).

> ➤ 在LGTM.com的查询控制台中查看完整的查询。