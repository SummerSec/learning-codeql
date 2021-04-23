<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:a6e03f019db83c832a112b2c169871aac961c77f8705aa474aba4b0f29d84e8a
size 18260
=======
# About CodeQL queries[¶](https://codeql.github.com/docs/writing-codeql-queries/about-codeql-queries/#about-codeql-queries)

CodeQL queries are used to analyze code for issues related to security, correctness, maintainability, and readability.

> CodeQL查询用于分析代码的安全性、正确性、可维护性和可读性等相关问题。

## Overview

CodeQL includes queries to find the most relevant and interesting problems for each supported language. You can also write custom queries to find specific issues relevant to your own project. The important types of query are:

> CodeQL包括查询，为每个支持的语言找到最相关和最有趣的问题。您也可以编写自定义查询来查找与自己项目相关的特定问题。重要的查询类型有

* **Alert queries**: queries that highlight issues in specific locations in your code.

    > 警报查询：突出显示您代码中特定位置的问题的查询。

* **Path queries**: queries that describe the flow of information between a source and a sink in your code.

    > 路径查询：描述你的代码中源和汇之间的信息流的查询。

You can add custom queries to [QL packs](https://codeql.github.com/docs/codeql-cli/about-ql-packs/) to analyze your projects with “[Code scanning](https://docs.github.com/github/finding-security-vulnerabilities-and-errors-in-your-code)”, use them to analyze a database with the “[CodeQL CLI](https://codeql.github.com/docs/codeql-cli/#codeql-cli),” or you can contribute to the standard CodeQL queries in our [open source repository on GitHub](https://github.com/github/codeql).

> 您可以将自定义查询添加到QL包中，用 "代码扫描 "来分析您的项目，用它们来分析 "CodeQL CLI "的数据库，或者您可以在GitHub上为我们的开源仓库中的标准CodeQL查询做出贡献。

This topic is a basic introduction to query files. You can find more information on writing queries for specific programming languages in the “[CodeQL language guides](https://codeql.github.com/docs/codeql-language-guides/#codeql-language-guides),” and detailed technical information about QL in the “[QL language reference](https://codeql.github.com/docs/ql-language-reference/#ql-language-reference).” For more information on how to format your code when contributing queries to the GitHub repository, see the [CodeQL style guide](https://github.com/github/codeql/blob/main/docs/ql-style-guide.md).

> 本主题是对查询文件的基本介绍。您可以在 "CodeQL语言指南 "中找到更多关于为特定编程语言编写查询的信息，并在 "QL语言参考 "中找到关于QL的详细技术信息。有关向GitHub仓库贡献查询时如何格式化代码的更多信息，请参阅 "CodeQL风格指南"。

## Basic query structure

[Queries](https://codeql.github.com/docs/ql-language-reference/queries/#queries) written with CodeQL have the file extension `.ql`, and contain a `select` clause. Many of the existing queries include additional optional information, and have the following structure:

> 用CodeQL编写的查询文件扩展名为.ql，并包含一个选择子句。许多现有的查询包括附加的可选信息，其结构如下:

```
/**
 *
 * Query metadata
 *
 */

import /* ... CodeQL libraries or modules ... */

/* ... Optional, define CodeQL classes and predicates ... */

from /* ... variable declarations ... */
where /* ... logical formula ... */
select /* ... expressions ... */
```

The following sections describe the information that is typically included in a query file for alerts. Path queries are discussed in more detail in “[Creating path queries](https://codeql.github.com/docs/writing-codeql-queries/creating-path-queries/).”

> 以下各节描述了通常包含在警报查询文件中的信息。路径查询将在 "创建路径查询 "中详细讨论。

### Query metadata

Query metadata is used to identify your custom queries when they are added to the GitHub repository or used in your analysis. Metadata provides information about the query’s purpose, and also specifies how to interpret and display the query results. For a full list of metadata properties, see “[Metadata for CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/metadata-for-codeql-queries/).” The exact metadata requirement depends on how you are going to run your query:

> 当您的自定义查询添加到GitHub仓库或用于分析时，查询元数据用于识别它们。元数据提供了有关查询目的的信息，还指定了如何解释和显示查询结果。有关元数据属性的完整列表，请参阅 "CodeQL查询的元数据"。确切的元数据要求取决于你将如何运行你的查询:

* If you are contributing a query to the GitHub repository, please read the [query metadata style guide](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md).

    > 如果你是向GitHub仓库贡献一个查询，请阅读查询元数据样式指南。

* If you are adding a custom query to a query pack for analysis using LGTM , see [Writing custom queries to include in LGTM analysis](https://lgtm.com/help/lgtm/writing-custom-queries).

    > 如果您正在将自定义查询添加到使用 LGTM 进行分析的查询包中，请参阅编写自定义查询以包含在 LGTM 分析中。

* If you are analyzing a database using the [CodeQL CLI](https://codeql.github.com/docs/codeql-cli/#codeql-cli), your query metadata must contain `@kind`.

    > 如果你正在使用CodeQL CLI分析数据库，你的查询元数据必须包含@kind。

* If you are running a query in the query console on LGTM or with the CodeQL extension for VS Code, metadata is not mandatory. However, if you want your results to be displayed as either an ‘alert’ or a ‘path’, you must specify the correct `@kind` property, as explained below. For more information, see [Using the query console](https://lgtm.com/help/lgtm/using-query-console) on LGTM.com and “[Analyzing your projects](https://codeql.github.com/docs/codeql-for-visual-studio-code/analyzing-your-projects/#analyzing-your-projects)” in the CodeQL for VS Code help.

    > 如果你是在LGTM的查询控制台中运行查询，或者使用VS Code的CodeQL扩展，元数据不是强制性的。但是，如果你想让你的结果显示为 "警报 "或 "路径"，你必须指定正确的@kind属性，如下所述。更多信息，请参见使用LGTM.com上的查询控制台和 "分析你的项目 "中的CodeQL for VS Code帮助。

> Note
>
> Queries that are contributed to the open source repository, added to a query pack in LGTM, or used to analyze a database with the [CodeQL CLI](https://codeql.github.com/docs/codeql-cli/#codeql-cli) must have a query type (`@kind`) specified. The `@kind` property indicates how to interpret and display the results of the query analysis:
>
> > 贡献给开源仓库的查询，添加到LGTM中的查询包中的查询，或者用CodeQL CLI来分析数据库的查询必须指定一个查询类型（@kind）。@kind 属性指示如何解释和显示查询分析的结果:
>
> * Alert query metadata must contain `@kind problem`.
>
>     > Alert查询元数据必须包含@kind问题。
>
> * Path query metadata must contain `@kind path-problem`.
>
>     > 路径查询元数据必须包含@kind path-problem。
>
> When you define the `@kind` property of a custom query you must also ensure that the rest of your query has the correct structure in order to be valid, as described below.
>
> 当您定义自定义查询的@kind属性时，您还必须确保查询的其余部分具有正确的结构才能有效，如下所述。

### Import statements

Each query generally contains one or more `import` statements, which define the [libraries](https://codeql.github.com/docs/ql-language-reference/modules/#library-modules) or [modules](https://codeql.github.com/docs/ql-language-reference/modules/#modules) to import into the query. Libraries and modules provide a way of grouping together related [types](https://codeql.github.com/docs/ql-language-reference/types/#types), [predicates](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates), and other modules. The contents of each library or module that you import can then be accessed by the query. Our [open source repository on GitHub](https://github.com/github/codeql) contains the standard CodeQL libraries for each supported language.

> 每个查询一般包含一个或多个导入语句，这些语句定义了要导入查询的库或模块。库和模块提供了一种将相关类型、谓词和其他模块分组的方式。然后你导入的每个库或模块的内容都可以被查询访问。我们在GitHub上的开源库包含了每个支持语言的标准CodeQL库。

When writing your own alert queries, you would typically import the standard library for the language of the project that you are querying, using `import` followed by a language:

> 当您编写自己的警报查询时，您通常会导入您要查询的项目语言的标准库，使用 import 后面的语言:

* C/C++: `cpp`
* C#: `csharp`
* Go: `go`
* Java: `java`
* JavaScript/TypeScript: `javascript`
* Python: `python`

There are also libraries containing commonly used predicates, types, and other modules associated with different analyses, including data flow, control flow, and taint-tracking. In order to calculate path graphs, path queries require you to import a data flow library into the query file. For more information, see “[Creating path queries](https://codeql.github.com/docs/writing-codeql-queries/creating-path-queries/).”

> 还有包含常用谓词、类型的库，以及与不同分析相关的其他模块，包括数据流、控制流和污点跟踪。为了计算路径图，路径查询需要您将数据流库导入查询文件中。有关详细信息，请参阅 "创建路径查询"。

You can explore the contents of all the standard libraries in the [CodeQL library reference documentation](https://codeql.github.com/codeql-standard-libraries/) or in the [GitHub repository](https://github.com/github/codeql).

> 您可以在CodeQL库参考文档或GitHub库中探索所有标准库的内容。

#### Optional CodeQL classes and predicates

You can customize your analysis by defining your own predicates and classes in the query. For further information, see [Defining a predicate](https://codeql.github.com/docs/ql-language-reference/predicates/#defining-a-predicate) and [Defining a class](https://codeql.github.com/docs/ql-language-reference/types/#defining-a-class).

> 您可以通过在查询中定义自己的谓词和类来定制分析。更多信息，请参阅定义谓词和定义类。

### From clause

The `from` clause declares the variables that are used in the query. Each declaration must be of the form `<type> <variable name>`. For more information on the available [types](https://codeql.github.com/docs/ql-language-reference/types/#types), and to learn how to define your own types using [classes](https://codeql.github.com/docs/ql-language-reference/types/#classes), see the [QL language reference](https://codeql.github.com/docs/ql-language-reference/#ql-language-reference).

> from子句声明了在查询中使用的变量，每个声明必须是<type><variable name>的形式。每个声明的形式必须是<type> <variable name>。关于可用类型的更多信息，以及学习如何使用类定义自己的类型，请参见QL语言参考。

### Where clause

The `where` clause defines the logical conditions to apply to the variables declared in the `from` clause to generate your results. This clause uses [aggregations](https://codeql.github.com/docs/ql-language-reference/expressions/#aggregations), [predicates](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates), and logical [formulas](https://codeql.github.com/docs/ql-language-reference/formulas/#formulas) to limit the variables of interest to a smaller set, which meet the defined conditions. The CodeQL libraries group commonly used predicates for specific languages and frameworks. You can also define your own predicates in the body of the query file or in your own custom modules, as described above.

> where子句定义了应用于from子句中声明的变量的逻辑条件，以生成结果。这个子句使用聚合、谓词和逻辑公式将感兴趣的变量限制在一个较小的集合中，这些变量符合定义的条件。CodeQL库为特定的语言和框架分组了常用的谓词。您也可以在查询文件的主体中或在自己的自定义模块中定义自己的谓词，如上所述。

### Select clause

The `select` clause specifies the results to display for the variables that meet the conditions defined in the `where` clause. The valid structure for the select clause is defined by the `@kind` property specified in the metadata.

> 选择子句指定了满足where子句中定义的条件的变量的显示结果。选择子句的有效结构由元数据中指定的@kind属性定义。

Select clauses for alert queries (`@kind problem`) consist of two ‘columns’, with the following structure:

> 警报查询（@kind问题）的选择子句由两个 "列 "组成，结构如下:

```
select element, string
```

* `element`: a code element that is identified by the query, which defines where the alert is displayed.

    > element：由查询识别的代码元素，它定义了警报的显示位置。

* `string`: a message, which can also include links and placeholders, explaining why the alert was generated.

    > string：一个消息，也可以包括链接和占位符，解释为什么会产生警报。

You can modify the alert message defined in the final column of the `select` statement to give more detail about the alert or path found by the query using links and placeholders. For more information, see “[Defining the results of a query](https://codeql.github.com/docs/writing-codeql-queries/defining-the-results-of-a-query/).”

> 您可以修改选择语句最后一列中定义的警报消息，以便使用链接和占位符提供有关警报或查询找到的路径的更多细节。有关详细信息，请参阅 "定义查询结果"。

Select clauses for path queries (`@kind path-problem`) are crafted to display both an alert and the source and sink of an associated path graph. For more information, see “[Creating path queries](https://codeql.github.com/docs/writing-codeql-queries/creating-path-queries/).”

> 路径查询的选择子句(@kind path-problem)被制作成同时显示警报和相关路径图的源和汇。有关更多信息，请参阅 "创建路径查询"。



## Viewing the standard CodeQL queries

One of the easiest ways to get started writing your own queries is to modify an existing query. To view the standard CodeQL queries, or to try out other examples, visit the [CodeQL](https://github.com/github/codeql) and [CodeQL for Go](https://github.com/github/codeql-go) repositories on GitHub.

> 开始编写自己的查询的最简单方法之一是修改现有的查询。要查看标准的CodeQL查询，或尝试其他例子，请访问GitHub上的CodeQL和CodeQL for Go资源库。

You can also find examples of queries developed to find security vulnerabilities and bugs in open source software projects on the [GitHub Security Lab website](https://securitylab.github.com/research) and in the associated [repository](https://github.com/github/securitylab).

> 你也可以在GitHub安全实验室网站和相关的仓库中找到为查找开源软件项目中的安全漏洞和错误而开发的查询示例。

## Contributing queries

Contributions to the standard queries and libraries are very welcome. For more information, see our [contributing guidelines](https://github.com/github/codeql/blob/main/CONTRIBUTING.md). If you are contributing a query to the open source GitHub repository, writing a custom query for LGTM, or using a custom query in an analysis with the CodeQL CLI, then you need to include extra metadata in your query to ensure that the query results are interpreted and displayed correctly. See the following topics for more information on query metadata:

> 我们非常欢迎对标准查询和库的贡献。更多信息，请参阅我们的贡献指南。如果您正在向开源GitHub仓库贡献查询，为LGTM编写自定义查询，或者在CodeQL CLI分析中使用自定义查询，那么您需要在查询中包含额外的元数据，以确保查询结果被正确解释和显示。有关查询元数据的更多信息，请参见以下主题。

* “[Metadata for CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/metadata-for-codeql-queries/)”
* [Query metadata style guide on GitHub](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md)

Query contributions to the open source GitHub repository may also have an accompanying query help file to provide information about their purpose for other users. For more information on writing query help, see the [Query help style guide on GitHub](https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md) and the “[Query help files](https://codeql.github.com/docs/writing-codeql-queries/query-help-files/).”

> 开源GitHub仓库的查询贡献也可以有一个附带的查询帮助文件，为其他用户提供有关其目的的信息。关于编写查询帮助的更多信息，请参见GitHub上的查询帮助样式指南和 "查询帮助文件"。

## Query help files

When you write a custom query, we also recommend that you write a query help file to explain the purpose of the query to other users. For more information, see the [Query help style guide](https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md) on GitHub, and the “[Query help files](https://codeql.github.com/docs/writing-codeql-queries/query-help-files/).”

> 当你写一个自定义查询时，我们还建议你写一个查询帮助文件，向其他用户解释查询的目的。有关更多信息，请参见 GitHub 上的查询帮助样式指南，以及 "查询帮助文件"。
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
