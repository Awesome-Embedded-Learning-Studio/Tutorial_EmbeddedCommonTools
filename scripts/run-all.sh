#!/usr/bin/env bash
# EmbedBox 验证总入口:顺序重放全部主线脚本。CI 与本地共用。
# 任何一个脚本红,总出口码为红。
# tier 感知:配对正文 frontmatter 声明 tier: ci-linux 的脚本,
# 只在 Linux runner 上重放(交叉工具链/模拟器只装在 Linux 侧);
# 其余 tier(含未声明)照常全平台重放。
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

is_linux() { case "$(uname -s)" in Linux*) return 0 ;; *) return 1 ;; esac; }

tier_of() {
  local md="$REPO_ROOT/tutorial/journey/$1.md"
  if [ -f "$md" ]; then
    sed -n 's/^tier:[[:space:]]*//p' "$md" | head -n1
  fi
  return 0
}

shopt -s nullglob
scripts=("$REPO_ROOT"/scripts/journey/*.sh)
shopt -u nullglob

if [ "${#scripts[@]}" -eq 0 ]; then
  echo "[run-all] scripts/journey/ 下暂时没有脚本"
  exit 0
fi

fail=0
for script in "${scripts[@]}"; do
  base="$(basename "$script" .sh)"
  tier="$(tier_of "$base")"
  echo
  if [ "$tier" = "ci-linux" ] && ! is_linux; then
    echo ">>> 跳过 $base.sh(tier: ci-linux,非 Linux runner)"
    continue
  fi
  echo ">>> 重放 $(basename "$script")"
  if bash "$script"; then
    echo "<<< $(basename "$script") 绿"
  else
    echo "<<< $(basename "$script") 红" >&2
    fail=1
  fi
done

exit "$fail"
