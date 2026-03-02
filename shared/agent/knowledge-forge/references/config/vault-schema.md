# Vault 目录结构规范

## Vault 位置

```
~/Documents/Knowledge Forge/
```

## 目录结构

```
Knowledge Forge/
├── 00-Inbox/                    # Agent 写入的 source notes（信息入口）
├── 10-Projects/                 # 项目专属知识
│   ├── xhs-content/             #   小红书内容存档与复盘
│   └── ai-research/             #   AI 研究项目
├── 20-Decisions/                # 决策记录（重要选择的 why）
├── 30-Playbooks/                # 操作手册（可复用的 how）
├── 40-Atoms/                    # 原子概念笔记（Zettelkasten 知识单元）
├── 50-Maps/                     # Maps of Content（主题导航地图）
├── 60-Briefs/                   # 知识简报
│   ├── daily/                   #   日报
│   └── weekly/                  #   周报
├── 70-Learning/                 # AI 学习笔记（Phase 3）
│   ├── progress/                #   学习进度报告
│   └── notes/                   #   学习产出
├── 80-Review/                   # 知识复习队列（Phase 3）
├── 90-Archive/                  # 归档（过时/低价值内容）
├── Templates/                   # Obsidian 模板
├── _index/                      # 元数据索引（不在 Obsidian 中直接查看）
│   └── processed-urls.json      #   已处理 URL 去重索引
└── _config/                     # Agent 配置
    ├── sources.yaml             #   信息源 + 巡逻配置（Phase 2）
    ├── learning.yaml            #   学习方向配置（Phase 3）
    └── profile.yaml             #   用户兴趣画像（Phase 3）
```

## 各目录职责

### 00-Inbox/ — 信息入口

Agent 执行 `ingest` 时写入的 source notes。每条 source note 对应一个 URL 来源。

**命名规则**: `{platform}-{YYYY-MM-DD}-{slug}.md`

示例:
- `twitter-2026-03-01-mcp-protocol-announcement.md`
- `web-2026-03-01-ai-agent-architecture-patterns.md`
- `github-2026-03-01-anthropic-sdk-python.md`
- `xhs-2026-03-01-ai-tools-review.md`
- `youtube-2026-03-01-rust-async-tutorial.md`

**slug 生成规则**:
- 从标题提取 3-5 个关键词
- 用 kebab-case 连接
- 全小写，去掉标点和特殊字符
- 最长 50 个字符

### 40-Atoms/ — 知识原子

每个文件代表一个独立概念，是知识库的核心资产。

**命名规则**: `{concept-name}.md`（英文 kebab-case）

示例:
- `model-context-protocol.md`
- `zettelkasten-method.md`
- `stepps-transmission-model.md`
- `react-agent-pattern.md`

**为什么用英文命名**:
- 文件名跨平台兼容性好
- `[[wikilink]]` 中英文混排不易出错
- 概念本身往往有通用英文名

### 50-Maps/ — 主题地图（MOC）

Maps of Content，是概念的导航索引。每个 MOC 聚合一个主题下的所有相关 Atom。

示例: `ai-agents-moc.md` 可能包含:
```markdown
# AI Agents

## 核心概念
- [[react-agent-pattern]]
- [[model-context-protocol]]
- [[function-calling]]

## 架构
- [[agent-tool-use]]
- [[agent-memory]]

## 工具
- [[langchain]]
- [[claude-agent-sdk]]
```

**创建时机**: 当某主题的 Atom 数量 ≥ 5 时，建议创建 MOC。

### 60-Briefs/ — 知识简报

Agent 生成的定期知识摘要。

**命名规则**:
- 日报: `daily/{YYYY-MM-DD}.md`
- 周报: `weekly/{YYYY-MM-DD}.md`（日期为周一）

### _index/ — 元数据索引

**processed-urls.json 结构**:

```json
{
  "version": "1.0",
  "urls": {
    "https://twitter.com/anthropic/status/123": {
      "ingested": "2026-03-01",
      "note": "00-Inbox/twitter-2026-03-01-mcp-protocol-announcement.md",
      "atoms": [
        "40-Atoms/model-context-protocol.md"
      ]
    }
  }
}
```

### _config/ — Agent 配置

存放 knowledge-forge 运行时需要的配置文件。详见 `sources-schema.md`。

## 初始化流程

首次使用 knowledge-forge 时自动创建:

```bash
mkdir -p ~/Documents/Knowledge\ Forge/{00-Inbox,10-Projects/{xhs-content,ai-research},20-Decisions,30-Playbooks,40-Atoms,50-Maps,60-Briefs/{daily,weekly},70-Learning/{progress,notes},80-Review,90-Archive,Templates,_index,_config}
```

然后创建:
1. `_index/processed-urls.json` — 空索引
2. `_config/sources.yaml` — 初始主题配置
