# 第一阶段：基础入门

本阶段将带你掌握 Bash 入门所需的核心概念，包括什么是 Shell、如何与系统交互、以及最常用的文件操作命令。学完本阶段后，你将能够熟练地在终端中进行日常操作。

---

## 目录

1. [Bash 简介与环境配置](#1-bash-简介与环境配置)
2. [基本命令](#2-基本命令)
3. [管道与重定向](#3-管道与重定向)
4. [变量与环境变量](#4-变量与环境变量)
5. [引号与转义](#5-引号与转义)

---

## 1. Bash 简介与环境配置

### 1.1 什么是 Bash

**Bash**（Bourne Again Shell）是 Linux 和 macOS 默认的命令行解释器（Shell）。它既是解释器，也是脚本语言，允许你：

- 在终端输入命令，与操作系统交互
- 将一系列命令写入脚本文件，实现自动化

常见的 Shell 还有 `zsh`、`sh`、`fish` 等，其中 Bash 是最通用、最广泛部署的。

### 1.2 终端与 Shell 的关系

很多人容易混淆这两个概念：

```
终端（Terminal）          Shell（壳层）
┌──────────────────┐    ┌──────────────────┐
│  接收键盘输入      │    │  解释命令         │
│  显示命令输出      │───▶│  调用系统程序     │
│  （图形窗口或 TTY）│    │  返回结果给终端   │
└──────────────────┘    └──────────────────┘
```

简单说：**终端**是输入输出界面，**Shell** 是解释执行命令的引擎。

### 1.3 检查当前使用的 Shell

```bash
# 方法一：查看 SHELL 变量
echo $SHELL
# 输出示例：/bin/bash

# 方法二：查看当前进程使用的 Shell
ps -p $$
# 或
ps -p $$

# 方法三：查看当前用户登录的 Shell
echo $0
# 在交互式会话中输出：-bash（前面的 - 表示是登录 Shell）

# 方法四：查看系统上所有可用的 Shell
cat /etc/shells
# 输出示例：
# /bin/sh
# /bin/bash
# /usr/bin/sh
# /usr/bin/bash
```

### 1.4 常用终端快捷键

熟练使用快捷键能大幅提升操作效率：

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + C` | 终止当前正在运行的命令 |
| `Ctrl + Z` | 暂停当前命令（可使用 `fg` 恢复） |
| `Ctrl + D` | 关闭当前终端（发送 EOF） |
| `Ctrl + L` | 清屏（等同于 `clear` 命令） |
| `Ctrl + A` | 光标跳到行首 |
| `Ctrl + E` | 光标跳到行尾 |
| `Ctrl + U` | 删除光标左侧所有内容 |
| `Ctrl + K` | 删除光标右侧所有内容 |
| `Ctrl + W` | 删除光标左侧一个单词 |
| `Ctrl + R` | **反向搜索历史命令**（非常重要）|
| `Tab` | 自动补全命令/文件/目录 |
| `Tab` × 2 | 显示所有可能的补全选项 |
| `↑` / `↓` | 浏览历史命令 |
| `!!` | 上一条命令（常用于 `sudo !!`）|
| `!n` | 执行历史记录中第 n 条命令 |
| `exit` | 退出当前 Shell |

> **提示**：按 `Ctrl + R` 后输入任意关键字，可以搜索包含该关键字的历史命令，非常实用。

---

## 2. 基本命令

### 2.1 文件和目录操作

#### `pwd` — 显示当前目录

```bash
pwd          # Print Working Directory
pwd -P       # 显示物理路径（不跟随符号链接）
```

#### `cd` — 切换目录

```bash
cd /home/user/documents    # 切换到绝对路径
cd documents               # 切换到相对路径（当前目录下的 documents）
cd ..                      # 返回上一级目录
cd ../..                   # 返回上两级目录
cd ~                       # 切换到当前用户主目录（等价于 cd）
cd ~user                    # 切换到 user 用户的主目录
cd -                       # 切换到上一个工作目录（非常实用）
```

> **技巧**：不带任何参数的 `cd` 等价于 `cd ~`，直接回到主目录。

#### `ls` — 列出目录内容

```bash
ls                          # 列出当前目录文件
ls /etc                     # 列出指定目录
ls -l                       # 详细列表格式（显示权限、所有者、大小、日期）
ls -a                       # 包含隐藏文件（以 . 开头的文件）
ls -A                       # 同 -a，但不包含 . 和 ..
ls -h                       # 文件大小以人类可读格式显示（需配合 -l 使用）
ls -R                       # 递归列出所有子目录
ls -t                       # 按修改时间排序（最新在前）
ls -S                       # 按文件大小排序（大文件在前）
ls -i                       # 显示文件的 inode 号

# 常用组合
ls -la  /home               # 详细列表 + 包含隐藏文件
ls -lh  ~/documents         # 人类可读大小 + 详细列表
ls -lt  .                   # 按时间排序的详细列表
```

`ls -l` 输出详解：

```
-rwxr-xr--  1  owner  group  4096  Jan 10 09:30  script.sh
^ ^^^^^^^^^  ^ ^^^^^^^ ^^^^^ ^^^^^ ^^^^^^^^^^^^^^^  ^^^^^^^^^^
│ permissions │ owner  group  size    modification date      filename
│             │
│             └── 硬链接数
│
└── 文件类型：- 普通文件, d 目录, l 符号链接, c 字符设备, b 块设备
```

文件类型字符：
- `-` 普通文件
- `d` 目录（directory）
- `l` 符号链接（link）
- `c` 字符设备
- `b` 块设备

#### `mkdir` — 创建目录

```bash
mkdir dir1                  # 创建单个目录
mkdir dir1 dir2 dir3        # 同时创建多个目录
mkdir -p /a/b/c/d            # 递归创建（父目录不存在时自动创建）
mkdir -p project/{src,doc,test}  # 创建项目目录结构（ brace expansion）
```

#### `rmdir` — 删除空目录

```bash
rmdir empty_dir             # 删除空目录（目录非空时会报错）
rmdir -p a/b/c              # 递归删除空目录（父目录变空后也删除）
```

> **注意**：`rmdir` 只能删除空目录，删除非空目录或文件需使用 `rm -r`。

#### `rm` — 删除文件或目录

```bash
rm file.txt                 # 删除普通文件
rm -r dir/                  # 递归删除目录及其内容
rm -rf dir/                 # 强制删除目录（不询问，不追踪符号链接）
rm -i file.txt              # 删除前确认（interactive）
rm *.log                    # 支持通配符：删除所有 .log 文件
rm file1 file2 file3        # 同时删除多个文件
```

> **警告**：`rm -rf /` 会删除整个系统，执行前务必三思！生产环境中尤其谨慎。

### 2.2 文件查看

#### `cat` — 连接并显示文件内容

```bash
cat file.txt                # 一次性显示整个文件内容
cat file1 file2 > merged.txt    # 合并多个文件
cat -n file.txt             # 显示行号
cat -b file.txt             # 非空行显示行号（忽略空行）
cat -s file.txt             # 多个连续空行压缩为一行
cat -T file.txt             # 显示 Tab 字符（显示为 ^I）
```

> **适用场景**：小文件快速查看。不适合大文件（一次性加载整个文件到内存）。

#### `less` — 分页查看文件（推荐）

```bash
less file.txt               # 进入分页模式
# 支持的操作：
#   空格键 / PageDown    下一页
#   b / PageUp          上一页
#   ↓ / ↑              下一行 / 上一行
#   g                  跳到第一行
#   G                  跳到最后一行
#   /pattern           向下搜索
#   ?pattern           向上搜索
#   n                  跳到下一个搜索结果
#   N                  跳到上一个搜索结果
#   q                  退出

less -N file.txt            # 显示行号
less -M file.txt            # 显示更多状态信息（百分比）
less +F file.txt            # 实时跟踪文件末尾（类似 tail -f）
```

> **技巧**：大文件优先使用 `less`，它不会一次性加载整个文件到内存。

#### `more` — 简单的分页查看器

```bash
more file.txt               # 简单分页（功能比 less 少）
```

> **对比**：虽然 `more` 更简单，但 `less` 功能更强大（支持上翻、搜索），日常使用推荐 `less`。

#### `head` — 查看文件开头部分

```bash
head file.txt               # 默认显示前 10 行
head -n 20 file.txt         # 显示前 20 行
head -c 100 file.txt         # 显示前 100 个字节
head -n 5 file1.txt file2.txt   # 同时显示多个文件的前 5 行
```

#### `tail` — 查看文件末尾部分

```bash
tail file.txt               # 默认显示后 10 行
tail -n 20 file.txt         # 显示后 20 行
tail -f file.txt            # **实时跟踪文件末尾**（重要！常用于查看日志）
tail -F file.txt            # 跟踪并重新打开（文件被删除或轮转时自动重新打开）
tail -n +5 file.txt         # 从第 5 行开始显示到末尾

# 常用组合：查看日志文件的最新 20 行
tail -n 20 /var/log/syslog

# 实时查看日志并高亮关键词
tail -f /var/log/nginx/access.log | grep "ERROR"
```

### 2.3 文件管理

#### `cp` — 复制文件或目录

```bash
cp source.txt dest.txt               # 复制文件
cp file1.txt file2.txt /backup/      # 复制多个文件到目录
cp -r dir/ backup_dir/               # 递归复制目录
cp -a dir/ backup_dir/               # 归档复制（保留权限、时间戳、链接等属性）
cp -i source.txt dest.txt            # 覆盖前询问
cp -v source.txt dest.txt            # 显示详细过程（verbose）
cp -p source.txt dest.txt            # 保留原文件属性

# 常用示例
cp -a project/ project_backup/       # 备份整个项目目录
```

#### `mv` — 移动或重命名文件/目录

```bash
mv oldname.txt newname.txt           # 重命名（在同一目录下）
mv file.txt /path/to/dest/           # 移动文件
mv -i file.txt /dest/                # 移动前询问
mv -v file.txt /dest/                # 显示详细过程
mv dir1/ dir2/                        # 移动目录（目录无需 -r 参数）

# 批量重命名（结合通配符）
mv *.txt ./text_files/               # 将所有 .txt 文件移动到 text_files 目录
```

#### `rename` — 批量重命名

```bash
# rename 支持两种语法风格：

# 风格一：Perl 正则表达式风格（Debian/Ubuntu 系列）
rename 's/\.txt$/\.md/' *.txt         # 将所有 .txt 改为 .md
rename 's/^/new_/' *                  # 所有文件名前加 "new_"
rename 'y/a-z/A-Z/' *                 # 全部转为大写
rename 'y/A-Z/a-z/' *                 # 全部转为小写

# 风格二：简单模式替换（CentOS/RHEL 系列）
rename from to files...
rename .txt .md *.txt                 # 简单替换扩展名
```

> **示例对比**：
> - `mv a.txt b.txt` — 单文件重命名，用 `mv`
> - `rename 's/txt/md/' *.txt` — 批量重命名，用 `rename`

### 2.4 权限管理

Linux 的权限模型基于 **三组权限 × 三种类型**：

```
rwx rwx rwx
├── 所有者（u）── 组（g）── 其他用户（o）
```

权限含义：

| 权限 | 对文件的意义 | 对目录的意义 |
|------|------------|------------|
| `r` (4) | 可以读取文件内容 | 可以列出目录内容（`ls`） |
| `w` (2) | 可以修改文件内容 | 可以在目录中创建/删除文件 |
| `x` (1) | 可以执行文件 | 可以进入目录（`cd`）|

#### `chmod` — 修改文件权限

```bash
# 符号模式（推荐初学者）
chmod u+x script.sh              # 给所有者添加执行权限
chmod g-w file.txt               # 从组中移除写权限
chmod o+r file.txt               # 给其他用户添加读权限
chmod a+x script.sh              # 给所有人添加执行权限（a = all）
chmod u=rwx,g=rx,o=r file        # 精确设置：所有者 rwx，组 rx，其他人 r
chmod +x script.sh               # 给所有人添加执行权限

# 数字模式（更简洁精确）
chmod 755 script.sh              # rwxr-xr-x：所有者可读写执行，其他人可读执行
chmod 644 file.txt               # rw-r--r--：所有者可读写，其他人只读
chmod 700 secret.txt              # rwx------：仅所有者可读写执行
chmod 600 secret.txt              # rw-------：仅所有者可读写
chmod 777 public.txt              # rwxrwxrwx：所有人可读写执行（慎用！）

# 递归修改目录权限
chmod -R 755 /var/www/html/      # 递归设置目录及所有子项

# 只修改文件权限（不改目录）
find /path -type f -exec chmod 644 {} \;
```

权限对照表：

| 数字 | 权限 | 含义 |
|------|------|------|
| 0 | `---` | 无权限 |
| 1 | `--x` | 执行 |
| 2 | `-w-` | 写入 |
| 3 | `-wx` | 写入+执行 |
| 4 | `r--` | 读取 |
| 5 | `r-x` | 读取+执行 |
| 6 | `rw-` | 读取+写入 |
| 7 | `rwx` | 全部权限 |

#### `chown` — 修改文件所有者和所属组

```bash
chown user file.txt              # 修改所有者
chown user:group file.txt       # 同时修改所有者和组
chown :group file.txt            # 只修改组
chown -R user:group dir/         # 递归修改

# 常用场景
sudo chown root file.txt         # 将文件所有者改为 root
sudo chown $USER:$USER ~/.bashrc    # 将文件改为当前用户所有
```

> **注意**：修改系统文件的权限和所有者通常需要 `sudo`。

---

## 3. 管道与重定向

### 3.1 标准输入、标准输出、标准错误

每个运行中的程序都会打开三个"文件"：

```
程序
├── 标准输入 (stdin)  ─── 键盘输入（文件描述符 0）
├── 标准输出 (stdout) ─── 正常输出（文件描述符 1）
└── 标准错误 (stderr) ─── 错误信息（文件描述符 2）
```

### 3.2 重定向符号

```bash
# 输出重定向

command > file.txt               # 将 stdout 重定向到文件（覆盖）
command >> file.txt              # 将 stdout 追加到文件末尾
command 2> error.txt             # 将 stderr 重定向到文件（覆盖）
command 2>> error.txt            # 将 stderr 追加到文件末尾

# 混合重定向
command > output.txt 2>&1        # stdout 和 stderr 都重定向到同一文件
command &> output.txt            # 同上，更简洁的写法（Bash 4+）
command &>> output.txt           # 追加模式，同时重定向 stdout 和 stderr

# 输入重定向
command < file.txt               # 从文件读取输入（而非键盘）
command <<EOF                    # Here Document：内联输入
  multiple
  lines
EOF
command <<< "string"            # Here String：单行字符串输入

# 常用实例
echo "hello" > file.txt          # 写入文件
cat file1.txt file2.txt > all.txt    # 合并文件
grep "error" /var/log/syslog > errors.txt 2>&1   # 保存匹配结果和错误
command > /dev/null 2>&1         # 完全丢弃输出（静默执行）
command > /dev/null              # 只丢弃 stdout
```

> **记忆技巧**：`>` 是覆盖，`>>` 是追加；`2>` 表示重定向 stderr，`&>` 表示同时重定向 stdout 和 stderr。

### 3.3 管道符 `|`

管道将前一个命令的 **stdout** 连接到下一个命令的 **stdin**：

```
command1 | command2 | command3
stdout1   stdout2   stdout3
   └──────┘└────────┘
     stdin1   stdin2
```

```bash
# 经典管道组合

ls -la /usr/bin | less           # 分页查看目录列表
ps aux | grep nginx              # 查找 nginx 进程
cat /var/log/nginx/access.log | grep "404" | wc -l   # 统计 404 错误数
ls -lh | sort -k5 -h             # 按文件大小排序目录
history | grep git               # 在历史记录中搜索 git 命令
df -h | grep /dev/sda            # 查看特定磁盘使用情况
echo "hello world" | tr 'a-z' 'A-Z'   # 转换大小写
cut -d: -f1 /etc/passwd | sort   # 提取用户名并排序
```

> **管道的本质**：管道连接的是 stdout 和 stdin，只有标准输出会传递，stderr 不会通过管道传递（除非使用 `2>&1` 显式合并）。

---

## 4. 变量与环境变量

### 4.1 用户自定义变量

```bash
# 定义变量（等号两边不能有空格！）
name="Alice"
age=25
path=/home/user/documents

# 读取变量（必须加 $）
echo $name                # 输出：Alice
echo "${name} is ${age}"  # 输出：Alice is 25

# 查看变量值
echo $name

# 修改变量
name="Bob"                # 修改变量值
unset name                # 删除变量

# 变量命名规则
# - 由字母、数字、下划线组成
# - 不能以数字开头
# - 区分大小写
# - 建议使用有意义的名称，使用下划线分隔（例：my_var）或驼峰命名（例：myVar）
```

> **重要**：定义变量时 `=` 两边**绝对不能有空格**，否则会被当作命令执行。

### 4.2 环境变量

**环境变量**是会传递给子进程的变量，普通变量只在当前 Shell 中有效。

```bash
# 定义环境变量
export MY_VAR="hello"           # 定义并导出为环境变量
MY_VAR="hello"; export MY_VAR    # 同上，分开写的写法

# 查看所有环境变量
env
printenv

# 查看特定环境变量
echo $PATH
echo $HOME
echo $USER
echo $SHELL
echo $PWD
echo $HOME
echo $LANG                       # 语言和字符编码设置
echo $TERM                       # 终端类型

# 临时添加路径到 PATH（当前会话有效）
export PATH=$PATH:/new/path

# 查看单个变量
printenv HOME
```

常见系统环境变量：

| 变量 | 含义 | 示例值 |
|------|------|--------|
| `HOME` | 当前用户主目录 | `/home/user` |
| `USER` | 当前用户名 | `user` |
| `SHELL` | 当前使用的 Shell | `/bin/bash` |
| `PATH` | 命令搜索路径 | `/usr/local/bin:/usr/bin:/bin` |
| `PWD` | 当前工作目录 | `/home/user/documents` |
| `LANG` | 语言和编码 | `en_US.UTF-8` 或 `zh_CN.UTF-8` |
| `TERM` | 终端类型 | `xterm-256color` |
| `EDITOR` | 默认编辑器 | `vim` |

### 4.3 Bash 变量类型详解

Bash 中的变量初看简单，实际上有多种类型和分类方式。理解它们对于写出健壮的脚本至关重要。

#### 4.3.1 按存储内容分类

这是最核心的区分，很多初学者感到困惑的根源就在这里。

```
Bash 变量（按存储内容）
├── 字符串变量（默认，所有变量本质都是字符串）
├── 整数变量（显式声明后可以进行算术运算）
├── 数组变量（普通数组、关联数组）
└── 特殊变量（预定义的系统变量）
```

**1. 字符串变量（默认类型）**

Bash 中所有变量默认都是字符串类型。即使你赋值 `count=42`，它也是字符串 `"42"`，不是数字。

```bash
# 默认都是字符串
name="Alice"
count=42
price=19.99   # 注意：Bash 不支持浮点数！小数会被截断或报错

echo "$name"          # 输出：Alice
echo "$count"         # 输出：42
```

**2. 整数变量**

如果明确声明为整数，变量就只能存储整数值，可以直接参与算术运算而不需要 `$(( ))`。

```bash
# 使用 declare -i 声明为整数
declare -i age=25
age=age+5              # 无需 $(( ))，直接运算
echo $age              # 输出：30

# 未声明为整数的变量，+5 会变成字符串拼接
count=10
count=count+5          # 结果是字符串 "count+5"，不会计算
echo $count            # 输出：count+5

# 算术运算必须用 $(( ))
count=10
count=$((count + 5))
echo $count            # 输出：15
```

> **初学者常见困惑**：为什么 `count=count+5` 不等于 15？因为 Bash 默认将所有值当作字符串处理，只有 `$(( ))` 内部才会进行真正的算术运算。

**3. 数组变量**

数组是存储多个值的有序集合，在第二阶段会详细学习，这里先建立概念。

```bash
# 普通数组：按索引存取
colors=(red green blue)
echo "${colors[0]}"      # 输出：red
echo "${colors[2]}"      # 输出：blue

# 关联数组：按键名存取（需 Bash 4+）
declare -A user
user[name]="Alice"
user[age]=25
echo "${user[name]}"    # 输出：Alice
```

#### 4.3.2 按作用域分类

```
按作用域分类
├── 普通变量（局部变量）— 仅在当前 Shell 会话有效
├── 环境变量 — 通过 export 导出，传递给子进程
└── 全局变量 — 在脚本顶层的变量（子函数中可见，除非用 local 遮蔽）
```

```bash
# 普通变量：只在当前 Shell 有效
myvar="hello"
bash -c 'echo $myvar'   # 输出为空，子进程看不到

# 环境变量：会传递给子进程
export myvar="hello"
bash -c 'echo $myvar'   # 输出：hello
```

#### 4.3.3 按访问权限分类

```
按访问权限分类
├── 可读写变量（默认）
└── 只读变量（readonly / declare -r）
```

```bash
# 创建只读变量
readonly PI=3.14159
declare -r VERSION="1.0"

PI=3.14                    # 报错：PI: readonly variable
unset PI                    # 报错：PI: readonly variable
```

#### 4.3.4 特殊变量（预定义变量）

Bash 提供了一系列预定义的特殊变量：

| 变量 | 含义 |
|------|------|
| `$0` | 当前脚本的文件名 |
| `$1` ~ `$9` | 第 1~9 个位置参数 |
| `${10}` | 第 10 个位置参数（超过 9 个时需用大括号） |
| `$@` | 所有位置参数（每个独立） |
| `$#` | 位置参数的个数 |
| `$?` | 上一个命令的退出状态（0=成功，非0=失败） |
| `$$` | 当前 Shell 的进程 ID |
| `$!` | 最近一个后台进程的进程 ID |
| `$-` | 当前 Shell 的启动选项（如 `himBHs`） |
| `$_` | 上一个命令的最后一个参数 |

```bash
# 假设脚本名为 test.sh，执行时带参数：./test.sh one two three

echo "$0"    # 输出：./test.sh
echo "$1"    # 输出：one
echo "$2"    # 输出：two
echo "$@"    # 输出：one two three
echo "$#"    # 输出：3

# $? 使用示例
ls /tmp
echo $?      # 输出：0（ls 成功）

ls /nonexistent
echo $?      # 输出：2（ls 失败）

echo "Last arg: $_"   # 输出：上一个命令的最后一个参数
```

#### 4.3.5 变量类型总结

```
┌─────────────────────────────────────────────────────────┐
│                    Bash 变量全景图                        │
├──────────────────┬──────────────────────────────────────┤
│ 按存储内容分      │  字符串（默认）/ 整数 / 数组 / 特殊变量  │
│ 按作用域分        │  普通变量 / 环境变量 / 全局变量         │
│ 按权限分         │  可读写 / 只读（readonly）             │
│ 按来源分         │  用户自定义 / 系统预定义（特殊变量）      │
└──────────────────┴──────────────────────────────────────┘
```

**初学者最常混淆的两组概念**：

1. **字符串 vs 整数**：所有变量默认是字符串。要做算术运算必须用 `$(( ))`。
2. **环境变量 vs 普通变量**：普通变量只在当前 Shell 有效；用 `export` 导出后才会传递给子进程。

> **记忆技巧**：记住三条规则——
> - 变量默认是**字符串**
> - 想做数学运算用 **`$(( ))`**
> - 想让子进程看到用 **`export`**

### 4.5 PATH 变量详解

`PATH` 是最重要的环境变量之一，它告诉 Shell 去哪些目录查找命令。

```bash
# 查看当前 PATH
echo $PATH
# 输出示例：/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

# PATH 以冒号分隔，查找顺序从左到右

# 临时添加新路径
export PATH=$PATH:/opt/myapp/bin

# 将当前目录添加到 PATH 开头（优先查找）
export PATH=.:$PATH

# 在脚本中设置 PATH
#!/bin/bash
export PATH=/usr/local/bin:$PATH
```

> **安全建议**：不要将 `.`（当前目录）添加到 PATH 开头，否则可能误执行同名恶意程序。正确做法是使用 `./` 显式执行当前目录的程序。

### 4.6 配置文件：`~/.bashrc` 与 `~/.bash_profile`

Shell 配置文件决定哪些设置在何时生效：

| 文件 | 何时生效 | 用途 |
|------|---------|------|
| `~/.bashrc` | 每次**打开新的 bash Shell** 时执行 | 别名、函数、本地环境变量 |
| `~/.bash_profile` | 仅在**登录 Shell** 时执行 | 登录时一次性设置 |
| `~/.bash_login` | 如果 `.bash_profile` 不存在则执行 | 同上 |
| `~/.profile` | 如果 `.bash_profile` 和 `.bash_login` 都不存在则执行 | 系统兼容性 |
| `/etc/profile` | 系统级，所有用户登录时执行 | 全局环境变量 |
| `/etc/bash.bashrc` | 系统级，所有交互式 bash 实例执行 | 系统别名 |

```bash
# 登录 Shell vs 交互式 Shell

# 登录 Shell：通过 SSH 登录、切换用户（su -）、终端登录
# 交互式非登录 Shell：在图形终端中打开新标签

# 通常的加载顺序（登录时）：
# /etc/profile  →  ~/.bash_profile 或 ~/.bash_login 或 ~/.profile

# 通常的加载顺序（交互式非登录时）：
# /etc/bash.bashrc  →  ~/.bashrc
```

**常见配置示例**：

```bash
# ~/.bashrc 中的常见配置

# === 别名 ===
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status'
alias gc='git commit'
alias gp='git push'

# === 环境变量 ===
export EDITOR='vim'
export VISUAL='vim'
export PATH="$HOME/.local/bin:$PATH"
export LANG='zh_CN.UTF-8'

# === 函数 ===
mkcd() { mkdir -p "$1" && cd "$1"; }   # 创建目录并进入
```

> **应用修改**：修改 `~/.bashrc` 后，不会立即生效。可以使用 `source ~/.bashrc` 或 `. ~/.bashrc` 使其立即生效。

---

## 5. 引号与转义

### 5.1 单引号、双引号、反引号的区别

这是 Bash 中最容易混淆的概念之一：

```bash
# 单引号 '' — 原样输出，不解释任何转义和变量
echo 'Hello $USER'          # 输出：Hello $USER（变量不展开）
echo 'Path: \$PATH'          # 输出：Path: \$PATH（转义也不生效）
echo 'He said: "Hi"'         # 输出：He said: "Hi"

# 双引号 "" — 解释变量和部分转义，保留空格和换行
echo "Hello $USER"           # 输出：Hello alice（变量展开）
echo "Path: $PATH"           # 输出：Path: /usr/local/bin:...
echo "Home: ${HOME}"         # 输出：Home: /home/user
echo "Current date: $(date)" # 命令替换生效

# 反引号 `` 或 $() — 命令替换，执行其中的命令并返回结果
echo "Today is `date`"      # 输出：Today is Wed Jan 15 10:30:00 CST 2026
echo "Today is $(date)"      # 同上，更推荐 $() 语法

# 三者的对比
VAR="world"
echo '$VAR'                  # 输出：$VAR
echo "$VAR"                  # 输出：world
echo $(echo $VAR)            # 输出：world
```

| 特性 | 单引号 | 双引号 | 反引号/`$( )` |
|------|--------|--------|--------------|
| 变量展开 | ❌ | ✅ | ✅（内层）|
| 命令替换 | ❌ | ❌ | ✅ |
| 转义字符 | ❌ | ✅ | ✅（内层）|
| 保留字面意思 | ✅ | ❌ | ❌ |

> **推荐**：`$()` 语法优于反引号，因为可以嵌套，易于阅读。

### 5.2 反斜杠转义

反斜杠 `\` 用于取消单个字符的特殊含义：

```bash
echo \$HOME                   # 输出：$HOME（取消 $ 的特殊含义）
echo "Hello\nWorld"          # 不解释 \n（双引号中 \n 不是换行符）
echo -e "Hello\nWorld"       # -e 选项使 \n 解释为换行
echo 'Hello\nWorld'          # 单引号中原样输出 Hello\nWorld
echo "100\$"                  # 输出：100$（转义 $）
echo "It\'s working"         # 转义单引号（在双引号中有效）
echo "File: C:\\path\\file"   # Windows 路径转义

# 常见转义字符
# \n  换行
# \t  制表符
# \r  回车
# \a  警告音
# \\  反斜杠本身
# \'  单引号（在双引号中）
# \"  双引号（在双引号中）
```

### 5.3 实际场景应用

```bash
# 场景一：文件名包含空格
touch "my document.txt"      # 用双引号包围
cat "my document.txt"
rm "my document.txt"

# 场景二：处理特殊字符
filename="report - 2026.txt"
cat "$filename"               # 变量在双引号中展开

# 场景三：安全的命令替换
TODAY=$(date +%Y-%m-%d)
echo "Backup created on $TODAY"

# 场景四：避免意外分词
files="file1.txt file2.txt"
ls $files                     # 错误：Shell 会将空格理解为分隔符
ls "$files"                   # 正确：作为一个参数传递

# 场景五：数学运算需要 $(( ))
a=5
b=3
echo $((a + b))               # 输出：8
echo $((a ** b))              # 输出：125（5 的 3 次方）
```

> **黄金法则**：变量使用时，**始终用双引号包围** `"$var"`，可以避免因空格或通配符导致的意外分词。除非你明确需要分词行为。

---

## 练习题

### 练习 1：终端操作
1. 查看当前使用的 Shell
2. 将终端清屏，然后查看当前工作目录
3. 用 `Ctrl + R` 搜索一条历史命令

### 练习 2：文件操作
1. 在主目录下创建一个名为 `bash_practice` 的目录
2. 在该目录下创建一个文件 `readme.txt`，内容为 "Hello Bash!"
3. 列出该目录的详细内容
4. 将该文件复制一份为 `readme_backup.txt`
5. 将原文件重命名为 `readme_old.txt`

### 练习 3：权限管理
1. 查看 `/bin/ls` 的权限
2. 创建一个脚本 `hello.sh`，内容为 `echo "Hello, World!"`
3. 给脚本添加执行权限并运行它

### 练习 4：管道与重定向
1. 查看 `/etc/passwd` 的前 5 行
2. 列出 `/usr/bin` 中所有文件，将结果保存到 `~/bin_list.txt`
3. 统计 `/etc/passwd` 的行数
4. 用管道组合 `ls` 和 `sort` 按字母顺序列出当前目录

### 练习 5：变量与引号
1. 定义一个变量 `NAME`，值为你的名字
2. 定义一个环境变量 `MY_PROJECT`，值为 `/home/yourname/projects`
3. 验证环境变量已被导出
4. 分别用单引号、双引号输出 `$NAME`
5. 使用 `$()` 获取当前日期并输出

---

## 总结

第一阶段涵盖了 Bash 使用中最基础也最重要的内容：

| 主题 | 核心命令 |
|------|---------|
| 终端操作 | `pwd`, `cd`, 快捷键 |
| 文件操作 | `ls`, `cp`, `mv`, `rm`, `mkdir`, `chmod`, `chown` |
| 文件查看 | `cat`, `less`, `head`, `tail` |
| 管道重定向 | `|`, `>`, `>>`, `<`, `2>` |
| 变量 | 定义 `var=value`，读取 `$var` |
| 引号 | `'原样'`, `"展开"`, `$(命令)` |

下一阶段将进入 **核心编程** 部分，学习条件判断、循环、函数等编程结构。
