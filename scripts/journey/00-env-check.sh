#!/usr/bin/env bash
# ── 拍 00 · 环境体检 ────────────────────────────────────────────
# 本拍比较特殊:验证脚本本身就是教具——教程教你读懂它输出的体检报告。
# 必需工具(git/gcc/make)缺失 → 红;建议工具缺失只提示,不算失败。
# tier: ci-matrix
#
# 本脚本的运行方式:bash scripts/journey/00-env-check.sh
#
# 装齐工具的手工指引(不同平台各取所需;脚本自己不会去装):
#   Ubuntu/Debian:  sudo apt install build-essential gdb cmake
#   Arch:           sudo pacman -S base-devel gdb cmake
#   Windows 先装 WSL2(PowerShell 管理员):
#     wsl --install -d Ubuntu
#   交叉工具链与模拟器(拍 05/06 才需要,现在可以先不装):
#     Ubuntu/Debian:  sudo apt install gcc-arm-none-eabi qemu-system-arm
#     Arch:           sudo pacman -S arm-none-eabi-gcc qemu-arm
set -euo pipefail

banner() { printf '\n──────── %s ────────\n' "$*"; }

banner "机器与系统"
uname -a
printf 'bash %s\n' "${BASH_VERSION:-?}"

banner "必需工具(缺任何一个,体检就是红)"
missing=0
for tool in git gcc make; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '  [ok] %-8s -> %s\n' "$tool" "$(command -v "$tool")"
  else
    printf '  [缺失] %s\n' "$tool"
    missing=1
  fi
done
[ "$missing" -eq 0 ] || { echo "FATAL: 必需工具缺失,安装指引见本文件头部注释" >&2; exit 1; }

banner "工具版本"
git --version
gcc --version | head -1
make --version | head -1

banner "建议工具(现在缺不要紧,后面的拍会用到再装)"
for tool in gdb cmake arm-none-eabi-gcc qemu-system-arm; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '  [ok] %s\n' "$tool"
  else
    printf '  [未装] %s —— 后面的拍会用到,到时候再装也来得及\n' "$tool"
  fi
done

banner "PATH —— shell 找命令的地方"
echo "$PATH" | tr ':' '\n' | sed 's/^/  /'

banner "command not found 的三板斧"
echo "  1) 它装了吗:  which gcc"
echo "  2) 它在哪:    echo \"\$PATH\" 里有没有那个目录"
echo "  3) 名字对吗:  拼写、大小写、别名"

echo
echo "✅ 拍 00 · 环境体检 —— 必需项全部就绪"
