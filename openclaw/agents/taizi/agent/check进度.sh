#!/bin/bash

# 检查开发进度 - 学生信息管理系统
STATE_FILE="/Users/yedi/student-info-system/.swarm/coordinator-state.json"
PHASE=$(cat "$STATE_FILE" | grep -o '"phase": *"[^"]*"' | cut -d'"' -f4)

case "$PHASE" in
  "planning")
    MSG="📋 方案规划中..."
    ;;
  "awaiting_spec_review")
    MSG="📋 方案待审阅"
    ;;
  "awaiting_human_spec_review")
    MSG="📋 方案待用户确认"
    ;;
  "spec_rejected")
    MSG="❌ 方案被退回，正在修订"
    ;;
  "spec_approved")
    MSG="✅ 方案已通过，技术审核通过"
    ;;
  "generating_plan")
    MSG="⚙️ 正在生成执行计划"
    ;;
  "swarm_running")
    MSG="⚙️ 开发进行中..."
    ;;
  "reviewing")
    MSG="🔍 代码审核中"
    ;;
  "completed")
    MSG="🎉 开发完成！"
    ;;
  *)
    MSG="📌 状态: $PHASE"
    ;;
esac

# 发送飞书消息
openclaw message send --channel feishu --account taizi --target ou_679f52877ee5040328493cf26943a045 --message "$MSG"

echo "$MSG"
