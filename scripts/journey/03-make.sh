#!/usr/bin/env bash
# ── 拍 03 · 程序长大 ────────────────────────────────────────────
# 重放 tutorial/journey/03-make.md 的全部命令,并断言关键结果。
# tier: ci-matrix(ubuntu / windows git-bash)
#
# 说明:正文里"文件长这样"的 C 代码块与第一/二幕的 heredoc 逐字一致;
#      最终态文件以 src/journey/03-make/ 为唯一事实源,用 cp 引入。
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC="$REPO_ROOT/src/journey/03-make"

# ── 平台自举:windows runner 上只有 mingw32-make 时,做个 shim ──
if ! command -v make >/dev/null 2>&1; then
  if command -v mingw32-make >/dev/null 2>&1; then
    SHIM="$(mktemp -d)/bin"
    mkdir -p "$SHIM"
    printf '#!/usr/bin/env bash\nexec mingw32-make "$@"\n' > "$SHIM/make"
    chmod +x "$SHIM/make"
    export PATH="$SHIM:$PATH"
    echo "[shim] 未找到 make,已将 mingw32-make 映射为 make"
  else
    echo "FATAL: 平台上没有 make/mingw32-make,无法重放本章" >&2
    exit 1
  fi
fi
command -v gcc >/dev/null 2>&1 || { echo "FATAL: 平台上没有 gcc" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"

banner() { printf '\n──────── %s ────────\n' "$*"; }

# ═══ 第一幕 · 手工时代:主角还只有一个文件 ═══
banner "第一幕:单文件时代"

cat > main.c <<'EOF'
/* 拍 01 出生、拍 02 病愈的主角,目前只有一个文件 */
#include <stdio.h>

int main(void)
{
    printf("hello, EmbedBox!\n");
    return 0;
}
EOF

gcc main.c -o hello
./hello
./hello | grep -q 'hello, EmbedBox!' || { echo "FATAL: 输出不符合预期" >&2; exit 1; }

# 程序长大:greet 搬进 util,main 变小(三个文件见正文代码块)
cat > main.c <<'EOF'
#include <stdio.h>
#include "util.h"

int main(void)
{
    greet("EmbedBox");
    return 0;
}
EOF
cat > util.h <<'EOF'
#ifndef UTIL_H
#define UTIL_H

/* greet 从 main.c 搬了出来,住进自己的家 */
void greet(const char *who);

#endif /* UTIL_H */
EOF
cat > util.c <<'EOF'
#include <stdio.h>
#include "util.h"

void greet(const char *who)
{
    printf("hello, %s!\n", who);
}
EOF

banner "第一幕:拆成三个文件,手工流水线"
gcc -c main.c
gcc -c util.c
gcc main.o util.o -o hello
./hello
./hello | grep -q 'hello, EmbedBox!' || { echo "FATAL: 输出不符合预期" >&2; exit 1; }

# ═══ 第二幕 · 长大的痛:改了三处,只记得重编一个 ═══
banner "第二幕:程序又长了,你只记得改过 main.c"

# util.h 长出 version 声明、util.c 长出实现、main.c 用上了它——
# 三个文件都换了新版(最终态 = src/journey/03-make/)
cp "$SRC/main.c" "$SRC/util.h" "$SRC/util.c" .

gcc -c main.c
set +e
out="$(gcc main.o util.o -o hello 2>&1)"
rc=$?
set -e
printf '%s\n' "$out"
if [ "$rc" -eq 0 ]; then
  echo "FATAL: 预期链接失败,却链接成功了" >&2
  exit 1
fi
printf '%s\n' "$out" | grep -q 'undefined reference to .version' \
  || { echo 'FATAL: 报错里没有 undefined reference to `version' >&2; exit 1; }

banner "第二幕:补上忘掉的那一步"
gcc -c util.c
gcc main.o util.o -o hello
./hello
./hello | grep -q 'journey beat 03: v0.3.0' || { echo "FATAL: 输出不符合预期" >&2; exit 1; }

# ═══ 第三幕 · make 接管 ═══
banner "第三幕:清掉手工残骸,让 make 接管"
rm main.o util.o hello
cp "$SRC/Makefile" .

out="$(make 2>&1)"
printf '%s\n' "$out"
printf '%s\n' "$out" | grep -q 'main\.c' || { echo "FATAL: 首次 make 没有编译 main.c" >&2; exit 1; }
printf '%s\n' "$out" | grep -q 'util\.c' || { echo "FATAL: 首次 make 没有编译 util.c" >&2; exit 1; }
./hello
./hello | grep -q 'journey beat 03: v0.3.0' || { echo "FATAL: 输出不符合预期" >&2; exit 1; }

banner "第三幕:touch util.h —— 头文件变了,两个都要重编"
touch util.h
out="$(make 2>&1)"
printf '%s\n' "$out"
printf '%s\n' "$out" | grep -q 'main\.c' || { echo "FATAL: 头文件变了,main.c 没有重编" >&2; exit 1; }
printf '%s\n' "$out" | grep -q 'util\.c' || { echo "FATAL: 头文件变了,util.c 没有重编" >&2; exit 1; }

banner "第三幕:什么都不改 —— make 说无事可做"
out="$(make 2>&1)"
printf '%s\n' "$out"
printf '%s\n' "$out" | grep -Eq '(Nothing to be done|is up to date)' \
  || { echo "FATAL: 没有改动时 make 应当无事可做" >&2; exit 1; }

banner "第三幕:touch util.c —— 只重编真正变了的那个"
touch util.c
out="$(make 2>&1)"
printf '%s\n' "$out"
printf '%s\n' "$out" | grep -q 'util\.c' || { echo "FATAL: util.c 没有重编" >&2; exit 1; }
if printf '%s\n' "$out" | grep -q 'main\.c'; then
  echo "FATAL: util.c 的改动不应该触发 main.c 重编" >&2
  exit 1
fi

banner "第三幕:make clean 与从零再来一遍"
make clean
[ ! -e hello ] || { echo "FATAL: clean 之后 hello 还在" >&2; exit 1; }
make
./hello | grep -q 'journey beat 03: v0.3.0' || { echo "FATAL: 输出不符合预期" >&2; exit 1; }

echo
echo "✅ 拍 03 · 程序长大 —— 全部断言通过"
