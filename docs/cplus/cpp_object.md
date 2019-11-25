## 类和对象
类是创建对象的模板(Template)，编译后不占用内存空间，在定义类时不能对成员变量进行初始化。创建对象后才给成员变量赋值(分配内存)。

使用new在堆上创建出来的对象是匿名的，不能直接使用，必须要用一个指针指向它，借助指针来访问它的成员变量或成员函数。

::被称为域解析符（也称作用域运算符或作用域限定符），用来连接类名和函数名，指明当前函数属于哪个类
### 成员对象与成员函数
在类体中和类体外定义成员函数的区别：类体中定义的成员函数会自动成为内联函数，在类体外定义的不会。

成员变量大都以m_开头，这是约定成俗的写法，不是语法规定的内容。

编译器会将成员变量和成员函数分开存储：分别为每个对象的成员变量分配内存，但是所有对象都共享同一段函数代码。

### 构造函数(Constructor)
构造函数必须是public属性的，构造函数没有返回值，不管是声明还是定义，函数名前面都不能出现返回值类型，函数体中不能有 return 语句。

#### 构造函数初始化列表
初始化const成员变量的唯一方法就是使用初始化列表。

成员变量的初始化顺序与初始化列表中列出的变量的顺序无关，它只与成员变量在类中声明的顺序有关。
```c++
class VLA{
private:
    const int m_len;
    int *m_arr;
public:
    VLA(int len);
};
//必须使用初始化列表来初始化 m_len
VLA::VLA(int len): m_len(len){
    m_arr = new int[len];
}
```
### 对象数组中元素的构造初始化
```c++
#include<iostream>
using namespace std;
class CSample{
public:
    CSample(){  //构造函数 1
        cout<<"Constructor 1 Called"<<endl;
    }
    CSample(int n){  //构造函数 2
        cout<<"Constructor 2 Called"<<endl;
    }
};
int main(){
    cout<<"stepl"<<endl;
    CSample arrayl[2];
    cout<<"step2"<<endl;
    CSample array2[2] = {4, 5};
    cout<<"step3"<<endl;
    CSample array3[2] = {3};
    cout<<"step4"<<endl;
    CSample* array4 = new CSample[2];
    delete [] array4;
    return 0;
}
//构造函数有多个参数时
class CTest{
public:
    CTest(int n){ }  //构造函数(1)
    CTest(int n, int m){ }  //构造函数(2)
    CTest(){ }  //构造函数(3)
};
int main(){
    //三个元素分别用构造函数(1)、(2)、(3) 初始化
    CTest arrayl [3] = { 1, CTest(1,2) };
    //三个元素分别用构造函数(2)、(2)、(1)初始化
    CTest array2[3] = { CTest(2,3), CTest(1,2), 1};
    //两个元素指向的对象分别用构造函数(1)、(2)初始化
    CTest* pArray[3] = { new CTest(4), new CTest(1,2) };    //pArray[2] 没有初始化，其值是随机的，不知道指向哪里。
    return 0;
}
```
### 析构函数
构造函数的名字和类名相同，而析构函数的名字是在类名前面加一个```~```符号。析构函数没有参数，不能被重载，一个类只有一个析构函数。

在所有函数之外创建的对象是全局对象，它和全局变量类似，位于内存分区中的全局数据区，程序在结束执行时会调用这些对象的析构函数。

在函数内部创建的对象是局部对象，它和局部变量类似，位于栈区，函数执行结束时会调用这些对象的析构函数。
#### 析构函数执行时机
析构函数在对象被销毁时调用，对象的销毁时机与它所在的内存区域有关：

1. 在所有函数之外创建的对象是全局对象，位于内存分区中的全局数据区，程序在结束执行时会调用这些对象的析构函数。

2. 在函数内部创建的对象是局部对象，位于栈区，函数执行结束时会调用这些对象的析构函数。

3. new创建的对象位于堆区，通过delete删除时才会调用析构函数，如果没有delete，析构函数就不会被执行。

### 成员对象和封闭类
一个类的成员变量如果是另一个类的对象，就称之为“成员对象”。包含成员对象的类叫封闭类（enclosed class）。

创建封闭类的对象时，其成员对象也需要被创建，成员对象调用哪个构造函数初始化？需要借助封闭类构造函数的初始化列表。
```c++
#include <iostream>
using namespace std;
//轮胎类
class Tyre{
public:
    Tyre(int radius, int width);
    void show() const;
private:
    int m_radius;  //半径
    int m_width;  //宽度
};
Tyre::Tyre(int radius, int width) : m_radius(radius), m_width(width){ }
void Tyre::show() const {
    cout << "轮毂半径：" << this->m_radius << "吋" << endl;
    cout << "轮胎宽度：" << this->m_width << "mm" << endl;
}
//引擎类
class Engine{
public:
    Engine(float displacement = 2.0);
    void show() const;
private:
    float m_displacement;
};
Engine::Engine(float displacement) : m_displacement(displacement) {}
void Engine::show() const {
    cout << "排量：" << this->m_displacement << "L" << endl;
}
//汽车类
class Car{
public:
    Car(int price, int radius, int width);
    void show() const;
private:
    int m_price;  //价格
    Tyre m_tyre;
    Engine m_engine;
};
Car::Car(int price, int radius, int width): m_price(price), m_tyre(radius, width)/*指明m_tyre对象的初始化方式*/{ }; //这里并没有说明 m_engine 该如何处理,有一个无参构造函数。
void Car::show() const {
    cout << "价格：" << this->m_price << "￥" << endl;
    this->m_tyre.show();
    this->m_engine.show();
}
int main()
{
    Car car(200000, 19, 245);
    car.show();
    return 0;
}
```
封闭类对象生成时，先执行所有成员对象的构造函数，然后才执行封闭类自己的构造函数。成员对象构造函数的执行次序和成员对象在类定义中的次序一致，与它们在构造函数初始化列表中出现的次序无关。

当封闭类对象消亡时，先执行封闭类的析构函数，然后再执行成员对象的析构函数，成员对象析构函数的执行次序和构造函数的执行次序相反，即先构造的后析构。
### C++ this指针
```this```指针是成员函数的一个形参，在调用成员函数时将对象的地址作为实参传递给this。不过this这个形参是隐式的，它并不出现在代码中，而是在编译阶段由编译器默默地将它添加到参数列表中。

成员函数最终被编译成与对象无关的普通函数，除了成员变量，会丢失所有信息，所以编译时要在成员函数中添加一个额外的参数，把当前对象的首地址传入，以此来关联成员函数和成员变量。这个额外的参数，就是this，它是成员函数和成员变量关联的桥梁。

1. this是const指针，它的值是不能被修改的。
2. this只能在成员函数内部使用。
3. 不能在static成员函数中使用。

### static静态成员变量和静态成员函数
static成员变量必须在类声明的外部初始化：
```c++
type class::name = value;
int Student::m_total = 0; //静态成员变量在初始化时不能再加 static
```
static成员变量的内存既不是在声明类时分配，也不是在创建对象时分配，而是在（类外）初始化时分配。反过来说，没有在类外初始化的static成员变量不能使用。

static成员变量和普通static变量一样，都在内存分区中的全局数据区分配内存，到程序结束时才释放。这就意味着static成员变量不占用对象的内存，不随对象的创建而分配内存，也不随对象的销毁而释放内存，即使不创建对象也可以访问。而普通成员变量在对象创建时分配内存，在对象销毁时释放内存。

静态成员函数与普通成员函数的区别在于：普通成员函数有this指针，可以访问类中的任意成员；静态成员函数没有this指针，只能访问静态成员（包括静态成员变量和静态成员函数）。

静态成员函数的主要目的是访问静态成员。和静态成员变量类似，静态成员函数在声明时要加static在定义时不能加static。
### const成员变量和成员函数

初始化```const```成员变量只有一种方法，就是通过构造函数的初始化列表。常成员函数需要在声明和定义的时候在函数头部的结尾加上const关键字。

const成员函数(常成员函数)可以使用类中的所有成员变量，但是不能修改它们的值。

```c++
class Student{
public:
    Student(char *name, int age, float score);
    void show();
    //声明常成员函数
    char *getname() const;
    int getage() const;
    float getscore() const;
private:
    char *m_name;
    int m_age;
    float m_score;
};
Student::Student(char *name, int age, float score): m_name(name), m_age(age), m_score(score){ }
void Student::show(){
    cout<<m_name<<"的年龄是"<<m_age<<"，成绩是"<<m_score<<endl;
}
//定义常成员函数
char * Student::getname() const{
    return m_name;
}
int Student::getage() const{
    return m_age;
}
float Student::getscore() const{
    return m_score;
}
```
函数开头的const用来修饰函数的返回值，表示返回值是 const 类型，也就是不能被修改，例如const char * getname()。

函数头部的结尾加上const表示常成员函数，这种函数只能读取成员变量的值，而不能修改成员变量的值，例如char * getname() const。

### const对象
const也可以用来修饰对象，称为常对象。只能调用类的const成员（包括const成员变量和const成员函数）了。
```c++
const  class  object(params);
class const object(params);

const class *p = new class(params);
class const *p = new class(params);
```
### friend友元函数与友元类
1. 友元的关系是单向的而不是双向的。
2. 友元的关系不能传递。
一般不建议把整个类声明为友元类，而只将某些成员函数声明为友元函数。
#### 友元函数
当前类以外定义的、不属于当前类的函数也可以在类中声明，但要在前面加friend关键字，这样就构成了友元函数。友元函数可以是不属于任何类的非成员函数，也可以是其他类的成员函数。友元函数可以访问当前类中的所有成员，包括 public、protected、private 属性的。

友元函数不同于类的成员函数，成员函数在调用时会隐式地增加this指针，指向调用它的对象，在友元函数中不能直接访问类的成员，必须要借助对象。

友元函数：有时候类需要提前声明，类的提前声明的使用范围是有限的，只有在正式声明一个类以后才能用它去创建对象。
#### 友元类
友元类中的所有成员函数都是另外一个类的友元函数。
```c++
#include <iostream>
using namespace std;
class Address;  //提前声明Address类
//声明Student类
class Student{
public:
    Student(char *name, int age, float score);
public:
    void show(Address *addr);
private:
    char *m_name;
    int m_age;
    float m_score;
};
//声明Address类
class Address{
public:
    Address(char *province, char *city, char *district);
public:
    //将Student类声明为Address类的友元类
    friend class Student;
private:
    char *m_province;  //省份
    char *m_city;  //城市
    char *m_district;  //区（市区）
};
//实现Student类
Student::Student(char *name, int age, float score): m_name(name), m_age(age), m_score(score){ }
void Student::show(Address *addr){
    cout<<m_name<<"的年龄是 "<<m_age<<"，成绩是 "<<m_score<<endl;
    cout<<"家庭住址："<<addr->m_province<<"省"<<addr->m_city<<"市"<<addr->m_district<<"区"<<endl;
}
//实现Address类
Address::Address(char *province, char *city, char *district){
    m_province = province;
    m_city = city;
    m_district = district;
}
int main(){
    Student stu("小明", 16, 95.5f);
    Address addr("陕西", "西安", "雁塔");
    stu.show(&addr);
   
    Student *pstu = new Student("李磊", 16, 80.5);
    Address *paddr = new Address("河北", "衡水", "桃城");
    pstu -> show(paddr);
    return 0;
}
```
### string类
string类为我们提供了一个转换函数c_str()，该函数能够将 string字符串转换为C风格的字符串。
```c++
string path = "D:\\demo.txt";
FILE *fp = fopen(path.c_str(), "rt");
```