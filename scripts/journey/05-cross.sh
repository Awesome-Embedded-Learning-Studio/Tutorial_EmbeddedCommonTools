#!/usr/bin/env bash
# ── 拍 05 · 搬家:交叉编译 ──────────────────────────────────────
# 重放 tutorial/journey/05-cross.md 的全部命令:同一份源码交给
# arm-none-eabi 工具链,对比架构产物,并验证「宿主机跑不了」。
# tier: ci-linux 起步(ubuntu runner 可 apt 装 gcc-arm-none-eabi)
#
# 工具链安装指引(拍 00 体检的建议工具,现在该装了):
#   Ubuntu/Debian:  sudo apt install gcc-arm-none-eabi
#   Arch:           sudo pacman -S arm-none-eabi-gcc
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC="$REPO_ROOT/src/journey/05-cross"

command -v gcc >/dev/null 2>&1 || { echo "FATAL: 没有 gcc" >&2; exit 1; }
command -v arm-none-eabi-gcc >/dev/null 2>&1 \
  || { echo "FATAL: 没有 arm-none-eabi-gcc,安装指引见本文件头部注释" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"
cp "$SRC/main.c" "$SRC/util.c" "$SRC/util.h" .

banner() { printf '\n──────── %s ────────\n' "$*"; }

# ═══ 同一个 gcc,不同的目标 ═══
banner "两个 dumpmachine:编译器各自身后的目标机"
gcc -dumpmachine
arm-none-eabi-gcc -dumpmachine

assert_dump() {  # 断言:目标三元组应以 want 开头(各发行版中段可有可无)
  local tool="$1" want="$2"
  got="$("$tool" -dumpmachine)"
  case "$got" in
    "$want"*) ;;
    *) echo "FATAL: $tool -dumpmachine = $got,期望 $want 前缀" >&2; exit 1 ;;
  esac
}
assert_dump gcc x86_64
assert_dump arm-none-eabi-gcc arm-none-eabi

# ═══ 交叉编译,逐段走 ═══
banner "交叉编译:编目标文件"
arm-none-eabi-gcc -c main.c -o main.o
arm-none-eabi-gcc -c util.c -o util.o

banner "交叉链接(--specs=rdimon.specs:printf 的裸机后端)"
arm-none-eabi-gcc main.o util.o --specs=rdimon.specs -o hello.elf

banner "架构对比:同一份 main.c,两个世界"
gcc -c main.c -o main-host.o
objdump -f main-host.o
arm-none-eabi-objdump -f main.o

# 断言:两份目标文件架构不同,ARM 版真的是 arm
objdump -f main-host.o | grep -q 'x86-64' || { echo "FATAL: 宿主目标文件架构异常" >&2; exit 1; }
arm-none-eabi-objdump -f main.o | grep -q 'architecture: arm' \
  || { echo "FATAL: 交叉目标文件架构不是 arm" >&2; exit 1; }

arm-none-eabi-readelf -h hello.elf | grep -E 'Class|Machine'

banner "ELF → 裸二进制"
arm-none-eabi-objcopy -O binary hello.elf hello.bin
ls -l hello.elf hello.bin

# 断言:.bin 是从 .elf 里抠出的裸字节,一定更小
elf_size="$(stat -c %s hello.elf)"
bin_size="$(stat -c %s hello.bin)"
[ "$bin_size" -lt "$elf_size" ] \
  || { echo "FATAL: hello.bin($bin_size) 应当比 hello.elf($elf_size) 小" >&2; exit 1; }

banner "在宿主机上跑它?试试"
set +e
out="$(./hello.elf 2>&1)"
rc=$?
set -e
printf '%s\n' "$out"
if [ "$rc" -eq 0 ]; then
  echo "FATAL: ARM 程序不应该能在 x86 宿主机上运行成功" >&2
  exit 1
fi

echo
echo "✅ 拍 05 · 搬家 —— 全部断言通过(心脏造好了,还差身体)"
