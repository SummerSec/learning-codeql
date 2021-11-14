## bug 问题



### 描述

Please try using a newer version of the query libraries.(codeQL runQuery)<br/>Error Query demo.ql<br/>expects database scheme   ``vscode-codeql-starter\ql\java\ql\src\config\semmlecode.dbscheme``, but the current database has a different scheme, and no database upgrades are available. The current database scheme may be newer than the CodeQL query libraries in your workspace 

![](https://user-images.githubusercontent.com/47944478/141506145-68e42c9e-ca9d-42cf-826c-db8fbf29ab9f.png)



### 解决办法

第一种临时解决方法，直接找到`vscode-codeql-starter\ql\java\ql\src\config\`文件夹下将两个文件替换掉生成数据库文件目录下`db-java`两个文件。

ps：最新版本的vscode-codeql-starter的将config目录删除了对应文件也没了，所以最新版本没有这个bug。

另外这种bug，在低版本可以使用，在高版本CodeQL CLI 2.7.0（亲测其他版本还待测试）无法解决。。

第二种解决方法，更新ql目录（记得经常更新🤦‍♂️）

![image-20211114130942188](https://gitee.com/samny/images/raw/master/summersec//42u09er42ec/42u09er42ec.png)



在vscode-codeql-starter根目录下执行命令

```
git pull
git submodule update --recursive
```





