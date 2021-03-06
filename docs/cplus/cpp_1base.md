## C++基础
### 编译运行
```
gcc main.cc -lstdc++
g++ main.cc
```
### namesapce
```
namespace name{
    //variables, functions, classes
}

using name::xxx;
```
### const
C语言对```const```的处理和普通变量一样，会到内存中读取数据，C++对``` const```的处理更像是编译时期的#define，是一个值替换的过程。

C和C++中全局```const```变量的作用域相同，都是当前文件，不同的是它们的可见范围：C语言中```const```全局变量的可见范围是整个程序，在其他文件中使用```extern```声明后就可以使用；而C++中```const```全局变量的可见范围仅限于当前文件，在其他文件中不可见，可以定义在头文件中，多次引入后不会出错。

### inline内联函数
```inline```关键字在函数定义处添加，在函数声明处添加```inline```关键字虽然没有错，但这种做法是无效的，编译器会忽略函数声明处的```inline```关键字。

在多文件编程时，建议将内联函数的定义直接放在头文件中，并且禁用内联函数的声明。

### 函数默认参数
C++规定，默认参数只能放在形参列表的最后，而且一旦为某个形参指定了默认值，那么后面的所有形参都必须有默认值。

在给定的作用域中只能指定一次默认参数。（同一源文件内定义+声明带默认参数会报错）

### 重载
函数重载：函数名字相同，参数列表不同（包括参数的类型、参数的个数和参数的顺序，只要有一个不同就叫做参数列表不同）。函数的返回类型可以相同也可以不相同。仅仅返回类型不同不足以成为函数的重载。

注意重载过程中可能发生类型转换与二义性。