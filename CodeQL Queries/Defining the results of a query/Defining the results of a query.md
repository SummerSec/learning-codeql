# Defining the results of a query

You can control how analysis results are displayed in source code by modifying a query’s `select` statement.

> 您可以通过修改查询的选择语句来控制分析结果在源代码中的显示方式。

## About query results

The information contained in the results of a query is controlled by the `select` statement. Part of the process of developing a useful query is to make the results clear and easy for other users to understand. When you write your own queries in the query console or in the CodeQL [extension for VS Code](https://codeql.github.com/docs/codeql-for-visual-studio-code/#codeql-for-visual-studio-code) there are no constraints on what can be selected. However, if you want to use a query to create alerts in LGTM or generate valid analysis results using the [CodeQL CLI](https://codeql.github.com/docs/codeql-cli/#codeql-cli), you’ll need to make the `select` statement report results in the required format. You must also ensure that the query has the appropriate metadata properties defined. This topic explains how to write your select statement to generate helpful analysis results.

> 查询结果中包含的信息由选择语句控制。开发一个有用的查询的过程中，有一部分是为了让结果清晰，便于其他用户理解。当你在查询控制台或VS Code的CodeQL扩展中编写自己的查询时，对可以选择的内容没有限制。但是，如果你想使用查询在LGTM中创建警报或使用CodeQL CLI生成有效的分析结果，你需要使选择语句报告结果的格式符合要求。您还必须确保查询具有适当的元数据属性定义。这个主题解释了如何编写选择语句来生成有用的分析结果。

## Overview

Alert queries must have the property `@kind problem` defined in their metadata. For more information, see “[Metadata for CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/metadata-for-codeql-queries/).” In their most basic form, the `select` statement must select two ‘columns’:

> 警报查询必须在其元数据中定义属性@kind问题。更多信息，请参阅 "CodeQL查询的元数据"。在其最基本的形式中，选择语句必须选择两个 "列":

* **Element**—a code element that’s identified by the query. This defines the location of the alert.

    > 元素--一个被查询识别的代码元素。这定义了警报的位置。

* **String**—a message to display for this code element, describing why the alert was generated.

    > 字符串--要为这个代码元素显示的消息，描述为什么会产生警报。

If you look at some of the LGTM queries, you’ll see that they can select extra element/string pairs, which are combined with `$@` placeholder markers in the message to form links. For example, [Dereferenced variable may be null](https://lgtm.com/query/rule:1954750296/lang:java/) (Java), or [Duplicate switch case](https://lgtm.com/query/rule:7890077/lang:javascript/) (JavaScript).

> 如果你看了一些LGTM查询，你会发现它们可以选择额外的元素/字符串对，这些元素/字符串与消息中的$@占位符结合在一起，形成链接。例如， Dereferenced变量可能是null（Java），或者Duplicate switch case（JavaScript）。

> Note
>
> An in-depth discussion of `select` statements for path queries is not included in this topic. However, you can develop the string column of the `select` statement in the same way as for alert queries. For more specific information about path queries, see “[Creating path queries](https://codeql.github.com/docs/writing-codeql-queries/creating-path-queries/).”
>
> > 本主题中不包括对路径查询的选择语句的深入讨论。但是，您可以以与警报查询相同的方式开发选择语句的字符串列。有关路径查询的更多具体信息，请参阅 "创建路径查询"。

## Developing a select statement

Here’s a simple query that uses the standard CodeQL `CodeDuplication.qll` library to identify similar files.

> 这里有一个简单的查询，使用标准的CodeQL CodeDuplication.qll库来识别类似的文件。

### Basic select statement

```
import java
import external.CodeDuplication

from File f, File other, int percent
where similarFiles(f, other, percent)
select f, "This file is similar to another file."
```

This basic select statement has two columns:

> 这个基本的select语句有两列:

1. Element to display the alert on: `f` corresponds to `File`.

    > 要在上面显示警报的元素： f对应于文件。

2. String message to display: `"This file is similar to another file."`

    > 要显示的字符串消息。"这个文件与另一个文件相似"

![Results of basic select statement](https://codeql.github.com/docs/_images/ql-select-statement-basic.png)

### Including the name of the similar file

The alert message defined by the basic select statement is constant and doesn’t give users much information. Since the query identifies the similar file (`other`), it’s easy to extend the `select` statement to report the name of the similar file. For example:

> 基本的select语句定义的提示信息是不变的，并不能给用户提供太多信息。由于查询确定了相似的文件（其他），所以很容易扩展select语句，报告相似文件的名称。例如:

```
select f, "This file is similar to " + other.getBaseName()
```

1. Element: `f` as before. 元素：f如前。

2. String message: `"This file is similar to "`—the string text is combined with the file name for the `other`, similar file, returned by `getBaseName()`.

    > 字符串消息。"这个文件与"--字符串文本与getBaseName()返回的另一个类似文件的文件名相结合。

![Results of extended select statement](https://codeql.github.com/docs/_images/ql-select-statement-filename.png)

While this is more informative than the original select statement, the user still needs to find the other file manually.

> 虽然这样比原来的选择语句信息量大，但用户还是需要手动找到其他文件。

### Adding a link to the similar file

You can use placeholders in the text of alert messages to insert additional information, such as links to the similar file. Placeholders are defined using `$@`, and filled using the information in the next two columns of the select statement. For example, this select statement returns four columns:

> 您可以在警报消息的文本中使用占位符来插入附加信息，例如类似文件的链接。占位符使用$@来定义，并使用选择语句下两列中的信息来填充。例如，这个选择语句返回四列。

```
select f, "This file is similar to $@.", other, other.getBaseName()
```

1. Element: `f` as before.

    > 元素：f如前。

2. String message: `"This file is similar to $@."`—the string text now includes a placeholder, which will display the combined content of the next two columns.

    > 字符串信息。"这个文件类似于$@。"--字符串文本现在包括一个占位符，它将显示下两列的合并内容。

3. Element for placeholder: `other` corresponds to the similar file.

    > 占位符的元素：其他对应于相似的文件。

4. String text for placeholder: the short file name returned by `other.getBaseName()`.

    > 占位符的字符串文本：other.getBaseName()返回的短文件名。

When the alert message is displayed, the `$@` placeholder is replaced by a link created from the contents of the third and fourth columns defined by the `select` statement.

> 当显示提示信息时，$@占位符会被由选择语句定义的第三列和第四列的内容创建的链接所取代。

If you use the `$@` placeholder marker multiple times in the description text, then the `N`th use is replaced by a link formed from columns `2N+2` and `2N+3`. If there are more pairs of additional columns than there are placeholder markers, then the trailing columns are ignored. Conversely, if there are fewer pairs of additional columns than there are placeholder markers, then the trailing markers are treated as normal text rather than placeholder markers.

> 如果在描述文本中多次使用$@占位符标记，那么第N次使用将被由第2N+2列和第2N+3列形成的链接所取代。如果附加列的对数多于占位标记的对数，那么后面的列将被忽略。相反，如果附加列的对数少于占位标记，那么尾部标记将被视为正常文本而不是占位标记。

### Adding details of the extent of similarity

You could go further and change the `select` statement to report on the similarity of content in the two files, since this information is already available in the query. For example:

> 你可以进一步改变选择语句，报告两个文件中内容的相似性，因为这个信息已经在查询中得到了。例如

```
select f, percent + "% of the lines in " + f.getBaseName() + " are similar to lines in $@.", other, other.getBaseName()
```

The new elements added here don’t need to be clickable, so we added them directly to the description string.

> 这里添加的新元素不需要点击，所以我们直接添加到描述字符串中。

![Results showing the extent of similarity](https://codeql.github.com/docs/_images/ql-select-statement-similarity.png)

## Further reading

* [CodeQL repository](https://github.com/github/codeql)