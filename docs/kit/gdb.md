>GDB是一个由GNU开源组织发布的、UNIX/LINUX操作系统下的、基于命令行的、功能强大的程序调试工具。 对于一名Linux下工作的c/c++程序员，gdb是必不可少的工具。

## 生成调式信息
```
gcc -g hello.c -o hello
启动gdb的方法
$gdb <program>
$gdb <program> <core dump file>
$gdb <program> <PID>
```

## 程序运行上下文
### 程序运行参数
```
set args 可指定运行时参数。（如：set args 10 20 30 40 50 ） 
show args 命令可以查看设置好的运行参数。 
不指定运行参数 run (r) 
指定运行参数r 10 20 30 40 50
```
### 显示源代码
```
list
list "文件名.后缀名":行号(显示别的文件)
show listsize
set listsize count
search text:该命令可显示在当前文件中包含text串的下一行。
Reverse-search text:该命令可以显示包含text 的前一行。
```

## 设置断点
### 简单断点
```
break 设置断点，可以简写为b 
b 10设置断点，在源程序第10行 
b func设置断点，在func函数入口处
```
### 条件断点
```
设置一个条件断点 
b test.c:8 if intValue == 5 
condition 与break if类似，只是condition只能用在已存在的断点上 
修改断点号为bnum的停止条件为expression 
condition bnum expression 
清楚断点号为bnum的停止条件 
condition bnum 
ignore 忽略停止条件几次 
表示忽略断点号为bnum的停止条件count次 
Ignore bnum count
```
### 多文件设置断点
```
在源文件filename的linenum行处停住 
break filename:linenum
在源文件filename的function函数的入口处停住 
break filename:function 或function(type,type) 
```
### 查询断点
```
info b
```
### 观察点
```
watch 为表达式（变量）expr设置一个观察点。当表达式值有变化时，马上停住程序。 
rwatch表达式（变量）expr被读时，停住程序。 
awatch 表达式（变量）的值被读或被写时，停住程序。 
info watchpoints列出当前所设置了的所有观察点。
```
### 维护断点
```
delete 断点号n：删除第n个断点
disable 断点号n：暂停第n个断点
enable 断点号n：开启第n个断点
clear 行号n：清除第n行的断点
delete breakpoints：清除所有断点
```
## 调试代码
### 运行程序
```
run 运行程序，可简写为r
next 单步跟踪，函数调用当作一条简单语句执行，可简写为n
step 单步跟踪，函数调进入被调用函数体内，可简写为s
finish 退出函数
until 在一个循环体内单步跟踪时，这个命令可以运行程序直到退出循环体,可简写为u。
continue 继续运行程序，可简写为c
info program 来查看程序的是否在运行，进程号，被暂停的原因。
quit：简记为 q ，退出gdb
```
### 打印表达式
```
print 打印变量、字符串、表达式等的值，可简写为p
p count 打印count的值
print   h@10 数组首地址@数组长度
```
### 查看运行信息
```
whatis 命令可以显示某个变量的类型
where/bt ：当前运行的堆栈列表； 
frame
info program： 来查看程序的是否在运行，进程号，被暂停的原因。
```
### 信号
```
signal signal
```
## 窗口
```
Ctrl+x+a
(focus)fs next在src和cmd之间切换外，还可以使用fs src切换到src，和fs cmd切换到cmd
layout：用于分割窗口，可以一边查看代码，一边测试：
layout src：显示源代码窗口
layout asm：显示反汇编窗口
layout regs：显示源代码/反汇编和CPU寄存器窗口
layout split：显示源代码和反汇编窗口
Ctrl + L：刷新窗口
```