## Predicates--谓词

### 定义

[官方](https://codeql.github.com/docs/ql-language-reference/predicates/)给出的定义

> ``Predicates are used to describe the logical relations that make up a QL program.``

> 谓词用于描述组成QL程序的逻辑关系。



-----

### 定义谓词

在定义谓词时，官方要求：

1. 关键字（用于[无结果的谓词](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates-without-result)）或结果类型（用于[结果的谓词](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates-with-result)）。`predicate`
2. 谓词的名称。这是一个[标识符](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#identifiers)，以小写字母开始。
3. 谓词的参数（如果有的话）被逗号隔开。对于每个参数，指定参数类型和参数变量的标识符。
4. 谓词体本身。这是一个逻辑公式，封闭在括号中。

>个人理解其实就是Java、C等语言中的方法或者函数（初步来看，但可以有其特殊性）

注意（之后在看）

[抽象](https://codeql.github.com/docs/ql-language-reference/annotations/#abstract)或[外部](https://codeql.github.com/docs/ql-language-reference/annotations/#external)谓词没有身体。要定义这样的谓词，则用分号 （） 结束谓词定义。`;`



----

### Predicates without result--没有结果谓词

以关键字`predicate`开头，如果传入的值满足条件就拥有该值。

[Predicates.ql](Predicates.ql)：

```
import java

predicate isSmall(int i) {
    i in [1 .. 9]
}

from int x
where x = 2 and isSmall(x) // x = 40
select x

>>>2
```

![image-20210311163818016](https://gitee.com/samny/images/raw/master//18u38er18ec/18u38er18ec.png)



---

### Predicates with result -- 结果谓词

You can define a predicate with result by replacing the keyword with the type of the result. This introduces the special variable .`predicateresult`

通过将关键字替换为结果类型来定义结果的谓词。这里引入特殊的变量`predicateresult`。

[Predicates1.ql](Predicates1.ql)：

```
import java

int getSuccessor(int i) {
    result = i + 1 and // i=3
    i in [1 .. 9] // i=2
}

from int x
where x = 2 
select getSuccessor(x) //x =3

>>> 3
```

![image-20210311165311442](https://gitee.com/samny/images/raw/master//11u53er11ec/11u53er11ec.png)

结果谓词可以定义一个或多个值

官方文档:

```
string getANeighbor(string country) {
  country = "France" and result = "Belgium"
  or
  country = "France" and result = "Germany"
  or
  country = "Germany" and result = "Austria"
  or
  country = "Germany" and result = "Belgium"
}
```

在这种情况下：

* 谓词调用返回两个结果：和.`getANeighbor("Germany")``"Austria"``"Belgium"`
* 谓词调用不返回任何结果，因为没有定义一个。`.getANeighbor("Belgium")``getANeighbor``result``"Belgium"`



----

### Recursive predicates--递归谓词



```
import java

string getANeighbor(string country) {
    country = "France" and result = "Belgium" 
    or
    country = "France" and result = "Germany"
    or
    country = "Germany" and result = "Austria"
    or
    country = "Germany" and result = "Belgium"
    or
    country = getANeighbor(result)
}
select getANeighbor("Belgium")

//大致流程（个人推断）14（country=Belgium）->4（country=Belgium）->6（country=Belgium）->8（country=Belgium）->10（country=Belgium）->12（country=Belgium）->4（country=France）输出->6（country=Germany）输出
```

![image-20210312171843940](https://gitee.com/samny/images/raw/master//44u18er44ec/44u18er44ec.png)

更多解释可以参考[递归](https://codeql.github.com/docs/ql-language-reference/recursion/#recursion)



-----

## Kinds of predicates ---谓词的种类



```
int getSuccessor(int i) {  // 1. Non-member predicate 非成员谓词
  result = i + 1 and
  i in [1 .. 9]
}

class FavoriteNumbers extends int {
  FavoriteNumbers() {  // 2. Characteristic predicate 特征谓词
    this = 1 or
    this = 4 or
    this = 9
  }

  string getName() {   // 3. Member predicate for the class FavoriteNumbers 成员谓词
    this = 1 and result = "one"
    or
    this = 4 and result = "four"
    or
    this = 9 and result = "nine"
  }
}
```