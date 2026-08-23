---
title: 拍 02 · 程序病了:printf 够不到的地方
order: 2
verify: scripts/journey/02-gdb.sh
tier: ci-matrix
verified-on: WSL2(Arch)/ gcc 16.1.1 / gdb 17.2;CI 矩阵 ubuntu-latest + windows-latest
---

# 拍 02 · 程序病了:printf 够不到的地方

这一拍的病,是笔者亲手埋的。病人在 [src/journey/02-gdb/](https://github.com/Awesome-Embedded-Learning-Studio/EmbedBox/tree/main/src/journey/02-gdb/),先睹为快:

```c
/* 拍 02 的病号:越界读一颗,答案就歪了
 * 对应教程:tutorial/journey/02-gdb.md
 */
#include <stdio.h>

static int scale(int v, int factor)
{
    return v * factor;
}

int main(void)
{
    int data[4] = {1, 2, 3, 4};
    int total = 0;

    for (int i = 0; i <= 4; i++) {   /* 病根:<=,data[4] 不是我们的 */
        total += scale(data[i], 2);
    }
    printf("total = %d\n", total);
    return 0;
}
```

`data` 只有 4 个元素,循环却跑 5 次——`data[4]` 越界读了隔壁邻居的内存。数学好的朋友心算一下:正确答案应该是 `(1+2+3+4)×2 = 20`。那编译运行看看:

```bash
gcc -g -O0 -o buggy buggy.c
./buggy
```

```text
total = 20
```

**答案是对的。** 在笔者这台机器上,这次越界读到的恰好是个 0,乘什么都不影响总分——病得悄无声息。咱们那边可能是 42,可能是 -8,甚至直接崩:越界读没有任何合同保证,读到什么全凭内存布局的运气。这正是它比崩溃更可怕的地方:崩溃至少诚实。

现在问题来了:怎么**证明**第五次调用真的发生了、`v` 拿到的不是数组里的数?printf 无能为力——咱们不能在一个不存在的变量上插桩,而且插桩本身会改变程序。咱们需要的是:让程序停在任何一行,掀开它的现场。这就是 GDB。

顺带解释刚才编译命令里的两个选择:`-g` 让 gcc 把「行号、变量名、类型」这些调试信息织进二进制——没有它,gdb 看到的是一串无名地址;`-O0` 关掉优化,让机器码老老实实按源码顺序走。为什么优化是调试的大敌,这一拍结尾咱们会亲眼看到。

## 会话一:断点、现场、回溯

真实使用时,`gdb ./buggy` 进入交互式对话。为了让整个会话可以被 CI 逐字重放,这里用 `-batch` 加一串 `-ex`(把要敲的命令提前排队),效果完全一致:

```bash
gdb -q -batch -iex 'set debuginfod enabled off' ./buggy \
    -ex 'break scale' \
    -ex 'run' \
    -ex 'info args' \
    -ex 'bt'
```

```text
Breakpoint 1 at 0x1153: file buggy.c, line 8.
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/libthread_db.so.1".

Breakpoint 1, scale (v=1, factor=2) at buggy.c:8
8	    return v * factor;
v = 1
factor = 2
#0  scale (v=1, factor=2) at buggy.c:8
#1  0x00005555555551b4 in main () at buggy.c:17
```

逐行读这份成绩单。`Breakpoint 1 at 0x1153` 是 gdb 在 `scale` 入口放了哨兵;程序跑起来,第一次撞上哨兵,它把**整个现场**摆给咱们:`scale (v=1, factor=2)`——函数名、两个参数的值,一目了然,一行 printf 都不用加。`info args` 再把参数单独列一遍。最后的 `bt`(backtrace)是调用栈回溯:`#0` 是现在所处的 `scale`,`#1` 是谁叫它来的——`main` 的 `buggy.c:17`。栈帧从下往上读,就是「案发现场 ← 谁报的案」。

## 会话二:一路 continue,逼出第五次

断点只告诉咱们「第一次调用长这样」。现在连续放行四次,守到第五次:

```bash
gdb -q -batch -iex 'set debuginfod enabled off' ./buggy \
    -ex 'break scale' \
    -ex 'run' \
    -ex 'info args' \
    -ex 'continue' \
    -ex 'continue' \
    -ex 'continue' \
    -ex 'continue'
```

```text
Breakpoint 1, scale (v=1, factor=2) at buggy.c:8
...

Breakpoint 1, scale (v=2, factor=2) at buggy.c:8
...

Breakpoint 1, scale (v=3, factor=2) at buggy.c:8
...

Breakpoint 1, scale (v=4, factor=2) at buggy.c:8
...

Breakpoint 1, scale (v=0, factor=2) at buggy.c:8
```

第五次来了:**`v=0`**。可数组里只有 1、2、3、4——这个 0 不属于这个数组,它是边界外那位未知邻居的值。病根确诊:`i <= 4` 里的等号。把循环条件改回 `i < 4`,第五次调用就不会发生。顺便说一句,交互模式下咱们的日常三件套是 `next`(下一行,不进函数)、`step`(走进函数)、`print 变量名`(看任意表达式的值)——这三个词加上今天的 `break`/`continue`/`bt`,足够应付大多数现场。

## 会话三:watch,让数据变化自己举手

还有一招值得入袋:盯梢。`watch total` 给变量装上门铃,谁改它谁触发:

```bash
gdb -q -batch -iex 'set debuginfod enabled off' ./buggy \
    -ex 'break main' \
    -ex 'run' \
    -ex 'watch total' \
    -ex 'continue'
```

```text
Breakpoint 1, main () at buggy.c:12
12	{
Hardware watchpoint 2: total

Hardware watchpoint 2: total

Old value = 0
New value = 2
main () at buggy.c:16
16	    for (int i = 0; i <= 4; i++) {
```

`Old value = 0 → New value = 2`——第一圈循环把 total 从 0 写成了 2(1×2),连改动的位置都指给咱们看。怀疑某个变量被「神秘之手」改坏时,watch 是终审证据。(它叫 **Hardware** watchpoint,因为靠的是 CPU 的调试寄存器——将来在真板上调试,这个细节会再次出现。)

## 会话四:-O2,编译器和调试器打架

最后兑现开头的伏笔。用 `-O2` 编译同一个文件:

```bash
gcc -O2 -g -o buggy-o2 buggy.c
gdb -q -batch -iex 'set debuginfod enabled off' ./buggy-o2 \
    -ex 'break main' \
    -ex 'run' \
    -ex 'print total' \
    -ex 'print data'
```

```text
buggy.c: In function 'main':
buggy.c:17:18: warning: iteration 4 invokes undefined behavior [-Waggressive-loop-optimizations]
   17 |         total += scale(data[i], 2);
      |                  ^~~~~~~~~~~~~~~~~
buggy.c:16:23: note: within this loop
   16 |     for (int i = 0; i <= 4; i++) {
      |                     ~~^~~
...
$1 = <optimized out>
$2 = <optimized out>
```

两个惊喜。其一,编译器自己拉响了警报:`iteration 4 invokes undefined behavior`——「第 4 次迭代(即 i=4 那次)行为未定义」。越界读属于未定义行为(UB),编译器有权做任何假设,-O2 下它看得更远,直接警告咱们。这也是拍 03 会把 `-Wall -Wextra` 写进 Makefile 的原因:警告是免费的第一道防线。其二,进了 gdb,`print total` 和 `print data` 都回一句 `<optimized out>`——优化器认为这些变量没必要在内存里留位置,直接扔进了寄存器或者干脆重排了。**不是 gdb 坏了,是它要观察的对象被优化掉了。** 所以业界的节奏是:调试期 `-O0 -g`,复现并修完,再换 `-O2` 验证——而不是对着一份优化过的二进制抱怨调试器不灵。

## 这一拍咱们带走了什么

gdb 五件套:`break`、`run`/`continue`、`info args`/`print`、`bt`、`watch`;两枚心法:现场比猜测值钱、调试用 `-O0`。还有一个正式登场的词:**undefined behavior**——它不是「崩一下」的意思,是「从此没有任何保证」的意思。

最后留个伏笔:这一整套断点、单步、观察,都发生在「本机进程」上。将来在拍 06,程序会住进另一台(虚拟的)机器,那时 gdb 只需要一句 `target remote`,就能隔着一条串口线把这一切原样搬过去——咱们在真板上调试 STM32 时用的 OpenOCD,本质就是那根线另一头的接线员。

## 下一站

病好了,但主角还是只会说一句话、只有一个文件。下一拍,让它长大——然后咱们会发现,长大本身会带来新的事故。
