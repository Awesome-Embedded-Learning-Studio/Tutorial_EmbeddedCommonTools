#!/usr/bin/env bash
# ── 第 5 个历程 · 工程化 ──────────────────────────────────────────────
# 重放 tutorial/journey/04-cmake.md 的全部命令:CMake 配置、构建、
# 运行,验证 compile_commands.json,并复验增量构建语义。
# tier: ci-matrix(产物名在 Windows 上可能带 .exe,脚本做了兼容)
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC="$REPO_ROOT/src/journey/04-cmake"

command -v cmake >/dev/null 2>&1 || { echo "FATAL: 没有 cmake,请回第 1 个历程 补装" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cp -r "$SRC/." "$WORK/"
cd "$WORK"

banner() { printf '\n──────── %s ────────\n' "$*"; }

# 定位产物:Linux/macOS 是 build/hello,部分 Windows 生成器是 hello.exe
find_bin() {
  for cand in build/hello build/hello.exe build/Debug/hello.exe build/Release/hello.exe; do
    [ -e "$cand" ] && { printf '%s' "$cand"; return 0; }
  done
  return 1
}

# ═══ 配置 + 构建 + 运行 ═══
banner "cmake -S -B:配置(生成构建系统)"
cmake -S . -B build | tail -4

banner "cmake --build:构建"
cmake --build build | tail -8

BIN="$(find_bin)" || { echo "FATAL: 没找到构建产物 hello" >&2; exit 1; }
echo "产物: $BIN"
# 运行:./build/hello(Windows 生成器的产物名可能带 .exe,由上面的 find_bin 解析)

banner "运行"
./"$BIN"
./"$BIN" | grep -q 'journey beat 04: v0.4.0' || { echo "FATAL: 输出不符合预期" >&2; exit 1; }

# ═══ compile_commands.json:给编辑器的那枚接口 ═══
banner "compile_commands.json"
ls -l build/compile_commands.json
grep -q 'util\.c' build/compile_commands.json \
  || { echo "FATAL: compile_commands.json 里没有 util.c" >&2; exit 1; }

# ═══ 增量构建:CMake 记着第 4 个历程 那本账 ═══
banner "touch src/util.h 之后再构建"
touch src/util.h
out="$(cmake --build build 2>&1)"
printf '%s\n' "$out"
printf '%s\n' "$out" | grep -q 'Building C object.*util\.c' \
  || { echo "FATAL: util.h 变了,util.c 没有重编" >&2; exit 1; }
printf '%s\n' "$out" | grep -q 'Building C object.*main\.c' \
  || { echo "FATAL: util.h 变了,main.c 没有重编" >&2; exit 1; }

banner "什么都不动,再构建一次"
out="$(cmake --build build 2>&1)"
printf '%s\n' "$out"
if printf '%s\n' "$out" | grep -q 'Building C object'; then
  echo "FATAL: 没有改动时不应重编" >&2
  exit 1
fi

echo
echo "✅ 第 5 个历程 · 工程化 —— 全部断言通过"
