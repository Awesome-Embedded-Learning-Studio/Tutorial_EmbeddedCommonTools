# 快速Git教程

Git是一个常见的版本控制系统，这里是笔者自己简单的记录和配置:

## After Installed, Tell everyone who you are
```bash
# 设置用户名和邮箱（每台机器设置一次）
git config --global user.name "你的名字" # 告诉git和协作成员, 你是谁？
git config --global user.email "you@example.com" # 告诉git和协作成员, 如何跟你取得联系，一般填自己的github账户。如果是协作仓库，填写自己的公司协作系统邮箱

# 检查配置
git config --list
```

设置好这个之后，我们就可以简单的唠唠Git的基本使用原理了，不懂得Git大致是如何工作的，我们很难真的去懂得如何操作Git。

这个事情源自于代码协作，假设，想像一下你在写一份重要文档、做一个网站或开发一个程序。没有版本控制，你可能会这样做：保存 file_v1.doc、file_v2.doc、file_final.doc、file_final_really.doc……文件名越来越乱，谁改过什么、什么时候改的、为什么改的都不清楚；如果改错了，要回到几天前的状态就很麻烦甚至不可能。版本控制系统（比如 Git）就是为了解决这些痛点，让项目的历史、有序协作和恢复变得简单可靠。

咱们看，既然抓不到谁，修改了什么，咱们就记录什么。

咱们不知道谁干了什么，所以咱们就记录下来，给一个名字叫做历史，顺便要注释每次变化：每次你“提交”（commit）时，系统会把当前工作状态保存下来，并记录是谁在什么时候做了哪些改动、为什么做（commit message）。就像给项目拍了张带说明的快照，方便你回溯、查原因或还原到任何一个历史时刻。

而且，有了这个功能，咱们就能安全地试验和并行开发。这将会是我们后面谈到的分支功能。每一个分支就像是一个副本那样，你可以在“分支”上自由尝试新功能，主线不会被影响。试验成功就合并回主线，失败就丢掉分支，不会搞乱主仓库。这像是在不同房间里并行做实验，最后再把成果搬回公共空间。

其次，大项目一个人改不现实，咱们多人同时改同一个项目时，版本控制能把各自的修改合并起来，避免简单地互相覆盖。出现真正的冲突时，系统会指出具体冲突文件和位置，需要人工决定如何合并，这比事后手工比对要安全高效得多。

最后一个，现代的软件工程已经把版本控制系统作为自动化流程的一个分支了版本控制与代码审查工具和自动化构建（CI）结合后，能在合并前自动跑测试、检查风格，保证主分支的质量。发布版本可以打标签（tag），清晰标识发布点，便于回滚和追踪。

这就是我们要学习Git的用处——协作的时候不糟心，出问题可以立刻回退，并行的开发和有序有效的合并。

## 所以我们怎么看Git

上面说了，Git就是一个版本管理系统。每次我们将我们的成果和修改做一次 commit提交，Git 不是记录文件的差异日志（虽然内部有差异优化），而是把当前工作树的“快照”与一组唯一标识（哈希）保存下来，并用一个小标签（分支名）指向这个快照。分支只是指向某个快照的可移动标签，切换分支就是把工作区还原为该分支标签指向的快照。

为了层层把关，Git有三个概念，您可以理解为三个柜子：工作目录、暂存区（Index/staging area）、本地仓库

- 工作目录（working directory）：你平时看到和修改的文件。我们直接打交道的柜子就是这个柜子。
- 暂存区（index / staging area）：你用 git add 把想包含在下一个 commit 的文件“放到一个暂存篮子里”。这就是我们git add后，这些变更就从工作目录中取出来，放到了暂存区中。
- 本地仓库（.git folder）：真正保存历史记录的地方，包含对象数据库和引用（refs）。在这里，我们的提交就是预备的，可以理解为在这里我们包含了最终的修改，随时可以推送到远程的仓库上。

## 一些常见的仓库



一般而言，如果我们打算现在本地上开一个仓库的话（简单的说，就是准备指定一个文件夹作为我们准备提交代码的本地仓库），我们一般这样操作：


1) 创建仓库与克隆仓库
```bash
# 在本地已有目录中初始化仓库
# 在一个目录上进行初始化，一般我们都是
cd my-repo
git init .
# 或者从远程克隆(这个使用的最多，可能我们会远程拉下来仓库进一步开发)
git clone https://github.com/username/repo.git
cd repo
```

3) 基本工作流：查看、暂存、提交
```bash
# 查看当前状态
git status

# 查看文件差异（工作区 vs 暂存区）
git diff

# 将修改加入暂存区
git add path/to/file
git add .   # 添加所有修改（慎用）

# 提交
git commit -m "简短说明：做了什么"

# 快速查看提交历史
git log --oneline --graph --decorate --all
```

4) 与远程交互
```bash
# 添加远程（通常git clone会自动配置origin）
git remote add origin https://github.com/username/repo.git

# 从远程获取并合并（相当于 fetch + merge）
git pull

# 推荐：先 fetch 再合并或 rebase
git fetch origin
git merge origin/main
# 或
git pull --rebase origin main

# 推送本地分支到远程
git push origin main

# 如果远程已有变更且你要强制覆盖（危险）
git push --force-with-lease origin branch-name
```

5) 分支（创建、切换、删除）
```bash
# 列出本地/远程分支
git branch       # 本地
git branch -a    # 本地+远程

# 创建并切换到新分支（推荐）
git switch -c feature-xyz
# 或旧命令： git checkout -b feature-xyz

# 切回主分支
git switch main

# 删除本地分支
git branch -d feature-xyz      # 若未合并会警告
git branch -D feature-xyz      # 强制删除
```

6) 合并（merge）：常见情形与命令
- 快进合并（fast-forward）：当目标分支自从分出后没有新的提交，合并会直接移动指针。
- 非快进合并（--no-ff）：保留合并提交，便于以后追踪功能分支。
```bash
# 在 main 分支上合并 feature-xyz
git switch main
git merge feature-xyz

# 强制生成合并提交（即使可以快进）
git merge --no-ff feature-xyz -m "Merge feature-xyz: 新功能描述"
```

7) 处理合并冲突
- 冲突时 Git 会在冲突文件中插入标记（`<<<<<<<`, `=======`,` >>>>>>>`）。
- 手动编辑冲突文件，保留或合并需要的内容，然后：
```bash
# 查看冲突文件
git status

# 编辑并解决冲突后，将文件标记为已解决
git add path/to/conflicted-file

# 继续合并（完成合并提交）
git commit   # Git 会生成合并信息
# 或者如果使用 merge --no-ff 并预先给出 -m，则在解决冲突后只需要 git add 并 git commit

# 如果合并后想放弃合并回到合并前状态
git merge --abort
```

8) rebase 与 merge 的选择（简述）
- merge 保留分支历史，生成合并节点，适合团队协作历史清晰。
- rebase 会把你的分支“移到”最新主分支之后，历史更线性，便于阅读，但会重写提交（慎用在已推送分支上）。
```bash
# 在 feature 分支上把自己的提交放到最新 main 之后
git switch feature-xyz
git fetch origin
git rebase origin/main

# 如果在 rebase 中遇到冲突，解决冲突后：
git add path/to/file
git rebase --continue

# 放弃 rebase 回到操作前
git rebase --abort
```

9) 常用恢复/回退命令（谨慎使用）
```bash
# 新建提交后撤销但保留修改到工作区
git reset --soft HEAD~1

# 撤销最近提交并把改动放回工作区（不保留提交）
git reset --mixed HEAD~1

# 丢弃工作区改动（不可恢复，慎用）
git checkout -- file.txt
# 或（较新）
git restore file.txt

# 回退提交并将反向提交推送（不会删除历史）
git revert <commit-hash>
```

10) 暂存工作（stash）
```bash
# 暂存当前未提交的修改
git stash save "WIP: 描述"

# 列出 stash
git stash list

# 恢复最近的 stash（并从 stash 列表移除）
git stash pop

# 仅应用 stash（保留在 stash 列表）
git stash apply stash@{0}

# 删除某个 stash
git stash drop stash@{0}
```

11) 其他有用命令
```bash
# 只看简洁提交历史
git log --oneline

# 查看某个文件的提交历史
git log -- path/to/file

# 在两次提交之间查看差异
git diff commitA commitB

# cherry-pick：把某个提交应用到当前分支
git cherry-pick <commit-hash>

# 打标签
git tag -a v1.0 -m "版本 1.0"
git push origin v1.0
```

## 一些说明

- 一般而言，master分支总是保证其可发布的状态，不要把master搞炸了。所以实验性的功能可以先放到分支中，等到真的很成熟了再说。
- 为每个功能/修复创建 feature 分支：feature/xxxx 或 fix/xxxx。
- 开发完成后推送分支并发 Pull Request（PR），由团队评审后合并入 main。
- 合并方式根据团队选择：merge（保留分支历史）、squash（合并为一个提交）、rebase+merge（线性历史）。