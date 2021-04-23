# Annotations in Java[¶](https://codeql.github.com/docs/codeql-language-guides/annotations-in-java/#annotations-in-java)

CodeQL databases of Java projects contain information about all annotations attached to program elements.

> Java项目的CodeQL数据库包含所有附加在程序元素上的注释信息。

## About working with annotations

Annotations are represented by these CodeQL classes:

> 注释由这些CodeQL类来表示。

* The class `Annotatable` represents all entities that may have an annotation attached to them (that is, packages, reference types, fields, methods, and local variables).

    > 类Annotatable代表所有可能附加注解的实体（即包、引用类型、字段、方法和局部变量）。

* The class `AnnotationType` represents a Java annotation type, such as `java.lang.Override`; annotation types are interfaces.

    > 类AnnotationType代表一个Java注释类型，如java.lang.Override；注释类型是接口。

* The class `AnnotationElement` represents an annotation element, that is, a member of an annotation type.

    > 类AnnotationElement表示一个注解元素，也就是一个注解类型的成员。

* The class `Annotation` represents an annotation such as `@Override`; annotation values can be accessed through member predicate `getValue`.

    > 类Annotation代表一个注解，如@Override；注解值可以通过成员谓词getValue访问。

For example, the Java standard library defines an annotation `SuppressWarnings` that instructs the compiler not to emit certain kinds of warnings:

> 例如，Java标准库定义了一个注解 SuppressWarnings，它指示编译器不要发出某些种类的警告:

```
package java.lang;

public @interface SuppressWarnings {
    String[] value;
}
```

`SuppressWarnings` is represented as an `AnnotationType`, with `value` as its only `AnnotationElement`.

> SuppressWarnings被表示为一个AnnotationType，其值是唯一的AnnotationElement。

A typical usage of `SuppressWarnings` would be this annotation for preventing a warning about using raw types:

> SuppressWarnings的典型用法是这个注解，用于防止使用原始类型的警告。

```
class A {
    @SuppressWarnings("rawtypes")
    public A(java.util.List rawlist) {
    }
}
```

The expression `@SuppressWarnings("rawtypes")` is represented as an `Annotation`. The string literal `"rawtypes"` is used to initialize the annotation element `value`, and its value can be extracted from the annotation by means of the `getValue` predicate.

> 表达式@SuppressWarnings("rawtypes")表示为一个Annotation。字符串 "rawtypes "用于初始化注解元素的值，它的值可以通过getValue谓词从注解中提取。

We could then write this query to find all `@SuppressWarnings` annotations attached to constructors, and return both the annotation itself and the value of its `value` element:

> 然后，我们可以写这个查询来查找所有附加在构造函数上的@SuppressWarnings注解，并返回注解本身和它的值元素的值。

```
import java

from Constructor c, Annotation ann, AnnotationType anntp
where ann = c.getAnAnnotation() and
    anntp = ann.getType() and
    anntp.hasQualifiedName("java.lang", "SuppressWarnings")
select ann, ann.getValue("value")
```

➤ [See the full query in the query console on LGTM.com](https://lgtm.com/query/1775658606775222283/). Several of the LGTM.com demo projects use the `@SuppressWarnings` annotation. Looking at the `value`s of the annotation element returned by the query, we can see that the *apache/activemq* project uses the `"rawtypes"` value described above.

> ➤ 在 LGTM.com 的查询控制台中查看完整的查询。LGTM.com的几个演示项目都使用了@SuppressWarnings注解。观察查询返回的注解元素的值，我们可以看到 apache/activemq 项目使用了上面描述的 "rawtypes "值。

![image-20210326171005866](https://gitee.com/samny/images/raw/master/6u10er6ec/6u10er6ec.png)

![image-20210326171043941](https://gitee.com/samny/images/raw/master/49u10er49ec/49u10er49ec.png)



![image-20210326171049443](https://gitee.com/samny/images/raw/master/49u10er49ec/49u10er49ec.png)

As another example, this query finds all annotation types that only have a single annotation element, which has name `value`:

> 作为另一个例子，这个查询找到了所有只有一个注解元素的注解类型，这个注解元素的值是name:

```
import java

from AnnotationType anntp
where forex(AnnotationElement elt |
    elt = anntp.getAnAnnotationElement() |
    elt.getName() = "value"
)
select anntp
```

➤ [See the full query in the query console on LGTM.com](https://lgtm.com/query/2145264152490258283/).

> ➤ 查看LGTM.com上查询控制台中的完整查询。

![image-20210326171131837](https://gitee.com/samny/images/raw/master/31u11er31ec/31u11er31ec.png)

![image-20210326171152529](https://gitee.com/samny/images/raw/master/52u11er52ec/52u11er52ec.png)

![image-20210326171215602](https://gitee.com/samny/images/raw/master/15u12er15ec/15u12er15ec.png)



## Example: Finding missing `@Override` annotations

In newer versions of Java, it’s recommended (though not required) that you annotate methods that override another method with an `@Override` annotation. These annotations, which are checked by the compiler, serve as documentation, and also help you avoid accidental overloading where overriding was intended.

> 在Java的新版本中，建议（虽然不是必须的）用@Override注解来注解覆盖另一个方法的方法。这些由编译器检查的注解可以作为文档，也可以帮助你避免意外的重载，而重载的目的是什么。

For example, consider this example program:

> 例如，考虑这个示例程序:

```
class Super {
    public void m() {}
}

class Sub1 extends Super {
    @Override public void m() {}
}

class Sub2 extends Super {
    public void m() {}
}
```

Here, both `Sub1.m` and `Sub2.m` override `Super.m`, but only `Sub1.m` is annotated with `@Override`.

> 这里，Sub1.m 和 Sub2.m 都覆盖了 Super.m，但只有 Sub1.m 被注解为 @Override。

We’ll now develop a query for finding methods like `Sub2.m` that should be annotated with `@Override`, but are not.

> 现在，我们将开发一个查询，用于查找像 Sub2.m 这样应该被注解为 @Override 但没有被注解的方法。

As a first step, let’s write a query that finds all `@Override` annotations. Annotations are expressions, so their type can be accessed using `getType`. Annotation types, on the other hand, are interfaces, so their qualified name can be queried using `hasQualifiedName`. Therefore we can implement the query like this:

> 第一步，让我们写一个查询来查找所有 @Override 注解。注解是表达式，所以可以使用 getType 访问它们的类型。另一方面，注解类型是接口，所以可以使用hasQualifiedName查询它们的限定名。因此我们可以这样实现查询:

```
import java

from Annotation ann
where ann.getType().hasQualifiedName("java.lang", "Override")
select ann
```

![image-20210326171338887](https://gitee.com/samny/images/raw/master/38u13er38ec/38u13er38ec.png)

 ![image-20210326171351526](https://gitee.com/samny/images/raw/master/59u13er59ec/59u13er59ec.png)

![image-20210326171359169](https://gitee.com/samny/images/raw/master/59u13er59ec/59u13er59ec.png)



As always, it is a good idea to try this query on a CodeQL database for a Java project to make sure it actually produces some results. On the earlier example, it should find the annotation on `Sub1.m`. Next, we encapsulate the concept of an `@Override` annotation as a CodeQL class:

> 和以往一样，最好在Java项目的CodeQL数据库中尝试这个查询，以确保它确实产生了一些结果。在前面的例子中，它应该能找到Sub1.m上的注解。接下来，我们将@Override注解的概念封装成一个CodeQL类:

```
class OverrideAnnotation extends Annotation {
    OverrideAnnotation() {
        this.getType().hasQualifiedName("java.lang", "Override")
    }
}
```

This makes it very easy to write our query for finding methods that override another method, but don’t have an `@Override` annotation: we use predicate `overrides` to find out whether one method overrides another, and predicate `getAnAnnotation` (available on any `Annotatable`) to retrieve some annotation.

> 这使得我们很容易写出我们的查询，用于查找覆盖另一个方法，但没有@Override注解的方法：我们使用谓词overrides来查找一个方法是否覆盖了另一个方法，使用谓词getAnAnnotation（在任何Annotatable上可用）来检索一些注解。

```
import java

from Method overriding, Method overridden
where overriding.overrides(overridden) and
    not overriding.getAnAnnotation() instanceof OverrideAnnotation
select overriding, "Method overrides another method, but does not have an @Override annotation."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/7419756266089837339/). In practice, this query may yield many results from compiled library code, which aren’t very interesting. It’s therefore a good idea to add another conjunct `overriding.fromSource()` to restrict the result to only report methods for which source code is available.

> ➤ 在LGTM.com的查询控制台中可以看到。在实践中，这种查询可能会产生许多来自编译库代码的结果，这些结果并不是很有趣。因此，最好是添加另一个共轭覆盖.fromSource()，以将结果限制为只报告有源代码的方法。

![image-20210326171531336](https://gitee.com/samny/images/raw/master/31u15er31ec/31u15er31ec.png)

![image-20210326171543972](https://gitee.com/samny/images/raw/master/44u15er44ec/44u15er44ec.png)

![image-20210326171549733](https://gitee.com/samny/images/raw/master/49u15er49ec/49u15er49ec.png)



## Example: Finding calls to deprecated methods

As another example, we can write a query that finds calls to methods marked with a `@Deprecated` annotation.

> 作为另一个例子，我们可以写一个查询，查找标记有@Deprecated注解的方法的调用。

For example, consider this example program:

> 例如，考虑这个示例程序:

```
class A {
    @Deprecated void m() {}

    @Deprecated void n() {
        m();
    }

    void r() {
        m();
    }
}
```

Here, both `A.m` and `A.n` are marked as deprecated. Methods `n` and `r` both call `m`, but note that `n` itself is deprecated, so we probably should not warn about this call.

> 这里，A.m和A.n都被标记为废弃。方法n和r都调用了m，但请注意n本身是废弃的，所以我们可能不应该对这个调用发出警告。

As in the previous example, we’ll start by defining a class for representing `@Deprecated` annotations:

> 和前面的例子一样，我们先定义一个类来表示@Deprecated注解:

```
class DeprecatedAnnotation extends Annotation {
    DeprecatedAnnotation() {
        this.getType().hasQualifiedName("java.lang", "Deprecated")
    }
}
```

Now we can define a class for representing deprecated methods:

> 现在我们可以定义一个类来表示被废弃的方法:

```
class DeprecatedMethod extends Method {
    DeprecatedMethod() {
        this.getAnAnnotation() instanceof DeprecatedAnnotation
    }
}
```

Finally, we use these classes to find calls to deprecated methods, excluding calls that themselves appear in deprecated methods:

> 最后，我们使用这些类来查找对废弃方法的调用，排除本身出现在废弃方法中的调用:

```
import java

from Call call
where call.getCallee() instanceof DeprecatedMethod
    and not call.getCaller() instanceof DeprecatedMethod
select call, "This call invokes a deprecated method."
```



In our example, this query flags the call to `A.m` in `A.r`, but not the one in `A.n`.

> 在我们的例子中，这个查询标记了A.r中对A.m的调用，但没有标记A.n中的调用。

For more information about the class `Call`, see “[Navigating the call graph](https://codeql.github.com/docs/codeql-language-guides/navigating-the-call-graph/).”

> 有关类Call的更多信息，请参阅 "导航调用图"。

### Improvements

The Java standard library provides another annotation type `java.lang.SupressWarnings` that can be used to suppress certain categories of warnings. In particular, it can be used to turn off warnings about calls to deprecated methods. Therefore, it makes sense to improve our query to ignore calls to deprecated methods from inside methods that are marked with `@SuppressWarnings("deprecated")`.

> Java标准库提供了另一个注解类型java.lang.SupressWarnings，可以用来抑制某些类别的警告。特别是，它可以用来关闭对废弃方法的调用的警告。因此，改进我们的查询以忽略来自标记为@SuppressWarnings("deprecated")的方法内部对废弃方法的调用是有意义的。

For instance, consider this slightly updated example:

> 例如，考虑这个稍微更新的例子:

```
class A {
    @Deprecated void m() {}

    @Deprecated void n() {
        m();
    }

    @SuppressWarnings("deprecated")
    void r() {
        m();
    }
}
```

Here, the programmer has explicitly suppressed warnings about deprecated calls in `A.r`, so our query should not flag the call to `A.m` any more.

> 在这里，程序员已经显式地抑制了A.r中关于废弃调用的警告，所以我们的查询不应该再标记对A.m的调用。

To do so, we first introduce a class for representing all `@SuppressWarnings` annotations where the string `deprecated` occurs among the list of warnings to suppress:

> 为此，我们首先引入一个类来表示所有@SuppressWarnings注解，其中字符串deprecated出现在要抑制的警告列表中。

```
class SuppressDeprecationWarningAnnotation extends Annotation {
    SuppressDeprecationWarningAnnotation() {
        this.getType().hasQualifiedName("java.lang", "SuppressWarnings") and
        this.getAValue().(Literal).getLiteral().regexpMatch(".*deprecation.*")
    }
}
```

Here, we use `getAValue()` to retrieve any annotation value: in fact, annotation type `SuppressWarnings` only has a single annotation element, so every `@SuppressWarnings` annotation only has a single annotation value. Then, we ensure that it is a literal, obtain its string value using `getLiteral`, and check whether it contains the string `deprecation` using a regular expression match.

> 在这里，我们使用getAValue()来检索任何注解值：事实上，注解类型SuppressWarnings只有一个注解元素，所以每个@SuppressWarnings注解只有一个注解值。然后，我们确保它是一个文字，使用getLiteral获取它的字符串值，并使用正则表达式匹配检查它是否包含字符串废弃。

For real-world use, this check would have to be generalized a bit: for example, the OpenJDK Java compiler allows `@SuppressWarnings("all")` annotations to suppress all warnings. We may also want to make sure that `deprecation` is matched as an entire word, and not as part of another word, by changing the regular expression to `".*\\bdeprecation\\b.*"`.

> 对于现实世界的使用，这种检查必须要概括一下：例如，OpenJDK Java编译器允许@SuppressWarnings("all")注解来抑制所有警告。我们还可以通过将正则表达式修改为".*/\b/deprecation/\b.*"来确保deprecation是作为一个完整的词来匹配的，而不是作为另一个词的一部分。

Now we can extend our query to filter out calls in methods carrying a `SuppressDeprecationWarningAnnotation`:

> 现在我们可以扩展我们的查询来过滤掉携带 SuppressDeprecationWarningAnnotation 的方法中的调用。

```
import java

// Represent deprecated methods
class DeprecatedMethod extends Method {
    DeprecatedMethod() {
        this.getAnAnnotation() instanceof DeprecatedAnnotation
    }
}

// Represent `@SuppressWarnings` annotations with `deprecation`
class SuppressDeprecationWarningAnnotation extends Annotation {
    SuppressDeprecationWarningAnnotation() {
        this.getType().hasQualifiedName("java.lang", "SuppressWarnings") and
        ((Literal)this.getAValue()).getLiteral().regexpMatch(".*deprecation.*")
    }
}

from Call call
where call.getCallee() instanceof DeprecatedMethod
    and not call.getCaller() instanceof DeprecatedMethod
    and not call.getCaller().getAnAnnotation() instanceof SuppressDeprecationWarningAnnotation
select call, "This call invokes a deprecated method."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/8706367340403790260/). It’s fairly common for projects to contain calls to methods that appear to be deprecated.

> ➤ 在 LGTM.com 的查询控制台中可以看到这一点。项目中包含对似乎已被废弃的方法的调用是相当常见的。



![image-20210326171721573](https://gitee.com/samny/images/raw/master/21u17er21ec/21u17er21ec.png)

![image-20210326171743593](https://gitee.com/samny/images/raw/master/43u17er43ec/43u17er43ec.png)

![image-20210326171752120](https://gitee.com/samny/images/raw/master/52u17er52ec/52u17er52ec.png)