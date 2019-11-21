<center>
![Go_Gopher](../image/Go_Gopher.jpg)
</center>

## 变量与常量
### 变量声明
声明变量的一般形式，指定变量类型，声明后若不赋值，使用**默认值**。
```go
var name type
name = value
```

简短模式声明(short variable declaration)，省略var。有以下限制：

* 不能提供数据类型。
* 左侧的变量不应该是已经声明过的(多变量声明时，**至少保证一个是新变量**)，否则会导致编译错误。
* 简短声明**只能被用在函数体内，不可以用于全局变量的声明与赋值**。

```go
name := value
```

多变量声明模式：
```go
var name1, name2, name3 type
name1, name2, name3 = v1, v2, v3

var name1, name2, name3 = v1, v2, v3

var (
    name1 type1
    name2 type2
    name3 struct{
        name4 type4
    }
)
```

### 初始化
Go语言在声明(不初始化)变量时，会自动对变量对应的内存区初始化该变量的默认值：

* 整型和浮点型变量的默认值为 0 和 0.0。
* 字符串变量的默认值为空字符串。
* 布尔型变量默认为 bool。
* 切片、函数、指针变量的默认为 nil。

变量初始化的标准格式：
```go
var name type = value
```
如果变量声明时具有初始值，可省略变量声明中的类型，Go将根据初始值来推断变量类型(**类型推断**Type inference)。
```go
var name = value /* no type */
```

短变量声明并初始化时，至少有一个新声明的变量出现在左值中，其他变量名可能是重复声明，编译器不会报错。
```go
name1, name2 := value1, value2
name3, name2 := value3, value2
```

### 多重赋值
除了多变量声明、初始化，还可以进行多变量同时赋值。多重赋值时，变量的左值和右值按从左到右的顺序赋值。

多重赋值的特性，还可进行**变量交换**。
```go
var a int = 100
var b int = 200
b, a = a, b
```

### 匿名变量
匿名变量使用"_"标识符(空白标识符)，匿名变量可以像其他变量一样声明或赋值(任何类型都可以赋值给它)，但任何赋值都会被抛弃，不能在后续代码中使用(对其它变量赋值)。
```go
a, _ := function1()
```
匿名变量不占用内存空间，不会分配内存。匿名变量与匿名变量之间也不会因为多次声明而无法使用。

### 作用域
变量定义位置的不同，可以分为以下三种作用域：

* 函数外定义的变量称为全局变量作用域。
* 函数内定义的变量称为局部变量作用域。
* 函数定义中的变量称为形式参数作用域。

### 变量逃逸(Escape Analysis)
编译器觉得变量应该分配在堆和栈上的原则是：

* 变量是否被取地址。
* 变量是否发生逃逸。

### 常量
常量使用关键字```const```定义，用于存储不会改变的数据，常量是在编译时被创建的，即使定义在函数内部也是如此，并且只能是布尔型、数字型（整数型、浮点型和复数）和字符串型。

```go
const name [type] = value
const b string = "abc"  //显式类型定义
const b = "abc"     //隐式类型定义
```

#### iota 常量生成器
```iota```常量生成器用于生成一组以相似规则初始化的常量，不用每行都写一遍初始化表达式。在一个```const```声明语句中，在第一个声明的常量所在的行，```iota```将会被置为0，然后在每一个有常量声明的行加一。

```go
//模拟枚举
type Weekday int
const (
    Sunday Weekday = iota
    Monday
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
)
```
无类型常量
### 类型别名
```go
type TypeAlias = Type
```

## 基本数据类型
### 整数类型

|数据类型|位(bit)宽度|字节宽度|数值范围|
|:-:|:-|:-|:-|
|int|32位机器32位</br>64位机器64位|4</br>8|-2^31^ ~ 2^31^-1</br>-2^63^ ~ 2^63^-1|
|uint|32位机器32位</br>64位机器64位|4</br>8|0 ~ 2^32^</br>0 ~ 2^64^|
|int8|8|1|-128~127|
|int16|16|2|-32768~32767|
|int32|32|4|约-21.47~21.47亿|
|int64|64|8|约-922亿亿~922亿亿|
|uint8|8|1|0~255|
|uint16|16|2|0~65535|
|uint32|32|4|约0~42.94亿|
|uint64|64|8|约0~1844亿亿|

* 8进制标识法"0"
* 16进制表示法"0x"

### 浮点数类型
Go语言中浮点数部分只能用10进制表示。

* float32 IEEE-754 32位浮点型数
* float64 IEEE-754 64位浮点型数

```go
const e = .71828 // 0.71828
const f = 1.     // 1

var a float32 = 3.9E-2 //表示浮点数0.039
var b float64 = 3.9E+1 //表示浮点数39

const Avogadro = 6.02214129e23  // 阿伏伽德罗常数
const Planck   = 6.62606957e-34 // 普朗克常数
```
### 复数类型

* complex128 64位实数和虚数 复数的默认类型
* complex64 32位实数和虚数

```go
var name complex128 = complex(x, y)
name := complex(x, y)   //x+yi(i 是虚数单位)
real(z) //实部
imag(z) //虚部
```
### bool类型
布尔类型的值只有两种：```true```或```false```。

布尔值并不会隐式转换为数字值 0 或 1，反之亦然。布尔型无法参与数值运算，也无法与其他类型进行强制转换。

if 和 for 语句的条件部分都是布尔类型的值，并且==和<等比较操作也会产生布尔型的值。

布尔值可以和 &&（AND）和 ||（OR）操作符结合，并且有短路行为。

### byte与rune
byte与rune都属于别名类型。byte是uint8的别名类型，而rune是int32的别名类型。

%U输出格式为```U+hhhh```的字符串。

### 字符串类型
字符串的表示法有两种：

* 解释型("")表示法，转义符会起作用，不能跨行。
* 原生(\`)表示法，所见即所得的(除了回车符)，能跨行。

```go
var str1 string = "hello world"
var str2 string = `hello 
world`
```
### 指针
```go
var var_name *var-type
var var_name **var-type
```
### 类型转换
```go
valueOfTypeB = typeB(valueOfTypeA)
```
## 复合数据类型
### 数组
数组声明:
```go
var 数组变量名 [元素数量]Type
var q [3]int = [3]int{1, 2, 3}

var array [4][2]int
// 声明并初始化数组中索引为 1 和 3 的元素
array = [4][2]int{1: {20, 21}, 3: {40, 41}}
```
数组长度的位置出现“...”省略号，则表示数组的长度是根据初始化值的个数来计算。
```go
q := [...]int{1, 2, 3}
```
### 切片(slice)
切片(slice)是对数组的一个连续片段的引用，所以切片是一个**引用类型**，这个片段可以是整个数组，也可以是由起始和终止索引标识的一些项的子集，需要注意的是，终止索引标识的项不包括在切片内。

```go
slice [开始位置 : 结束位置]
```
切片类型声明:
```go
var name []Type
var numListEmpty = []int{}  //空切片
```
切片是动态结构，只能与 nil 判定相等，不能互相判定相等。

```go
make( []Type, size, cap )
```
切片append()操作
```go
var a []int
a = append(a, 1) // 追加1个元素
a = append(a, 1, 2, 3) // 追加多个元素, 手写解包方式
a = append(a, []int{1,2,3}...) // 追加一个切片, 切片需要解包
var a = []int{1,2,3}
a = append([]int{0}, a...) // 在开头添加1个元素
a = append([]int{-3,-2,-1}, a...) // 在开头添加1个切片
var a []int
a = append(a[:i], append([]int{x}, a[i:]...)...) // 在第i个位置插入x
a = append(a[:i], append([]int{1,2,3}, a[i:]...)...) // 在第i个位置插入切片
```
切片copy()操作```copy( destSlice, srcSlice []T) int```
```go
slice1 := []int{1, 2, 3, 4, 5}
slice2 := []int{5, 4, 3}
copy(slice2, slice1) // 只会复制slice1的前3个元素到slice2中
copy(slice1, slice2) // 只会复制slice2的3个元素到slice1的前3个位置
```
切片删除操作
```go
a = []int{1, 2, 3}
a = a[N:] // 删除开头N个元素
a = a[:copy(a, a[N:])] // 删除开头N个元素
a = append(a[:i], a[i+N:]...) // 删除中间N个元素
a = a[:i+copy(a[i:], a[i+N:])] // 删除中间N个元素
a = a[:len(a)-N] // 删除尾部N个元素
```
循环迭代切片range
```go
// 创建一个整型切片
// 其长度和容量都是 4 个元素
slice := []int{10, 20, 30, 40}
// 迭代每一个元素，并显示其值
for index, value := range slice {
    fmt.Printf("Index: %d Value: %d\n", index, value)
}
```
多维切片
```go
// 创建一个整型切片
slice := [][]int{{10}, {100, 200}}
// 为第一个切片追加值为 20 的元素
slice[0] = append(slice[0], 20)
```
### Map(字典/关联数组)类型
map 是引用类型，可以使用如下方式声明：
```go
var mapname map[keytype]valuetype
```
可以使用```make()```，但不能使用```new()```来构造map。
```go
make(map[keytype]valuetype, cap)
```
用切片作为map的值
```go
mp1 := make(map[int][]int)
mp2 := make(map[int]*[]int)
```
```go
scene := make(map[string]int)
scene["route"] = 66
scene["brazil"] = 4
scene["china"] = 960
for k, v := range scene {
    fmt.Println(k, v)
}
```
使用 delete() 函数从 map 中删除键值对：```delete(map, 键)```。

#### sync.Map
```go
package main
import (
      "fmt"
      "sync"
)
func main() {
    var scene sync.Map
    // 将键值对保存到sync.Map
    scene.Store("greece", 97)
    scene.Store("london", 100)
    scene.Store("egypt", 200)
    // 从sync.Map中根据键取值
    fmt.Println(scene.Load("london"))
    // 根据键删除对应的键值对
    scene.Delete("london")
    // 遍历所有sync.Map中的键值对
    scene.Range(func(k, v interface{}) bool {
        fmt.Println("iterate:", k, v)
        return true
    })
}
```

### 列表List
在Go语言中，列表使用 container/list 包来实现，内部的实现原理是双链表，列表能够高效地进行任意位置的元素插入和删除操作。

list 的初始化有两种方法：分别是使用 New() 函数和 var 关键字声明，两种方法的初始化效果都是一致的。

```go
变量名 := list.New()
var 变量名 list.List
```

列表与切片和 map 不同的是，列表并没有具体元素类型的限制。

|方法|功能|
|:-:|:-|
|InsertAfter(v interface {}, mark * Element) * Element|在 mark 点之后插入元素，mark 点由其他插入函数提供|
|InsertBefore(v interface {}, mark * Element) *Element|在 mark 点之前插入元素，mark 点由其他插入函数提供|
|PushBackList(other *List)|添加 other 列表元素到尾部|
|PushFrontList(other *List)|添加 other 列表元素到头部|

PushFront和PushBack方法都会返回一个 *list.Element 结构，如果在以后的使用中需要删除插入的元素，则只能通过 *list.Element 配合 Remove() 方法进行删除。

## 流程控制
### 条件
### 选择
Go语言中case是一个独立的代码块，执行完毕后不会像C语言那样紧接着执行下一个case。加入了```fallthrough```关键字来顺序执行所有case分支。

### 循环
Go语言中的循环语句只支持for关键字，而不支持while和do-while结构。

#### for range键值循环
```go
for key, val := range coll {
    ...
}
```
### 跳转
```goto```,```break```,```continue```.

## 函数
函数声明包括函数名、形式参数列表、返回值列表（可省略）以及函数体。

如果返回值是同一种类型，则用括号将多个返回值类型括起来，用逗号分隔每个返回值的类型。

Go语言支持对返回值进行命名，这样返回值就和参数一样拥有参数变量名和类型。

```go
func 函数名(形式参数列表)(返回值列表){
    函数体
}
```
---

## 类(结构体)
### 方法
### 实例化
### 继承

## 接口

## 垃圾回收处理

## 异常处理

## 包管理

## 并发
### 协程

## 断言和反射

## 文件处理

## 网络编程
