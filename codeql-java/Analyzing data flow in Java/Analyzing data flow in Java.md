# Analyzing data flow in Java[¶](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-java/#analyzing-data-flow-in-java)

You can use CodeQL to track the flow of data through a Java program to its use.

> 你可以使用CodeQL来跟踪数据流通过Java程序的使用情况。

## About this article

This article describes how data flow analysis is implemented in the CodeQL libraries for Java and includes examples to help you write your own data flow queries. The following sections describe how to use the libraries for local data flow, global data flow, and taint tracking.

> 本文介绍了如何在Java的CodeQL库中实现数据流分析，并包含了一些例子来帮助你编写自己的数据流查询。下面的章节描述了如何使用这些库进行本地数据流、全局数据流和污点跟踪。

For a more general introduction to modeling data flow, see “[About data flow analysis](https://codeql.github.com/docs/writing-codeql-queries/about-data-flow-analysis/#about-data-flow-analysis).”

> 有关数据流建模的更一般介绍，请参见 "关于数据流分析"。

## Local data flow

Local data flow is data flow within a single method or callable. Local data flow is usually easier, faster, and more precise than global data flow, and is sufficient for many queries.

> 本地数据流是指单个方法或可调用内的数据流。本地数据流通常比全局数据流更简单、更快速、更精确，对于很多查询来说已经足够了。

### Using local data flow

The local data flow library is in the module `DataFlow`, which defines the class `Node` denoting any element that data can flow through. `Node`s are divided into expression nodes (`ExprNode`) and parameter nodes (`ParameterNode`). You can map between data flow nodes and expressions/parameters using the member predicates `asExpr` and `asParameter`:

> 本地数据流库在模块DataFlow中，它定义了类Node，表示数据可以流经的任何元素。节点分为表达式节点（ExprNode）和参数节点（ParameterNode）。您可以使用成员谓词asExpr和asParameter在数据流节点和表达式/参数之间进行映射:

```
class Node {
  /** Gets the expression corresponding to this node, if any. */
  Expr asExpr() { ... }

  /** Gets the parameter corresponding to this node, if any. */
  Parameter asParameter() { ... }

  ...
}
```

or using the predicates `exprNode` and `parameterNode`:

> 或使用谓词 exprNode 和 parameterNode:

```
/**
 * Gets the node corresponding to expression `e`.
 */
ExprNode exprNode(Expr e) { ... }

/**
 * Gets the node corresponding to the value of parameter `p` at function entry.
 */
ParameterNode parameterNode(Parameter p) { ... }
```

The predicate `localFlowStep(Node nodeFrom, Node nodeTo)` holds if there is an immediate data flow edge from the node `nodeFrom` to the node `nodeTo`. You can apply the predicate recursively by using the `+` and `*` operators, or by using the predefined recursive predicate `localFlow`, which is equivalent to `localFlowStep*`.

> 如果存在从节点nodeFrom到节点nodeTo的即时数据流边，则谓词localFlowStep(Node nodeFrom, Node nodeTo)成立。您可以通过使用+和*运算符，或者通过使用定义的递归谓词localFlow（相当于localFlowStep*）来递归应用该谓词。

For example, you can find flow from a parameter `source` to an expression `sink` in zero or more local steps:

> 例如，可以在零个或多个本地步骤中找到从参数源到表达式接收器的污点传 播：DataFlow::localFlow(DataFlow::parameterNode(source), DataFlow::exprNode(sink))

### Using local taint tracking

Local taint tracking extends local data flow by including non-value-preserving flow steps. For example:

> 本地污点跟踪通过包括非保值流步骤来扩展本地数据流。例如: 

```
String temp = x;
String y = temp + ", " + temp;
```

If `x` is a tainted string then `y` is also tainted.

> 如果x是一个污点字符串，那么y也是污点。

The local taint tracking library is in the module `TaintTracking`. Like local data flow, a predicate `localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)` holds if there is an immediate taint propagation edge from the node `nodeFrom` to the node `nodeTo`. You can apply the predicate recursively by using the `+` and `*` operators, or by using the predefined recursive predicate `localTaint`, which is equivalent to `localTaintStep*`.

> 本地污点跟踪库在TaintTracking模块中。和本地数据流一样，如果有一条从节点nodeFrom到节点nodeTo的即时污点传播边，则谓词localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)成立。您可以通过使用+和*运算符，或者通过使用定义的递归谓词localTaint（相当于localTaintStep*）来递归应用该谓词。

For example, you can find taint propagation from a parameter `source` to an expression `sink` in zero or more local steps:

> 例如，可以在零个或多个本地步骤中找到从参数源到表达式接收器的污点传播：

```
TaintTracking::localTaint(DataFlow::parameterNode(source), DataFlow::exprNode(sink))
```

### Examples

This query finds the filename passed to `new FileReader(..)`.

> 这个查询可以找到传递给new FileReader(.)的文件名。

```
import java

from Constructor fileReader, Call call
where
  fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
  call.getCallee() = fileReader
select call.getArgument(0)
```

![image-20210321154347521](C:%5CUsers%5CSamny%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5Cimage-20210321154347521.png)



![image-20210321154357125](C:%5CUsers%5CSamny%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5Cimage-20210321154357125.png)



Unfortunately, this only gives the expression in the argument, not the values which could be passed to it. So we use local data flow to find all expressions that flow into the argument:

> 不幸的是，这只给出了参数中的表达式，而没有给出可以传递给它的值。所以我们使用本地数据流来查找所有流入参数中的表达式:

```
import java
import semmle.code.java.dataflow.DataFlow

from Constructor fileReader, Call call, Expr src
where
  fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
  call.getCallee() = fileReader and
  DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(call.getArgument(0)))
select src
```

![image-20210321154642299](https://gitee.com/samny/images/raw/master/42u46er42ec/42u46er42ec.png)

![image-20210321154605656](https://gitee.com/samny/images/raw/master/5u46er5ec/5u46er5ec.png)



Then we can make the source more specific, for example an access to a public parameter. This query finds where a public parameter is passed to `new FileReader(..)`:

> 然后，我们可以把源头做得更具体，例如对一个公共参数的访问。这个查询可以找到公共参数被传递给new FileReader(...)的位置:

```
import java
import semmle.code.java.dataflow.DataFlow

from Constructor fileReader, Call call, Parameter p
where
  fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
  call.getCallee() = fileReader and
  DataFlow::localFlow(DataFlow::parameterNode(p), DataFlow::exprNode(call.getArgument(0)))
select p
```

![image-20210321154757521](https://gitee.com/samny/images/raw/master/57u47er57ec/57u47er57ec.png)



![image-20210321154726769](https://gitee.com/samny/images/raw/master/26u47er26ec/26u47er26ec.png)

This query finds calls to formatting functions where the format string is not hard-coded.

> 这个查询可以找到对格式字符串没有硬编码的格式化函数的调用。

```
import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.StringFormat

from StringFormatMethod format, MethodAccess call, Expr formatString
where
  call.getMethod() = format and
  call.getArgument(format.getFormatStringIndex()) = formatString and
  not exists(DataFlow::Node source, DataFlow::Node sink |
    DataFlow::localFlow(source, sink) and
    source.asExpr() instanceof StringLiteral and
    sink.asExpr() = formatString
  )
select call, "Argument to String format method isn't hard-coded."
```

![image-20210321151731106](https://gitee.com/samny/images/raw/master/31u17er31ec/31u17er31ec.png)

![image-20210321151844554](C:%5CUsers%5CSamny%5CAppData%5CRoaming%5CTypora%5Ctypora-user-images%5Cimage-20210321151844554.png)

![image-20210321151901989](https://gitee.com/samny/images/raw/master/2u19er2ec/2u19er2ec.png)



### Exercises

Exercise 1: Write a query that finds all hard-coded strings used to create a `java.net.URL`, using local data flow. ([Answer](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-java/#exercise-1))

> 练习1：写一个查询，使用本地数据流找到所有用于创建java.net.URL的硬编码字符串。(答案)

## Global data flow

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow. However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

> 全局数据流跟踪整个程序的数据流，因此比局部数据流更强大。但是，全局数据流的精度低于本地数据流，而且分析通常需要更多的时间和内存来执行。

> Note
>
> You can model data flow paths in CodeQL by creating path queries. To view data flow paths generated by a path query in CodeQL for VS Code, you need to make sure that it has the correct metadata and `select` clause. For more information, see [Creating path queries](https://codeql.github.com/docs/writing-codeql-queries/creating-path-queries/#creating-path-queries).
>
> 你可以在CodeQL中通过创建路径查询来模拟数据流路径。要在CodeQL for VS Code中查看路径查询生成的数据流路径，你需要确保它有正确的元数据和选择子句。更多信息，请参阅创建路径查询。

### Using global data flow

You use the global data flow library by extending the class `DataFlow::Configuration`:

> 你可以通过扩展类DataFlow::Configuration来使用全局数据流库:

```
import semmle.code.java.dataflow.DataFlow

class MyDataFlowConfiguration extends DataFlow::Configuration {
  MyDataFlowConfiguration() { this = "MyDataFlowConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    ...
  }

  override predicate isSink(DataFlow::Node sink) {
    ...
  }
}
```

These predicates are defined in the configuration:

> 这些谓词在配置中被定义:

* `isSource`—defines where data may flow from  isSource-定义了数据可能从哪里流出。
* `isSink`—defines where data may flow to isSink-定义数据可能流向的地方
* `isBarrier`—optional, restricts the data flow  isBarrier-optional，限制数据流。
* `isAdditionalFlowStep`—optional, adds additional flow steps  isAdditionalFlowStep-选项，增加额外的流程步骤

The characteristic predicate `MyDataFlowConfiguration()` defines the name of the configuration, so `"MyDataFlowConfiguration"` should be a unique name, for example, the name of your class.

> 特性谓词MyDataFlowConfiguration()定义了配置的名称，所以 "MyDataFlowConfiguration "应该是一个唯一的名称，例如，你的类的名称。

The data flow analysis is performed using the predicate `hasFlow(DataFlow::Node source, DataFlow::Node sink)`:

> 使用谓词hasFlow(DataFlow::Node source, DataFlow::Node sink)进行数据流分析:

```
from MyDataFlowConfiguration dataflow, DataFlow::Node source, DataFlow::Node sink
where dataflow.hasFlow(source, sink)
select source, "Data flow to $@.", sink, sink.toString()
```

### Using global taint tracking

Global taint tracking is to global data flow as local taint tracking is to local data flow. That is, global taint tracking extends global data flow with additional non-value-preserving steps. You use the global taint tracking library by extending the class `TaintTracking::Configuration`:

> 全局污点跟踪对于全局数据流来说，就像本地污点跟踪对于本地数据流一样。也就是说，全局污点跟踪通过额外的非保值步骤扩展了全局数据流。您通过扩展类TaintTracking::Configuration来使用全局污点跟踪库:

```
import semmle.code.java.dataflow.TaintTracking

class MyTaintTrackingConfiguration extends TaintTracking::Configuration {
  MyTaintTrackingConfiguration() { this = "MyTaintTrackingConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    ...
  }

  override predicate isSink(DataFlow::Node sink) {
    ...
  }
}
```

These predicates are defined in the configuration:

> 这些谓词在配置中定义:

* `isSource`—defines where taint may flow from  isSource-定义了污点可能来自哪里。
* `isSink`—defines where taint may flow to  isSink-定义污点可能流向的地方。
* `isSanitizer`—optional, restricts the taint flow  isSanitizer-optional，限制污点的流动
* `isAdditionalTaintStep`—optional, adds additional taint steps   isAdditionalTaintStep-选项，增加额外的污点步骤。

Similar to global data flow, the characteristic predicate `MyTaintTrackingConfiguration()` defines the unique name of the configuration.

> 与全局数据流类似，特征谓词MyTaintTrackingConfiguration()定义了配置的唯一名称。

The taint tracking analysis is performed using the predicate `hasFlow(DataFlow::Node source, DataFlow::Node sink)`.

> 使用谓词hasFlow(DataFlow::Node source, DataFlow::Node sink)进行污点跟踪分析。

### Flow sources

The data flow library contains some predefined flow sources. The class `RemoteFlowSource` (defined in `semmle.code.java.dataflow.FlowSources`) represents data flow sources that may be controlled by a remote user, which is useful for finding security problems.

> 数据流库包含一些预定义的流源。类RemoteFlowSource（定义在semmle.code.java.dataflow.FlowSources中）代表了可能被远程用户控制的数据流源，这对于发现安全问题很有用。

### Examples

This query shows a taint-tracking configuration that uses remote user input as data sources.

> 这个查询显示了一个使用远程用户输入作为数据源的污点跟踪配置。

```
import java
import semmle.code.java.dataflow.FlowSources

class MyTaintTrackingConfiguration extends TaintTracking::Configuration {
  MyTaintTrackingConfiguration() {
    this = "..."
  }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
  }

  ...
}
```

### Exercises

Exercise 2: Write a query that finds all hard-coded strings used to create a `java.net.URL`, using global data flow. ([Answer](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-java/#exercise-2))

> 练习2：写一个查询，使用全局数据流找到所有用于创建java.net.URL的硬编码字符串。(答案)

Exercise 3: Write a class that represents flow sources from `java.lang.System.getenv(..)`. ([Answer](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-java/#exercise-3))

> 练习3：从java.lang.System.getenv(...)写一个表示流源的类。(答案)

Exercise 4: Using the answers from 2 and 3, write a query which finds all global data flows from `getenv` to `java.net.URL`. ([Answer](https://codeql.github.com/docs/codeql-language-guides/analyzing-data-flow-in-java/#exercise-4))

>  练习4：使用2和3中的答案，写一个查询，找到所有从getenv到java.net.URL的全局数据流。(答案)

## Answers

### Exercise 1

```
import semmle.code.java.dataflow.DataFlow

from Constructor url, Call call, StringLiteral src
where
  url.getDeclaringType().hasQualifiedName("java.net", "URL") and
  call.getCallee() = url and
  DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(call.getArgument(0)))
select src
```

![image-20210321161316130](https://gitee.com/samny/images/raw/master/16u13er16ec/16u13er16ec.png)

### Exercise 2

```
import semmle.code.java.dataflow.DataFlow

class Configuration extends DataFlow::Configuration {
  Configuration() {
    this = "LiteralToURL Configuration"
  }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof StringLiteral
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Call call |
      sink.asExpr() = call.getArgument(0) and
      call.getCallee().(Constructor).getDeclaringType().hasQualifiedName("java.net", "URL")
    )
  }
}

from DataFlow::Node src, DataFlow::Node sink, Configuration config
where config.hasFlow(src, sink)
select src, "This string constructs a URL $@.", sink, "here"
```



### Exercise 3

```
import java

class GetenvSource extends MethodAccess {
  GetenvSource() {
    exists(Method m | m = this.getMethod() |
      m.hasName("getenv") and
      m.getDeclaringType() instanceof TypeSystem
    )
  }
}
```

### Exercise 4

```
import semmle.code.java.dataflow.DataFlow

class GetenvSource extends DataFlow::ExprNode {
  GetenvSource() {
    exists(Method m | m = this.asExpr().(MethodAccess).getMethod() |
      m.hasName("getenv") and
      m.getDeclaringType() instanceof TypeSystem
    )
  }
}

class GetenvToURLConfiguration extends DataFlow::Configuration {
  GetenvToURLConfiguration() {
    this = "GetenvToURLConfiguration"
  }

  override predicate isSource(DataFlow::Node source) {
    source instanceof GetenvSource
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Call call |
      sink.asExpr() = call.getArgument(0) and
      call.getCallee().(Constructor).getDeclaringType().hasQualifiedName("java.net", "URL")
    )
  }
}

from DataFlow::Node src, DataFlow::Node sink, GetenvToURLConfiguration config
where config.hasFlow(src, sink)
select src, "This environment variable constructs a URL $@.", sink, "here"
```

