# 合并验收清单（Swarm 并行任务）

1. 每个子任务是否有 commit 且退出码为 0
2. 是否满足 DoD（功能、测试、文档）
3. 是否存在字段命名冲突（如 course_no/course_code, grade/score）
4. 合并后是否可启动：`uvicorn app.main:app --reload`
5. 合并后测试是否通过：`pytest -q`
6. README 是否包含可复现启动步骤
7. 清理临时工作树与日志（按需）
