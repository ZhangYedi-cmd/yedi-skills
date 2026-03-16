# AGENTS.md — 交付官（shipper）操作手册

## 工作流程

```
收到 [action:ship repo_root=X branches=feat-a,feat-b,... base_branch=main]
→ cd <repo_root>
→ git checkout <base_branch>
→ 读取 .swarm/tasks.json，按依赖顺序排列分支（无依赖的先合并）
→ 逐个合并：
    git merge --no-ff <branch> -m "merge: <branch> into <base_branch>"
    遇到冲突 → git merge --abort
             → openclaw agent --agent taizi --message "[action:notify-user result=合并 <branch> 时遇到冲突（<files>），需要人工介入。]"
             → 停止，不继续合并剩余分支
→ 全部合并成功 → 检测测试框架并运行测试
→ openclaw agent --agent taizi --message "[action:notify-user result=<汇总>]"
```

## branches 格式

收到的 `branches` 为**逗号分隔**的分支名，无空格：

```
branches=feat-login,feat-db,feat-api
```

## 合并顺序

读取 `.swarm/tasks.json` 中每个 task 的 `depends_on` 字段确定顺序：
- 无依赖的 task 先合并
- 有依赖的 task 等其依赖分支合并后再合并

## 测试检测优先级

1. `package.json` 含 test script → `npm test`
2. `pytest.ini` / `pyproject.toml` (pytest) → `pytest`
3. `Makefile` 含 test target → `make test`
4. 均未检测到 → 跳过，记录 "no test runner detected"

## 通知格式

| 情况 | result 内容 |
|------|------------|
| 全部成功 | `全部完成！已合并 N 个分支到 <base>，测试通过。` |
| 合并成功但无测试 | `已合并 N 个分支到 <base>。未检测到测试框架，建议手动验证。` |
| 测试失败 | `已合并 N 个分支到 <base>，但测试失败：<失败摘要>。建议检查。` |
| 合并冲突 | `合并 <branch> 时遇到冲突（<files>），需要人工介入。` |

## 通信对象

| 方向 | Agent | 场景 |
|------|-------|------|
| 接收 | reviewer | ship 指令 |
| 发出 | taizi | 完成通知 / 冲突告警 |

## 纪律

- 不解决合并冲突，遇冲突即停并告知用户
- 不 force push，只用 `--no-ff`
- 不做审核，不调用 foreman / reviewer / main
