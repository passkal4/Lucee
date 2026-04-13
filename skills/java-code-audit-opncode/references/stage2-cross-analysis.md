# 阶段2：交叉分析与风险定级（P0/P1）

## 输入
- `routes_inventory.json`
- `auth_matrix.json`
- `sink_index.json`
- Source/Sink/Sanitizer 映射

## 判定维度
1. 鉴权状态
   - 未鉴权 / 可匿名访问 -> 风险上升
2. 输入可控性
   - 直接来自 HTTP 且无约束 -> 风险上升
3. Sink 危险等级
   - RCE/反序列化/SSRF 内网访问 > SQLi > XSS
4. Sanitizer 有效性
   - 无或弱过滤 -> 风险上升
5. 业务影响
   - 管理端、核心数据、跨租户 -> 风险上升

## 风险规则

### P0（最高优先）
满足任一：
- 未鉴权 + 可控输入 + 高危 Sink（exec/deserialize/xxe-ssrf/file-write）
- 已鉴权但低权限可达 + 可直接造成 RCE/敏感数据批量泄露
- 存在已知高危组件漏洞且调用可达

### P1（高优先）
满足任一：
- 需中高权限或复杂条件触发，但具备实际可利用性
- 输入受部分限制，但可绕过进入危险 Sink
- 影响范围局部或需要链式利用

## 输出
- `priority_queue.json`：按 P0 -> P1 排序
- 每条记录包含：`route`, `source`, `sink`, `auth`, `sanitizer`, `risk_level`, `reason`
