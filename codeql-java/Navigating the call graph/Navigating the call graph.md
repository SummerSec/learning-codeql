# Navigating the call graph[¶](https://codeql.github.com/docs/codeql-language-guides/navigating-the-call-graph/#navigating-the-call-graph)

CodeQL has classes for identifying code that calls other code, and code that can be called from elsewhere. This allows you to find, for example, methods that are never used.

> CodeQL有一些类用于识别调用其他代码的代码，以及可以从其他地方调用的代码。例如，这允许你找到从未使用过的方法。

## Call graph classes

The CodeQL library for Java provides two abstract classes for representing a program’s call graph: `Callable` and `Call`. The former is simply the common superclass of `Method` and `Constructor`, the latter is a common superclass of `MethodAccess`, `ClassInstanceExpression`, `ThisConstructorInvocationStmt` and `SuperConstructorInvocationStmt`. Simply put, a `Callable` is something that can be invoked, and a `Call` is something that invokes a `Callable`.

> Java的CodeQL库提供了两个抽象类来表示程序的调用图。Callable和Call。前者只是Method和Constructor的共同超类，后者是MethodAccess、ClassInstanceExpression、ThisConstructorInvocationStmt和SuperConstructorInvocationStmt的共同超类。简单的说，Callable就是可以被调用的东西，Call就是调用Callable的东西。

For example, in the following program all callables and calls have been annotated with comments:

> 例如，在下面的程序中，所有的可调用和调用都被注解了:

```
class Super {
    int x;

    // callable
    public Super() {
        this(23);       // call
    }

    // callable
    public Super(int x) {
        this.x = x;
    }

    // callable
    public int getX() {
        return x;
    }
}

    class Sub extends Super {
    // callable
    public Sub(int x) {
        super(x+19);    // call
    }

    // callable
    public int getX() {
        return x-19;
    }
}

class Client {
    // callable
    public static void main(String[] args) {
        Super s = new Sub(42);  // call
        s.getX();               // call
    }
}
```

Class `Call` provides two call graph navigation predicates:

> Class Call提供了两个调用图导航谓词:

* `getCallee` returns the `Callable` that this call (statically) resolves to; note that for a call to an instance (that is, non-static) method, the actual method invoked at runtime may be some other method that overrides this method.
* getCallee返回这个调用（静态）所解析的Callable；注意，对于一个实例（即非静态）方法的调用，在运行时实际调用的方法可能是其他一些覆盖这个方法的方法。
* `getCaller` returns the `Callable` of which this call is syntactically part.
* getCaller返回这个调用在语法上是其一部分的Callable。

For instance, in our example `getCallee` of the second call in `Client.main` would return `Super.getX`. At runtime, though, this call would actually invoke `Sub.getX`.

> 例如，在我们的例子中，Client.main中第二个调用的getCallee将返回Super.getX。但在运行时，这个调用实际上会调用Sub.getX。

Class `Callable` defines a large number of member predicates; for our purposes, the two most important ones are:

> 类Callable定义了大量的成员谓词；对于我们的目的，最重要的两个谓词是。

* `calls(Callable target)` succeeds if this callable contains a call whose callee is `target`.
* calls(Callable target)如果这个callable包含一个call，其calllee是target，则成功。

* `polyCalls(Callable target)` succeeds if this callable may call `target` at runtime; this is the case if it contains a call whose callee is either `target` or a method that `target` overrides.
* polyCalls(Callable target)如果这个callable在运行时可以调用target，那么就会成功；如果它包含一个call，其calllee是target或target覆盖的方法，那么就会成功。

In our example, `Client.main` calls the constructor `Sub(int)` and the method `Super.getX`; additionally, it `polyCalls` method `Sub.getX`.

> 在我们的例子中，Client.main调用了构造函数Sub(int)和方法Super.getX；此外，它还polyCalls方法Sub.getX。

## Example: Finding unused methods

We can use the `Callable` class to write a query that finds methods that are not called by any other method:

> 我们可以使用Callable类来写一个查询，找到没有被其他方法调用的方法:

```
import java

from Callable callee
where not exists(Callable caller | caller.polyCalls(callee))
select callee
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/8376915232270534450/). This simple query typically returns a large number of results.

> ➤ 在LGTM.com的查询控制台中可以看到。这种简单的查询通常会返回大量的结果。

![image-20210325154446690](https://gitee.com/samny/images/raw/master/46u44er46ec/46u44er46ec.png)

![image-20210325154511712](https://gitee.com/samny/images/raw/master/11u45er11ec/11u45er11ec.png)



> Note
>
> We have to use `polyCalls` instead of `calls` here: we want to be reasonably sure that `callee` is not called, either directly or via overriding.
>
> 我们必须在这里使用 polyCalls 而不是调用：我们要合理地确定 callee 没有被调用，无论是直接调用还是通过覆盖调用。

Running this query on a typical Java project results in lots of hits in the Java standard library. This makes sense, since no single client program uses every method of the standard library. More generally, we may want to exclude methods and constructors from compiled libraries. We can use the predicate `fromSource` to check whether a compilation unit is a source file, and refine our query:

> 在一个典型的Java项目上运行这个查询的结果是，在Java标准库中会有很多点击。这是有道理的，因为没有一个客户程序会使用标准库的每一个方法。更一般的情况下，我们可能希望从编译库中排除方法和构造函数。我们可以使用fromSource谓词来检查一个编译单元是否是源文件，并完善我们的查询:

```
import java

from Callable callee
where not exists(Callable caller | caller.polyCalls(callee)) and
    callee.getCompilationUnit().fromSource()
select callee, "Not called."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/8711624074465690976/). This change reduces the number of results returned for most projects.

> ➤ 在LGTM.com的查询控制台中可以看到。这个变化减少了大多数项目返回的结果数量。

![image-20210325164432951](C:%5CUsers%5CSamny%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5Cimage-20210325164432951.png)

![image-20210325164448392](https://gitee.com/samny/images/raw/master/48u44er48ec/48u44er48ec.png)

![image-20210325164454547](https://gitee.com/samny/images/raw/master/54u44er54ec/54u44er54ec.png)

We might also notice several unused methods with the somewhat strange name `<clinit>`: these are class initializers; while they are not explicitly called anywhere in the code, they are called implicitly whenever the surrounding class is loaded. Hence it makes sense to exclude them from our query. While we are at it, we can also exclude finalizers, which are similarly invoked implicitly:

> 我们还可能会注意到几个未使用的方法，它们的名称有些奇怪<clinit>：这些方法是类初始化器；虽然它们在代码中的任何地方都没有被显式调用，但每当加载周围的类时，它们就会被隐式调用。因此，将它们从我们的查询中排除是有意义的。当我们在这里的时候，我们也可以排除最终化器，它们同样是隐式调用的:

```
import java

from Callable callee
where not exists(Callable caller | caller.polyCalls(callee)) and
    callee.getCompilationUnit().fromSource() and
    not callee.hasName("<clinit>") and not callee.hasName("finalize")
select callee, "Not called."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/925473733866047471/). This also reduces the number of results returned by most projects.

> ➤ 在LGTM.com的查询控制台中可以看到。这也减少了大多数项目返回的结果数量。

![image-20210325164333796](https://gitee.com/samny/images/raw/master/52u43er52ec/52u43er52ec.png)

![image-20210325164401002](https://gitee.com/samny/images/raw/master/1u44er1ec/1u44er1ec.png)

![image-20210325164415230](https://gitee.com/samny/images/raw/master/15u44er15ec/15u44er15ec.png)

We may also want to exclude public methods from our query, since they may be external API entry points:

> 我们可能还想从查询中排除公共方法，因为它们可能是外部 API 入口点:

```
import java

from Callable callee
where not exists(Callable caller | caller.polyCalls(callee)) and
    callee.getCompilationUnit().fromSource() and
    not callee.hasName("<clinit>") and not callee.hasName("finalize") and
    not callee.isPublic()
select callee, "Not called."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/6284320987237954610/). This should have a more noticeable effect on the number of results returned.

> ➤ 在LGTM.com的查询控制台中可以看到。这对返回的结果数量应该有比较明显的影响。

![image-20210325164953331](https://gitee.com/samny/images/raw/master/53u49er53ec/53u49er53ec.png)

![image-20210325165015867](https://gitee.com/samny/images/raw/master/15u50er15ec/15u50er15ec.png)

![image-20210325165026661](https://gitee.com/samny/images/raw/master/26u50er26ec/26u50er26ec.png)



A further special case is non-public default constructors: in the singleton pattern, for example, a class is provided with private empty default constructor to prevent it from being instantiated. Since the very purpose of such constructors is their not being called, they should not be flagged up:

> 还有一种特殊情况是非公共的默认构造函数：例如，在单子模式中，一个类提供了私有的空默认构造函数，以防止它被实例化。由于这类构造函数的目的就是它们不被调用，所以不应该将它们标记起来:

```
import java

from Callable callee
where not exists(Callable caller | caller.polyCalls(callee)) and
    callee.getCompilationUnit().fromSource() and
    not callee.hasName("<clinit>") and not callee.hasName("finalize") and
    not callee.isPublic() and
    not callee.(Constructor).getNumberOfParameters() = 0
select callee, "Not called."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/2625028545869146918/). This change has a large effect on the results for some projects but little effect on the results for others. Use of this pattern varies widely between different projects.

> ➤ 在LGTM.com的查询控制台中可以看到。这种变化对某些项目的结果影响很大，但对其他项目的结果影响不大。这种模式的使用在不同的项目之间差异很大。

![image-20210325165429413](C:%5CUsers%5CSamny%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5Cimage-20210325165429413.png)

![image-20210325165440723](https://gitee.com/samny/images/raw/master/59u54er59ec/59u54er59ec.png)

![image-20210325165446958](https://gitee.com/samny/images/raw/master/46u54er46ec/46u54er46ec.png)



Finally, on many Java projects there are methods that are invoked indirectly by reflection. So, while there are no calls invoking these methods, they are, in fact, used. It is in general very hard to identify such methods. A very common special case, however, is JUnit test methods, which are reflectively invoked by a test runner. The CodeQL library for Java has support for recognizing test classes of JUnit and other testing frameworks, which we can employ to filter out methods defined in such classes:

> 最后，在许多Java项目上，有一些方法是通过反射间接调用的。因此，虽然没有调用这些方法，但事实上，它们是被使用的。在一般情况下，很难识别这些方法。然而，一个非常常见的特殊情况是JUnit测试方法，这些方法是由测试运行器反射性调用的。Java的CodeQL库支持识别JUnit和其他测试框架的测试类，我们可以采用它来过滤掉这些类中定义的方法:

```
import java

from Callable callee
where not exists(Callable caller | caller.polyCalls(callee)) and
    callee.getCompilationUnit().fromSource() and
    not callee.hasName("<clinit>") and not callee.hasName("finalize") and
    not callee.isPublic() and
    not callee.(Constructor).getNumberOfParameters() = 0 and
    not callee.getDeclaringType() instanceof TestClass
select callee, "Not called."
```

➤ [See this in the query console on LGTM.com](https://lgtm.com/query/2055862421970264112/). This should give a further reduction in the number of results returned.

> ➤ 在LGTM.com的查询控制台中可以看到。这应该会进一步减少返回结果的数量。

![image-20210325165535738](https://gitee.com/samny/images/raw/master/35u55er35ec/35u55er35ec.png)

![image-20210325165551041](https://gitee.com/samny/images/raw/master/51u55er51ec/51u55er51ec.png)

![image-20210325165616137](https://gitee.com/samny/images/raw/master/16u56er16ec/16u56er16ec.png)