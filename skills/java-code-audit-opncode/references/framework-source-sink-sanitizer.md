# Framework Source / Sink / Sanitizer 映射

## Spring Boot / Spring MVC

### Sources
- `@RequestParam`, `@PathVariable`, `@RequestHeader`, `@CookieValue`
- `@RequestBody`（JSON/XML）
- `MultipartFile` 上传参数
- WebSocket/STOMP 消息 payload

### Sinks
- SQL 执行：`JdbcTemplate.query/update`, `Statement.execute*`, `EntityManager.createNativeQuery`
- 命令执行：`Runtime.getRuntime().exec`, `ProcessBuilder.start`
- SSRF：`RestTemplate`, `WebClient`, `HttpClient`, `URL.openConnection`
- 文件：`Files.read/write`, `FileInputStream`, `FileOutputStream`
- 模板：`Thymeleaf/Spring EL` 动态模板名或表达式

### Sanitizers
- SQL 参数化：`PreparedStatement`, `NamedParameterJdbcTemplate`
- 输入校验：`@Validated`, `javax.validation` 注解（需确认覆盖）
- 输出编码：`HtmlUtils.htmlEscape`（需匹配上下文）
- URL/主机白名单校验函数（项目自定义）

## MyBatis

### Sources
- Controller 入参传入 Mapper 的 DTO/Map/String

### Sinks
- XML Mapper 中 `${param}`
- 注解 SQL 中字符串拼接

### Sanitizers
- `#{param}` 参数绑定
- 枚举白名单映射（排序字段、表名别名）

### 重点规则
- `${}` 默认判为高风险，除非参数来自严格白名单映射。
- `ORDER BY ${}` 需检查字段映射是否闭集。

## Struts2

### Sources
- Action 属性自动绑定
- 参数拦截器注入字段

### Sinks
- OGNL 表达式求值
- 结果渲染链中的动态表达式
- 后端 SQL/命令/文件 API 同上

### Sanitizers
- 参数拦截器白名单
- OGNL 访问限制策略（版本相关）

## Spring Security / Shiro 权限线索

### Spring Security
- `SecurityFilterChain`, `HttpSecurity.authorizeHttpRequests`
- `@PreAuthorize/@PostAuthorize`, `@Secured`
- 自定义 `OncePerRequestFilter`

### Shiro
- `shiro.ini`, `ShiroFilterFactoryBean` URL 规则
- `@RequiresRoles/@RequiresPermissions`
- 自定义 Realm 鉴权逻辑

> 规则：若路由无显式鉴权且可触达高危 Sink，优先进入 P0 候选池。
