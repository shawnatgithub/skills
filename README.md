# SeanClickin-Skills

> 个人 AI Agent 技能分享仓库，提供认知思维工具与 Git 版本控制工作流。

English | [中文](./README.zh.md)

## 简介

本仓库包含一系列 [Anthropic Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills) 规范的技能，旨在提升 AI Agent 在复杂问题求解和开发工作流中的表现。

## 前置条件

- Bash shell（所有脚本为纯 Bash，无额外运行时依赖）
- Git（用于 `ai-git-version-control` 技能）
- `gh` CLI（可选，用于 PR 创建工作流）

## 安装

### 方式一：克隆仓库

```bash
git clone https://github.com/your-username/SeanClickin-Skills.git ~/.trae/skills/seanclickin-skills
```

### 方式二：项目级安装

将需要的技能目录复制或软链接到项目的 `.claude/skills/` 下：

```bash
# 安装单个技能
cp -r skills/ai-git-version-control .claude/skills/

# 或使用软链接
ln -s /path/to/SeanClickin-Skills/skills/ai-git-version-control .claude/skills/ai-git-version-control
```

### 方式三：Claude Plugin

通过 marketplace.json 注册的插件方式安装（适用于支持 Claude Plugin 的环境）。

## 技能清单

### 认知思维工具（ai-cognitive-mentor）

基于《思维导师》文档构建的元认知协调与结构化思维工具集，遵循"先定义问题，再匹配工具，最后执行推理"的协议。

| 技能 | 作用 | 触发条件 |
|------|------|---------|
| [cognitive-tool-orchestrator](skills/ai-cognitive-mentor/cognitive-tool-orchestrator/SKILL.md) | Step 0-5 完整元认知流程 | 复杂、模糊或多维度问题 |
| [first-principles-thinking](skills/ai-cognitive-mentor/first-principles-thinking/SKILL.md) | 第一性原理分析 | 创新、根因分析 |
| [systems-thinking](skills/ai-cognitive-mentor/systems-thinking/SKILL.md) | 系统思维 | 组织/系统/生态问题 |
| [chain-of-thought](skills/ai-cognitive-mentor/chain-of-thought/SKILL.md) | 链式思考 | 精确推导、复杂决策 |
| [socratic-inversion](skills/ai-cognitive-mentor/socratic-inversion/SKILL.md) | 苏格拉底式质疑 | 决策检验、风险评估 |
| [tacit-knowledge](skills/ai-cognitive-mentor/tacit-knowledge/SKILL.md) | 默会知识挖掘 | 实操咨询、技能传承 |
| [multi-dimensional-analysis](skills/ai-cognitive-mentor/multi-dimensional-analysis/SKILL.md) | 多维度分析 | 战略决策、社会议题 |
| [second-order-effects](skills/ai-cognitive-mentor/second-order-effects/SKILL.md) | 第二序效应 | 政策评估、长远影响 |
| [feynman-technique](skills/ai-cognitive-mentor/feynman-technique/SKILL.md) | 费曼技巧 | 学习新概念、解释复杂内容 |
| [mental-models](skills/ai-cognitive-mentor/mental-models/SKILL.md) | 心智模型 | 结构化思考决策 |
| [structured-output](skills/ai-cognitive-mentor/structured-output/SKILL.md) | 结构化输出 | 最终交付、报告 |

### 开发工作流工具

| 技能 | 作用 | 触发条件 |
|------|------|---------|
| [ai-git-version-control](skills/ai-git-version-control/SKILL.md) | Agent-Aware Git 版本控制 | AI Agent 提交代码、创建分支、管理 PR |

## 技能结构

```
SeanClickin-Skills/
├── .claude-plugin/
│   └── marketplace.json              # 插件配置
├── skills/
│   ├── ai-cognitive-mentor/         # 认知思维工具集（11个技能）
│   │   ├── cognitive-tool-orchestrator/
│   │   ├── first-principles-thinking/
│   │   ├── systems-thinking/
│   │   ├── chain-of-thought/
│   │   ├── socratic-inversion/
│   │   ├── tacit-knowledge/
│   │   ├── multi-dimensional-analysis/
│   │   ├── second-order-effects/
│   │   ├── feynman-technique/
│   │   ├── mental-models/
│   │   ├── structured-output/
│   │   └── README.md
│   └── ai-git-version-control/      # Git 版本管理技能
│       ├── SKILL.md
│       ├── README.md
│       ├── scripts/
│       ├── references/
│       └── assets/
├── docs/
│   └── creating-skills.md           # 技能创建指南
├── CLAUDE.md                        # AI 协作指导
├── CHANGELOG.md                     # 变更记录
└── README.md                        # 本文件
```

## 使用方式

### 完整流程模式（复杂问题）

直接提出问题，`cognitive-tool-orchestrator` 会自动触发，引导完成 Step 0-5 元认知流程。

### 单工具模式（特定需求）

在提问中点名要用的思维工具，跳过完整流程：

```
请用第一性原理分析为什么传统车企转型电动化这么难。
用费曼技巧给我解释什么是量子纠缠。
```

### Git 工作流

```bash
# 生成 Agent-Aware 提交信息
MSG=$(skills/ai-git-version-control/scripts/generate-agent-commit.sh \
  feat auth "implement JWT refresh token rotation")

git commit -m "$MSG"
```

## 版本信息

| 项目 | 值 |
|------|-----|
| 技能集版本 | v0.1.0 |
| 规范兼容 | Anthropic Agent Skills (SKILL.md) |
| 许可证 | MIT |
| 技能数量 | 12 个（11 个思维工具 + 1 个 Git 工作流） |

## 贡献

欢迎贡献！创建新技能请参考 [docs/creating-skills.md](docs/creating-skills.md)。

## 许可证

MIT
