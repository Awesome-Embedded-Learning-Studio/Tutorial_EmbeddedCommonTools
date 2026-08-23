---
title: 拍 00 · 环境体检:先确认机器活着
order: 0
verify: scripts/journey/00-env-check.sh
tier: ci-matrix
verified-on: WSL2(Arch)/ bash 5.3 / git 2.55 / gcc 16.1.1 / make 4.4.1;CI 矩阵 ubuntu-latest + windows-latest
---

# 拍 00 · 环境体检:先确认机器活着

欢迎来到主线第一拍。咱们刚把这个仓库 clone 下来,接下来十拍,咱们会陪一个会打招呼的小程序走过它的一生——出生、生病、长大、搬家、进入一台没有屏幕的机器。但在那之前,有一件更朴素的事:**确认咱们手上这台机器,干得了这些活。**

这一拍没有任何新知识要背,目标只有一个:跑一份体检报告,读懂它,把缺的东西补上。

## 先得有一个能跑命令的地方

「终端」就是敲命令的地方。Linux 和 macOS 用户已经有了;Windows 用户请注意——嵌入式开发的主体生态在 Linux 侧,咱们不打算从第一天起就打游击,所以先给自己装一台 Linux:WSL2,Windows 官方的 Linux 子系统,开箱即用。在**管理员权限的 PowerShell** 里:

```bash
wsl --install -d Ubuntu
```

装完重启,从开始菜单打开 Ubuntu,咱们会得到一个真正的 bash。此后本书说的「终端」,对 Windows 用户而言默认指 WSL 里的这扇窗;裸装 Linux 的朋友,开终端模拟器就行。

然后在终端里,先熟悉三条最原始的口令——「我是谁、我在哪、这里有什么」:

```console
$ pwd
/home/you
$ ls
EmbedBox
$ cd EmbedBox
```

`pwd` 打印当前目录,`ls` 列出下面有什么,`cd` 走进去。就这三条,够咱们起步了。这一拍先不解释 shell 的更多花样,用到的时候咱们再学——工具永远是被问题逼出来的,这是全书的方法论。

## 跑体检

笔者给这一拍准备的「实验」不是代码,而是一份体检脚本,它就是本章的配对验证脚本:

```bash
bash scripts/journey/00-env-check.sh
```

在咱们刚 clone 下来的仓库根目录跑它。下面是笔者这台机器的真实输出(注意第一行——笔者自己也是在 WSL2 里干活的):

```text
──────── 机器与系统 ────────
Linux DESKTOP-65DBAA7 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC ... x86_64 GNU/Linux
bash 5.3.15(1)-release

──────── 必需工具(缺任何一个,体检就是红) ────────
  [ok] git      -> /usr/sbin/git
  [ok] gcc      -> /usr/sbin/gcc
  [ok] make     -> /usr/sbin/make

──────── 工具版本 ────────
git version 2.55.0
gcc (GCC) 16.1.1 20260728
GNU Make 4.4.1

──────── 建议工具(现在缺不要紧,后面的拍会用到再装) ────────
  [ok] gdb
  [ok] cmake
  [ok] arm-none-eabi-gcc
  [ok] qemu-system-arm
```

报告分三层,值得逐层读一遍。**机器与系统**告诉你内核和架构——后面拍 05 交叉编译时,「x86_64」这个字眼会变成故事的另一半。**必需工具**是全书的硬门槛:git(拉代码、记录旅程)、gcc(编译)、make(构建),缺任何一个,这一拍的体检就是红的。**建议工具**是后场的队员:gdb 拍 02 上场,cmake 拍 04,arm-none-eabi-gcc 和 qemu 拍 05/06——现在缺了完全不用慌。

缺什么就补什么。Ubuntu/Debian 用户一把梭:

```bash
sudo apt install build-essential gdb cmake
```

Arch 用户对号入座 `sudo pacman -S base-devel gdb cmake`;交叉工具链和模拟器到拍 05 前再装也来得及(Ubuntu:`sudo apt install gcc-arm-none-eabi qemu-system-arm`)。这里先不展开每个包是什么——它们各自的章节会亲自介绍自己。

## 顺便学会一件救命的小事:command not found

总有一天(大概率是今天晚上),咱们会敲出一个命令,终端冷冷回一句 `command not found`。别慌,三板斧:

第一斧,**它装了吗**:

```bash
which gcc
```

`which` 在 PATH 里找这个命令,找到了就打印它的位置,找不到就一声不吭。第二斧,**它在的地方 shell 知道吗**:

```bash
echo "$PATH"
```

PATH 是 shell 的寻人启事列表,冒号分隔的一串目录。命令明明装了却报 not found,九成是它所在的目录不在这串列表里——拍 05 装完交叉工具链、拍 08 配编辑器时,你还会再遇到这个局面。第三斧,**名字对吗**:拼写、大小写、连字符,以及「我以为我装了」的自我怀疑。这三斧会陪咱们穿过全书,也会陪咱们穿过之后所有的嵌入式生涯。

## 下一站

机器活了,工具在位,咱们现在两手空空——正好,下一拍咱们从一行代码开始,亲眼看着它变成一个能跑的程序,再把这个程序拆开,看看「可执行文件」的肚子里到底装了什么。
