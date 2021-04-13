# CodeQL style guide

## Introduction

This document describes how to format the code you contribute to this repository. It covers aspects such as layout, white-space, naming, and documentation. Adhering to consistent standards makes code easier to read and maintain. Of course, these are only guidelines, and can be overridden as the need arises on a case-by-case basis. Where existing code deviates from these guidelines, prefer consistency with the surrounding code.

> 本文档描述了如何格式化你贡献给这个版本库的代码。它涵盖了诸如布局、空白空间、命名和文档等方面。遵循一致的标准可以使代码更容易阅读和维护。当然，这些只是指导原则，当需要时可以根据具体情况进行修改。如果现有的代码偏离了这些准则，最好与周围的代码保持一致。

Note, if you use [CodeQL for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode/procedures/about-codeql-for-vscode.html), you can autoformat your query in the editor.

> 注意，如果你使用[CodeQL for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode/procedures/about-codeql-for-vscode.html)，你可以在编辑器中自动格式化你的查询。

Words in *italic* are defined in the [Glossary](#glossary).

> 在[词汇表](#glossary)中定义了*首字母*的单词。

## Indentation
1. *Always* use 2 spaces for indentation.

    > *始终*用2个空格进行缩进。

1. *Always* indent:
   
   > *始终*缩进。
   
   - The *body* of a module, newtype, class or predicate
   
       > 模块、新类型、类或谓词的*主体*。
   
   - The second and subsequent lines after you use a line break to split a long line
   
       > 使用换行符拆分长行后的第二行和后续行
   
   - The *body* of a `from`, `where` or `select` clause where it spans multiple lines
   
       > 跨越多行的 "from"、"where "或 "select "子句的*主体。
   
   - The *body* of a *quantifier* that spans multiple lines
   
       > 跨越多行的*量词的*主体。


### Examples

```ql
module Helpers {
  /** ... */
  class X ... {
    /** ... */
    int getNumberOfChildren () {
      result = count(int child |
        exists(this.getChild(child))
      )
    }
  }
}
```

```ql
from Call c, string reason
where isDeprecated(c, reason)
select c, "This call to '$@' is deprecated because " + reason + ".",
  c.getTarget(), c.getTarget().getName()
```

## Line breaks
1. Use UNIX line endings.

    > 使用UNIX行尾。

1. Lines *must not* exceed 100 characters.

    > 行数*不得*超过100个字符。

1. Long lines *should* be split with a line break, and the following lines *must* be indented one level until the next "regular" line break.

    > 长行*应该用换行符分割，下面的行*必须缩进一级，直到下一个 "常规 "换行符。

1. There *should* be a single blank line:
   
   > 应该*有一个单独的空行。
   
   - Between the file documentation and the first `import`
   
       > 在文件文档和第一个 "import "之间。
   
   - Before each declaration, except for the first declaration in a *body*
   
       > 在每个声明之前，除了*body*中的第一个声明之外
   
   - Before the `from`-`where`-`select` section in a query file
   
       > 在查询文件中的 "from"-"where"-"select "部分之前。
   
1. *Avoid* two or more adjacent blank lines.

    > *避免*两个或两个以上相邻的空行。

1. There *must* be a new line after the *annotations* `cached`, `pragma`, `language` and `bindingset`. Other *annotations* do not have a new line.

    > 在*注解*"缓存"、"pragma"、"语言 "和 "绑定集 "之后必须有一行新的注解。其他*注解*没有新行。

1. There *should not* be additional blank lines within a predicate.

    > 谓词内不应该有额外的空行。

1. There *may* be a new line:
   
   > 可以有一个新行。
   
   - Immediately after the `from`, `where` or `select` keywords in a query.
   
       >  紧接在查询中的 "from"、"where "或 "select "关键字之后。
   
   - Immediately after `if`, `then`, or `else` keywords.
   
       > 紧接在 "if"、"then "或 "else "关键字之后。
   
1. *Avoid* other line breaks in declarations, other than to break long lines.

    >  *避免*声明中的其他换行符，除了用于打断长行。

1. When operands of *binary operators* span two lines, the operator *should* be placed at the end of the first line.

    > 当*二进制操作符的操作数*跨两行时，操作符*应该放在第一行的末尾。

1. If the parameter list needs to be broken across multiple lines then there *must* be a line break after the opening `(`, the parameter declarations indented one level, and the `) {` *must* be on its own line at the outer indentation.

    > 如果参数表需要跨多行断行，那么在开头的`(`后必须*有一个换行符，参数声明缩进一级，`){`*必须*在自己的行外缩进。

### Examples

```ql
cached
private int getNumberOfParameters() {
  ...
}
```

```ql
predicate methodStats(
  string qualifiedName, string name, int numberOfParameters,
  int numberOfStatements, int numberOfExpressions, int linesOfCode,
  int nestingDepth, int numberOfBranches
) {
  ...
}
```

```ql
from Method main
where main.getName() = "Main"
select main, "This is the program entry point."
```

```ql
from Method main
where
  main.getName() = "Main" and
  main.getNumberOfParameters() = 0
select main, "Main method has no parameters."
```

```ql
  if x.isPublic()
  then result = "public"
  else result = "private"
```

```ql
  if
    x.isPublic()
  then
    result = "public"
  else
    result = "private"
```

```ql
  if x.isPublic()
  then result = "public"
  else
    if x.isPrivate()
    then result = "private"
    else result = "protected"
```


## Braces
1. Braces follow [Stroustrup](https://en.wikipedia.org/wiki/Indentation_style#Variant:_Stroustrup) style. The opening `{` *must* be placed at the end of the preceding line.

    >  方括号遵循[Stroustrup](https://en.wikipedia.org/wiki/Indentation_style#Variant:_Stroustrup)的风格。开头的`{`*必须*放在前一行的末尾。

1. The closing `}` *must* be placed on its own line, indented to the outer level, or be on the same line as the opening `{`.

    > 结尾`}` *必须*放在自己的行上，缩进到外侧，或者与开头的`{`在同一行。

1. Braces of empty blocks *may* be placed on a single line, with a single space separating the braces.

    > 空块的括号*可以*放在一行，括号之间用一个空格隔开。

1. Short predicates, not exceeding the maximum line width, *may* be placed on a single line, with a space following the opening brace and preceding the closing brace.

    >  短的谓词，不超过最大行宽，*可以放在单行上，开头括号后和结尾括号前各留一个空格。

### Examples

```ql
class ThrowException extends ThrowExpr {
  Foo() {
    this.getTarget() instanceof ExceptionClass
  }

  override string toString() { result = "Throw Exception" }
}
```

## Spaces
1. There *must* be a space or line break:
   
   > 必须有一个空格或换行符。
   
   - Surrounding each `=` and `|`
   
       > 每一个"="和"|"的周围都有一个空格或换行符。
   
   - After each `,`
   
       > 在每一个`、`之后
   
1. There *should* be a space or line break:
   
   > 应该有一个空格或换行符。
   
   - Surrounding each *binary operator*, which *must* be balanced
   
       > 每一个*二进制运算符*的周围，*必须*平衡。
   
   - Surrounding `..` in a range
   
       > 在一个范围内包围`.`。
   
   - Exceptions to this may be made to save space or to improve readability.
   
       > 为了节省空间或提高可读性，可以破例。
   
1. *Avoid* other spaces, for example:
   
   > 例如，*避免*其他空格。
   
   - After a *quantifier/aggregation* keyword
   
       >  在*量词/集合*关键词之后...
   
   - After the predicate name in a *call*
   
       > 在*call*中的谓词名后边
   
   - Inside brackets used for *calls*, single-line quantifiers, and parenthesised formulas
   
       > 内括号用于*号、单行量化符和括号内的公式。
   
   - Surrounding a `.`
   
       >  `.`的周围
   
   - Inside the opening or closing `[ ]` in a range expression
   
       > 在一个范围表达式的开头或结尾`[]`内。
   
   - Inside casts `a.(X)`
   
       > Inside投出`a.(X)`。
   
1. *Avoid* multiple spaces, except for indentation, and *avoid* additional indentation to align formulas, parameters or arguments.

    > 除缩进外，*避免*多个空格，*避免*额外的缩进来对齐公式、参数或参数。

1. *Do not* put whitespace on blank lines, or trailing on the end of a line.

    >  *不要*在空行上加空白，或在行尾加尾巴。

1. *Do not* use tabs.

    >  *不要*使用制表符。


### Examples

```ql
cached
private predicate foo(Expr e, Expr p) {
  exists(int n |
    n in [0 .. 1] |
    e = p.getChild(n + 1)
  )
}
```

## Naming
1. Use [PascalCase](http://wiki.c2.com/?PascalCase) for: 
   
   > 使用[PascalCase](http://wiki.c2.com/?PascalCase)进行:
   
   - `class` names
   - `module` names
   - `newtype` names
   
1. Use [camelCase](https://en.wikipedia.org/wiki/Camel_case) for:
   
   > 使用[camelCase](https://en.wikipedia.org/wiki/Camel_case)进行。
   
   - Predicate names
   - Variable names
   
1. Newtype predicate names *should* begin with `T`.

    > 新类型谓词名称应该以`T`开头。

1. Predicates that have a result *should* be named `get...`

    > 有结果的谓词*应该*命名为 "get..."。

1. Predicates that can return multiple results *should* be named `getA...` or `getAn...`

    > 可以返回多个结果的谓词*应该*命名为`getA...`或`getAn...`。

1. Predicates that don't have a result or parameters *should* be named `is...` or `has...`

    > 没有结果或参数的谓词*应该*命名为`is...`或`has...`。

1. *Avoid* underscores in names.

    > *避免*在名称中使用下划线。

1. *Avoid* short or single-letter names for classes, predicates and fields.

    > *避免*类、谓词和字段的短名或单字母名。

1. Short or single letter names for parameters and *quantifiers* *may* be used provided that they are sufficiently clear.

    > 只要参数和*量子*足够清晰，就可以*使用简短或单字母的名称。

1. Use names as they are used in the target-language specification.

    > 使用目标语言规范中使用的名称。

1. Use American English.

    > 使用美式英语。

### Examples

```ql
/** ... */
predicate calls(Callable caller, Callable callee) {
  ...
}
```

```ql
/** ... */
class Type extends ... {
  /** ... */
  string getName() { ... }

  /** ... */
  predicate declares(Member m) { ... }

  /** ... */
  predicate isGeneric() { ... }

  /** ... */
  Type getTypeParameter(int n) { ... }

  /** ... */
  Type getATypeParameter() { ... }
}
```

## Documentation

For more information about documenting the code that you contribute to this repository, see the [QLDoc style guide](qldoc-style-guide.md).

> 要了解更多关于记录你贡献给这个仓库的代码的信息，请看 [QLDoc style guide](qldoc-style-guide.md)。

## Formulas
1. *Prefer* one *conjunct* per line.

    >  *每行*好有一个*结点。

2. Write the `and` at the end of the line. This also applies in `where` clauses.

3. *Prefer* to write the `or` keyword on its own line.

4. The `or` keyword *may* be written at the end of a line, or within a line, provided that it has no `and` operands.

5. Single-line formulas *may* be used in order to save space or add clarity, particularly in the *body* of a *quantifier/aggregation*.

6. *Always* use brackets to clarify the precedence of:
   - `implies`
   - `if`-`then`-`else`

7. *Avoid* using brackets to clarify the precedence of:
   - `not`
   - `and`
   - `or`

8. Parenthesised formulas *can* be written:
   - Within a single line. There *should not* be an additional space following the opening parenthesis or preceding the closing parenthesis.
   - Spanning multiple lines. The opening parenthesis *should* be placed at the end of the preceding line, the body should be indented one level, and the closing bracket should be placed on a new line at the outer indentation.

9. *Quantifiers/aggregations* *can* be written:
   - Within a single line. In this case, there is no space to the inside of the parentheses, or after the quantifier keyword.
   - Across multiple lines. In this case, type declarations are on the same line as the quantifier with the first `|` at the same line as the quantifier, the second `|` *must* be at the end of the same line as the quantifier or on its own line at the outer indentation, and the body of the quantifier *must* be indented one level. The closing `)` is written on a new line, at the outer indentation. If the type declarations need to be broken across multiple lines then there must *must* be a line break after the opening `(`, the type declarations indented one level, and the first `|` on its own line at the outer indentation.

10. `if`-`then`-`else` *can* be written:
   - On a single line
   - With the *body* after the `if`/`then`/`else` keyword
   - With the *body* indented on the next line
   - *Always* parenthesise the `else` part if it is a compound formula.

11. If an `if`-`then`-`else` is broken across multiple lines then the `then` and `else` keywords *should* be at the start of lines aligned with the `if`.

12. The `and` and `else` keywords *may* be placed on the same line as the closing parenthesis.

13. The `and` and `else` keywords *may* be "cuddled": `) else (`

14. *Always* qualify *calls* to predicates of the same class with `this`.

15. *Prefer* postfix casts `a.(Expr)` to prefix casts `(Expr)a`.

### Examples

```ql
  argumentType.isImplicitlyConvertibleTo(parameterType)
  or
  argumentType instanceof NullType and
  result.getParameter(i).isOut() and
  parameterType instanceof SimpleType
  or
  reflectionOrDynamicArg(argumentType, parameterType)
```

```ql
  this.getName() = "Finalize" and not exists(this.getAParameter())
```

```ql
  e1.getType() instanceof BoolType and (
    b1 = true
    or
    b1 = false
  ) and (
    b2 = true
    or
    b2 = false
  )
```

```ql
  if e1 instanceof BitwiseOrExpr or e1 instanceof LogicalOrExpr
  then (
    impliesSub(e1.(BinaryOperation).getAnOperand(), e2, b1, b2) and
    b1 = false
  ) else (
    e1.getType() instanceof BoolType and
    e1 = e2 and
    b1 = b2 and
    (b1 = true or b1 = false)
  )
```

```ql
  (x instanceof Exception implies x.isPublic()) and y instanceof Exception
```

```ql
  x instanceof Exception implies (x.isPublic() and y instanceof Exception)
```

```ql
  exists(Type arg | arg = this.getAChild() | arg instanceof TypeParameter)
```

```ql
  exists(Type qualifierType |
    this.hasNonExactQualifierType(qualifierType)
  |
    result = getANonExactQualifierSubType(qualifierType)
  )
```

```ql
  methods = count(Method m | t = m.getDeclaringType() and not ilc(m))
```

```ql
  if n = 0 then result = 1 else result = n * f(n - 1)
```

```ql
  if n = 0
  then result = 1
  else result = n * f(n - 1)
```

```ql
  if
    n = 0
  then
    result = 1
  else
    result = n * f(n - 1)
```

```ql
  if exists(this.getContainingType())
  then (
    result = "A nested class" and
    parentName = this.getContainingType().getFullyQualifiedName()
  ) else (
    result = parentName + "." + this.getName() and
    parentName = this.getNamespace().getFullyQualifiedName()
  )
```

## Glossary

| Phrase      | Meaning  |
|-------------|----------|
| *[annotation](https://help.semmle.com/QL/ql-handbook/language.html#annotations)* | An additional specifier used to modify a declaration, such as `private`, `override`, `deprecated`, `pragma`, `bindingset`, or `cached`. |
| *body* | The text inside `{ }`, `( )`, or each section of an `if`-`then`-`else` or `from`-`where`-`select`. |
| *binary operator* | An operator with two operands, such as comparison operators, `and`, `or`, `implies`, or arithmetic operators. |
| *call* | A *formula* that invokes a predicate, e.g. `this.isStatic()` or `calls(a,b)`. |
| *[conjunct](https://help.semmle.com/QL/ql-handbook/language.html#conjunctions)* | A formula that is an operand to an `and`. |
| *declaration* | A class, module, predicate, field or newtype. |
| *[disjunct](https://help.semmle.com/QL/ql-handbook/language.html#disjunctions)* | A formula that is an operand to an `or`. |
| *[formula](https://help.semmle.com/QL/ql-handbook/language.html#formulas)* | A logical expression, such as `A = B`, a *call*, a *quantifier*, `and`, `or`, `not`, `in` or `instanceof`. |
| *should/should not/avoid/prefer* | Adhere to this rule wherever possible, where it makes sense. |
| *may/can* | This is a reasonable alternative, to be used with discretion. |
| *must/always/do not* | Always adhere to this rule. |
| *[quantifier/aggregation](https://help.semmle.com/QL/ql-handbook/language.html#aggregations)* | `exists`, `count`, `strictcount`, `any`, `forall`, `forex` and so on. |
| *variable* | A parameter to a predicate, a field, a from variable, or a variable introduced by a *quantifier* or *aggregation*. |
