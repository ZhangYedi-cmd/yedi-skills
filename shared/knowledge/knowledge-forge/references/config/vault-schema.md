# Vault 目录结构规范

## Vault 位置

```
~/Documents/Knowledge Forge/
```

## 目录结构

```
Knowledge Forge/
├── 00-Inbox/                    # Agent 写入的 source notes（信息入口）
├── 40-Atoms/                    # 原子概念笔记（知识卡片）
├── 60-Briefs/                   # 知识简报
│   ├── daily/                   #   日报
│   └── weekly/                  #   周报
├── _index/                      # 元数据索引（不在 Obsidian 中直接查看）
│   └── processed-urls.json      #   已处理 URL 去重索引
└── _config/                     # Agent 配置（当前空置，留存备用）
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

**命名规则**: 优先使用能直观表意的名称，允许中英混合

示例:
- `model-context-protocol.md`
- `zettelkasten-method.md`
- `Context-Engineering-上下文工程.md`
- `react-agent-pattern.md`

**命名原则**:
- 直观表意优先，看文件名能猜出概念内容
- 允许中英混合（如涉及中文特有概念时）
- 避免过度规范化（如不必强制全 kebab-case）

### 60-Briefs/ — 知识简报

Agent 生成的定期知识摘要。

**命名规则**:
- 日报: `daily/{YYYY-MM-DD}.md`
- 周报: `weekly/{YYYY-MM-DD}.md`（日期为周一）
- 主题简报: `daily/{YYYY-MM-DD}-{topic}.md`

### _index/ — 元数据索引

**processed-urls.json 结构**（扁平数组，新条目追加到末尾）:

```json
{
  "version": "1.0",
  "urls": [
    {
      "url": "https://www.anthropic.com/news/model-context-protocol",
      "platform": "web",
      "captured_at": "2026-03-01",
      "source_note": "00-Inbox/web-2026-03-01-mcp-protocol-announcement.md",
      "atoms": [
        "40-Atoms/model-context-protocol.md",
        "40-Atoms/json-rpc.md"
      ]
    }
  ]
}
```

> 注：历史批次数据不迁移，仅新条目遵循此 schema。

### _config/ — Agent 配置

当前空置，留存占位以备未来扩展（如 patrol 巡逻配置等）。

## 初始化流程

首次使用 knowledge-forge 时自动创建:

```bash
mkdir -p ~/Documents/Knowledge\ Forge/{00-Inbox,40-Atoms,60-Briefs/{daily,weekly},_index,_config}
```

然后创建:
1. `_index/processed-urls.json` — 空索引（`{"version": "1.0", "urls": []}`）
