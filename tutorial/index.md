---
layout: home
title: EmbedBox
titleTemplate: 嵌入式中的 CSAPP · 共同实验工作台

hero:
  name: EmbedBox
  text: 一个程序的一生
  tagline: 从 clean clone 到一份 CI 背书的串口运行证据——终端 / Git / GCC / Make / CMake / GDB / 交叉编译 / QEMU / 串口,在一条真实旅程里逐个学会。
  actions:
    - theme: brand
      text: 走主线(推荐)
      link: /journey/
    - theme: alt
      text: 从第一拍开始
      link: /journey/00-env-check

features:
  - title: 主线 · 一个程序的一生
    details: 首刷推荐:一个会打招呼的小程序,被解剖、生病、长大、搬家、进入无屏机器、开口说话——十拍走通「构建→调试→交叉→QEMU→串口证据」全链条。
    link: /journey/
  - title: 环境与终端
    details: WSL2 / 终端与 PATH / VS Code 接线(旧域,待并入参考篇)。
    link: /environment/
  - title: 协作与文档
    details: Git 完全指南与 Markdown(旧域,待并入参考篇)。
    link: /collaboration/
  - title: 构建系统
    details: GCC / Make / CMake(旧域,待并入参考篇)。
    link: /build-system/
  - title: 调试
    details: GDB 与串口(旧域,待并入参考篇)。
    link: /debugging/
  - title: 模拟与交叉
    details: 交叉编译 / Docker / QEMU(旧域,待并入参考篇)。
    link: /cross-compile/

---

> EmbedBox 是 [Awesome-Embedded-Learning-Studio](https://github.com/Awesome-Embedded-Learning-Studio) 的"嵌入式 CSAPP"与共同实验工作台:承担所有路线共同需要、恰好够用的基础嵌入式开发知识。每一拍的正文命令都被 `scripts/journey/` 的配对脚本在 CI 中逐字重放——你看到的输出是真跑出来的。
