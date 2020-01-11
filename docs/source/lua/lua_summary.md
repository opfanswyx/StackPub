## Lua环境安装
```
curl -R -O http://www.lua.org/ftp/lua-5.3.0.tar.gz
tar zxf lua-5.3.0.tar.gz
cd lua-5.3.0
make linux test
make install
```
### 注释
单行注释
```lua
--
```
多行注释
```lua
--[[
多行注释
多行注释
]]--
```


```lua
lua hello.lua

lua -i prog    --使用-i参数后让lua语言解释器在执行完prog程序后进行交互模式。

dofile("hello.lua")      --该函数会执行一个文件。
```

在默认情况下，变量总是认为是全局的。

全局变量不需要声明，给一个变量赋值后即创建了这个全局变量，访问一个没有初始化的全局变量也不会出错，只不过得到的结果是：nil。

## Lua数据类型

|数据类型|描述|
|:-:|:-|
|nil|表示一个无效值，nil作比较时应该加上双引号"|
|boolean|fase和true|
|number|表示双精度类型的实浮点数|
|string|字符串由一对双引号或单引号来表示|
|function|由C或Lua编写的函数|
|userdata|表示任意存储在变量中的C数据结构|
|thread|表示执行的独立线路，用于执行协同程序|
|table|	Lua 中的表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字、字符串或表类型。在 Lua 里，table 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。|

## Lua变量

Lua 变量有三种类型：全局变量、局部变量、表中的域。

Lua 中的变量全是全局变量，那怕是语句块或是函数里，除非用 local 显式声明为局部变量。

局部变量的作用域为从声明位置开始到所在语句块结束。应该尽可能的使用局部变量，有两个好处：

1. 避免命名冲突。
2. 访问局部变量的速度比全局变量更快。

变量的默认值均为 nil。

Lua 可以对多个变量同时赋值，变量列表和值列表的各个元素用逗号分开，赋值语句右边的值会依次赋给左边的变量。

当变量个数和值的个数不一致时，Lua会一直以变量个数为基础采取以下策略：

```
a. 变量个数 > 值的个数             按变量个数补足nil
b. 变量个数 < 值的个数             多余的值会被忽略
```

```lua
a, b, c = 0, 1
print(a,b,c)             --> 0   1   nil
 
a, b = a+1, b+1, b+2     -- value of b+2 is ignored
print(a,b)               --> 1   2
 
a, b, c = 0
print(a,b,c)             --> 0   nil   nil
```

## 字符串
Lua 语言中字符串可以使用以下三种方式来表示：

* 单引号间的一串字符。
* 双引号间的一串字符。
* [[和]]间的一串字符。

使用双引号和单引号声明字符串是等价的。它们两者唯一的区别在于，使用双引号声明的字符串中出现单引号时，单引号可以不用转义；使用单引号声明的字符串中出现双引号时，双引号可以不用转义。

```lua
string1 = "Lua"
print("\"字符串 1 是\"",string1)
string2 = 'runoob.com'
print("字符串 2 是",string2)

string3 = [["Lua 教程"]]
print("字符串 3 是",string3)

"字符串 1 是"    Lua
字符串 2 是    runoob.com
字符串 3 是    "Lua 教程"
```
### 字符串操作

|函数|说明|举例|
|:-:|:-|:-|
|string.upper(argument)|字符串全部转为大写字母||
|string.lower(argument)|字符串全部转为小写字母||
|string.find (str, substr, [init, [end]])|在一个指定的目标字符串中搜索指定的内容(第三个参数为索引),返回其具体位置。不存在则返回 nil|string.find("Hello Lua user", "Lua", 1) |
|string.reverse(arg)|字符串反转||
|string.format(...)|返回一个类似printf的格式化字符串|string.format("the value is:%d",4)|
|string.char(arg)</br>string.byte(arg[,int])|char 将整型数字转成字符并连接， byte 转换字符为整数值(可以指定某个字符，默认第一个字符)|string.char(97,98,99,100)</br>string.byte("ABCD",4)|
|string.len(arg)|计算字符串长度||
|..|链接两个字符串||


## Lua函数
```lua
optional_function_scope function function_name( argument1, argument2, argument3..., argumentn)
    function_body
    return result_params_comma_separated
end
```

Lua 函数可以接受可变数目的参数，和 C 语言类似，在函数参数列表中使用三点 ... 表示函数有可变的参数。

### 运算符

|操作符|说明|
|:-:|:-:|
|..|连接两个字符串|
|#|一元运算符，返回字符串或表的长度。#"Hello" 返回 5|

## Lua数组
```lua
array = {"Lua", "Hello"}

for i= 0, 2 do
   print(array[i])
end
```

## 迭代器
迭代器（iterator）是一种对象，它能够用来遍历标准模板库容器中的部分或全部元素，每个迭代器对象代表容器中的确定的地址。

### 泛型for迭代器
泛型 for 在自己内部保存迭代函数，实际上它保存三个值：迭代函数、状态常量、控制变量。
```lua
for k, v in pairs(t) do
    print(k, v)
end
```
```
array = {"hello", "world"}

for key,value in ipairs(array)
do
   print(key, value)
end
```

### 无状态迭代器

### 多状态迭代器

## Lua table
table 是 Lua 的一种数据结构用来帮助我们创建不同的数据类型，如：数组、字典等。

构造器是创建和初始化表的表达式。表是Lua特有的功能强大的东西。最简单的构造函数是{}，用来创建一个空表。

```lua
-- 初始化表
mytable = {}

-- 指定值
mytable[1]= "Lua"

-- 移除引用
mytable = nil
-- lua 垃圾回收会释放内存
```

### table操作

|操作|描述|
|:-:|:-|
|table.concat (table [, sep [, start [, end]]])|列出参数中指定table的数组部分从start位置到end位置的所有元素, 元素间以指定的分隔符(sep)隔开|
|table.insert (table, [pos,] value)|在table的数组部分指定位置(pos)插入值为value的一个元素. pos参数可选, 默认为数组部分末尾|
|table.remove (table [, pos])|返回table数组部分位于pos位置的元素. 其后的元素会被前移. pos参数可选, 默认为table长度, 即从最后一个元素删起|
|table.sort (table [, comp])|对给定的table进行升序排序|

## 模块与包
模块类似于一个封装库，从 Lua 5.1 开始，Lua 加入了标准的模块管理机制，可以把一些公用的代码放在一个文件里，以 API 接口的形式在其他地方调用，有利于代码的重用和降低代码耦合度。

```lua
-- 文件名为 module.lua
-- 定义一个名为 module 的模块
module = {}
 
-- 定义一个常量
module.constant = "这是一个常量"
 
-- 定义一个函数
function module.func1()
    io.write("这是一个公有函数！\n")
end
 
local function func2()
    print("这是一个私有函数！")
end
 
function module.func3()
    func2()
end
 
return module
```

Lua提供require的函数用来加载模块。```require("<模块名>")```或者```require"<模块名>"```。

require用于搜索Lua文件的路径是存放在全局变量 package.path 中，当Lua启动后，会以环境变量LUA_PATH的值来初始这个环境变量。如果没有找到该环境变量，则使用一个编译时定义的默认路径来初始化。

```lua
#LUA_PATH
export LUA_PATH="~/lua/?.lua;;"

source ~/.profile
```

### C包
与Lua中写包不同，C包在使用以前必须首先加载并连接，在大多数系统中最容易的实现方式是通过动态连接库机制。

Lua在一个叫loadlib的函数内提供了所有的动态连接的功能。这个函数有两个参数:库的绝对路径和初始化函数。

```lua
local path = "/usr/local/lua/lib/libluasocket.so"
local f = loadlib(path, "luaopen_socket")

local f = assert(loadlib(path, "luaopen_socket"))
f()  -- 真正打开库
```

loadlib 函数加载指定的库并且连接到 Lua，然而它并不打开库（也就是说没有调用初始化函数），反之他返回初始化函数作为 Lua 的一个函数，这样我们就可以直接在Lua中调用他。

## 元表(Metatable)
元表(Metatable)，允许我们改变table的行为，每个行为关联了对应的元方法。

* setmetatable(table,metatable): 对指定 table 设置元表(metatable)，如果元表(metatable)中存在 __metatable 键值，setmetatable 会失败。
* getmetatable(table): 返回对象的元表(metatable)。

## Lua协同程序(coroutine)
Lua 协同程序(coroutine)与线程比较类似：拥有独立的堆栈，独立的局部变量，独立的指令指针，同时又与其它协同程序共享全局变量和其它大部分东西。

线程与协同程序的主要区别在于，一个具有多个线程的程序可以同时运行几个线程，而协同程序却需要彼此协作的运行。在任一指定时刻只有一个协同程序在运行，并且这个正在运行的协同程序只有在明确的被要求挂起的时候才会被挂起。
协同程序有点类似同步的多线程，在等待同一个线程锁的几个线程有点类似协同。

|方法|描述|
|:-:|:-|
|coroutine.create()|创建 coroutine，返回 coroutine， 参数是一个函数，当和 resume 配合使用的时候就唤醒函数调用|
|coroutine.resume()|重启 coroutine，和 create 配合使用|
|coroutine.yield()|挂起 coroutine，将 coroutine 设置为挂起状态，这个和 resume 配合使用能有很多有用的效果|
|coroutine.status()|	查看 coroutine 的状态</br>注：coroutine 的状态有三种：dead，suspended，running，具体什么时候有这样的状态请参考下面的程序|
|coroutine.wrap()|创建 coroutine，返回一个函数，一旦你调用这个函数，就进入 coroutine，和 create 功能重复|
|coroutine.running()|返回正在跑的 coroutine，一个 coroutine 就是一个线程，当使用running的时候，就是返回一个 corouting 的线程号|

### 生产者消费者示例
```lua
local newProductor

function productor()
     local i = 0
     while true do
          i = i + 1
          send(i)     -- 将生产的物品发送给消费者
     end
end

function consumer()
     while true do
          local i = receive()     -- 从生产者那里得到物品
          print(i)
     end
end

function receive()
     local status, value = coroutine.resume(newProductor)
     return value
end

function send(x)
     coroutine.yield(x)     -- x表示需要发送的值，值返回以后，就挂起该协同程序
end

-- 启动程序
newProductor = coroutine.create(productor)
consumer()
```

## 文件I/O

## 错误处理

* 语法错误
* 运行错误

lua使用两个函数：assert 和 error 来处理错误。

## 调试

## 垃圾回收
Lua 运行了一个垃圾收集器来收集所有死对象 （即在 Lua 中不可能再访问到的对象）来完成自动内存管理的工作。 Lua 中所有用到的内存，如：字符串、表、用户数据、函数、线程、 内部结构等，都服从自动管理。

Lua 提供了以下函数collectgarbage ([opt [, arg]])用来控制自动内存管理:

* collectgarbage("collect"): 做一次完整的垃圾收集循环。通过参数 opt 它提供了一组不同的功能：
* collectgarbage("count"): 以 K 字节数为单位返回 Lua 使用的总内存数。 这个值有小数部分，所以只需要乘上 1024 就能得到 Lua 使用的准确字节数（除非溢出）。
* collectgarbage("restart"): 重启垃圾收集器的自动运行。
* collectgarbage("setpause"): 将 arg 设为收集器的 间歇率。 返回 间歇率 的前一个值。
* collectgarbage("setstepmul"): 返回 步进倍率 的前一个值。
* collectgarbage("step"): 单步运行垃圾收集器。 步长"大小"由 arg 控制。 传入 0 时，收集器步进（不可分割的）一步。 传入非 0 值， 收集器收集相当于 Lua 分配这些多（K 字节）内存的工作。 如果收集器结束一个循环将返回 true 。
* collectgarbage("stop"): 停止垃圾收集器的运行。 在调用重启前，收集器只会因显式的调用运行。

## 数据库访问
```
$ wget http://luarocks.org/releases/luarocks-2.2.1.tar.gz
$ tar zxpf luarocks-2.2.1.tar.gz
$ cd luarocks-2.2.1
$ ./configure; sudo make bootstrap
$ sudo luarocks install luasocket
$ lua
Lua 5.3.0 Copyright (C) 1994-2015 Lua.org, PUC-Rio
> require "socket"

luarocks install luasql-sqlite3
luarocks install luasql-postgres
luarocks install luasql-mysql
luarocks install luasql-sqlite
luarocks install luasql-odbc
```
Lua 连接MySql 数据库
```lua
require "luasql.mysql"

--创建环境对象
env = luasql.mysql()

--连接数据库
conn = env:connect("数据库名","用户名","密码","IP地址",端口)

--设置数据库的编码格式
conn:execute"SET NAMES UTF8"

--执行数据库操作
cur = conn:execute("select * from role")

row = cur:fetch({},"a")

--文件对象的创建
file = io.open("role.txt","w+");

while row do
    var = string.format("%d %s\n", row.id, row.name)

    print(var)

    file:write(var)

    row = cur:fetch(row,"a")
end


file:close()  --关闭文件对象
conn:close()  --关闭数据库连接
env:close()   --关闭数据库环境
```
## 面向对象