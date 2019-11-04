## 异常处理（try catch）
异常必须显式地抛出，才能被检测和捕获到；如果没有显式的抛出，即使有异常也检测不到。
```c++
抛出（Throw）--> 检测（Try） --> 捕获（Catch）
```
程序的错误大致可以分为三种，分别是语法错误、逻辑错误和运行时错误。
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