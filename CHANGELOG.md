# Changelog

本文件记录 SeanClickin-Skills 仓库的所有变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
版本号遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

## [Unreleased]

## [0.1.0] - 2026-06-28

### Added
- 初始化仓库架构，参考 baoyu-skills 最佳实践
- 创建 `.claude-plugin/marketplace.json` 插件配置
- 创建 `CLAUDE.md` 项目级 AI 协作指导
- 创建 `docs/creating-skills.md` 技能创建指南
- 整合 `ai-cognitive-mentor` 认知思维工具集（11个技能）
  - cognitive-tool-orchestrator（核心调度器）
  - first-principles-thinking
  - systems-thinking
  - chain-of-thought
  - socratic-inversion
  - tacit-knowledge
  - multi-dimensional-analysis
  - second-order-effects
  - feynman-technique
  - mental-models
  - structured-output
- 整合 `ai-git-version-control` Git 版本管理技能
  - 11 个 Bash 脚本（提交、分支、PR、历史整理等）
  - 4 个参考文档（提交规范、分支管理、PR管理、CI/CD集成）
  - 2 个模板文件（PR模板、AGENT.md模板）

### Changed
- 将 `ai-git-version-control` 从 `Ai-Git-Management/output/` 提取到 `skills/` 下
- 将 `ai-cognitive-mentor` 移入统一的 `skills/` 目录
- 删除多余的 `Ai-Git-Management/` 目录（含 source and reference、中间产物等）
