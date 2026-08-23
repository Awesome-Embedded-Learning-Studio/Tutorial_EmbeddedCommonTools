#!/usr/bin/env bash
# 正文命令与配对脚本的一致性检查(铁律 2:命令即引用)。
#
# 规则:tutorial/journey/NN-x.md 的 ```bash 围栏里,每条非注释命令行
#      必须逐字出现在 scripts/journey/NN-x.sh 中(containment 匹配)。
# 约定:命令放 ```bash 围栏;输出/文件内容放无语言或 ```c/```text 围栏,
#      本脚本只检查 bash/sh/shell 围栏。
# 模式:默认 warn(只报告);LINT_STRICT=1 时有告警即红。
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STRICT="${LINT_STRICT:-0}"

shopt -s nullglob
docs=("$REPO_ROOT"/tutorial/journey/*.md)
shopt -u nullglob

if [ "${#docs[@]}" -eq 0 ]; then
  echo "[lint] tutorial/journey/ 下暂时没有正文"
  exit 0
fi

warnings=0
checked=0

for md in "${docs[@]}"; do
  base="$(basename "$md" .md)"
  # index 页是导览,不配脚本
  [ "$base" = "index" ] && continue

  script="$REPO_ROOT/scripts/journey/$base.sh"
  if [ ! -e "$script" ]; then
    # manual 级允许无配对脚本(编辑器交互/需硬件),但必须在 frontmatter 声明 tier
    if grep -q '^tier: *manual' "$md"; then
      continue
    fi
    echo "[lint] ⚠ $base.md: 缺配对脚本 scripts/journey/$base.sh"
    warnings=$((warnings + 1))
    continue
  fi

  # 抽取 bash 围栏中的命令行,落到临时文件再逐条核对
  cmds_tmp="$(mktemp)"
  trap 'rm -f "$cmds_tmp"' EXIT
  awk '
    /^```(bash|sh|shell)[[:space:]]*$/ { inblock = 1; next }
    /^```/ { inblock = 0; next }
    inblock {
      line = $0
      sub(/^\$ /, "", line)                     # 去掉手写的提示符
      if (line ~ /^[[:space:]]*#/) next         # 注释行
      if (line ~ /^[[:space:]]*$/) next         # 空行
      if (line ~ /\\$/) next                    # 续行:v1 先跳过
      print line
    }
  ' "$md" > "$cmds_tmp"

  while IFS= read -r cmd; do
    checked=$((checked + 1))
    if ! grep -Fq -- "$cmd" "$script"; then
      echo "[lint] ⚠ $base.md: 命令未见于配对脚本 → $cmd"
      warnings=$((warnings + 1))
    fi
  done < "$cmds_tmp"
done

echo
echo "[lint] 核对命令 $checked 条,告警 $warnings 条(模式:$([ "$STRICT" = 1 ] && echo strict || echo warn))"
if [ "$STRICT" = 1 ] && [ "$warnings" -gt 0 ]; then
  exit 1
fi
exit 0
