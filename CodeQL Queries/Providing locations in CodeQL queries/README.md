# Providing locations in CodeQL queries[¶](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/#providing-locations-in-codeql-queries)

CodeQL includes mechanisms for extracting the location of elements in a codebase. Use these mechanisms when writing custom CodeQL queries and libraries to help display information to users.

> CodeQL包括提取代码库中元素位置的机制。在编写自定义的CodeQL查询和库时使用这些机制来帮助向用户显示信息。

## About locations

When displaying information to the user, LGTM needs to be able to extract location information from the results of a query. In order to do this, all QL classes which can provide location information should do this by using one of the following mechanisms:

> 在向用户显示信息时，LGTM需要能够从查询结果中提取位置信息。为了做到这一点，所有能够提供位置信息的QL类都应该通过使用以下机制之一来实现:

* [Providing URLs](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/#providing-urls)

* [Providing location information](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/#providing-location-information)

* [Using extracted location information](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/#using-extracted-location-information)

    > 使用提取的位置信息

This list is in priority order, so that the first available mechanism is used.

> 这个列表是按优先顺序排列的，因此，第一个可用的机制被使用。

> Note
>
> Since QL is a relational language, there is nothing to enforce that each entity of a QL class is mapped to precisely one location. This is the responsibility of the designer of the library (or the extractor, in the case of the third option below). If entities are assigned no location at all, users will not be able to click through from query results to the source code viewer. If multiple locations are assigned, results may be duplicated.
>
> 因为QL是一种关系语言，所以没有任何东西可以强制要求QL类的每个实体都精确地映射到一个位置。这是库的设计者的责任（或者在下面第三个选项的情况下，是提取器的责任）。如果实体根本没有被分配位置，用户将无法从查询结果点击到源代码查看器。如果分配了多个位置，结果可能会重复。

### Providing URLs

A custom URL can be provided by defining a QL predicate returning `string` with the name `getURL` – note that capitalization matters, and no arguments are allowed. For example:

> 可以通过定义一个名为getURL的QL谓词返回字符串来提供一个自定义的URL--注意，大写很重要，而且不允许有任何参数。例如

```
class JiraIssue extends ExternalData {
    JiraIssue() {
        getDataPath() = "JiraIssues.csv"
    }

    string getKey() {
        result = getField(0)
    }

    string getURL() {
        result = "http://mycompany.com/jira/" + getKey()
    }
}
```

#### File URLs

LGTM supports the display of URLs which define a line and column in a source file.

> LGTM支持显示URL，它定义了源文件中的一行和一列。

The schema is `file://`, which is followed by the absolute path to a file, followed by four numbers separated by colons. The numbers denote start line, start column, end line and end column. Both line and column numbers are **1-based**, for example:

> 模式是file://，后面是文件的绝对路径，然后是四个数字，用冒号隔开。数字表示开始行、开始列、结束行和结束列。例如，行号和列号都是基于1的。

* `file://opt/src/my/file.java:0:0:0:0` is used to link to an entire file.

    > file://opt/src/my/file.java:0:0:0用于链接到整个文件。

* `file:///opt/src/my/file.java:1:1:2:1` denotes the location that starts at the beginning of the file and extends to the first character of the second line (the range is inclusive).

    > file:///opt/src/my/file.java:1:1:2:1表示从文件开头开始，延伸到第二行第一个字符的位置（范围是包含的）。

* `file:///opt/src/my/file.java:1:0:1:0` is taken, by convention, to denote the entire first line of the file.

    > file:///opt/src/my/file.java:1:0:1:0，按照惯例，表示整个文件的第一行。

By convention, the location of an entire file may also be denoted by a `file://` URL without trailing numbers. Optionally, the location within a file can be denoted using three numbers to define the start line number, character offset and character length of the location respectively. Results of these types are not displayed in LGTM.

> 按照惯例，整个文件的位置也可以用file://URL来表示，而不用尾数。可选地，文件中的位置可以用三个数字来表示，分别定义位置的起始行号、字符偏移量和字符长度。这些类型的结果不在LGTM中显示。

#### Other types of URL

The following, less-common types of URL are valid but are not supported by LGTM and will be omitted from any results:

> 以下不常见的URL类型是有效的，但不被LGTM支持，并将从任何结果中省略:

* **HTTP URLs** are supported in some client applications. For an example, see the code snippet above.

    > 一些客户端应用程序支持HTTP URL。对于一个例子，请参阅上面的代码片段。

* **Folder URLs** can be useful, for example to provide folder-level metrics. They may use a file URL, for example `file:///opt/src:0:0:0:0`, but they may also start with a scheme of `folder://`, and no trailing numbers, for example `folder:///opt/src`.

    > 文件夹URL可以很有用，例如，提供文件夹级别的指标。它们可以使用一个文件URL，例如file:///opt/src:0:0:0，但它们也可以以文件夹://的方案开始，并且没有尾数，例如文件夹:///opt/src。

* **Relative file URLs** are like normal file URLs, but start with the scheme `relative://`. They are typically only meaningful in the context of a particular database, and are taken to be implicitly prefixed by the database’s source location. Note that, in particular, the relative URL of a file will stay constant regardless of where the database is analyzed. It is often most convenient to produce these URLs as input when importing external information; selecting one from a QL class would be unusual, and client applications may not handle it appropriately.

    > 相对文件URL和普通文件URL一样，但以相对://的方案开始。它们通常只在特定数据库的上下文中才有意义，并且被认为是隐含了数据库的源位置的前缀。特别要注意的是，无论数据库在哪里分析，文件的相对URL都将保持不变。在导入外部信息时，产生这些URL作为输入往往是最方便的；从QL类中选择一个是不寻常的，客户端应用程序可能不会适当地处理它。

### Providing location information

If no `getURL()` member predicate is defined, a QL class is checked for the presence of a member predicate called `hasLocationInfo(..)`. This can be understood as a convenient way of providing file URLs (see above) without constructing the long URL string in QL. `hasLocationInfo(..)` should be a predicate, its first column must be `string`-typed (it corresponds to the “path” portion of a file URL), and it must have an additional 3 or 4 `int`-typed columns, which are interpreted like a trailing group of three or four numbers on a file URL.

> 如果没有定义getURL()成员谓词，则检查QL类是否存在一个名为hasLocationInfo(.)的成员谓词。hasLocationInfo(..)应该是一个谓词，它的第一列必须是字符串类型的(它对应于文件URL的 "路径 "部分)，而且它必须有额外的3或4个int类型的列，它的解释就像文件URL上的3或4个数字的尾数组。

For example, let us imagine that the locations for methods provided by the extractor extend from the first character of the method name to the closing curly brace of the method body, and we want to “fix” them to ensure that only the method name is selected. The following code shows two ways of achieving this:

> 例如，让我们想象一下，提取器提供的方法的位置从方法名的第一个字符延伸到方法体的尾部大括号，我们想要 "固定 "它们，以确保只选择方法名。下面的代码展示了实现这一目标的两种方法:

```
class MyMethod extends Method {
    // The locations from the database, which we want to modify.
    Location getLocation() { result = super.getLocation() }

    /* First member predicate: Construct a URL for the desired location. */
    string getURL() {
        exists(Location loc | loc = this.getLocation() |
            result = "file://" + loc.getFile().getFullName() +
                ":" + loc.getStartLine() +
                ":" + loc.getStartColumn() +
                ":" + loc.getStartLine() +
                ":" + (loc.getStartColumn() + getName().length() - 1)
        )
    }

    /* Second member predicate: Define hasLocationInfo. This will be more
       efficient (it avoids constructing long strings), and will
       only be used if getURL() is not defined. */
    predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
        exists(Location loc | loc = this.getLocation() |
            path = loc.getFile().getFullName() and
            sl = loc.getStartLine() and
            sc = loc.getStartColumn() and
            el = sl and
            ec = sc + getName().length() - 1
        )
    }
}
```

### Using extracted location information

Finally, if the above two predicates fail, client applications will attempt to call a predicate called `getLocation()` with no parameters, and try to apply one of the above two predicates to the result. This allows certain locations to be put into the database, assigned identifiers, and picked up.

> 最后，如果上述两个谓词失败，客户端应用程序将尝试调用一个没有参数的名为getLocation()的谓词，并尝试将上述两个谓词中的一个应用到结果中。这样就可以将某些位置放入数据库，分配标识符，并拾取。

By convention, the return value of the `getLocation()` predicate should be a class called `Location`, and it should define a version of `hasLocationInfo(..)` (or `getURL()`, though the former is preferable). If the `Location` class does not provide either of these member predicates, then no location information will be available.

> 按照惯例，getLocation()谓词的返回值应该是一个名为Location的类，它应该定义一个hasLocationInfo(...)的版本（或者getURL()，不过前者更可取）。如果Location类没有提供这些成员谓词中的任何一个，那么就不会有位置信息。

## The `toString()` predicate

All classes except those that extend primitive types, must provide a `string toString()` member predicate. The query compiler will complain if you don’t. The uniqueness warning, noted above for locations, applies here too.

> 除了那些扩展基元类型的类，所有的类都必须提供一个字符串toString()成员谓词。如果你不提供，查询编译器会抱怨。上面提到的位置的唯一性警告在这里也适用。

## Further reading[¶](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/#further-reading)

* [CodeQL repository](https://github.com/github/codeql)