<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:9ca8194148e7cd82bc512b5c209dd8449aec15acc79919515b1a798f11ba94b9
size 12431
=======
# CodeQL Design Patterns

A list of design patterns you are recommended to follow.

> 建议你遵循的设计模式列表。

## `::Range` for extensibility and refinement

To allow both extensibility and refinement of classes, we use what is commonly referred to as the `::Range` pattern (since https://github.com/github/codeql/pull/727), but the actual implementation can use different names.

> 为了允许类的可扩展性和精细化，我们使用通常被称为`::Range`模式（自https://github.com/github/codeql/pull/727），但实际实现可以使用不同的名称。

This pattern should be used when you want to model a user-extensible set of values ("extensibility"), while allowing restrictive subclasses, typically for the purposes of overriding predicates ("refinement"). Using a simple `abstract` class gives you the former, but makes it impossible to create overriding methods for all contributing extensions at once. Using a non-`abstract` class provides refinement-based overriding, but requires the original class to range over a closed, non-extensible set.

> 当你想模拟一个用户可扩展的值集（"扩展性"），同时允许限制性的子类，通常是为了覆盖谓词（"细化"）时，应该使用这种模式。使用一个简单的 "抽象 "类可以让你获得前者，但不可能同时为所有贡献的扩展创建覆盖方法。使用非 "抽象 "类可以提供基于精炼的覆盖，但需要原始类覆盖一个封闭的、不可扩展的集合。

<details>
<summary>Generic example of how to define classes with ::Range</summary>
Using a single `abstract` class looks like this:

> 使用一个简单抽象类，如：

```ql
/** <QLDoc...> */
abstract class MySpecialExpr extends Expr {
  /** <QLDoc...> */
  abstract int memberPredicate();
}
class ConcreteSubclass extends MySpecialExpr { ... }
```

While this allows users of the library to add new types of `MySpecialExpr` (like, in this case, `ConcreteSubclass`), there is no way to override the implementations of `memberPredicate` of all extensions at once.

> 虽然这允许库的用户添加新类型的`MySpecialExpr`（比如，在本例中，`ConcreteSubclass`），但没有办法一次性覆盖所有扩展的`memberPredicate`的实现。

Applying the `::Range` pattern yields the following:

> 应用`::Range`模式可以得到以下结果:

```ql
/**
 * <QLDoc...>
 *
 * Extend this class to refine existing API models. If you want to model new APIs,
 * extend `MySpecialExpr::Range` instead.
 */
class MySpecialExpr extends Expr {
  MySpecialExpr::Range range;

  MySpecialExpr() { this = range }

  /** <QLDoc...> */
  int memberPredicate() { result = range.memberPredicate() }
}

/** Provides a class for modeling new <...> APIs. */
module MySpecialExpr {
  /**
   * <QLDoc...>
   *
   * Extend this class to model new APIs. If you want to refine existing API models,
   * extend `MySpecialExpr` instead.
   */
  abstract class Range extends Expr {
    /** <QLDoc...> */
    abstract int memberPredicate();
  }
}
```
Now, a concrete subclass can derive from `MySpecialExpr::Range` if it wants to extend the set of values in `MySpecialExpr`, and it will be required to implement the abstract `memberPredicate()`. Conversely, if it wants to refine `MySpecialExpr` and override `memberPredicate` for all extensions, it can do so by deriving from `MySpecialExpr` directly.

> 现在，一个具体的子类如果想扩展`MySpecialExpr::Range`中的值集，可以从`MySpecialExpr`派生，并且需要实现抽象的`memberPredicate()`。反之，如果它想完善`MySpecialExpr`，并覆盖`memberPredicate`进行所有扩展，则可以直接从`MySpecialExpr`中派生出来。

The key element of the pattern is to provide a field of type `MySpecialExpr::Range`, equating it to `this` in the characteristic predicate of `MySpecialExpr`. In member predicates, we can use either `this` or `range`, depending on which type has the API we need.

> 该模式的关键要素是提供一个类型为`MySpecialExpr::Range`的字段，将其等同于`MySpecialExpr`的特性谓词中的`this`。在成员谓词中，我们可以使用 "this "或 "range"，这取决于哪个类型有我们需要的API。

</details>

Note that in some libraries, the `range` field is in fact called `self`. While we do recommend using `range` for consistency, the name of the field does not matter (and using `range` avoids confusion in contexts like Python analysis that has strong usage of `self`).

> 请注意，在一些库中，`range`字段实际上叫做`self`。虽然我们推荐使用 "range "来保持一致性，但字段的名称并不重要 (而且使用 "range "可以避免在Python分析这样使用 "self "较多的情况下产生混淆)。

### Rationale

Let's use an example from the Go libraries: https://github.com/github/codeql-go/blob/2ba9bbfd8ba1818b5ee9f6009c86a605189c9ef3/ql/src/semmle/go/Concepts.qll#L119-L157

> 我们用Go库中的一个例子来说明：https://github.com/github/codeql-go/blob/2ba9bbfd8ba1818b5ee9f6009c86a605189c9ef3/ql/src/semmle/go/Concepts.qll#L119-L157。

`EscapeFunction`, as the name suggests, models various APIs that escape meta-characters. It has a member-predicate `kind()` that tells you what sort of escaping the modelled function does. For example, if the result of that predicate is `"js"`, then this means that the escaping function is meant to make things safe to embed inside JavaScript.

> `EscapeFunction`，顾名思义，它为各种转义元字符的API建模。它有一个成员谓词`kind()`，告诉你所建模的函数进行何种转义。例如，如果该谓词的结果是`"js"`，那么这意味着转义函数是为了让东西安全地嵌入到JavaScript里面。

`EscapeFunction::Range` is subclassed to model various APIs, and `kind()` is implemented accordingly.

> `EscapeFunction::Range`被子类化来模拟各种API，`kind()`也会相应的实现。

But we can also subclass `EscapeFunction` to, as in the above example, talk about all JS-escaping functions.

> 但是我们也可以将`EscapeFunction`子类化，就像上面的例子一样，讲所有的JS逃逸函数。

You can, of course, do the same without the `::Range` pattern, but it's a little cumbersome:

> 当然，你也可以不用`::Range`模式来做同样的事情，但是有点麻烦:

If you only had an `abstract class EscapeFunction { ... }`, then `JsEscapeFunction` would need to be implemented in a slightly tricky way to prevent it from extending `EscapeFunction` (instead of refining it). You would have to give it a charpred `this instanceof EscapeFunction`, which looks useless but isn't. And additionally, you'd have to provide trivial `none()` overrides of all the abstract predicates defined in `EscapeFunction`. This is all pretty awkward, and we can avoid it by distinguishing between `EscapeFunction` and `EscapeFunction::Range`.

> 如果你只有一个`抽象类EscapeFunction { ... ... }`，那么`JsEscapeFunction`就需要用一种稍微棘手的方式来实现，以防止它扩展`EscapeFunction`（而不是完善它）。你必须给它一个charpred`this instanceof EscapeFunction`，这看起来没用，但其实不然。另外，你还得为`EscapeFunction`中定义的所有抽象谓词提供琐碎的`none()`覆盖。这一切都很尴尬，我们可以通过区分`EscapeFunction`和`EscapeFunction::Range`来避免。


## Importing all subclasses of a class

Importing new files can modify the behaviour of the standard library, by introducing new subtypes of `abstract` classes, by introducing new multiple inheritance relationships, or by overriding predicates. This can change query results and force evaluator cache misses.

> 导入新文件可以修改标准库的行为，引入`抽象`类的新子类型，引入新的多重继承关系，或覆盖谓词。这可能会改变查询结果，并迫使评价器缓存错过。

Therefore, unless you have good reason not to, you should ensure that all subclasses are included when the base-class is (to the extent possible).

> 因此，除非你有很好的理由不这样做，否则你应该确保当基类被包含时，所有的子类都被包含（尽可能地）。

One example where this _does not_ apply: `DataFlow::Configuration` and its variants are meant to be subclassed, but we generally do not want to import all configurations into the same scope at once.

> 这一点不适用的一个例子。`DataFlow::Configuration`和它的变体是要被子类化的，但是我们一般不希望一次把所有的配置导入到同一个作用域。


## Abstract classes as open or closed unions

A class declared as `abstract` in QL represents a union of its direct subtypes (restricted by the intersections of its supertypes and subject to its characteristic predicate). Depending on context, we may want this union to be considered "open" or "closed".

> 在QL中声明为 "抽象 "的类代表了它的直接子类型的联合（受其超类型的交集限制，并受其特征谓词的制约）。根据上下文，我们可能希望这个联合被认为是 "开放 "或 "封闭 "的。

An open union is generally used for extensibility. For example, the abstract classes suggested by the `::Range` design pattern are explicitly intended as extension hooks. As another example, the `DataFlow::Configuration` design pattern provides an abstract class that is intended to be subclassed as a configuration mechanism.

> 一个开放的联合体一般用于扩展性。例如，`::Range`设计模式所建议的抽象类被明确地打算作为扩展钩子。作为另一个例子，`DataFlow::Configuration`设计模式提供了一个抽象类，它的目的是作为配置机制的子类。

A closed union is a class for which we do not expect users of the library to add more values. Historically, we have occasionally modelled this as `abstract` classes in QL, but these days that would be considered an anti-pattern: Abstract classes that are intended to be closed behave in surprising ways when subclassed by library users, and importing libraries that include derived classes can invalidate compilation caches and subvert the meaning of the program.

> 闭合联盟是一个我们不希望库的用户为其添加更多值的类。历史上，我们偶尔会在QL中把它建模为`抽象`类，但如今这将被认为是一种反模式。当库用户对抽象类进行子类化时，这些抽象类的封闭性会出人意料地表现出来，而且导入包含派生类的库会使编译缓存无效，并颠覆程序的意义。

As an example, suppose we want to define a `BinaryExpr` class, which has subtypes of `PlusExpr`, `MinusExpr`, and so on. Morally, this represents a closed union: We do not anticipate new kinds of `BinaryExpr` being added. Therefore, it would be undesirable to model it as an abstract class:

> 举个例子，假设我们要定义一个`BinaryExpr`类，它有`PlusExpr`、`MinusExpr`等子类型。在道德上，这代表了一个封闭的联合。我们不希望增加新的`BinaryExpr`类。因此，将它建模为一个抽象类是不可取的:

```ql
/** ANTI-PATTERN */
abstract class BinaryExpr extends Expr {
  Expr getLhs() { result = this.getChild(0) }
  Expr getRight() { result = this.getChild(1) }
}

class PlusExpr extends BinaryExpr {}
class MinusExpr extends BinaryExpr {}
...
```

Instead, the `BinaryExpr` class should be non-`abstract`, and we have the following options for specifying its extent:

> 相反，`BinaryExpr`类应该是非`抽象的，我们有以下选项来指定它的范围:

- Define a dbscheme type `@binary_expr = @plus_expr | @minus_expr | ...` and add it as an additional super-class for `BinaryExpr`.

    > - 定义一个dbscheme类型`@binary_expr = @plus_expr | @minus_expr | ...`，并将其添加为`BinaryExpr`的附加超类。

- Define a type alias `class RawBinaryExpr = @plus_expr | @minus_expr | ...` and add it as an additional super-class for `BinaryExpr`.

    > - 定义一个类型别名`class RawBinaryExpr = @plus_expr | @minus_expr | ...`，并将其添加为`BinaryExpr`的一个额外的超级类。

- Add a characteristic predicate of `BinaryExpr() { this instanceof PlusExpr or this instanceof MinusExpr or ... }`.

    > - 增加一个`BinaryExpr() { this instanceof PlusExpr or this instanceof MinusExpr or ... 的特性谓词。}`.
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
