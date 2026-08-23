---
title: 第 4 个历程 · 程序长大:让 make 记住咱们记不住的
order: 3
verify: scripts/journey/03-make.sh
tier: ci-matrix
verified-on: WSL2(Arch)/ gcc 16.1.1 / GNU Make 4.4.1;CI:ubuntu-latest
---

# 第 4 个历程 · 程序长大:让 make 记住咱们记不住的

上一个历程结束时,咱们的程序刚被 GDB 救回来,健康,但它只会说一句话,而且所有家当挤在一个 `main.c` 里。这个历程,咱们让它长大——从"一个文件"长成"一个小工程"。长大的代价马上会来:文件一多,「哪些东西需要重新编译」就成了人脑不该背的负担。这个历程的主角就是 make:一个替咱们记住依赖关系的工具。

动手地点是 src/journey/03-make/。您收拾一下，准备开始干活了！

## 第一幕:手工时代

主角目前长这样:

```c
/* 第 2 个历程 出生、第 3 个历程 病愈的主角,目前只有一个文件 */
#include <stdio.h>

int main(void)
{
    printf("hello, EmbedBox!\n");
    return 0;
}
```

一个文件的时候,生活很简单:

```bash
gcc main.c -o hello
./hello
```

```text
hello, EmbedBox!
```

然后程序长大了。它学会的问候,值得从 `main.c` 里搬出去,单独住一个家——于是 `greet` 搬进了 `util`,`main.c` 只负责，额，用它！

```c
#include <stdio.h>
#include "util.h"

int main(void)
{
    greet("EmbedBox");
    return 0;
}
```

```c
// 老手说pragma once呢？不着急，一些嵌入式的老编译器恐怕看了犯迷糊。
#ifndef UTIL_H
#define UTIL_H

/* greet 从 main.c 搬了出来,住进自己的家 */
void greet(const char *who);

#endif /* UTIL_H */
```

```c
#include <stdio.h>
#include "util.h"

void greet(const char *who)
{
    printf("hello, %s!\n", who);
}
```

三个文件各司其职。`util.h` 是**声明**——只宣布「有这么个函数,长这个样子」。味道是——我说了有这个东西，是不是真的，我也不知道（后面链接器就会狠狠的惩罚你，就是这个意思）

像餐厅的菜单;`util.c` 是**实现**,厨房本体;`main.c` 照着菜单点菜。两处新长相顺带交代:`#include "util.h"` 用引号、`<stdio.h>` 用尖括号,是在告诉第一棒的抄写员「一个在咱们自己目录里,一个是系统标配」;`util.h` 开头结尾那圈 `#ifndef UTIL_H ... #endif` 叫**包含守卫**,防止同一个头文件被抄两遍——原理是第一次抄时做个记号,再遇到就跳过。至于 `greet` 参数里的 `const char *`,是「字符串参数」的惯用写法,现在照认即可,指针有它自己的大课,不记在本历程账上。

现在编译要分两步走了:先把每个 `.c` 编成目标文件(第 2 个历程 的词汇:`-c` 停在汇编之后、链接之前),再把目标文件拼成可执行文件:

```bash
gcc -c main.c
gcc -c util.c
gcc main.o util.o -o hello
./hello
```

```text
hello, EmbedBox!
```

值得停下来看一眼刚才发生了什么:`main.o` 里有一个**未决符号** `greet`——`main.c` 只给了借条(调用了它),欠条(它的实现)在 `util.o` 里。链接器的工作就是把借条和欠条对上账。记住这个画面,第二幕它就要出事。

## 第二幕:长大的痛

程序继续长。这次它想知道自己的版本号,于是三处同时改动:`util.h` 长出 `version` 的声明,`util.c` 长出实现,`main.c` 用上了它:

```c
#ifndef UTIL_H
#define UTIL_H

/* greet 与 version 从 main.c 里搬了出来,住进自己的家 */
void greet(const char *who);
const char *version(void);

#endif /* UTIL_H */
```

```c
#include <stdio.h>
#include "util.h"

void greet(const char *who)
{
    printf("hello, %s!\n", who);
}

const char *version(void)
{
    return "v0.3.0";
}
```

```c
/* 主线第 4 个历程 · 程序长大 —— 主角长成三个文件后的入口
 * 对应教程:tutorial/journey/03-make.md
 */
#include <stdio.h>
#include "util.h"

int main(void)
{
    greet("EmbedBox");
    printf("journey beat 03: %s\n", version());
    return 0;
}
```

改完三个文件,要重新编译。咱们只记得自己刚动过 `main.c`,于是:

```bash
gcc -c main.c
gcc main.o util.o -o hello
```

```text
/usr/bin/ld: main.o: in function `main':
main.c:(.text+0x14): undefined reference to `version'
collect2: error: ld returned 1 exit status
```

这个报错值得逐行读,因为它会陪咱们很多年。第一行说话的是 `/usr/bin/ld`——链接器本身;`main.o: in function main'` 是说账对不上发生在 `main.o` 的 `main` 函数里,`(.text+0x14)` 是这条借条在代码段里的地址(第 2 个历程 讲过的 `.text`,在这里兑现)。第二行是正题:`undefined reference to version'`——`main.o` 拿着 `version` 的借条,但所有目标文件的欠条里都找不到它。因为 `version` 的实现住在新版 `util.c` 里,而手边的 `util.o` 还是旧版编译出来的,里面没有它。第三行的 `collect2` 是 gcc 的链接包装进程,它在替真正的 `ld` 报告退出状态。

修法就是补上忘掉的那一步:

```bash
gcc -c util.c
gcc main.o util.o -o hello
./hello
```

```text
hello, EmbedBox!
journey beat 03: v0.3.0
```

事情解决了,但不知道咱们有没有后背发凉:这次靠报错兜住了,是因为签名对不上炸得响。换一种改法——比如只改了函数内部的行为——旧目标文件会**安静地**混进最终程序,链接一句怨言都没有,拿到手的是一份用旧零件拼的「新」程序。三个文件时咱们还能靠记性,等工程长到三十个文件、头文件一层套一层,「改了什么、谁要重编」就不是人脑该干的活了。咱们需要一个替咱们记账的:它知道每个目标文件从哪来、依赖谁,谁变了就重编谁,没变的绝对不碰。这个记账员就是 make。

## 第三幕:make 接管

先把手工时代的残骸清掉,从一张白纸开始。`rm` 就是删除(remove)——它不进回收站,删了就是删了,拿它点名文件时看清楚再回车:

```bash
rm main.o util.o hello
```

然后写下这个历程的 Makefile(完整文件就在 `src/journey/03-make/Makefile`):

```make
# 主线第 4 个历程 · 程序长大 —— 最终 Makefile:变量 + 模式规则 + 头文件依赖
# 对应教程:tutorial/journey/03-make.md

CC      := gcc
CFLAGS  := -Wall -Wextra -g
TARGET  := hello
OBJS    := main.o util.o

.PHONY: all clean
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^

# 模式规则:任何 .o 都从同名 .c 编出来,并且都依赖头文件
%.o: %.c util.h
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(TARGET) $(OBJS)
```

逐块看它在说什么。开头几行的 `:=` 是 make 的赋值写法,暂时当成 `=` 用即可——两者的细微差别是 make 的深水区,不拦咱们的路。这些变量是「一处声明、处处引用」:`CC` 是编译器,`CFLAGS` 是编译选项——`-Wall -Wextra` 把警告开足(第二幕那种安静的事故,警告常常是第一道警报),`-g` 留下调试信息——这个习惯第 3 个历程 就教过咱们。`all` 是默认目标,它只是站在前台指着真正的产物 `hello`;`hello` 依赖两个目标文件,配方里的 `$@` 代表目标本身,`$^` 代表全部依赖——所以那行展开就是 `gcc -o hello main.o util.o`,和手工时代一模一样,只是换了套更耐用的写法。注意链接这一行没有放 `CFLAGS`:链接器只对符号感兴趣,警告和调试选项是编译期的事。

最有味道的是 `%.o: %.c util.h` 这条**模式规则**:任意一个 `.o` 都从同名的 `.c` 编出来,并且额外依赖 `util.h`。`$<` 代表第一个依赖,即那个 `.c` 文件。这一行就是第二幕事故的解药——`util.h` 变了,两个 `.o` 都会被判定过期,谁也漏不掉。至于 `.PHONY`,它声明 `all` 和 `clean` 是「动作」不是文件;少了它,哪天目录里恰好出现一个叫 `clean` 的文件,`make clean` 就会报告无事可做——这个坑的原理在 [GNU Make 手册的 PHONY 一节](https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html)写得很清楚。

好了,让它干活:

```bash
make
```

我们的屏幕中依次出现：

```text
gcc -Wall -Wextra -g -c -o main.o main.c
gcc -Wall -Wextra -g -c -o util.o util.c
gcc -o hello main.o util.o
```

OK了，这就是完事了，跑一下？

```bash
./hello
```

马上拿到了我们的输出：

```text
hello, EmbedBox!
journey beat 03: v0.3.0
```

每一行都是 make 替咱们敲的命令——它先回显命令本身,再执行。现在验证记账员是不是真的在记账。先动头文件——`touch` 的作用是把文件的修改时间戳改成「现在」(文件不存在时顺手创建个空的),内容一个字都不改,正好用来模拟「文件被动过了」:

```bash
touch util.h
make
```

```text
gcc -Wall -Wextra -g -c -o main.o main.c
gcc -Wall -Wextra -g -c -o util.o util.c
gcc -o hello main.o util.o
```

`util.h` 的时间戳变了,两个目标文件都被判过期,双双重编——第二幕那种「忘了哪一个」的事故,从机制上不存在了。反过来,什么都不动,make 就什么都不做:

```bash
make
```

```text
make: Nothing to be done for 'all'.
```

再单独动 `util.c`:

```bash
touch util.c
make
```

```text
gcc -Wall -Wextra -g -c -o util.o util.c
gcc -o hello main.o util.o
```

只有 `util.o` 重编,`main.o` 原封不动,然后重新链接。这就是「最小重编」:三十个文件的工程里,这个差别是从「泡杯咖啡等全量」到「回车即完成」的差别——以后咱们编译内核和 BSP(板级支持包——厂商为某块板子备好的那沓驱动与配置)的时候,会对这一行感恩戴德。

最后是打扫和重来,验证这套账本从零开始也成立:

```bash
make clean
make
```

这两个命令依次对应的是

```text
rm -f hello main.o util.o
```

和：

```text
gcc -Wall -Wextra -g -c -o main.o main.c
gcc -Wall -Wextra -g -c -o util.o util.c
gcc -o hello main.o util.o
```

## 看我，我说个事！

**Tab,不是空格。** Makefile 的配方行必须以真正的 Tab 开头。用空格缩进,咱们会收获:

```text
Makefile:16: *** missing separator.  Stop.
```

报错行号指向的正是那条配方。规则依据:[GNU Make 手册的 Recipe Syntax](https://www.gnu.org/software/make/manual/html_node/Recipe-Syntax.html)。编辑器里建议直接把 Makefile 的缩进硬性设为 Tab。

**`Nothing to be done` 不是报错。** 它是 make 在说「依赖没变,我什么都没干」。如果咱们明明改了代码却看到这句话,先怀疑自己是不是改错了地方、或者目录不对——make 只看时间戳,它不会撒谎。

**头文件依赖会长大。** 咱们手写的 `util.h` 依赖在两个文件时刚好够用;等头文件多起来,「谁 include 了谁」也该交给机器记——`gcc -MMD` 能自动生成依赖文件。这属于把 make 用到深处的手艺,这些放到参考篇再展开,主线先记着这个口子存在。
