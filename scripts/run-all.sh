#!/usr/bin/env bash
# EmbedBox 验证总入口:顺序重放全部主线脚本。CI 与本地共用。
# 任何一个脚本红,总出口码为红。
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

shopt -s nullglob
scripts=("$REPO_ROOT"/scripts/journey/*.sh)
shopt -u nullglob

if [ "${#scripts[@]}" -eq 0 ]; then
  echo "[run-all] scripts/journey/ 下暂时没有脚本"
  exit 0
fi

fail=0
for script in "${scripts[@]}"; do
  echo
  echo ">>> 重放 $(basename "$script")"
  if bash "$script"; then
    echo "<<< $(basename "$script") 绿"
  else
    echo "<<< $(basename "$script") 红" >&2
    fail=1
  fi
done

exit "$fail"
