## 关联容器
关联容器内部的元素都是排好序的，有以下四种。

1. set：排好序的集合，不允许有相同元素。
2. multiset：排好序的集合，允许有相同元素。
3. map：每个元素都分为关键字和值两部分，容器中的元素是按关键字排序的。不允许有多个元素的关键字相同。
4. multimap：和 map 类似，差别在于元素的关键字可以相同。

不能修改 set 或 multiset 容器中元素的值。如果要修改 set 或 multiset 容器中某个元素的值，正确的做法是先删除该元素，再插入新元素。

## pair类模板
关联容器的一些成员函数的返回值是 pair 对象，而且 map 和 multimap 容器中的元素都是 pair 对象。

pair 的定义如下：

```c++
template <class_Tl, class_T2>
struct pair
{
    _T1 first;
    _T2 second;
    pair(): first(), second() {}  //用无参构造函数初始化 first 和 second
    pair(const _T1 &__a, const _T2 &__b): first(__a), second(__b) {}
    template <class_U1, class_U2>
    pair(const pair <_U1, _U2> &__p): first(__p.first), second(__p.second) {}
};
```

STL 中还有一个函数模板 make_pair，其功能是生成一个 pair 模板类对象。make_pair 的源代码如下：
```c++
template <class T1, class T2>
pair<T1, T2 > make_pair(T1 x, T2 y)
{
    return ( pair<T1, T2> (x, y) );
}
```

```c++
#include <iostream>
using namespace std;
int main()
{
    pair<int,double> p1;
    cout << p1.first << "," << p1.second << endl; //输出  0,0   
    pair<string,int> p2("this",20);
    cout << p2.first << "," << p2.second << endl; //输出  this,20
    pair<int,int> p3(pair<char,char>('a','b'));
    cout << p3.first << "," << p3.second << endl; //输出  97,98
    pair<int,string> p4 = make_pair(200,"hello");
    cout << p4.first << "," << p4.second << endl; //输出  200,hello
    return 0;
}
```