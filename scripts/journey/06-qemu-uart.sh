#!/usr/bin/env bash
# ── 第 7 个历程 · 没有屏幕的机器 ──────────────────────────────────────
# 重放 tutorial/journey/06-qemu-uart.md 的全部命令:裸机构建、
# QEMU 运行、串口证据与 expected-serial.txt 全量比对、CMake 工具链文件收编、
# gdbstub 远程调试。
# tier: ci-linux(ubuntu:apt 装 gcc-arm-none-eabi + qemu-system-arm)
#
# 工具安装指引(Ubuntu):
#   sudo apt install gcc-arm-none-eabi qemu-system-arm gdb cmake
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC="$REPO_ROOT/src/journey/06-qemu-uart"

command -v arm-none-eabi-gcc >/dev/null 2>&1 || { echo "FATAL: 缺 arm-none-eabi-gcc(第 6 个历程 已装过)" >&2; exit 1; }
command -v qemu-system-arm >/dev/null 2>&1 || { echo "FATAL: 缺 qemu-system-arm,安装指引见本文件头部注释" >&2; exit 1; }
command -v gdb >/dev/null 2>&1 || { echo "FATAL: 缺 gdb" >&2; exit 1; }
command -v cmake >/dev/null 2>&1 || { echo "FATAL: 缺 cmake" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"
cp "$SRC/startup.c" "$SRC/main.c" "$SRC/linker.ld" "$SRC/expected-serial.txt" .
cp "$SRC/CMakeLists.txt" "$SRC/arm-none-eabi.cmake" .

banner() { printf '\n──────── %s ────────\n' "$*"; }

# ═══ 构建:点名 CPU,自己带链接脚本 ═══
banner "交叉编译(点名 cortex-m3 / thumb-2)"
arm-none-eabi-gcc -c -mcpu=cortex-m3 -mthumb -Wall -Wextra -g -O2 startup.c -o startup.o
arm-none-eabi-gcc -c -mcpu=cortex-m3 -mthumb -Wall -Wextra -g -O2 main.c -o main.o

banner "链接(-nostdlib:这次谁都不借)"
arm-none-eabi-gcc -nostdlib -T linker.ld startup.o main.o -o hello.elf

arm-none-eabi-objdump -f hello.elf
arm-none-eabi-objdump -f hello.elf | grep -q 'architecture: arm' \
  || { echo "FATAL: 产物架构不是 arm" >&2; exit 1; }
arm-none-eabi-nm hello.elf | grep -q ' T main' || { echo "FATAL: 缺 main 符号" >&2; exit 1; }

arm-none-eabi-objcopy -O binary hello.elf hello.bin
ls -l hello.elf hello.bin

# 断言:没有 newlib/半主机拖家带口,镜像应当轻装
bin_size="$(stat -c %s hello.bin)"
[ "$bin_size" -lt 4096 ] \
  || { echo "FATAL: 裸机镜像 $bin_size 字节,超出预期(应轻装)" >&2; exit 1; }

# ═══ 运行:串口就是这台机器唯一的嘴 ═══
banner "QEMU:上电(5 秒后关机)"
set +e
timeout 5 qemu-system-arm -M mps2-an385 -cpu cortex-m3 -nographic -monitor none \
    -kernel hello.elf > serial.txt 2> qemu.err
rc=$?
set -e
if [ "$rc" -ne 124 ] && [ "$rc" -ne 0 ]; then
  echo "FATAL: QEMU 异常退出(rc=$rc)" >&2; cat qemu.err >&2; exit 1
fi

echo "── 串口输出 ──"
cat serial.txt

# ═══ 证据落袋:与 expected-serial.txt 全量比对 ═══
banner "diff:串口输出 vs expected-serial.txt"
if diff -u expected-serial.txt serial.txt; then
  echo "两份逐字节一致"
else
  echo "FATAL: 串口输出与期望不符" >&2
  exit 1
fi

# ═══ 兑现第 5 个历程:换一个工具链文件,重新配置 ═══
banner "CMake:换一个工具链文件,重新配置"
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=arm-none-eabi.cmake
cmake --build build

arm-none-eabi-objcopy -O binary build/hello.elf hello-cmake.bin
cmp hello.bin hello-cmake.bin \
  || { echo "FATAL: CMake 产物与手敲产物不一致" >&2; exit 1; }
echo "── CMake 产物与手敲产物逐字节一致 ──"

set +e
timeout 5 qemu-system-arm -M mps2-an385 -cpu cortex-m3 -nographic -monitor none \
    -kernel build/hello.elf > serial-cmake.txt 2> qemu-cmake.err
rc=$?
set -e
if [ "$rc" -ne 124 ] && [ "$rc" -ne 0 ]; then
  echo "FATAL: QEMU(CMake 产物)异常退出(rc=$rc)" >&2; cat qemu-cmake.err >&2; exit 1
fi
diff -u expected-serial.txt serial-cmake.txt \
  || { echo "FATAL: CMake 产物的串口输出与期望不符" >&2; exit 1; }

# ═══ 远程调试:第 3 个历程 的伏笔在此兑现 ═══
banner "gdbstub:target remote,隔空断点"
GDB_PORT=12345  # 固定端口,正文命令逐字可核
# Ubuntu 的原生 gdb 是单架构构建,连 ARM 目标会报 unknown architecture "arm";
# 那边需要 gdb-multiarch。Arch 等发行版的 gdb 本身就是全架构的,直接用。
GDB_BIN=gdb
command -v gdb-multiarch >/dev/null 2>&1 && GDB_BIN=gdb-multiarch
qemu-system-arm -M mps2-an385 -cpu cortex-m3 -nographic -monitor none \
    -kernel hello.elf -S -gdb tcp::12345 > /dev/null 2>&1 &
QEMU_PID=$!
cleanup_qemu() { kill "$QEMU_PID" 2>/dev/null || true; }
trap cleanup_qemu EXIT
sleep 1
set +e
timeout 20 "$GDB_BIN" -q -batch -iex 'set debuginfod enabled off' \
    -ex "target remote localhost:12345" \
    -ex 'break main' \
    -ex 'continue' \
    -ex 'bt' \
    hello.elf | tee gdb.log
gdb_rc=$?
set -e
cleanup_qemu
trap 'rm -rf "$WORK"' EXIT
if [ "$gdb_rc" -ne 0 ]; then
  echo "FATAL: 远程调试会话失败(rc=$gdb_rc)" >&2
  exit 1
fi

grep -q 'Breakpoint 1, ' gdb.log || { echo "FATAL: 远程断点未命中" >&2; exit 1; }
grep -Eq '#0 +main' gdb.log || { echo "FATAL: 回溯缺 main 帧" >&2; exit 1; }
grep -q 'Reset_Handler' gdb.log || { echo "FATAL: 连接时应先停在复位入口" >&2; exit 1; }

echo
echo "✅ 第 7 个历程 · 没有屏幕的机器 —— 全部断言通过(终点事件完成)"
