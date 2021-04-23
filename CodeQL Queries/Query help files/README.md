# Query help files[¶](https://codeql.github.com/docs/writing-codeql-queries/query-help-files/#query-help-files)



Query help files tell users the purpose of a query, and recommend how to solve the potential problem the query finds.

> 查询帮助文件告诉用户查询的目的，并推荐如何解决查询发现的潜在问题。

This topic provides detailed information on the structure of query help files. For more information about how to write useful query help in a style that is consistent with the standard CodeQL queries, see the [Query help style guide](https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md) on GitHub.

> 本主题提供了关于查询帮助文件结构的详细信息。关于如何以与标准CodeQL查询一致的风格编写有用的查询帮助的更多信息，请参阅GitHub上的查询帮助风格指南。

> Note
>
> You can access the query help for CodeQL queries by visiting [CodeQL query help](https://codeql.github.com/codeql-query-help). You can also access the raw query help files in the [GitHub repository](https://github.com/github/codeql). For example, see the [JavaScript security queries](https://github.com/github/codeql/tree/main/javascript/ql/src/Security) and [C/C++ critical queries](https://github.com/github/codeql/tree/main/cpp/ql/src/Critical).
>
> 您可以通过访问CodeQL查询帮助来访问CodeQL查询帮助。您也可以访问GitHub仓库中的原始查询帮助文件。例如，请参阅JavaScript安全查询和C/C++关键查询。
>
> For queries run by default on LGTM, there are several different ways to access the query help. For further information, see [Where do I see the query help for a query on LGTM?](https://lgtm.com/help/lgtm/query-help#where-query-help-in-lgtm) in the LGTM user help.
>
> 对于在LGTM上默认运行的查询，有几种不同的方式来访问查询帮助。更多信息，请参阅LGTM用户帮助中的LGTM上的查询帮助。

## Overview

Each query help file provides detailed information about the purpose and use of a query. When you write your own queries, we recommend that you also write query help files so that other users know what the queries do, and how they work.

> 每个查询帮助文件都提供了关于查询的目的和使用的详细信息。当你编写自己的查询时，我们建议你也编写查询帮助文件，以便其他用户知道查询的目的和工作方式。

## Structure

Query help files are written using a custom XML format, and stored in a file with a `.qhelp` extension. Query help files must have the same base name as the query they describe, and must be located in the same directory. The basic structure is as follows:

> 查询帮助文件使用自定义的XML格式编写，并存储在一个扩展名为.qhelp的文件中。查询帮助文件必须与它们所描述的查询具有相同的基本名称，并且必须位于同一目录中。基本结构如下。

```
<!DOCTYPE qhelp SYSTEM "qhelp.dtd">
<qhelp>
    CONTAINS one or more section-level elements
</qhelp>
```

The header and single top-level `qhelp` element are both mandatory. The following sections explain additional elements that you may include in your query help files.

> 头部和单个顶层qhelp元素都是强制性的。下面的章节解释了您可以在查询帮助文件中包含的其他元素。

## Section-level elements

Section-level elements are used to group the information in the help file into sections. Many sections have a heading, either defined by a `title` attribute or a default value. The following section-level elements are optional child elements of the `qhelp` element.

> 节段级元素用于将帮助文件中的信息分成若干节。许多章节都有一个标题，由标题属性或默认值定义。下面的章节级元素是qhelp元素的可选子元素。

| Element          | Attributes                            | Children          | Purpose of section                                           |                                                              |
| :--------------- | :------------------------------------ | :---------------- | :----------------------------------------------------------- | ------------------------------------------------------------ |
| `example`        | None                                  | Any block element | Demonstrate an example of code that violates the rule implemented by the query with guidance on how to fix it. Default heading. | 展示一个违反查询实现的规则的代码示例，并指导如何修复。默认标题。 |
| `fragment`       | None                                  | Any block element | See “[Query help inclusion](https://codeql.github.com/docs/writing-codeql-queries/query-help-files/#qhelp-inclusion)” below. No heading. | 参见下面的 "查询帮助包含"。无标题。                          |
| `hr`             | None                                  | None              | A horizontal rule. No heading.                               | 一个水平规则。无标题。                                       |
| `include`        | `src` The query help file to include. | None              | Include a query help file at the location of this element. See “[Query help inclusion](https://codeql.github.com/docs/writing-codeql-queries/query-help-files/#qhelp-inclusion)” below. No heading. | 在该元素的位置包含一个查询帮助文件。参见下面的 "包含查询帮助"。无标题。 |
| `overview`       | None                                  | Any block element | Overview of the purpose of the query. Typically this is the first section in a query document. No heading. | 查询目的的概述。通常这是查询文档中的第一节。无标题。         |
| `recommendation` | None                                  | Any block element | Recommend how to address any alerts that this query identifies. Default heading. | 建议如何处理此查询识别的任何警报。默认标题。                 |
| `references`     | None                                  | `li` elements     | Reference list. Typically this is the last section in a query document. Default heading. | 引用列表。通常这是查询文档的最后一节。缺省标题。             |
| `section`        | `title` Title of the section          | Any block element | General-purpose section with a heading defined by the `title` attribute. | 通用节的标题由标题属性定义。                                 |
| `semmleNotes`    | None                                  | Any block element | Implementation notes about the query. This section is used only for queries that implement a rule defined by a third party. Default heading. | 查询的实现说明。本节仅用于实现第三方定义的规则的查询。默认的标题。 |

## Block elements

The following elements are optional child elements of the `section`, `example`, `fragment`, `recommendation`, `overview`, and `semmleNotes` elements.

> 以下元素是section、example、fragment、recommendation、overview和semmleNotes元素的可选子元素。

| Element      | Attributes                                                   | Children           | Purpose of block                                             |                                                              |
| :----------- | :----------------------------------------------------------- | :----------------- | :----------------------------------------------------------- | ------------------------------------------------------------ |
| `blockquote` | None                                                         | Any block element  | Display a quoted paragraph.                                  | 显示被引用的段落。                                           |
| `img`        | `src` The image file to include.`alt` Text for the image’s alt text.`height` Optional, height of the image.`width` Optional, the width of the image. | None               | Display an image. The content of the image is in a separate image file. | 显示图像。图片的内容在一个单独的图片文件中。                 |
| `include`    | `src` The query help file to include.                        | None               | Include a query help file at the location of this element. See [Query help inclusion](https://codeql.github.com/docs/writing-codeql-queries/query-help-files/#qhelp-inclusion) below for more information. | 在这个元素的位置包含一个查询帮助文件。更多信息请参见下面的查询帮助文件。 |
| `ol`         | None                                                         | `li`               | Display an ordered list. See List elements below.            | 显示一个有序的列表。参见下面的列表元素。                     |
| `p`          | None                                                         | Any inline content | Display a paragraph, used as in HTML files.                  | 显示一个段落，和HTML文件一样使用。                           |
| `pre`        | None                                                         | Text               | Display text in a monospaced font with preformatted whitespace. | 以单倍行距字体显示文本，并预置空白。                         |
| `sample`     | `language` The language of the in-line code sample.`src` Optional, the file containing the sample code. | Text               | Display sample code either defined as nested text in the `sample` element or defined in the `src` file specified. When `src` is specified, the language is inferred from the file extension. If `src` is omitted, then language must be provided and the sample code provided as nested text. | 显示示例代码，可以在示例元素中定义为嵌套文本，也可以在指定的src文件中定义。当指定src时，语言是由文件扩展名推断出来的。如果省略src，则必须提供语言，并以嵌套文本的形式提供样本代码。 |
| `table`      | None                                                         | `tbody`            | Display a table. See Tables below.                           | 显示一个表格。参见下面的表格。                               |
| `ul`         | None                                                         | `li`               | Display an unordered list. See List elements below.          | 显示一个无序的列表。参见下面的列表元素。                     |
| `warning`    | None                                                         | Text               | Display a warning that will be displayed very visibly on the resulting page. Such warnings are sometimes used on queries that are known to have low precision for many code bases; such queries are often disabled by default. | 显示一个警告，该警告将非常明显地显示在结果页面上。这种警告有时会被用于对许多代码库来说精度较低的查询；这种查询通常被默认禁用。 |

## List elements

Query help files support two types of block elements for lists: `ul` and `ol`. Both block elements support only one child elements of the type `li`. Each `li` element contains either inline content or a block element.

> 查询帮助文件支持两种类型的列表块元素：ul和ol。这两种块元素都只支持一个类型为li的子元素。每个li元素包含内联内容或块元素。

## Table elements

The `table` block element is used to include a table in a query help file. Each table includes a number of rows, each of which includes a number of cells. The data in the cells will be rendered as a grid.

> 表块元素用于在查询帮助文件中包含一个表。每个表都包括一些行，每个行都包括一些单元格。单元格中的数据将以网格的形式呈现。

| Element | Attributes | Children           | Purpose                                   |                              |
| :------ | :--------- | :----------------- | :---------------------------------------- | ---------------------------- |
| `tbody` | None       | `tr`               | Defines the top-level element of a table. | 定义表的顶层元素。           |
| `tr`    | None       | `th``td`           | Defines one row of a table.               | 定义表格中的一行。           |
| `td`    | None       | Any inline content | Defines one cell of a table row.          | 定义表格行的一个单元格。     |
| `th`    | None       | Any inline content | Defines one header cell of a table row.   | 定义表格行的一个标题单元格。 |

## Inline content

Inline content is used to define the content for paragraphs, list items, table cells, and similar elements. Inline content includes text in addition to the inline elements defined below:

> 内联内容用于定义段落、列表项、表格单元格和类似元素的内容。内联内容除了下面定义的内联元素外，还包括文本:

| Element  | Attributes                  | Children       | Purpose                                                      |                                                             |
| :------- | :-------------------------- | :------------- | :----------------------------------------------------------- | ----------------------------------------------------------- |
| `a`      | `href` The URL of the link. | text           | Defines hyperlink. When a user selects the child text, they will be redirected to the given URL. | 定义超链接。当用户选择子文本时，他们将被重定向到指定的URL。 |
| `b`      | None                        | Inline content | Defines content that should be displayed as bold face.       | 定义应该以粗体字显示的内容。                                |
| `code`   | None                        | Inline content | Defines content representing code. It is typically shown in a monospace font. | 定义代表代码的内容。它通常以单色字体显示。                  |
| `em`     | None                        | Inline content | Defines content that should be emphasized, typically by italicizing it. | 定义应该强调的内容，通常以斜体显示。                        |
| `i`      | None                        | Inline content | Defines content that should be displayed as italics.         | 定义应该以斜体显示的内容。                                  |
| `img`    | `src``alt``height``width`   | None           | Display an image. See the description above in Block elements. | 显示图像。请看上面的块元素的描述。                          |
| `strong` | None                        | Inline content | Defines content that should be rendered more strongly, typically using bold face. | 定义应该更强烈地显示的内容，通常使用粗体。                  |
| `sub`    | None                        | Inline content | Defines content that should be rendered as subscript.        | 定义应该以下标形式显示的内容。                              |
| `sup`    | None                        | Inline content | Defines content that should be rendered as superscript.      | 内联内容 定义应该以上标形式呈现的内容。                     |
| `tt`     | None                        | Inline content | Defines content that should be displayed with a monospace font. | 定义应以单倍体字体显示的内容。                              |



## Query help inclusion

To reuse content between different help topics, you can store shared content in one query help file and then include it in a number of other query help files using the `include` element. The shared content can be stored either in the same directory as the including files, or in `SEMMLE_DIST/docs/include`. When a query help file is only included by other help files but does not belong to a specific query, it should have the file extension `.inc.qhelp`.

> 为了在不同的帮助主题之间重用内容，你可以将共享内容存储在一个查询帮助文件中，然后将其包含在其他一些使用include元素的查询帮助文件中。共享的内容可以存储在同一目录下的包括文件，或在SEMMLE_DIST/docs/include。当一个查询帮助文件只被其他帮助文件包含，但不属于一个特定的查询，它应该有文件扩展名.inc.qhelp。

The `include` element can be used as a section or block element. The content of the query help file defined by the `src` attribute must contain elements that are appropriate to the location of the `include` element.

>  include元素可以作为一个章节或块元素使用。由src属性定义的查询帮助文件的内容必须包含适合include元素位置的元素。

### Section-level include elements

Section-level `include` elements can be located beneath the top-level `qhelp` element. For example, in [StoredXSS.qhelp](https://github.com/github/codeql/blob/main/csharp/ql/src/Security Features/CWE-079/StoredXSS.qhelp), a full query help file is reused:

> 节级的包含元素可以位于顶层qhelp元素的下方。例如，在StoredXSS.qhelp中，重用了一个完整的查询帮助文件:

```
<qhelp>
    <include src="XSS.qhelp" />
</qhelp>
```

In this example, the [XSS.qhelp](https://github.com/github/codeql/blob/main/csharp/ql/src/Security Features/CWE-079/XSS.qhelp) file must conform to the standard for a full query help file as described above. That is, the `qhelp` element may only contain non-`fragment`, section-level elements.

> 在这个例子中，XSS.qhelp文件必须符合上述完整查询帮助文件的标准。也就是说，qhelp元素只能包含非片段、部分级别的元素。

### Block-level include elements

Block-level `include` elements can be included beneath section-level elements. For example, an `include` element is used beneath the `overview` section in [ThreadUnsafeICryptoTransform.qhelp](https://github.com/github/codeql/blob/main/csharp/ql/src/Likely Bugs/ThreadUnsafeICryptoTransform.qhelp):

> 块级的include元素可以包含在节级元素下面。例如，在ThreadUnsafeICryptoTransform.qhelp中的概览部分下面使用了一个include元素:

```
<qhelp>
    <overview>
        <include src="ThreadUnsafeICryptoTransformOverview.inc.qhelp" />
    </overview>
    ...
</qhelp>
```

The included file, [ThreadUnsafeICryptoTransformOverview.inc.qhelp](https://github.com/github/codeql/blob/main/csharp/ql/src/Likely Bugs/ThreadUnsafeICryptoTransformOverview.inc.qhelp), may only contain one or more `fragment` sections. For example:

> 包含的文件ThreadUnsafeICryptoTransformOverview.inc.qhelp可能只包含一个或多个片段部分。例如:

```
<!DOCTYPE qhelp SYSTEM "qhelp.dtd">
<qhelp>
   <fragment>
      <p>
         ...
      </p>
   </fragment>
</qhelp>
```



 