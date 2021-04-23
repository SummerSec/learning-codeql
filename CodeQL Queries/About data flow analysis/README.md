<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:5e69ee8ba81cf1594e6b78d0d472a73a9167474c4a12db8566f985c9dca2a821
size 11986
=======
# About data flow analysis[¶](https://codeql.github.com/docs/writing-codeql-queries/about-data-flow-analysis/#about-data-flow-analysis)

Data flow analysis is used to compute the possible values that a variable can hold at various points in a program, determining how those values propagate through the program and where they are used.

> 数据流分析用于计算一个变量在程序中不同点可能持有的值，确定这些值是如何在程序中传播的，以及它们在哪里被使用。

## Overview

Many CodeQL security queries implement data flow analysis, which can highlight the fate of potentially malicious or insecure data that can cause vulnerabilities in your code base. These queries help you understand if data is used in an insecure way, whether dangerous arguments are passed to functions, or whether sensitive data can leak. As well as highlighting potential security issues, you can also use data flow analysis to understand other aspects of how a program behaves, by finding, for example, uses of uninitialized variables and resource leaks.

> 许多CodeQL安全查询实现了数据流分析，它可以突出潜在的恶意或不安全数据的命运，从而导致您的代码库中的漏洞。这些查询可以帮助您了解数据是否以不安全的方式使用，是否有危险的参数传递给函数，或者敏感数据是否会泄露。除了突出潜在的安全问题外，您还可以使用数据流分析来了解程序行为的其他方面，例如，通过查找未初始化变量的使用和资源泄漏。

The following sections provide a brief introduction to data flow analysis with CodeQL.

> 下面的章节提供了一个关于CodeQL数据流分析的简要介绍。

See the following tutorials for more information about analyzing data flow in specific languages:

> 请参阅下面的教程，了解更多关于在特定语言中分析数据流的信息:

* “[Analyzing data flow in C/C++](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-cpp/#analyzing-data-flow-in-cpp)”
* “[Analyzing data flow in C#](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-csharp/#analyzing-data-flow-in-csharp)”
* “[Analyzing data flow in Java](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-java/#analyzing-data-flow-in-java)”
* “[Analyzing data flow in JavaScript/TypeScript](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-javascript-and-typescript/#analyzing-data-flow-in-javascript-and-typescript)”
* “[Analyzing data flow in Python](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-python/#analyzing-data-flow-in-python)”

> Note
>
> Data flow analysis is used extensively in path queries. To learn more about path queries, see “[Creating path queries](https://codeql.github.com/docs/writing-codeql-queries/creating-path-queries/).”
>
> 在路径查询中广泛使用了数据流分析。要了解有关路径查询的更多信息，请参阅 "创建路径查询"。



## Data flow graph

The CodeQL data flow libraries implement data flow analysis on a program or function by modeling its data flow graph. Unlike the [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree), the data flow graph does not reflect the syntactic structure of the program, but models the way data flows through the program at runtime. Nodes in the abstract syntax tree represent syntactic elements such as statements or expressions. Nodes in the data flow graph, on the other hand, represent semantic elements that carry values at runtime.

> CodeQL数据流库通过对程序或函数的数据流图建模来实现对程序的数据流分析。与抽象语法树不同的是，数据流图并不反映程序的语法结构，而是在运行时模拟数据流经程序的方式。抽象语法树中的节点代表语句或表达式等语法元素。而数据流图中的节点则代表运行时携带值的语义元素。

Some AST nodes (such as expressions) have corresponding data flow nodes, but others (such as `if` statements) do not. This is because expressions are evaluated to a value at runtime, whereas `if` statements are purely a control-flow construct and do not carry values. There are also data flow nodes that do not correspond to AST nodes at all.

> 一些AST节点（如表达式）有相应的数据流节点，但其他节点（如if语句）则没有。这是因为表达式在运行时被评估为一个值，而if语句则是纯粹的控制流构造，不携带值。还有一些数据流节点根本不对应AST节点。

Edges in the data flow graph represent the way data flows between program elements. For example, in the expression `x || y` there are data flow nodes corresponding to the sub-expressions `x` and `y`, as well as a data flow node corresponding to the entire expression `x || y`. There is an edge from the node corresponding to `x` to the node corresponding to `x || y`, representing the fact that data may flow from `x` to `x || y` (since the expression `x || y` may evaluate to `x`). Similarly, there is an edge from the node corresponding to `y` to the node corresponding to `x || y`.

> 数据流图中的边表示数据在程序元素之间的流动方式。例如，在表达式x || y中，有对应于子表达式x和y的数据流节点，也有对应于整个表达式x || y的数据流节点，从对应于x的节点到对应于x || y的节点有一条边，代表数据可以从x流向x || y（因为表达式x || y可以求值为x）。同理，从y对应的节点到x || y对应的节点也有一条边。

Local and global data flow differ in which edges they consider: local data flow only considers edges between data flow nodes belonging to the same function and ignores data flow between functions and through object properties. Global data flow, however, considers the latter as well. Taint tracking introduces additional edges into the data flow graph that do not precisely correspond to the flow of values, but model whether some value at runtime may be derived from another, for instance through a string manipulating operation.

> 局部数据流和全局数据流在考虑哪些边方面有所不同：局部数据流只考虑属于同一函数的数据流节点之间的边，而忽略函数之间和通过对象属性的数据流。然而，全局数据流也考虑了后者。污点跟踪在数据流图中引入了额外的边，这些边并不精确地对应于值的流动，而是模拟运行时的某个值是否可能从另一个值衍生出来，例如通过字符串操作。

The data flow graph is computed using [classes](https://codeql.github.com/docs/ql-language-reference/types/#classes) to model the program elements that represent the graph’s nodes. The flow of data between the nodes is modeled using [predicates](https://codeql.github.com/docs/ql-language-reference/predicates/#predicates) to compute the graph’s edges.

> 数据流图是用类来模拟代表图中节点的程序元素来计算的。节点之间的数据流使用谓词来计算图的边缘来建模。

Computing an accurate and complete data flow graph presents several challenges:

> 计算一个准确和完整的数据流图有几个挑战。

* It isn’t possible to compute data flow through standard library functions, where the source code is unavailable.

    > 它不可能通过标准的库函数来计算数据流，因为那里的源代码是不可用的。

* Some behavior isn’t determined until run time, which means that the data flow library must take extra steps to find potential call targets.

    > 有些行为直到运行时才被确定，这意味着数据流库必须采取额外的步骤来寻找潜在的调用目标。

* Aliasing between variables can result in a single write changing the value that multiple pointers point to.

    > 变量之间的别名会导致一次写入改变多个指针指向的值。

* The data flow graph can be very large and slow to compute.

    > 数据流图可能非常大，计算速度也很慢。

To overcome these potential problems, two kinds of data flow are modeled in the libraries:

> 为了克服这些潜在的问题，库中对两种数据流进行了建模:

* Local data flow, concerning the data flow within a single function. When reasoning about local data flow, you only consider edges between data flow nodes belonging to the same function. It is generally sufficiently fast, efficient and precise for many queries, and it is usually possible to compute the local data flow for all functions in a CodeQL database.

    > 局部数据流，关于单个函数内的数据流。在推理局部数据流时，只考虑属于同一函数的数据流节点之间的边。一般来说，它的速度足够快，效率高，精度高，对于很多查询来说，通常可以计算出CodeQL数据库中所有函数的局部数据流。

* Global data flow, effectively considers the data flow within an entire program, by calculating data flow between functions and through object properties. Computing global data flow is typically more time and energy intensive than local data flow, therefore queries should be refined to look for more specific sources and sinks.

    > 全局数据流，通过计算函数之间和通过对象属性的数据流，有效地考虑整个程序内部的数据流。计算全局数据流通常比本地数据流更耗费时间和精力，因此应该细化查询，寻找更具体的数据源和数据汇。

Many CodeQL queries contain examples of both local and global data flow analysis. For more information, see [CodeQL query help](https://codeql.github.com/codeql-query-help).

## Normal data flow vs taint tracking

In the standard libraries, we make a distinction between ‘normal’ data flow and taint tracking. The normal data flow libraries are used to analyze the information flow in which data values are preserved at each step.

> 在标准库中，我们对 "正常 "数据流和污点跟踪进行了区分。正常的数据流库是用来分析信息流的，其中的数据值在每一步都会被保存下来。

For example, if you are tracking an insecure object `x` (which might be some untrusted or potentially malicious data), a step in the program may ‘change’ its value. So, in a simple process such as `y = x + 1`, a normal data flow analysis will highlight the use of `x`, but not `y`. However, since `y` is derived from `x`, it is influenced by the untrusted or ‘tainted’ information, and therefore it is also tainted. Analyzing the flow of the taint from `x` to `y` is known as taint tracking.

> 例如，如果你正在跟踪一个不安全的对象x（可能是一些不受信任或潜在的恶意数据），程序中的一个步骤可能会 "改变 "它的值。所以，在一个简单的过程中，比如y=x+1，正常的数据流分析会突出x的使用，但不会突出y，但是由于y是由x派生出来的，所以会受到不受信任或 "污点 "信息的影响，因此它也是污点。分析污点从x到y的流向被称为污点跟踪。

In QL, taint tracking extends data flow analysis by including steps in which the data values are not necessarily preserved, but the potentially insecure object is still propagated. These flow steps are modeled in the taint-tracking library using predicates that hold if taint is propagated between nodes.

> 在QL中，污点跟踪扩展了数据流分析，包括了数据值不一定会被保存，但潜在的不安全对象仍然会被传播的步骤。这些流动步骤在污点跟踪库中使用谓词进行建模，如果污点在节点之间传播，则这些步骤成立。

## Further reading

* “[Exploring data flow with path queries](https://codeql.github.com/docs/codeql-for-visual-studio-code/exploring-data-flow-with-path-queries/#exploring-data-flow-with-path-queries)”

>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
