<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:b90ac510bb1b7aabdf6d0897ff463d293fc671830d22dc94a21a5cf3e536c84a
size 14423
=======
# Supported CodeQL queries and libraries

Queries and libraries outside [the `experimental` directories](experimental.md) are _supported_ by GitHub, allowing our users to rely on their continued existence and functionality in the future:

> 查询和[`experimental`目录](experimental.md)以外的库由GitHub提供_支持，允许我们的用户在未来继续依赖它们的存在和功能:

1. Once a query or library has appeared in a stable release, a one-year deprecation period is required before we can remove it. There can be exceptions to this when it's not technically possible to mark it as deprecated.

    > 一旦一个查询或库出现在稳定版本中，在我们删除它之前，需要一年的废弃期。当技术上无法将其标记为废弃时，可以有例外。

2. Major changes to supported queries and libraries are always announced in the [change notes for stable releases](../change-notes/).

    > 对支持的查询和库的重大更改总是在[稳定版的更改说明](.../change-notes/)中公布。

3. We will do our best to address user reports of false positives or false negatives.

    >  我们将尽最大努力解决用户报告的假阳性或假阴性问题。

Because of these commitments, we set a high bar for accepting new supported queries. The requirements are detailed in the rest of this document.

> 由于这些承诺，我们为接受新的支持查询设置了很高的门槛。这些要求在本文档的其余部分有详细说明。

## Steps for introducing a new supported query

The process must begin with the first step and must conclude with the final step. The remaining steps can be performed in any order.

> 这一过程必须从第一步开始，并以最后一步结束。其余步骤可按任何顺序进行。

1. **Have the query merged into the appropriate `experimental` subdirectory**

   See [CONTRIBUTING.md](../CONTRIBUTING.md).

   >  **将查询合并到相应的 "experimental "子目录中**。
   >
   > [CONTRIBUTING.md](./CONTRIBUTING.md)。

2. **Write a query help file**

   Query help files explain the purpose of your query to other users. Write your query help in a `.qhelp` file and save it in the same directory as your query. For more information on writing query help, see the [Query help style guide](query-help-style-guide.md).

   > 查询帮助文件向其他用户解释你的查询目的。将你的查询帮助写在`.qhelp`文件中，并将其保存在与你的查询相同的目录中。关于编写查询帮助的更多信息，请参阅[查询帮助样式指南](query-help-style-guide.md)。

   - Note, in particular, that almost all queries need to have a pair of "before" and "after" examples demonstrating the kind of problem the query identifies and how to fix it. Make sure that the examples are actually consistent with what the query does, for example by including them in your unit tests.

       > 特别要注意的是，几乎所有的查询都需要有一对 "之前 "和 "之后 "的例子来演示查询所发现的问题种类以及如何解决它。确保这些例子实际上与查询所做的事情是一致的，例如将它们包含在你的单元测试中。

   - At the time of writing, there is no way of previewing help locally. Once you've opened a PR, a preview will be created as part of the CI checks. A GitHub employee will review this and let you know of any problems.

       > 在写这篇文章的时候，还没有办法在本地预览帮助。一旦你打开了一个PR，一个预览将作为CI检查的一部分被创建。GitHub的员工会审查这个并让你知道任何问题。

3. **Write unit tests**

   Add one or more unit tests for the query (and for any library changes you make) to the `ql/<language>/ql/test/experimental` directory. Tests for library changes go into the `library-tests` subdirectory, and tests for queries go into `query-tests` with their relative path mirroring the query's location under `ql/<language>/ql/src/experimental`.

   >  在`ql/<language>/ql/test/experimental`目录下添加一个或多个单元测试，用于测试查询（以及你所做的任何库变化）。对库变化的测试进入`library-tests`子目录，对查询的测试进入`query-tests`，它们的相对路径与查询在`ql/<language>/ql/src/experimental`下的位置一致。

   See the section on [Testing custom queries](https://help.semmle.com/codeql/codeql-cli/procedures/test-queries.html) in the [CodeQL documentation](https://help.semmle.com/codeql/) for more information.

   > 更多信息请参见[CodeQL文档](https://help.semmle.com/codeql/)中的[测试自定义查询](https://help.semmle.com/codeql/codeql-cli/procedures/test-queries.html)一节。

4. **Test for correctness on real-world code**

   Test the query on a number of large real-world projects to make sure it doesn't give too many false positive results. Adjust the `@precision` and `@problem.severity` attributes in accordance with the real-world results you observe. See the advice on query metadata below.

   > 在一些大型真实世界的项目上测试该查询，以确保它不会给出太多的假阳性结果。根据你观察到的真实世界结果，调整`@precision`和`@problem.s severity`属性。参见下面关于查询元数据的建议。

   You can use the LGTM.com [query console](https://lgtm.com/query) to get an overview of true and false positive results on a large number of projects. The simplest way to do this is to:

   > 你可以使用LGTM.com[查询控制台](https://lgtm.com/query)来获得大量项目的真假阳性结果的概览。最简单的方法是：

   1. [Create a list of prominent projects](https://lgtm.com/help/lgtm/managing-project-lists) on LGTM.

       > 在LGTM上【创建突出项目列表】(https://lgtm.com/help/lgtm/managing-project-lists)。

   2. In the query console, [run your query against your custom project list](https://lgtm.com/help/lgtm/using-query-console).

       > 在查询控制台中，[针对你的自定义项目列表运行你的查询](https://lgtm.com/help/lgtm/using-query-console)。

   3. Save links to your query console results and include them in discussions on issues and pull requests.

       > 保存你的查询控制台结果的链接，并将其包含在问题和拉请求的讨论中。

5. **Test and improve performance**

   There must be a balance between the execution time of a query and the value of its results: queries that are highly valuable and broadly applicable can be allowed to take longer to run. In all cases, you need to address any easy-to-fix performance issues before the query is put into production.

   > 必须在查询的执行时间和查询结果的价值之间取得平衡：可以允许具有高度价值和广泛适用性的查询需要更长的运行时间。在所有情况下，你都需要在查询投入生产之前解决任何容易解决的性能问题。

   QL performance profiling and tuning is an advanced topic, and some tasks will require assistance from GitHub employees. With that said, there are several things you can do.

   > QL性能剖析和调优是一个高级话题，有些任务需要GitHub员工的协助。说到这里，有几件事你可以做。

   - Understand [the evaluation model of QL](https://help.semmle.com/QL/ql-handbook/evaluation.html). It's more similar to SQL than to any mainstream programming language.

       > 了解【QL的评估模型】(https://help.semmle.com/QL/ql-handbook/evaluation.html)。它更类似于SQL，而不是任何主流编程语言。

   - Most performance tuning in QL boils down to computing as few tuples (rows of data) as possible. As a mental model, think of predicate evaluation as enumerating all combinations of parameters that satisfy the predicate body. This includes the implicit parameters `this` and `result`.

       > QL中的大多数性能调优归结为计算尽可能少的元组（数据行）。作为一种心理模型，把谓词评估看作是枚举所有满足谓词体的参数组合。这包括隐含的参数`this`和`result`。

   - The major libraries in CodeQL are _cached_ and will only be computed once for the entire suite of queries. The first query that needs a cached _stage_ will trigger its evaluation. This means that query authors should usually only look at the run time of the last stage of evaluation.

       >  CodeQL中的主要库都是_缓存的，对于整个查询套件只会计算一次。第一个需要缓存_阶段的查询将触发其评估。这意味着查询作者通常应该只看最后一个阶段的评估运行时间。

   - In [the settings for the VSCode extension](https://help.semmle.com/codeql/codeql-for-vscode/reference/settings.html), check the box "Running Queries: Debug" (`codeQL.runningQueries.debug`). Then find "CodeQL Query Server" in the VSCode Output panel (View -> Output) and capture the output when running the query. That output contains timing and tuple counts for all computed predicates.

       > 在[VSCode扩展的设置](https://help.semmle.com/codeql/codeql-for-vscode/reference/settings.html)中，选中 "运行查询。调试"（`codeQL.runningQueries.debug`）。然后在VSCode输出面板(视图->输出)中找到 "CodeQL查询服务器"，捕捉运行查询时的输出。该输出包含所有计算过的谓词的计时和元组计数。

   - To clear the entire cache, invoke "CodeQL: Clear Cache" from the VSCode command palette.

       > 要清除整个缓存，请调用VSCode输出面板中的 "CodeQL: 从VSCode命令面板中清除缓存。

6. **Make sure your query has the correct metadata**

   For the full reference on writing query metadata, see the [Query metadata style guide](query-metadata-style-guide.md). The following constitutes a checklist.

   > 关于查询元数据的编写，全文参考【查询元数据样式指南】(query-metadata-style-guide.md)。下面构成一个检查表。

   a. Each query needs a `@name`, a `@description`, and a `@kind`.

   > a. 每个查询都需要一个"@name"、一个"@description "和一个"@kind"。

   b. Alert queries also need a `@problem.severity` and a `@precision`.

   > b. 告警查询还需要一个`@problem.s severity`和一个`@precision`。

      - The severity is one of `error`, `warning`, or `recommendation`.

        > 严重性是 "error"、"warning "或 "recommendation "中的一种。

      - The precision is one of `very-high`, `high`, `medium` or `low`. It may take a few iterations to get this right.

        > 精度是 "非常高"、"高"、"中 "或 "低 "中的一种。这可能需要反复几次才能搞定。

      - Currently, LGTM runs all `error` or `warning` queries with a `very-high`, `high`, or `medium` precision. In addition, `recommendation` queries with `very-high` or `high` precision are run.

        > 目前，LGTM以 "非常高"、"高 "或 "中等 "精度运行所有 "错误 "或 "警告 "查询。此外，"非常高 "或 "高 "精度的 "建议 "查询也会运行。

      - However, results from `error` and `warning` queries with `medium` precision, as well as `recommendation` queries with `high` precision, are not shown by default.

        > 但是，"中 "精度的 "错误 "和 "警告 "查询以及 "高 "精度的 "建议 "查询的结果默认不显示。

   c. All queries need an `@id`.

   > c. 所有查询都需要一个`@id`。

      - The ID should be consistent with the ids of similar queries for other languages; for example, there is a C/C++ query looking for comments containing the word "TODO" which has id `cpp/todo-comment`, and its C# counterpart has id `cs/todo-comment`.

        > 这个id应该和其他语言的类似查询的id一致；例如，有一个C/C++查询，寻找包含 "TODO "的注释，它的id是`cpp/todo-comment`，而它的C#对应的id是`cs/todo-comment`。

   d. Provide one or more `@tags` describing the query.

   > d. 提供一个或多个`@tags`来描述查询。

      - Tags are free-form, but we have some conventions. At a minimum, most queries should have at least one of `correctness`, `maintainability` or `security` to indicate the general kind of issue the query is intended to find. Security queries should also be tagged with corresponding [CWE](https://cwe.mitre.org/data/definitions/1000.html) numbers, for example `external/cwe/cwe-119` (prefer the most specific CWE that encompasses the target of the query).

        > 标签是自由形式的，但我们有一些约定。至少，大多数查询应该至少有 "正确性"、"可维护性 "或 "安全性 "中的一个，以表明查询要找到的一般问题类型。安全性查询也应标注相应的[CWE](https://cwe.mitre.org/data/definitions/1000.html)编号，例如 "external/cwe/cwe-119"(最好是包含查询目标的最具体的CWE)。

7. **Move your query out of `experimental`**

   - The structure of an `experimental` subdirectory mirrors the structure of its parent directory, so this step may just be a matter of removing the `experimental/` prefix of the query and test paths. Be sure to also edit any references to the query path in tests.
   
       >  `experimental`子目录的结构反映了它的父目录的结构，所以这一步可能只是删除查询和测试路径的`experimental/`前缀。确保也编辑测试中对查询路径的任何引用。
   
   - Add the query to one of the legacy suite files in `ql/<language>/config/suites/<language>/` if it exists. Note that there are separate suite directories for C and C++, `c` and `cpp` respectively, and the query should be added to one or both as appropriate.
   
       > 将查询添加到`ql/<language>/config/suites/<language>/`中的一个传统套件文件中，如果它存在的话。请注意，C和C++有单独的套件目录，分别是`c`和`cpp`，查询应该适当地添加到其中一个或两个目录中。
   
   - Add a release note to `change-notes/<next-version>/analysis-<language>.md`.
   
       > 在 "change-notes/<next-version>/analysis-<language>.md "中添加一个发布说明。
   
   - Your pull request will be flagged automatically for a review by the documentation team to ensure that the query help file is ready for wider use. 
   
       > 你的拉取请求将被自动标记，供文档团队审查，以确保查询帮助文件可以被更广泛地使用。
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
