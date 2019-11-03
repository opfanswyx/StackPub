# C++
## C++基础
### 编译
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
C++ 中的常量(const)更类似于#define命令，是一个值替换的过程，只不过#define是在预处理阶段替换，而常量是在编译阶段替换。

C和C++中全局 const 变量的作用域相同，都是当前文件，不同的是它们的可见范围：C语言中 const 全局变量的可见范围是整个程序，在其他文件中使用 extern 声明后就可以使用；而C++中 const 全局变量的可见范围仅限于当前文件，在其他文件中不可见，所以它可以定义在头文件中，多次引入后也不会出错。

### inline内联函数
在函数定义处添加 inline 关键字，在函数声明处添加 inline 关键字虽然没有错，但这种做法是无效的，编译器会忽略函数声明处的 inline 关键字。

在多文件编程时，建议将内联函数的定义直接放在头文件中，并且禁用内联函数的声明。

### 函数默认参数
C++规定，默认参数只能放在形参列表的最后，而且一旦为某个形参指定了默认值，那么它后面的所有形参都必须有默认值。

这是因为C++ 规定，在给定的作用域中只能指定一次默认参数。（同一源文件内定义+声明带默认参数会报错）

### 重载
函数重载：函数名字相同，数列表不同（参数列表又叫参数签名，包括参数的类型、参数的个数和参数的顺序，只要有一个不同就叫做参数列表不同）。
## 类和对象
类是一个模板（Template），编译后不占用内存空间，在定义类时不能对成员变量进行初始化。只有在创建对象后才给成员变量分配内存，这个时候赋值了。

使用new在堆上创建出来的对象是匿名的，不能直接使用，必须要用一个指针指向它，再借助指针来访问它的成员变量或成员函数。

::被称为域解析符（也称作用域运算符或作用域限定符），用来连接类名和函数名，指明当前函数属于哪个类

在类体中和类体外定义成员函数是有区别的：在类体中定义的成员函数会自动成为内联函数，在类体外定义的不会

成员变量大都以m_开头，这是约定成俗的写法，不是语法规定的内容。以m_开头既可以一眼看出这是成员变量，又可以和成员函数中的形参名字区分开。

编译器会将成员变量和成员函数分开存储：分别为每个对象的成员变量分配内存，但是所有对象都共享同一段函数代码
### 构造函数
构造函数必须是public属性的，构造函数没有返回值，不管是声明还是定义，函数名前面都不能出现返回值类型，即使是 void 也不允许；
函数体中不能有 return 语句。
#### 构造函数初始化列表
初始化const成员变量的唯一方法就是使用初始化列表。
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
构造函数的名字和类名相同，而析构函数的名字是在类名前面加一个~符号。析构函数没有参数，不能被重载，一个类只能有一个析构函数。

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
this 实际上是成员函数的一个形参，在调用成员函数时将对象的地址作为实参传递给 this。不过 this 这个形参是隐式的，它并不出现在代码中，而是在编译阶段由编译器默默地将它添加到参数列表中。

成员函数最终被编译成与对象无关的普通函数，除了成员变量，会丢失所有信息，所以编译时要在成员函数中添加一个额外的参数，把当前对象的首地址传入，以此来关联成员函数和成员变量。这个额外的参数，实际上就是 this，它是成员函数和成员变量关联的桥梁。

1. this 是 const 指针，它的值是不能被修改的，一切企图修改该指针的操作，如赋值、递增、递减等都是不允许的。
2. this 只能在成员函数内部使用，用在其他地方没有意义，也是非法的。
3. 只有当对象被创建后 this 才有意义，因此不能在 static 成员函数中使用（后续会讲到 static 成员）。
### static静态成员变量和静态成员函数
static成员变量必须在类声明的外部初始化：
```c++
type class::name = value;
int Student::m_total = 0; //静态成员变量在初始化时不能再加 static
```
static 成员变量的内存既不是在声明类时分配，也不是在创建对象时分配，而是在（类外）初始化时分配。反过来说，没有在类外初始化的 static 成员变量不能使用。

static成员变量和普通static变量一样，都在内存分区中的全局数据区分配内存，到程序结束时才释放。这就意味着，static 成员变量不占用对象的内存，不随对象的创建而分配内存，也不随对象的销毁而释放内存，即使不创建对象也可以访问。而普通成员变量在对象创建时分配内存，在对象销毁时释放内存。

静态成员函数与普通成员函数的根本区别在于：普通成员函数有 this 指针，可以访问类中的任意成员；而静态成员函数没有 this 指针，只能访问静态成员（包括静态成员变量和静态成员函数）。

静态成员函数的主要目的是访问静态成员。和静态成员变量类似，静态成员函数在声明时要加 static，在定义时不能加 static。
### const成员变量和成员函数

初始化 const 成员变量只有一种方法，就是通过构造函数的初始化列表。

const 成员函数可以使用类中的所有成员变量，但是不能修改它们的值，这种措施主要还是为了保护数据而设置的。const 成员函数也称为常成员函数。

常成员函数需要在声明和定义的时候在函数头部的结尾加上 const 关键字。

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
函数开头的 const 用来修饰函数的返回值，表示返回值是 const 类型，也就是不能被修改，例如const char * getname()。

函数头部的结尾加上 const 表示常成员函数，这种函数只能读取成员变量的值，而不能修改成员变量的值，例如char * getname() const。
### const对象
const也可以用来修饰对象，称为常对象。只能调用类的 const成员（包括const成员变量和const成员函数）了。
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

友元函数不同于类的成员函数，成员函数在调用时会隐式地增加 this指针，指向调用它的对象，在友元函数中不能直接访问类的成员，必须要借助对象。

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
## C++引用
引用在定义时需要添加&，在使用时不能添加&，使用时添加&表示取地址。引用必须在定义的同时初始化，并且以后也要从一而终，不能再引用其它数据，这有点类似于常量（const 变量）。

引用只是对指针进行了简单的封装，它的底层依然是通过指针实现的，引用占用的内存和指针占用的内存长度一样，在 32 位环境下是 4 个字节，在 64 位环境下是 8 个字节，之所以不能获取引用的地址，是因为编译器进行了内部转换。
### 指针和引用的区别
1. 引用必须在定义时初始化，不能再指向其他数据；指针没有这个限制，指针在定义时不必赋值，也能指向任意数据。
2. 有 const 指针，但是没有 const 引用。
3. 指针可以有多级，但是引用只能有一级。
4. 。对指针使用++表示指向下一份数据，对引用使用 ++ 表示它所指代的数据本身加1，自减（--）也是。

### const和引用的奇妙反应
#### 引用不能绑定到临时数据
指针就是数据或代码在内存中的地址，指针变量指向的就是内存中的数据或代码。指针只能指向内存，不能指向寄存器或者硬盘，因为寄存器和硬盘没法寻址。

int、double、bool、char 等基本类型的数据往往不超过 8 个字节，用一两个寄存器就能存储，所以这些类型的临时数据通常会放到寄存器中；而对象、结构体变量是自定义类型的数据，大小不可预测，所以这些类型的临时数据通常会放到内存中。

常量表达式的值虽然在内存中，但是没有办法寻址，所以也不能使用&来获取它的地址，更不能用指针指向它。

引用不能指代临时数据如函数参数等。

临时数据，例如表达式的结果、函数的返回值等，它们可能会放在内存中，也可能会放在寄存器中。一旦它们被放到了寄存器中，就没法用&获取它们的地址了，也就没法用指针指向它们。

编译器会为临时数据创建一个新的、无名的临时变量，并将临时数据放入该临时变量中，然后再将引用绑定到该临时变量。

给引用添加 const 限定后，不但可以将引用绑定到临时数据，还可以将引用绑定到类型相近的数据(const引用与转换类型)，它们背后的机制都是临时变量。

引用类型的函数形参请尽可能的使用const。
## 继承与派生
```c++
class 派生类名:［继承方式］ 基类名{
    派生类新增加的成员
};
```
1) public继承方式
    1. 基类中所有 public 成员在派生类中为 public 属性；
    2. 基类中所有 protected 成员在派生类中为 protected 属性；
    3. 基类中所有 private 成员在派生类中不能使用。

2) protected继承方式
    1. 基类中的所有 public 成员在派生类中为 protected 属性；
    2. 基类中的所有 protected 成员在派生类中为 protected 属性；
    3. 基类中的所有 private 成员在派生类中不能使用。

3) private继承方式
    1. 基类中的所有 public 成员在派生类中均为 private 属性；
    2. 基类中的所有 protected 成员在派生类中均为 private 属性；
    3. 基类中的所有 private 成员在派生类中不能使用。

不管继承方式如何，基类中的 private 成员在派生类中始终不能使用。基类的 private 成员是能够被继承的，并且（成员变量）会占用派生类对象的内存，只是在派生类中不可见，导致无法使用。

在派生类中访问基类 private 成员的唯一方法就是借助基类的非 private 成员函数，如果基类没有非 private 成员函数，那么该成员在派生类中将无法访问。

using 只能改变基类中 public 和 protected 成员的访问权限，不能改变 private 成员的访问权限，因为基类中 private 成员在派生类中是不可见的，根本不能使用，所以基类中的 private 成员在派生类中无论如何都不能访问。

如果派生类中的成员（包括成员变量和成员函数）和基类中的成员重名，那么就会遮蔽从基类继承过来的成员。

基类成员函数和派生类成员函数不会构成重载，如果派生类有同名函数，那么就会遮蔽基类中的所有同名函数，不管它们的参数是否一样。

只有一个作用域内的同名函数才具有重载关系，不同作用域内的同名函数是会造成遮蔽，使得外层函数无效。派生类和基类拥有不同的作用域，所以它们的同名函数不具有重载关系。
### 继承的作用域嵌套
派生类的作用域位于基类作用域之内
### 继承下的内存模型
有继承关系时，派生类的内存模型可以看成是基类成员变量和新增成员变量的总和，而所有成员函数仍然存储在另外一个区域——代码区，由所有对象共享。

在派生类的对象模型中，会包含所有基类的成员变量。这种设计方案的优点是访问效率高，能够在派生类对象中直接访问基类变量，无需经过好几层间接计算。
#### 基类和派生类的析构函数
类的构造函数不能被继承。

在派生类的构造函数中调用基类的构造函数。派生类构造函数总是先调用基类构造函数再执行其他代码（包括参数初始化表以及函数体中的代码）

派生类构造函数中只能调用直接基类的构造函数，不能调用间接基类的。

创建派生类对象时，构造函数的执行顺序和继承顺序相同，即先执行基类构造函数，再执行派生类构造函数。
而销毁派生类对象时，析构函数的执行顺序和继承顺序相反，即先执行派生类析构函数，再执行基类析构函数。

```c++
#include <iostream>
using namespace std;
class A{
public:
    A(){cout<<"A constructor"<<endl;}
    ~A(){cout<<"A destructor"<<endl;}
};
class B: public A{
public:
    B(){cout<<"B constructor"<<endl;}
    ~B(){cout<<"B destructor"<<endl;}
};
class C: public B{
public:
    C(){cout<<"C constructor"<<endl;}
    ~C(){cout<<"C destructor"<<endl;}
};
int main(){
    C test;
    return 0;
}
```
#### 多继承
```c++
class D: public A, private B, protected C{
    //类D新增加的成员
}

D(形参列表): A(实参列表), B(实参列表), C(实参列表){
    //其他操作
}

#include <iostream>
using namespace std;
//基类
class BaseA{
public:
    BaseA(int a, int b);
    ~BaseA();
public:
    void show();
protected:
    int m_a;
    int m_b;
};
BaseA::BaseA(int a, int b): m_a(a), m_b(b){
    cout<<"BaseA constructor"<<endl;
}
BaseA::~BaseA(){
    cout<<"BaseA destructor"<<endl;
}
void BaseA::show(){
    cout<<"m_a = "<<m_a<<endl;
    cout<<"m_b = "<<m_b<<endl;
}
//基类
class BaseB{
public:
    BaseB(int c, int d);
    ~BaseB();
    void show();
protected:
    int m_c;
    int m_d;
};
BaseB::BaseB(int c, int d): m_c(c), m_d(d){
    cout<<"BaseB constructor"<<endl;
}
BaseB::~BaseB(){
    cout<<"BaseB destructor"<<endl;
}
void BaseB::show(){
    cout<<"m_c = "<<m_c<<endl;
    cout<<"m_d = "<<m_d<<endl;
}
//派生类
class Derived: public BaseA, public BaseB{
public:
    Derived(int a, int b, int c, int d, int e);
    ~Derived();
public:
    void display();
private:
    int m_e;
};
Derived::Derived(int a, int b, int c, int d, int e): BaseA(a, b), BaseB(c, d), m_e(e){
    cout<<"Derived constructor"<<endl;
}
Derived::~Derived(){
    cout<<"Derived destructor"<<endl;
}
void Derived::display(){
    BaseA::show();  //调用BaseA类的show()函数
    BaseB::show();  //调用BaseB类的show()函数
    cout<<"m_e = "<<m_e<<endl;
}
int main(){
    Derived obj(1, 2, 3, 4, 5);
    obj.display();
    return 0;
}
```
命名冲突时使用域解析符。
#### 虚继承和虚基类详解
菱形继承

为了解决多继承时的命名冲突和冗余数据问题，C++ 提出了虚继承，使得在派生类中只保留一份间接基类的成员。

虚继承的目的是让某个类做出声明，承诺愿意共享它的基类。其中，这个被共享的基类就称为虚基类（Virtual Base Class），本例中的 A 就是一个虚基类。在这种机制下，不论虚基类在继承体系中出现了多少次，在派生类中都只包含一份虚基类的成员。

对最终的派生类来说，虚基类是间接基类，而不是直接基类。这跟普通继承不同，在普通继承中，派生类构造函数中只能调用直接基类的构造函数，不能调用间接基类的。

类其实也是一种数据类型，也可以发生数据类型转换，不过这种转换只有在基类和派生类之间才有意义，并且只能将派生类赋值给基类，包括将派生类对象赋值给基类对象、将派生类指针赋值给基类指针、将派生类引用赋值给基类引用，这在 C++ 中称为向上转型（Upcasting）。相应地，将基类赋值给派生类称为向下转型（Downcasting）。

赋值的本质是将现有的数据写入已分配好的内存中，对象的内存只包含了成员变量，所以对象之间的赋值是成员变量的赋值，成员函数不存在赋值问题。

## 多态与虚函数

通过基类指针只能访问派生类的成员变量，但是不能访问派生类的成员函数。

让基类指针能够访问派生类的成员函数，C++ 增加了虚函数（Virtual Function）。使用虚函数非常简单，只需要在函数声明前面增加 virtual 关键字。

有了虚函数，基类指针指向基类对象时就使用基类的成员（包括成员函数和成员变量），指向派生类对象时就使用派生类的成员。换句话说，基类指针可以按照基类的方式来做事，也可以按照派生类的方式来做事，它有多种形态，或者说有多种表现方式，我们将这种现象称为多态（Polymorphism）。

虚函数的注意事项
1. 只需要在虚函数的声明处加上 virtual 关键字，函数定义处可以加也可以不加。

2. 可以只将基类中的函数声明为虚函数，这样所有派生类中具有遮蔽关系的同名函数都将自动成为虚函数。

3. 当在基类中定义了虚函数时，如果派生类没有定义新的函数来遮蔽此函数，那么将使用基类的虚函数。

4. 只有派生类的虚函数覆盖基类的虚函数（函数原型相同）才能构成多态（通过基类指针访问派生类函数）。

5. 构造函数不能是虚函数。

6. 析构函数可以声明为虚函数，而且有时候必须要声明为虚函数。

构成多态的条件
1. 必须存在继承关系；
2. 继承关系中必须有同名的虚函数，并且它们是覆盖关系（函数原型相同）。
3. 存在基类的指针，通过该指针调用虚函数。

### 虚析构函数的必要性
大部分情况下都应该将基类的析构函数声明为虚函数。
```c++
class Base{
public:
    Base();
    virtual ~Base();
protected:
    char *str;
};
```
### 纯虚函数和抽象类详解
```c++
virtual 返回值类型 函数名 (函数参数) = 0;
```
纯虚函数没有函数体，只有函数声明，在虚函数声明的结尾加上=0，表明此函数为纯虚函数。

包含纯虚函数的类称为抽象类（Abstract Class）。纯虚函数没有函数体，无法实例化。派生类必须实现纯虚函数才能被实例化。

抽象基类除了约束派生类的功能，还可以实现多态。

一个纯虚函数就可以使类成为抽象基类，但是抽象基类中除了包含纯虚函数外，还可以包含其它的成员函数（虚函数或普通函数）和成员变量。

只有类中的虚函数才能被声明为纯虚函数，普通成员函数和顶层函数均不能声明为纯虚函数。

### 虚函数表
编译器之所以能通过指针指向的对象找到虚函数，是因为在创建对象时额外地增加了虚函数表。

如果一个类包含了虚函数，那么在创建该类的对象时就会额外地增加一个数组，数组中的每一个元素都是虚函数的入口地址。不过数组和对象是分开存储的，为了将对象和数组关联起来，编译器还要在对象中安插一个指针，指向数组的起始位置。数组就是虚函数表（Virtual function table），简写为vtable。

## typeid运算符与RTTI机制
typeid 运算符用来获取一个表达式的类型信息。类型信息是创建数据的模板，数据占用多大内存、能进行什么样的操作、该如何操作等，这些都由它的类型信息决定。

这种在程序运行后确定对象的类型信息的机制称为运行时类型识别（Run-Time Type Identification，RTTI）。在 C++ 中，只有类中包含了虚函数时才会启用 RTTI 机制，其他所有情况都可以在编译阶段确定类型信息。
```c++
#include <iostream>
using namespace std;
//基类
class People{
public:
    virtual void func(){ }
};
//派生类
class Student: public People{ };
int main(){
    People *p;
    int n;
  
    cin>>n;
    if(n <= 100){
        p = new People();
    }else{
        p = new Student();
    }
    //根据不同的类型进行不同的操作
    if(typeid(*p) == typeid(People)){
        cout<<"I am human."<<endl;
    }else{
        cout<<"I am a student."<<endl;
    }
    return 0;
}
```
除了 typeid 运算符，dynamic_cast 运算符和异常处理也依赖于 RTTI 机制，并且要能够通过派生类获取基类的信息，或者说要能够判断一个类是否是另一个类的基类，要在基类和派生类之间再增加一条绳索。称此为继承链（Inheritance Chain）。

### 运算符重载
```c++
返回值类型 operator 运算符名称 (形参表列){
    //TODO:
}
```
```c++
#include <iostream>
using namespace std;
class complex{
public:
    complex();
    complex(double real, double imag);
public:
    //声明运算符重载
    complex operator+(const complex &A) const;
    void display() const;
private:
    double m_real;  //实部
    double m_imag;  //虚部
};
complex::complex(): m_real(0.0), m_imag(0.0){ }
complex::complex(double real, double imag): m_real(real), m_imag(imag){ }
//实现运算符重载
complex complex::operator+(const complex &A) const{
    complex B;
    B.m_real = this->m_real + A.m_real;
    B.m_imag = this->m_imag + A.m_imag;
    return B;
}
void complex::display() const{
    cout<<m_real<<" + "<<m_imag<<"i"<<endl;
}
int main(){
    complex c1(4.3, 5.8);
    complex c2(2.4, 3.7);
    complex c3;
    c3 = c1 + c2;
    c3.display();
    return 0;
}
```
```c++
c3 = c1 + c2;
c3 = c1.operator+(c2);
```
运算符重载函数不仅可以作为类的成员函数，还可以作为全局函数--->友元函数。

重载不能改变运算符的优先级和结合性。

重载不会改变运算符的用法。

运算符重载函数不能有默认的参数。

运算符重载函数既可以作为类的成员函数，也可以作为全局函数。

箭头运算符->、下标运算符[ ]、函数调用运算符( )、赋值运算符=只能以成员函数的形式重载。

## 模板和泛型
模板函数
```c++
template <typename 类型参数1 , typename 类型参数2 , ...> 返回值类型  函数名(形参列表){
    //在函数体中可以使用类型参数
}
```
类模板
```c++
template<typename 类型参数1 , typename 类型参数2 , …> class 类名{
    //TODO:
};

template<typename 类型参数1 , typename 类型参数2 , …>
返回值类型 类名<类型参数1 , 类型参数2, ...>::函数名(形参列表){
    //TODO:
}
```
```c++
#include <iostream>
using namespace std;
template<class T1, class T2>  //这里不能有分号
class Point{
public:
    Point(T1 x, T2 y): m_x(x), m_y(y){ }
public:
    T1 getX() const;  //获取x坐标
    void setX(T1 x);  //设置x坐标
    T2 getY() const;  //获取y坐标
    void setY(T2 y);  //设置y坐标
private:
    T1 m_x;  //x坐标
    T2 m_y;  //y坐标
};
template<class T1, class T2>  //模板头
T1 Point<T1, T2>::getX() const /*函数头*/ {
    return m_x;
}
template<class T1, class T2>
void Point<T1, T2>::setX(T1 x){
    m_x = x;
}
template<class T1, class T2>
T2 Point<T1, T2>::getY() const{
    return m_y;
}
template<class T1, class T2>
void Point<T1, T2>::setY(T2 y){
    m_y = y;
}
int main(){
    Point<int, int> p1(10, 20);
    cout<<"x="<<p1.getX()<<", y="<<p1.getY()<<endl;
    Point<int, char*> p2(10, "东经180度");
    cout<<"x="<<p2.getX()<<", y="<<p2.getY()<<endl;
    Point<char*, char*> *p3 = new Point<char*, char*>("东经180度", "北纬210度");
    cout<<"x="<<p3->getX()<<", y="<<p3->getY()<<endl;
    return 0;
}
```
可边长数组实现
```c++
#include <iostream>
#include <cstring>
using namespace std;
template <class T>
class CArray
{
    int size; //数组元素的个数
    T *ptr; //指向动态分配的数组
public:
    CArray(int s = 0);  //s代表数组元素的个数
    CArray(CArray & a);
    ~CArray();
    void push_back(const T & v); //用于在数组尾部添加一个元素v
    CArray & operator=(const CArray & a); //用于数组对象间的赋值
    T length() { return size; }
    T & operator[](int i)
    {//用以支持根据下标访问数组元素，如a[i] = 4;和n = a[i]这样的语句
        return ptr[i];
    }
};
template<class T>
CArray<T>::CArray(int s):size(s)
{
     if(s == 0)
         ptr = NULL;
    else
        ptr = new T[s];
}
template<class T>
CArray<T>::CArray(CArray & a)
{
    if(!a.ptr) {
        ptr = NULL;
        size = 0;
        return;
    }
    ptr = new T[a.size];
    memcpy(ptr, a.ptr, sizeof(T ) * a.size);
    size = a.size;
}
template <class T>
CArray<T>::~CArray()
{
     if(ptr) delete [] ptr;
}
template <class T>
CArray<T> & CArray<T>::operator=(const CArray & a)
{ //赋值号的作用是使"="左边对象里存放的数组，大小和内容都和右边的对象一样
    if(this == & a) //防止a=a这样的赋值导致出错
    return * this;
    if(a.ptr == NULL) {  //如果a里面的数组是空的
        if( ptr )
            delete [] ptr;
        ptr = NULL;
        size = 0;
        return * this;
    }
     if(size < a.size) { //如果原有空间够大，就不用分配新的空间
         if(ptr)
            delete [] ptr;
        ptr = new T[a.size];
    }
    memcpy(ptr,a.ptr,sizeof(T)*a.size);   
    size = a.size;
     return *this;
}
template <class T>
void CArray<T>::push_back(const T & v)
{  //在数组尾部添加一个元素
    if(ptr) {
        T *tmpPtr = new T[size+1]; //重新分配空间
    memcpy(tmpPtr,ptr,sizeof(T)*size); //拷贝原数组内容
    delete []ptr;
    ptr = tmpPtr;
}
    else  //数组本来是空的
        ptr = new T[1];
    ptr[size++] = v; //加入新的数组元素
}
int main()
{
    CArray<int> a;
    for(int i = 0;i < 5;++i)
        a.push_back(i);
    for(int i = 0; i < a.length(); ++i)
        cout << a[i] << " ";   
    return 0;
}
```
### 重载函数模板
```c++
#include <iostream>
using namespace std;
template<class T> void Swap(T &a, T &b);  //模板①：交换基本类型的值
template<typename T> void Swap(T a[], T b[], int len);  //模板②：交换两个数组
void printArray(int arr[], int len);  //打印数组元素
int main(){
    //交换基本类型的值
    int m = 10, n = 99;
    Swap(m, n);  //匹配模板①
    cout<<m<<", "<<n<<endl;
    //交换两个数组
    int a[5] = { 1, 2, 3, 4, 5 };
    int b[5] = { 10, 20, 30, 40, 50 };
    int len = sizeof(a) / sizeof(int);  //数组长度
    Swap(a, b, len);  //匹配模板②
    printArray(a, len);
    printArray(b, len);
    return 0;
}
template<class T> void Swap(T &a, T &b){
    T temp = a;
    a = b;
    b = temp;
}
template<typename T> void Swap(T a[], T b[], int len){
    T temp;
    for(int i=0; i<len; i++){
        temp = a[i];
        a[i] = b[i];
        b[i] = temp;
    }
}
void printArray(int arr[], int len){
    for(int i=0; i<len; i++){
        if(i == len-1){
            cout<<arr[i]<<endl;
        }else{
            cout<<arr[i]<<", ";
        }
    }
}
```

为函数模板显式地指明实参

### 模板的显示具体化（Explicit Specialization）
函数模板的显示具体化
```c++
#include <iostream>
#include <string>
using namespace std;
typedef struct{
    string name;
    int age;
    float score;
} STU;
//函数模板
template<class T> const T& Max(const T& a, const T& b);
//函数模板的显示具体化（针对STU类型的显示具体化）
template<> const STU& Max<STU>(const STU& a, const STU& b);
//重载<<
ostream & operator<<(ostream &out, const STU &stu);
int main(){
    int a = 10;
    int b = 20;
    cout<<Max(a, b)<<endl;
   
    STU stu1 = { "王明", 16, 95.5};
    STU stu2 = { "徐亮", 17, 90.0};
    cout<<Max(stu1, stu2)<<endl;
    return 0;
}
template<class T> const T& Max(const T& a, const T& b){
    return a > b ? a : b;
}
template<> const STU& Max<STU>(const STU& a, const STU& b){
    return a.score > b.score ? a : b;
}
ostream & operator<<(ostream &out, const STU &stu){
    out<<stu.name<<" , "<<stu.age <<" , "<<stu.score;
    return out;
}
```
类模板的显示具体化
```c++
#include <iostream>
using namespace std;
//类模板
template<class T1, class T2> class Point{
public:
    Point(T1 x, T2 y): m_x(x), m_y(y){ }
public:
    T1 getX() const{ return m_x; }
    void setX(T1 x){ m_x = x; }
    T2 getY() const{ return m_y; }
    void setY(T2 y){ m_y = y; }
    void display() const;
private:
    T1 m_x;
    T2 m_y;
};
template<class T1, class T2>  //这里要带上模板头
void Point<T1, T2>::display() const{
    cout<<"x="<<m_x<<", y="<<m_y<<endl;
}
//类模板的显示具体化（针对字符串类型的显示具体化）
template<> class Point<char*, char*>{
public:
    Point(char *x, char *y): m_x(x), m_y(y){ }
public:
    char *getX() const{ return m_x; }
    void setX(char *x){ m_x = x; }
    char *getY() const{ return m_y; }
    void setY(char *y){ m_y = y; }
    void display() const;
private:
    char *m_x;  //x坐标
    char *m_y;  //y坐标
};
//这里不能带模板头template<>
void Point<char*, char*>::display() const{
    cout<<"x="<<m_x<<" | y="<<m_y<<endl;
}
int main(){
    ( new Point<int, int>(10, 20) ) -> display();
    ( new Point<int, char*>(10, "东京180度") ) -> display();
    ( new Point<char*, char*>("东京180度", "北纬210度") ) -> display();
    return 0;
}
```
部分显示具体化
```c++
#include <iostream>
using namespace std;
//类模板
template<class T1, class T2> class Point{
public:
    Point(T1 x, T2 y): m_x(x), m_y(y){ }
public:
    T1 getX() const{ return m_x; }
    void setX(T1 x){ m_x = x; }
    T2 getY() const{ return m_y; }
    void setY(T2 y){ m_y = y; }
    void display() const;
private:
    T1 m_x;
    T2 m_y;
};
template<class T1, class T2>  //这里需要带上模板头
void Point<T1, T2>::display() const{
    cout<<"x="<<m_x<<", y="<<m_y<<endl;
}
//类模板的部分显示具体化
template<typename T2> class Point<char*, T2>{
public:
    Point(char *x, T2 y): m_x(x), m_y(y){ }
public:
    char *getX() const{ return m_x; }
    void setX(char *x){ m_x = x; }
    T2 getY() const{ return m_y; }
    void setY(T2 y){ m_y = y; }
    void display() const;
private:
    char *m_x;  //x坐标
    T2 m_y;  //y坐标
};
template<typename T2>  //这里需要带上模板头
void Point<char*, T2>::display() const{
    cout<<"x="<<m_x<<" | y="<<m_y<<endl;
}
int main(){
    ( new Point<int, int>(10, 20) ) -> display();
    ( new Point<char*, int>("东京180度", 10) ) -> display();
    ( new Point<char*, char*>("东京180度", "北纬210度") ) -> display();
    return 0;
}
```
## 非类型参数
```c++
template<typename T, int N> class Demo{ };
template<class T, int N> void func(T (&arr)[N]);
```
### 类模板中使用非类型参数
动态数组
```c++
#include <iostream>
#include <cstring>
#include <cstdlib>
using namespace std;
template<typename T, int N>
class Array{
public:
    Array();
    ~Array();
public:
    T & operator[](int i);  //重载下标运算符[]
    int length() const { return m_length; }  //获取数组长度
    bool capacity(int n);  //改变数组容量
private:
    int m_length;  //数组的当前长度
    int m_capacity;  //当前内存的容量（能容乃的元素的个数）
    T *m_p;  //指向数组内存的指针
};
template<typename T, int N>
Array<T, N>::Array(){
    m_p = new T[N];
    m_capacity = m_length = N;
}
template<typename T, int N>
Array<T, N>::~Array(){
    delete[] m_p;
}
template<typename T, int N>
T & Array<T, N>::operator[](int i){
    if(i<0 || i>=m_length){
        cout<<"Exception: Array index out of bounds!"<<endl;
    }
    return m_p[i];
}
template<typename T, int N>
bool Array<T, N>::capacity(int n){
    if(n > 0){  //增大数组
        int len = m_length + n;  //增大后的数组长度
        if(len <= m_capacity){  //现有内存足以容纳增大后的数组
            m_length = len;
            return true;
        }else{  //现有内存不能容纳增大后的数组
            T *pTemp = new T[m_length + 2 * n * sizeof(T)];  //增加的内存足以容纳 2*n 个元素
            if(pTemp == NULL){  //内存分配失败
                cout<<"Exception: Failed to allocate memory!"<<endl;
                return false;
            }else{  //内存分配成功
                memcpy( pTemp, m_p, m_length*sizeof(T) );
                delete[] m_p;
                m_p = pTemp;
                m_capacity = m_length = len;
            }
        }
    }else{  //收缩数组
        int len = m_length - abs(n);  //收缩后的数组长度
        if(len < 0){
            cout<<"Exception: Array length is too small!"<<endl;
            return false;
        }else{
            m_length = len;
            return true;
        }
    }
}
int main(){
    Array<int, 5> arr;
    //为数组元素赋值
    for(int i=0, len=arr.length(); i<len; i++){
        arr[i] = 2*i;
    }
   
    //第一次打印数组
    for(int i=0, len=arr.length(); i<len; i++){
        cout<<arr[i]<<" ";
    }
    cout<<endl;
   
    //扩大容量并为增加的元素赋值
    arr.capacity(8);
    for(int i=5, len=arr.length(); i<len; i++){
        arr[i] = 2*i;
    }
    //第二次打印数组
    for(int i=0, len=arr.length(); i<len; i++){
        cout<<arr[i]<<" ";
    }
    cout<<endl;
    //收缩容量
    arr.capacity(-4);
    //第三次打印数组
    for(int i=0, len=arr.length(); i<len; i++){
        cout<<arr[i]<<" ";
    }
    cout<<endl;
    return 0;
}
```

模板的实例化是由编译器完成的，而不是由链接器完成的，这可能会导致在链接期间找不到对应的实例。所以不能将模板的声明和定义分散到多个文件中

### Note
#### 模板的显式实例化
#### 类模板与继承
#### 类模板与友元
#### 类模板中的静态成员

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

## 进阶

### 拷贝构造函数
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