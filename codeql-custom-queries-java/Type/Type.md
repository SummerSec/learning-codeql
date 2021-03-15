

## Type

QL is a statically typed language, so each variable must have a declared type.
> QL是一种静态类型的语言，因此每个变量必须具有声明的类型。

A type is a set of values. For example, the type int is the set of integers. Note that a value can belong to more than one of these sets, which means that it can have more than one type.

>类型是一组值。例如，int类型是整数的集合。请注意，一个值可以属于这些集合中的一个以上，这意味着它可以有多个类型。

The kinds of types in QL are primitive types, classes, character types, class domain types, algebraic datatypes, type unions, and database types.

> QL类型基本种类有 classes, character types, class domain types, algebraic datatypes, type unions, and database types.

---

### 类

定义一个类：

1. class关键字
2. 类名，大写字母开头
3. extends 继承的类（至少一个基本类型）
4. 主体，大括号

```
class OneTwoThree extends int {
  OneTwoThree() { // characteristic predicate
    this = 1 or this = 2 or this = 3
  }

  string getAString() { // member predicate
    result = "One, two or three: " + this.toString()
  }

  predicate isEven() { // member predicate
    this = 2
  }
}
```

定义了一个类OneTwoThree，它包含了值1、2和3。特征谓词（this）代表 "整数1、2、3中的一个 "这一逻辑属性。

一个有效类：

* 不能继承自己
* 不能继承final class（类比Java final关键词修饰的类）
* 不得继承不兼容的类型。更多信息，请参见 [类型兼容性](https://codeql.github.com/docs/ql-language-reference/types/#type-compatibility)。

-----

#### 类主体

类主体可以包含：

* 特征谓词声明

* 任意数量的成员谓词声明

* 任何数量的字段声明

#### 特征谓词 

它们是在类的主体中定义的谓词。它们是使用变量 this 限制类中可能的值的逻辑属性。

#### 成员谓词 

这些谓词只适用于特定类的成员。可以对值调用成员谓词。

例如，可以使用上 述类中的成员谓词： 

>  1.(OneTwoThree).getAString()

![image-20210315172957232](https://gitee.com/samny/images/raw/master//57u29er57ec/57u29er57ec.png)

此调用返回结果"One, two or three: 1"。 

表达式(OneTwoThree) 是一个类型转换(cast)。它确保 1 的类型是 OneTwoThree，而不仅仅是 int。因此，它可以访问成员谓词 getAString(). 成员谓词特别有用，因为可以将它们链接在一起。

例如，可以使用 toUpperCase()，它是为字符串定义的内置函数：

> 1.(OneTwoThree).getAString().toUpperCase()

![image-20210315181050594](C:%5CUsers%5CSamny%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5Cimage-20210315181050594.png)

此调用返回 "ONE, TWO OR THREE: 1". 注意 特征谓词和成员谓词通常使用变量 this。这个变量总是引用类的一个成员，在 这种情况下是属于类 OneTwoThree 的值。类中的特征值是该类中的特征值。 在成员谓词中，这与谓词的任何其他参数的作用方式相同。 Fields 这些是在类的主体中声明的变量。一个类的主体中可以有任意数量的字段声明。

----

> 注

> 特性谓词和成员谓词经常使用变量this。这个变量总是指类的成员--本例中是属于类OneTwoThree的值。在特性谓词中，变量this约束了类中的值。在成员谓词中，this的作用与谓词的任何其他参数相同。



----

### Field 字段

These are variables declared in the body of a class. A class can have any number of field declarations (that is, variable declarations) within its body. You can use these variables in predicate declarations inside the class. Much like the variable this, fields must be constrained in the characteristic predicate.

> 这些是在类的主体中声明的变量。一个类的主体中可以有任意数量的字段声明（也就是变量声明）。你可以在类内部的谓词声明中使用这些变量。和变量this一样，字段必须在特性谓词中受到约束。

[Type1.ql](Type1.ql)

````
class SmallInt extends int {
  SmallInt() { this = [1 .. 10] }
}

class DivisibleInt extends SmallInt {
  SmallInt divisor;   // declaration of the field `divisor`
  DivisibleInt() { this % divisor = 0 }

  SmallInt getADivisor() { result = divisor }
}

from DivisibleInt i
select  i.getADivisor(),i
// 一时半会儿没想到怎么解释
// 大致意思就是
// 求1-10每一个数的因数
````

![image-20210315201534294](https://gitee.com/samny/images/raw/master//34u15er34ec/34u15er34ec.png)

----

### Overriding member predicates重写成员谓词

If a class inherits a member predicate from a supertype, you can **override** the inherited definition. You do this by defining a member predicate with the same name and arity as the inherited predicate, and by adding the `override` [annotation](https://codeql.github.com/docs/ql-language-reference/annotations/#override). This is useful if you want to refine the predicate to give a more specific result for the values in the subclass.

> 如果一个类从一个超类型继承了一个成员谓词，您可以覆盖继承的定义。您可以通过定义一个与继承的谓词具有相同名称和奇偶性的成员谓词，并添加覆盖注解来实现。如果您想完善谓词，以便为子类中的值提供一个更具体的结果，这很有用。

[Type2.ql](Type2.ql)

````
class OneTwo extends OneTwoThree {
    OneTwo() {
    this = 1 or this = 2
    }

    override string getAString() {
        result = "One or two: " + this.toString()
    }
}
class OneTwoThree extends int {
    OneTwoThree() {
    // characteristic predicate
        this = 1 or this = 2 or this = 3
    }

    string getAString() {
    // member predicate
        result = "One, two or three: " + this.toString()
    }

    predicate isEven() {
    // member predicate
        this = 1
    }
    
}

from OneTwoThree o
select o, o.getAString()
````

![image-20210315204818741](https://gitee.com/samny/images/raw/master//18u48er18ec/18u48er18ec.png)



---

In QL, unlike other object-oriented languages, different subtypes of the same types don’t need to be disjoint. For example, you could define another subclass of `OneTwoThree`, which overlaps with `OneTwo`:

> 在QL中，与其他面向对象的语言不同，同一类型的不同子类型不需要是不相干的。例如，你可以定义OneTwoThree的另一个子类，它与OneTwo重合。

```
class OneTwo extends OneTwoThree {
    OneTwo() {
    this = 1 or this = 2
    }

    override string getAString() {
        result = "One or two: " + this.toString()
    }
}
class OneTwoThree extends int {
    OneTwoThree() {
    // characteristic predicate
        this = 1 or this = 2 or this = 3 or this = 4
    }

    string getAString() {
    // member predicate
        result = "One, two or three: " + this.toString()
    }

    predicate isEven() {
    // member predicate
        this = 1
    }
    
}
class TwoThree extends OneTwoThree {
    TwoThree() {
        this = 2 or this = 3
    }

    override string getAString() {
        result = "Two or three: " + this.toString()
    }
}

from OneTwoThree x
select x, x.getAString()
```

![image-20210315205036789](https://gitee.com/samny/images/raw/master//36u50er36ec/36u50er36ec.png)



----

### Multiple inheritance[¶](https://codeql.github.com/docs/ql-language-reference/types/#multiple-inheritance)多重继承

A class can extend multiple types. In that case, it inherits from all those types.

> 类可以扩展多种类型。在这种情况下，它继承了所有这些类型。

For example, using the definitions from the above section:

> 例如，使用上面的定义。

```
class Two extends OneTwo, TwoThree {}
```
Any value in the class `Two` must satisfy the logical property represented by `OneTwo`, **and** the logical property represented by `TwoThree`. Here the class `Two` contains one value, namely 2.

> 类 Two 中的任何值都必须满足 OneTwo 表示的逻辑属性和 TwoThree 表示的逻
> 辑属性。这里，类 Two 包含一个值，即 2。

It inherits member predicates from `OneTwo` and `TwoThree`. It also (indirectly) inherits from `OneTwoThree` and `int`.

> 它从 OneTwo 和 TwoThree 继承成员谓词。它还(间接)继承了 OneTwoThree 和
> int。

> 注意
> 如果一个子类继承了同一谓词名称的多个定义，那么它必须重写这些定义以避
> 免歧义。在这种情况下，超级表达式通常很有用。



---

参考：https://codeql.github.com/docs/ql-language-reference/types/

