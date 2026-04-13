# quality_report.md 模板

```md
# Java 安全审计报告（quality_report）

## 0. 审计元数据
- 项目名：
- 审计范围：源码 / 二进制（CFR反编译）
- 提交版本/制品哈希：
- 审计日期：
- 审计器版本：java-code-audit-opncode

## 1. 总览
- 发现总数：
- P0：
- P1：
- 主要风险类型：

## 2. 阶段产物汇总
- Phase1: routes_inventory/auth_matrix/dependency_risk/sink_index
- Phase2: priority_queue
- Phase3: 调用链批次结果
- Phase4: 各模块漏洞判定结果

## 3. 漏洞详情
### [VULN-ID]
- 标题：
- 风险级别：P0/P1
- 漏洞类型：
- 影响端点/模块：
- Source：
- Sink：
- Sanitizer 状态：有效/无效/缺失
- 调用链路：
  - A.method -> B.method -> C.sink
- 触发条件（最小）：
- 影响说明：
- 证据（文件:行号）：
- 修复建议：
- 对应知识库条目：
- 置信度：high/medium/low

## 4. 调用链路图
- 使用 mermaid 或文本链路图展示 P0/P1 核心路径。

## 5. 修复建议清单
- 按优先级列出短期修复与长期治理项。

## 6. 残余风险与后续计划
- 未完成验证项：
- 建议复测范围：
```

## 报告编写规则
- 每条漏洞必须绑定至少一个知识库条目。
- 每条结论必须具备“可达性 + 可控性 + 防护有效性”三要素。
- 不写武器化利用脚本，仅提供安全验证级别信息。
