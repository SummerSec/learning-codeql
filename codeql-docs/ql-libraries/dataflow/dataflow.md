<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:e433a5ae1fe3fececf28b38aabea16c836b11337308e48828a56044a519b0074
size 34144
=======
# Using the shared data-flow library

This document is aimed towards language maintainers and contains implementation
details that should be mostly irrelevant to query writers.

> 本文档是针对语言维护者的，其中包含了实现细节，应该是大部分与查询作者无关的。

## Overview

The shared data-flow library implements sophisticated global data flow on top of a language-specific data-flow graph. The language-specific bits supply the graph through a number of predicates and classes, and the shared implementation takes care of matching call-sites with returns and field writes with reads to ensure that the generated paths are well-formed. The library also supports a number of additional features for improving precision, for example pruning infeasible paths based on type information.

> 共享数据流库在上面实现了复杂的全局数据流的语言特定的数据流图。语言特定的位提供的是 通过一些谓词和类，以及共享的实现，来实现图的功能。负责将调用点与返回值以及字段写入与读取值匹配到 确保生成的路径形状良好。该库还支持一个 一些额外的功能，以提高精度，例如，修剪 基于类型信息的不可行路径。

## File organisation

The data-flow library consists of a number of files typically located in
`<lang>/dataflow` and `<lang>/dataflow/internal`:

> 数据流库由一些文件组成，这些文件一般位于
> `<lang>/dataflow`和`<lang>/dataflow/internal`。

```
dataflow/DataFlow.qll
dataflow/internal/DataFlowImpl.qll
dataflow/internal/DataFlowCommon.qll
dataflow/internal/DataFlowImplSpecific.qll
```

`DataFlow.qll` provides the user interface for the library and consists of just a few lines of code importing the implementation:

> `DataFlow.qll`为该库提供了用户界面，仅由以下部分组成
> 几行代码导入实现。

#### `DataFlow.qll`
```ql
import <lang>

module DataFlow {
  import semmle.code.java.dataflow.internal.DataFlowImpl
}
```

The `DataFlowImpl.qll` and `DataFlowCommon.qll` files contain the library code
that is shared across languages. These contain `Configuration`-specific and
`Configuration`-independent code, respectively. This organization allows
multiple copies of the library to exist without duplicating the `Configuration`-independent predicates (for the use case when a query wants to use two instances of global data flow and the configuration of one depends on the results from the other). Using multiple copies just means duplicating `DataFlow.qll` and `DataFlowImpl.qll`, for example as:

> `DataFlowImpl.qll`和`DataFlowCommon.qll`文件包含库代码不同语言之间共享。这些内容包括 "配置 "专用的和 "配置 "专用的。
> 分别是 "配置 "无关的代码。这种组织方式使库的多个副本，而不重复存在。"配置 "无关的谓词(在使用情况下，当一个查询想要：
> 使用两个全局数据流的实例，其中一个的配置取决于的结果）。) 使用多个副本只是意味着复制`DataFlow.qll` `DataFlowImpl.qll`，例如：

```
dataflow/DataFlow2.qll
dataflow/DataFlow3.qll
dataflow/internal/DataFlowImpl2.qll
dataflow/internal/DataFlowImpl3.qll
```

The file `DataFlowImplSpecific.qll` provides all the language-specific classes
and predicates that the library needs as input and is the topic of the rest of
this document.

> 文件 "DataFlowImplSpecific.qll "提供了所有特定语言的类。
> 和谓词库所需要的输入，也是本文其余部分的主题文件。

This file must provide two modules named `Public` and `Private`, which the shared library code will import publicly and privately, respectively, thus allowing the language-specific part to choose which classes and predicates should be exposed by `DataFlow.qll`.

> 该文件必须提供两个名为 "Public "和 "Private "的模块，共享库代码将分别公开和私下导入，因此允许语言特定部分选择哪些类和谓词应该由`DataFlow.qll`暴露。

A typical implementation looks as follows, thereby organizing the predicates in
two files, which we'll subsequently assume:

> 一个典型的实现看起来如下，从而将谓词组织在了两个文件，我们后续会假设:

#### `DataFlowImplSpecific.qll`
```ql
module Private {
  import DataFlowPrivate
}

module Public {
  import DataFlowPublic
}
```

## Defining the data-flow graph

The main input to the library is the data-flow graph. One must define a class
`Node` and an edge relation `simpleLocalFlowStep(Node node1, Node node2)`. The
`Node` class should be in `DataFlowPublic`.

> 该库的主要输入是数据流图。我们必须定义一个类
> `节点`和边缘关系`simpleLocalFlowStep(Node node1, Node node2)`。`Node'的
> `Node`类应该在`DataFlowPublic`中。

Recommendations:
* Make `Node` an IPA type. There is commonly a need for defining various data-flow nodes that are not necessarily represented in the AST of the language.
  
  > 将 "节点 "定为IPA类型。通常需要定义各种类型的 "节点"。数据流节点，不一定在语言的AST中表示。
  
* Define `predicate localFlowStep(Node node1, Node node2)` as an alias of `simpleLocalFlowStep` and expose it publicly. The reason for this indirection is that it gives the option of exposing local flow augmented with field flow.
  See the C/C++ implementation, which makes use of this feature. Another use of this indirection is to hide synthesized local steps that are only relevant for global flow. See the C# implementation for an example of this.
  
  > 定义 "predicate localFlowStep(Node node1, Node node2) "作为一个别名。`simpleLocalFlowStep`并将其公开。这种间接性的原因是 是，它提供了一个选项，可以暴露本地流，并增加了场流。
  > 请看C/C++的实现，它利用了这个特性。的另一个用途是 这种间接性是为了隐藏合成的局部步骤，这些步骤只与 的全局流。请看C#实现的例子。
  
* Define `predicate localFlow(Node node1, Node node2) { localFlowStep*(node1, node2) }`.

    > 定义`predicate localFlow(Node node1, Node node2) { localFlowStep*(node1, node2) }`。

* Make the local flow step relation in `simpleLocalFlowStep` follow def-to-first-use and use-to-next-use steps for SSA variables. Def-use steps also work, but the upside of `use-use` steps is that sources defined in terms of variable reads just work out of the box. It also makes certain barrier-implementations simpler.
  
  > 使`simpleLocalFlowStep`中的本地流步骤关系遵循以下步骤 SSA 变量的 def-to-first-use 和 use-to-next-use 步骤。定义-使用步骤 也可以，但 "使用 "步骤的好处是，源的定义是以 的变量读数就能正常工作。它也使得某些 障碍物的实现更简单。
  
* A predicate `DataFlowCallable Node::getEnclosingCallable()` is required, and in order to ensure appropriate join-orders, it is important that the QL compiler knows that this predicate is functional. It can therefore be necessary to enclose the body of this predicate in a `unique` aggregate.

  > 需要一个谓词 "DataFlowCallable Node::getEnclosingCallable()"，并在 "DataFlowCallable Node::getEnclosingCallable() "中使用。为了保证适当的连接顺序，重要的是QL编译器要知道 该谓词是功能性的。因此，可以有必要将主体包围起来 这个谓词的 "唯一 "集合。

The shared library does not use `localFlowStep` nor `localFlow` but users of `DataFlow.qll` may expect the existence of `DataFlow::localFlowStep` and `DataFlow::localFlow`.

> 共享库不使用`localFlowStep`或`localFlow`，但用户可以使用`localFlow`。`DataFlow.qll`可能期望存在`DataFlow::localFlowStep`和 `DataFlow::localFlow`。

### `Node` subclasses

The `Node` class needs a number of subclasses. As a minimum the following are needed:

> `节点'类需要若干子类。至少需要下列子类。

```
ExprNode
ParameterNode
PostUpdateNode

OutNode
ArgumentNode
ReturnNode
CastNode
```
and possibly more depending on the language and its AST. Of the above, the first 3 should be public, but the last 4 can be private. Also, the last 4 will likely be subtypes of `ExprNode`. For further details about `ParameterNode`, `ArgumentNode`, `ReturnNode`, and `OutNode` see [The call-graph](#the-call-graph) below. For further details about `CastNode` see [Type pruning](#type-pruning) below. For further details about `PostUpdateNode` see [Field flow](#field-flow) below.

> 以及可能更多，这取决于语言和它的AST。在上面的例子中，前3个应该是公共的，但最后4个可以是私有的。另外，最后4个很可能是`ExprNode`的子类型。关于`ParameterNode`、`ArgumentNode`、`ReturnNode`和`OutNode`的更多细节请看下面的【The call-graph】(#the-call-graph)。关于`CastNode`的详细内容请参见下面的【类型修剪】(#type-pruning)。关于`PostUpdateNode`的更多细节见下面的【字段流】(#field-flow)。

Nodes corresponding to expressions and parameters are the most common for users to interact with so a couple of convenience predicates are generally included:

> 表达式和参数对应的节点是用户最常用的交互方式，所以一般会包含几个方便的谓词:

```
DataFlowExpr Node::asExpr()
Parameter Node::asParameter()
ExprNode exprNode(DataFlowExpr n)
ParameterNode parameterNode(Parameter n)
```
Here `DataFlowExpr` should be an alias for the language-specific class of expressions (typically called `Expr`). Parameters do not need an alias for the shared implementation to refer to, so here you can just use the language-specific class name (typically called `Parameter`).

> 这里`DataFlowExpr`应该是表达式的语言特定类的别名（通常称为`Expr`）。参数不需要共享实现的别名来引用，所以这里可以只使用语言特定的类名（通常称为`Parameter`）。

### The call-graph

In order to make inter-procedural flow work a number of classes and predicates must be provided. First, two types, `DataFlowCall` and `DataFlowCallable`, must be defined. These should be aliases for whatever language-specific class represents calls and callables (a "callable" is intended as a broad term covering functions, methods, constructors, lambdas, etc.). It can also be useful to represent `DataFlowCall` as an IPA type if implicit calls need to be modelled. The call-graph should be defined as a predicate:

> 为了使程序间流工作，必须提供一些类和谓词。首先，必须定义两个类型，`DataFlowCall`和`DataFlowCallable`。这两个类型应该是代表调用和可调用的语言类的别名（"可调用 "是一个广义的术语，包括函数、方法、构造函数、lambdas等）。如果需要对隐式调用进行建模，那么将 "DataFlowCall "表示为IPA类型也是有用的。调用图应该被定义为一个谓词。

```ql
DataFlowCallable viableCallable(DataFlowCall c)
```

In order to connect data-flow across calls, the 4 `Node` subclasses `ArgumentNode`, `ParameterNode`, `ReturnNode`, and `OutNode` are used. Flow into callables from arguments to parameters are matched up using an integer position, so these two classes must define:

> 为了连接跨调用的数据流，使用了4个`Node`子类`ArgumentNode`、`ParameterNode`、`ReturnNode`和`OutNode`。从参数到参数的流进可调用项是用整数位置匹配起来的，所以这两个类必须定义。

```ql
ArgumentNode::argumentOf(DataFlowCall call, int pos)
ParameterNode::isParameterOf(DataFlowCallable c, int pos)
```
It is typical to use `pos = -1` for an implicit `this`-parameter.

> 典型的做法是使用 "pos = -1 "作为隐式的 "this "参数。

For most languages return-flow is simpler and merely consists of matching up a `ReturnNode` with the data-flow node corresponding to the value of the call, represented as `OutNode`.  For this use-case we would define a singleton type `ReturnKind`, a trivial `ReturnNode::getKind()`, and `getAnOutNode` to relate calls and `OutNode`s:

> 对于大多数语言来说，返回流是比较简单的，仅仅包括将一个`ReturnNode`与对应于调用值的数据流节点进行匹配，用`OutNode`表示。 对于这种用例，我们将定义一个单子类型`ReturnKind`，一个琐碎的`ReturnNode::getKind()`，以及`getAnOutNode`来关联调用和`OutNode`。

```ql
private newtype TReturnKind = TNormalReturnKind()

ReturnKind ReturnNode::getKind() { any() }

OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  result = call.getNode() and
  kind = TNormalReturnKind()
}
```

For more complex use-cases when a language allows a callable to return multiple values, for example through `out` parameters in C#, the `ReturnKind` class can be defined and used to match up different kinds of `ReturnNode`s with the corresponding `OutNode`s.

> 对于更复杂的使用情况，当一种语言允许一个可调用对象返回多个值时，例如通过C#中的 "out "参数，可以定义 "ReturnKind "类，并用于匹配不同类型的 "ReturnNode "和相应的 "OutNode"。

## Flow through global variables

Flow through global variables are called jump-steps, since such flow steps essentially jump from one callable to another completely discarding call contexts. Adding support for this type of flow is done with the following predicate:

> 通过全局变量的流被称为跳步，因为这种流步基本上是从一个可调用的变量跳到另一个完全抛弃调用上下文的变量。通过下面的谓词来添加对这种类型的流的支持。

```ql
predicate jumpStep(Node node1, Node node2)
```

If global variables are common and certain databases have many reads and writes of the same global variable, then a direct step may have performance problems, since the straight-forward implementation is just a cartesian product of reads and writes for each global variable. In this case it can be beneficial to remove the cartesian product by introducing an intermediate `Node` for the
value of each global variable.

> 如果全局变量是通用的，而且某些数据库对同一个全局变量有很多读和写，那么直接步骤可能会有性能问题，因为直接实现只是对每个全局变量的读和写的卡方乘积。在这种情况下，通过引入一个中间`节点`来去除卡方乘积，对每个全局变量的值。

Note that, jump steps of course also can be used to implement other cross-callable flow. As an example Java also uses this mechanism for variable capture flow. But beware that this will lose the call context, so normal inter-procedural flow should use argument-parameter-, and return-outnode-flow as described above.

> 需要注意的是，跳步当然也可以用来实现其他可交叉调用的流程。举个例子，Java也使用这种机制来实现变量捕获流。但是要注意，这样会失去调用上下文，所以正常的跨过程流应该使用参数-参数-，和返回-输出节点-流，如上所述。	

## Field flow

The library supports tracking flow through field stores and reads. In order to support this, a class `Content` and two predicates `storeStep(Node node1, Content f, Node node2)` and `readStep(Node node1, Content f, Node node2)` must be defined. It generally makes sense for stores to target `PostUpdateNode`s, but this is not a strict requirement. Besides this, certain nodes must have associated `PostUpdateNode`s. The node associated with a `PostUpdateNode` should be defined by `PostUpdateNode::getPreUpdateNode()`. `PostUpdateNode`s are generally used when we need two data-flow nodes for a single AST element in order to distinguish the value before and after some side-effect (typically a field store, but it may also be addition of taint through an additional step targeting a `PostUpdateNode`).

> 该库支持通过字段存储和读取跟踪流程。为了支持这一点，必须定义一个类`Content`和两个谓词`storeStep(Node node1, Content f, Node node2)`和`readStep(Node node1, Content f, Node node2)`。一般来说，商店以`PostUpdateNode`为目标是有意义的，但这不是一个严格的要求。除此之外，某些节点必须有关联的`PostUpdateNode`s。与`PostUpdateNode`相关联的节点应该由`PostUpdateNode::getPreUpdateNode()`定义。`PostUpdateNode`s通常用于当我们需要为一个AST元素提供两个数据流节点，以便区分某些副作用（通常是字段存储，但也可能是通过针对`PostUpdateNode`的附加步骤添加污点）之前和之后的值。

It is recommended to introduce `PostUpdateNode`s for all `ArgumentNode`s (this can be skipped for immutable arguments), and all field qualifiers for both reads and stores. 

> 建议为所有的 "ArgumentNode "引入`PostUpdateNode`s（对于不可变的参数可以跳过），以及所有读和存储的字段限定符。

Remember to define local flow for `PostUpdateNode`s as well in `simpleLocalFlowStep`.  In general out-going local flow from `PostUpdateNode`s should be use-use flow, and there is generally no need for in-going local flow edges for `PostUpdateNode`s.

> 记得在`simpleLocalFlowStep`中也要为`PostUpdateNode`s定义本地流。 一般情况下，从`PostUpdateNode`s流出的本地流应该是使用流，一般情况下不需要为`PostUpdateNode`s定义流入的本地流边。

We will illustrate how the shared library makes use of `PostUpdateNode`s through a couple of examples.

> 我们将通过几个例子来说明共享库如何使用`PostUpdateNode`s。

### Example 1

Consider the following setter and its call:
```
setFoo(obj, x) {
  sink1(obj.foo);
  obj.foo = x;
}

setFoo(myobj, source);
sink2(myobj.foo);
```
Here `source` should flow to the argument of `sink2` but not the argument of `sink1`. The shared library handles most of the complexity involved in this flow path, but needs a little bit of help in terms of available nodes. In particular it is important to be able to distinguish between the value of the `myobj` argument to `setFoo` before the call and after the call, since without this distinction it is hard to avoid also getting flow to `sink1`. The value before the call should be the regular `ArgumentNode` (which will get flow into the call), and the value after the call should be a `PostUpdateNode`. Thus a`PostUpdateNode` should exist for the `myobj` argument with the `ArgumentNode` as its pre-update node. In general `PostUpdateNode`s should exist for any mutable `ArgumentNode`s to support flow returning through a side-effect updating the argument.

> 这里`source`应该流向`sink2`的参数，而不是`sink1`的参数。共享库处理了这一流动路径中涉及的大部分复杂性，但在可用节点方面需要一点帮助。特别是能够区分调用前和调用后`setFoo`的`myobj`参数的值很重要，因为如果没有这种区分，很难避免也得到流向`sink1`的流量。调用前的值应该是常规的`ArgumentNode`(它将获得流进调用)，调用后的值应该是`PostUpdateNode`。因此，`myobj`参数应该存在一个`PostUpdateNode`，并以`ArgumentNode`作为其更新前的节点。一般来说，`PostUpdateNode`应该存在于任何可变的`ArgumentNode`中，以支持通过更新参数的副作用来返回流。

This example also suggests how `simpleLocalFlowStep` should be implemented for `PostUpdateNode`s: we need a local flow step between the `PostUpdateNode` for the `myobj` argument and the following `myobj` in the qualifier of `myobj.foo`.

> 这个例子也提示了`simpleLocalFlowStep`应该如何为`PostUpdateNode`s实现：我们需要在`PostUpdateNode`的`myobj`参数和下面`myobj.foo`的限定符中的`myobj`之间有一个本地流步骤。

Inside `setFoo` the actual store should also target a `PostUpdateNode` - in this case associated with the qualifier `obj` - as this is the mechanism the shared library uses to identify side-effects that should be reflected at call sites as setter-flow.  The shared library uses the following rule to identify setters: If the value of a parameter may flow to a node that is the pre-update node of a `PostUpdateNode` that is reached by some flow, then this represents an update to the parameter, which will be reflected in flow continuing to the `PostUpdateNode` of the corresponding argument in call sites.

> 在`setFoo`内部，实际的存储也应该针对一个`PostUpdateNode`--在这种情况下与限定符`obj`相关联--因为这是共享库用来识别应该在调用站点反映为setter-flow的副作用的机制。 共享库使用以下规则来识别setter。如果一个参数的值可能会流向一个节点，而这个节点是某个流向的`PostUpdateNode`的预更新节点，那么这就代表了参数的更新，在调用站点中，这个更新将反映在流向相应参数的`PostUpdateNode`的继续。

### Example 2

In the following two lines we would like flow from `x` to reach the `PostUpdateNode` of `a` through a sequence of two store steps, and this is indeed handled automatically by the shared library.

> 在下面的两行中，我们希望流从`x`通过两个存储步骤的序列到达`a`的`PostUpdateNode`，这确实是由共享库自动处理的。

```
a.b.c = x;
a.getB().c = x;
```
The only requirement for this to work is the existence of `PostUpdateNode`s. For a specified read step (in `readStep(Node n1, Content f, Node n2)`) the shared library will generate a store step in the reverse direction between the corresponding `PostUpdateNode`s. A similar store-through-reverse-read will be generated for calls that can be summarized by the shared library as getters. This usage of `PostUpdateNode`s ensures that `x` will not flow into the `getB` call after reaching `a`.

> 这个工作的唯一要求是存在`PostUpdateNode`s。对于一个指定的读取步骤（在`readStep(Node n1, Content f, Node n2)`中），共享库将在对应的`PostUpdateNode`s之间生成一个反向的存储步骤。对于可以被共享库总结为getters的调用，也会产生类似的存储-通-逆向读取。`PostUpdateNode`s的这种用法保证了`x`在到达`a`后不会流向`getB`调用。

### Example 3

Consider a constructor and its call (for this example we will use Java, but the idea should generalize):

> 考虑一个构造函数及其调用(在这个例子中，我们将使用Java，但这个想法应该是通用的)。

```java
MyObj(Content content) {
  this.content = content;
}

obj = new MyObj(source);
sink(obj.content);
```

We would like the constructor call to act in the same way as a setter, and indeed this is quite simple to achieve. We can introduce a synthetic data-flow node associated with the constructor call, let us call it `MallocNode`, and make this an `ArgumentNode` with position `-1` such that it hooks up with the implicit `this`-parameter of the constructor body. Then we can set the corresponding `PostUpdateNode` of the `MallocNode` to be the constructor call itself as this represents the value of the object after construction, that is after the constructor has run. With this setup of `ArgumentNode`s and `PostUpdateNode`s we will achieve the desired flow from `source` to `sink`

> 我们希望构造函数调用的作用与setter相同，事实上这很容易实现。我们可以引入一个与构造函数调用相关联的合成数据流节点，让我们称其为`MallocNode`，并将其变成一个位置为`-1`的`ArgumentNode`，使其与构造函数体的隐含`this`参数挂接。然后我们可以将`MallocNode`对应的`PostUpdateNode`设置为构造函数调用本身，因为这代表了构造后，也就是构造函数运行后对象的值。通过对`ArgumentNode`和`PostUpdateNode`的这种设置，我们将实现从`source`到`sink`的理想流程

### Field flow barriers

Consider this field flow example:

```
obj.f = source;
obj.f = safeValue;
sink(obj.f);
```
or the similar case when field flow is used to model collection content:

```
obj.add(source);
obj.clear();
sink(obj.get(key));
```
Clearing a field or content like this should act as a barrier, and this can be achieved by marking the relevant `Node, Content` pair as a clear operation in the `clearsContent` predicate. A reasonable default implementation for fields looks like this:

> 清除这样的字段或内容应该起到一个屏障的作用，这可以通过在 "clearsContent "谓词中把相关的 "节点、内容 "对标记为清除操作来实现。字段的合理默认实现是这样的。

```ql
predicate clearsContent(Node n, Content c) {
  n = any(PostUpdateNode pun | storeStep(_, c, pun)).getPreUpdateNode()
}
```
However, this relies on the local step relation using the smallest possible use-use steps. If local flow is implemented using def-use steps, then `clearsContent` might not be easy to use.

> 然而，这依赖于使用尽可能小的使用步骤的本地步骤关系。如果本地流是使用def-use步骤实现的，那么`clearsContent`可能就不容易使用了。

## Type pruning

The library supports pruning paths when a sequence of value-preserving steps originate in a node with one type, but reaches a node with another and incompatible type, thus making the path impossible.

> 当一个保值步骤序列起源于一种类型的节点，但到达另一种不兼容类型的节点，从而使路径不可能时，该库支持修剪路径。

The type system for this is specified with the class `DataFlowType` and the compatibility relation `compatibleTypes(DataFlowType t1, DataFlowType t2)`. Using a singleton type as `DataFlowType` means that this feature is effectively disabled.

> 为此的类型系统用`DataFlowType`类和兼容性关系`compatibleTypes(DataFlowType t1, DataFlowType t2)`来指定。使用一个单子类型作为`DataFlowType`意味着这个功能被有效地禁用。

It can be useful to use a simpler type system for pruning than whatever type system might come with the language, as collections of types that would otherwise be equivalent with respect to compatibility can then be represented as a single entity (this improves performance). As an example, Java uses erased types for this purpose and a single equivalence class for all numeric types.

> 在修剪时使用一个比语言自带的任何类型系统更简单的类型系统可能是有用的，因为本来在兼容性方面是等价的类型集合可以被表示为一个单一的实体（这提高了性能）。举个例子，Java为此使用了擦除类型，并为所有数字类型使用了一个单一的等价类。

The type of a `Node` is given by the following predicate

> 一个 "节点 "的类型由下面的谓词给出

```
DataFlowType getNodeType(Node n)
```
and every `Node` should have a type.

One also needs to define the string representation of a `DataFlowType`:

> 而每个`节点`都应该有一个类型。
>
> 我们还需要定义一个`DataFlowType`的字符串表示。

```
string ppReprType(DataFlowType t)
```
The `ppReprType` predicate is used for printing a type in the labels of `PathNode`s, this can be defined as `none()` if type pruning is not used. Finally, one must define `CastNode` as a subclass of `Node` as those nodes where types should be checked. Usually this will be things like explicit casts. The shared library will also check types at `ParameterNode`s and `OutNode`s without needing to include these in `CastNode`.  It is semantically perfectly valid to include all nodes in `CastNode`, but this can hurt performance as it will reduce the opportunity for the library to compact several local steps into one. It is also perfectly valid to leave `CastNode` as the empty set, and this should be the default if type pruning is not used.

> `ppReprType`谓词用于在`PathNode`s的标签中打印类型，如果不使用类型修剪，可以定义为`none()`。最后，必须将`CastNode`定义为`Node`的一个子类，作为那些应该检查类型的节点。通常这将是像显式投胎这样的事情。共享库也会在`ParameterNode`s和`OutNode`s检查类型，而不需要在`CastNode`中包含这些。 在`CastNode`中包含所有节点在语义上是完全有效的，但这可能会影响性能，因为这将减少库将几个本地步骤压缩成一个的机会。将`CastNode`作为空集也是完全有效的，如果不使用类型修剪，这应该是默认的。

## Virtual dispatch with call context

Consider a virtual call that may dispatch to multiple different targets. If we know the call context of the call then this can sometimes be used to reduce the set of possible dispatch targets and thus eliminate impossible call chains.

> 考虑一个虚拟调用，它可能会派遣到多个不同的目标。如果我们知道该调用的调用上下文，那么有时可以用它来减少可能的调度目标集，从而消除不可能的调用链。

The library supports a one-level call context for improving virtual dispatch.

> 该库支持一级调用上下文来改善虚拟调度。

Conceptually, the following predicate should be implemented as follows:

> 从概念上讲，下面的谓词应该是这样实现的:

```ql
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
  exists(DataFlowCallable enclosing |
    result = viableCallable(call) and
    enclosing = call.getEnclosingCallable() and
    enclosing = viableCallable(ctx)
  |
    not ... <`result` is impossible target for `call` given `ctx`> ...
  )
}
```
However, joining the virtual dispatch relation with itself in this way is usually way too big to be feasible. Instead, the relation above should only be defined for those values of `call` for which the set of resulting dispatch targets might be reduced. To do this, define the set of `call`s that might for some reason benefit from a call context as the following predicate (the `c` column should be `call.getEnclosingCallable()`):

> 然而，以这种方式将虚拟调度关系与自身连接起来通常太大了，不可行。相反，上面的关系应该只为那些可能减少结果调度目标集的`call`的值定义。要做到这一点，将由于某些原因可能从调用上下文中受益的`call`的集合定义为下面的谓词（`c`列应该是`call.getEnclosingCallable()`）:

```ql
predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c)
```
And then define `DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx)` as sketched above, but restricted to `mayBenefitFromCallContext(call, _)`.

> 然后定义`DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx)`，如上图所示，但仅限于`mayBenefitFromCallContext(call, _)`。

The shared implementation will then compare counts of virtual dispatch targets using `viableCallable` and `viableImplInCallContext` for each `call` in `mayBenefitFromCallContext(call, _)` and track call contexts during flow calculation when differences in these counts show an improved precision in further calls.

> 然后，共享实现将使用`viableCallable`和`viableImplInCallContext`对`mayBenefitFromCallContext(call，_)`中的每个`call`比较虚拟调度目标的计数，并在流计算期间跟踪调用上下文，当这些计数的差异显示出在进一步调用中提高了精度。

## Additional features

### Access path length limit

The maximum length of an access path is the maximum number of nested stores that can be tracked. This is given by the following predicate:

> 访问路径的最大长度是指可以跟踪的嵌套存储的最大数量。这由下面的谓词给出:

```ql
int accessPathLimit() { result = 5 }
```
We have traditionally used 5 as a default value here, and real examples have been observed to require at least this much. Changing this value has a direct impact on performance for large databases.

> 我们传统上将5作为这里的默认值，据观察，实际的例子至少需要这么多。改变这个值对大型数据库的性能有直接影响。

### Hidden nodes

Certain synthetic nodes can be hidden to exclude them from occurring in path explanations. This is done through the following predicate:

> 某些合成节点可以被隐藏，以排除它们在路径解释中出现。这是通过以下谓词实现的。

```ql
predicate nodeIsHidden(Node n)
```

### Unreachable nodes

Consider:
```
foo(source1, false);
foo(source2, true);

foo(x, b) {
  if (b)
    sink(x);
}
```
Sometimes certain data-flow nodes can be unreachable based on the call context. In the above example, only `source2` should be able to reach `sink`. This is supported by the following predicate where one can specify unreachable nodes given a call context.

> 有时，根据调用上下文，某些数据流节点可能无法到达。在上面的例子中，只有`source2`能够到达`sink`。下面的谓词就支持这一点，可以指定给定调用上下文的不可到达的节点。

```ql
predicate isUnreachableInCall(Node n, DataFlowCall callcontext) { .. }
```
Note that while this is a simple interface it does have some scalability issues if the number of unreachable nodes is large combined with many call sites.

> 请注意，虽然这是一个简单的接口，但如果无法到达的节点数量很大，再加上有许多呼叫站点，它确实存在一些可扩展性问题。

### `BarrierGuard`s

The class `BarrierGuard` must be defined. See https://github.com/github/codeql/pull/1718 for details.

> 必须定义 "BarrierGuard "类。详情请见https://github.com/github/codeql/pull/1718。

### Consistency checks

The file `dataflow/internal/DataFlowImplConsistency.qll` contains a number of consistency checks to verify that the language-specific parts satisfy the invariants that are expected by the shared implementation. Run these queries to check for inconsistencies.

> 文件`dataflow/internal/DataFlowImplConsistency.qll`包含一些一致性检查，以验证语言特定部分是否满足共享实现所期望的不变性。运行这些查询来检查不一致的地方。
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
