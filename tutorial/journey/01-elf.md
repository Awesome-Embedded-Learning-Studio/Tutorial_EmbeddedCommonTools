---
title: 拍 01 · 源码→程序:看着它变,再拆开看
order: 1
verify: scripts/journey/01-elf.sh
tier: ci-matrix
verified-on: WSL2(Arch)/ gcc 16.1.1;CI 矩阵 ubuntu-latest + windows-latest
---

# 拍 01 · 源码→程序:看着它变,再拆开看

主角出场了。它现在是这个样子,一行 `hello.c`,住在 [src/journey/01-elf/](https://github.com/Awesome-Embedded-Learning-Studio/EmbedBox/tree/main/src/journey/01-elf/):

```c
/* 拍 01 出生、拍 02 病愈的主角,目前只有一个文件
 * 对应教程:tutorial/journey/01-elf.md
 */
#include <stdio.h>

int main(void)
{
    printf("hello, EmbedBox!\n");
    return 0;
}
```

一行命令就能让它跑起来:

```bash
gcc hello.c -o hello
./hello
```

```text
hello, EmbedBox!
```

跑起来了,然后呢?如果咱们此刻的心情是「能跑就行」,那这一拍就是为咱们准备的——因为**`gcc` 这一个命令里,其实住着四个工具**,它们接力把文本变成了机器码。接下来咱们把这四棒拆开,一棒一棒亲眼看。

## 四棒接力:预处理器、编译器、汇编器、链接器

### 第一棒:预处理器

`-E` 让 gcc 在预处理之后立刻停下,把结果吐成 `.i` 文件:

```bash
gcc -E hello.c -o hello.i
wc -l hello.i
```

```text
848 hello.i
```

一行 `#include` 变成了八百多行。看看开头:

```bash
head -12 hello.i
```

```text
# 0 "hello.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3
# 0 "<command-line>" 2
# 1 "hello.c"



# 1 "/usr/include/stdio.h" 1 3
# 28 "/usr/include/stdio.h" 3
# 1 "/usr/include/bits/libc-header-start.h" 1 3
```

预处理器干的事朴素得可爱:**把 `#include` 的文件原样抄进来,把 `#define` 的名字换成值**。那些 `# 1 "..."` 行是行号标记,告诉编译器「接下来这段来自哪个文件第几行」——以后咱们看到编译报错指向头文件深处,靠的就是它们指的路。咱们的 hello.c 本体,在这八百多行的最末尾。

### 第二棒:编译器

`-S` 停在汇编之后,产出 `.s`:

```bash
gcc -S hello.c
```

看看 `main` 部分(咱们用 `grep` 先定位它在第几行):

```bash
grep -n 'main:' hello.s
```

```text
9:main:
```

```text
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
```

停一下,这里有个彩蛋:**咱们明明写的是 `printf`,汇编里却是 `call puts@PLT`。** 这是编译器干的好事——`printf("...\n")` 这种单参数、以换行结尾的调用,输出效果和 `puts` 一模一样,而 `puts` 更快(不用解析格式串)。编译器在 `-O0` 下也会做这类小替换。这个细节顺便提醒咱们:汇编层看到的才是真相,源码只是愿望。那些 `.cfi_*` 是调试 unwind 信息的骨架,现在可以无视。

### 第三棒:汇编器

`-c` 停在汇编之后,产出目标文件 `.o`:

```bash
gcc -c hello.c
objdump -f hello.o
```

```text

hello.o:     file format elf64-x86-64
architecture: i386:x86-64, flags 0x00000011:
HAS_RELOC, HAS_SYMS
start address 0x0000000000000000
```

现在它已经是货真价实的机器码了,但注意 flags 里那个 **`HAS_RELOC`**:「含有待重定位项」。翻译成人话:这份机器码里还有一堆空位,等着链接器把最终地址填进去。start address 是 0——它自己都不知道自己将来会被放到内存的哪里。

再看看它随身带的账本,符号表:

```bash
nm hello.o
```

```text
0000000000000000 T main
                 U puts
```

两行,但信息量巨大。`T main`:我定义了函数 `main`,它在代码段(Text)。`U puts`:我**用了** `puts`,但它的实现不在我这——`U` 是 Undefined,一张借条。这个借条/欠条的意象请记牢,两拍之后它会变成一次真实的爆炸。

### 第四棒:链接器

```bash
gcc hello.o -o hello
objdump -f hello
```

```text

hello:     file format elf64-x86-64
architecture: i386:x86-64, flags 0x00000150:
HAS_SYMS, DYNAMIC, D_PAGED
start address 0x0000000000001040
```

对比 `.o`:flags 变了——`HAS_RELOC` 没了,换来 `DYNAMIC`(动态链接)和 `D_PAGED`(按页布局);start address 从 0 变成了 `0x1040`,链接器已经决定好它住哪了。链接器做的事,就是把 `hello.o` 的借条和 C 库的欠条对上账,把那些待重定位的空位填成真地址。跑一下,它活着:

```bash
./hello
```

```text
hello, EmbedBox!
```

## 拆开看:可执行文件是一个数据结构

「可执行文件」听起来高深,其实它就是一个格式约定的数据结构——ELF(Executable and Linkable Format)。`readelf` 能把它掀开:

```bash
readelf -S hello
```

```text
  [12] .text             PROGBITS         0000000000001040  00001040
  [14] .rodata           PROGBITS         0000000000002000  00002000
  [25] .data             PROGBITS         0000000000004008  00003008
  [26] .bss              NOBITS           0000000000004018  00003018
```

这里节选了最要紧的四段。`.text` 是代码,只读;`.rodata` 是只读数据——咱们那句 `"hello, EmbedBox!\n"` 字符串就住在这里;`.data` 是有初值的全局/静态变量;`.bss` 最有意思,类型是 **NOBITS**——不占文件一字节,因为「初值为 0 的变量」没必要存,程序启动时内存里划一块零就行。这四个名字,`.text`/`.data`/`.bss`,是嵌入式的通行证:将来咱们在链接脚本里亲手给它们安排地址时(拍 06),今天的这一眼就是全部前置知识。

还能反汇编看自己程序的机器码:

```bash
objdump -d hello
```

```text
0000000000001139 <main>:
    1139:	55                   	push   %rbp
    113a:	48 89 e5             	mov    %rsp,%rbp
    113d:	48 8d 05 c0 0e 00 00 	lea    0xec0(%rip),%rax        # 2004 <_IO_stdin_used+0x4>
    1144:	48 89 c7             	mov    %rax,%rdi
    1147:	e8 e4 fe ff ff       	call   1030 <puts@plt>
    114c:	b8 00 00 00 00       	mov    $0x0,%eax
    1151:	5d                   	pop    %rbp
    1152:	c3                   	ret
```

左列是地址,中间是机器码字节,右列是反汇编。和刚才 `.s` 里的 `main` 长得像——本来就是同一段逻辑,只是现在每条指令有了确定的门牌号。最后看个体积报表:

```bash
size hello
```

```text
   text	   data	    bss	    dec	    hex	filename
   1411	    584	      8	   2003	    7d3	hello
```

`.text` 加上 `.rodata` 等,一共 1411 字节——在宿主机上这点体积无人在意;但请记住这个看体积的习惯,等咱们搬去只有几十 KB 内存的小板子,每一行这个报表都是钱。

## 这一拍咱们带走了什么

四棒接力:预处理器(抄写员)→ 编译器(翻译官)→ 汇编器(打包员)→ 链接器(对账人)。三件随身工具:`objdump -f` 看格式与架构,`nm` 看符号账本,`readelf -S` 看段落布局。四个段名:`.text`/`.rodata`/`.data`/`.bss`。还有两个伏笔:符号表里的 `U`(借条)会在拍 03 炸出 `undefined reference`;段布局会在拍 06 被咱们亲手写进链接脚本。

## 下一站

程序健康地活着,只会说一句话。下一拍,咱们把它弄坏——认真地、蓄意地弄坏——然后请出嵌入式生涯里最重要的搭档之一:GDB。
