# Query classification and display

## Attributable Queries

The results of some queries are unsuitable for attribution to individual
developers. Most of them have a threshold value on which they trigger,
for example all metric violations and statistics based queries. The
results of such queries would all be attributed to the person pushing
the value over (or under) the threshold. Some queries only trigger when
another one doesn't. An example of this is the MaybeNull query which
only triggers if the AlwaysNull query doesn't. A small change in the
data flow could make an alert switch from AlwaysNull to MaybeNull (or
vice versa). As a result we attribute both a fix and an introduction to
the developer that changed the data flow. For this particular example
the funny attribution results are more a nuisance than a real problem;
the overall alert count remains unchanged. However, for the duplicate
and similar code queries the effects can be much more severe, as they
come in versions for "duplicate file" and "duplicate function" among
many others, where "duplicate function" only triggers if "duplicate
file" didn't. As a result adding some code to a duplicate file might
result in a "fix" of a "duplicate file" alert and an introduction of
many "duplicate function" alerts. This would be highly unfair.
Currently, only the duplicate and similar code queries exhibit this
"exchanging one for many" alerts when trying to attribute their results.
Therefore we currently exclude all duplicate code related alerts from
attribution.

> 一些查询的结果不适合归属到个人。
> 开发者。它们中的大多数都有一个触发的阈值。
> 例如，所有的度量违规和基于统计的查询。的
> 这些查询的结果将全部归属于推送者
> 值超过（或低于）阈值。有些查询只有当
> 另一个则没有。这方面的一个例子是 MaybeNull 查询，该查询可以
> 只有当AlwaysNull查询不触发时才会触发。在
> 数据流可以使警报从AlwaysNull切换到MaybeNull（或者是
> 反之亦然）。) 因此，我们把修复和介绍都归结于
> 的开发者改变了数据流。对于这个特殊的例子
> 滑稽的归因结果与其说是一个真正的问题，不如说是一个麻烦。
> 整体警报数保持不变。然而，对于重复的
> 和类似的代码查询的影响可能会严重得多，因为它们
> 有 "重复文件 "和 "重复功能 "的版本。
> 许多其他的功能，其中 "重复的功能 "只有在 "重复的 "时才会触发。
> 文件 "没有。因此，在一个重复的文件中添加一些代码可能会导致
> 导致 "重复文件 "警报的 "修复"，并引入了
> 许多 "重复功能 "的警报。这将是非常不公平的。
> 目前，只有重复和类似代码查询表现出这种
> "以一换多 "的警报，当试图归属其结果时。
> 因此，我们目前将所有与代码相关的重复警报从
> 归属。

The following queries are excluded from attribution:

> 以下查询不在归属范围内:

- Metric violations, i.e. the ones with metadata properties like
  `@(error|warning|recommendation)-(to|from)`
  
  > 违反度量标准，即具有元数据属性的查询，如：
  >     `@(错误|警告|建议)-(收件人|发件人)`
  
- Queries with tag `non-attributable`

    > 带有标签 "非属性 "的查询。

This check is applied when the results of a single attribution are
loaded into the datastore. This means that any change to this behaviour
will only take effect on newly attributed revisions but the historical
data remains unchanged.

> 当单项归属的结果是以下情况时，将进行该检查
> 加载到数据存储中。这意味着对这种行为的任何改变
> 只对新归属的修订生效，但对历史上的修订则无效。
> 数据保持不变。

## Query severity and precision

We currently classify queries on two axes, with some additional tags.
Those axes are severity and precision, and are defined using the
query-metadata properties `@problem.severity` and `@precision`.

> 我们目前在两个轴上对查询进行分类，并增加了一些标签。
> 这两个轴是严重性和精确性，并使用了
> 查询-元数据属性`@problem.s severity`和`@precision`。

For severity, we have the following categories:

> 对于严重性，我们有以下类别:

- Error
- Warning
- Recommendation

These categories may change in the future.

> 这些类别将来可能会改变。

For precision, we have the following categories:

> 为了精确，我们有以下类别:

- very-high
- high
- medium
- low

As [usual](https://en.wikipedia.org/wiki/Precision_and_recall),
precision is defined as the percentage of query results that are true
positives, i.e., precision = number of true positives / (number of true
positives + number of false positives). There is no hard-and-fast rule
for which precision ranges correspond to which categories.

> 如[往常](https://en.wikipedia.org/wiki/Precision_and_recall)。
> 精度是指查询结果中真实的百分比。
> 阳性，即精度=真正的阳性数/（真正的阳性数）。
> 阳性+假阳性的数量）。) 没有硬性规定
> 哪些精度范围对应哪些类别。

We expect these categories to remain unchanged for the foreseeable
future.

> 我们预计，在可预见的时间内，这些类别将保持不变。

### A note on precision

Intuitively, precision measures how well the query performs at finding the
results it is supposed to find, i.e., how well it implements its
(informal, unwritten) rule. So how precise a query is depends very much
on what we consider that rule to be. We generally try to sharpen our
rules to focus on results that a developer might actually be interested
in.

> 直观地讲，精度衡量的是查询在找到
> 它应该找到的结果，也就是说，它对其 (非正式的、不成文的)规则。所以，一个查询的精确程度在很大程度上取决于 关于我们认为的规则是什么。我们通常会努力使我们的 规则来关注开发者可能真正感兴趣的结果。

## Which queries to run and display on LGTM

The following queries are run:

Precision:     | very-high | high    | medium  | low
---------------|-----------|---------|---------|----
Error          | **Yes**   | **Yes** | **Yes** | No
Warning        | **Yes**   | **Yes** | **Yes** | No
Recommendation | **Yes**   | **Yes** | No      | No

The following queries have their results displayed by default:

Precision:     | very-high | high    | medium | low
---------------|-----------|---------|--------|----
Error          | **Yes**   | **Yes** | No     | No
Warning        | **Yes**   | **Yes** | No     | No
Recommendation | **Yes**   | No      | No     | No

Results for queries that are run but not displayed by default can be
made visible by editing the project configuration.

> 已运行但默认不显示的查询结果可以是
> 通过编辑项目配置使之可见。

Queries from custom query packs (in-repo or site-wide) are always run
and displayed by default. They can be hidden by editing the project
config, and "disabled" by removing them from the query pack.

> 自定义查询包（in-repo或site-wide）的查询总是运行在
> 并默认显示。它们可以通过编辑项目的
> 配置，并通过从查询包中删除 "禁用"。