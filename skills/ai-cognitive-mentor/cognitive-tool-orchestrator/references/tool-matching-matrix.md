# 工具匹配矩阵（Tool Matching Matrix）

为子问题匹配思维工具的核心参考表。

## 核心匹配矩阵

| 子问题特征 | 首选工具 | 辅助工具 | 避免工具 |
|-----------|---------|---------|---------|
| 需要打破惯例/类比 | first-principles-thinking | socratic-inversion | tacit-knowledge（初期） |
| 涉及多变量互动 | systems-thinking | second-order-effects | chain-of-thought（单独） |
| 需要严密逻辑推导 | chain-of-thought | structured-output | multi-dimensional-analysis |
| 需要挑战假设 | socratic-inversion | second-order-effects | structured-output（初期） |
| 需要实操经验 | tacit-knowledge | mental-models | first-principles-thinking（单独） |
| 需要跨学科视角 | multi-dimensional-analysis | mental-models | chain-of-thought（单独） |
| 需要长远影响评估 | second-order-effects | systems-thinking | feynman-technique |
| 需要向他人解释 | feynman-technique | structured-output | systems-thinking |
| 需要快速决策框架 | mental-models | socratic-inversion | chain-of-thought（过于复杂） |
| 需要最终可交付成果 | structured-output | feynman-technique | socratic-inversion（单独） |

## 问题类型与工具映射

### "是什么"型 (What)
- **首选**：feynman-technique + structured-output
- **适用场景**：定义概念、解释原理、描述现象
- **组合逻辑**：先用费曼技巧简化理解，再用结构化输出整理

### "为什么"型 (Why)
- **首选**：first-principles-thinking + systems-thinking + socratic-inversion
- **适用场景**：根因分析、归因溯源、现象解释
- **组合逻辑**：先用第一性原理拆解基本要素，再用系统思维看互动关系，最后用苏格拉底式质疑挑战假设

### "怎么做"型 (How)
- **首选**：chain-of-thought + tacit-knowledge + structured-output
- **适用场景**：方案设计、流程制定、步骤规划
- **组合逻辑**：用链式思考逐步推导，结合默会知识补充实操细节，最后结构化输出

### "好不好"型 (Should)
- **首选**：socratic-inversion + second-order-effects + multi-dimensional-analysis
- **适用场景**：决策评估、方案选择、价值判断
- **组合逻辑**：用反转思维检验风险，用第二序效应看长远影响，用多维度分析全面评估

### "如果…会怎样"型 (What if)
- **首选**：systems-thinking + second-order-effects + chain-of-thought
- **适用场景**：情景推演、预测分析、假设检验
- **组合逻辑**：用系统思维识别变量关系，用第二序效应推演连锁反应，用链式思考逐步验证

### "创新/突破"型 (Innovate)
- **首选**：first-principles-thinking + mental-models + multi-dimensional-analysis
- **适用场景**：新方案设计、突破瓶颈、跨界迁移
- **组合逻辑**：用第一性原理打破框架，用心智模型提供结构，用多维度跨界启发

### "验证/检验"型 (Validate)
- **首选**：socratic-inversion + structured-output + chain-of-thought
- **适用场景**：逻辑检查、方案审核、错误排查
- **组合逻辑**：用苏格拉底式质疑找漏洞，用反转思维找反例，用自洽性验证一致性

## 工具组合原则

1. **不超过 3 个工具**：每个子问题最多匹配 3 个工具，避免过度复杂
2. **有主有辅**：明确 1 个首选工具，其余为辅助
3. **形成闭环**：工具组合应覆盖"分析-验证-输出"完整链条
4. **避免冗余**：功能高度重叠的工具不同时使用（如 feynman-technique 和 structured-output 都用于输出，但前者重解释后者重结构）
5. **渐进使用**：先用轻量工具，不够再加重工具
