#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# OpenClaw Dev Workflow Pipeline - 一键安装脚本
# 创建 4 个 Agent: taizi, foreman, reviewer, shipper
# ============================================================

OPENCLAW_HOME="$HOME/.openclaw"
OPENCLAW_JSON="$OPENCLAW_HOME/openclaw.json"
MAIN_AUTH="$OPENCLAW_HOME/agents/main/agent/auth-profiles.json"
MAIN_WORKSPACE="$HOME/clawd"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOULS_DIR="$SCRIPT_DIR/souls"

# Agent 定义
AGENTS=(taizi foreman reviewer shipper)
MODEL="openai-codex/gpt-5.4"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================================
# Step 0: 前置检查
# ============================================================

log_info "检查前置条件..."

if ! command -v openclaw &>/dev/null; then
    log_error "openclaw CLI 未安装或不在 PATH 中"
    log_error "请先安装：npm install -g openclaw"
    exit 1
fi

if [ ! -f "$OPENCLAW_JSON" ]; then
    log_error "找不到 $OPENCLAW_JSON，请先运行 openclaw 初始化"
    exit 1
fi

if [ ! -f "$MAIN_AUTH" ]; then
    log_error "找不到 main agent 的 auth-profiles.json: $MAIN_AUTH"
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    log_error "python3 未安装"
    exit 1
fi

if ! command -v jq &>/dev/null; then
    log_warn "jq 未安装，将使用 python3 处理 JSON"
fi

log_info "前置检查通过"

# ============================================================
# Step 1: 创建 workspace 目录
# ============================================================

log_info "创建 workspace 目录..."

for agent in "${AGENTS[@]}"; do
    workspace="$OPENCLAW_HOME/workspace-${agent}"
    if [ -d "$workspace" ]; then
        log_warn "workspace 已存在: $workspace（跳过创建）"
    else
        mkdir -p "$workspace"
        log_info "创建: $workspace"
    fi
done

# ============================================================
# Step 2: 写入 SOUL.md
# ============================================================

log_info "写入 SOUL.md..."

for agent in "${AGENTS[@]}"; do
    workspace="$OPENCLAW_HOME/workspace-${agent}"
    soul_src="$SOULS_DIR/${agent}.md"
    soul_dst="$workspace/SOUL.md"

    if [ ! -f "$soul_src" ]; then
        log_error "找不到 SOUL 模板: $soul_src"
        exit 1
    fi

    cp "$soul_src" "$soul_dst"
    log_info "写入: $soul_dst"
done

# ============================================================
# Step 3: 写入 IDENTITY.md
# ============================================================

log_info "写入 IDENTITY.md..."

declare -A IDENTITY_NAME
IDENTITY_NAME[taizi]="太子"
IDENTITY_NAME[foreman]="工头"
IDENTITY_NAME[reviewer]="审核官"
IDENTITY_NAME[shipper]="交付官"

declare -A IDENTITY_EMOJI
IDENTITY_EMOJI[taizi]="👑"
IDENTITY_EMOJI[foreman]="🏗️"
IDENTITY_EMOJI[reviewer]="🔍"
IDENTITY_EMOJI[shipper]="🚀"

declare -A IDENTITY_CREATURE
IDENTITY_CREATURE[taizi]="消息分拣 AI"
IDENTITY_CREATURE[foreman]="规划调度 AI（中书省）"
IDENTITY_CREATURE[reviewer]="质量审核 AI（门下省）"
IDENTITY_CREATURE[shipper]="合并交付 AI（尚书省）"

for agent in "${AGENTS[@]}"; do
    workspace="$OPENCLAW_HOME/workspace-${agent}"
    cat > "$workspace/IDENTITY.md" << IDEOF
# IDENTITY.md

- **Name:** ${IDENTITY_NAME[$agent]}
- **Creature:** ${IDENTITY_CREATURE[$agent]}
- **Vibe:** 专注、高效
- **Emoji:** ${IDENTITY_EMOJI[$agent]}
IDEOF
    log_info "写入: $workspace/IDENTITY.md"
done

# ============================================================
# Step 4: 复制 USER.md
# ============================================================

log_info "复制 USER.md..."

if [ -f "$MAIN_WORKSPACE/USER.md" ]; then
    for agent in "${AGENTS[@]}"; do
        workspace="$OPENCLAW_HOME/workspace-${agent}"
        cp "$MAIN_WORKSPACE/USER.md" "$workspace/USER.md"
    done
    log_info "USER.md 已复制到所有 workspace"
else
    log_warn "未找到 main workspace 的 USER.md ($MAIN_WORKSPACE/USER.md)，跳过"
fi

# ============================================================
# Step 5: 注册 Agent
# ============================================================

log_info "注册 Agent..."

for agent in "${AGENTS[@]}"; do
    workspace="$OPENCLAW_HOME/workspace-${agent}"

    # 检查是否已注册
    if openclaw agents list 2>/dev/null | grep -q "^${agent} "; then
        log_warn "Agent 已注册: ${agent}（跳过）"
        continue
    fi

    log_info "注册 Agent: ${agent} (model: ${MODEL}, workspace: ${workspace})"
    openclaw agents add "${agent}" \
        --workspace "$workspace" \
        --model "$MODEL" \
        --non-interactive \
        || { log_error "注册 ${agent} 失败"; exit 1; }
done

log_info "Agent 注册完成"

# ============================================================
# Step 6: 设置权限（subagents.allowAgents）
# ============================================================

log_info "设置 Agent 权限矩阵..."

# 权限矩阵定义
# taizi    → [foreman]
# foreman  → [reviewer]
# reviewer → [foreman, shipper]
# shipper  → [taizi]
# main     → 不限制（保持现有）

python3 << 'PYEOF'
import json
import shutil

config_path = "$OPENCLAW_JSON"
# 展开环境变量
import os
config_path = os.path.expandvars(config_path.replace("$OPENCLAW_JSON", ""))
config_path = os.path.join(os.environ["HOME"], ".openclaw", "openclaw.json")

# 备份
shutil.copy2(config_path, config_path + ".bak")

with open(config_path, "r") as f:
    config = json.load(f)

# 确保 agents.entries 存在
if "agents" not in config:
    config["agents"] = {}
if "entries" not in config["agents"]:
    config["agents"]["entries"] = {}

# 权限矩阵
permissions = {
    "taizi":    {"subagents": {"allowAgents": ["foreman"]}},
    "foreman":  {"subagents": {"allowAgents": ["reviewer"]}},
    "reviewer": {"subagents": {"allowAgents": ["foreman", "shipper"]}},
    "shipper":  {"subagents": {"allowAgents": ["taizi"]}},
}

for agent_id, perms in permissions.items():
    if agent_id not in config["agents"]["entries"]:
        config["agents"]["entries"][agent_id] = {}
    config["agents"]["entries"][agent_id].update(perms)

with open(config_path, "w") as f:
    json.dump(config, f, indent=2, ensure_ascii=False)

print("权限矩阵已写入 openclaw.json")
PYEOF

log_info "权限设置完成"

# ============================================================
# Step 7: 开启 session visibility
# ============================================================

log_info "设置 session visibility..."

openclaw config set tools.sessions.visibility all 2>/dev/null \
    && log_info "visibility 已设置为 all" \
    || log_warn "设置 visibility 失败（可能需要手动设置）"

# ============================================================
# Step 8: 同步 auth
# ============================================================

log_info "同步 auth-profiles.json..."

for agent in "${AGENTS[@]}"; do
    agent_dir="$OPENCLAW_HOME/agents/${agent}/agent"
    mkdir -p "$agent_dir"
    cp "$MAIN_AUTH" "$agent_dir/auth-profiles.json"
    log_info "auth 已同步: ${agent}"
done

log_info "auth 同步完成"

# ============================================================
# Step 9: 绑定渠道（暂不变更，提示手动操作）
# ============================================================

log_info "渠道绑定："
log_warn "暂不自动变更大象通信渠道绑定。"
log_warn "如需将大象通信从 main 绑到 taizi，请手动执行："
log_warn "  openclaw channels bind elephant taizi"
log_warn "当前保持 main 不变，先通过 CLI 手动测试流水线。"

# ============================================================
# Step 10: 重启 gateway
# ============================================================

log_info "重启 gateway..."

openclaw gateway restart 2>/dev/null \
    && log_info "gateway 已重启" \
    || log_warn "gateway 重启失败（可能未运行，不影响 CLI 测试）"

# ============================================================
# 验证
# ============================================================

echo ""
echo "============================================================"
log_info "安装完成！运行验证..."
echo "============================================================"
echo ""

# 验证 agents 注册
log_info "已注册的 Agents:"
openclaw agents list 2>/dev/null || log_warn "无法列出 agents"

echo ""

# 验证权限
log_info "权限矩阵:"
python3 -c "
import json, os
config_path = os.path.join(os.environ['HOME'], '.openclaw', 'openclaw.json')
c = json.load(open(config_path))
for a in ['taizi', 'foreman', 'reviewer', 'shipper', 'main']:
    entry = c.get('agents', {}).get('entries', {}).get(a, {})
    allow = entry.get('subagents', {}).get('allowAgents', 'NOT SET')
    print(f'  {a}: {allow}')
"

echo ""

# 验证 auth 同步
log_info "Auth 文件:"
for agent in "${AGENTS[@]}"; do
    auth_file="$OPENCLAW_HOME/agents/${agent}/agent/auth-profiles.json"
    if [ -f "$auth_file" ]; then
        echo "  ${agent}: OK"
    else
        echo "  ${agent}: MISSING"
    fi
done

echo ""

# 验证 workspace 文件
log_info "Workspace 文件:"
for agent in "${AGENTS[@]}"; do
    workspace="$OPENCLAW_HOME/workspace-${agent}"
    soul="$([ -f "$workspace/SOUL.md" ] && echo 'OK' || echo 'MISSING')"
    identity="$([ -f "$workspace/IDENTITY.md" ] && echo 'OK' || echo 'MISSING')"
    user="$([ -f "$workspace/USER.md" ] && echo 'OK' || echo 'MISSING')"
    echo "  ${agent}: SOUL=${soul} IDENTITY=${identity} USER=${user}"
done

echo ""
echo "============================================================"
log_info "安装验证完成"
echo ""
log_info "下一步测试："
echo "  # Agent 间通信测试"
echo "  openclaw agent --agent foreman --message 'ping' --json"
echo ""
echo "  # 端到端测试"
echo "  openclaw agent --agent taizi --message '帮我在 ~/my-project 加一个用户登录功能'"
echo "============================================================"
