# AI Cognitive Mentor

> 基于《思维导师》文档构建的 Anthropic Agent Skills 技能集合，提供元认知协调与结构化思维工具，帮助 AI 在解决复杂问题时遵循"先定义问题，再匹配工具，最后执行推理"的协议。

- **版本**：v1.0.0
- **协议**：Anthropic Agent Skills (SKILL.md 规范)
- **许可**：MIT
- **来源**：基于 [思维导师.md](file:///workspace/思维导师.md) 原始文档拆分重构

---

## 目录

- [Quickstart](#quickstart)
- [技能结构树](#技能结构树)
- [技能清单](#技能清单)
- [使用方式](#使用方式)
- [版本信息](#版本信息)
- [免责条款](#免责条款)

---

## Quickstart

### 1. 安装

将 `ai-cognitive-mentor` 目录整体放入你的 Agent Skills 加载路径：

```bash
# Claude Code / Claude Desktop
cp -r ai-cognitive-mentor ~/.claude/skills/

# 或放入项目级目录
cp -r ai-cognitive-mentor ./.claude/skills/
```

### 2. 最小可用示例

安装后，直接向 AI 提出一个复杂问题即可触发核心调度器：

```
用户：我希望借助 AI 大模型的能力提升购物中心的管理效率，
     让原本没有经验的团队也能快速上手。
```

AI 会自动进入 Step 0 问题定义流程：

```
【问题陈述显性化】
- 表层：用AI提升购物中心管理效率，赋能无经验团队
- 深层：建立一套"低门槛、可复制"的AI辅助管理方法论...
- 隐藏假设：①AI可以直接"教"人管理；②效率提升主要来自知识获取...

【问题定义摘要】
本次对话的核心任务是：___。

请确认这一定义，或选择以下操作：
- 输入 "确认" → 进入 Step 1-5 工具适配与执行
- 输入 "调整：[具体修改]" → 返回对应子步骤修正
- 输入 "简化" → 缩小范围，减少子问题
...
```

### 3. 用户指令速查

在流程的任何阶段，你可以用这些指令控制走向：

| 指令 | 效果 |
|------|------|
| `确认` | 认可当前方案，进入下一阶段 |
| `调整：[具体]` | 修改某个子问题或工具选择 |
| `简化` | 减少子问题，用更轻量工具 |
| `深入` | 增加粒度，启用重工具 |
| `深度分析` | 从快速模式切换到完整 5 步法 |
| `重拆` | 回到 Step 0 重新识别问题本质 |
| `展示推理` | 展示当前工具的内部推理链 |
| `继续` | 在执行暂停后恢复 |

### 4. 只用单个思维工具

如果你不需要完整流程，只想调用某个思维工具，直接在提问中点名即可。例如：

```
用户：请用第一性原理分析为什么传统车企转型电动化这么难。
用户：用费曼技巧给我解释什么是量子纠缠。
用户：用第二序效应分析提高最低工资的影响。
```

对应的 Skill 会独立触发，不需要经过 Step 0-5 完整流程。

---

## 技能结构树

```
ai-cognitive-mentor/
│
├── README.md                                      ← 本文件
│
├── cognitive-tool-orchestrator/                   ← 核心调度器
│   ├── SKILL.md                                      Step 0-5 完整元认知流程
│   ├── references/
│   │   └── tool-matching-matrix.md                    工具匹配矩阵
│   └── assets/
│       └── example-session.md                         购物中心 AI 赋能完整示例
│
├── first-principles-thinking/                     ← 第一性原理
│   └── SKILL.md
│
├── systems-thinking/                              ← 系统思维
│   └── SKILL.md
│
├── chain-of-thought/                              ← 链式思考 + 显性推理
│   └── SKILL.md
│
├── socratic-inversion/                            ← 苏格拉底式质疑 + 反转思维
│   └── SKILL.md
│
├── tacit-knowledge/                               ← 默会知识
│   └── SKILL.md
│
├── multi-dimensional-analysis/                    ← 多维度 / 跨学科分析
│   └── SKILL.md
│
├── second-order-effects/                          ← 第二序效应
│   └── SKILL.md
│
├── feynman-technique/                             ← 费曼技巧
│   └── SKILL.md
│
├── mental-models/                                 ← 心智模型
│   └── SKILL.md
│
└── structured-output/                             ← 结构化输出
    └── SKILL.md
```

---

## 技能清单

### 核心调度器

| 技能 | 作用 | 触发条件 |
|------|------|---------|
| [cognitive-tool-orchestrator](cognitive-tool-orchestrator/SKILL.md) | 执行 Step 0-5 完整流程：问题定义 → 本质识别 → 结构拆解 → 工具匹配 → 自动执行 → 目标验证 | 用户提出复杂、模糊或多维度的问题，需要结构化思考 |

### 思维工具（可独立调用，也可被调度器调用）

| 技能 | 作用 | 触发条件 |
|------|------|---------|
| [first-principles-thinking](first-principles-thinking/SKILL.md) | 把问题分解为基本真理，从头重建 | 创新、根因分析、打破惯例 |
| [systems-thinking](systems-thinking/SKILL.md) | 识别反馈循环、涌现属性、杠杆点 | 组织/系统/生态问题、复杂故障 |
| [chain-of-thought](chain-of-thought/SKILL.md) | 一步步展示推理链，支持思维树和自洽性 | 精确推导、复杂决策、代码调试 |
| [socratic-inversion](socratic-inversion/SKILL.md) | 连续提问挑战假设 + 反向思考打破盲区 | 决策检验、风险评估、认知盲区挖掘 |
| [tacit-knowledge](tacit-knowledge/SKILL.md) | 挖掘专家隐性经验、直觉判断和情境智慧 | 实操咨询、技能传承、行业潜规则 |
| [multi-dimensional-analysis](multi-dimensional-analysis/SKILL.md) | 从技术/经济/心理/社会/伦理等维度分析 | 战略决策、社会议题、产品定位 |
| [second-order-effects](second-order-effects/SKILL.md) | 分析后果的后果（二阶、三阶连锁反应） | 政策评估、投资决策、长远影响 |
| [feynman-technique](feynman-technique/SKILL.md) | 用最简单的语言解释复杂概念 | 学习新概念、向非专业人士解释 |
| [mental-models](mental-models/SKILL.md) | 调用 30+ 经典心智模型（机会成本、复利、反脆弱等） | 任何需要结构化思考的决策和分析 |
| [structured-output](structured-output/SKILL.md) | 统一输出格式：核心结论 + 推理链 + 风险 + 行动步骤 | 最终交付、报告、行动指南 |

### 工具匹配速查

| 子问题特征 | 首选工具 | 辅助工具 |
|-----------|---------|---------|
| 需要打破惯例/类比 | first-principles-thinking | socratic-inversion |
| 涉及多变量互动 | systems-thinking | second-order-effects |
| 需要严密逻辑推导 | chain-of-thought | structured-output |
| 需要挑战假设 | socratic-inversion | second-order-effects |
| 需要实操经验 | tacit-knowledge | mental-models |
| 需要跨学科视角 | multi-dimensional-analysis | mental-models |
| 需要长远影响评估 | second-order-effects | systems-thinking |
| 需要向他人解释 | feynman-technique | structured-output |
| 需要快速决策框架 | mental-models | socratic-inversion |
| 需要最终可交付成果 | structured-output | feynman-technique |

完整的匹配矩阵见 [tool-matching-matrix.md](cognitive-tool-orchestrator/references/tool-matching-matrix.md)。

---

## 使用方式

### 方式一：完整流程模式（推荐用于复杂问题）

直接提出问题，`cognitive-tool-orchestrator` 会自动触发，引导你走完 Step 0-5：

```
Step 0: 问题定义与目标界定（强制前置）
  ├── 0.1 问题陈述显性化
  ├── 0.2 目标层次拆解
  ├── 0.3 问题性质判定
  ├── 0.4 问题重构与边界划定
  └── 0.5 目标偏差检验
      ↓ 用户确认
Step 1: 问题本质识别
Step 2: 问题结构拆解（MECE）
Step 3: 工具适配方案
      ↓ 用户确认
Step 4: 方案自动执行
Step 5: 目标验证与交付
```

### 方式二：快速模式（用于简单问题）

当问题明确属于"是什么"型且范围狭窄时，AI 会自动切换到快速模式，直接给出答案。如需深度分析，回复 `深度分析` 即可。

### 方式三：单工具调用（用于特定需求）

直接点名要用的思维工具，跳过完整流程。适合你已经知道需要哪种思维工具的场景。

### 渐进使用策略

| 阶段 | 建议 |
|------|------|
| **初期** | 要求 AI 严格执行 Step 0-5，建立协作默契 |
| **熟练后** | 允许 AI 自动判断"快速模式"或"完整模式" |
| **深度工作时** | 始终使用完整模式，防止目标漂移 |

---

## 版本信息

| 项目 | 值 |
|------|-----|
| 技能集版本 | v1.0.0 |
| 规范兼容 | Anthropic Agent Skills (SKILL.md) |
| 许可证 | MIT |
| 技能数量 | 11 个（1 个核心调度器 + 10 个思维工具） |
| 原始文档 | [思维导师.md](file:///workspace/思维导师.md) v1.0 |

### 各技能版本

| 技能 | 版本 |
|------|------|
| cognitive-tool-orchestrator | 1.0.0 |
| first-principles-thinking | 1.0.0 |
| systems-thinking | 1.0.0 |
| chain-of-thought | 1.0.0 |
| socratic-inversion | 1.0.0 |
| tacit-knowledge | 1.0.0 |
| multi-dimensional-analysis | 1.0.0 |
| second-order-effects | 1.0.0 |
| feynman-technique | 1.0.0 |
| mental-models | 1.0.0 |
| structured-output | 1.0.0 |

### 变更记录

- **v1.0.0** (2026-06-28)：初始版本。基于《思维导师》文档拆分为 11 个独立 Skill，遵循 Anthropic Agent Skills 规范。

---

## 免责条款

### 1. 输出性质

本技能集合提供的所有分析、建议和输出**仅供参考**，不构成任何形式的专业建议（包括但不限于法律、医疗、财务、投资、工程建议）。AI 生成的内容可能存在错误、偏见或不适用的情况。在做出任何重要决策前，请咨询具备相应资质的专业人士。

### 2. 准确性不保证

尽管本技能集合旨在提升 AI 推理的结构性和严谨性，但**不保证**输出的准确性、完整性或时效性。思维工具是辅助思考的框架，不能替代事实核查和领域专业知识。

### 3. 使用风险

使用者需自行承担使用本技能集合的全部风险。作者和贡献者不对因使用或无法使用本技能集合而导致的任何直接或间接损失负责，包括但不限于业务损失、数据丢失或利润损失。

### 4. 知识产权

本技能集合基于 MIT 许可证发布。原始文档《思维导师》的版权归原作者所有。本技能集合中的工具定义、执行流程和输出格式为基于原始文档的再创作。

### 5. 适用性

本技能集合并非为特定行业或场景定制。在不同的应用场景中，使用者应自行判断其适用性，并根据实际情况进行调整。

### 6. 第三方依赖

本技能集合遵循 Anthropic Agent Skills 规范，其正常运行依赖于兼容的 AI Agent 平台（如 Claude Code、Claude Desktop 等）。作者不保证在所有平台上的兼容性和一致性。

### 7. 反馈与改进

如发现问题或有改进建议，欢迎通过 [GitHub Issues](https://github.com/shawnatgithub/skills/issues) 反馈。

---

> **核心理念**：80% 的推理低效，根源不是工具选错，而是问题本身没有被正确界定。在思考如何解题之前，先确认题目本身是否成立、是否完整、是否属于当前这张考卷。
