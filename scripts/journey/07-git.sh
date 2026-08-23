#!/usr/bin/env bash
# ── 第 8 个历程 · 记录旅程 ────────────────────────────────────────────
# 重放 tutorial/journey/07-git.md 的全部命令:在临时目录里
# 从零建仓、改坏再救回、制造并解决冲突、打上里程碑 tag。
# tier: ci-matrix
set -euo pipefail

command -v git >/dev/null 2>&1 || { echo "FATAL: 没有 git" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

banner() { printf '\n──────── %s ────────\n' "$*"; }

# ═══ 建仓:第一份家业 ═══
banner "git init:从零建仓"
cd "$WORK"
git init -b main box
cd box
git config user.name "Journey Learner"
git config user.email "learner@example.com"

cat > README.md <<'EOF'
# box —— 一个程序的一生

主线实验仓:EmbedBox journey 的动手记录。

## 状态

- 第 7 个历程:串口输出已捕获(证据在 expected-serial.txt)
EOF

cat > hello.c <<'EOF'
#include <stdio.h>

int main(void)
{
    printf("hello, EmbedBox!\n");
    return 0;
}
EOF

banner "git status:两件新家当还没登记"
git status

banner "登记 + 第一笔户口"
git add README.md hello.c
git commit -m "hello: journey starts"

# ═══ 长大:改动与差异 ═══
banner "程序又长大了一行"
cat > hello.c <<'EOF'
#include <stdio.h>

int main(void)
{
    printf("hello, EmbedBox!\n");
    printf("journey: v0.2\n");
    return 0;
}
EOF

banner "git diff:改了什么,一目了然"
git diff

git diff | grep -q 'journey: v0.2' || { echo "FATAL: diff 里应当有新行" >&2; exit 1; }

banner "git add + 第二笔户口"
git add hello.c
git commit -m "hello: add version line"

banner "git log --oneline:户口本"
git log --oneline
[ "$(git log --oneline | wc -l)" -ge 2 ] || { echo "FATAL: 应当至少两笔提交" >&2; exit 1; }

# ═══ 改坏了?历史来救 ═══
banner "手滑改坏,先别慌"
cat > hello.c <<'EOF'
#include <stdio.h>

int main(void)
{
    /* 手滑:整个 main 被清空了 */
    return 0;
}
EOF
git diff --stat

banner "git restore:从最近一笔户口恢复"
git restore hello.c
grep -q 'journey: v0.2' hello.c || { echo "FATAL: 恢复失败" >&2; exit 1; }
echo "hello.c 已恢复,文件内容和最近一次提交一致"

# ═══ 分支:在不打扰主线的地方折腾 ═══
banner "开分支改 README"
git checkout -b polish-readme
cat > README.md <<'EOF'
# box —— 一个程序的一生

主线实验仓:EmbedBox journey 的动手记录。

## 状态

- 第 7 个历程:串口输出已验证 diff 一致
EOF
git add README.md
git commit -m "readme: sharpen beat-06 note"

banner "回主线,改同一行"
git checkout main
cat > README.md <<'EOF'
# box —— 一个程序的一生

主线实验仓:EmbedBox journey 的动手记录。

## 状态

- 第 7 个历程:串口输出已捕获,连 \r\n 都是亲手发的
EOF
git add README.md
git commit -m "readme: enrich beat-06 note"

# ═══ 合并:冲突,以及它的解法 ═══
banner "git merge:两边动了同一行"
set +e
out="$(git merge polish-readme 2>&1)"
rc=$?
set -e
printf '%s\n' "$out"
if [ "$rc" -eq 0 ]; then
  echo "FATAL: 预期冲突,却合并成功了" >&2
  exit 1
fi
printf '%s\n' "$out" | grep -q 'CONFLICT (content)' \
  || { echo "FATAL: 输出缺 CONFLICT 标记" >&2; exit 1; }

banner "git status:冲突现场"
git status

banner "手工裁决,然后收尾"
cat > README.md <<'EOF'
# box —— 一个程序的一生

主线实验仓:EmbedBox journey 的动手记录。

## 状态

- 第 7 个历程:串口输出已捕获,且与 expected-serial.txt 逐字节一致
EOF
git add README.md
git commit -m "merge polish-readme: pick the precise wording"

# ═══ 里程碑:tag ═══
banner "打上里程碑"
git tag v0.1-journey
git tag
git tag | grep -q 'v0.1-journey' || { echo "FATAL: tag 缺失" >&2; exit 1; }

git log --oneline

echo
echo "✅ 第 8 个历程 · 记录旅程 —— 全部断言通过"
