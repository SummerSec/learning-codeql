# Query file metadata and alert message style guide

## Introduction

This document outlines the structure of CodeQL query files. You should adopt this structure when contributing custom queries to this repository, in order to ensure that new queries are consistent with the standard CodeQL queries.

> 本文档概述了CodeQL查询文件的结构。当你向这个资源库贡献自定义查询时，你应该采用这个结构，以确保新的查询与标准的CodeQL查询一致。

## Query files (.ql extension)

Query files have the extension `.ql`. Each file has two distinct areas:

> 查询文件的扩展名为`.ql`。每个文件有两个不同的区域:

* Metadata area–displayed at the top of the file, contains the metadata that defines how results for the query are interpreted and gives a brief description of the purpose of the query.

    > 元数据区--显示在文件的顶部，包含元数据，定义了如何解释查询结果，并对查询的目的进行了简要描述。

*   Query definition–defined using QL. The query includes a select statement, which defines the content and format of the results. For further information about writing QL, see the following topics:
    
    > 查询定义--使用QL定义。查询包括一个选择语句，它定义了结果的内容和格式。关于编写QL的更多信息，请参考以下主题:
    
    *   [Learning CodeQL](https://help.semmle.com/QL/learn-ql/index.html)
    *   [QL language reference](https://help.semmle.com/QL/ql-handbook/index.html)
    *   [CodeQL style guide](https://github.com/github/codeql/blob/main/docs/ql-style-guide.md) 

For examples of query files for the languages supported by CodeQL, visit the following links: 

> 关于CodeQL支持的语言的查询文件的例子，请访问以下链接:

*   [C/C++ queries](https://help.semmle.com/wiki/display/CCPPOBJ/)
*   [C# queries](https://help.semmle.com/wiki/display/CSHARP/)
*   [Go queries](https://help.semmle.com/wiki/display/GO/)
*   [Java queries](https://help.semmle.com/wiki/display/JAVA/)
*   [JavaScript queries](https://help.semmle.com/wiki/display/JS/)
*   [Python queries](https://help.semmle.com/wiki/display/PYTHON/)

## Metadata area

Query file metadata contains important information that defines the identifier and purpose of the query. The metadata is included as the content of a valid [QLDoc](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#qldoc) comment, on lines with leading whitespace followed by `*`, between an initial `/**` and a trailing `*/`. For example:

> 查询文件元数据包含重要信息，界定了查询的标识符和目的。元数据作为有效的[QLDoc](https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#qldoc)注释的内容，包含在首字母"/**"和尾字母 "*/"之间的行中，并在其后面加上 "*"。例如：

```
/**
 * @name Useless assignment to local variable
 * @description An assignment to a local variable that is not used later on, or whose value is always
 *              overwritten, has no effect.
 * @kind problem
 * @problem.severity warning
 * @id cs/useless-assignment-to-local
 * @tags maintainability
 *       external/cwe/cwe-563
 * @precision very-high
 */
```

To help others use your query, and to ensure that the query works correctly on LGTM, you should include all of the required information outlined below in the metadata, and as much of the optional information as possible. For further information on query metadata see [Metadata for CodeQL queries](https://help.semmle.com/QL/learn-ql/ql/writing-queries/query-metadata.html) on help.semmle.com.

> 为了帮助其他人使用你的查询，并确保查询在LGTM上正确地工作，你应该在元数据中包含下面列出的所有必要信息，以及尽可能多的可选信息。关于查询元数据的更多信息，请参见 help.semmle.com 上的 [Metadata for CodeQL queries](https://help.semmle.com/QL/learn-ql/ql/writing-queries/query-metadata.html)。




### Query name `@name`

You must specify an `@name` property for your query. This property defines the display name for the query. Query names should use sentence capitalization, but not include a full stop. For example:

> 你必须为你的查询指定一个`@name`属性。这个属性定义了查询的显示名称。查询名称应该使用句子大写，但不包括句号。例如：

*   `@name Access to variable in enclosing class`
*   `@name Array argument size mismatch`
*   `@name Reference equality test on strings`
*   `@name Return statement outside function`


### Query descriptions `@description`

You must define an `@description` property for your query. This property defines a short help message. Query descriptions should be written as a sentence or short-paragraph of plain prose, with sentence capitalization and full stop. The preferred pattern for alert queries is  "Syntax X causes behavior Y." Any code elements included in the description should be enclosed in single quotes. For example:

> 你必须为你的查询定义一个`@description`属性。这个属性定义了一个简短的帮助信息。查询描述应写成一句话或短段的普通散文，句子大写和句号。警示查询的首选模式是 "语法X导致行为Y"。描述中包含的任何代码元素都应该用单引号括起来。例如：


*   `@description Using a format string with an incorrect format causes a 'System.FormatException'.`
*   `@description Commented-out code makes the remaining code more difficult to read.`

### Query ID `@id`

You must specify an `@id` property for your query. It must be unique and should follow the standard CodeQL convention. That is, it should begin with the 'language code' for the language that the query analyzes followed by a forward slash. The following language codes are supported:

> 你必须为你的查询指定一个`@id`属性。它必须是唯一的，并且应该遵循标准的CodeQL约定。也就是说，它应该以查询分析的语言的 "语言代码 "开头，后面加一个斜杠。支持以下语言代码:

*   C and C++: `cpp`
*   C#: `cs`
*   Go: `go`
*   Java: `java`
*   JavaScript and TypeScript: `js`
*   Python: `py`

The `@id` should consist of a short noun phrase that identifies the issue that the query highlights. For example:

> `@id'应该由一个简短的名词短语组成，以确定查询所强调的问题。例如：

*   `@id cs/command-line-injection`
*   `@id java/string-concatenation-in-loop`

Further terms can be added to the `@id` to group queries that, for example, highlight similar issues or are of particular relevance to a certain framework. For example:

> 可以在"@id "中添加更多的术语，以便将突出类似的问题或与某一框架特别相关的查询分组。例如

*   `@id js/angular-js/missing-explicit-injection`
*   `@id js/angular-js/duplicate-dependency`

Note, `@id` properties should be consistent for queries that highlight the same issue for different languages. For example, the following queries identify format strings that contain unsanitized input in Java and C++ code respectively:

> 注意，`@id`属性对于不同语言中突出相同问题的查询应该是一致的。例如，下面的查询分别识别了Java和C++代码中包含未消毒输入的格式字符串

*   `@id java/tainted-format-string`
*   `@id cpp/tainted-format-string`


### Query type `@kind`

`@kind` is a required property that defines the type of query. The main query types are:

> `@kind`是一个必要的属性，定义了查询的类型。主要的查询类型有：

*   alerts (`@kind problem`)
*   alerts containing path information (`@kind path-problem`)

Alert queries (`@kind problem` or `path-problem`) support two further properties. These are added by GitHub staff after the query has been tested, prior to deployment to LGTM. The following information is for reference:

> 警报查询（"@kind problem "或 "path-problem"）还支持两个属性。这些属性是GitHub的工作人员在对查询进行测试后，在部署到LGTM之前添加的。以下信息供参考:

*   `@precision`–broadly indicates the proportion of query results that are true positives, while also considering their context and relevance:
    
    > `@precision`-广义上表示查询结果中真阳性的比例，同时还要考虑其上下文和相关性:
    
    *   `low `
    *   `medium `
    *   `high `
    *   `very-high`
    
*   `@problem.severity`–defines the level of severity of the alert: 
    
    > `@problem.s severity`-定义警报的严重程度:
    
    * `error`–an issue that is likely to cause incorrect program behavior, for example a crash or vulnerability.
    
        > `error`-可能导致不正确程序行为的问题，例如崩溃或漏洞。
    
    * `warning`–an issue that indicates a potential problem in the code, or makes the code fragile if another (unrelated) part of code is changed.
    
        > `warning`--表明代码中存在潜在问题的问题，或者如果改变代码的其他（不相关）部分，会使代码变得脆弱。
    
    * `recommendation`–an issue where the code behaves correctly, but it could be improved.
    
        > `recommendation`--代码表现正确，但可以改进的问题。

The values of `@precision` and `@problem.severity` assigned to a query that is part of the standard set determine how the results are displayed by LGTM. See [About alerts](https://help.semmle.com/lgtm-enterprise/user/help/about-alerts.html) and [Alert interest](https://lgtm.com/help/lgtm/alert-interest) for further information. For information about using custom queries in LGTM on a 'per-project' basis, see [Writing custom queries to include in LGTM analysis](https://lgtm.com/help/lgtm/writing-custom-queries) and [About adding custom queries](https://help.semmle.com/lgtm-enterprise/admin/help/about-adding-custom-queries.html). 

> `@precision`和`@problem.s severity`分配给属于标准集的查询的值决定了LGTM如何显示结果。更多信息请参见【关于警报】(https://help.semmle.com/lgtm-enterprise/user/help/about-alerts.html)和【警报兴趣】(https://lgtm.com/help/lgtm/alert-interest)。关于在LGTM中以 "每个项目 "为基础使用自定义查询的信息，请参阅[编写自定义查询以包含在LGTM分析中](https://lgtm.com/help/lgtm/writing-custom-queries)和[关于添加自定义查询](https://help.semmle.com/lgtm-enterprise/admin/help/about-adding-custom-queries.html)。

## Query tags `@tags`

The `@tags` property is used to define categories that the query relates to. Each query should belong to one (or more, if necessary) of the following four top-level categories:

> `@tags`属性用于定义查询所涉及的类别。每个查询都应该属于以下四个顶级类别中的一个（或多个，如果需要）。

* `@tags correctness`–for queries that detect incorrect program behavior.

    > `@tags correctness`-检测不正确程序行为的查询。

* `@tags maintainability`–for queries that detect patterns that make it harder for developers to make changes to the code.

    > `@tagsmaintainability`--用于检测使开发人员更难对代码进行修改的模式的查询。

* `@tags readability`–for queries that detect confusing patterns that make it harder for developers to read the code.

    > `@tags readability`-用于检测那些使开发人员更难阅读代码的混乱模式的查询。

* `@tags security`–for queries that detect security weaknesses. See below for further information.

    >  `@tags security`--用于检测安全弱点的查询。更多信息请看下文。

There are also more specific `@tags` that can be added. See, the following pages for examples of the low-level tags:

> 还有更多特定的`@tags`可以被添加。低级标签的例子请看下面的页面:

*   [C/C++ queries](https://help.semmle.com/wiki/display/CCPPOBJ/)
*   [C# queries](https://help.semmle.com/wiki/display/CSHARP/)
*   [Go queries](https://help.semmle.com/wiki/display/GO/)
*   [Java queries](https://help.semmle.com/wiki/display/JAVA/)
*   [JavaScript queries](https://help.semmle.com/wiki/display/JS/)
*   [Python queries](https://help.semmle.com/wiki/display/PYTHON/)

If necessary, you can also define your own low-level tags to categorize the queries specific to your project or organization. When creating your own tags, you should:

> 如果有必要，你也可以定义自己的低级标签，对项目或组织的特定查询进行分类。在创建自己的标签时，您应该： * 使用所有小写字母，包括缩略语和专有名词，没有空格。

* Use all lower-case letters, including for acronyms and proper nouns, with no spaces. All characters apart from * and @ are accepted.

    > 使用所有小写字母，包括首字母缩写和专有名词，不要有空格。除了 * 和 @ 之外的所有字符均可接受。

* Use a forward slash / to indicate a hierarchical relationship between tags if necessary. For example, a query with tag `foo/bar` is also interpreted as also having tag `foo`, but not `bar`.

    > 如有必要，使用前斜杠/来表示标签之间的层次关系。例如，带有标签 "foo/bar "的查询也会被解释为也有标签 "foo"，但没有 "bar"。

* Use a single-word `@tags` name. Multiple words, separated with hyphens, can be used for clarity if necessary. 

    > 使用单字的`@tags`名称。如有必要，为了清晰起见，可以使用多个单词，用连字符分隔。

#### Security query `@tags`

If your query is a security query, use one or more `@tags` to associate it with the relevant CWEs. Add `@tags` for the most specific Base Weakness or Class Weakness in [View 1000](https://cwe.mitre.org/data/definitions/1000.html), using the parent/child relationship. For example:

> 如果您的查询是安全查询，请使用一个或多个`@tags`将其与相关的CWEs关联起来。在[查看1000](https://cwe.mitre.org/data/definitions/1000.html)中为最具体的基础弱点或类弱点添加`@tags`，使用父/子关系。例如:

| `@tags security` | `external/cwe/cwe-022`|
|-|-|
||`external/cwe/cwe-023` |
||`external/cwe/cwe-036` |
||`external/cwe/cwe-073` |

When you tag a query like this, the associated CWE pages from [MITRE.org](http://cwe.mitre.org/index.html) will automatically appear in the reference section of its associated qhelp file.

> 当你给这样的查询打上标签时，[MITRE.org](http://cwe.mitre.org/index.html)的相关CWE页面将自动出现在其相关qhelp文件的参考部分。

## QL area

### Alert messages

The select clause of each alert query defines the alert message that is displayed for each result found by the query. Alert messages are strings that concisely describe the problem that the alert is highlighting and, if possible, also provide some context. For consistency, alert messages should adhere to the following guidelines:

> 每个警报查询的选择子句定义了为查询发现的每个结果显示的警报消息。警报消息是简明扼要地描述警报所强调的问题的字符串，如果可能，还提供一些上下文。为了保持一致性，警报消息应遵守以下准则:

* Each message should be a complete, standalone sentence. That is, it should be capitalized and have proper punctuation, including a full stop.

    > 每条消息都应该是一个完整的、独立的句子。也就是说，它应该大写，并有适当的标点符号，包括句号。

* The message should factually describe the problem that is being highlighted–it should not contain recommendations about how to fix the problem or value judgements.

    >  信息应如实描述所强调的问题，不应包含有关如何解决问题的建议或价值判断。

* Program element references should be in 'single quotes' to distinguish them from ordinary words. Quotes are not needed around substitutions ($@).

    > 程序元素引用应使用 "单引号"，以区别于普通词语。替换（$@）周围不需要引号。

* Avoid constant alert message strings and include some context, if possible. For example, `The class 'Foo' is duplicated as 'Bar'.` is preferable to `This class is duplicated here.`

    > 避免使用恒定的警报信息字符串，如果可能的话，应包含一些上下文。例如，"The class 'Foo' is duplicated as 'Bar'. "就比 "This class is duplicated here. "更可取。

* Where you reference another program element, link to it if possible using a substitution (`$@`). Links should be used inline in the sentence, rather than as parenthesised lists or appositions. 

    > 当你引用另一个程序元素时，如果可能的话，使用替换（`$@`）链接到它。链接应该在句子中使用，而不是作为括号内的列表或附加物。

* When a message contains multiple links, construct a sentence that has the most variable link (that is, the link with most targets) last. For further information, see [Defining the results of a query](https://help.semmle.com/QL/learn-ql/ql/writing-queries/select-statement.html).

    > 当一个消息包含多个链接时，构造一个句子的时候，把最多变量的链接（即目标最多的链接）放在最后。更多信息，请参阅[定义查询结果](https://help.semmle.com/QL/learn-ql/ql/writing-queries/select-statement.html)。

For examples of select clauses and alert messages, see the query source files at the following pages:

> 关于选择子句和警报信息的例子，请参见以下页面的查询源文件:

*   [C/C++ queries](https://help.semmle.com/wiki/display/CCPPOBJ/)
*   [C# queries](https://help.semmle.com/wiki/display/CSHARP/)
*   [Go queries](https://help.semmle.com/wiki/display/GO/)
*   [Java queries](https://help.semmle.com/wiki/display/JAVA/)
*   [JavaScript queries](https://help.semmle.com/wiki/display/JS/)
*   [Python queries](https://help.semmle.com/wiki/display/PYTHON/)

For further information on query writing, see [CodeQL queries](https://help.semmle.com/QL/learn-ql/ql/writing-queries/writing-queries.html). For more information on learning CodeQL, see [Learning CodeQL](https://help.semmle.com/QL/learn-ql/index.html).

> 关于查询编写的更多信息，请参见[CodeQL查询](https://help.semmle.com/QL/learn-ql/ql/writing-queries/writing-queries.html)。关于学习CodeQL的更多信息，请参见[学习CodeQL](https://help.semmle.com/QL/learn-ql/index.html)。