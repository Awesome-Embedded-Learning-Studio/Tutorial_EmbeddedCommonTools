---
title: 第 2 个历程 · 源码→程序:看着它变,再拆开看
order: 1
verify: scripts/journey/01-elf.sh
tier: ci-matrix
verified-on: WSL2(Arch)/ gcc 16.1.1;CI:ubuntu-latest
---

# 第 2 个历程 · 源码→程序:看着它变,再拆开看

主角出场了。它现在是这个样子,一行 `hello.c`。您找到的方式是这样的，请回到当时克隆的EmbedBox上，然后

```shell
[charliechen@DESKTOP-65DBAA7 EmbedBox]$ cd src/journey/01-elf
[charliechen@DESKTOP-65DBAA7 01-elf]$ ls
hello.c
```

`ls` 的意思很简单，就是列出来有什么，咱们这个目录就是一个hello.c。下一步是打开这个文件看看——终端里的「打开」不弹新窗口，用的命令叫 `cat`，它把文件内容整个倒在屏幕上，像把一张纸摊开在咱们面前：

```shell
[charliechen@DESKTOP-65DBAA7 01-elf]$ cat hello.c
```

得到的是。
```c
/* 第 2 个历程 出生、第 3 个历程 病愈的主角,目前只有一个文件
 * 对应教程:tutorial/journey/01-elf.md
 */
#include <stdio.h>

int main(void)
{
    printf("hello, EmbedBox!\n");
    return 0;
}
```

这里笔者得先立个假设：咱们学过最简单的C语言。真的没有的话，把上面这段代码丢给喜欢的AI问一嘴，一分钟的事。然后，一行命令就能让它跑起来:

```bash
gcc hello.c -o hello && ./hello
```

```text
hello, EmbedBox!
```

跑起来了。先别急着往下一屏冲，这行命令本身就值得拆一拆——全书咱们都要跟它打交道。`gcc hello.c` 是主体：把源文件交给 gcc；`-o hello` 给产物起名字，`o` 就是 output，不写的话 gcc 默认管它叫 `a.out`，一个来历不明的名字。

中间的 `&&` 是「成了再跑」：左边成功，右边才执行——编译要是失败，`./hello` 压根不会跑，免得咱们捧着上次留下的旧文件空欢喜。至于 `./hello` 的 `./`，第 1 个历程里那串 PATH 咱们还有印象：shell 找命令只翻那串目录，当前目录不在名单上，想运行「就在脚边」的这个程序，就得指名道姓，`./` 的意思就是「当前目录下的这个」。

拆完这行命令,然后呢?如果咱们此刻的心情是「能跑就行」,那这个历程就是为咱们准备的——因为 **`gcc` 这一个命令里,其实住着四个工具**, 它们接力把文本变成了机器码——CPU 唯一肯吃的东西。接下来咱们把这四棒拆开,一棒一棒亲眼看。

## 四棒接力:预处理器、编译器、汇编器、链接器

### 第一棒:预处理器

`-E` 让 gcc 在预处理之后立刻停下,把结果吐成 `.i` 文件。顺手用 `wc -l` 数一数行数——`wc` 是 word count,`-l` 让它数行:

```bash
gcc -E hello.c -o hello.i
wc -l hello.i
```

```text
848 hello.i
```

一行 `#include` 变成了八百多行。看看开头——`head -12` 就是「只取头 12 行」,八百多行没必要全看:

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

预处理器干的事朴素到令人感到好玩和可爱:**把 `#include` 的文件原样抄进来,把 `#define` 的名字换成值**。那些 `# 1 "..."` 行是行号标记,告诉编译器「接下来这段来自哪个文件第几行」——以后咱们看到编译报错指向头文件深处,靠的就是它们指的路。咱们的 hello.c 本体,在这八百多行的最末尾。

### 第二棒:编译器

看汇编之前,得先垫一句话,不然下一屏对咱们就是纯天书。CPU 不认识 C,它只吃机器码——每条指令在它眼里就是几个二进制字节,后面咱们会亲眼看到,这段 `main` 的开头四个字节是 `55 48 89 e5`。**汇编**就是机器码的人话版:一条汇编指令几乎一比一地对应一段机器码字节,给二进制起了名字——`mov` 是搬,`call` 是喊人。第二棒干的就是「C → 汇编」这一跳,产出的 `hello.s`,是离 C 很远、离 CPU 很近的文字。咱们不需要全读懂,认得它就够了。

`-S` 停在汇编之后,产出 `.s`。这次没写 `-o`,`hello.s` 也会自己落在当前目录——`.s` 和 `.o` 这两棒都有默认产物名,而 `-E` 的默认是把结果直接吐到屏幕上,所以第一棒咱们老老实实写了 `-o hello.i`:

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

这一屏允许咱们看不懂大半——笔者第一次正经读汇编,也是头皮发麻。抓住两样东西就够:`%rbp` `%rsp` `%rax` `%rdi` 这些带 `%` 的名字是**寄存器**,CPU 肚子里屈指可数的几个超高速小格,变量想参与运算,得先搬进这些格子;`pushq` `movq` `leaq` `call` 这些打头的是**指令**,即动作本身——存一下、搬一下、算个地址、跳过去喊人。写 C 不需要会写汇编,但混个脸熟很值:嵌入式调到深处,经常只剩汇编肯跟咱们说话。

停一下,这里有个彩蛋:**咱们明明写的是 `printf`,汇编里却是 `call puts@PLT`。** 这是编译器干的好事——`printf("...\n")` 这种单参数、以换行结尾的调用,输出效果和 `puts` 一模一样,而 `puts` 更快(不用解析格式串)。`-O0` 是 gcc 的优化档位,数字越大,编译器越敢自作主张地改写咱们的代码;`-O0` 是「一个字都别动」的最低档——连最低档它都要做这类小替换,往后走进 `-O2` 的世界,咱们心里要有数。

这个细节顺便提醒咱们:汇编层看到的才是真相,源码只是愿望。那些 `.cfi_*` 是调试 unwind 信息的骨架,现在可以无视;`@PLT` 这个后缀也先按下不表,第四棒它会自己现身。

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

现在它已经是货真价实的机器码了,但注意 flags 里那个 **`HAS_RELOC`**:「含有待重定位项」。翻译成人话:这份机器码里还有一堆空位,等着链接器（您可以叫他代码的整合器）把最终地址填进去。start address 是 0——它自己都不知道自己将来会被放到内存的哪里。

再看看它随身带的账本,符号表:

```bash
nm hello.o
```

```text
0000000000000000 T main
                 U puts
```

两行,但信息量巨大。`T main`:我定义了函数 `main`,它在代码段(Text)。`U puts`:我**用了** `puts`,但它的实现不在我这——`U` 是 Undefined,一张借条。这个借条/欠条的意象请记牢,两个历程之后它会变成一次真实的爆炸。

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

对比 `.o`:flags 变了——`HAS_RELOC` 没了,换来 `DYNAMIC`(动态链接)和 `D_PAGED`(按页布局);start address 从 0 变成了 `0x1040`,链接器已经决定好它住哪了。

「C 库」和「动态链接」这两个词,笔者前面都是一带而过,这里兑现。**C 库**(常叫 libc)是操作系统自带的零件库,`printf`、`puts` 这些常用函数的实现全住在里面——`#include <stdio.h>` 抄进来的只是说明书,实现本体从来不在咱们的文件里。于是那张 `U puts` 的借条怎么还,链接器有两种还法:把用到的实现整段抄进 `hello`,文件变大,但从此独立生活,这叫静态链接;或者只在 `hello` 里登记一个门牌,运行时再去系统里的 libc 搭伙,这叫动态链接。gcc 在 Linux 上默认走后者,这就是 `DYNAMIC` 的来历——`hello` 里其实**没有** `puts` 的机器码,`call puts@PLT` 里那个前面按下不表的 `@PLT`,就是门牌本身:一小段跳板代码,程序跑到这里,先顺藤摸瓜找到 libc 里的真身,再跳过去。等到第 7 个历程 上裸机、没有 libc 可搭伙,咱们会亲手体会这两种还法的差别。

链接器做的事,就是把 `hello.o` 的借条和 C 库的欠条对上账,把那些待重定位的空位填成真地址。跑一下,它活着:

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

这里节选了最要紧的四段。`.text` 是代码,只读;`.rodata` 是只读数据——咱们那句 `"hello, EmbedBox!\n"` 字符串就住在这里;`.data` 是有初值的全局/静态变量;`.bss` 最有意思,类型是 **NOBITS**——不占文件一字节,因为「初值为 0 的变量」没必要存,程序启动时内存里划一块零就行。这四个名字,`.text`/`.data`/`.bss`,是嵌入式的通行证:将来咱们在链接脚本里亲手给它们安排地址时(第 7 个历程),今天的这一眼就是全部前置知识。

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

## 这个历程咱们带走了什么

四棒接力:预处理器(抄写员)→ 编译器(翻译官)→ 汇编器(打包员)→ 链接器(对账人)。三件随身工具:`objdump -f` 看格式与架构,`nm` 看符号账本,`readelf -S` 看段落布局。四个段名:`.text`/`.rodata`/`.data`/`.bss`。还有两个伏笔:符号表里的 `U`(借条)会在第 4 个历程 炸出 `undefined reference`;到了第 7 个历程 上裸机,没有 libc 可搭伙,段布局也得咱们亲手写进链接脚本——今天记下的每一样,那天都要用上。

## 下一站

程序健康地活着,只会说一句话。下一个历程,咱们把它弄坏——认真地、蓄意地弄坏——然后请出嵌入式生涯里最重要的搭档之一:GDB。
