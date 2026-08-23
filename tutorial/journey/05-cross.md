---
title: 第 6 个历程 · 搬家:交叉编译
order: 5
verify: scripts/journey/05-cross.sh
tier: ci-linux
verified-on: WSL2(Arch)/ gcc 16.1.1 + Arm GNU Toolchain arm-none-eabi-gcc;CI:ubuntu-latest(apt 装 gcc-arm-none-eabi)
---

# 第 6 个历程 · 搬家:交叉编译

程序在宿主机上活得很滋润,但它的命运是住进一台小板子。这个历程咱们给它搬家——结果会是一颗造好却暂时无处安放的心脏,以及一个重要的世界观:**「可执行文件」从来不是一种通用货币,它是特定架构的方言。**

动手地点是 src/journey/05-cross/。源码和上一个历程几乎一样(greet + version,版本跳到 v0.5.0)——**搬家不该惊动住户**。需要新工具:`arm-none-eabi-gcc`(第 1 个历程 体检里「建议工具」的那位,Ubuntu 用户 `sudo apt install gcc-arm-none-eabi`,Arch 用户 `sudo pacman -S arm-none-eabi-gcc`)。您把工具装好,咱们就发车。

## 先认清编译器的身世

咱们马上要拥有两个长得一模一样的 gcc,先问清它们各自为谁工作:

```bash
gcc -dumpmachine
```

得到的是——

```text
x86_64-pc-linux-gnu
```

我们再走：

```bash
arm-none-eabi-gcc -dumpmachine
```

继续拿到：

```text
arm-none-eabi
```

这串叫**目标三元组**(target triplet),是编译器出厂时就烙好的身份:「我生成的代码,给这类机器用」。宿主机 gcc 面向 x86_64 Linux。

`arm-none-eabi` 拆开读就是一份自我介绍:**arm** 是 ARM 架构——所谓架构,就是一套 CPU 认识的指令方言,第 2 个历程 咱们看过的 `pushq`、`%rbp` 那些拼写是 x86 的方言,ARM 是另一套,同一段 C 翻过去,拼出来完全两样;**none** 是「没有操作系统」(裸机),**eabi** 是 ARM 家调用约定的一个版本(调用约定就是「参数从哪递、返回值放哪」的家规)。

编译器本身都是跑在咱们桌面上的 x86 程序——区别只在它**吐出的代码给谁跑**，理解这个，你就理解了交叉编译的概念。给别的架构生成代码,这就叫交叉编译。干这活的工具链,叫交叉工具链。

## 搬家实操

流程和第 2 个历程 的四棒接力完全同构,只是每一棒都换了人:

```bash
arm-none-eabi-gcc -c main.c -o main.o
arm-none-eabi-gcc -c util.c -o util.o
```

```bash
arm-none-eabi-gcc main.o util.o --specs=rdimon.specs -o hello.elf
```

链接这行多出的 `--specs=rdimon.specs` 值得一句解释。咱们的程序用了 `printf`,而 printf 是 C 库的函数——宿主机上,这个 C 库是 glibc,它收下咱们要打的字之后,还得亲自去请 Linux 内核把字写到屏幕上(这趟「请内核办事」的申请,行话叫系统调用,syscall)。

可裸机的世界里没有操作系统,`arm-none-eabi` 工具链配的是面向裸机的精简 C 库 **newlib**,它把「往哪输出」这个问题留了空位。`rdimon`(半主机,semihosting)是一种补位方案:让调试器或模拟器**替**目标机代劳这些请求。它是权宜之计,不是归宿——第 7 个历程 咱们会让程序真正自己开口。

现在验证搬家是否成功。用第 2 个历程 的老朋友 `objdump -f`,同一份 `main.c`,两个世界:

```bash
gcc -c main.c -o main-host.o
objdump -f main-host.o
```

```text

main-host.o:     file format elf64-x86-64
architecture: i386:x86-64, flags 0x00000011:
HAS_RELOC, HAS_SYMS
start address 0x0000000000000000
```

```bash
arm-none-eabi-objdump -f main.o
```

```text

main.o:     file format elf32-littlearm
architecture: armv4t, flags 0x00000011:
HAS_RELOC, HAS_SYMS
start address 0x00000000
```

同一份源码,一份是 `elf64-x86-64`,一份是 `elf32-littlearm`——32 位(CPU 一次能啃的字宽,比宿主机的 64 位窄一半)、小端、ARM 指令集。

小端(little-endian)是「多字节数据在内存里低位字节排在前」的排法,它的反面叫大端;好在这套工具链和 x86 一样默认小端,咱们暂时不用换脑子——知道世上存在另一种排法就行。再看最终产物的「户口本」。

这行命令里有两样新机关:竖线 `|` 叫管道,把左边命令的输出直接接到右边命令的输入上——`readelf` 吐出的长篇户口,整卷递给 `grep` 过筛;而 `grep -E` 表示按正则表达式匹配,`Class|Machine` 里的竖线是「或」,只放行带这两个词的行:

```bash
arm-none-eabi-readelf -h hello.elf | grep -E 'Class|Machine'
```

```text
  Class:                             ELF32
  Machine:                           ARM
```

顺带一提,`armv4t` 是工具链不指定时的默认底档;下一个历程咱们会用 `-mcpu=cortex-m3` 精确点名 CPU,拿到 Thumb-2 这类现代指令集。

## 裸字节:从 ELF 里抠出 .bin

第 2 个历程 说过,ELF 是给**工具**看的容器——里面有段表、符号表、调试信息。但板子上的烧录器(把字节写进板子闪存的那支笔)只认一样东西:从某个地址开始,一字节一字节的裸机器码。`objcopy` 负责把容器拆掉,只取干货:

```bash
arm-none-eabi-objcopy -O binary hello.elf hello.bin
ls -l hello.elf hello.bin
```

```text
-rwxr-xr-x 1 charliechen charliechen  62048 Aug 23 14:43 hello.bin
-rwxr-xr-x 1 charliechen charliechen 377580 Aug 23 14:43 hello.elf
```

`.bin` 比 `.elf` 小了一个数量级——容器确实占地方。不过 62KB 对将来的小板子来说仍然太富态:那是半主机后端拖家带口的结果。等下一个历程程序亲自负责输出,镜像会轻装得多。

## 现在试试跑它

```text
scripts/journey/05-cross.sh: line 74: ./hello.elf: cannot execute binary file: Exec format error
```

这是宿主机 shell 的原话:`Exec format error`——**格式不符,拒绝执行**。x86 的内核读不懂 ARM 的 ELF,这不是 bug,是架构的巴别塔。心脏造好了,检验合格,但它还没有身体。
