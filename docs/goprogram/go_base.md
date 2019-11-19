<center>
![Go_Gopher](../image/Go_Gopher.jpg)
</center>

## 变量

Go语言的基本类型有：

- bool
- string
- int、int8、int16、int32、int64
- uint、uint8、uint16、uint32、uint64、uintptr
- byte // uint8 的别名
- rune // int32 的别名 代表一个 Unicode 码
- float32、float64
- complex64、complex128

Go语言变量声明有以下三种格式:

- 标准格式 `var name type`
- 批量格式
```go
var (
    a int
    b string
    c []float32
    d func() bool
    e struct {
        x int
    }
)
```
- 简短格式 ```名字 := 表达式```简短模式有以下限制：
    - 定义变量，同时显式初始化。
    - 不能提供数据类型。
    - 只能用在函数内部。