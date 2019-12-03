## 异常处理（try catch）
异常必须显式地抛出，才能被检测和捕获到；如果没有显式的抛出，即使有异常也检测不到。
```c++
抛出（Throw）--> 检测（Try） --> 捕获（Catch）
```
程序的错误大致可以分为三种，分别是语法错误、逻辑错误和运行时错误。

运行时错误例如除数为 0、内存分配失败、数组越界、文件不存在等。C++提供了异常（Exception）机制，让我们能够捕获运行时错误，给程序一次“起死回生”的机会，或者至少告诉用户发生了什么再终止程序。

```c++
try{
    //可能抛出异常的语句
}catch (exception_type_1 e){
    //处理异常的语句
}catch (exception_type_2 e){
    //处理异常的语句
}
//其他的catch
catch (exception_type_n e){
    //处理异常的语句
}
```
### throw异常规范

1. 派生类虚函数的异常规范必须与基类虚函数的异常规范一样严格，或者更严格。
```c++
class Base{
public:
    virtual int fun1(int) throw();
    virtual int fun2(int) throw(int);
    virtual string fun3() throw(int, string);
};
class Derived:public Base{
public:
    int fun1(int) throw(int);   //错！异常规范不如 throw() 严格
    int fun2(int) throw(int);   //对！有相同的异常规范
    string fun3() throw(string);  //对！异常规范比 throw(int,string) 更严格
}
```
2. 在函数声明和函数定义中必须同时指明，并且要严格保持一致，不能更加严格或者更加宽松。
3. 请抛弃异常规范，不要再使用它。异常规范是 C++98 新增的一项功能，但是后来的 C++11 已经将它抛弃了，不再建议使用。2333

### exception类

```c++
class exception{
public:
    exception () throw();  //构造函数
    exception (const exception&) throw();  //拷贝构造函数
    exception& operator= (const exception&) throw();  //运算符重载
    virtual ~exception() throw();  //虚析构函数
    virtual const char* what() const throw();  //虚函数
}
```