# MEMORY.md

## 2026-03-29

### Task: poiacct-migrate
- Status: in-progress (Phase 1)
- Project path: /Users/yedizhang/meituan/msfe-bizaccount
- Branch: feat/poiacct-migrate
- Session: poiacct-phase1 (tmux)
- Backend: tmux
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/poiacct-migrate
- Task: 迁移 dailyops/poiacct → bizaccount/poiacct-pc，技术栈升级
- Phase 1: API层 + Store层 + 入口/路由/容器 + 占位页面
- Phase 2: 4个页面完整视图实现（pending）
- 技术方案 KM: https://km.sankuai.com/collabpage/2753512342
- 网关ID: com.sankuai.meishi.fe.ecommanage20231108202446642, ...20231108202643985, ...20231108202747375, ...20231108202849856, com.sankuai.meishi.fe.ecommanage20241114193425819, meshi20240718143529211
- 决策: 路由用旧前缀 /activity/poiacct, 网关转发已确认能通

### Task: todo-backend
- Status: completed
- Project path: /Users/yedizhang/todo-app
- Branch: feat/todo-backend
- Session: todo-backend
- Backend: ACPX
- Agent: Codex
- Worktree: /Users/yedizhang/worktrees/todo-backend
- Commit: 0dcf725 (`feat: implement todo backend`)
- Verification:
  - watchdog callback: completed ✅
  - Independent: build ✅, health ✅, 4 seed tags ✅, stats ✅

### Task: todo-frontend
- Status: completed
- Project path: /Users/yedizhang/todo-app
- Branch: feat/todo-frontend
- Session: todo-frontend
- Backend: ACPX
- Agent: Codex
- Worktree: /Users/yedizhang/worktrees/todo-frontend
- Commit: 1633862 (`feat: implement todo frontend`)
- Verification:
  - watchdog callback: completed ✅
  - Independent: `npm run build` ✅

### Task: acct-backend
- Status: completed
- Project path: /Users/yedizhang/accounting-system
- Branch: feat/acct-backend
- Session: acct-backend
- Backend: ACPX
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/acct-backend
- Commit: 3784d7a (`feat: implement accounting backend with Express + Prisma + SQLite`)
- Verification:
  - watchdog callback: completed, all endpoints verified
  - Independent: `npm run build` ✅, health ✅, categories(12 seed) ✅, summary ✅

### Task: acct-frontend
- Status: completed
- Project path: /Users/yedizhang/accounting-system
- Branch: feat/acct-frontend
- Session: acct-frontend
- Backend: ACPX
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/acct-frontend
- Commit: 7968de4 (`feat: implement accounting frontend with React + Ant Design`)
- Verification:
  - `npm run build` ✅

## 2026-03-28

### Task: sis5-backend
- Status: running
- Project path: /Users/yedizhang/student-info-system-v5
- Branch: feat/sis5-backend
- Session: sis5-backend
- Backend: ACPX
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/sis5-backend
- Watchdog: running (crisp-cedar, interval=30s, 修复版v2)
- Latest Milestone: task dispatched

### Task: sis5-frontend
- Status: pending
- Project path: /Users/yedizhang/student-info-system-v5
- Branch: feat/sis5-frontend
- Session: sis5-frontend (未启动)
- Backend: ACPX
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/sis5-frontend
- Note: 等 sis5-backend watchdog 通知完成后派发

### Task: sis4-backend
- Status: running
- Project path: /Users/yedizhang/student-info-system-v4
- Branch: feat/sis4-backend
- Session: sis4-backend
- Backend: ACPX
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/sis4-backend
- Watchdog: running (wild-lagoon, interval=30s, 修复版)
- Latest Milestone: task dispatched

### Task: sis4-frontend
- Status: pending
- Project path: /Users/yedizhang/student-info-system-v4
- Branch: feat/sis4-frontend
- Session: sis4-frontend (未启动)
- Backend: ACPX
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/sis4-frontend
- Note: 等 sis4-backend 完成后派发

### Task: sis3-backend
- Status: running
- Project path: /Users/yedizhang/student-info-system-v3
- Branch: feat/sis3-backend
- Session: sis3-backend
- Backend: ACPX
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/sis3-backend
- Watchdog: running (kind-comet, interval=30s)
- Latest Milestone: task dispatched

### Task: sis3-frontend
- Status: pending
- Project path: /Users/yedizhang/student-info-system-v3
- Branch: feat/sis3-frontend
- Session: sis3-frontend (未启动)
- Backend: ACPX
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/sis3-frontend
- Note: 等 sis3-backend 完成后派发

### Task: sis2-backend
- Status: completed
- Project path: /Users/yedizhang/student-info-system-v2
- Branch: feat/sis2-backend
- Session: sis2-backend
- Backend: ACPX
- Agent: Codex
- Worktree: /Users/yedizhang/worktrees/sis2-backend
- Commit: 2aabfd6 (`feat: implement sis2 backend server`)
- Verification:
  - `npm run build` 通过
  - `GET /api/health` 返回 ok
  - `GET /api/students` 返回正确分页结构

### Task: sis2-frontend
- Status: completed
- Project path: /Users/yedizhang/student-info-system-v2
- Branch: feat/sis2-frontend
- Session: sis2-frontend
- Backend: ACPX
- Agent: Claude Code
- Worktree: /Users/yedizhang/worktrees/sis2-frontend
- Commit: 871c9fe (`feat: implement student management frontend with React + Ant Design`)
- Verification:
  - `npm run build` 通过

## 2026-03-26

### Task: kdb-pc-profit-copy-opt
- Status: completed
- Project path: /Users/yedizhang/msfe-kdb-finance-settlement
- Branch: feat/kdb-profit-download-copy-opt
- Session: kdb-pc-profit-copy-opt
- Backend: ACPX
- Agent: Claude
- Worktree: /Users/yedizhang/worktrees/kdb-pc-profit-copy-opt
- Commit: 1d27c282 (`feat: optimize profit home download button labels and add tooltips`)
- Verification:
  - Agent callback: completed
  - Changed file: `packages/container/pc/src/pages/profit/views/home/components/list-table/index.tsx`
  - Note: lint step skipped due ACP permission constraints in agent run

### Task: tsi-backend-core
- Status: completed
- Project path: /Users/yedizhang/test-student-info
- Branch: feat/tsi-backend-core
- Session: tsi-backend-core
- Backend: ACPX
- Agent: Claude
- Worktree: /Users/yedizhang/worktrees/tsi-backend-core
- Commit: 972acb7 (`feat: implement student CRUD backend with Express + Prisma + SQLite`)
- Verification:
  - Agent callback: `test_results: 11 passed, 0 failed`
  - Independent check: `npm run build` 通过；`GET /api/health` (PORT=3002) 返回 ok

### Task: tsi-frontend-core
- Status: completed
- Project path: /Users/yedizhang/test-student-info
- Branch: feat/tsi-frontend-core
- Session: tsi-frontend-core
- Backend: ACPX
- Agent: Claude
- Commit: b780d82 (`chore: add web/.gitignore`)
- Worktree: /Users/yedizhang/worktrees/tsi-frontend-core
- Verification:
  - Agent callback: completed
  - Independent check: `npm run build` 通过

### Task: tsi-integration-qa
- Status: completed
- Project path: /Users/yedizhang/test-student-info
- Branch: chore/tsi-integration-qa
- Session: tsi-integration-qa
- Backend: ACPX
- Agent: Claude
- Worktree: /Users/yedizhang/worktrees/tsi-integration-qa
- Commit: 0cb721e (`chore: integrate backend + frontend with QA deliverables`)
- Verification:
  - Agent callback: `test_results: 14 passed, 0 failed`
  - Independent check: `server npm run build` 通过；`web npm run build` 通过；`bash scripts/smoke-test.sh` 结果 `14 passed, 0 failed`

## 2026-03-24

### Task: sis-mvp-20260324
- Status: completed
- Project path: /Users/yedizhang/student-info-system
- Branch: feat/sis-mvp
- Stack: React + TypeScript + Vite, Node.js + Express, SQLite
- Features: 学生 CRUD、姓名/学号搜索、分页、表单校验
- Verification:
  - `npm run build` (web) 通过
  - 端到端 CRUD 脚本校验通过（create/search/update/delete）

### Task: acp-hello-world-test-20260324
- Status: completed
- Goal: 使用 ACP 协议调用 Claude Code 创建 Hello World Python 脚本
- Output file: /Users/yedizhang/hello_acp.py
- Verification: `python3 /Users/yedizhang/hello_acp.py` 输出 `Hello, World!`

### Task: acp-smoke-20260324-1936
- Status: completed
- Goal: 端到端测试 ACP 派发/执行/回传机制（Claude）
- Session: acp-smoke-20260324-1936
- Output files:
  - /Users/yedizhang/acp-smoke-test/hello.py
  - /Users/yedizhang/acp-smoke-test/README.md
- Verification:
  - `python3 /Users/yedizhang/acp-smoke-test/hello.py` 输出 `Hello from ACP smoke test`
  - README 内容为 `ACP smoke test done.`

### Task: acct-backend-core-20260324
- Status: completed
- Branch: feat/backend-core
- Session: acct-backend-core-20260324
- Worktree: /Users/yedizhang/worktrees/acct-backend-core-20260324
- Commit: f1f3fe8 (`feat: backend mvp for accounting system`)
- Verification:
  - Health check 通过（`/api/health`）
  - 独立 CRUD 校验通过（accounts/categories/transactions）

### Task: acct-frontend-core-20260324
- Status: completed
- Branch: feat/frontend-core
- Session: acct-frontend-core-20260324
- Worktree: /Users/yedizhang/worktrees/acct-frontend-core-20260324
- Commits:
  - abad2b1 (`feat: frontend mvp for accounting system`)
  - 0b48870 (`fix: align frontend with backend api contract`)
- Verification:
  - `npm run build` 通过
  - 已对齐后端响应包裹与分页字段

### Task: acct-integration-qa-20260324
- Status: completed
- Branch: chore/integration-qa
- Session: acct-integration-qa-20260324
- Worktree: /Users/yedizhang/worktrees/acct-integration-qa-20260324
- Commits:
  - 775af68 (`chore: add integration docs and smoke scripts`)
  - f14a0cf (`fix: align smoke script with backend api contract`)
  - 6848c60 (`fix: make smoke api script compatible with current backend`)
- Verification:
  - 在后端运行时 `node scripts/smoke-api.mjs` 结果 `13 passed, 0 failed`
