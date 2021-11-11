# Learning-CodeQL
## 前言

CodeQL学习笔记  `只有Java`

加入运行截屏帮助理解CodeQL代码

笔记目前单纯为个人理解，如有错误还请不吝赐教。

`欢迎大家提交pr或者是直接提交在issue中，看到会在第一时间更新！`

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

ps: 排列顺序由本人发现时间为主，CodeQL 频道里面包含大量视频。

| Youtube                                                      | Twitter                                             | Github                                                       | 文章                                                         | 其他                                                         |
| ------------------------------------------------------------ | --------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Discover vulnerabilities with CodeQL by: Boik Su ](https://youtu.be/UDDHXBFbuqo) | [@boik_su](https://twitter.com/boik_su)             | [codeql_chinese](https://github.com/xsser/codeql_chinese)    | [Github 官方文档](https://codeql.github.com/docs/)           | [Github 官方API](https://codeql.github.com/codeql-standard-libraries/java/index.html) |
| [[Live Stream] CodeQL Code Scanning Language Tutorial ](https://youtu.be/HH7wLL2g1Iw ) | [@SummerSec](https://twitter.com/SecSummers)        | [Github's CodeQL](https://github.com/github/codeql)          | [haby0 's 博客](https://github.com/haby0/mark)               | [Github research 文档](https://securitylab.github.com/research/) |
| [Securing your code with CodeQL with Sasha Rosenbaum! - OWASP DevSlop](https://youtu.be/G_yDbouY0tM) | [@haby013](https://twitter.com/haby013)             | [Github's securitylab](https://github.com/github/securitylab) | [使用codeql 挖掘 ofcms](https://www.anquanke.com/post/id/203674) |                                                              |
| [What is GitHub Code Scanning? Find VULNERABILITIES in your code](https://youtu.be/A8SERCUE-i4) | [@GHSecurityLab](https://twitter.com/GHSecurityLab) | [CodeQL Queries for Insecure JMS Deserialization](https://github.com/silentsignal/jms-codeql/) | [代码分析引擎 CodeQL 初体验](https://paper.seebug.org/1078/#_1) |                                                              |
| [$3,000 CodeQL query for finding LDAP Injection - Github Security Lab ]( https://youtu.be/qStzSfsEQGQ) | [@pwntester](https://twitter.com/pwntester)         | [Apache Struts CVE-2018-11776](https://github.com/github/securitylab/blob/main/CodeQL_Queries/java/Apache_Struts_CVE-2018-11776) | [使用codeql挖掘fastjson利用链](https://xz.aliyun.com/t/7482) |                                                              |
| [CodeQL 频道](https://www.youtube.com/channel/UCudgrgkdUUA17vqnrHzXtVw) |                                                     | [codeql-jdk-docke](https://github.com/Marcono1234/codeql-jdk-docker) | [使用 CodeQL 挖掘 CVE-2020-9297](https://xz.aliyun.com/t/7979) |                                                              |
| [CodeQL as an auditing oracle - POC 2020](https://www.youtube.com/watch?v=XmAEgl8bVhg) |                                                     | [codeql-dubbo-workshop](https://github.com/github/codeql-dubbo-workshop) | [codeql学习——污点分析](https://xz.aliyun.com/t/7789)         |                                                              |
| [mbuf-oflow: Finding Vulnerabilities In iOS/MacOS Networking Code](https://www.youtube.com/watch?v=0EHP2gzwVAY) |                                                     | [LookupInterface](https://github.com/SummerSec/LookupInterface) | [如何用CodeQL数据流复现 apache kylin命令执行漏洞](https://xz.aliyun.com/t/8240) |                                                              |
| [Community-powered security analysis with CodeQL - GitHub Universe 2020](https://youtu.be/Y6PjAaZKNYk) |                                                     | [jms-codeql](https://github.com/silentsignal/jms-codeql/)    | [CodeQL从入门到放弃](https://www.freebuf.com/articles/web/283795.html) |                                                              |
| [Using GitHub code scanning and CodeQL to detect traces of Solorigate and other backdoors](https://github.blog/2021-03-16-using-github-code-scanning-and-codeql-to-detect-traces-of-solorigate-and-other-backdoors/) |                                                     |                                                              | [CodeQL 快速上手](https://www.yuque.com/docs/share/738555ae-258e-4f27-8818-6024b8225488?#) |                                                              |
| [PII data leaks: Identifying personal information in logs with QL ](https://youtu.be/hHaOxbyqy44) |                                                     |                                                              | [CodeQL与XRay联动实现黑白盒双重校验](https://www.yuque.com/docs/share/782dbabc-1f9a-4214-8003-289886447bb4) |                                                              |
| [Finding Insecure Deserialization in Java](https://www.youtube.com/watch?v=XsUcSd75K00) |                                                     |                                                              | [使用 CodeQL 分析闭源 Java 程序](https://paper.seebug.org/1324/) |                                                              |
| [How Variant Analysis and CodeQL helped secure the fight against COVID-19](https://www.youtube.com/watch?v=5beYejYfhjY) |                                                     |                                                              | [finding-insecure-jwt-signature-validation-with-codeql](https://intrigus.org/research/2021/08/05/finding-insecure-jwt-signature-validation-with-codeql/) |                                                              |
|                                                              |                                                     |                                                              | [Apache Dubbo: All roads lead to RCE](https://securitylab.github.com/research/apache-dubbo/) |                                                              |
|                                                              |                                                     |                                                              | [CodeQL从0到1（内附Shiro检测demo）](https://www.anquanke.com/post/id/255721) |                                                              |
|                                                              |                                                     |                                                              | [CodeQL with CVE-2021-2471](http://m0d9.me/2021/11/01/CodeQL-CVE-2021-2471/) |                                                              |
|                                                              |                                                     |                                                              | [CodeQL 若干问题思考及 CVE-2019-3560 审计详解](https://lennysec.github.io/codql-and-cve-2019-3560/) |                                                              |
|                                                              |                                                     |                                                              | [从Java反序列化漏洞题看CodeQL数据流](https://www.anquanke.com/post/id/256967) |                                                              |
|                                                              |                                                     |                                                              |                                                              |                                                              |



----









 [![Stargazers over time](https://starchart.cc/SummerSec/learning-codeql.svg)](https://starchart.cc/SummerSec/JavaLearnVulnerability) 





<img align='right' src="https://profile-counter.glitch.me/summersec/count.svg" width="200">