# tasks.json Schema 参考

`.swarm/tasks.json` 是 ai-tmux-swarm 执行引擎的任务清单，由 swarm-planner 在 Phase 4 生成。

## 完整结构

```json
{
  "version": 1,
  "defaults": {
    "base_branch": "main",
    "engine": "codex",
    "model": "gpt-5.3-codex",
    "reasoning": "high",
    "max_restarts": 3
  },
  "tasks": [
    {
      "id": "data-model",
      "description": "定义数据模型和数据库迁移",
      "prompt_file": "prompts/data-model.md",
      "depends_on": []
    },
    {
      "id": "api-endpoint",
      "description": "实现 API 端点和请求验证",
      "prompt_file": "prompts/api-endpoint.md",
      "depends_on": ["data-model"]
    },
    {
      "id": "business-logic",
      "description": "实现核心业务逻辑",
      "prompt_file": "prompts/business-logic.md",
      "depends_on": ["data-model"]
    },
    {
      "id": "integration",
      "description": "集成测试和接口联调",
      "prompt_file": "prompts/integration.md",
      "depends_on": ["api-endpoint", "business-logic"]
    }
  ]
}
```

## 字段说明

### 顶层字段

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `version` | number | 是 | Schema 版本号，当前固定为 `1` |
| `defaults` | object | 是 | 任务的默认配置，可被单个 task 覆盖 |
| `tasks` | array | 是 | 任务列表，至少包含 1 个任务 |

### defaults 对象

| 字段 | 类型 | 必填 | 默认值 | 说明 |
|---|---|---|---|---|
| `base_branch` | string | 是 | `"main"` | 基准分支，worktree 从此分支检出 |
| `engine` | string | 是 | `"codex"` | 执行引擎：`codex` 或 `claude` |
| `model` | string | 是 | `"gpt-5.3-codex"` | 使用的模型 |
| `reasoning` | string | 否 | `"high"` | 推理等级（engine 支持时生效） |
| `max_restarts` | number | 否 | `3` | 最大重试次数 |

### task 对象

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `id` | string | 是 | 任务唯一标识，slug 格式（小写字母、数字、连字符） |
| `description` | string | 是 | 任务描述，简明扼要 |
| `prompt_file` | string | 是 | prompt 文件的相对路径（相对于 `.swarm/`） |
| `depends_on` | array | 否 | 依赖的 task id 列表，默认 `[]` |
| `engine` | string | 否 | 覆盖 defaults 的执行引擎 |
| `model` | string | 否 | 覆盖 defaults 的模型 |
| `reasoning` | string | 否 | 覆盖 defaults 的推理等级 |
| `branch` | string | 否 | 自定义分支名（默认自动生成） |
| `max_restarts` | number | 否 | 覆盖 defaults 的最大重试次数 |

## 约束规则

### id 约束
- 必须唯一
- 必须是 slug 格式：`/^[a-z0-9]+(-[a-z0-9]+)*$/`
- slug 化后仍须唯一（即 `my_task` 和 `my-task` 视为冲突）

### prompt_file 约束
- 路径相对于 `.swarm/` 目录
- 文件必须存在，否则 swarm 启动失败
- 建议统一放在 `prompts/` 子目录：`prompts/<task-id>.md`

### depends_on 约束
- 只能引用同一 `tasks` 数组中已定义的 task id
- 依赖图必须是 DAG（有向无环图），不允许循环依赖
- 空数组 `[]` 或省略表示无依赖（可立即执行）

## 从 spec.md 到 tasks.json 的映射

| spec.md 区块 | tasks.json 字段 |
|---|---|
| 任务拆分 → Task ID | `tasks[].id` |
| 任务拆分 → 描述 | `tasks[].description` |
| DAG 依赖图 | `tasks[].depends_on` |
| 任务拆分 → 预估复杂度 | 用于决定是否调整 `max_restarts` |
| 技术决策 → 引擎选型 | `defaults.engine` / `tasks[].engine` |

## 验证命令

```bash
# 1. JSON 格式校验
cat .swarm/tasks.json | python3 -m json.tool > /dev/null && echo "JSON valid"

# 2. 确认所有 prompt 文件存在
jq -r '.tasks[].prompt_file' .swarm/tasks.json | while read f; do
  [ -f ".swarm/$f" ] && echo "OK: $f" || echo "MISSING: $f"
done

# 3. 确认 id 唯一
jq -r '.tasks[].id' .swarm/tasks.json | sort | uniq -d | \
  { read dup && echo "DUPLICATE: $dup" || echo "All IDs unique"; }

# 4. 确认无循环依赖（简易检查）
jq -r '.tasks[] | "\(.id): \(.depends_on // [] | join(", "))"' .swarm/tasks.json
```
