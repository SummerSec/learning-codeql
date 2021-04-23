<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:88d535090e828923d4715f11cd88932964fa5d4b4aa756a72ba0c7a7ad451b77
size 14303
=======
.. _analyzing-databases-with-the-codeql-cli:

Analyzing databases with the CodeQL CLI
=======================================

To analyze a codebase, you run queries against a CodeQL
database extracted from the code.

> 要分析代码库，你需要对从代码中提取的CodeQLdatabase运行查询。

CodeQL analyses produce :ref:`interpreted results
<interpret-query-results>` that can be displayed as alerts or paths in source code.
For information about writing queries to run with ``database analyze``, see
":doc:`Using custom queries with the CodeQL CLI <using-custom-queries-with-the-codeql-cli>`."

CodeQL分析会产生:ref:`解释结果<interpret-query-results>`，这些结果可以在源代码中作为警报或路径显示。关于编写查询以与数据库分析一起运行的信息，请参见":doc:`使用CodeQL CLI的自定义查询<using-custom-queries-with-the-codeql-cli>`"。

.. include:: ../reusables/advanced-query-execution.rst

Before starting an analysis you must:
在开始分析之前，你必须:

- :doc:`Set up the CodeQL CLI <getting-started-with-the-codeql-cli>` so that it can find the queries
  and libraries included in the CodeQL repository. 
  `设置CodeQL CLI <getting-started-with-the-codeql-cli>`，这样它就可以找到CodeQL仓库中包含的查询和库。
- :doc:`Create a CodeQL database <creating-codeql-databases>` for the source 
  code you want to analyze. 
  `为你要分析的源代码创建一个CodeQL数据库<creating-codeql-databases>`。
运行codeql数据库分析


Running ``codeql database analyze``
------------------------------------

When you run ``database analyze``, it does two things:
当你运行数据库分析时，它会做两件事：

#. Executes one or more query files, by running them over a CodeQL database.
    执行一个或多个查询文件，通过在CodeQL数据库上运行它们。
#. Interprets the results, based on certain query metadata, so that alerts can be
   displayed in the correct location in the source code.
   根据一定的查询元数据，解释结果，以便在源代码的正确位置显示警报。

You can analyze a database by running the following command::
可以通过运行以下命令来分析数据库。

   codeql database analyze <database> <queries> --format=<format> --output=<output>

You must specify:
你必须指定：

- ``<database>``: the path to the CodeQL database you want to analyze.
  <database>：你要分析的CodeQL数据库的路径

- ``<queries>``: the queries to run over your database. You can
  list one or more individual query files, specify a directory that will be
  searched recursively for query files, or name a query suite that defines a
  particular set of queries. For more information, see the :ref:`examples
  <database-analyze-examples>` below.
  <queries>：要在数据库上运行的查询。您可以列出一个或多个单独的查询文件，指定一个将递归搜索查询文件的目录，或者命名一个定义特定查询集的查询套件。更多信息，请参见下面的:ref:`examples <database-analyze-examples>`。

- ``--format``: the format of the results file generated during analysis. A
  number of different formats are supported, including CSV, :ref:`SARIF
  <sarif-file>`, and graph formats. For more information about CSV and SARIF,
  see `Results <#results>`__. To find out which other results formats are
  supported, see the `database analyze reference
  <../manual/database-analyze>`__.
  --format：分析过程中生成的结果文件的格式。支持多种不同的格式，包括CSV、 :ref:`SARIF <sarif-file>`和图表格式。有关CSV和SARIF的更多信息，请参见结果。要了解支持的其他结果格式，请参见数据库分析参考。

- ``--output``: the output path of the results file generated during analysis.
--output：分析过程中生成的结果文件的输出路径。

You can also specify:
您也可以指定:

- .. include:: ../reusables/threads-query-execution.rst


.. pull-quote:: 

   Upgrading databases

   If the CodeQL queries you want to use are newer than the
   extractor used to create the database, then you may see a message telling you
   that your database needs to be upgraded when you run ``database analyze``.
   You can quickly upgrade a database by running the ``database upgrade``
   command. For more information, see ":doc:`Upgrading CodeQL databases
   <upgrading-codeql-databases>`."
   如果你要使用的CodeQL查询比用于创建数据库的提取器要新，那么当你运行数据库分析时，你可能会看到一条消息告诉你，你的数据库需要升级。你可以通过运行数据库升级命令快速升级数据库。有关更多信息，请参阅":doc:`升级CodeQL数据库<upgrading-codeql-databases>`"。

For full details of all the options you can use when analyzing databases, see
the `database analyze reference documentation <../manual/database-analyze>`__.
有关分析数据库时可以使用的所有选项的完整细节，请参见数据库分析参考文档。


.. _database-analyze-examples:

Examples
--------

The following examples assume your CodeQL databases have been created in a
directory that is a sibling of your local copies of the CodeQL and CodeQL for Go
repositories.
下面的例子假设你的CodeQL数据库已经被创建在你的CodeQL和CodeQL for Go仓库的本地副本的兄弟目录中。


Running a single query
~~~~~~~~~~~~~~~~~~~~~~

To run a single query over a JavaScript codebase, you could use the following
command from the directory containing your database::
要在JavaScript代码库上运行单个查询，你可以在包含数据库的目录下使用以下命令:


   codeql database analyze <javascript-database> ../ql/javascript/ql/src/Declarations/UnusedVariable.ql --format=csv --output=js-analysis/js-results.csv 

This command runs a simple query that finds potential bugs related to unused
variables, imports, functions, or classes---it is one of the JavaScript
queries included in the CodeQL repository. You could run more than one query by
specifying a space-separated list of similar paths.
这个命令运行一个简单的查询，以查找与未使用的变量、导入、函数或类相关的潜在错误------它是CodeQL资源库中包含的JavaScript查询之一。你可以通过指定一个以空格分隔的类似路径列表来运行多个查询。

The analysis generates a CSV file (``js-results.csv``) in a new directory
(``js-analysis``).  
分析会在一个新的目录（js-analysis）中生成一个CSV文件（jsresults.csv）。


You can also run your own custom queries with the ``database analyze`` command.
For more information about preparing your queries to use with the CodeQL CLI,
see ":doc:`Using custom queries with the CodeQL CLI <using-custom-queries-with-the-codeql-cli>`."
你也可以使用数据库分析命令运行你自己的自定义查询。有关准备使用CodeQL CLI的查询的更多信息，请参阅":doc:`使用CodeQL CLI的自定义查询<using-custom-queries-with-the-codeql-cli>`"。



Running LGTM.com query suites
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The CodeQL repository also includes query suites, which can be run over your
code as part of a broader code review. CodeQL query suites are ``.qls`` files
that use directives to select queries to run based on certain metadata
properties.
CodeQL资源库还包括查询套件，它可以作为更广泛的代码审查的一部分在你的代码上运行。CodeQL查询套件是.qls文件，它使用指令来选择基于特定元数据属性的查询来运行。


The query suites included in the CodeQL repository select the same set of
queries that are run by default on `LGTM.com <https://lgtm.com>`__. The queries
are selected to highlight the most relevant and useful results for each
language. 
CodeQL资源库中包含的查询套件选择了与LGTM.com上默认运行的相同的查询集。选择这些查询是为了突出每个语言的最相关和有用的结果。

The language-specific LGTM query suites are located at the following paths in
the CodeQL repository::
特定语言的LGTM查询套件位于CodeQL资源库中的以下路径:
   ql/<language>/ql/src/codeql-suites/<language>-lgtm.qls

and at the following path in the CodeQL for Go repository::
并在CodeQL for Go资源库中的以下路径:
   ql/src/codeql-suites/go-lgtm.qls

These locations are specified in the metadata included in the standard QL packs.
This means that CodeQL knows where to find the suite files automatically, and
you don't have to specify the full path on the command line when running an
analysis. For more information, see ":ref:`About QL packs <standard-ql-packs>`."
这些位置是在标准QL包中的元数据中指定的，这意味着CodeQL会自动知道套件文件的位置，当运行分析时，你不必在命令行中指定完整的路径。这意味着CodeQL会自动知道在哪里找到套件文件，当运行分析时，你不必在命令行上指定完整的路径。更多信息，请参阅":ref:`关于QL包<standard-ql-packs>`"。


For example, to run the LGTM.com query suite on a C++ codebase (generating
results in the latest SARIF format), you would run::
例如，要在C++代码库上运行LGTM.com查询套件（以最新的SARIF格式生成结果），你将运行:

   codeql database analyze <cpp-database> cpp-lgtm.qls --format=sarif-latest --output=cpp-analysis/cpp-results.sarif

For information about creating custom query suites, see ":doc:`Creating
CodeQL query suites <creating-codeql-query-suites>`."
有关创建自定义查询套件的信息，请参见":doc:`创建CodeQL查询套件<creating-codeql-query-suites>"。"
Running all queries in a directory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can run all the queries located in a directory by providing the directory
path, rather than listing all the individual query files. Paths are searched
recursively, so any queries contained in subfolders will also be executed. 
你可以通过提供目录路径来运行位于目录中的所有查询，而不是列出所有单独的查询文件。路径是以递归方式搜索的，因此子文件夹中包含的任何查询也将被执行。

.. pull-quote::

   Important

   You shouldn't specify the root of a :doc:`QL pack
   <about-ql-packs>` when executing ``database analyze``
   as it contains some special queries that aren't designed to be used with
   the command. Rather, to run a wide range of useful queries, run one of the
   LGTM.com query suites. 
   在执行数据库分析时，你不应该指定:doc:`QL包<about-ql-packs>`的根目录，因为它包含了一些特殊的查询，而这些查询并不是设计用来与命令一起使用的。相反，如果要运行各种有用的查询，可以运行LGTM.com查询套件中的一个。

   
For example, to execute all Python queries contained in the ``Functions``
directory you would run::
例如，要执行Functions目录中包含的所有Python查询，你将运行:

   codeql database analyze <python-database> ../ql/python/ql/src/Functions/ --format=sarif-latest --output=python-analysis/python-results.sarif 

A SARIF results file is generated. Specifying ``--format=sarif-latest`` ensures
that the results are formatted according to the most recent SARIF specification
supported by CodeQL.
一个SARIF结果文件被生成。指定--format=sarif-latest可以确保结果的格式是根据CodeQL支持的最新SARIF规范。


Results
-------

You can save analysis results in a number of different formats, including SARIF
and CSV.
您可以将分析结果保存为多种不同的格式，包括SARIF和CSV。

The SARIF format is designed to represent the output of a broad range of static
analysis tools. For more information, see :doc:`SARIF output <sarif-output>`.
SARIF格式被设计用来表示广泛的静态分析工具的输出。如需了解更多信息，请参阅:doc:`SARIF输出<sarif-output>`。

If you choose to generate results in CSV format, then each line in the output file
corresponds to an alert. Each line is a comma-separated list with the following information:
如果您选择以CSV格式生成结果，那么输出文件中的每一行都对应一个警报。每一行都是一个逗号分隔的列表，包含以下信息:
.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Property
     - Description
     - Example
   * - Name
     - Name of the query that identified the result. 
     - ``Inefficient regular expression``
   * - Description
     - Description of the query. 
     - ``A regular expression that requires exponential time to match certain 
       inputs can be a performance bottleneck, and may be vulnerable to 
       denial-of-service attacks.``
   * - Severity
     - Severity of the query.
     - ``error``
   * - Message
     - Alert message. 
     - ``This part of the regular expression may cause exponential backtracking 
       on strings containing many repetitions of '\\\\'.``
   * - Path
     - Path of the file containing the alert.
     - ``/vendor/codemirror/markdown.js``
   * - Start line
     - Line of the file where the code that triggered the alert begins.
     - ``617``
   * - Start column
     - Column of the start line that marks the start of the alert code. Not
       included when equal to 1.
     - ``32``
   * - End line
     - Line of the file where the code that triggered the alert ends. Not
       included when the same value as the start line.
     - ``64``
   * - End column
     - Where available, the column of the end line that marks the end of the 
       alert code. Otherwise the end line is repeated.
     - ``617``

Results files can be integrated into your own code-review or debugging
infrastructure. For example, SARIF file output can be used to highlight alerts
in the correct location in your source code using a SARIF viewer plugin for your
IDE. 
结果文件可以集成到您自己的代码审查或调试基础架构中。例如，SARIF文件输出可以用来突出显示源代码中正确位置的警报，使用IDE的SARIF查看器插件。
Further reading
---------------

- ":ref:`Analyzing your projects in CodeQL for VS Code <analyzing-your-projects>`"

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
