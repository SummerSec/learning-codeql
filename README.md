# Learning-CodeQL
## 前言

CodeQL学习笔记  `只有Java`

加入运行截屏帮助理解CodeQL代码

笔记目前单纯为个人理解，如有错误还请不吝赐教。

----

### 格式说明

目前都是中英文对照翻译，翻译大部分是机翻，会小幅度修改一部分。



| 目录                       | 内容                                                         |
| -------------------------- | ------------------------------------------------------------ |
| codeql-custom-queries-java | codeql的一些语法规则                                         |
| codeql-java                | codeql对于Java方向上的内容                                   |
| codeql-docs                | codeql官方对codeql格式要求文档等                             |
| codeql-java                | CodeQL官方的实验并学习如何为由Java代码库生成的CodeQL数据库编写有效和高效的查询。 |
| codeql-java-vul            | java vul QL                                                  |







----

## 推荐



| Youtube                                                      | Twitter                                             | Github                                                       | 文章                                                         | 其他                                                         |
| ------------------------------------------------------------ | --------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Discover vulnerabilities with CodeQL by: Boik Su ](https://youtu.be/UDDHXBFbuqo) | [@boik_su](https://twitter.com/boik_su)             | [codeql_chinese](https://github.com/xsser/codeql_chinese)    | [Github 官方文档](https://codeql.github.com/docs/)           | [Github 官方API](https://codeql.github.com/codeql-standard-libraries/java/index.html) |
| [[Live Stream] CodeQL Code Scanning Language Tutorial ](https://youtu.be/HH7wLL2g1Iw ) | [@SummerSec](https://twitter.com/SecSummers)        | [Github's CodeQL](https://github.com/github/codeql)          | [haby0 's 博客](https://github.com/haby0/mark)               | [Github research 文档](https://securitylab.github.com/research/) |
| [Securing your code with CodeQL with Sasha Rosenbaum! - OWASP DevSlop](https://youtu.be/G_yDbouY0tM) | [@haby013](https://twitter.com/haby013)             | [Github's securitylab](https://github.com/github/securitylab) | [使用codeql 挖掘 ofcms](https://www.anquanke.com/post/id/203674) |                                                              |
| [What is GitHub Code Scanning? Find VULNERABILITIES in your code](https://youtu.be/A8SERCUE-i4) | [@GHSecurityLab](https://twitter.com/GHSecurityLab) | [CodeQL Queries for Insecure JMS Deserialization](https://github.com/silentsignal/jms-codeql/) | [代码分析引擎 CodeQL 初体验](https://paper.seebug.org/1078/#_1) |                                                              |
| [$3,000 CodeQL query for finding LDAP Injection - Github Security Lab ]( https://youtu.be/qStzSfsEQGQ) |                                                     | [Apache Struts CVE-2018-11776](https://github.com/github/securitylab/blob/main/CodeQL_Queries/java/Apache_Struts_CVE-2018-11776) | [使用codeql挖掘fastjson利用链](https://xz.aliyun.com/t/7482) |                                                              |
| [CodeQL 频道](https://www.youtube.com/channel/UCudgrgkdUUA17vqnrHzXtVw) |                                                     |                                                              | [使用 CodeQL 挖掘 CVE-2020-9297](https://xz.aliyun.com/t/7979) |                                                              |
| [CodeQL as an auditing oracle - POC 2020](https://www.youtube.com/watch?v=XmAEgl8bVhg) |                                                     |                                                              | [codeql学习——污点分析](https://xz.aliyun.com/t/7789)         |                                                              |
| [mbuf-oflow: Finding Vulnerabilities In iOS/MacOS Networking Code](https://www.youtube.com/watch?v=0EHP2gzwVAY) |                                                     |                                                              | [如何用CodeQL数据流复现 apache kylin命令执行漏洞](https://xz.aliyun.com/t/8240) |                                                              |
| [Community-powered security analysis with CodeQL - GitHub Universe 2020](https://youtu.be/Y6PjAaZKNYk) |                                                     |                                                              |                                                              |                                                              |
| [Using GitHub code scanning and CodeQL to detect traces of Solorigate and other backdoors](https://github.blog/2021-03-16-using-github-code-scanning-and-codeql-to-detect-traces-of-solorigate-and-other-backdoors/) |                                                     |                                                              |                                                              |                                                              |
| [PII data leaks: Identifying personal information in logs with QL ](https://youtu.be/hHaOxbyqy44) |                                                     |                                                              |                                                              |                                                              |



----









 [![Stargazers over time](https://starchart.cc/SummerSec/learning-codeql.svg)](https://starchart.cc/SummerSec/JavaLearnVulnerability) 





<img align='right' src="https://profile-counter.glitch.me/summersec/count.svg" width="200">