# QLDoc style guide 

## Introduction

Valid QL comments are known as QLDoc. This document describes the recommended styles and conventions you should use when writing QLDoc for code contributions in this repository. If there is a conflict between any of the recommendations in this guide and clarity, then clarity should take precedence.

> 有效的 QL 注释被称为 QLDoc。本文档描述了您在为本版本库中的代码贡献编写QLDoc时应该使用的推荐样式和约定。如果本指南中的任何建议与明确性之间有冲突，则应以明确性为准。

### General requirements

1. Documentation must adhere to the [QLDoc specification](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#qldoc).

    >  文件必须遵守[QLDoc规范](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#qldoc)。

1. Documentation comments should be appropriate for users of the code.

    > 文档注释应适合代码的用户。

1. Documentation for maintainers of the code must use normal comments.

    > 代码的维护者的文档必须使用正常的注释。

1. Use `/** ... */` for documentation, even for single line comments.
   
   >  使用`/** ... */`用于文档，即使是单行注释。
   
   - For single-line documentation, the `/**` and `*/` are written on the same line as the comment.
   
       >  对于单行文档，`/**`和`*/`与注释写在同一行。
   
   - For multi-line documentation, the `/**` and `*/` are written on separate lines. There is a `*` preceding each comment line, aligned on the first `*`.
   
       >  对于多行文档，`/**`和`*/`写在不同的行上。每行注释前有一个`*`，对齐在第一个`*`上。
   
1. Use code formatting (backticks) within comments for code from the source language, and also for QL code (for example, names of classes, predicates, and variables).

    > 在注释内使用代码格式化（回标），用于来自源语言的代码，也用于QL代码（例如，类、谓词和变量的名称）。

1. Give explanatory examples of code in the target language, enclosed in ```` ```<target language> ````  or `` ` ``.

    > 给出目标语言代码的解释性例子，用```` ````<目标语言>```` 或````````括起来。


### Language requirements

1. Use American English.

    > 使用美式英语。

1. Use full sentences, with capital letters and periods, except for the initial sentence of the comment, which may be fragmentary as described below.

    > 使用完整的句子，大写字母和句号，除注释的首句外，其他句子可以是下面所说的片段。

1. Use simple sentence structures and avoid complex or academic language.

    > 使用简单的句子结构，避免使用复杂或学术性的语言。

1. Avoid colloquialisms and contractions.

    >  避免使用俗语和缩略语。

1. Use words that are in common usage.

    > 使用常用词。


### Requirements for specific items

1. Public declarations must be documented.

    > 公开申报必须有记录。

1. Non-public declarations should be documented.

    > 非公开的申报要有记录。

1. Declarations in query files should be documented.

    > 查询文件中的声明应该被记录下来。

1. Library files (`.qll` files) should be have a documentation comment at the top of the file.

    > 库文件(`.qll`文件)应该在文件的顶部有一个文档注释。

1. Query files, except for tests, must have a QLDoc query documentation comment at the top of the file.

    > 查询文件，除了测试，必须在文件顶部有一个QLDoc查询文档注释。

## QLDoc for predicates

1. Refer to all predicate parameters in the predicate documentation.

    >  参照谓词文档中的所有谓词参数。

1. Reference names, such as types and parameters, using backticks `` ` ``.

    > 引用名称，如类型和参数，使用背标``````。

1. Give examples of code in the target language, enclosed in ```` ```<target language> ````  or `` ` ``.

    >给出目标语言的代码实例，用```` ````<目标语言>```` 或```````````````````````。

1. Predicates that override a single predicate don't need QLDoc, as they will inherit it.

    > 覆盖单个谓词的谓词不需要QLDoc，因为它们会继承它。

### Predicates without result

1. Use a third-person verb phrase of the form ``Holds if `arg` has <property>.``

    > 使用第三人称动词短语 "如果`arg`有<属性>，则保持"。

1. Avoid:
   - `/** Whether ... */`
   - `/**" Relates ... */`
   - Question forms:
     - ``/** Is `x` a foo? */``
     - ``/** Does `x` have a bar? */``
     
     > 避免使用。
     >     - `/**是否...。*/`
     >         - `/**" 亲属... */`
     >         - 问题形式。
     >         - ``/** `x`是foo吗？*/``
     >         - ``/** `x`是否有栏杆？*/``

#### Example

```ql
/**
 * Holds if the qualifier of this call has type `qualifierType`.
 * `isExactType` indicates whether the type is exact, that is, whether
 * the qualifier is guaranteed not to be a subtype of `qualifierType`.
 */
 

/**
 * 如果该调用的限定符具有`qualifierType`类型，则保持。
 * "isExactType "表示该类型是否精确，也就是说，该类型是否为 "qualifierType"。
 * 保证限定词不是`qualifierType`的子类型。
 */

```

### Predicates with result

1. Use a third-person verb phrase of the form `Gets (a|the) <thing>.`

    > 使用第三人称动词短语 "Gets (a|the) <thing>. "的形式。

1. Use "if any" if the item is usually unique but might be missing. For example
  `Gets the body of this method, if any.`

  > 如果物品通常是唯一的，但可能会丢失，则使用 "如果有"。例如
  >     `如果有的话，获取该方法的主体。

1. If the predicate has more complex behaviour, for example multiple arguments are conceptually "outputs", it can be described like a predicate without a result. For example
  ``Holds if `result` is a child of this expression.``

  > 如果谓词有更复杂的行为，例如多个参数在概念上是 "输出"，它可以像一个没有结果的谓词那样描述。例如
  >     ``如果`result`是这个表达式的子句，则成立。

1. Avoid:
   - `Get a ...`
   - `The ...`
   - `Results in ...`
   - Any use of `return`
   
   > 避免使用。
   >     - `获取一个...`。
   >         - `该...`
   >         - `结果在...`。
   >         - 任何 "return "的使用

#### Example
```ql
/**
 * Gets the expression denoting the super class of this class,
 * or nothing if this is an interface or a class without an `extends` clause.
 */
```

### Deprecated predicates

The documentation for deprecated predicates should be updated to emphasize the deprecation and specify what predicate to use as an alternative.

> 应更新关于被废弃的谓词的文件，以强调被废弃的情况，并具体说明应使用什么谓词作为替代。

Insert a sentence of the form `DEPRECATED: Use <other predicate> instead.` at the start of the QLDoc comment. 

> 在QLDoc评注的开头插入一句 "已废弃。在QLDoc注释的开头插入一句话："使用<其他谓词>代替。

#### Example

```ql
/** DEPRECATED: Use `getAnExpr()` instead. */
deprecated Expr getInitializer()
```

### Internal predicates

Some predicates are internal-only declarations that cannot be made private. The documentation for internal predicates should begin with `INTERNAL: Do not use.`

> 有些谓词是内部专用的声明，不能成为私有的。内部谓词的文档应该以`INTERNAL: Do not use.`开头。

#### Example

```ql
/**
 * INTERNAL: Do not use.
 */
```

### Special predicates

Certain special predicates should be documented consistently.

> 某些特殊的谓词应该被一致地记录下来。

- Always document `toString` as 
  
  > 始终将 "toString "记录为 
  
  ```ql
  /** Gets a textual representation of this element. */
string toString() { ... } 
  ```
  
- Always document `hasLocationInfo` as

  > 始终将`hasLocationInfo`记录为
  
  ```ql
  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
 * [Locations](https://help.semmle.com/QL/learn-ql/locations.html).
   */
  
  predicate hasLocationInfo(string filepath, int startline, int startcolumn, int endline, int endcolumn) { ... }
  ```
## QLDoc for classes

1. Document classes using a noun phrase of the form `A <domain element> that <has property>.`

    >  使用 "一个<域元素>，<有属性>. "形式的名词短语记录类。

1. Use "that", not "which".

    >  使用 "that"，而不是 "which"。

1. Refer to member elements in the singular.

    >  用单数来称呼成员元素。

1. Where a class denotes a generic concept with subclasses, list those subclasses.

    >  当一个类表示一个有子类的通用概念时，请列出这些子类。

#### Example

```ql
/**
 * A delegate declaration, for example
 * ```
 * delegate void Logger(string text);
 * ```
 */
class Delegate extends ...
```

```ql
/**
 * An element that can be called.
 *
 * Either a method (`Method`), a constructor (`Constructor`), a destructor
 * (`Destructor`), an operator (`Operator`), an accessor (`Accessor`),
 * an anonymous function (`AnonymousFunctionExpr`), or a local function
 * (`LocalFunction`).
 */
class Callable extends ...
```

## QLDoc for modules

Modules should be documented using a third-person verb phrase of the form `Provides <classes and predicates to do something>.` 

> 模块应该使用第三人称动词短语 "提供<类和谓词来做某事>. "的形式来记录。

#### Example

```ql
/** Provides logic for determining constant expressions. */
```
```ql
/** Provides classes representing the control flow graph within functions. */
```

## Special variables

When referring to `this`, you may either refer to it as `` `this` `` or `this <type>`. For example:

> 当提到 "this "时，你可以将其称为"``this``"或 "this <type>"。例如：

- ``Holds if `this` is static.``
- `Holds if this method is static.`

When referring to `result`, you may either refer to it as `` `result` `` or as `the result`. For example:

> 当提到 "result "时，你可以把它称为"``result``"或 "the result"。例如

- ``Holds if `result` is a child of this expression.``
- `Holds if the result is a child of this expression.`
