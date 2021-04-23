# Query help style guide

## Introduction

When you contribute a new [supported query](supported-queries.md) to this repository, or add a custom query for analysis in LGTM, you should also write a query help file. This file provides detailed information about the purpose and use of the query, which is available to users in LGTM (for example [here](https://lgtm.com/rules/1506093386171/)) and on the query homepages:

> 当你向这个资源库贡献一个新的[支持的查询](supported-queries.md)，或者在LGTM中添加一个自定义查询进行分析时，你也应该写一个查询帮助文件。这个文件提供了关于查询目的和使用的详细信息，用户可以在LGTM中（例如[这里](https://lgtm.com/rules/1506093386171/)）和查询主页上获得这些信息:

*   [C/C++ queries](https://help.semmle.com/wiki/display/CCPPOBJ/)
*   [C# queries](https://help.semmle.com/wiki/display/CSHARP/)
*   [Java queries](https://help.semmle.com/wiki/display/JAVA/)
*   [JavaScript queries](https://help.semmle.com/wiki/display/JS/)
*   [Python queries](https://help.semmle.com/wiki/display/PYTHON/)

### Location and file name

Query help files must have the same base name as the query they describe and must be located in the same directory.  

> 查询帮助文件必须与它们所描述的查询有相同的基本名称，并且必须位于同一目录中。 

### File structure and layout

Query help files are written using a custom XML format, and stored in a file with a `.qhelp` extension. The basic structure is as follows:

> 查询帮助文件使用自定义的XML格式编写，并存储在一个扩展名为`.qhelp`的文件中。基本结构如下:

```
<!DOCTYPE qhelp SYSTEM "qhelp.dtd">
<qhelp>
    CONTAINS one or more section-level elements
</qhelp>
```

The header and single top-level `<qhelp>` element are both mandatory. 

> 头部和单个顶层`<qhelp>`元素都是强制性的。

### Section-level elements

Section-level elements are used to group the information within the query help file. All query help files should include at least the following section elements, in the order specified:

> 节级元素用于对查询帮助文件中的信息进行分组。所有的查询帮助文件至少应该按照指定的顺序包含以下章节元素:

1. `overview`—a short summary of the issue that the query identifies, including an explanation of how it could affect the behavior of the program.

    > “概述” - 查询识别的问题的简短摘要，包括解释它如何影响程序的行为。

2. `recommendation`—information on how to fix the issue highlighted by the query.

    >  `recommendation`--关于如何修复查询所强调的问题的信息。

3. `example`—an example of code showing the problem. Where possible, this section should also include a solution to the issue.

    >  `example`--显示问题的代码示例。在可能的情况下，这部分还应该包括问题的解决方案。

4. `references`—relevant references, such as authoritative sources on language semantics and best practice. 

    >  `references`--相关的参考资料，比如语言语义和最佳实践的权威来源。

For further information about the other section-level, block, list and table elements supported by query help files, see [Query help files](https://help.semmle.com/QL/learn-ql/ql/writing-queries/query-help.html) on help.semmle.com.

> 关于查询帮助文件支持的其他节级、块、列表和表元素的更多信息，请参见help.semmle.com上的[查询帮助文件](https://help.semmle.com/QL/learn-ql/ql/writing-queries/query-help.html)。


## English style

You should write the overview and recommendation elements in simple English that is easy to follow. You should:

> 你应该用简单的英语写出概述和推荐的内容，让人一目了然。您应该：

* Use simple sentence structures and avoid complex or academic language.

    > 使用简单的句子结构，避免使用复杂或学术性语言

* Avoid colloquialisms and contractions.

    > 避免使用俗语和缩略语。

* Use US English spelling throughout.

    >  使用美式英语拼写。

* Use words that are in common usage.

    > 使用常用词。

## Code examples

Whenever possible, you should include a code example that helps to explain the issue you are highlighting. Any code examples that you include should adhere to the following guidelines:

> 在可能的情况下，你应该包括一个有助于解释你所强调的问题的代码例子。您所包含的任何代码示例都应遵守以下准则： 

* The example should be less than 20 lines, but it should still clearly illustrate the issue that the query identifies.  If appropriate, then the example may also be runnable.

    > 示例应少于20行，但仍应清楚地说明查询所确定的问题。 如果合适的话，这个例子也可以是可运行的。

* Put the code example after the recommendation element where possible. Only include an example in the description element if absolutely necessary.

    >  尽可能将代码示例放在建议元素之后。只有在绝对必要的情况下，才在描述元素中加入示例。

* If you are using an example to illustrate the solution to a problem, and the change required is minor, avoid repeating the whole example. It is preferable to either describe the change required or to include a smaller snippet of the corrected code.

    > 如果你使用一个例子来说明问题的解决方案，而且所需的改变很小，避免重复整个例子。最好是描述所需的修改，或者包含一个较小的修改后的代码片段。

* Clearly indicate which of the samples is an example of bad coding practice and which is recommended practice.

    > 清楚地指出哪些示例是不良编码实践的例子，哪些是推荐的实践。

* Define the code examples in `src` files. The language is inferred from the file extension:

    > 在`src`文件中定义代码示例。语言是根据文件扩展名推断出来的。

```
<example>
<p>This example highlights poor coding practice</p>

<sample src = "example-code-bad.java" />

<p>This example shows how to fix the code</p>

<sample src = "example-code-fixed.java" />
</example>
```

Note, if any code words are included in the `overview` and `recommendation` sections, they should be formatted with `<code> ... </code>` for emphasis.

> 请注意，如果在 "意见 "和 "建议 "两节中包含任何编码词，应以"<code>. "作为格式。</code>`以示强调。

## Including references

You should include one or more references, list formatted with `<li> ... </li>` for each item, to provide further information about the problem that your query is designed to find. References can be of the following types:

> 你应该包括一个或多个参考文献，列表格式为"<li>......"，为每个项目提供有关你的查询所设计的问题的进一步信息。</li>`为每个项目提供关于你的查询所要找的问题的进一步信息。参考文献可以是以下几种类型:

### Books

If you are citing a book, use the following format:

> 如果你要引用一本书，请使用以下格式:

>\<Author-initial. Surname>, _\<Book title>_ \<page/chapter etc.\>, \<Publisher\>, \<date\>.

For example:

>W. C. Wake, _Refactoring Workbook_, pp. 93 – 94, Addison-Wesley Professional, 2004.

Note, & symbols need to be replaced by \&amp;. The symbol will be displayed correctly in the HTML files generated from the query help files.

> 注意，&符号需要用\&amp;代替。该符号将正确显示在由查询帮助文件生成的HTML文件中。

### Academic papers

If you are citing an academic paper, we recommend adopting the reference style of the journal that you are citing. For example: 

> 如果您在引用学术论文时，我们建议采用您所引用的期刊的参考文献风格。例如：

>S. R. Chidamber and C. F. Kemerer, _A metrics suite for object-oriented design_. IEEE Transactions on Software Engineering, 20(6):476-493, 1994.


### Websites

If you are citing a website, please use the following format, without breadcrumb trails:

> 如果你引用的是一个网站，请使用以下格式，不要有面包屑痕迹:

>\<Name of website>: \<Name of page or anchor>

For example:

>Java 6 API Specification: [Object.clone()](http://docs.oracle.com/javase/6/docs/api/java/lang/Object.html#clone%28%29).

### Referencing potential security weaknesses

If your query checks code for a CWE weakness, you should use the `@tags` element in the query file to reference the associated CWEs, as explained [here](query-metadata-style-guide.md). When you use these tags, a link to the appropriate entry from the [MITRE.org](https://cwe.mitre.org/scoring/index.html) site will automatically appear as a reference in the output HTML file.

> 如果您的查询检查CWE弱点的代码，您应该在查询文件中使用`@tags`元素来引用相关的CWE，如[这里](query-metadata-style-guide.md)所述。当您使用这些标签时，来自 [MITRE.org](https://cwe.mitre.org/scoring/index.html) 站点的适当条目的链接将自动作为引用出现在输出的 HTML 文件中。

## Query help example 

The following example is a query help file for a query from the standard query suite for Java: 

> 下面的例子是一个Java标准查询套件的查询帮助文件:

```
<!DOCTYPE qhelp PUBLIC
  "-//Semmle//qhelp//EN"
  "qhelp.dtd">
<qhelp>

<overview>
<p>A control structure (an <code>if</code> statement or a loop) has a body that is either a block
of statements surrounded by curly braces or a single statement.</p>

<p>If you omit braces, it is particularly important to ensure that the indentation of the code
matches the control flow of the code.</p>

</overview>
<recommendation>

<p>It is usually considered good practice to include braces for all control
structures in Java. This is because it makes it easier to maintain the code
later. For example, it's easy to see at a glance which part of the code is in the
scope of an <code>if</code> statement, and adding more statements to the body of the <code>if</code>
statement is less error-prone.</p>

<p>You should also ensure that the indentation of the code is consistent with the actual flow of 
control, so that it does not confuse programmers.</p>

</recommendation>
<example>

<p>In the example below, the original version of <code>Cart</code> is missing braces. This means 
that the code triggers a <code>NullPointerException</code> at runtime if <code>i</code>
is <code>null</code>.</p>

<sample src="UseBraces.java" />

<p>The corrected version of <code>Cart</code> does include braces, so
that the code executes as the indentation suggests.</p>

<sample src="UseBracesGood.java" />

<p>
In the following example the indentation may or may not be misleading depending on your tab width
settings. As such, mixing tabs and spaces in this way is not recommended, since what looks fine in
one context can be very misleading in another.
</p>

<sample src="UseBraces2.java" />

<p>
If you mix tabs and spaces in this way, then you might get seemingly false positives, since your
tab width settings cannot be taken into account.
</p>

</example>
<references>

<li>
  Java SE Documentation:
  <a href="http://www.oracle.com/technetwork/java/javase/documentation/codeconventions-142311.html#15395">Compound Statements</a>.
</li>
<li>
  Wikipedia:
  <a href="https://en.wikipedia.org/wiki/Indent_style">Indent style</a>.
</li>

</references>
</qhelp>
```
