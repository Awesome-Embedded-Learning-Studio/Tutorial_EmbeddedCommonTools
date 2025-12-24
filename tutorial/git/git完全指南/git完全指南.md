# Git团队协作完全入门指南

你好！如果你是第一次听说Git，甚至对命令行都不太熟悉，不用担心。这篇教程会用**最详细、最通俗**的方式，手把手带你入门。我会假设你对这些东西完全不了解，从最基础的概念开始讲起。





## 第一章：在开始之前，你需要知道的事

### 1.1 什么是命令行？

在开始学Git之前，我们要先了解一个工具：**命令行**（也叫终端、控制台）。

**什么是命令行？** 你平时用电脑，都是用鼠标点来点去对吧？比如双击文件夹打开它，右键删除文件等等。但还有另一种方式操作电脑：**用文字命令**。

想象一下：

- 图形界面：你对电脑说"请帮我打开这个文件夹"，你用鼠标双击
- 命令行：你对电脑说"请帮我打开这个文件夹"，你打字输入命令

**为什么要用命令行？** 因为Git主要是通过命令行来使用的。一开始可能觉得不习惯，但其实命令行很强大，熟练后比鼠标点击还要快。

**如何打开命令行？**

- **Windows**：安装Git后，右键点击任意文件夹，选择"Git Bash Here"
- **Mac**：按 Command + 空格，输入"Terminal"（终端），按回车
- **Linux**：按 Ctrl + Alt + T

打开后，你会看到一个黑色或白色的窗口，里面有一些文字和一个闪烁的光标。不要害怕，这就是命令行！

### 1.2 命令行基础操作（5分钟速成）

在学Git之前，先学几个最基本的命令行操作：

**1. 查看当前位置**

```bash
pwd
```

这个命令会显示你现在在电脑的哪个文件夹里。比如显示 `/Users/zhangsan/Desktop` 就表示你在桌面。

**2. 列出当前文件夹的内容**

```bash
ls        # Mac/Linux
dir       # Windows
```

就像你在文件管理器里看到的文件列表一样。

**3. 进入某个文件夹**

```bash
cd 文件夹名字
```

比如：

```bash
cd Desktop      # 进入桌面
cd my-project   # 进入my-project文件夹
```

**4. 返回上一级文件夹**

```bash
cd ..
```

那两个点 `..` 表示"父文件夹"。

**5. 创建新文件夹**

```bash
mkdir 文件夹名字
```

比如：

```bash
mkdir my-first-project    # 创建一个叫my-first-project的文件夹
```

**小提示：**

- 命令行里的路径用 `/` 分隔（不是Windows文件管理器里的 `\`）
- 文件夹名字如果有空格，要用引号括起来，比如 `cd "My Project"`
- 按上下箭头键可以查看之前输入过的命令

好了，有了这些基础，我们可以开始学Git了！

------

## 第二章：Git是什么？为什么要用它？

### 2.1 一个真实的故事

小明和他的三个朋友要一起做一个网站项目。刚开始，他们是这样协作的：

**第一周：**

- 小明写了首页的代码，保存为 `website.html`
- 他把文件发到微信群里
- 小红下载后，添加了导航栏，保存为 `website-小红修改.html`
- 小红又发到群里

**第二周：**

- 小刚也想改首页，但他不知道该用哪个文件，用小明的原始版本还是小红的版本？
- 小刚选择了小明的版本，加了个登录按钮，保存为 `website-小刚修改.html`
- 结果小红的导航栏丢失了！

**第三周：**

- 小明想把大家的修改合并起来，但文件有10个版本了：
  - `website.html`
  - `website-小红修改.html`
  - `website-小刚修改.html`
  - `website-最终版.html`
  - `website-最终版2.html`
  - `website-这次真的是最终版.html`
  - ...

小明崩溃了！他不知道哪个是最新的，哪些修改已经合并了，万一改错了也不知道怎么恢复。

### 2.2 Git是如何解决这个问题的？

如果他们用Git，故事会是这样的：

**使用Git后：**

- 所有人都在同一个项目上工作，不需要来回发文件
- 每个人的修改都被清楚记录：谁改的、什么时候改的、改了什么
- 可以轻松看到最新版本
- 如果改错了，可以一键恢复到任何历史版本
- 多个人同时修改不同部分，Git会自动合并
- 即使改了同一个地方，Git也会提醒你处理冲突

**所以，Git就是一个：**

1. **版本控制系统**：记录文件的每一次修改
2. **协作工具**：让多人可以同时在一个项目上工作
3. **时光机**：可以回到过去的任何版本
4. **备份工具**：你的代码永远不会丢失

### 2.3 Git的核心思想

Git的工作原理可以用一个比喻来理解：

**想象你在写一本小说：**

- **每写完一章，你拍个照片保存起来**（这就是"提交/commit"）
- **照片按时间顺序排列，形成一个时间轴**（这就是"历史记录"）
- **如果你想尝试不同的故事走向，可以复制出一个副本分支来写**（这就是"分支/branch"）
- **写满意后，再把副本的内容合并回主线故事**（这就是"合并/merge"）
- **你把所有照片传到云端，朋友们也能看到**（这就是"推送到远程仓库/push"）

记住这个比喻，后面所有的概念都围绕着它展开。

------

## 第三章：安装和配置Git

### 3.1 下载和安装Git

#### Windows用户（最详细步骤）

1. **打开浏览器**，访问 https://git-scm.com
2. **下载Git**
   - 点击网站上显眼的"Download for Windows"按钮
   - 会自动下载一个 `.exe` 文件（大概50MB）
3. **安装Git**
   - 双击下载的文件
   - 会弹出一个安装向导
   - **建议**：一路点"Next"使用默认设置就可以了
   - 重要的几个选项：
     - "Select Components"：全选，不用管
     - "Adjusting your PATH environment"：选择 "Git from the command line and also from 3rd-party software"（通常是默认的）
     - "Choosing the default editor"：选择一个你喜欢的编辑器，不知道就选"Use Vim"
     - 其他都选默认即可
   - 点击"Install"开始安装
   - 安装完成后，点击"Finish"
4. **验证安装成功**
   - 右键点击桌面或任意文件夹
   - 你会看到多了两个新选项："Git Bash Here" 和 "Git GUI Here"
   - 点击"Git Bash Here"
   - 会打开一个黑色窗口（这就是命令行）
   - 输入：`git --version`
   - 按回车
   - 如果显示类似 `git version 2.43.0` 的文字，说明安装成功了！

#### Mac用户

Mac系统可能已经自带了Git，我们先检查一下：

1. **打开终端**
   - 按 Command (⌘) + 空格
   - 输入"Terminal"
   - 按回车
2. **检查是否已安装**
   - 输入：`git --version`
   - 如果显示版本号，说明已经安装了
   - 如果提示"command not found"，继续下一步
3. **安装Git**
   - 访问 https://git-scm.com
   - 下载Mac版本
   - 双击安装包，按照提示安装
   - 或者使用Homebrew安装（如果你知道这是什么）：`brew install git`

#### Linux用户

打开终端，根据你的发行版输入：

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install git

# CentOS/RHEL
sudo yum install git

# Fedora
sudo dnf install git
```

安装完后，输入 `git --version` 验证。

### 3.2 第一次配置Git（非常重要！）

安装完Git后，你需要告诉Git你是谁。这很重要，因为每次你提交代码时，Git都会记录是谁提交的。

**打开命令行（Git Bash或Terminal）**，输入以下两条命令：

```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

**详细说明：**

1. **`git config`** 是配置Git的命令
2. **`--global`** 表示这是全局配置，对你电脑上所有的Git项目都有效
3. **`user.name`** 是你的用户名，可以是中文，比如"张三"
4. **`user.email`** 是你的邮箱，建议用你GitHub的邮箱（稍后会讲GitHub）

**实际例子：**

```bash
git config --global user.name "张三"
git config --global user.email "zhangsan@example.com"
```

输入完后，按回车。如果没有任何提示，说明设置成功了（Unix系统的哲学：没有消息就是好消息）。

**验证配置：**

```bash
git config --global --list
```

这会显示你的所有配置，应该能看到你刚才设置的名字和邮箱。

**小提示：**

- 这个名字和邮箱只是用来标识你的，不会被验证真实性
- 但如果你要用GitHub，建议邮箱和GitHub的注册邮箱一致
- 你随时可以重新运行这些命令来修改配置

------

## 第四章：Git的核心概念详解

在真正开始用Git之前，我们需要理解几个核心概念。这些概念非常重要，理解了它们，后面的操作就都说得通了。

### 4.1 仓库（Repository）

**什么是仓库？**

简单说，仓库就是一个**被Git管理的文件夹**。

你的项目文件夹里有很多文件，比如：

```
my-project/
  ├── index.html
  ├── style.css
  ├── script.js
  └── README.md
```

当你在这个文件夹里运行 `git init` 后，这个文件夹就变成了一个Git仓库。Git会创建一个隐藏文件夹 `.git`，里面存放了所有的版本历史信息。

**仓库的作用：**

- 跟踪文件夹里所有文件的变化
- 记录每一次修改的历史
- 允许你回到过去的任何版本

**仓库的两种类型：**

1. **本地仓库**：在你自己的电脑上
2. **远程仓库**：在服务器上（比如GitHub），大家都能访问

### 4.2 工作区、暂存区、版本库（超级重要！）

这是Git最重要也是最容易混淆的概念。我用一个详细的比喻来解释：

**想象你在整理房间，准备拍照发朋友圈：**

1. **工作区（Working Directory）**
   - 就是你的房间本身
   - 你在这里移动东西、打扫卫生、装饰房间
   - 对应Git中，就是你的项目文件夹，你在这里修改代码
2. **暂存区（Staging Area / Index）**
   - 想象你有一个"待拍照清单"
   - 你觉得沙发摆得不错，就在清单上打勾"沙发✓"
   - 你觉得书架也整理好了，再打勾"书架✓"
   - 但卧室还乱着呢，先不打勾
   - 对应Git中，你用 `git add` 把修改好的文件加入暂存区
3. **版本库（Repository）**
   - 最后，你把清单上打勾的东西拍照，这张照片就永久保存了
   - 这张照片就存入了你的"照片册"
   - 对应Git中，你用 `git commit` 把暂存区的内容永久保存为一个版本

**为什么要有暂存区这个中间环节？**

假设你同时修改了10个文件，但你想分两次提交：

- 第一次提交：3个文件（它们是完成了登录功能的）
- 第二次提交：另外7个文件（它们是完成了注册功能的）

有了暂存区，你就可以：

```bash
# 只添加登录相关的文件到暂存区
git add login.html login.css login.js
git commit -m "完成登录功能"

# 再添加注册相关的文件
git add register.html register.css register.js signup.js form.js validation.js utils.js
git commit -m "完成注册功能"
```

这样，你的提交历史就很清晰，每次提交都是一个完整的功能。

**文字图示：**

```
工作区                 暂存区               版本库
(你修改文件)   →   (git add)   →   (git commit)
-----------------------------------------------------
修改 index.html        
修改 style.css    →   index.html      →   提交1: "更新首页"
修改 script.js         style.css
                      
修改 about.html   →   about.html      →   提交2: "添加关于页面"
```

### 4.3 提交（Commit）

**什么是提交？**

提交就是给你的项目**拍一个快照**，记录当前所有文件的状态。

每次提交都包含：

- **修改的内容**：哪些文件被修改了
- **提交信息**：描述这次修改做了什么（非常重要！）
- **作者信息**：谁提交的（就是你之前配置的name和email）
- **时间戳**：什么时候提交的
- **唯一ID**：一串字母和数字组成的编号（如 `a3f5d9c`）

**提交的比喻：**

把Git的提交历史想象成一条时间线上的珍珠链：

```
珠子1      →    珠子2      →    珠子3      →    珠子4
"初始化"   →   "添加首页"  →   "添加样式"  →   "修复bug"
```

每颗珠子就是一次提交，珠子按时间顺序连接起来。你可以随时跳到任何一颗珠子，看看那个时候的项目是什么样子。

**好的提交信息 vs 坏的提交信息：**

❌ 坏的例子：

```
"修改"
"更新代码"
"aaa"
"test"
"修复bug"  （不说是什么bug）
```

✅ 好的例子：

```
"添加用户登录功能"
"修复首页按钮点击无响应的问题"
"更新README文档，添加安装说明"
"重构数据库连接模块，提高性能"
```

**为什么提交信息很重要？**

想象3个月后，你发现网站有个bug，你查看提交历史，看到：

- 选项A："更新了一些东西" ← 完全不知道改了什么
- 选项B："修复了用户注册时邮箱验证失败的问题" ← 一目了然！

### 4.4 分支（Branch）

分支是Git最强大的功能之一，但对新手来说也是最难理解的。让我详细解释：

**什么是分支？**

分支就是项目的**平行宇宙**。你可以创建一个分支，在这个分支上做实验、开发新功能，而不影响主线代码。

**详细比喻：**

想象你在写一本小说，主线剧情是男主和女主A在一起了。但你想尝试一个不同的结局：男主和女主B在一起。

- **没有分支**：你修改了结局，结果发现读者不喜欢，但你已经把原来的结局覆盖了，找不回来了。
- **有分支**：
  1. 你创建一个"女主B结局"分支
  2. 在这个分支上写新结局
  3. 给读者看，如果他们喜欢，你就采用这个结局（合并分支）
  4. 如果他们不喜欢，你就删掉这个分支，主线故事完全没受影响

**Git中的分支：**

```
主分支 (main):
o---o---o---o---o
         \
          o---o  ← 新功能分支 (feature)
```

- 主分支 `main`（或叫 `master`）：是项目的主线，通常是稳定的、可发布的版本
- 功能分支 `feature`：从主分支分出来，开发某个新功能
- 开发完成后，可以把功能分支合并回主分支

**实际应用场景：**

假设你们团队在开发一个网站：

```
main 分支:         o---o---o---o---o---o---o  ← 始终保持可运行
                        \         \
feature-login:           o---o---o ← 张三在开发登录功能
                              \
feature-payment:               o---o---o ← 李四在开发支付功能
```

- **张三**创建 `feature-login` 分支，开发登录功能，完成后合并到 `main`
- **李四**创建 `feature-payment` 分支，开发支付功能，完成后合并到 `main`
- 两人互不干扰，各自在自己的分支上工作
- `main` 分支始终保持稳定，不会因为正在开发的功能而出问题

**分支的好处：**

1. **并行开发**：多人可以同时开发不同功能
2. **安全实验**：可以放心尝试新想法，不会破坏主代码
3. **代码审查**：功能开发完成后，可以让别人审查再合并
4. **回滚方便**：如果新功能有问题，直接删除分支即可

### 4.5 远程仓库（Remote Repository）

**什么是远程仓库？**

简单说，就是你的项目的**云端备份**，存放在服务器上（比如GitHub），大家都能访问。

**本地仓库 vs 远程仓库：**

```
你的电脑（本地仓库）          GitHub服务器（远程仓库）
    o---o---o                     o---o---o
         ↓                             ↑
    git push  →  --------→  ←  git pull
    （上传）                    （下载）
```

- **本地仓库**：在你的电脑上，只有你能访问
- **远程仓库**：在服务器上，团队所有人都能访问
- **push（推送）**：把本地的新提交上传到远程仓库
- **pull（拉取）**：把远程仓库的新提交下载到本地

**为什么需要远程仓库？**

1. **备份**：万一你的电脑坏了，代码还在服务器上
2. **协作**：团队成员可以互相看到对方的代码
3. **分享**：可以让全世界的人看到你的项目（如果是公开仓库）
4. **持续集成**：可以自动测试、自动部署

**常见的远程仓库服务：**

- **GitHub**：最流行的，全球最大的代码托管平台
- **GitLab**：功能强大，适合企业使用
- **Gitee**：中国的代码托管平台，访问速度快

我们主要会使用GitHub，因为它最流行。

------

## 第五章：创建你的第一个Git项目

理论讲完了，现在让我们实际操作！我会一步步带你创建第一个Git项目。

### 5.1 方式一：从零开始创建本地项目

这个方式适合你**要开始一个新项目**的情况。

#### 步骤1：创建项目文件夹

首先，我们要创建一个文件夹来存放项目。

**打开命令行（Git Bash或Terminal）**，输入以下命令：

```bash
# 进入你想存放项目的位置，比如桌面
cd ~/Desktop

# 创建一个新文件夹，叫my-first-project
mkdir my-first-project

# 进入这个文件夹
cd my-first-project
```

**详细解释：**

- `cd ~/Desktop` 表示进入桌面（`~` 代表你的用户目录）
- `mkdir my-first-project` 创建一个新文件夹
- `cd my-first-project` 进入刚创建的文件夹

现在你在 `my-first-project` 文件夹里了，但这还只是个普通文件夹，不是Git仓库。

#### 步骤2：初始化Git仓库

现在我们要把这个普通文件夹变成一个Git仓库：

```bash
git init
```

你会看到类似这样的提示：

```
Initialized empty Git repository in /Users/zhangsan/Desktop/my-first-project/.git/
```

**发生了什么？**

- Git在你的文件夹里创建了一个隐藏文件夹 `.git`
- 这个 `.git` 文件夹里存放了所有的版本历史信息
- 现在这个文件夹就是一个Git仓库了！

**小提示：**

- `.git` 文件夹是隐藏的，你可能在文件管理器里看不到
- **千万不要手动修改 `.git` 文件夹里的东西！** 这会破坏你的仓库
- 如果你想"取消"Git仓库，删除 `.git` 文件夹就行了（但通常不需要这样做）

#### 步骤3：创建第一个文件

现在让我们创建一个文件：

```bash
echo "# 我的第一个Git项目" > README.md
```

**这行命令做了什么？**

- `echo` 是"回声"的意思，会输出后面的文字
- `>` 是重定向符号，把输出写入文件
- `README.md` 是文件名，`.md` 表示这是一个Markdown格式的文件

你也可以用文本编辑器手动创建这个文件：

- Windows：右键 → 新建 → 文本文档，重命名为 `README.md`
- Mac：用TextEdit或任何编辑器创建文件

在文件里写上：

```markdown
# 我的第一个Git项目

这是我学习Git时创建的第一个项目。

## 项目介绍
这个项目用来练习Git的基本操作。
```

保存文件。

#### 步骤4：查看状态

现在让我们看看Git认为发生了什么：

```bash
git status
```

你会看到类似这样的输出：

```
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        README.md

nothing added to commit but untracked files present (use "git add" to track)
```

**详细解释这段输出：**

- `On branch main` ← 你在 `main` 分支上（主分支）
- `No commits yet` ← 你还没有做过任何提交
- `Untracked files` ← 有未跟踪的文件（Git还不知道要管理它们）
- `README.md` ← 这个文件是新的，Git还没有跟踪它
- 最后一行告诉你：用 `git add` 命令来跟踪这些文件

**什么是"未跟踪"（Untracked）？**

想象你买了一个新本子，在第一页写了字，但你还没有告诉图书管理员这个本子要放进图书馆管理。"未跟踪"就是这个意思：Git看到了这个文件，但你还没有告诉Git要管理它。

#### 步骤5：添加文件到暂存区

现在让我们告诉Git要跟踪这个文件：

```bash
git add README.md
```

如果你有多个文件，可以一次性添加所有文件：

```bash
git add .
```

**小提示：**

- `git add README.md` ← 添加单个文件
- `git add .` ← 添加当前文件夹下的所有修改（最常用！）
- `.` 表示"当前文件夹"

现在再运行 `git status` 看看：

```bash
git status
```

输出变了：

```
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   README.md
```

**解释：**

- `Changes to be committed` ← 准备提交的修改
- `new file: README.md` ← 这是一个新文件

文件从"未跟踪"变成了"准备提交"，它现在在暂存区了！

#### 步骤6：提交到版本库

现在让我们做第一次提交：

```bash
git commit -m "初始化项目，添加README文件"
```

输出类似这样：

```
[main (root-commit) a3f5d9c] 初始化项目，添加README文件
 1 file changed, 5 insertions(+)
 create mode 100644 README.md
```

**详细解释：**

- `git commit` ← 提交命令
- `-m "..."` ← `-m` 表示"message"（消息），后面跟你的提交说明
- `[main (root-commit) a3f5d9c]` ← 在main分支上，这是第一次提交（root-commit），ID是a3f5d9c
- `1 file changed` ← 1个文件被修改
- `5 insertions(+)` ← 插入了5行内容

**恭喜！你完成了第一次提交！**

现在再运行 `git status`：

```bash
git status
```

输出：

```
On branch main
nothing to commit, working tree clean
```

**解释：**

- `nothing to commit` ← 没有需要提交的修改
- `working tree clean` ← 工作区是干净的（没有未保存的修改）

这说明所有的修改都已经提交了！

#### 步骤7：查看提交历史

现在让我们看看提交历史：

```bash
git log
```

输出类似这样：

```
commit a3f5d9c8b2e1f4d6a8c9e7f5d3b1a9c7e5d3b1a  (HEAD -> main)
Author: 张三 <zhangsan@example.com>
Date:   Mon Dec 23 10:30:00 2024 +0800

    初始化项目,添加README文件
```

**详细解释：**

- `commit a3f5d9c...` ← 这次提交的唯一ID（很长的一串）
- `(HEAD -> main)` ← HEAD指向main分支（HEAD表示"当前位置"）
- `Author` ← 作者（你之前配置的名字和邮箱）
- `Date` ← 提交时间
- 最后是你的提交信息

**小提示：**

- `git log` 显示详细历史
- `git log --oneline` 显示简洁版本（推荐！）
- 按 `q` 键退出日志查看

试试简洁版本：

```bash
git log --oneline
```

输出：

```
a3f5d9c (HEAD -> main) 初始化项目，添加README文件
```

简洁多了！

### 5.2 方式二：克隆一个已存在的项目

这个方式适合你**要加入一个已有的项目**的情况。

假设你的队友已经在GitHub上创建了一个项目，地址是：

```
https://github.com/yourteam/awesome-project.git
```

你想把这个项目下载到本地，只需要一个命令：

```bash
# 进入你想存放项目的文件夹
cd ~/Desktop

# 克隆项目
git clone https://github.com/yourteam/awesome-project.git

# 进入项目文件夹
cd awesome-project
```

**发生了什么？**

- Git从GitHub下载了整个项目
- 自动初始化了本地Git仓库
- 自动建立了和远程仓库的连接
- 下载了所有的历史记录

一个命令就搞定了！不需要再 `git init`，因为已经是个Git仓库了。

------

## 第六章：Git的日常工作流程

现在你已经有了一个Git项目，让我们学习日常工作中最常用的操作流程。

### 6.1 完整的工作流程（重要！）

记住这个流程，以后每天工作都会用到：

```
1. 修改文件（在工作区）
      ↓
2. git add .（添加到暂存区）
      ↓
3. git commit -m "..."（提交到版本库）
      ↓
4. git push（推送到远程仓库，如果有的话）
```

这就像一个生产线：

1. 在工厂里生产零件（修改文件）
2. 把零件放到待检区（git add）
3. 质检通过，打包装箱（git commit）
4. 发货到仓库（git push）

### 6.2 实际操作演练

让我们做一个完整的工作流程演练：

#### 场景：给项目添加一个新功能

**步骤1：修改文件**

假设你要添加一个 `index.html` 文件。用你喜欢的编辑器创建文件：

```html
<!DOCTYPE html>
<html>
<head>
    <title>我的第一个网页</title>
</head>
<body>
    <h1>欢迎来到我的网站！</h1>
    <p>这是我用Git管理的第一个网页项目。</p>
</body>
</html>
```

保存文件。

**步骤2：查看状态**

```bash
git status
```

输出：

```
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        index.html

nothing added to commit but untracked files present (use "git add" to track)
```

Git发现了新文件 `index.html`，但它还是"未跟踪"状态。

**步骤3：添加到暂存区**

```bash
git add index.html
```

或者添加所有修改：

```bash
git add .
```

**步骤4：再次查看状态**

```bash
git status
```

输出：

```
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   index.html
```

现在文件在暂存区了，准备提交！

**步骤5：提交**

```bash
git commit -m "添加首页index.html"
```

输出：

```
[main b7d8a2f] 添加首页index.html
 1 file changed, 10 insertions(+)
 create mode 100644 index.html
```

完成！你的修改已经被永久保存了。

**步骤6：查看历史**

```bash
git log --oneline
```

输出：

```
b7d8a2f (HEAD -> main) 添加首页index.html
a3f5d9c 初始化项目，添加README文件
```

现在有两次提交了！

### 6.3 修改已有文件

现在让我们修改已经存在的文件：

**步骤1：编辑 index.html**

打开 `index.html`，添加一段内容：

```html
<!DOCTYPE html>
<html>
<head>
    <title>我的第一个网页</title>
</head>
<body>
    <h1>欢迎来到我的网站！</h1>
    <p>这是我用Git管理的第一个网页项目。</p>
    <p>这是新添加的内容！</p> <!-- 这是新加的 -->
</body>
</html>
```

保存。

**步骤2：查看状态**

```bash
git status
```

输出：

```
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   index.html

no changes added to commit (use "git add" and/or "git commit -a")
```

**解释：**

- `Changes not staged for commit` ← 有修改，但还没放到暂存区
- `modified: index.html` ← 这个文件被修改了

**步骤3：查看具体修改了什么**

```bash
git diff
```

输出类似这样：

```diff
diff --git a/index.html b/index.html
index e5f3d9a..7d8a2bf 100644
--- a/index.html
+++ b/index.html
@@ -6,5 +6,6 @@
 <body>
     <h1>欢迎来到我的网站！</h1>
     <p>这是我用Git管理的第一个网页项目。</p>
+    <p>这是新添加的内容！</p>
 </body>
 </html>
```

**解释：**

- 绿色的 `+` 开头的行是新增的内容
- 红色的 `-` 开头的行是删除的内容（这里没有）

按 `q` 退出查看。

**步骤4：添加和提交**

```bash
git add index.html
git commit -m "在首页添加新段落"
```

或者用一个快捷方式（适用于修改已跟踪的文件）：

```bash
git commit -am "在首页添加新段落"
```

**说明：**

- `-a` 选项会自动把所有已跟踪的文件的修改加入暂存区
- `-m` 后面跟提交信息
- `-am` 就是把两个选项合并了

但是注意：`-a` 只对已经被Git跟踪的文件有效，新文件还是要先 `git add`。

### 6.4 删除文件

假设你想删除一个文件：

**方法1：直接删除文件，然后告诉Git**

```bash
rm index.html          # 删除文件（Unix/Mac）
del index.html         # 删除文件（Windows CMD）
git add index.html     # 告诉Git这个删除操作
git commit -m "删除index.html"
```

**方法2：用Git命令删除（推荐）**

```bash
git rm index.html
git commit -m "删除index.html"
```

`git rm` 命令会同时删除文件并告诉Git，一步到位。

### 6.5 重命名文件

假设你想把 `index.html` 改名为 `home.html`：

**方法1：手动改名，然后告诉Git**

```bash
mv index.html home.html    # 重命名（Unix/Mac）
git add home.html
git add index.html
git commit -m "重命名index.html为home.html"
```

**方法2：用Git命令重命名（推荐）**

```bash
git mv index.html home.html
git commit -m "重命名index.html为home.html"
```

一步到位！

### 6.6 忽略某些文件

有些文件我们不想提交到Git，比如：

- 编译生成的文件
- 临时文件
- 包含密码的配置文件
- 系统文件（如Mac的 `.DS_Store`）
- 依赖包文件夹（如 `node_modules/`）

**如何忽略文件？**

创建一个 `.gitignore` 文件：

```bash
touch .gitignore
```

编辑这个文件，添加要忽略的文件或文件夹：

```
# 忽略所有.log文件
*.log

# 忽略临时文件夹
temp/
tmp/

# 忽略Mac系统文件
.DS_Store

# 忽略Node.js的依赖包
node_modules/

# 忽略配置文件中的敏感信息
config/secrets.txt
```

然后提交 `.gitignore`：

```bash
git add .gitignore
git commit -m "添加.gitignore文件"
```

现在，`.gitignore` 里列出的文件就不会被Git跟踪了。

------

## 第七章：分支操作详解

分支是Git最强大的功能，也是团队协作的核心。让我们详细学习分支的使用。

### 7.1 为什么需要分支？（再次强调）

想象一个真实场景：

你们团队在开发一个电商网站：

- 网站现在是v1.0版本，正在线上运行
- 你要开发一个新功能：购物车
- 这个功能需要2周时间
- 但在这2周里，可能会有紧急bug需要修复

**没有分支的情况：**

- 你在主代码上开发购物车功能
- 第3天，发现了一个紧急bug
- 但你的购物车功能还没完成，代码是半成品
- 你无法发布修复，因为会把半成品购物车也发布了
- 你进退两难！

**有分支的情况：**

```
main分支（稳定）:     o---o---o---o---o---o
                          \         \
feature-cart分支:          o---o---o  ← 你在这里开发购物车
                                \
hotfix分支:                      o  ← 紧急修复bug
```

- 你创建 `feature-cart` 分支开发购物车
- 发现紧急bug时，从 `main` 分支创建 `hotfix` 分支
- 在 `hotfix` 分支上修复bug，然后合并回 `main` 并发布
- 购物车功能不受影响，继续在 `feature-cart` 分支上开发
- 完成后再合并回 `main`

### 7.2 查看分支

**查看所有本地分支：**

```bash
git branch
```

输出：

```
* main
```

`*` 号表示你当前在哪个分支上。

**查看所有分支（包括远程分支）：**

```bash
git branch -a
```

### 7.3 创建分支

**创建一个新分支：**

```bash
git branch feature-login
```

这会创建一个叫 `feature-login` 的分支，但你还在 `main` 分支上。

**验证：**

```bash
git branch
```

输出：

```
  feature-login
* main
```

看到了吧，有两个分支了，但 `*` 还在 `main` 上。

### 7.4 切换分支

**切换到新分支：**

```bash
git checkout feature-login
```

或者用新命令（Git 2.23+）：

```bash
git switch feature-login
```

输出：

```
Switched to branch 'feature-login'
```

**验证：**

```bash
git branch
```

输出：

```
* feature-login
  main
```

现在 `*` 在 `feature-login` 上了！

**创建并切换分支（快捷方式）：**

```bash
git checkout -b feature-payment
```

或者：

```bash
git switch -c feature-payment
```

这一个命令相当于：

```bash
git branch feature-payment    # 创建分支
git checkout feature-payment  # 切换过去
```

### 7.5 在分支上工作

现在你在 `feature-login` 分支上，让我们添加一个登录页面：

创建 `login.html`：

```html
<!DOCTYPE html>
<html>
<head>
    <title>登录</title>
</head>
<body>
    <h1>用户登录</h1>
    <form>
        <input type="text" placeholder="用户名">
        <input type="password" placeholder="密码">
        <button>登录</button>
    </form>
</body>
</html>
```

提交：

```bash
git add login.html
git commit -m "添加登录页面"
```

现在切回 `main` 分支：

```bash
git checkout main
```

**神奇的事情发生了：**

打开你的项目文件夹，`login.html` 消失了！

再切回 `feature-login` 分支：

```bash
git checkout feature-login
```

`login.html` 又出现了！

**这就是分支的魔法：**

- 每个分支有自己独立的文件状态
- 切换分支时，工作区的文件会自动变化
- 就像在不同的平行宇宙之间穿梭

### 7.6 合并分支

当你在 `feature-login` 分支上完成了登录功能，想把它合并到 `main` 分支：

**步骤1：切换到目标分支（main）**

```bash
git checkout main
```

记住：**要合并到哪个分支，就先切换到哪个分支**。

**步骤2：合并**

```bash
git merge feature-login
```

输出：

```
Updating a3f5d9c..e8f2a7b
Fast-forward
 login.html | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644 login.html
```

**解释：**

- `Fast-forward` ← 这是一种合并模式，表示"快进"
- `login.html | 13 +++++++++++++` ← 添加了13行代码

现在，`login.html` 在 `main` 分支上也有了！

**步骤3：删除已合并的分支（可选）**

如果 `feature-login` 分支已经完成使命，可以删除它：

```bash
git branch -d feature-login
```

输出：

```
Deleted branch feature-login (was e8f2a7b).
```

**小提示：**

- `-d` 是安全删除，如果分支还没合并，Git会警告你
- `-D` 是强制删除，不管有没有合并都删除（危险！）

### 7.7 合并冲突（重要！）

当两个分支修改了同一个文件的同一部分，合并时就会发生冲突。这是团队协作中最常见的情况，不要害怕它！

#### 什么时候会发生冲突？

**场景模拟：**

1. 你和同事小王都从 `main` 分支创建了自己的分支
2. 你们两人都修改了 `index.html` 的第10行
3. 小王先完成并合并到了 `main`
4. 当你也想合并时，Git发现第10行有两个不同的版本
5. Git不知道该保留谁的，于是报告冲突，让你来决定

#### 实际演练：制造一个冲突

让我们实际操作一遍，这样你就知道怎么处理了。

**步骤1：创建两个分支**

先在 `main` 分支上创建一个文件：

```bash
git checkout main
echo "这是原始内容" > test.txt
git add test.txt
git commit -m "添加test.txt"
```

创建第一个分支并修改文件：

```bash
git checkout -b branch-a
echo "这是分支A的修改" > test.txt
git commit -am "分支A修改test.txt"
```

回到 `main`，创建第二个分支并修改**同一个文件**：

```bash
git checkout main
git checkout -b branch-b
echo "这是分支B的修改" > test.txt
git commit -am "分支B修改test.txt"
```

**步骤2：先合并分支A**

```bash
git checkout main
git merge branch-a
```

没问题，合并成功！

**步骤3：尝试合并分支B（冲突来了！）**

```bash
git merge branch-b
```

你会看到：

```
Auto-merging test.txt
CONFLICT (content): Merge conflict in test.txt
Automatic merge failed; fix conflicts and then commit the result.
```

**翻译：**

- 自动合并 test.txt
- 冲突！test.txt 的内容有冲突
- 自动合并失败，请修复冲突然后提交结果

**不要慌！** 这很正常，我们来解决它。

**步骤4：查看冲突**

打开 `test.txt` 文件，你会看到：

```
<<<<<<< HEAD
这是分支A的修改
=======
这是分支B的修改
>>>>>>> branch-b
```

**详细解释：**

- `<<<<<<< HEAD` 到 `=======` 之间：是当前分支（main，已经合并了branch-a）的内容
- `=======` 到 `>>>>>>> branch-b` 之间：是要合并进来的分支（branch-b）的内容
- Git用这些符号把两个版本都展示给你，让你决定保留哪个

**步骤5：解决冲突**

你有三个选择：

1. **保留分支A的内容**：删除分支B的部分和所有标记符号
2. **保留分支B的内容**：删除分支A的部分和所有标记符号
3. **两个都保留或写一个新的**：删除标记符号，手动编辑

假设我们两个都保留，编辑文件为：

```
这是分支A的修改
这是分支B的修改
```

**一定要删除那些 `<<<<`、`====`、`>>>>` 符号！**

**步骤6：标记冲突已解决**

保存文件后，告诉Git冲突已解决：

```bash
git add test.txt
```

**步骤7：完成合并**

```bash
git commit -m "合并branch-b，解决冲突"
```

或者直接 `git commit`（不加 `-m`），Git会自动生成一个合并提交信息。

**完成！** 冲突解决了！

#### 冲突解决的建议

1. **不要害怕冲突**：这是正常的，说明团队在协作
2. **仔细阅读冲突内容**：理解两个版本的区别
3. **和相关同事沟通**：如果不确定保留哪个，问问对方
4. **测试解决后的代码**：确保合并后的代码能正常工作
5. **经常从main拉取更新**：减少冲突的可能性

### 7.8 分支管理的最佳实践

**分支命名规范：**

- `feature/功能名`：开发新功能，如 `feature/user-login`
- `bugfix/bug描述`：修复bug，如 `bugfix/header-overlap`
- `hotfix/紧急修复`：紧急修复线上问题
- `release/版本号`：准备发布的版本

**团队分支策略（简化版）：**

- `main` 分支：永远保持稳定，可以随时发布
- `develop` 分支：开发分支，功能开发完成后合并到这里
- `feature/*` 分支：个人开发分支，从develop创建，完成后合并回develop
- 定期把develop合并到main进行发布

------

## 第八章：GitHub完全指南

GitHub是全球最大的代码托管平台，几乎所有开发者都在用它。让我们详细学习如何使用GitHub。

### 8.1 注册GitHub账号

**步骤1：访问GitHub**

打开浏览器，访问 https://github.com

**步骤2：注册**

1. 点击右上角的 "Sign up"（注册）按钮
2. 输入你的邮箱地址
3. 创建密码（至少8个字符）
4. 输入用户名（这个用户名会出现在你的GitHub网址里，比如 `github.com/你的用户名`）
5. 选择是否接收营销邮件（建议选No）
6. 完成人机验证（点图片之类的）
7. 点击 "Create account"
8. 查看邮箱，点击验证链接

**步骤3：完善个人资料（可选）**

1. 登录后，点击右上角头像
2. 选择 "Settings"
3. 在 "Profile" 里可以添加：
   - 头像
   - 个人简介
   - 所在地
   - 网站链接等

### 8.2 创建远程仓库

**步骤1：创建新仓库**

1. 登录GitHub
2. 点击右上角的 `+` 号
3. 选择 "New repository"（新建仓库）

**步骤2：填写仓库信息**

你会看到一个表单，让我们逐项填写：

- **Repository name（仓库名称）**：给你的项目起个名字
  - 只能包含字母、数字、连字符和下划线
  - 例如：`my-awesome-project`
- **Description（描述）**：简短描述这个项目是干什么的（可选）
  - 例如："我的第一个Git练习项目"
- **Public or Private（公开还是私有）**：
  - **Public（公开）**：任何人都能看到这个仓库（代码是开源的）
  - **Private（私有）**：只有你和你指定的人能看到
  - 对于学习项目，选Public或Private都可以
- **Initialize this repository with（初始化选项）**：
  - **Add a README file**：是否创建README文件（建议勾选）
  - **Add .gitignore**：选择一个.gitignore模板（如果是网页项目，选"Node"）
  - **Choose a license**：选择开源协议（学习项目可以不选）

**步骤3：创建**

点击绿色的 "Create repository" 按钮。

恭喜！你的第一个GitHub仓库创建好了！

### 8.3 连接本地仓库和GitHub

现在你有了：

- 本地的Git仓库（在你电脑上）
- GitHub的远程仓库（在服务器上）

我们要把它们连接起来。

#### 情况1：你已经有了本地仓库

假设你之前创建了 `my-first-project` 这个本地仓库，现在要上传到GitHub。

**步骤1：在GitHub创建仓库**

按照上面的步骤，创建一个名为 `my-first-project` 的仓库。 **注意**：不要勾选"Initialize this repository with"下的任何选项！

**步骤2：GitHub会给你提示**

创建完成后，GitHub会显示一个页面，上面有一些命令。找到 "…or push an existing repository from the command line" 这部分，会有类似这样的命令：

```bash
git remote add origin https://github.com/你的用户名/my-first-project.git
git branch -M main
git push -u origin main
```

**步骤3：在本地执行这些命令**

在你的项目文件夹里，打开命令行，执行：

```bash
# 添加远程仓库地址
git remote add origin https://github.com/你的用户名/my-first-project.git

# 确保分支名是main（如果已经是main就跳过这步）
git branch -M main

# 推送到GitHub
git push -u origin main
```

**详细解释：**

- `git remote add origin URL`：
  - `remote`：远程仓库
  - `add`：添加
  - `origin`：给远程仓库起的名字（习惯上叫origin，你也可以改成别的）
  - `URL`：远程仓库的地址
- `git branch -M main`：
  - 把当前分支重命名为main（老版本Git默认是master，新版本是main）
- `git push -u origin main`：
  - `push`：推送（上传）
  - `-u`：设置上游分支（以后直接`git push`就行了）
  - `origin`：远程仓库的名字
  - `main`：推送的分支名

**步骤4：输入账号密码**

第一次推送时，会要求你输入GitHub的用户名和密码。

**重要提示（2021年后的变化）：** GitHub已经不支持用密码来push代码了！你需要使用 **Personal Access Token（个人访问令牌）**。

**如何创建Personal Access Token：**

1. 登录GitHub
2. 点击右上角头像 → Settings
3. 左侧菜单最下面 → Developer settings
4. Personal access tokens → Tokens (classic)
5. Generate new token → Generate new token (classic)
6. 填写：
   - Note（备注）：比如"我的电脑"
   - Expiration（过期时间）：选择一个时间，或选No expiration（永不过期）
   - Select scopes（权限）：勾选`repo`（完全控制仓库）
7. 点击 "Generate token"
8. **复制这个token并保存好！** 它只显示一次，以后就看不到了

以后push时，用户名输入你的GitHub用户名，密码输入这个token。

**或者使用SSH密钥（更方便，推荐！）**

SSH方式不需要每次输入密码，配置方法稍后会讲。

**步骤5：查看GitHub**

刷新GitHub页面，你会看到你的代码已经上传了！

#### 情况2：从GitHub克隆项目

如果你要加入一个已有的GitHub项目：

```bash
# 进入你想存放项目的文件夹
cd ~/Desktop

# 克隆项目
git clone https://github.com/用户名/项目名.git

# 进入项目文件夹
cd 项目名
```

一个命令就搞定了！

### 8.4 推送（Push）和拉取（Pull）

#### 推送（Push）：上传你的修改

当你在本地做了新的提交，想上传到GitHub：

```bash
git push origin main
```

如果你之前用了 `-u` 参数设置了上游分支，可以简写为：

```bash
git push
```

**推送的完整流程：**

```bash
# 1. 修改文件
echo "新内容" >> README.md

# 2. 添加到暂存区
git add README.md

# 3. 提交
git commit -m "更新README"

# 4. 推送到GitHub
git push
```

#### 拉取（Pull）：下载最新的修改

当你的队友更新了GitHub上的代码，你想下载最新版本：

```bash
git pull
```

**Pull做了什么？**

- 从GitHub下载最新的提交
- 自动合并到你的当前分支
- 如果有冲突，会提示你解决

**建议：每天开始工作前先pull一下！**

```bash
git pull
```

这样可以避免很多冲突。

#### Fetch：只下载不合并

如果你想先看看远程有什么更新，但不立即合并：

```bash
git fetch origin
```

这会下载更新，但不会影响你的工作区。然后你可以：

```bash
git log origin/main    # 查看远程的提交历史
git diff origin/main   # 查看和远程的区别
git merge origin/main  # 决定合并
```

### 8.5 配置SSH密钥（推荐！）

使用SSH方式可以避免每次都输入密码，非常方便。

#### 步骤1：检查是否已有SSH密钥

```bash
ls -al ~/.ssh
```

如果看到 `id_rsa.pub` 或 `id_ed25519.pub` 文件，说明已经有了，可以跳到步骤3。

#### 步骤2：生成SSH密钥

```bash
ssh-keygen -t ed25519 -C "你的邮箱@example.com"
```

**说明：**

- 如果你的系统不支持ed25519算法，用：`ssh-keygen -t rsa -b 4096 -C "你的邮箱"`

按回车，会提示：

```
Enter file in which to save the key (/Users/你/.ssh/id_ed25519):
```

直接按回车（使用默认路径）。

然后提示：

```
Enter passphrase (empty for no passphrase):
```

可以输入一个密码（更安全），也可以直接按回车（不设密码）。

再按一次回车确认。

密钥生成完成！

#### 步骤3：复制公钥

```bash
cat ~/.ssh/id_ed25519.pub
```

你会看到一长串以 `ssh-ed25519` 开头的文字。全选并复制它。

**或者（Mac）：**

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

这会自动复制到剪贴板。

#### 步骤4：添加到GitHub

1. 登录GitHub
2. 点击右上角头像 → Settings
3. 左侧菜单 → SSH and GPG keys
4. 点击 "New SSH key"
5. Title（标题）：给这个密钥起个名字，比如"我的MacBook"
6. Key（密钥）：粘贴刚才复制的内容
7. 点击 "Add SSH key"

#### 步骤5：测试连接

```bash
ssh -T git@github.com
```

第一次连接会提示：

```
The authenticity of host 'github.com (...)' can't be established.
Are you sure you want to continue connecting (yes/no)?
```

输入 `yes`，按回车。

如果看到：

```
Hi 你的用户名! You've successfully authenticated...
```

说明成功了！

#### 步骤6：更换仓库地址为SSH

如果你的仓库之前用的是HTTPS地址，现在要换成SSH：

```bash
# 查看当前的远程地址
git remote -v

# 更换为SSH地址
git remote set-url origin git@github.com:你的用户名/仓库名.git
```

以后push和pull就不需要输入密码了！

### 8.6 GitHub的重要功能

#### README文件

README.md是项目的"门面"，告诉别人你的项目是干什么的。

**好的README应该包含：**

- 项目标题和简短描述
- 安装方法
- 使用方法
- 示例
- 贡献指南（如果是开源项目）

**Markdown语法速查：**

~~~markdown
# 一级标题
## 二级标题
### 三级标题

**粗体**
*斜体*

- 列表项1
- 列表项2

1. 有序列表1
2. 有序列表2

[链接文字](https://example.com)

![图片描述](图片URL)

```代码块```
~~~

#### Issues（问题跟踪）

Issues用来记录bug、任务、功能需求等。

**创建Issue：**

1. 在仓库页面点击 "Issues" 标签
2. 点击 "New issue"
3. 填写标题和描述
4. 可以：
   - 指派给某人（Assignees）
   - 添加标签（Labels）：bug、enhancement、question等
   - 设置里程碑（Milestones）
5. 点击 "Submit new issue"

**关闭Issue：**

- 在Issue页面点击 "Close issue"
- 或者在提交信息里写 `fix #1`（关闭编号为1的issue）

#### Pull Request（PR）

Pull Request是GitHub协作的核心，用于代码审查。

**什么是Pull Request？**

想象你要给朋友的小说提意见：

- 你复制了一份他的小说（fork）
- 你在副本上做了修改
- 你把修改后的内容发给他，请他审查（pull request）
- 他觉得你的修改不错，就采纳了（merge）

**创建Pull Request：**

1. 在你的分支上完成开发并push到GitHub

```bash
git push origin feature-login
```

1. 访问GitHub仓库页面，会看到提示：

```
feature-login had recent pushes less than a minute ago
[Compare & pull request]
```

1. 点击 "Compare & pull request" 按钮
2. 填写PR信息：
   - 标题：简短描述这次修改
   - 描述：详细说明做了什么，为什么这样做
   - 可以@某人请他审查
   - 可以链接相关Issue（如"Closes #5"）
3. 点击 "Create pull request"

**审查Pull Request：**

作为审查者，你可以：

- 查看代码变更
- 在代码行上添加评论
- 提出修改建议
- 批准（Approve）或请求修改（Request changes）

**合并Pull Request：**

审查通过后，点击 "Merge pull request" 按钮。有三种合并方式：

- **Merge commit**：保留所有提交历史
- **Squash and merge**：把多个提交合并成一个
- **Rebase and merge**：重新应用提交

新手推荐用默认的 "Merge commit"。

#### Fork（分叉）

Fork是GitHub的特色功能，用于给别人的项目做贡献。

**什么是Fork？**

想象你看到一个很棒的开源项目，你想改进它：

1. **Fork**：在GitHub上"复制"一份到你的账号下
2. **Clone**：把你账号下的版本克隆到本地
3. **修改**：在本地做修改
4. **Push**：推送到你账号下的版本
5. **Pull Request**：向原项目提交你的修改

**操作步骤：**

1. 访问你想贡献的项目
2. 点击右上角的 "Fork" 按钮
3. 选择你的账号（会复制一份到你的账号下）
4. 克隆到本地：

```bash
git clone https://github.com/你的用户名/项目名.git
```

1. 做修改，提交，push
2. 在GitHub上创建Pull Request到原项目

#### Star（星标）和 Watch（关注）

- **Star**：给项目点赞，表示你喜欢这个项目
- **Watch**：关注项目，有更新时会通知你

------

## 第九章：团队协作完整流程

现在让我们把所有知识串起来，看看一个真实团队是如何协作的。

### 9.1 团队成员角色

一个典型的团队：

- **项目负责人（Maintainer）**：管理整个项目，审查PR，决定合并
- **开发者（Developer）**：开发新功能，修复bug
- **贡献者（Contributor）**：偶尔贡献代码的外部人员

### 9.2 标准工作流程（完整版）

#### 作为新成员加入项目

**第1步：获取项目权限**

项目负责人需要把你加入GitHub仓库：

1. 仓库页面 → Settings → Collaborators
2. 添加你的GitHub用户名

你会收到邮件邀请，点击接受。

**第2步：克隆项目**

```bash
# 克隆项目到本地
git clone https://github.com/团队/项目名.git

# 进入项目文件夹
cd 项目名

# 查看分支
git branch -a
```

**第3步：了解项目结构**

阅读README文件，了解：

- 项目是干什么的
- 如何运行项目
- 代码结构是什么样的
- 有什么开发规范

#### 开始开发新功能

**第1步：确保代码是最新的**

```bash
# 切换到主分支
git checkout main

# 拉取最新代码
git pull origin main
```

**重要**：每次开始新功能前都要pull，确保基于最新代码！

**第2步：创建功能分支**

```bash
# 创建并切换到新分支
git checkout -b feature/user-profile

# 或者按照团队规范命名，比如：
# git checkout -b feature/你的名字-功能描述
```

**第3步：开发功能**

在你的分支上自由开发：

```bash
# 修改文件...

# 经常提交（每完成一个小功能就提交）
git add .
git commit -m "添加用户头像上传功能"

# 继续修改...
git add .
git commit -m "添加头像裁剪功能"

# 继续修改...
git add .
git commit -m "添加头像预览功能"
```

**小提示**：

- 每个提交应该是一个"原子性"的修改（一个完整的小功能）
- 提交信息要清楚
- 经常提交，不要攒一大堆修改

**第4步：推送到GitHub**

```bash
git push origin feature/user-profile
```

第一次推送这个分支可能会提示：

```
fatal: The current branch feature/user-profile has no upstream branch.
```

按照提示执行：

```bash
git push --set-upstream origin feature/user-profile
```

或者简写：

```bash
git push -u origin feature/user-profile
```

**第5步：同步主分支的更新**

如果开发时间比较长（比如几天），主分支可能已经有了新的提交。你需要把这些更新合并到你的分支：

```bash
# 确保主分支是最新的
git checkout main
git pull origin main

# 回到你的分支
git checkout feature/user-profile

# 把主分支的更新合并进来
git merge main
```

如果有冲突，解决冲突（参考第七章）。

**或者使用rebase（进阶）：**

```bash
git rebase main
```

Rebase会让提交历史更清晰，但对新手来说merge更安全。

**第6步：创建Pull Request**

功能开发完成后：

1. 访问GitHub仓库

2. 会看到黄色提示框，点击 "Compare & pull request"

3. 填写PR信息：

   - 标题：简洁明了，如"添加用户头像功能"

   - 描述：

     ```
     ## 这个PR做了什么？- 添加了头像上传功能- 添加了头像裁剪功能- 添加了头像预览功能## 测试- [x] 本地测试通过- [x] 上传头像正常- [x] 裁剪功能正常## 截图（如果是UI改动，贴上截图）Closes #15  （如果解决了某个Issue）
     ```

4. 选择审查者（Reviewers）

5. 点击 "Create pull request"

**第7步：等待审查**

队友会审查你的代码，可能会：

- 提出修改建议
- 要求你修改某些地方
- 批准你的PR

如果需要修改：

```bash
# 在你的分支上继续修改
git checkout feature/user-profile

# 修改文件...
git add .
git commit -m "根据审查意见修复问题"

# 推送
git push origin feature/user-profile
```

GitHub会自动更新你的PR。

**第8步：合并**

审查通过后，负责人会点击 "Merge pull request" 按钮。你的代码就进入主分支了！

**第9步：清理**

合并后，清理本地分支：

```bash
# 切回主分支
git checkout main

# 拉取最新代码（包含你刚合并的功能）
git pull origin main

# 删除功能分支
git branch -d feature/user-profile

# 删除远程分支（GitHub上会自动删除，但也可以手动删）
git push origin --delete feature/user-profile
```

完整流程结束！

### 9.3 日常工作习惯

**每天开始工作：**

```bash
git checkout main
git pull origin main
git checkout -b feature/今天要做的功能
```

**开发过程中（每隔1-2小时）：**

```bash
git add .
git commit -m "完成了某个小功能"
git push origin feature/今天要做的功能
```

**每天结束工作：**

```bash
# 确保所有修改都提交和推送了
git status  # 应该显示"working tree clean"
git push origin feature/今天要做的功能
```

**功能完成时：**

```bash
# 同步主分支
git checkout main
git pull origin main
git checkout feature/今天要做的功能
git merge main

# 推送并创建PR
git push origin feature/今天要做的功能
# 然后去GitHub创建Pull Request
```

### 9.4 常见协作场景

#### 场景1：同时开发不同功能

**情况**：

- 你在开发"用户登录"功能
- 同事在开发"商品搜索"功能

**解决方案**：

- 各自创建自己的分支
- 互不干扰地开发
- 完成后分别创建PR
- 依次合并到主分支

```
main:        o---o---o-------o-------o
                  \         /       /
feature-login:     o---o---o       /
                    \             /
feature-search:      o---o---o---o
```

#### 场景2：依赖别人的功能

**情况**：

- 同事小王在开发"用户认证"模块
- 你的"个人中心"功能依赖他的认证模块

**解决方案**：

- 等小王完成并合并到main
- 你从最新的main创建分支
- 或者从小王的分支创建分支（不推荐）

```bash
# 等小王合并后
git checkout main
git pull origin main
git checkout -b feature/user-center
```

#### 场景3：紧急修复线上bug

**情况**：

- 你正在开发新功能（还没完成）
- 突然发现线上有个紧急bug需要修复

**解决方案**：

```bash
# 1. 暂存当前工作
git stash

# 2. 切到主分支创建hotfix分支
git checkout main
git pull origin main
git checkout -b hotfix/紧急bug描述

# 3. 修复bug
# 修改文件...
git add .
git commit -m "修复紧急bug"
git push origin hotfix/紧急bug描述

# 4. 创建PR并快速合并

# 5. 回到你的功能分支
git checkout feature/你的功能
git stash pop  # 恢复之前的工作

# 6. 合并hotfix的修复
git merge main
```

**git stash的详细说明：**

```bash
git stash              # 暂存当前修改
git stash list         # 查看暂存列表
git stash pop          # 恢复最近的暂存并删除
git stash apply        # 恢复暂存但不删除
git stash drop         # 删除暂存
git stash clear        # 清空所有暂存
```

------

## 第十章：Git常用命令速查

这里整理了最常用的Git命令，建议打印出来贴在电脑旁！

### 10.1 基础操作

```bash
# 初始化仓库
git init

# 克隆仓库
git clone <url>

# 查看状态
git status

# 查看修改内容
git diff                    # 查看工作区和暂存区的区别
git diff --staged           # 查看暂存区和版本库的区别
git diff HEAD              # 查看工作区和版本库的区别

# 添加文件到暂存区
git add <file>              # 添加单个文件
git add .                   # 添加所有修改（最常用！）
git add *.js                # 添加所有js文件

# 提交
git commit -m "提交信息"     # 提交暂存区的内容
git commit -am "提交信息"    # 添加并提交（仅对已跟踪文件有效）
git commit --amend          # 修改最后一次提交

# 查看历史
git log                     # 查看详细历史
git log --oneline           # 查看简洁历史
git log --graph             # 查看分支图
git log --all --graph --oneline  # 查看所有分支的图形历史
```

### 10.2 分支操作

```bash
# 查看分支
git branch                  # 查看本地分支
git branch -a               # 查看所有分支（含远程）
git branch -r               # 只看远程分支

# 创建分支
git branch <分支名>          # 创建分支
git checkout -b <分支名>     # 创建并切换（旧方式）
git switch -c <分支名>       # 创建并切换（新方式）

# 切换分支
git checkout <分支名>        # 切换分支（旧方式）
git switch <分支名>          # 切换分支（新方式）

# 合并分支
git merge <分支名>           # 合并指定分支到当前分支

# 删除分支
git branch -d <分支名>       # 删除本地分支（安全删除）
git branch -D <分支名>       # 强制删除本地分支
git push origin --delete <分支名>  # 删除远程分支
```

### 10.3 远程操作

```bash
# 查看远程仓库
git remote                  # 查看远程仓库名称
git remote -v               # 查看远程仓库地址

# 添加远程仓库
git remote add origin <url>

# 修改远程仓库地址
git remote set-url origin <new-url>

# 拉取和推送
git fetch origin            # 下载远程更新但不合并
git pull origin main        # 拉取并合并
git pull                    # 拉取当前分支
git push origin main        # 推送到远程
git push                    # 推送当前分支
git push -u origin main     # 首次推送并设置上游分支

# 查看远程分支
git branch -r
```

### 10.4 撤销操作

```bash
# 撤销工作区的修改
git checkout -- <file>      # 恢复单个文件
git checkout -- .           # 恢复所有文件
git restore <file>          # 恢复文件（新命令）

# 撤销暂存区的修改（不删除工作区的修改）
git reset HEAD <file>       # 取消暂存单个文件
git restore --staged <file> # 取消暂存（新命令）

# 撤销提交
git reset --soft HEAD~1     # 撤销提交，保留修改在暂存区
git reset --mixed HEAD~1    # 撤销提交，保留修改在工作区（默认）
git reset --hard HEAD~1     # 撤销提交，删除所有修改（危险！）

# 回退到指定版本
git reset --hard <commit-id>  # 回退到指定提交（危险！）
git revert <commit-id>       # 创建新提交来撤销指定提交（安全）
```

### 10.5 暂存操作

```bash
# 暂存当前修改
git stash
git stash save "暂存说明"

# 查看暂存列表
git stash list

# 恢复暂存
git stash pop               # 恢复最近的暂存并删除
git stash apply            # 恢复暂存但不删除
git stash apply stash@{0}  # 恢复指定暂存

# 删除暂存
git stash drop stash@{0}   # 删除指定暂存
git stash clear            # 清空所有暂存
```

### 10.6 标签操作

```bash
# 创建标签
git tag v1.0.0              # 创建轻量标签
git tag -a v1.0.0 -m "版本1.0.0"  # 创建附注标签

# 查看标签
git tag                     # 列出所有标签
git show v1.0.0            # 查看标签详情

# 推送标签
git push origin v1.0.0     # 推送单个标签
git push origin --tags     # 推送所有标签

# 删除标签
git tag -d v1.0.0          # 删除本地标签
git push origin --delete v1.0.0  # 删除远程标签
```

### 10.7 配置相关

```bash
# 用户配置
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"

# 查看配置
git config --list           # 查看所有配置
git config user.name       # 查看某项配置

# 设置默认编辑器
git config --global core.editor "code --wait"  # VSCode
git config --global core.editor "vim"          # Vim

# 设置别名
git config --global alias.st status     # git st = git status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
```

------

## 第十一章：常见问题和解决方案

### 11.1 提交相关问题

#### 问题1：提交了错误的文件

**场景**：不小心把不该提交的文件（如密码文件）提交了。

**解决方案**：

如果还没push：

```bash
# 撤销最后一次提交，保留修改
git reset --soft HEAD~1

# 移除不该提交的文件
git reset HEAD 错误文件.txt

# 重新提交
git add .
git commit -m "正确的提交"
```

如果已经push：

```bash
# 删除文件
git rm 错误文件.txt

# 提交删除
git commit -m "删除错误提交的文件"

# 推送
git push
```

**注意**：即使删除了，文件内容仍然在历史记录里！如果是密码等敏感信息，需要修改密码。

#### 问题2：提交信息写错了

**场景**：提交信息有错别字或描述不准确。

**解决方案**：

如果还没push：

```bash
# 修改最后一次提交的信息
git commit --amend -m "正确的提交信息"
```

如果已经push：

- 最好不要修改已推送的提交
- 如果必须修改，会很麻烦且可能影响其他人
- 建议就让它这样吧，下次注意

#### 问题3：忘记添加文件到提交

**场景**：提交后发现漏了一个文件。

**解决方案**：

如果还没push：

```bash
# 添加漏掉的文件
git add 漏掉的文件.txt

# 追加到上次提交
git commit --amend --no-edit
```

`--no-edit` 表示不修改提交信息。

#### 问题4：提交了太多次，想合并提交

**场景**：你提交了10次小修改，想合并成1次提交。

**解决方案（使用rebase）：**

```bash
# 交互式rebase最近的10次提交
git rebase -i HEAD~10
```

会打开编辑器，显示：

```
pick a3f5d9c 提交1
pick b7d8a2f 提交2
pick c9e6f1d 提交3
...
```

把第2次及以后的 `pick` 改成 `squash` 或 `s`：

```
pick a3f5d9c 提交1
squash b7d8a2f 提交2
squash c9e6f1d 提交3
...
```

保存退出，Git会让你编辑合并后的提交信息。

**注意**：不要rebase已经push的提交！

### 11.2 分支相关问题

#### 问题5：切换分支时提示有未提交的修改

**场景**：

```
error: Your local changes to the following files would be overwritten by checkout
```

**解决方案1**：提交修改

```bash
git add .
git commit -m "临时提交"
```

**解决方案2**：暂存修改

```bash
git stash
git checkout 其他分支
# 回来后恢复
git checkout 原分支
git stash pop
```

**解决方案3**：放弃修改

```bash
git checkout -- .
git checkout 其他分支
```

#### 问题6：删除了不该删的分支

**场景**：不小心删除了还需要的分支。

**解决方案**：

如果刚删除，可以找回：

```bash
# 查看所有操作记录
git reflog

# 找到那个分支最后的commit id
# 然后创建新分支指向它
git checkout -b 分支名 <commit-id>
```

#### 问题7：合并冲突后不知道怎么办

**场景**：执行merge后出现冲突，不知道如何继续。

**解决方案**：

查看冲突状态：

```bash
git status
```

会列出冲突的文件，打开它们，手动解决冲突（参考第七章）。

如果实在解决不了，放弃合并：

```bash
git merge --abort
```

如果已经解决了冲突：

```bash
git add 冲突文件.txt
git commit -m "解决合并冲突"
```

### 11.3 远程操作问题

#### 问题8：push被拒绝

**错误信息**：

```
! [rejected] main -> main (fetch first)
error: failed to push some refs to 'https://github.com/...'
```

**原因**：远程有你本地没有的提交。

**解决方案**：

```bash
# 先拉取远程更新
git pull origin main

# 如果有冲突，解决冲突

# 再推送
git push origin main
```

#### 问题9：push需要密码但记不住

**场景**：每次push都要输入用户名和密码。

**解决方案**：配置SSH密钥（参考第八章8.5节）。

或者使用credential helper：

```bash
# 存储密码
git config --global credential.helper store

# Mac用户
git config --global credential.helper osxkeychain

# Windows用户
git config --global credential.helper wincred
```

#### 问题10：错误的远程地址

**场景**：添加了错误的远程仓库地址。

**解决方案**：

```bash
# 查看当前远程地址
git remote -v

# 修改地址
git remote set-url origin 正确的地址

# 或者删除后重新添加
git remote remove origin
git remote add origin 正确的地址
```

### 11.4 文件操作问题

#### 问题11：想忽略已经提交的文件

**场景**：忘记添加.gitignore，已经提交了不该提交的文件。

**解决方案**：

```bash
# 1. 创建或编辑.gitignore，添加要忽略的文件

# 2. 从Git中删除文件（但保留本地文件）
git rm --cached 要忽略的文件.txt

# 3. 提交
git commit -m "停止跟踪某文件"

# 4. 推送
git push
```

#### 问题12：误删了文件想恢复

**场景**：删除了文件，还没提交。

**解决方案**：

```bash
# 恢复文件
git checkout -- 文件名.txt
```

**场景**：删除并提交了。

**解决方案**：

```bash
# 查看历史，找到删除前的commit id
git log -- 文件名.txt

# 恢复文件
git checkout <commit-id> -- 文件名.txt

# 提交
git add 文件名.txt
git commit -m "恢复误删的文件"
```

#### 问题13：大文件提交失败

**错误信息**：

```
remote: error: File 大文件.zip is 150.00 MB; this exceeds GitHub's file size limit of 100.00 MB
```

**解决方案**：

从提交中移除大文件：

```bash
# 撤销提交
git reset --soft HEAD~1

# 移除大文件
git reset HEAD 大文件.zip

# 添加到.gitignore
echo "大文件.zip" >> .gitignore

# 重新提交
git add .
git commit -m "移除大文件"
```

**建议**：大文件应该：

- 不要提交到Git
- 使用Git LFS（Large File Storage）
- 放到云存储服务

### 11.5 协作问题

#### 问题14：不小心在main分支上开发了

**场景**：忘记创建功能分支，直接在main上写代码了。

**解决方案**（如果还没提交）：

```bash
# 暂存当前修改
git stash

# 创建新分支
git checkout -b feature/我的功能

# 恢复修改
git stash pop

# 正常提交
git add .
git commit -m "完成功能"
```

**解决方案**（如果已经提交但没push）：

```bash
# 创建新分支（会带着当前的提交）
git checkout -b feature/我的功能

# 回退main分支
git checkout main
git reset --hard origin/main
```

#### 问题15：队友的分支合并后出现问题

**场景**：队友的代码合并到main后，导致项目无法运行。

**解决方案**：

临时回退main：

```bash
# 查看提交历史
git log --oneline

# 回退到出问题前的提交
git reset --hard <出问题前的commit-id>

# 强制推送（危险！最好和团队商量）
git push -f origin main
```

更好的做法：

```bash
# 使用revert创建新提交来撤销
git revert <有问题的commit-id>
git push origin main
```

revert的好处是不会改写历史，更安全。

------

## 第十二章：最佳实践和进阶技巧

### 12.1 提交最佳实践

#### 提交信息规范

好的提交信息应该：

- 第一行：简短的标题（50字符以内）
- 空一行
- 详细描述（如果需要）

**规范格式：**

```
类型: 简短描述

详细说明（可选）

相关Issue（可选）
```

**常用类型：**

- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档修改
- `style`: 代码格式（不影响代码运行）
- `refactor`: 重构
- `test`: 添加测试
- `chore`: 构建过程或辅助工具的变动

**例子：**

```
feat: 添加用户登录功能

- 实现用户名/密码登录
- 添加登录表单验证
- 集成JWT token认证

Closes #23
```

#### 提交频率

- **太频繁**：每改一个字就提交 ❌
- **太少**：一周就一次提交 ❌
- **刚刚好**：每完成一个小功能就提交 ✅

**建议**：

- 每1-2小时提交一次
- 每完成一个独立的小功能提交一次
- 下班前提交一次
- 提交前测试一下，确保代码能运行

#### 原子性提交

每次提交应该是一个"原子性"的修改：

- 只做一件事
- 可以独立理解
- 可以独立回退

❌ 不好的例子：

```
git commit -m "修改了登录、注册、个人中心，修复了3个bug，更新了文档"
```

✅ 好的例子：

```
git commit -m "添加用户登录功能"
git commit -m "添加用户注册功能"
git commit -m "修复登录按钮无响应问题"
```

### 12.2 分支管理最佳实践

#### Git Flow工作流

这是一个流行的分支管理策略：

```
main (或 master)      ← 生产环境，随时可发布
  |
develop               ← 开发主分支
  |\
  | feature-a         ← 功能分支
  | feature-b
  |
  release-1.0         ← 发布准备分支
  |
  hotfix-urgent       ← 紧急修复分支
```

**分支说明：**

- `main`: 生产环境代码，只能从release或hotfix合并
- `develop`: 开发主分支，所有功能开发的基础
- `feature/*`: 功能分支，从develop创建，完成后合并回develop
- `release/*`: 发布准备分支，从develop创建，准备好后合并到main和develop
- `hotfix/*`: 紧急修复分支，从main创建，修复后合并到main和develop

#### 简化的分支策略（推荐新手）

```
main                  ← 主分支，稳定版本
  |\
  | feature-login     ← 功能分支
  | feature-payment
  |
  hotfix-bug          ← 修复分支
```

只需要：

- `main`: 主分支
- `feature/*`: 功能分支
- `hotfix/*`: 修复分支

### 12.3 代码审查（Code Review）

#### 为什么需要代码审查？

- 发现潜在的bug
- 保持代码质量
- 分享知识
- 统一代码风格
- 减少技术债务

#### 如何做好代码审查？

**作为提交者：**

1. 提交前自己先审查一遍
2. PR描述清楚做了什么、为什么这样做
3. 代码要有注释
4. 虚心接受建议

**作为审查者：**

1. 及时审查（不要让PR等太久）
2. 提出建设性的意见
3. 先表扬优点，再指出问题
4. 用疑问句代替命令句："这里是否可以..."

#### Pull Request的描述模板

```markdown
## 改动说明
简要描述这个PR做了什么

## 改动原因
为什么需要这个改动？解决了什么问题？

## 改动内容
- 添加了XX功能
- 修改了YY模块
- 删除了ZZ代码

## 测试
- [ ] 单元测试通过
- [ ] 手动测试通过
- [ ] 在不同浏览器测试

## 截图（如果有UI改动）
贴上改动前后的截图

## 相关Issue
Closes #123
Related to #456
```

### 12.4 效率提升技巧

#### 使用别名

创建Git命令的快捷方式：

```bash
# 在~/.gitconfig中添加
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    lg = log --graph --oneline --all
    last = log -1 HEAD
    uncommit = reset --soft HEAD~1
    unstage = reset HEAD
```

使用：

```bash
git st      # 相当于 git status
git co main # 相当于 git checkout main
git lg      # 查看图形化历史
```

#### 使用图形化工具

命令行不习惯？试试这些GUI工具：

- **GitHub Desktop**：简单易用，适合新手
- **SourceTree**：功能强大
- **GitKraken**：界面美观
- **VSCode内置Git**：编辑器集成

#### 使用.gitignore模板

GitHub提供了各种语言的.gitignore模板： https://github.com/github/gitignore

比如Node.js项目的.gitignore：

```
node_modules/
.env
.DS_Store
*.log
dist/
build/
```

#### 设置全局.gitignore

有些文件在所有项目中都不想提交：

```bash
# 创建全局gitignore文件
touch ~/.gitignore_global

# 配置Git使用它
git config --global core.excludesfile ~/.gitignore_global
```

在`~/.gitignore_global`中添加：

```
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Windows
Thumbs.db
Desktop.ini

# 编辑器
.vscode/
.idea/
*.swp
*.swo

# 其他
.env.local
.env
```

### 12.5 团队协作技巧

#### 每天的例行工作

**早上到公司：**

```bash
git checkout main
git pull origin main
git checkout -b feature/今天的功能
```

**开发过程中（每隔1-2小时）：**

```bash
git add .
git commit -m "完成了XX"
git push origin feature/今天的功能
```

**下班前：**

```bash
git status          # 确认没有未提交的修改
git push            # 确保代码已上传
```

#### 沟通最佳实践

- 使用Issue跟踪任务和bug
- PR描述要详细，方便审查
- 及时回应别人的PR审查
- 遇到冲突先沟通再解决
- 定期开会同步进度

#### 文档建议

在项目根目录创建这些文件：

- `README.md`: 项目介绍和使用说明
- `CONTRIBUTING.md`: 如何贡献代码
- `.gitignore`: 忽略文件列表
- `LICENSE`: 开源协议（如果开源）

### 12.6 安全建议

#### 不要提交敏感信息

永远不要提交：

- 密码
- API密钥
- 数据库连接字符串
- 私钥
- 个人信息

如果不小心提交了：

1. 立即修改密码/密钥
2. 从Git历史中删除（很复杂，最好找有经验的人帮忙）
3. 以后使用环境变量存储敏感信息

#### 使用.env文件

```bash
# .env文件（不要提交！）
DATABASE_PASSWORD=secret123
API_KEY=your_api_key

# .gitignore
.env
```

创建`.env.example`作为模板（可以提交）：

```bash
# .env.example
DATABASE_PASSWORD=your_password_here
API_KEY=your_api_key_here
```

------

## 第十三章：总结和下一步

### 13.1 回顾核心概念

让我们回顾一下Git的核心概念：

1. **仓库（Repository）**：被Git管理的文件夹
2. **工作区**：你修改文件的地方
3. **暂存区**：准备提交的修改
4. **版本库**：永久保存的提交历史
5. **提交（Commit）**：项目的快照
6. **分支（Branch）**：独立的开发线
7. **远程仓库**：云端的代码备份

### 13.2 核心工作流程

记住这个黄金流程：

```
1. git pull           # 拉取最新代码
2. git checkout -b 分支名  # 创建新分支
3. 修改代码...
4. git add .          # 添加修改
5. git commit -m "说明"  # 提交
6. git push           # 推送
7. 创建Pull Request  # 请求审查
8. 合并到主分支      # 完成！
```

### 13.3 从新手到熟练的路径

**第1周：基础操作**

- 熟练使用add、commit、push、pull
- 能够创建和切换分支
- 理解工作区、暂存区、版本库的概念

**第2-4周：分支和协作**

- 熟练使用分支进行开发
- 学会解决合并冲突
- 参与团队的PR审查

**第1-3个月：进阶技能**

- 掌握rebase、cherry-pick等高级命令
- 能够处理复杂的合并场景
- 制定团队的Git规范

**持续学习：**

- 阅读Git官方文档
- 关注最佳实践
- 学习其他人的工作流程

### 13.4 常用资源

**学习资源：**

- [Pro Git](https://git-scm.com/book/zh/v2) - 官方权威教程（中文版）
- [Learn Git Branching](https://learngitbranching.js.org/?locale=zh_CN) - 可视化交互式教程
- [GitHub Skills](https://skills.github.com/) - GitHub官方课程

**查询资源：**

- [Git命令大全](https://git-scm.com/docs)
- [Oh My Git!](https://ohmygit.org/) - 游戏化学习Git
- Stack Overflow - 遇到问题搜索解决方案

**工具推荐：**

- [GitHub Desktop](https://desktop.github.com/) - 图形化界面
- [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) - VSCode插件
- [tig](https://jonas.github.io/tig/) - 命令行图形化工具

### 13.5 给团队新成员的建议

1. **不要害怕犯错**
   - Git几乎可以撤销任何操作
   - 本地操作很难真正搞坏东西
   - 多尝试，多练习
2. **养成好习惯**
   - 经常提交
   - 写清楚的提交信息
   - 每天开始工作前先pull
   - 使用分支开发功能
3. **多和团队沟通**
   - 不确定的操作先问问
   - 遇到冲突和相关同事讨论
   - 分享你的经验和困惑
4. **持续学习**
   - Git命令很多，不需要全记住
   - 掌握常用的就够了
   - 遇到问题再查资料
5. **使用合适的工具**
   - 命令行不习惯就用GUI
   - 找到适合自己的工作方式
   - 工具是为了提高效率，不是目的

### 13.6 最后的话

恭喜你读完了这篇教程！Git一开始可能看起来很复杂，但其实核心概念就那么几个：

- **提交**：保存快照
- **分支**：平行开发
- **合并**：整合代码
- **远程**：团队协作

记住这个简单的日常流程：

```bash
git pull        # 拉取
修改代码
git add .       # 添加
git commit -m   # 提交
git push        # 推送
```

**85%的日常工作就是这5个命令！**

遇到问题不要慌：

1. 先Google搜索错误信息
2. 查看Git官方文档
3. 询问团队成员
4. 实在不行，重新克隆项目（最后的手段）

Git是一个强大的工具，但记住：

- **工具是为人服务的，不是人为工具服务**
- **重要的是协作，不是炫技**
- **清晰的沟通比完美的Git历史更重要**

现在，打开命令行，创建你的第一个Git项目吧！祝你在Git的世界里玩得开心！🚀

------

**附录：快速命令参考卡片**

```bash
# 📋 每天都用
git status          # 查看状态
git add .           # 添加所有修改
git commit -m "..."  # 提交
git push            # 推送
git pull            # 拉取

# 🌿 分支操作
git branch          # 查看分支
git checkout -b xxx # 创建并切换分支
git merge xxx       # 合并分支

# 📜 查看历史
git log --oneline   # 简洁历史
git diff            # 查看修改

# ↩️ 撤销操作
git checkout -- .   # 撤销工作区修改
git reset HEAD file # 取消暂存
git stash          # 暂存当前修改

# 🌐 远程操作
git remote -v       # 查看远程地址
git clone xxx       # 克隆项目
git push origin xxx # 推送分支
```

打印这个卡片，贴在电脑旁边，随时查看！

**谢谢阅读，祝你成为Git高手！** 💪