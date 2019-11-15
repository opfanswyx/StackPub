信息就是位+上下文

预处理，编译器，汇编器，链接器

总线，I/O设备，主存，处理器

操作系统管理硬件：防止硬件被失控的应用程序滥用。向应用程序提供简单一致的机制来控制复杂而又通常大不相同的低级硬件设备。

文件是I/O设备的抽象表示。

虚拟内存是对主存和磁盘I/O设备的抽象表示。

进程是对处理器，主存和I/O设备的抽象表示。

## 程序结构和执行
### 信息的表示和处理
#### 信息存储
大多数计算机使用8位的块，或者字节(byte)，作为最小的可寻址的内存单位，而不是访问内存中单的位。

每台计算机都有一个字长(word size)，指明指针数据的标称大小。字长决定的最重要的系统参数就是虚拟地址空间的最大大小。也就是说对于一个字长w位的机器而言，虚拟地址的范围就是0~2W-1，程序最多访问2w个字节。

ISO c99引入了一类数据类型，其数据大小是固定的，不随编译器和机器设置而变化。int32_t和int64_t分别为4字节和8字节。