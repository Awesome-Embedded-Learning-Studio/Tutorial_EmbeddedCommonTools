#!/usr/bin/env bash
# ── 第 9 个历程 · 编辑器接线 ──────────────────────────────────────────
# tier: manual —— 编辑器交互无法无人值守重放,本脚本只做机械部分:
# 配置文件存在性 + JSON 合法性;其余为人工走查清单(见正文末)。
# 用 VS Code 打开工程:code .
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOTVS="$REPO_ROOT/src/journey/08-vscode/.vscode"

command -v node >/dev/null 2>&1 || { echo "FATAL: 缺 node(本仓库构建本身就需要它)" >&2; exit 1; }

banner() { printf '\n──────── %s ────────\n' "$*"; }

banner "机械检查:三份配置存在且是合法 JSON"
for f in settings.json launch.json tasks.json; do
  [ -e "$DOTVS/$f" ] || { echo "FATAL: 缺 $DOTVS/$f" >&2; exit 1; }
  node -e "JSON.parse(require('fs').readFileSync('$DOTVS/$f','utf8'))"
  echo "  [ok] $f"
done

banner "机械检查:launch 引用的 preLaunchTask 在 tasks.json 里存在"
task_label="$(node -e "console.log(JSON.parse(require('fs').readFileSync('$DOTVS/launch.json','utf8')).configurations[0].preLaunchTask)")"
node -e "const ts=JSON.parse(require('fs').readFileSync('$DOTVS/tasks.json','utf8')).tasks; process.exit(ts.some(t=>t.label==='$task_label')?0:1)" \
  || { echo "FATAL: tasks.json 里没有 '$task_label'" >&2; exit 1; }
echo "  [ok] preLaunchTask '$task_label' 可解析"

banner "人工走查清单(编辑器交互,需真人执行)"
cat <<'EOF'
  [ ] 在第 5 个历程 的工程根目录放入本目录的 .vscode/,code . 打开
  [ ] IntelliSense 生效:src/util.c 里 greet 跳转定义可用,无红线
  [ ] F5 触发 cmake-build 并启动 gdb 会话,断点可命中
  [ ] Remote-WSL(Windows 用户):左下角绿色角标显示 WSL 发行版
EOF

echo
echo "✅ 第 9 个历程 · 编辑器接线 —— 机械部分通过;人工部分见清单"
