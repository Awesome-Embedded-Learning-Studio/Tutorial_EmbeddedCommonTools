---
title: 拍 04 · 工程化:CMake 与那枚给编辑器的接口
order: 4
verify: scripts/journey/04-cmake.sh
tier: ci-matrix
verified-on: WSL2(Arch)/ cmake 4.4.2 / gcc 16.1.1;CI 矩阵 ubuntu-latest + windows-latest
---

# 拍 04 · 工程化:CMake 与那枚给编辑器的接口

三个文件的工程用 CMake,确实有点杀鸡用牛刀——上一拍的 Makefile 十几行,清清爽爽。但程序的结构变了:`util` 不再是「顺带编的两个文件」,它是一个有名字、有接口的**库**,值得用库的方式被声明和管理。更硬的理由在下一拍等着:咱们要搬家,同一份源码要在「宿主机工具链」和「ARM 工具链」两套规则之间切换——手写 Makefile 管一套是清爽,管两套就是手工地毯。趁现在把壳子换好,搬家时才不心疼。

动手地点:[src/journey/04-cmake/](https://github.com/Awesome-Embedded-Learning-Studio/EmbedBox/tree/main/src/journey/04-cmake/)。程序还是那个程序,只是住进了新户型:`src/` 目录下 `main.c`、`util.c`、`util.h`,版本号跳到 v0.4.0。

## CMakeLists.txt:用声明代替记账

整个工程的新账本只有十几行:

```cmake
# 主线拍 04 · 工程化 —— 同一个程序,搬进 CMake 工程
# 对应教程:tutorial/journey/04-cmake.md
cmake_minimum_required(VERSION 3.16)

project(journey_box C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# util 从「几个文件」升格为库:接口(include)随库走,消费者自动可见
add_library(util STATIC src/util.c)
target_include_directories(util PUBLIC src)

add_executable(hello src/main.c)
target_link_libraries(hello PRIVATE util)
```

和上一拍最大的区别在姿势:Makefile 记的是**过程**(哪个文件先编、命令行怎么拼),CMakeLists 声明的是**事实**(存在一个库叫 util、一个可执行文件叫 hello、后者链接前者)。`add_library(util STATIC src/util.c)` 一行,「编目标文件、打包成 libutil.a」的流水线自动成立。`target_include_directories(util PUBLIC src)` 里那个 `PUBLIC` 是全段最值钱的关键词:`src` 是 util 的接口目录,声明成 PUBLIC 意味着**谁链接 util,谁就自动获得这个 include 路径**——main.c 里 `#include "util.h"` 不需要任何额外配置。库的接口随库走,而不是靠每个消费者自己记得,这是工程化和你上拍手写 `-I` 的本质区别。`PRIVATE` 则相反:链接关系只属于 hello 自己,不外传。

## 配置与构建:两步走

```bash
cmake -S . -B build
```

```text
-- Detecting C compile features - done
-- Configuring done (0.1s)
-- Generating done (0.0s)
-- Build files have been written to: /tmp/.../build
```

注意这条命令**没有编译任何东西**。`-S .` 指源码目录,`-B build` 指输出目录,CMake 此刻干的是「考察环境、生成构建系统」——它探测了咱们的编译器,然后在 `build/` 里生成了一套现成的构建脚本(默认就是 Makefile)。换句话说,CMake 是构建系统的生成器,不是构建系统本身;「我该用哪个编译器、平台是什么」这类问题,由它在配置期一次性回答,不散落在构建规则里。这也是它将来能优雅切换工具链的底气:换一个工具链文件,重新配置,同一份 CMakeLists 纹丝不动。

然后才是构建:

```bash
cmake --build build
```

```text
[ 25%] Building C object CMakeFiles/util.dir/src/util.c.o
[ 50%] Linking C static library libutil.a
[ 50%] Built target util
[ 75%] Building C object CMakeFiles/hello.dir/src/main.c.o
[100%] Linking C executable hello
[100%] Built target hello
```

看这份进度条式的输出:先编 `util.c`、打成 `libutil.a`,再编 `main.c`、链接成 `hello`——上一拍咱们手写的依赖关系,这里由目标(target)之间的关系自动推导。运行:

```bash
./build/hello
```

```text
hello, EmbedBox!
journey beat 04: v0.4.0
```

## 那枚给编辑器的接口

配置时埋的一行 `set(CMAKE_EXPORT_COMPILE_COMMANDS ON)`,让 `build/` 里多出一个文件:

```bash
ls -l build/compile_commands.json
```

```text
-rw-r--r-- 1 charliechen charliechen 558 Aug 23 14:41 build/compile_commands.json
```

打开看,里面是每个源文件**完整编译命令**的 JSON 清单——用哪个编译器、什么标准、哪些 include 路径。它不是给 CMake 自己用的,是给工具生态的通用接口:编辑器拿到它,就知道每个文件「真实的编译视角」。拍 08 给 VS Code 接线时,IntelliSense 吃的就是这份文件。现在咱们只需要记住:它在 `build/` 里,是构建系统递给编辑器的名片。

## 账还记着吗?

换了大管家,拍 03 用血换来的增量构建语义可不能丢。验证:

```bash
touch src/util.h
cmake --build build
```

```text
[ 25%] Building C object CMakeFiles/util.dir/src/util.c.o
[ 50%] Linking C static library libutil.a
[ 50%] Built target util
[ 75%] Building C object CMakeFiles/hello.dir/src/main.c.o
[100%] Linking C executable hello
[100%] Built target hello
```

头文件一变,库和应用双双重编——而且这次不用咱们在规则里手写 `util.h` 依赖,CMake 生成 Makefile 时顺带查了每个文件的 `#include` 关系。什么都不改再构建一次:

```bash
cmake --build build
```

```text
[ 50%] Built target util
[100%] Built target hello
```

只报「已就绪」,一个字都没重编。账本还在,管家换了,服务升级。

## 下一站

工程壳子就位:库与应用分离、声明式账本、还有一枚递给编辑器的名片。现在,搬家——下一拍咱们把同一份源码交给 ARM 工具链,亲眼看看「可执行文件」这个词在另一套架构下的含义——以及为什么宿主机上好好的程序,到了目标机上连运行的机会都没有。
