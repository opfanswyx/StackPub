## 进阶
### 拷贝构造函数(Copy Constructor)
const 引用
只要创建对象，就会调用构造函数。拷贝是在初始化阶段进行的，也就是用其它对象的数据来初始化新对象的内存。
```c++
#include <iostream>
#include <string>
using namespace std;
class Student{
public:
    Student(string name = "", int age = 0, float score = 0.0f);  //普通构造函数
    Student(const Student &stu);  //拷贝构造函数（声明）
public:
    void display();
private:
    string m_name;
    int m_age;
    float m_score;
};
Student::Student(string name, int age, float score): m_name(name), m_age(age), m_score(score){ }
//拷贝构造函数（定义）
Student::Student(const Student &stu){
    this->m_name = stu.m_name;
    this->m_age = stu.m_age;
    this->m_score = stu.m_score;
   
    cout<<"Copy constructor was called."<<endl;
}
void Student::display(){
    cout<<m_name<<"的年龄是"<<m_age<<"，成绩是"<<m_score<<endl;
}
int main(){
    Student stu1("小明", 16, 90.5);
    Student stu2 = stu1;  //调用拷贝构造函数
    Student stu3(stu1);  //调用拷贝构造函数
    stu1.display();
    stu2.display();
    stu3.display();
   
    return 0;
}
```
在定义的同时进行赋值叫做初始化（Initialization），定义完成以后再赋值（不管在定义的时候有没有赋值）就叫做赋值（Assignment）。初始化只能有一次，赋值可以有多次。

当以拷贝的方式初始化一个对象时，会调用拷贝构造函数；当给一个对象赋值时，会调用重载过的赋值运算符。



```c++

```
#### 深拷贝和浅拷贝

#### 重载=(赋值运算符)

#### 拷贝控制操作

### 类型转换相关

#### 转换构造函数(将其它类型转换为当前类的类型)

#### 类型转换函数(将当前类的类型转换为其它类型)

#### 强制类型转换运算符

### 智能指针shared_ptr
```c++
shared_ptr<T> ptr(new T);  // T 可以是 int、char、类等各种类型
```
### lambda表达式(匿名函数)
```c++
[外部变量访问方式说明符] (参数表) -> 返回值类型
{
   语句块
}
```
其中，“外部变量访问方式说明符”可以是=或&，表示{}中用到的、定义在{}外面的变量在{}中是否允许被改变。=表示不允许，&表示允许。当然，在{}中也可以不使用定义在外面的变量。“-> 返回值类型”可以省略。

### auto和decltype关键字

### 移动构造函数

### 右值引用