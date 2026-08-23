---
title: 第 9 个历程 · 编辑器接线:让 VS Code 认识咱们的工具链
order: 8
verify: scripts/journey/08-vscode.sh
tier: manual
verified-on: 机械部分(配置存在性/JSON 合法性/任务链解析)由脚本验证;编辑器交互项见正文清单,待首次人工走查后回填
---

# 第 9 个历程 · 编辑器接线:让 VS Code 认识咱们的工具链

这个历程**不教编辑器**。VS Code 的教程满山遍野,不缺这一本。它教的是一件小得多也重要得多的事:**把前八个历程学会的工具——gcc、CMake、gdb——接进编辑器**,让「按一个键」背后跑的还是咱们认识的那几条命令。工具永远比 IDE(集成开发环境——把编辑器、构建、调试装进同一个壳的软件,VS Code、Keil、STM32CubeIDE 都是)重要,这是咱们在第 1 个历程 就立下的世界观;这个历程只是让世界观过得舒服点。

编辑器交互没法无人值守重放,所以本历程是全书唯一 `tier: manual` 的一个历程——配对脚本负责机械部分(配置文件存在、JSON 合法、任务链完整),真正的「红线消失、断点命中」需要咱们亲手走一遍,正文末有一张清单。

## 病症:满屏红线

拿第 5 个历程 的 CMake 工程用 VS Code 打开——命令是在 WSL 里敲 `code .`(用 VS Code 打开当前目录;Windows 用户先装 Remote-WSL 扩展,让 Windows 上的 VS Code 隔着一条缝操作 WSL 里的文件与终端)——多半会看到熟悉的病症:代码能编译,编辑器却满屏红线,`#include "util.h"` 报「找不到头文件」,跳转到定义时灵时不灵。原因一句话就能说清:**IntelliSense 不是编译器,它只是在一遍遍猜咱们的编译视角**——猜错了视角,猜出来的世界自然是错的。而猜,本可以不必猜。

## 第一根线:compile_commands.json

还记得第 5 个历程 里那句 `set(CMAKE_EXPORT_COMPILE_COMMANDS ON)` 吗?当时说它在 `build/` 里留了一枚「给编辑器的名片」。现在把名片递过去——在工程根目录的 `.vscode/settings.json` 里:

```json
{
  "C_Cpp.default.compileCommands": "${workspaceFolder}/build/compile_commands.json",
  "files.associations": {
    "*.h": "c"
  },
  "editor.insertSpaces": true,
  "editor.tabSize": 4
}
```

关键的只有第一行:告诉 C/C++ 扩展,**每个文件怎么编译,以这份 JSON 清单为准**——哪个编译器、什么标准、哪些 include 路径,全部来自构建系统的真实视角,不再靠猜。`${workspaceFolder}` 是个占位符,展开成「当前打开的工程根目录」,和 shell 里 `./` 指脚边是同一种亲切。红线通常在这一行落笔后当场消退;`greet` 跳到定义、悬停看签名,也都顺了。其余三行是舒适度配置(把 `.h` 识破成 C 而不是 C++,空格缩进四格)。

需要装的东西就一件:C/C++ 扩展(ms-vscode.cpptools,扩展面板搜 `ms-vscode.cpptools` 装第一个就是)。Windows 用户在 Remote-WSL 模式下,扩展要装在 **WSL 侧**(扩展面板会分区提示),这一点装错了是经典坑。

## 第二根线:一键构建

编辑器的「运行」按钮背后应该是咱们自己的构建命令。`.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "cmake-build",
      "type": "shell",
      "command": "cmake --build build",
      "group": { "kind": "build", "isDefault": true },
      "problemMatcher": ["$gcc"]
    }
  ]
}
```

`command` 一栏就是咱们在第 5 个历程 敲过的那条 `cmake --build build`,一个字没改——现在它绑在了 `Ctrl+Shift+B` 上。`problemMatcher` 让 gcc 的报错变成编辑器里可点击跳转的条目。**IDE 的构建按钮不是魔法,是咱们自己那条命令的马甲**;理解这一点的人,换任何 IDE 都能在五分钟内配好构建。

## 第三根线:F5 就是 gdb

最后把第 3 个历程 的 gdb 接到 F5 上。`.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "(gdb) hello",
      "type": "cppdbg",
      "request": "launch",
      "program": "${workspaceFolder}/build/hello",
      "args": [],
      "stopAtEntry": false,
      "cwd": "${workspaceFolder}",
      "environment": [],
      "externalConsole": false,
      "MIMode": "gdb",
      "preLaunchTask": "cmake-build"
    }
  ]
}
```

逐行认亲:`MIMode: gdb`——调试器就是第 3 个历程 那位,断点、单步、变量窗,底下全是同一套 gdb;`preLaunchTask` 指回上一节的 `cmake-build`,F5 = 先构建、再调试;`program` 指向第 5 个历程 的产物 `build/hello`;`cwd` 是程序启动时所在的目录,相当于先替它 `cd` 过去。在 `main.c` 的 `greet("EmbedBox")` 那行点一下行号左侧设断点,按 F5——构建日志滚过,程序停在断点上,单步走进 `greet`,参数 `who` 的值在变量窗里排排坐。**咱们在第 3 个历程 用命令行做过的一切,现在有了图形界面,但没有一层魔法。**

再往前看一步:`launch.json` 里再配一个 `target remote`(或装上 Cortex-Debug 扩展指向 OpenOCD),F5 就能调试第 7 个历程 那样的板子——接线方式和咱们已经会的完全一致。

## 收束全书:体检,然后出发

三根线接完,编辑器认识的不再是「一堆文本」,而是**咱们的**工具链。这也是全书的收束时刻。回望一遍咱们走过来的路:确认机器活着(第 1 个历程),看程序出生、拆开它的肚子(第 2 个历程),治好一场 printf 够不到的病(第 3 个历程),让它长大并学会记账(第 4/5 个历程),搬去另一个架构(第 6 个历程),在没有操作系统、没有屏幕的机器上亲口说话、留下证据(第 7 个历程),把旅程记录成可回溯的历史(第 8 个历程),最后把这一切接进日常的椅子(第 9 个历程)。

**从 clean clone 到可追溯的串口证据——这条 community 计划书里的主线,咱们已经完整走通。** 剩下的问题只有一个:接下来去哪。

分流口就在眼前:想把语言基本功打深,

去 [C-Journey](https://github.com/Awesome-Embedded-Learning-Studio/C-Journey)(C 语言承重墙)和 [Tutorial_AwesomeModernCPP](https://github.com/Awesome-Embedded-Learning-Studio/Tutorial_AwesomeModernCPP)(现代 C++)

想理解程序之上的系统,去 [PenguinLab](https://github.com/Awesome-Embedded-Learning-Studio/PenguinLab)(Linux 内核实验)和 [Tutorial_FreeRTOS](https://github.com/Awesome-Embedded-Learning-Studio/Tutorial_FreeRTOS)

想上真硬件,去 [ST-Forge](https://github.com/Awesome-Embedded-Learning-Studio/ST-Forge)(STM32 主教学线——咱们的 Cortex-M 经验直接复用)和 [imx-forge](https://github.com/Awesome-Embedded-Learning-Studio/imx-forge)(Embedded Linux 入口)。

无论去哪,第一件事仍然是第 1 个历程 那份体检——工具永远比 IDE 重要,旅程永远从确认机器活着开始。
