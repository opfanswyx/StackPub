## 信息(数据)的表示与处理

## 机器指令结构与程序优化
处理器组成:

1. 程序计数器(pc, program counter)-存着下一条指令的地址，在x86-64中称为RIP，```%rip```指令指针。
2. 寄存器(Register)-用来存储数据以便操作，存储着当前正在执行的程序相关信息
3. 条件代码(Codition codes)-通常保存最近的算术或逻辑操作的信息，用来做条件跳转。```CF```,```ZF```,```SF```,```OF```。

处理器能够执行的操作有:**存取数据**,**计算**和**传输控制**。存取数据是在内存和寄存器之间传输数据，进行计算则是对寄存器或者内存中的数据执行算术运算，传输控制主要指非条件跳转和条件分支。

### 汇编入门
汇编代码中，第一个字符串叫做**操作符**，后面跟着1|2|3个以**逗号**分隔的**操作数**。
```
指令  操作数1(, 操作数2, 操作数3)
```

|64位整型寄存器|32位|16位|说明|
|:-|:-|:-:|:-|
|%rax|%eax  %ax|%ah  %al|用于做累加|
|%rbx|%ebx  %bx|%bh  %bl|用于做内存查找的基础地址|
|%rcx|%ecx  %cx|%ch  %cl|用于计数|
|%rdx|%edx  %dx|%dh  %dl|用于保存数据|
|%rsi|%esi  %si||用于保存源索引值|
|%rdi|%edi  %di||用于保存目标索引值|
|%rsp|%esp  %sp||栈指针|
|%rbp|%ebp  %bp||基指针|
|||||
|||||

操作数的三种基本类型:**立即数(Imm)**,**寄存器值(Reg)**和**内存值(Mem)**。有些操作数带有**括号**,括号的意思就是**寻址**。寻址的通用格式为如下，其中:
```
D(Rb, Ri, S)->Mem[Reg[Rb]+S*Reg[Ri]+D]
```

* D - 常数偏移量
* Rb - 基寄存器
* Ri - 索引寄存器，不能是%rsp
* S - 系数

几种特殊情况:

* (Rb, Ri) -> Mem[Reg[Rb]+Reg[Ri]]
* D(Rb, Ri) -> Mem[Reg[Rb]+Reg[Ri]+D]
* (Rb, Ri, S) -> Mem[Reg[Rb]+S*Reg[Ri]]

假设%rdx中存放着0xf000,%rcx中存放着0x0100,则:

```
0x8(%rdx) = 0xf000 + 0x8 = 0xf008
(%rdx, %rcx) = 0xf000 + 0x100 = 0xf100
(%rdx, %rcx, 4) = 0xf000 + 4*0x100 = 0xf400
0x80(, %rdx, 2) = 2*0xf000 + 0x80 = 0x13080
```

```movq```指令，第一个操作数是源操作数，第二个操作数是目标操作数。源操作数可以是立即数，寄存器值或内存值，目标操作数只能是寄存器值或内存值。没有```movq Mem, Mem```，即没有办法用一条指令完成内存间的数据交换。

```leaq Src, Dst```，其中Src是地址表达式，把计算的值存入Dst指定的寄存器。

常见的算术运算指令

|指令|说明|
|:-|:-|
|addq Src, Dest|Dest = Dest + Src|
|subq Src, Desc|Dest = Dest - Src|
|imulq Src, Dest|Dest = Dest * Src|
|salq Src, Dest|Dest = Dest << Src|
|sarq Src, Dest|Dest = Dest >> Src|
|shrq Src, Dest|Dest = Dest >> Src|
|xorq Src, Dest|Dest = Dest ^ Src|
|andq Src, Dest|Dest = Dest & Src|
|orq Src, Dest|Dest = Dest | Src|
|incq Dest|Dest = Dest + 1|
|decq Dest|Dest = Dest -1|
|negq Dest|Dest = -Dest|
|notq Dest|Dest = ~Dest|

#### 流程控制
寄存器中存储着当前正在执行的程序相关信息，临时数据存放在(%rax,...)，运行时栈的地址存储在(%rsp)中，当前代码控制点存储在(%rip,...)中，当前测试的状态放在CF,ZF,SF,OF中。

* CF: Carry Flag(针对无符号数)
* ZF: Zero Flag
* SF: Sign Flag(针对有符号数)
* OF: Overflow Flag(针对有符号数)

举个例子，假如如```t = a + b```的语句，汇编之后假设用的是```addq Src, Dest```，那么根据这个操作结果的不同，会相应设置上面提到的四个标识位，而因为这个是执行类似操作时顺带尽心设置的，称为**隐式设置**，例如：

* 如果两个数相加，在最高位还需要进位（也就是溢出了），那么 CF 标识位就会被设置
* 如果 t 等于 0，那么 ZF 标识位会被设置
* 如果 t 小于 0，那么 SF 标识位会被设置
* 如果 2’s complement 溢出，那么 OF 标识位会被设置为 1（溢出的情况是```(a>0 && b > 0 && t <0) || (a<0 && b<0 && t>=0)）```

这就发现了，其实这四个条件代码，是用来标记上一条命令的结果的各种可能的，是自动会进行设置的。注意，使用 leaq 指令的话不会进行设置。

cmpq(```cmpq Src2(b), Src1(a)```等价于```a-b```)与testq(```testq Src2(b), Src1(a)```等价于```a&b```)指令来显式进行设置。

cpu依靠流水线工作，在执行当前操作时，会将接下来的操作所需的数据加载到寄存器中，这样执行下一个操作时，无须等待数据载入，但是遇到分支后，后续预先载入的数据可能有误，需要把流水线清空，然后重新载入，造成了性能影响。一般常用[分支预测]来解决该问题。

如果在编译器中开启```-O1```优化，那么会把```While```先翻译成```Do-While```，然后再转换成对应的```Goto```版本，因为 ```Do-While```语句执行起来更快，更符合CPU的运算模型。

#### 过程调用


#### 数据存储
结构体对齐问题
#### 缓冲区溢出
返回导向编程

### 程序优化
#### 代码移动
如果**一个表达式总是得到同样的结果，最好把它移动到循环外面，这样只需要计算一次**。编译器有时候可以自动完成，比如说使用 -O1 优化。一个例子：
```c
void set_row(double *a, double *b, long i, long n){
    long j;
    for (j = 0; j < n; j++){
        a[n*i + j] = b[j];
    }
}
```
这里```n*i```是重复被计算的，可以放到循环外面。
```c
long j;
int ni = n * i;
for (j = 0; j < n; j++){
    a[ni + j] = b[j];
}
```
#### 减少计算强度
用更简单的表达式来完成用时较久的操作，例如 16*x 就可以用 x << 4 代替，一个比较明显的例子是，可以把乘积转化位一系列的加法，如下：
```c
for (i = 0; i < n; i++){
    int ni = n * i;
    for (j = 0; j < n; j++)
        a[ni + j] = b[j];
}
```
可以把 n*i 用加法代替，比如：
```c
int ni = 0;
for (i = 0; i < n; i++){
    for (j = 0; j < n; j++)
        a[ni + j] = b[j];
    ni += n;
}
```
#### 公共子表达式
可以重用部分表达式的计算结果，例如：
```c
/* Sum neighbors of i, j */
up =    val[(i-1)*n + j  ];
down =  val[(i+1)*n + j  ];
left =  val[i*n     + j-1];
right = val[i*n     + j+1];
sum = up + down + left + right;
```
```c
long inj = i*n + j;
up =    val[inj - n];
down =  val[inj + n];
left =  val[inj - 1];
right = val[inj + 1];
sum = up + down + left + right;
```
#### 小心过程调用
```c
void lower1(char *s){
    size_t i;
    for (i = 0; i < strlen(s); i++)
        if (s[i] >= 'A' && s[i] <= 'Z')
            s[i] -= ('A' - 'a');
}
```
```c
void lower2(char *s){
    size_t i;
    size_t len = strlen(s);
    for (i = 0; i < len; i++)
        if (s[i] >= 'A' && s[i] <= 'Z')
            s[i] -= ('A' - 'a');
}
```
#### 注意内存问题
```c
// 把 nxn 的矩阵 a 的每一行加起来，存到向量 b 中
void sum_rows1(double *a, double *b, long n)
{
    long i, j;
    for (i = 0; i < n; i++)
    {
        b[i] = 0;
        for (j = 0; j < n; j++)
            b[i] += a[i*n + j];
    }
}
```
```asm
# sum_rows1 的内循环
.L4:
    movsd   (%rsi, %rax, 8), %xmm0  # 浮点数载入
    addsd   (%rdi), %xmm0           # 浮点数加
    movsd   %xmm0, (%rsi, %rax, 8)  # 浮点数保存
    addq    $8, %rdi
    cmpq    %rcx, %rdi
    jne     .L4
```
可以看到在汇编中，每次都会把 b[i] 存进去再读出来，为什么编译器会有这么奇怪的做法呢？因为有可能这里的 a 和 b 指向的是同一块内存地址，那么每次更新，都会使得值发生变化。但是中间过程是什么，实际上是没有必要存储起来的，所以我们引入一个临时变量，这样就可以消除内存引用的问题。
```c
// 把 nxn 的矩阵 a 的每一行加起来，存到向量 b 中
void sum_rows2(double *a, double *b, long n)
{
    long i, j;
    for (i = 0; i < n; i++)
    {
        double val = 0;
        for (j = 0; j < n; j++)
            val += a[i*n + j];
        b[i] = val;
    }
}
```
```asm
# sum_rows2 内循环
.L10:
    addsd   (%rdi), %xmm0   # 浮点数载入 + 加法
    addq    $9, %rdi
    cmpq    %rax, %rdi
    jne     .L10
```
## 存储器层次结构
### 随机存取存储器
**随机存取存储器**(RAM, Random-Access Memory)有两种类型：SRAM(Static RAM)和DRAM(Dynamic RAM)，SRAM非常快，也不需要定期刷新，通常用在处理器做缓存，但是比较贵；DRAM稍慢一点（大概是SRAM速度的十分之一），需要刷新，通常用作主内存，相比来说很便宜（是SRAM价格的百分之一）。

无论是DRAM还是SRAM，一旦不通电，所有的信息都会丢失。如果想要让数据持久化，可以考虑ROM, PROM, EPROM, EEPROM等介质。固件程序会存储在ROM中（比如BIOS，磁盘控制器，网卡，图形加速器，安全子系统等等）。另外一个趋势就是SSD固态硬盘，取消了机械结构，更稳定速度更快更省电。
### 传统机械硬盘
机械硬盘有许多片磁盘(platter)组成，每一片磁盘有两面；每一面由一圈圈的磁道(track)组成，而每个磁道会被分隔成不同的扇区(sector)
### 固态硬盘
固态硬盘中分成很多的块(Block)，每个块又有很多页(Page)，大约 32-128 个，每个页可以存放一定数据（大概 4-512KB），页是进行数据读写的最小单位。但是有一点需要注意，对一个页进行写入操作的时候，需要先把整个块清空（设计限制），而一个块大概在 100,000 次写入之后就会报废。

与传统的机械硬盘相比，固态硬盘在读写速度上有很大的优势。但是因为设计本身的约束，连续访问会比随机访问快，而且如果需要写入 Page，那么需要移动其他 Page，擦除整个 Block，然后才能写入。现在固态硬盘的读写速度差距已经没有以前那么大了，但是仍然有一些差距。

不过与机械硬盘相比，固态硬盘存在一个具体的寿命限制，价格也比较贵，但是因为速度上的优势，越来越多设备开始使用固态硬盘。

### 总线
总线是用来传输地址、数据和控制信号的一组平行的电线，通常来说由多个设备共享，类似于不同城市之间的高速公路，可以传输各类数据。CPU 通过总线和对应的接口来从不同的设备中获得所需要的数据，放入寄存器中等待运算。

### 缓存未命中的类型
缓存未命中有三种，这里进行简要介绍

* 强制性失效(Cold/compulsory Miss): CPU 第一次访问相应缓存块，缓存中肯定没有对应数据，这是不可避免的
* 冲突失效(Confilict Miss): 在直接相联或组相联的缓存中，不同的缓存块由于索引相同相互替换，引起的失效叫做冲突失效
- * 假设这里有 32KB 直接相联的缓存
- * 如果有两个 8KB 的数据需要来回访问，但是这两个数组都映射到相同的地址，缓存大小足够存储全部的数据，但是因为相同地址发生了冲突需要来回替换，发生的失效则全都是冲突失效（第一次访问失效依旧是强制性失效），这时缓存并没有存满
* 容量失效(Capacity Miss): 有限的缓存容量导致缓存放不下而被替换，被替换出去的缓存块再被访问，引起的失效叫做容量失效
- * 假设这里有 32KB 直接相联的缓存
- * 如果有一个 64KB 的数组需要重复访问，数组的大小远远大于缓存大小，没办法全部放入缓存。第一次访问数组发生的失效全都是强制性失效。之后再访问数组，再发生的失效则全都是容量失效，这时缓存已经存满，容量不足以存储全部数据
## 链接
C 语言代码最终成为机器可执行的程序，会像流水线上的产品一样接受各项处理：

* 预处理器：将C语言代码(da.c)转化成```da.i```文件(```gcc –E```)，对应于预处理命令```cpp```
* 编译器：C语言代码(da.c, wang.c)经过编译器的处理(```gcc -0g -S```)成为汇编代码(da.s, wang.s)
* 汇编器：汇编代码(da.s, wang.s)经过汇编器的处理(```gcc``` 或```as```)成为对象程序(da.o, wang.o)
* 链接器：对象程序(da.o, wang.o)以及所需静态库(lib.a)经过链接器的处理(```gcc```或```ld```)最终成为计算机可执行的程序
* 加载器：将可执行程序加载到内存并进行执行，```loader```和```ld-linux.so```
### 链接基本知识

1. 符号解析 Symbol resolution
2. 重定位 Relocation

对象文件(Object File)实际上是一个统称，具体来说有以下三种形式：

* 可重定位目标文件 Relocatable object file (.o file)每个 .o 文件都是由对应的 .c 文件通过编译器和汇编器生成，包含代码和数据，可以与其他可重定位目标文件合并创建一个可执行或共享的目标文件
* 可执行目标文件 Executable object file (a.out file)由链接器生成，可以直接通过加载器加载到内存中充当进程执行的文件，包含代码和数据
* 共享目标文件 Shared object file (.so file)在 windows 中被称为 Dynamic Link Libraries(DLLs)，是类特殊的可重定位目标文件，可以在链接(静态共享库)时加入目标文件或加载时或运行时(动态共享库)被动态的加载到内存并执行

上面提到的三种对象文件有统一的格式，即 Executable and Linkable Format(ELF)，因为，我们把它们统称为 ELF binaries，具体的文件格式如下

* ELF header包含 word size, byte ordering, file type (.o, exec, .so), machine type, etc
* Segment header table包含 page size, virtual addresses memory segments(sections), segment sizes
* .text section代码部分
* .rodata section
只读数据部分，例如跳转表
* .data section
初始化的全局变量
* .bss section未初始化的全局变量
* .symtab section包含 symbol table, procudure 和 static variable names 以及 section names 和 location
* .rel.txt section .text section 的重定位信息
* .rel.data section .data section 的重定位信息
* .debug section包含 symbolic debugging (gcc -g) 的信息
* Section header table每个 section 的大小和偏移量

链接器实际上会处理三种不同的符号，对应于代码中不同写法的部分：

* 全局符号 Global symbols,在当前模块中定义，且可以被其他代码引用的符号，例如非静态 C 函数和非静态全局变量
* 外部符号 External symbols,同样是全局符号，但是是在其他模块（也就是其他的源代码）中定义的，但是可以在当前模块中引用
* 本地符号 Local symbols,在当前模块中定义，只能被当前模块引用的符号，例如静态函数和静态全局变量,注意，Local linker symbol 并不是 local program variables

链接器只知道非静态的全局变量/函数，而对于局部变量一无所知。局部非静态变量会保存在栈中，局部静态变量会保存在 .bss 或 .data 中。

两个函数中定义了同名的静态变量，编译器会在 .data 部分为每一个静态变量进行定义，如果遇到同名，就会在本地的符号表中自动给出唯一的编号，例如变量 x，可能在符号表中是 x.1 和 x.2。

不同的符号是有强弱之分的，强符号：函数和初始化的全局变量，弱符号：未初始化的全局变量。

链接器在处理强弱符号的时候遵守以下规则：

1. 不能出现多个同名的强符号，不然就会出现链接错误
2. 如果有同名的强符号和弱符号，选择强符号，也就意味着弱符号是『无效』d而
3. 如果有多个弱符号，随便选择一个

**尽量避免使用全局变量**，如果一定要用的话，注意下面几点：

1. 使用静态变量
2. 定义全局变量的时候初始化
3. 注意使用 extern 关键字

## 异常控制流与信号

## 系统级I/O

## 虚拟内存与动态分配

## 网络编程

## 并行与同步