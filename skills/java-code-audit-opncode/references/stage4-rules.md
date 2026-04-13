# 阶段4：漏洞子模块审计规则

## 通用规则模板
- 匹配模板：`Source -> Transform -> Sink`
- 前置校验：鉴权、输入约束、过滤/编码、框架安全配置
- 误报排除：不可控输入、不可达路径、强白名单、上下文正确编码

---

## sql-auditor
- 匹配
  - Source 可控参数进入拼接 SQL 或 MyBatis `${}`。
- 前置校验
  - 是否使用 `PreparedStatement` / MyBatis `#{}`。
- 排除
  - 字段名来自固定枚举映射且无旁路。

## xxe-auditor
- 匹配
  - 不可信 XML 输入 -> `DocumentBuilderFactory/SAXParser/XMLInputFactory`。
- 前置校验
  - 是否显式关闭外部实体、DTD。
- 排除
  - 仅处理可信内部静态 XML 且解析器全局安全封装生效。

## deserialization-auditor
- 匹配
  - 可控输入 -> `ObjectInputStream.readObject` 或高危库反序列化入口。
- 前置校验
  - 是否存在 `ObjectInputFilter`、签名校验、严格白名单。
- 排除
  - 数据源不可控且链路完整认证。

## ssrf-auditor
- 匹配
  - 可控 URL/host/path -> HTTP 客户端请求。
- 前置校验
  - 协议/域名/IP 白名单；是否禁用重定向。
- 排除
  - 目标服务固定且由不可变配置决定。

## ssti-auditor
- 匹配
  - 用户输入参与模板名/表达式解析。
- 前置校验
  - 是否禁用危险表达式能力；模板名是否固定映射。
- 排除
  - 仅普通变量渲染，模板结构不可控。

## xss-auditor
- 匹配
  - 不可信输入直接进入 HTML/JS/URL 输出上下文。
- 前置校验
  - 是否执行正确上下文编码。
- 排除
  - 统一输出编码且模板引擎自动转义不可关闭。

## file-auditor（上传/读取）
- 匹配
  - 可控文件名/路径 -> 文件系统读写 API。
- 前置校验
  - 规范化路径 + 根目录约束 + 扩展/MIME/magic 校验。
- 排除
  - 路径由固定 ID 映射生成，且不接受相对路径片段。

## cmdi-auditor（命令注入）
- 匹配
  - 可控参数拼接 shell 命令执行。
- 前置校验
  - 是否使用参数数组；是否有严格枚举白名单。
- 排除
  - 命令与参数常量化且不可被输入影响。
