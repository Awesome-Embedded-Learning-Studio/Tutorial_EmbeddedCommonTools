#!/usr/bin/env bash
# ── 拍 02 · 程序病了 ────────────────────────────────────────────
# 重放 tutorial/journey/02-gdb.md 的全部命令:用 gdb 脚本化会话
# 揪出 buggy.c 里故意埋的越界读。
# tier: ci-matrix
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC="$REPO_ROOT/src/journey/02-gdb"

command -v gcc >/dev/null 2>&1 || { echo "FATAL: 没有 gcc" >&2; exit 1; }
command -v gdb >/dev/null 2>&1 || { echo "FATAL: 没有 gdb,请回拍 00 补装" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"
cp "$SRC/buggy.c" .

banner() { printf '\n──────── %s ────────\n' "$*"; }

# ═══ 编译带调试信息的版本,先看症状 ═══
banner "编译(-g 留下调试信息)与症状"
gcc -g -O0 -o buggy buggy.c
./buggy
./buggy | grep -Eq 'total = -?[0-9]+' || { echo "FATAL: 输出不符合预期" >&2; exit 1; }

# ═══ 会话一:断点 + 参数 + 回溯 ═══
banner "gdb 会话一:断点、info args、bt"
gdb -q -batch -iex 'set debuginfod enabled off' ./buggy \
    -ex 'break scale' \
    -ex 'run' \
    -ex 'info args' \
    -ex 'bt' \
 | tee gdb1.log

grep -q 'Breakpoint 1, ' gdb1.log || { echo "FATAL: 断点未命中" >&2; exit 1; }
grep -q 'factor = 2' gdb1.log || { echo "FATAL: info args 输出异常" >&2; exit 1; }
grep -Eq '#0 +scale' gdb1.log || { echo "FATAL: 回溯缺 scale 帧" >&2; exit 1; }
grep -Eq '#1 .*main' gdb1.log || { echo "FATAL: 回溯缺 main 帧" >&2; exit 1; }

# ═══ 会话二:一路 continue 到第五次调用,看越界值 ═══
banner "gdb 会话二:continue 到 data[4] 那一拍"
gdb -q -batch -iex 'set debuginfod enabled off' ./buggy \
    -ex 'break scale' \
    -ex 'run' \
    -ex 'info args' \
    -ex 'continue' \
    -ex 'info args' \
    -ex 'continue' \
    -ex 'continue' \
    -ex 'continue' \
    -ex 'continue' \
 | tee gdb2.log

# 第五次调用一定发生(循环 i=0..4 共五次),且 v 是越界读到的值
stops="$(grep -c 'Breakpoint 1, ' gdb2.log)"
[ "$stops" -ge 5 ] || { echo "FATAL: 断点应命中 5 次,实际 $stops 次" >&2; exit 1; }
grep -q 'v = ' gdb2.log || { echo "FATAL: 缺 v 的打印" >&2; exit 1; }

# ═══ 会话三:watch —— 让数据变化自己举手 ═══
banner "gdb 会话三:watch total"
gdb -q -batch -iex 'set debuginfod enabled off' ./buggy \
    -ex 'break main' \
    -ex 'run' \
    -ex 'watch total' \
    -ex 'continue' \
 | tee gdb3.log

grep -q 'Old value = 0' gdb3.log || { echo "FATAL: watch 未捕获首次写入" >&2; exit 1; }
grep -q 'New value = 2' gdb3.log || { echo "FATAL: watch 首次写入值异常" >&2; exit 1; }

# ═══ 会话四:-O2 下,变量被优化掉 ═══
banner "-O2:优化和调试器打架"
gcc -O2 -g -o buggy-o2 buggy.c
gdb -q -batch -iex 'set debuginfod enabled off' ./buggy-o2 \
    -ex 'break main' \
    -ex 'run' \
    -ex 'print total' \
    -ex 'print data' \
 | tee gdb4.log

grep -q 'optimized out' gdb4.log || { echo "FATAL: 应观察到 optimized out" >&2; exit 1; }

echo
echo "✅ 拍 02 · 程序病了 —— 全部断言通过"
