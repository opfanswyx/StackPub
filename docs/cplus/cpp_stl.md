## STL容器
顺序容器：元素在容器中的位置同元素的值无关，即不是排序。可变长数组vector，双端队列deque，双向链表list。顺序容器有以下常用成员函数：

1. front()：返回容器中第一个元素的引用。
2. back()：返回容器中最后一个元素的引用。
3. push_back()：在容器末尾增加新元素。
4. pop_back()：删除容器末尾的元素。
5. insert(...)：插入一个或多个元素。该函数参数较复杂，此处省略。

关联容器：元素在容器类是排序的。set，multiset，map，multimap。

容器适配器：栈stack，队列queue，优先级队列priority_queue。

所有容器都有以下两个成员函数：

1. int size()：返回容器对象中元素的个数。
2. bool empty()：判断容器对象是否为空。

顺序容器和关联容器还有以下成员函数：

1. begin()：返回指向容器中第一个元素的迭代器。
2. end()：返回指向容器中最后一个元素后面的位置的迭代器。
3. rbegin()：返回指向容器中最后一个元素的反向迭代器。
4. rend()：返回指向容器中第一个元素前面的位置的反向迭代器。
5. erase(...)：从容器中删除一个或几个元素。该函数参数较复杂，此处省略。
6. clear()：从容器中删除所有元素。

## STL迭代器iterator
要访问顺序容器和关联容器中的元素，需要通过“迭代器（iterator）”进行。迭代器是一个变量。迭代器可以指向容器中的某个元素，通过迭代器就可以读写它指向的元素，迭代器和指针类似。

迭代器按照定义方式分成以下四种:

正向迭代器
```c++
容器类名::iterator  迭代器名;
```
常量正向迭代器
```c++
容器类名::const_iterator  迭代器名;
```
反向迭代器
```c++
容器类名::reverse_iterator  迭代器名;
```
常量反向迭代器
```c++
容器类名::const_reverse_iterator  迭代器名;
```

通过迭代器可以读取它指向的元素，*迭代器名就表示迭代器指向的元素。通过非常量迭代器还能修改其指向的元素。

迭代器都可以进行++操作。反向迭代器和正向迭代器的区别在于：
1. 对正向迭代器进行++操作时，迭代器会指向容器中的后一个元素；

2. 而对反向迭代器进行++操作时，迭代器会指向容器中的前一个元素。

```c++
#include <iostream>
#include <vector>
using namespace std;
int main()
{
    vector<int> v;  //v是存放int类型变量的可变长数组，开始时没有元素
    for (int n = 0; n<5; ++n)
        v.push_back(n);  //push_back成员函数在vector容器尾部添加一个元素
    vector<int>::iterator i;  //定义正向迭代器
    for (i = v.begin(); i != v.end(); ++i) {  //用迭代器遍历容器
        cout << *i << " ";  //*i 就是迭代器i指向的元素
        *i *= 2;  //每个元素变为原来的2倍
    }
    cout << endl;
    //用反向迭代器遍历容器
    for (vector<int>::reverse_iterator j = v.rbegin(); j != v.rend(); ++j)
        cout << *j << " ";
    return 0;
}
```
### 迭代器功能分类

正向迭代器。假设 p 是一个正向迭代器，则 p 支持以下操作：++p，p++，*p。此外，两个正向迭代器可以互相赋值，还可以用==和!=运算符进行比较。

双向迭代器。双向迭代器具有正向迭代器的全部功能。除此之外，若 p 是一个双向迭代器，则--p和p--都是有定义的。--p使得 p 朝和++p相反的方向移动。

随机访问迭代器。随机访问迭代器具有双向迭代器的全部功能。若 p 是一个随机访问迭代器，i 是一个整型变量或常量，则 p 还支持以下操作：

1. p+=i：使得 p 往后移动 i 个元素。
2. p-=i：使得 p 往前移动 i 个元素。
3. p+i：返回 p 后面第 i 个元素的迭代器。
4. p-i：返回 p 前面第 i 个元素的迭代器。
5. p[i]：返回 p 后面第 i 个元素的引用。

此外，两个随机访问迭代器 p1、p2 还可以用 <、>、<=、>= 运算符进行比较。p1<p2的含义是：p1 经过若干次（至少一次）++操作后，就会等于 p2。其他比较方式的含义与此类似。

|容器|迭代器功能|
|:-:|:-:|
|vector|随机访问|
|deque|随机访问|
|list|双向|
|set/multiset|双向|
|map/multimap|双向|
|stack|不支持迭代器|
|queue|不支持迭代器|
|priority_queue|不支持迭代器|

### 迭代器的辅助函数
STL 中有用于操作迭代器的三个函数模板，它们是：

1. advance(p, n)：使迭代器 p 向前或向后移动 n 个元素。
2. distance(p, q)：计算两个迭代器之间的距离，即迭代器 p 经过多少次 + + 操作后和迭代器 q 相等。如果调用时 p 已经指向 q 的后面，则这个函数会陷入死循环。
3. iter_swap(p, q)：用于交换两个迭代器 p、q 指向的值。

```c++
#include <list>
#include <iostream>
#include <algorithm> //要使用操作迭代器的函数模板，需要包含此文件
using namespace std;
int main()
{
    int a[5] = { 1, 2, 3, 4, 5 };
    list <int> lst(a, a+5);
    list <int>::iterator p = lst.begin();
    advance(p, 2);  //p向后移动两个元素，指向3
    cout << "1)" << *p << endl;  //输出 1)3
    advance(p, -1);  //p向前移动一个元素，指向2
    cout << "2)" << *p << endl;  //输出 2)2
    list<int>::iterator q = lst.end();
    q--;  //q 指向 5
    cout << "3)" << distance(p, q) << endl;  //输出 3)3
    iter_swap(p, q); //交换 2 和 5
    cout << "4)";
    for (p = lst.begin(); p != lst.end(); ++p)
        cout << *p << " ";
    return 0;
}
```

## STL算法
算法可以处理容器，也可以处理普通的数组。

有的算法会改变其所作用的容器。例如：
1. copy：将一个容器的内容复制到另一个容器。
2. remove：在容器中删除一个元素。
3. random_shuffle：随机打乱容器中的元素。
4. fill：用某个值填充容器。

有的算法不会改变其所作用的容器。例如：
1. find：在容器中查找元素。
2. count_if：统计容器中符合某种条件的元素的个数。

find 模板的原型如下：
```c++
template <class InIt, class T>
InIt find(InIt first, InIt last, const T& val);
```

sort，用于对容器排序，其原型为：
```c++
template<class_RandIt>
void sort(_RandIt first, _RandIt last);
```

在 STL 中，默认情况下，比较大小是通过<运算符进行的，和>运算符无关。