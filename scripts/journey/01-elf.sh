#!/usr/bin/env bash
# ── 拍 01 · 源码→程序 ───────────────────────────────────────────
# 重放 tutorial/journey/01-elf.md 的全部命令:把一行 hello.c
# 逐步变成可执行文件,并把每一段的中间产物拆开看。
# tier: ci-matrix
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC="$REPO_ROOT/src/journey/01-elf"

command -v gcc >/dev/null 2>&1 || { echo "FATAL: 没有 gcc,请先完成拍 00 体检" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"
cp "$SRC/hello.c" .

banner() { printf '\n──────── %s ────────\n' "$*"; }

# ═══ 开场:一行命令,先跑起来 ═══
banner "一行命令,先跑起来"
gcc hello.c -o hello
./hello
./hello | grep -q 'hello, EmbedBox!' || { echo "FATAL: 输出不符合预期" >&2; exit 1; }

# ═══ 第一步:只跑预处理器 ═══
banner "gcc -E:只跑预处理器"
gcc -E hello.c -o hello.i
wc -l hello.i
head -12 hello.i

# 断言:stdio.h 展开后体积暴涨(几百行起步)
lines="$(wc -l < hello.i)"
[ "$lines" -gt 100 ] || { echo "FATAL: 预处理产物行数异常: $lines" >&2; exit 1; }

# ═══ 第二步:到汇编为止 ═══
banner "gcc -S:到汇编为止"
gcc -S hello.c
grep -n 'main:' hello.s
sed -n '/^main:/,/ret/p' hello.s

# ═══ 第三步:到目标文件为止 ═══
banner "gcc -c:到目标文件为止"
gcc -c hello.c
objdump -f hello.o

# 断言:目标文件带着「待重定位」标记,还不是可执行文件
objdump -f hello.o | grep -q 'HAS_RELOC' \
  || { echo "FATAL: hello.o 应当是可重定位目标文件" >&2; exit 1; }

nm hello.o

# 断言:符号表里有已定义的 main 和未决的标准库函数
# (gcc 会把单参数带换行的 printf 优化成 puts,两者都合法)
nm hello.o | grep -q ' T main' || { echo "FATAL: 符号表缺 main" >&2; exit 1; }
nm hello.o | grep -Eq ' U (printf|puts)' || { echo "FATAL: 符号表缺未决的 printf/puts" >&2; exit 1; }

# ═══ 第四步:链接成可执行文件 ═══
banner "链接:hello.o → hello"
gcc hello.o -o hello
objdump -f hello
nm hello | grep -q ' T main' || { echo "FATAL: 可执行文件缺 main" >&2; exit 1; }
objdump -f hello | grep -q 'x86-64' || { echo "FATAL: 架构字段异常" >&2; exit 1; }
./hello
./hello | grep -q 'hello, EmbedBox!' || { echo "FATAL: 输出不符合预期" >&2; exit 1; }

# ═══ 拆开看:段、反汇编、体积 ═══
banner "readelf -S:可执行文件里的段"
readelf -S hello | grep -E '(\.text|\.data|\.bss|\.rodata)' || true
readelf -S hello | grep -q '\.text' || { echo "FATAL: 缺 .text 段" >&2; exit 1; }
readelf -S hello | grep -q '\.bss' || { echo "FATAL: 缺 .bss 段" >&2; exit 1; }

banner "objdump -d:看自己程序的汇编"
objdump -d hello | sed -n '/<main>:/,/^$/p'

banner "size:三个段各占多少"
size hello

echo
echo "✅ 拍 01 · 源码→程序 —— 全部断言通过"
