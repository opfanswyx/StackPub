## 进阶
### 拷贝构造函数(复制构造函数)
const 引用
只要创建对象，就会调用构造函数。
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
### 深拷贝和浅拷贝

### 重载=(赋值运算符)

### 拷贝控制操作

### 转换构造函数

### 类型转换函数

### 强制类型转换运算符

### shared_ptr

### lambda

### auto和decltype

### 移动构造函数

### 右值引用