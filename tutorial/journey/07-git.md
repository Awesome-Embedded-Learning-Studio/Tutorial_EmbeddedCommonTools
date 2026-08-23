---
title: 第 8 个历程 · 记录旅程:Git 的深度与一份像样的 README
order: 7
verify: scripts/journey/07-git.sh
tier: ci-matrix
verified-on: WSL2(Arch)/ git 2.55.0;CI 矩阵 ubuntu-latest + windows-latest
---

# 第 8 个历程 · 记录旅程:Git 的深度与一份像样的 README

咱们在第 1 个历程 就用过 git 了——`git clone` 那条命令,当时说「先照抄,这个历程解释」。现在兑现。机器开口说话了(第 7 个历程),但如果这段旅程没有记录:代码没处放、改动没法回溯、成果没法交给人——一切等于没发生。这个历程咱们把「记录」这件事做扎实:在临时目录里从零建一个小仓,亲手走完 git 的日常闭环,包括一次真实的合并冲突。

本章没有 `src/` 实验——实验对象就是一个即建即弃的小仓库,配对脚本会替咱们把它完整重放一遍。

## 建仓:第一份家业

```bash
git init -b main box
```

`git init` 建仓,`-b main` 顺便指定主分支名(不指定的话,新版 git 会友好地提示它打算叫什么)。进到 `box/` 里,放两件家当:咱们的老主角 `hello.c`(单文件时代的那位),和一份 README。然后问 git:「你看到什么了?」

```bash
git status
```

```text
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	README.md
	hello.c

nothing added to commit but untracked files present (use "git add" to track)
```

git 的世界观是一台**户口登记机**:工作目录里的一切,它先当「无户口」(Untracked)看待。`git status` 是咱们和它对账的窗口,这个命令咱们之后每天要敲几十遍。登记,然后落第一笔户口:

```bash
git add README.md hello.c
git commit -m "hello: journey starts"
```

```text
[main (root-commit) 7ad7635] hello: journey starts
 2 files changed, 14 insertions(+)
 create mode 100644 README.md
 create mode 100644 hello.c
```

(那串 `7ad7635` 是提交的指纹——每次提交都不同,咱们跑出来的必然是另一串,这很正常。)

## 改动、差异与户口本

程序长大了一行,加了句 `printf("journey: v0.2\n");`。改完先别急着提交,看看 git 怎么描述这次改动:

```bash
git diff
```

```text
diff --git a/hello.c b/hello.c
index df3d6b5..02323af 100644
--- a/hello.c
+++ b/hello.c
@@ -3,5 +3,6 @@
 int main(void)
 {
     printf("hello, EmbedBox!\n");
+    printf("journey: v0.2\n");
     return 0;
 }
```

`diff` 是 git 的显微镜:加了哪行、在哪个上下文里,一清二楚。读法认三个记号:`a/hello.c` 和 `b/hello.c` 是改动前、后两版;`@@ -3,5 +3,6 @@` 是路段牌——旧文件第 3 行起的 5 行,换成了新文件第 3 行起的 6 行;行前的 `+` 是新增、`-` 是删除。这正是第 7 个历程 那个 `diff -u` 的格式——连老朋友都不换衣服。将来咱们 review 别人的代码、或者排查「到底是哪次改动引入了问题」,读的都是这种格式。确认无误,再登记、落笔:

```bash
git add hello.c
git commit -m "hello: add version line"
```

```bash
git log --oneline
```

```text
51424d7 hello: add version line
7ad7635 hello: journey starts
```

户口本(`git log`)从新到旧列着每笔提交。`--oneline` 是紧凑模式;想看每笔的完整改动,`git log -p` 连 diff 一起端上来。

## 改坏了?历史来救

现在演示这个历程真正的卖点。手滑了——假设咱们把 `main` 函数整个删了,文件一保存,心里一凉。先看事故报告(`--stat` 只看汇总账目:动了哪个文件、几行增减,那串 `+--` 是增删行的条形图,一行对一行):

```bash
git diff --stat
```

```text
 hello.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
```

工作目录和户口本对不上了。但注意:**户口本里的那笔提交完好无损**——git 的提交是不可变的历史,咱们在工作目录里怎么折腾都伤不到它。所以救回是一行命令的事:

```bash
git restore hello.c
```

它成功时和 diff 一样,一言不发——沉默即恢复。配对脚本会用 `grep` 验证 `journey: v0.2` 那行确实回来了,再替它补一句「hello.c 已恢复,文件内容和最近一次提交一致」。

`git restore` 把文件恢复到最近一次提交的样子。这就是「记录」的含金量:第 3 个历程 咱们靠 gdb 救回了程序的逻辑,这个历程咱们多了第二重保险——**任何提交过的状态,永远可以回去**。`git log` 里任何一个指纹,都是一台时光机。

## 分支:在不打扰主线的地方折腾

想改 README,又怕改坏主线?开条分支:

```bash
git checkout -b polish-readme
```

```text
Switched to a new branch 'polish-readme'
```

分支不是「复制一份代码」,只是一个**可以移动的书签**:咱们现在在 `polish-readme` 这枚书签上提交,主线那边风平浪静。在这里把 README 的状态行改成「串口输出已验证 diff 一致」,提交;然后切回主线:

```bash
git checkout main
```

在主线上,**同一个位置**,把那行改成另一个说法——「串口输出已捕获,连 `\r\n` 都是亲手发的」,提交。好了,炸药埋好了:两边动了同一行。

## 合并:冲突,以及它的解法

```bash
git merge polish-readme
```

```text
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
```

**CONFLICT**——这是新手最怕的字眼,但请把它重新理解为一件好事:git 把能自动合并的都合并了,唯独「两边对同一行给出了不同意见」的地方,它**不敢替咱们做主**,于是把裁决权连同现场一起交给咱们。看现场:

```bash
git status
```

```text
On branch main
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
	both modified:   README.md
```

打开 README.md,git 在冲突处留了标记:

```text
<<<<<<< HEAD
- 第 7 个历程:串口输出已捕获,连 \r\n 都是亲手发的
=======
- 第 7 个历程:串口输出已验证 diff 一致
>>>>>>> polish-readme
```

`<<<<<<<` 到 `=======` 是咱们这边的(HEAD 是 git 给「咱们此刻站在哪」起的名字,现在指着当前分支),`=======` 到 `>>>>>>>` 是对方的。解法永远是同一个:**动手编辑,留下咱们认为对的最终样子,删掉所有标记**。咱们裁决成一句更准确的:

```markdown
# box —— 一个程序的一生

主线实验仓:EmbedBox journey 的动手记录。

## 状态

- 第 7 个历程:串口输出已捕获,且与 expected-serial.txt 逐字节一致
```

然后告诉 git 裁决完毕,收尾:

```bash
git add README.md
git commit -m "merge polish-readme: pick the precise wording"
```

顺手打个里程碑——tag 是牢牢锚在历史上的刻度,以后 `git checkout v0.1-journey` 可以随时回到这个精确时刻,发版、留档、交作业都靠它:

```bash
git tag v0.1-journey
git tag
```

```text
v0.1-journey
```

## README:协作的门面

这个历程的另一半主角是 README 本身。咱们大概注意到,这份 README 用的是 Markdown——`#` 是标题、`-` 是列表、反引号是行内代码。为什么值得学?因为**开源世界的门面全是它写的**:GitHub 的项目首页、Issue、Pull Request、代码里的文档,全是 Markdown。一份好 README 至少回答四件事:这是什么、怎么跑、依赖什么、结果在哪。上面那份小 README 已经是个最小样板。

至于「交作业」的完整形态——把本地仓库推上 GitHub、开分支、发 Pull Request——流程就是今天这套动作加一个 `git push` 和网页上的两次点击,GitHub 的官方文档([Hello World 教程](https://docs.github.com/zh/get-started/start-your-journey/hello-world))二十分钟能走完。等咱们在真实仓库提第一个 PR 时,会发现冲突解决这一步,咱们已经亲手做过。

## 这个历程咱们带走了什么

日常闭环七件套:`status` / `add` / `commit` / `diff` / `log` / `checkout -b` / `merge`;两道保险:提交不可变(`restore` 随时可回)与 tag(锚定里程碑);以及一份不再恐惧 CONFLICT 的心态——那不是事故,是 git 在请咱们签字。

## 下一站

记录有了,证据有了。但日常工作的椅子还不舒服:编辑器看不懂咱们的代码,满屏红线,跳转失灵。最后一个历程,把前面所有工具接进 VS Code——顺便咱们会发现,那枚第 5 个历程 埋下的 `compile_commands.json`,就是为这一刻准备的。
