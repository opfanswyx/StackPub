## 类(结构体)
结构体的定义格式如下：
```go
type 类型名 struct {
    字段1 字段1类型
    字段2 字段2类型
    …
}
```
### 实例化
```go
var ins T
ins := new(T)
```
对结构体进行&取地址操作时，视为对该类型进行一次 new 的实例化操作，取地址格式如下：
```go
ins := &T{} //ins 为结构体的实例，类型为 *T，是指针类型。
```
初始化结构体
```go
ins := 结构体类型名{
    字段1: 字段1的值,
    字段2: 字段2的值,
    …
}

ins := struct {
    字段1 字段类型1
    字段2 字段类型2
    …
}
```
### 方法
接收器格式
```go
func (接收器变量 接收器类型) 方法名(参数列表) (返回参数) {
    函数体
}
```
当方法作用于非指针类型接收器，Go语言会在代码运行时将接收器的值复制一份，在非指针接收器的方法中可以获取接收器的成员值，但修改后无效。

**为基本类型添加方法**
```go
package main
import (
    "fmt"
)
// 将int定义为MyInt类型
type MyInt int
// 为MyInt添加IsZero()方法
func (m MyInt) IsZero() bool {
    return m == 0
}
// 为MyInt添加Add()方法
func (m MyInt) Add(other int) int {
    return other + int(m)
}
func main() {
    var b MyInt
    fmt.Println(b.IsZero())
    b = 1
    fmt.Println(b.Add(2))
}
```
### 继承
在一个结构体中对于每一种数据类型(包括结构体类型)只能有一个匿名字段。

Go语言中使用结构体内嵌模拟类的继承。
```go
package main
import "fmt"
// 可飞行的
type Flying struct{}
func (f *Flying) Fly() {
    fmt.Println("can fly")
}
// 可行走的
type Walkable struct{}
func (f *Walkable) Walk() {
    fmt.Println("can calk")
}
// 人类
type Human struct {
    Walkable // 人类能行走
}
// 鸟类
type Bird struct {
    Walkable // 鸟类能行走
    Flying   // 鸟类能飞行
}
func main() {
    // 实例化鸟类
    b := new(Bird)
    fmt.Println("Bird: ")
    b.Fly()
    b.Walk()
    // 实例化人类
    h := new(Human)
    fmt.Println("Human: ")
    h.Walk()
}
```
### 垃圾回收和SetFinalizer
```go
runtime.GC()
fmt.Printf("%d\n", runtime.MemStats.Alloc/1024)
runtime.SetFinalizer(obj, func(obj *typeObj))
```
## 接口
```go
type 接口类型名 interface{
    方法名1( 参数列表1 ) 返回值列表1
    方法名2( 参数列表2 ) 返回值列表2
    …
}
```
## 垃圾回收处理

## 异常处理

## 包管理

## 并发
### 协程

## 断言和反射

## 文件处理

## 网络编程