# Basic query for Java code[¶](https://codeql.github.com/docs/codeql-language-guides/basic-query-for-java-code/#basic-query-for-java-code)



Learn to write and run a simple CodeQL query using LGTM.

> 学习使用LGTM编写并运行一个简单的CodeQL查询。

## About the query

The query we’re going to run performs a basic search of the code for `if` statements that are redundant, in the sense that they have an empty then branch. For example, code such as:

> 我们要运行的查询是对代码进行基本搜索，寻找多余的if语句，即它们有一个空的then分支。例如:

```
if (error) { }
```

## Running the query

1. In the main search box on LGTM.com, search for the project you want to query. For tips, see [Searching](https://lgtm.com/help/lgtm/searching).

    > 在LGTM.com的主搜索框中，搜索你要查询的项目。有关提示，请参阅搜索。

2. Click the project in the search results.

    > 点击搜索结果中的项目。

3. Click **Query this project**.

    > 点击查询这个项目。

    This opens the query console. (For information about using this, see [Using the query console](https://lgtm.com/help/lgtm/using-query-console).)

    > 这将打开查询控制台。有关使用该功能的信息，请参见使用查询控制台。

    > Note
    >
    > Alternatively, you can go straight to the query console by clicking **Query console** (at the top of any page), selecting **Java** from the **Language** drop-down list, then choosing one or more projects to query from those displayed in the **Project** drop-down list.
    >
    > 你可以直接进入查询控制台，点击查询控制台（在任何页面的顶部），从语言下拉列表中选择Java，然后从项目下拉列表中显示的项目中选择一个或多个项目进行查询。

4. Copy the following query into the text box in the query console:

    > 将以下查询复制到查询控制台的文本框中。

    ```
    import java
    
    from IfStmt ifstmt, Block block
    where ifstmt.getThen() = block and
      block.getNumStmt() = 0
    select ifstmt, "This 'if' statement is redundant."
    ```

    LGTM checks whether your query compiles and, if all is well, the **Run** button changes to green to indicate that you can go ahead and run the query.

    > 在查询框的下方列出了你要查询的项目名称，以及最近分析的项目提交的ID。右边是一个图标，表示查询操作的进度。

5. Click **Run**.

    The name of the project you are querying, and the ID of the most recently analyzed commit to the project, are listed below the query box. To the right of this is an icon that indicates the progress of the query operation:

    > 在查询框的下方列出了你要查询的项目名称，以及最近分析的项目提交的ID。右边是一个图标，表示查询操作的进度。

    ![image-20210319162604365](https://gitee.com/samny/images/raw/master/4u26er4ec/4u26er4ec.png)

    ![image-20210319164221280](https://gitee.com/samny/images/raw/master/21u42er21ec/21u42er21ec.png)

    > Note
    >
    > Your query is always run against the most recently analyzed commit to the selected project.
    >
    > > 你的查询总是针对最近分析过的项目的提交运行。

    The query will take a few moments to return results. When the query completes, the results are displayed below the project name. The query results are listed in two columns, corresponding to the two expressions in the `select` clause of the query. The first column corresponds to the expression `ifstmt` and is linked to the location in the source code of the project where `ifstmt` occurs. The second column is the alert message.

    > 查询需要几分钟才能返回结果。当查询完成后，结果会显示在项目名称下面。查询结果列在两列中，对应于查询的选择子句中的两个表达式。第一列对应表达式ifstmt，并链接到ifstmt出现的项目源代码中的位置。第二列是警报信息。

    ➤ [Example query results](https://lgtm.com/query/3235645104630320782/)

    > Note
    >
    > An ellipsis (…) at the bottom of the table indicates that the entire list is not displayed—click it to show more results.
    >
    > 表格底部的省略号(...)表示没有显示整个列表-点击它以显示更多结果。

6. If any matching code is found, click a link in the `ifstmt` column to view the `if` statement in the code viewer.

    > 如果找到任何匹配的代码，请点击ifstmt列中的链接，在代码查看器中查看if语句。

    The matching `if` statement is highlighted with a yellow background in the code viewer. If any code in the file also matches a query from the standard query library for that language, you will see a red alert message at the appropriate point within the code.

    > 匹配的if语句会在代码查看器中以黄色背景高亮显示。如果文件中的任何代码也匹配了该语言的标准查询库中的查询，您将在代码中的适当位置看到一条红色的警报信息。

### About the query structure

After the initial `import` statement, this simple query comprises three parts that serve similar purposes to the FROM, WHERE, and SELECT parts of an SQL query.

> 在初始导入语句之后，这个简单的查询由三个部分组成，其作用类似于SQL查询中的FROM、WHERE和SELECT部分。

| Query part                                                  | Purpose                                                      | Details                                                      |
| :---------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `import java`                                               | Imports the standard CodeQL libraries for Java.              | Every query begins with one or more `import` statements.     |
|                                                             | 导入Java的标准CodeQL库                                       | 每个查询都以一个或多个导入语句开始。                         |
| `from IfStmt ifstmt, Block block`                           | Defines the variables for the query. Declarations are of the form: `<type> <variable name>` | We use: an `IfStmt` variable for `if` statements ;  a `Block` variable for the then block |
|                                                             | 声明的形式是：<type> <variable name <类型> <变量名>。        | 我们使用:一个 "IfStmt "变量用于 "if "语句; a "Block "变量用于 "then "块。 |
| `where ifstmt.getThen() = block and block.getNumStmt() = 0` | Defines a condition on the variables.                        | `ifstmt.getThen() = block` relates the two variables. The block must be the `then` branch of the `if` statement.`block.getNumStmt() = 0` states that the block must be empty (that is, it contains no statements). |
|                                                             | 定义一个变量的条件。                                         | ifstmt.getThen() = block将两个变量联系起来。block必须是if语句的then分支。block.getNumStmt() = 0 说明该块必须是空的（也就是说，它不包含任何语句）。 |
| `select ifstmt, "This 'if' statement is redundant."`        | Defines what to report for each match.`select` statements for queries that are used to find instances of poor coding practice are always in the form: `select <program element>, "<alert message>"` | Reports the resulting `if` statement with a string that explains the problem. |
|                                                             | 定义了每个匹配的报告内容。用于查找不良编码实践实例的查询的select语句总是采用这样的形式：select <program element>, "<alert message>" | 用一个解释问题的字符串报告结果的if语句。                     |

## Extend the query

Query writing is an inherently iterative process. You write a simple query and then, when you run it, you discover examples that you had not previously considered, or opportunities for improvement.

> 查询的编写本质上是一个迭代的过程。你写了一个简单的查询，然后，当你运行它时，你会发现你以前没有考虑过的例子，或者改进的机会。

### Remove false positive results

Browsing the results of our basic query shows that it could be improved. Among the results you are likely to find examples of `if` statements with an `else` branch, where an empty `then` branch does serve a purpose. For example:

> 浏览我们的基本查询结果，发现它还可以改进。在这些结果中，你很可能会发现if语句带有else分支的例子，其中空的then分支确实有一定的作用。例如:

```
if (...) {
  ...
} else if ("-verbose".equals(option)) {
  // nothing to do - handled earlier
} else {
  error("unrecognized option");
}
```

In this case, identifying the `if` statement with the empty `then` branch as redundant is a false positive. One solution to this is to modify the query to ignore empty `then` branches if the `if` statement has an `else` branch.

> 在这种情况下，将带有空的then分支的if语句识别为多余的语句，是一种假阳性。一种解决方法是修改查询，如果if语句有 else分支，则忽略空then分支。

To exclude `if` statements that have an `else` branch:

> 要排除有else分支的if语句。

1. Extend the where clause to include the following extra condition:

    > 扩展where子句，加入以下额外条件:

    ```
    and not exists(ifstmt.getElse())
    ```

    The `where` clause is now:

    > 现在的where子句:

    ```
    where ifstmt.getThen() = block and
      block.getNumStmt() = 0 and
      not exists(ifstmt.getElse())
    ```

2. Click **Run**.

    There are now fewer results because `if` statements with an `else` branch are no longer included.

    > 现在结果减少了，因为不再包含带有 else 分支的 if 语句。

➤ [See this in the query console](https://lgtm.com/query/6382189874776576029/)

## Further reading

* [CodeQL queries for Java](https://github.com/github/codeql/tree/main/java/ql/src)
* [Example queries for Java](https://github.com/github/codeql/tree/main/java/ql/examples)
* [CodeQL library reference for Java](https://codeql.github.com/codeql-standard-libraries/java/)

* “[QL language reference](https://codeql.github.com/docs/ql-language-reference/#ql-language-reference)”
* “[CodeQL tools](https://codeql.github.com/docs/codeql-overview/codeql-tools/#codeql-tools)”