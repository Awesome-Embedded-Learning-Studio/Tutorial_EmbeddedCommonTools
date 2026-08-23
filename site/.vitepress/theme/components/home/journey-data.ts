// 首页数据源(卷宗终端版)
// 暂为手工快照;蓝图第 4 步落地后,由 scripts/journey 生成 journey.json
// 并在 CI 中校验与本文件一致,防止「改了脚本、首页还在展示旧输出」。
// 会话行的真实性约束:每一行都必须能在 src/journey/06-qemu-uart/ 或
// scripts/journey/06-qemu-uart.sh 中找到出处,不许手写编造。
// 术语:首页一律用「历程」(第几个历程),不再用「拍」。

export interface Stage {
  label: string
  title: string
  story: string
  link: string
  tier: 'ci' | 'manual'
}

export const STAGES: Stage[] = [
  { label: '第 1 个历程', title: '造机器', story: 'clone 下来先确认机器活着', link: '/journey/00-env-check', tier: 'ci' },
  { label: '第 2 个历程', title: '造程序', story: '看着源码一步步变成 ELF,再把它拆开看', link: '/journey/01-elf', tier: 'ci' },
  { label: '第 3 个历程', title: '治病', story: '程序被笔者弄坏了,printf 够不到病灶,GDB 出场', link: '/journey/02-gdb', tier: 'ci' },
  { label: '第 4 个历程', title: '程序长大', story: '改了头文件忘重编炸出 undefined reference,make 接管记账', link: '/journey/03-make', tier: 'ci' },
  { label: '第 5 个历程', title: '工程化', story: '库与应用分离,CMake 产出 compile_commands.json', link: '/journey/04-cmake', tier: 'ci' },
  { label: '第 6 个历程', title: '搬家', story: '宿主机二进制目标机跑不了,交叉编译', link: '/journey/05-cross', tier: 'ci' },
  { label: '第 7 个历程', title: '没有屏幕的机器', story: 'QEMU 给身体,串口开口说话,证据落袋', link: '/journey/06-qemu-uart', tier: 'ci' },
  { label: '第 8 个历程', title: '记录旅程', story: 'Git 与 Markdown,让旅程可复现、可交付', link: '/journey/07-git', tier: 'ci' },
  { label: '第 9 个历程', title: '编辑器接线', story: '把工具链接进 VS Code', link: '/journey/08-vscode', tier: 'ci' },
  { label: '尾声', title: '实验安全', story: '3.3V/5V、共地、静电、万用表三招', link: '/journey/91-lab-safety', tier: 'manual' },
]

// hero 终端会话 — 出处:scripts/journey/06-qemu-uart.sh + expected-serial.txt
// 注意:「journey beat 06: …」是真实串口输出的原文,不随首页术语调整而改。
export type SessionLine = {
  kind: 'cmd' | 'out' | 'dim' | 'stamp'
  text: string
  cont?: boolean // 上一条命令的续行
}

export const SESSION: SessionLine[] = [
  { kind: 'cmd', text: 'arm-none-eabi-gcc -nostdlib -T linker.ld startup.o main.o -o hello.elf' },
  { kind: 'cmd', text: 'timeout 5 qemu-system-arm -M mps2-an385 -cpu cortex-m3 -nographic \\' },
  { kind: 'cmd', text: '  -monitor none -kernel hello.elf', cont: true },
  { kind: 'out', text: 'hello, EmbedBox!' },
  { kind: 'out', text: 'journey beat 06: no OS, just UART (v0.6.0)' },
  { kind: 'cmd', text: 'diff -u expected-serial.txt serial.txt' },
  { kind: 'dim', text: '# 无输出 —— 串口捕获与仓库预存期望逐字节一致' },
  { kind: 'stamp', text: '[CI VERIFIED] scripts/journey/06-qemu-uart.sh · PASS' },
]

export const LEGACY_LINKS = [
  { text: '环境与终端', link: '/environment/' },
  { text: '协作与文档', link: '/collaboration/' },
  { text: '构建系统', link: '/build-system/' },
  { text: '调试', link: '/debugging/' },
  { text: '模拟与交叉', link: '/cross-compile/' },
]

export const ACTIONS_URL =
  'https://github.com/Awesome-Embedded-Learning-Studio/EmbedBox/actions'
