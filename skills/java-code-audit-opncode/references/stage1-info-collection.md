# 阶段1：信息收集指令（可执行）

## 目标
建立“路由-鉴权-依赖-敏感操作”全景资产，为后续分析提供索引。

## 1. 路由全量提取

### Spring Boot/MVC
- 扫描注解：`@RequestMapping`, `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`。
- 合并类级与方法级路径，标准化 HTTP 方法。
- 记录参数来源：query/path/header/body/multipart。

### Struts2
- 扫描 `struts.xml`、注解 action 映射、Convention 插件规则。

### 输出字段
- `route_id`, `method`, `path`, `controller/action`, `params`, `produces/consumes`。

## 2. 鉴权逻辑识别
- 提取框架配置：Spring Security、Shiro、拦截器链。
- 识别注解鉴权：`@PreAuthorize`, `@Secured`, `@RequiresRoles` 等。
- 标注匿名访问规则（`permitAll`, `anon`）与默认策略。

### 输出字段
- `auth_required`(yes/no/unknown), `auth_mechanism`, `role_expr`, `bypass_risk`。

## 3. 第三方组件漏洞扫描
- Maven: `pom.xml` + `dependency:tree`。
- Gradle: `build.gradle` + `dependencies`。
- 比对已知漏洞数据库（NVD/GHSA/厂商公告）。
- 标记高危依赖：反序列化、表达式引擎、文件解析器、HTTP 客户端。

### 输出字段
- `group:artifact:version`, `cve`, `cvss`, `reachable`(yes/no), `upgrade_path`。

## 4. 敏感 Sink 初筛
- 全仓扫描高危 API 调用点（SQL/Exec/URL/XML/File/Template）。
- 建立 `sink_index`：文件、方法、行号、调用上下文。

## 5. 交付物
- `routes_inventory.json`
- `auth_matrix.json`
- `dependency_risk.csv`
- `sink_index.json`
