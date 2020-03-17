## IO与文件操作
|头文件|类型|说明|
|:-:|:-|:-|
|iostream|istream,wistream|从流读取数据|
||ostream,wostream|从流写入数据|
||iostream,wiostream|读写流|
|fstream|ifstream,wifstream|从文件读取数据|
||ofstream,wofstream|向文件写入数据|
||fstream,wfstream|读写文件|
|sstream|istringstream,wistringstream|从string读取数据|
||ostringstream,wostringstream|向string写入数据|
||stringstream,wstringstream|读写string|

**IO对象不能拷贝和赋值**，所以不能将形参或返回类型设置为流类型。进行IO操作的函数通常以引用方式传递和返回流。读写IO对象会改变其状态，所以传递和返回引用不能是const的。

```cpp
ofstream out1, out2;
out1 = out2;              //错误：不能对流对象赋值
ofstream print(ofstream); //错误：不能初始化ofstream参数
out2 = print(out2);       //错误：不能拷贝流对象
```
### IO类
### 文件输入输出
### string流

## STL(标准模板库)
### 容器
### 顺序容器

|||
|:-|:-|
|vector|可变大小数组。支持快速随机访问。在尾部之外的位置插入或删除元素可能很慢。|
|deque|双端队列。支持快速随机访问。在头尾位置插入/删除速度很快。|
|list|双向链表。只支持双向顺序访问。在list中任何位置进行插入/删除操作速度都很快。|
|forward_list|单向链表。只支持单向顺序访问。在链表任何位置进行插入/删除操作速度很快。|
|array|固定大小数组，支持快速随机访问。不能添加或删除元素。|
|string|与vector相似的容器，但专门用于保存字符，随机访问快，在尾部插入/删除速度块。|

### 关联容器

|按关键字有序保存元素|说明|
|:-|:-|
|map|关联数组：保存关键字-值对|
|set|关键字即值，只保存关键字的容器|
|multimap|关键字可重复出现的map|
|multiset|关键字可重复出现的set|

|无序集合|说明|
|:-|:-|
|unordered_map|用哈希函数组织的map|
|unordered_set|用哈希函数组织的set|
|unordered_multimap|哈希组织的map，关键字可以重复出现|
|unordered_multiset|哈希组织的set，关键字可以重复出现|
#### pair类型

### 容器适配器
适配器(adaptor)接受一种已有的容器类型，使其行为看起来像一种不同的容器。

顺序容器的适配器：stack，queue和priority_queue。
### 迭代器

### 算法
**谓词**是一个可调用的表达式，其返回结果是一个能用作条件的值。标准库算法使用的谓词分为两类：**一元谓词**只接受单一参数，**二元谓词**有两个参数。

可调用对象：函数，函数指针，lambda表达式，重载了函数调用运算符的类。
#### lambda表达式
一个lambda表达式表示一个可调用的代码单元(一个未命名的内联函数)。lambda可能定义在函数内部。

```cpp
[capture list](parameter list) -> return type { function body }
```
capture list(捕获列表)是一个lambda所在函数中定义的局部变量的列表(通常为空)。

捕获列表只能用于局部非static变量，lambda可以直接使用局部static变量和在它所在函数之外声明的名字。

当以引用方式捕获一个变量时，必须保证在lambda执行时变量是存在的。

除了显示捕获所在函数的变量之外，还可以让编译器根据lambda中的代码推断要使用的变量。捕获列表中使用**&**或**=**。&告诉编译器采用捕获引用的方式，=则表示采用值捕获的方式。

一部分需要值捕获，一部分需要引用捕获，可以混合使用隐式捕获与显示捕获。混合使用隐式捕获和显示捕获时，捕获列表中的第一个元素必须是一个&或=，指定了默认捕获方式为引用或值。

```cpp
void biggies(vector<string> &words      
    vector<string>::size_type sz,
    ostream &os = cout, char c = '')
{
    for_each(words.begin(), words.end(),
        [&, c](const string &s) {os << s <<c;});

    for_each(words.begin(), words.end(),
        [=, &os](const string &s) {os << s << c;});
}
```
如果需要改变一个被捕获的变量的值，就必须在参数列表首加上关键字mutable。

可以忽略参数列表和返回类型，但必须包含捕获列表和函数体。

## 动态内存
### 智能指针
#### shared_ptr类
**make_shared**函数在动态内存中分配一个对象并初始化它，返回指向此对象的shared_ptr。
```cpp
shared_ptr<int> p3 = make_shared<int>();
auto p1 = make_shared<vecotr<string>>();  //指向一个动态分配的空vector<string>

shared_ptr<int> p(new int(1024));
```
当进行拷贝或赋值操作时，每个shared_ptr都会记录有多少个其他shared_ptr指向相同的对象。每个shared_ptr都有一个关联的计数器，称其为**引用计数**。当一个shared_ptr的计数器变为0，它就会释放自己所管理的对象。
#### unique_ptr
某个时刻只有一个unique_ptr指向一个给定的对象。不支持普通的拷贝或赋值操作。可以通过release或reset将指针的所有权从一个(非const)unique_ptr转移给另一个unique。
```cpp
unique_ptr<string> p2(p1.release()); 
p2.reset(p3.release());
```
release成员返回unique_ptr当前保存的指针并将其置为空。p2被初始化为p1原来保存的指针，而p1被置为空。

reset成员接受一个可选的指针参数，令unique_ptr重新指向给定的指针。

可以拷贝或赋值一个将要被销毁的unique_ptr。

#### weak_ptr
weak_ptr是一种不控制所指向对象生存期的智能指针，他指向由一个shared_ptr管理的对象。将一个weak_ptr绑定到一个shared_ptr不会改变shared_ptr的引用计数。
```cpp
auto p = make_shared<int>(42);
weak_ptr<int> wp(p);
```

|||
|:-|:-|
|w.reset()|将w置为空|
|w.use_count()|与w共享对象的shared_ptr的数量|
|w.expired()|当w.use_count()为0，返回true，否则返回false|
|w.lock()|当expired为true，返回一个空shared_ptr,否则返回一个指向w的对象的shared_ptr|

```cpp
if(shared_ptr<int> np = wp.lock()){
  //...
}
```
### 动态数组
#### new和数组
#### allocator类
new将内存分配和对象构造组合在一起，delete将对象析构和内存释放组合在一起。

allocator帮助我们将内存分配和对象构造分离开来。是一种类型感知的内存分配方法，它分配的内存是原始的，未构造的。

|||
|:-|:-|
|allocator<T> a|定义一个名为a的allocator对象，可以为类型为T的对象分配内存|
|a.allocate(n)|分配一段原始的，未构造的内存，保存n个类型为T的对象|
|a.deallocate(p,n)|释放从T*指针p中地址开始的内存，这块内存保存类n个类型为T的对象，p必须是一个先前由allocate返回的指针，且n必须是p创建时所要求的大小。在调用 deallocate之前，用户必须对每个在这块内存中创建的对象调用destroy|
|a.construct(p, args)|p必须是一个类型为T*的指针，指向一块原始内存；arg被传递给类型为T的构造函数，用来在p指向的内存中构造一个对象|
|a.destroy(p)|p为T*类型的指针，此算法对p指向的对象执行析构函数|



 

