# CodeQL pre-commit-hook setup

As stated in [CONTRIBUTING](../CONTRIBUTING.md) all CodeQL files must be formatted according to our [CodeQL style guide](ql-style-guide.md). You can use our pre-commit hook to avoid committing incorrectly formatted code. To use it, simply copy the [pre-commit](../misc/scripts/pre-commit) script to `.git/hooks/pre-commit` and make sure that:

> 正如在[CONTRIBUTING](.../CONTRIBUTING.md)中所述，所有的CodeQL文件必须根据我们的[CodeQL样式指南](ql-style-guide.md)进行格式化。你可以使用我们的预提交钩子来避免提交不正确格式的代码。要使用它，只需将[pre-commit](.../misc/scripts/pre-commit)脚本复制到`.git/hooks/pre-commit`，并确保;

- The script is executable. On Linux and macOS this can be done using `chmod +x`.

    > 脚本是可执行的。在Linux和macOS上，可以使用`chmod +x`来完成。

- The CodeQL CLI has been added to your `PATH`.

    > CodeQL CLI已经被添加到你的`PATH`中。

The script will abort a commit that contains incorrectly formatted code in .ql or .qll files and print an error message like:

> 脚本将中止包含在.ql或.ql文件中的错误格式的代码的提交，并打印出一个错误信息，如:

```
> git commit -m "My commit."
ql/cpp/ql/src/Options.qll would change by autoformatting.
ql/cpp/ql/src/printAst.ql would change by autoformatting.
```

If you prefer to have the script automatically format the code (and not abort the commit), you can replace the line `codeql query format --check-only` with `codeql query format --in-place` (and `exit $exitVal` with `exit 0`).

> 如果你想让脚本自动格式化代码(而不是中止提交)，你可以用 "codeql query format --in-place "替换 "codeql query format --check-only"(用 "exit 0 "替换 "exit $exitVal")。