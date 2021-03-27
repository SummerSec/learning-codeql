# Javadoc[¶](https://codeql.github.com/docs/codeql-language-guides/javadoc/#javadoc)

You can use CodeQL to find errors in Javadoc comments in Java code.

> 您可以使用CodeQL来查找Java代码中Javadoc注释的错误。

## About analyzing Javadoc

To access Javadoc associated with a program element, we use member predicate `getDoc` of class `Element`, which returns a `Documentable`. Class `Documentable`, in turn, offers a member predicate `getJavadoc` to retrieve the Javadoc attached to the element in question, if any.

> 要访问与程序元素相关联的 Javadoc，我们使用 Element 类的成员谓词 getDoc，它返回一个 Documentable。类Documentable则提供了一个成员谓词getJavadoc来检索与相关元素相关的Javadoc，如果有的话。

Javadoc comments are represented by class `Javadoc`, which provides a view of the comment as a tree of `JavadocElement` nodes. Each `JavadocElement` is either a `JavadocTag`, representing a tag, or a `JavadocText`, representing a piece of free-form text.

> Javadoc注释由类Javadoc表示，它提供了一个注释的视图，即JavadocElement节点的树。每个 JavadocElement 要么是一个 JavadocTag，代表一个标签，要么是一个 JavadocText，代表一段自由格式的文本。

The most important member predicates of class `Javadoc` are:

> Javadoc类最重要的成员谓词是:

* `getAChild` - retrieves a top-level `JavadocElement` node in the tree representation.

    > getAChild - 检索树型表示中的一个顶层JavadocElement节点。

* `getVersion` - returns the value of the `@version` tag, if any.

    > getVersion - 返回@version标签的值（如果有的话）。

* `getAuthor` - returns the value of the `@author` tag, if any.

    > getAuthor - 如果有的话，返回@author标签的值。

For example, the following query finds all classes that have both an `@author` tag and a `@version` tag, and returns this information:

> 例如，下面的查询可以找到所有同时拥有@author标签和@version标签的类，并返回这些信息:

```
import java

from Class c, Javadoc jdoc, string author, string version
where jdoc = c.getDoc().getJavadoc() and
    author = jdoc.getAuthor() and
    version = jdoc.getVersion()
select c, author, version
```

![image-20210327132707004](https://gitee.com/samny/images/raw/master/7u27er7ec/7u27er7ec.png)

![image-20210327132717979](https://gitee.com/samny/images/raw/master/18u27er18ec/18u27er18ec.png)

`JavadocElement` defines member predicates `getAChild` and `getParent` to navigate up and down the tree of elements. It also provides a predicate `getTagName` to return the tag’s name, and a predicate `getText` to access the text associated with the tag.

> JavadocElement 定义了成员谓词 getAChild 和 getParent，用于在元素树中上下导航。它还提供了一个谓词 getTagName 来返回标记的名称，以及一个谓词 getText 来访问与标记相关的文本。

We could rewrite the above query to use this API instead of `getAuthor` and `getVersion`:

> 我们可以重写上面的查询，使用这个API代替getAuthor和getVersion:

```
import java

from Class c, Javadoc jdoc, JavadocTag authorTag, JavadocTag versionTag
where jdoc = c.getDoc().getJavadoc() and
    authorTag.getTagName() = "@author" and authorTag.getParent() = jdoc and
    versionTag.getTagName() = "@version" and versionTag.getParent() = jdoc
select c, authorTag.getText(), versionTag.getText()
```

![image-20210327132707004](https://gitee.com/samny/images/raw/master/7u27er7ec/7u27er7ec.png)

![image-20210327132717979](https://gitee.com/samny/images/raw/master/18u27er18ec/18u27er18ec.png)

The `JavadocTag` has several subclasses representing specific kinds of Javadoc tags:

> 从类c，Javadoc jdoc，JavadocTag authorTag，JavadocTag versionTag:

* `ParamTag` represents `@param` tags; member predicate `getParamName` returns the name of the parameter being documented.

    > ParamTag代表@param标签；成员谓词getParamName返回被记录的参数名称。

* `ThrowsTag` represents `@throws` tags; member predicate `getExceptionName` returns the name of the exception being documented.

    > ThrowsTag代表@throws标签；成员谓词getExceptionName返回被记录的异常名称。

* `AuthorTag` represents `@author` tags; member predicate `getAuthorName` returns the name of the author.

    > AuthorTag代表@author标签；成员谓词getAuthorName返回被记录的作者名称。

## Example: Finding spurious @param tags

As an example of using the CodeQL Javadoc API, let’s write a query that finds `@param` tags that refer to a non-existent parameter.

> 作为使用CodeQL Javadoc API的一个例子，让我们写一个查询来查找引用一个不存在的参数的@param标签。

For example, consider this program:

> 例如，考虑这个程序:

```
class A {
    /**
    * @param lst a list of strings
    */
    public String get(List<String> list) {
        return list.get(0);
    }
}
```

Here, the `@param` tag on `A.get` misspells the name of parameter `list` as `lst`. Our query should be able to find such cases.

> 这里，A.get上的@param标签将参数列表的名称误写为lst。我们的查询应该能够找到这种情况。

To begin with, we write a query that finds all callables (that is, methods or constructors) and their `@param` tags:

> 首先，我们写一个查询，找到所有可调用的方法（即方法或构造函数）和它们的@param标签:

```
import java

from Callable c, ParamTag pt
where c.getDoc().getJavadoc() = pt.getParent()
select c, pt
```

![image-20210327133510876](https://gitee.com/samny/images/raw/master/10u35er10ec/10u35er10ec.png)

![image-20210327133535667](https://gitee.com/samny/images/raw/master/35u35er35ec/35u35er35ec.png)

![image-20210327133548916](https://gitee.com/samny/images/raw/master/48u35er48ec/48u35er48ec.png)



It’s now easy to add another conjunct to the `where` clause, restricting the query to `@param` tags that refer to a non-existent parameter: we simply need to require that no parameter of `c` has the name `pt.getParamName()`.

> 现在很容易在where子句中添加另一个共轭，将查询限制在引用不存在的参数的@param标签上：我们只需要要求c的任何参数都没有pt.getParamName()这个名字。

```
import java

from Callable c, ParamTag pt
where c.getDoc().getJavadoc() = pt.getParent() and
    not c.getAParameter().hasName(pt.getParamName())
select pt, "Spurious @param tag."
```

![image-20210327133629753](https://gitee.com/samny/images/raw/master/29u36er29ec/29u36er29ec.png)

![image-20210327133636435](https://gitee.com/samny/images/raw/master/36u36er36ec/36u36er36ec.png)

![image-20210327133649013](https://gitee.com/samny/images/raw/master/49u36er49ec/49u36er49ec.png)



## Example: Finding spurious @throws tags

A related, but somewhat more involved, problem is finding `@throws` tags that refer to an exception that the method in question cannot actually throw.

> 一个相关的，但比较复杂的问题是找到@throws标签，它指的是一个异常，而该方法实际上不能抛出。

For example, consider this Java program:

> 例如，考虑这个Java程序:

```
import java.io.IOException;

class A {
    /**
    * @throws IOException thrown if some IO operation fails
    * @throws RuntimeException thrown if something else goes wrong
    */
    public void foo() {
        // ...
    }
}
```

Notice that the Javadoc comment of `A.foo` documents two thrown exceptions: `IOException` and `RuntimeException`. The former is clearly spurious: `A.foo` doesn’t have a `throws IOException` clause, and therefore can’t throw this kind of exception. On the other hand, `RuntimeException` is an unchecked exception, so it can be thrown even if there is no explicit `throws` clause listing it. So our query should flag the `@throws` tag for `IOException`, but not the one for `RuntimeException.`

> 请注意，A.foo的Javadoc注释中记录了两个抛出的异常：IOException和RuntimeException。IOException和RuntimeException。前者显然是虚假的：A.foo没有throws IOException子句，因此不能抛出这种异常。另一方面，RuntimeException是一个未被选中的异常，所以即使没有显式的throws子句列出它，它也可以被抛出。所以我们的查询应该标记IOException的@throws标签，而不是RuntimeException的标签。

Remember that the CodeQL library represents `@throws` tags using class `ThrowsTag`. This class doesn’t provide a member predicate for determining the exception type that is being documented, so we first need to implement our own version. A simple version might look like this:

> 记住，CodeQL库使用类ThrowsTag来表示@throws标签。这个类没有提供一个成员谓词来确定被记录的异常类型，所以我们首先需要实现我们自己的版本。一个简单的版本可能是这样的:

```
RefType getDocumentedException(ThrowsTag tt) {
    result.hasName(tt.getExceptionName())
}
```

Similarly, `Callable` doesn’t come with a member predicate for querying all exceptions that the method or constructor may possibly throw. We can, however, implement this ourselves by using `getAnException` to find all `throws` clauses of the callable, and then use `getType` to resolve the corresponding exception types:

> 同样，Callable也没有自带一个成员谓词来查询方法或构造函数可能抛出的所有异常。不过，我们可以自己实现这个功能，使用getAnException查找callable的所有抛出子句，然后使用getType解析相应的异常类型:

```
predicate mayThrow(Callable c, RefType exn) {
    exn.getASupertype*() = c.getAnException().getType()
}
```

Note the use of `getASupertype*` to find both exceptions declared in a `throws` clause and their subtypes. For instance, if a method has a `throws IOException` clause, it may throw `MalformedURLException`, which is a subtype of `IOException`.

> 注意使用getASupertype*来查找throws子句中声明的异常和它们的子类型。例如，如果一个方法有一个throws IOException子句，它可能会抛出MalformedURLException，这是IOException的一个子类型。

Now we can write a query for finding all callables `c` and `@throws` tags `tt` such that:

> 现在我们可以写一个查询，用于查找所有可调用的c和@throws标签tt，这样:

* `tt` belongs to a Javadoc comment attached to `c`. tt属于附加在c上的Javadoc注释。
* `c` can’t throw the exception documented by `tt`. c不能抛出tt所记录的异常。

```
import java

// Determine the kind of exception for the `ThrowsTag`
RefType getDocumentedException(ThrowsTag tt) {
    result.hasName(tt.getExceptionName())
}

// Find all `throws` clauses of the callable and get the exception type
predicate mayThrow(Callable c, RefType exn) {
    exn.getASupertype*() = c.getAnException().getType()
}

from Callable c, ThrowsTag tt, RefType exn
where c.getDoc().getJavadoc() = tt.getParent+() and
    exn = getDocumentedException(tt) and
    not mayThrow(c, exn)
select tt, "Spurious @throws tag."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/1258570917227966396/). This finds several results in the LGTM.com demo projects.

> ➤ 在LGTM.com的查询控制台中看到这个。这可以在 LGTM.com 演示项目中找到几个结果。

![image-20210327134654810](https://gitee.com/samny/images/raw/master/54u46er54ec/54u46er54ec.png)

![image-20210327135253078](https://gitee.com/samny/images/raw/master/53u52er53ec/53u52er53ec.png)

![image-20210327135242786](https://gitee.com/samny/images/raw/master/42u52er42ec/42u52er42ec.png)



### Improvements

Currently, there are two problems with this query:

> 目前，这个查询有两个问题:

1. `getDocumentedException` is too liberal: it will return *any* reference type with the right name, even if it’s in a different package and not actually visible in the current compilation unit.

    > getDocumentedException过于自由：它将返回任何名称正确的引用类型，即使它在不同的包中，并且在当前的编译单元中实际上不可见。

2. `mayThrow` is too restrictive: it doesn’t account for unchecked exceptions, which do not need to be declared.

    > mayThrow的限制性太强：它没有考虑到未被选中的异常，而这些异常不需要声明。

To see why the former is a problem, consider this program:

> 要了解为什么前者是个问题，请考虑这个程序:

```
class IOException extends Exception {}

class B {
    /** @throws IOException an IO exception */
    void bar() throws IOException {}
}
```

This program defines its own class `IOException`, which is unrelated to the class `java.io.IOException` in the standard library: they are in different packages. Our `getDocumentedException` predicate doesn’t check packages, however, so it will consider the `@throws` clause to refer to both `IOException` classes, and thus flag the `@param` tag as spurious, since `B.bar` can’t actually throw `java.io.IOException`.

> 这个程序定义了自己的类IOException，它与标准库中的类java.io.IOException无关：它们在不同的包中。然而，我们的getDocumentedException谓词并不检查包，因此它会认为@throws子句同时引用两个IOException类，从而将@param标签标记为虚假的，因为B.bar实际上不能抛出java.io.IOException。

As an example of the second problem, method `A.foo` from our previous example was annotated with a `@throws RuntimeException` tag. Our current version of `mayThrow`, however, would think that `A.foo` can’t throw a `RuntimeException`, and thus flag the tag as spurious.

> 作为第二个问题的例子，我们上一个例子中的方法A.foo被注解了一个@throws RuntimeException标签。然而，我们当前版本的mayThrow会认为A.foo不能抛出RuntimeException，从而将这个标签标记为虚假的。

We can make `mayThrow` less restrictive by introducing a new class to represent unchecked exceptions, which are just the subtypes of `java.lang.RuntimeException` and `java.lang.Error`:

> 我们可以通过引入一个新的类来表示unchecked异常，这只是java.lang.RuntimeException和java.lang.Error的子类型，从而使mayThrow的限制性降低:

```
class UncheckedException extends RefType {
    UncheckedException() {
        this.getASupertype*().hasQualifiedName("java.lang", "RuntimeException") or
        this.getASupertype*().hasQualifiedName("java.lang", "Error")
    }
}
```

Now we incorporate this new class into our `mayThrow` predicate:

> 现在我们将这个新类加入到我们的 mayThrow 谓词中:

```
predicate mayThrow(Callable c, RefType exn) {
    exn instanceof UncheckedException or
    exn.getASupertype*() = c.getAnException().getType()
}
```

Fixing `getDocumentedException` is more complicated, but we can easily cover three common cases:

> 修复getDocumentedException比较复杂，但我们可以轻松覆盖三种常见情况:

1. The `@throws` tag specifies the fully qualified name of the exception.

    > @throws标签指定了异常的完全限定名称。

2. The `@throws` tag refers to a type in the same package.

    > @throws标签指的是同一个包中的一个类型。

3. The `@throws` tag refers to a type that is imported by the current compilation unit.

    > @throws标签指的是当前编译单元导入的类型。

The first case can be covered by changing `getDocumentedException` to use the qualified name of the `@throws` tag. To handle the second and the third case, we can introduce a new predicate `visibleIn` that checks whether a reference type is visible in a compilation unit, either by virtue of belonging to the same package or by being explicitly imported. We then rewrite `getDocumentedException` as:

> 第一种情况可以通过修改getDocumentedException来使用@throws标签的限定名来处理。为了处理第二种和第三种情况，我们可以引入一个新的谓词visibleIn，它可以检查一个引用类型在编译单元中是否可见，无论是属于同一个包还是被显式导入。然后我们将getDocumentedException重写成:

```
import java

// Determine whether a reference type is visible in a compilation unit
predicate visibleIn(CompilationUnit cu, RefType tp) {
    cu.getPackage() = tp.getPackage()
    or
    exists(ImportType it | it.getCompilationUnit() = cu | it.getImportedType() = tp)
}

// Determine the kind of exception for the `ThrowsTag`
RefType getDocumentedException(ThrowsTag tt) {
    result.getQualifiedName() = tt.getExceptionName()
    or
    (result.hasName(tt.getExceptionName()) and visibleIn(tt.getFile(), result))
}

// Define a class to represent unchecked exceptions
class UncheckedException extends RefType {
    UncheckedException() {
        this.getASupertype*().hasQualifiedName("java.lang", "RuntimeException") or
        this.getASupertype*().hasQualifiedName("java.lang", "Error")
    }
}

// Find all `throws` clauses of the callable and get the exception type
predicate mayThrow(Callable c, RefType exn) {
    exn instanceof UncheckedException or
    exn.getASupertype*() = c.getAnException().getType()
}

from Callable c, ThrowsTag tt, RefType exn
where c.getDoc().getJavadoc() = tt.getParent+() and
    exn = getDocumentedException(tt) and
    not mayThrow(c, exn)
select tt, "Spurious @throws tag."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/8016848987103345329/). This finds many fewer, more interesting results in the LGTM.com demo projects.

> ➤ 在LGTM.com的查询控制台中看到。这在LGTM.com的演示项目中发现了很多少而有趣的结果。

![image-20210327135340417](https://gitee.com/samny/images/raw/master/40u53er40ec/40u53er40ec.png)

![image-20210327135354874](https://gitee.com/samny/images/raw/master/54u53er54ec/54u53er54ec.png)

![image-20210327135400636](https://gitee.com/samny/images/raw/master/0u54er0ec/0u54er0ec.png)

Currently, `visibleIn` only considers single-type imports, but you could extend it with support for other kinds of imports.

> 目前，visibleIn只考虑单一类型的导入，但你可以扩展它，支持其他类型的导入。