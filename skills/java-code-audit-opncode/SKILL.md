---
name: java-code-audit-opncode
description: Full-chain Java security code audit skill for source code and compiled artifacts. Use when an agent must perform deep vulnerability analysis (SQLi, XXE, deserialization, SSRF, SSTI, XSS, file upload/read, command injection), map framework-specific Source/Sink/Sanitizer patterns (Spring Boot/MVC, MyBatis, Struts2), decompile JAR/WAR/class files via CFR, score risks (P0/P1), and generate structured quality_report.md outputs with exploit paths and fixes.
---

# Java Code Audit (opncode)

## Overview

Execute a 5-phase Java security audit workflow and output a reproducible report. Load only the relevant `references/*.md` files for the requested framework and vulnerability scope.

## Quick Start

1. Confirm audit target type:
   - Source project: Java/Kotlin + Maven/Gradle.
   - Binary-only target: JAR/WAR/class (decompile first).
2. Build audit plan with five phases:
   - Phase 1 信息收集
   - Phase 2 交叉分析与风险定级
   - Phase 3 调用链追踪
   - Phase 4 漏洞深度分析
   - Phase 5 汇总报告
3. Select vulnerability modules in priority order:
   - `deserialization`, `rce-command-injection`, `ssrf`, `sqli`, `xxe`, `file-io-upload`, `ssti`, `xss`
4. Generate final `quality_report.md` using the template in `references/stage5-report-template.md`.

## Binary-Only Handling (CFR)

If only compiled code is available, decompile before phase 1:

- Use `scripts/decompile_with_cfr.sh`.
- Extract route definitions, security config, and sink callsites from decompiled output.
- Mark uncertain types as `inference` and prioritize manual confirmation.

## Phase Workflow

### Phase 1: 信息收集

Follow `references/stage1-info-collection.md`:

- Enumerate all routes and HTTP methods.
- Identify authn/authz logic (Spring Security/Shiro/interceptors/AOP).
- Inventory third-party dependencies and CVEs.
- Build endpoint-to-controller mapping and trust-boundary notes.

### Phase 2: 交叉分析

Follow `references/stage2-cross-analysis.md`:

- Evaluate controllability (input source), privilege requirements, and exploit preconditions.
- Assign severity:
  - `P0`: unauthenticated or low-bar exploit with high impact (RCE/data exfil/admin takeover).
  - `P1`: requires auth/high complexity/partial impact but still exploitable.
- Output prioritized queue for phase 3.

### Phase 3: 调用链追踪

Follow `references/stage3-callchain.md`:

- Start from high-risk sources, track taint to sinks.
- Use static call graph + data-flow constraints.
- Split long paths into batch tasks and merge findings.
- Preserve path evidence (method signatures, files, lines, conditions).

### Phase 4: 深度分析（按漏洞模块）

Follow `references/stage4-rules.md` and module knowledge in `references/knowledge-base.md`:

- Apply per-vulnerability match templates.
- Verify prerequisite conditions (whether effective sanitizer/security plugin exists).
- Apply false-positive exclusion rules.
- Produce exploitability conclusion and fix strategy.

### Phase 5: 汇总报告

Follow `references/stage5-report-template.md`:

- Consolidate risk table, detailed findings, and call chains.
- Link every finding to a knowledge-base entry and remediation guidance.
- Output reproducible verification commands and residual risk.

## Framework Mapping Usage

Load `references/framework-source-sink-sanitizer.md` whenever the target uses Spring Boot/MVC, MyBatis, or Struts2. Reuse its Source/Sink/Sanitizer matrix before judging exploitability.

## Operating Rules

- Prioritize primary evidence from code and dependency manifests over assumptions.
- Mark every uncertain conclusion with `confidence: low|medium|high`.
- Avoid claiming vulnerability when sanitizer is present and context-appropriate.
- Prefer concrete PoC-safe payload shapes over weaponized exploit steps.
- Keep report language concise, deterministic, and reproducible.
