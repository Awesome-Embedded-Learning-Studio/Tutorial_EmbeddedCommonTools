---
title: 尾声 A · 物理串口:接上真线的那天
order: 90
tier: manual
verified-on: 待人工回填(需 USB-TTL 转接器与目标板;本章命令不在 CI 重放范围)
---

# 尾声 A · 物理串口:接上真线的那天

拍 06 里,串口是 QEMU 递到咱们终端上的一行行文字。真硬件上,串口是一根**真实的线**:三根杜邦线、一块几十块的 USB-TTL 转接器,和咱们从数据手册里查出来的引脚。这一篇是拿到第一块板子那天的操作指南——命令都不复杂,但每一条都需要真硬件在场,所以它是 `manual` 级:CI 不重放,断言换成人眼和终端本身。

## 行前准备

买一块 USB-TTL 串口转接器(CH340、CP2102、FT232 方案的都行,几块到几十块钱),注意选**3.3V 电平**或带电平跳线的型号。然后查目标板的引脚图,找到三个脚:TX(发送)、RX(接收)、GND(地)。接线只有一条纪律加一个口诀:纪律是 **GND 必须接**——没有共同的地,电平无从谈起;口诀是**TX 接 RX,交叉相接**——这边的嘴对那边的耳朵,那边的嘴对这边的耳朵,接成环就谁也听不见谁。

## 把线插进系统

转接器插上电脑的 USB 口。Linux(含 WSL2——USB 串口设备默认不进 WSL,需要在 Windows 侧用 `usbipd` 转发,或直接在 Windows 里用)上,先问内核「你看到新东西了吗」:

```bash
dmesg | tail
```

```text
[12345.678901] ch341-uart ttyUSB0: break control not supported, using simulated break
[12345.678912] usb 1-2: ch341 adapter now disconnected from ttyUSB0
```

(示意输出;看到 `ttyUSB0` 字样就是它。)设备节点在 `/dev/ttyUSB0`——拍 00 讲过的「一切皆文件」,串口也是一个。确认一下:

```bash
ls /dev/ttyUSB*
```

第一次打开它,咱们多半会撞上 `Permission denied`:串口设备属于 `dialout` 组,咱们不在组里。把自己加进去(一次性动作,重新登录生效):

```bash
sudo usermod -aG dialout $USER
```

这是 Linux 嵌入式的第一道成人礼,几乎每个人都撞过一次。

## 听它说话

最朴素的听法,连工具都不用装:

```bash
stty -F /dev/ttyUSB0 115200 cs8 -cstopb -parenb -echo
cat /dev/ttyUSB0
```

`stty` 把这根线配置成嵌入式最典型的参数:115200 波特、8 数据位、1 停止位、无校验(这句口诀咱们会在无数板子的文档里再见到)。然后 `cat`——把设备当文件读,板子说的每个字节都会滚上咱们的终端。按板子的复位键,启动日志哗哗流出来的那一刻,和拍 06 里 QEMU 上电的那一幕,是同一个瞬间。

日常顺手的工具是 `picocom` 或 `minicom`(以 picocom 为例,`picocom -b 115200 /dev/ttyUSB0`,退出是 `Ctrl-A` 再 `Ctrl-X`);Windows 侧则是设备管理器里认领一个 COM 口号,用 PuTTY 的 Serial 模式连它。

## 从这里出发

物理串口一通,咱们就有了板子的「stdout + stderr + 救命稻草」:启动日志、panic 栈、bootloader 交互,全从这根线来。接下来去 [ST-Forge](https://github.com/Awesome-Embedded-Learning-Studio/ST-Forge),那里有真板、真烧录、真调试的完整路线;想看这根线上跑的电平波形长什么样,去 [Tutorial_AwesomeHardware](https://github.com/Awesome-Embedded-Learning-Studio/Tutorial_AwesomeHardware) 的示波器与逻辑分析仪章节——那是硬件深水区,与本篇的边界就在这里。
