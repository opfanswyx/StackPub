list 是顺序容器的一种。list 是一个双向链表。

list 容器不支持根据下标随机存取元素。

list 的构造函数和许多成员函数的用法都与 vector 类似，除了顺序容器都有的成员函数外，list 容器还独有如下所示的成员函数：

|成员函数|作用|
|:-:|:-:|
|void push_front(const T & val)|将 val 插入链表最前面|
|void pop_front()|删除链表最前面的元素|
|void sort()|将链表从小到大排序|
|void remove (const T & val)|删除和 val 相等的元素|
|remove_if|删除符合某种条件的元素|
|void unique()|删除所有和前一个元素相等的元素|
|void merge(list <T> & x)|将链表 x 合并进来并清空 x。要求链表自身和 x 都是有序的|
|void splice(iterator i, list <T> & x, iterator first, iterator last)|在位置 i 前面插入链表 x 中的区间 [first, last)，并在链表 x 中删除该区间。链表自身和链表 x 可以是同一个链表，只要 i 不在 [first, last) 中即可|

```c++
#include <list>  //使用 list 需要包含此头文件
#include <iostream>
#include <algorithm>  //使用STL中的算法需要包含此头文件
using namespace std;
class A {
private: int n;
public:
    A(int n_) { n = n_; }
    friend bool operator < (const A & a1, const A & a2);
    friend bool operator == (const A & a1, const A & a2);
    friend ostream & operator << (ostream & o, const A & a);
};
bool operator < (const A & a1, const A & a2) {
    return a1.n < a2.n;
}
bool operator == (const A & a1, const A & a2) {
    return a1.n == a2.n;
}
ostream & operator << (ostream & o, const A & a) {
    o << a.n;
    return o;
}
template <class T>
void Print(T first, T last)
{
    for (; first != last; ++first)
        cout << *first << " ";
    cout << endl;
}
int main()
{
    A a[5] = { 1, 3, 2, 4, 2 };
    A b[7] = { 10, 30, 20, 30, 30, 40, 40 };
    list<A> lst1(a, a + 5), lst2(b, b + 7);
    lst1.sort();
    cout << "1)"; Print(lst1.begin(), lst1.end());  //输出：1)1 2 2 3 4
    lst1.remove(2);  //删除所有和A(2)相等的元素
    cout << "2)"; Print(lst1.begin(), lst1.end());  //输出：2)1 3 4
    lst2.pop_front();  //删除第一个元素
    cout << "3)"; Print(lst2.begin(), lst2.end());  //输出：3)30 20 30 30 40 40
    lst2.unique();  //删除所有和前一个元素相等的元素
    cout << "4)"; Print(lst2.begin(), lst2.end());  //输出：4)30 20 30 40
    lst2.sort();
    lst1.merge(lst2);  //合并 lst2 到 lst1 并清空 lst2
    cout << "5)"; Print(lst1.begin(), lst1.end());  //输出：5)1 3 4 20 30 30 40
    cout << "6)"; Print(lst2.begin(), lst2.end());  //lst2是空的，输出：6)
    lst1.reverse();  //将 lst1 前后颠倒
    cout << "7)"; Print(lst1.begin(), lst1.end());  //输出 7)40 30 30 20 4 3 1
    lst2.insert(lst2.begin(), a + 1, a + 4);  //在 lst2 中插入 3,2,4 三个元素
    list <A>::iterator p1, p2, p3;
    p1 = find(lst1.begin(), lst1.end(), 30);
    p2 = find(lst2.begin(), lst2.end(), 2);
    p3 = find(lst2.begin(), lst2.end(), 4);
    lst1.splice(p1, lst2, p2, p3);  //将[p2, p3)插入p1之前，并从 lst2 中删除[p2,p3)
    cout << "8)"; Print(lst1.begin(), lst1.end());  //输出：8)40 2 30 30 20 4 3 1
    cout << "9)"; Print(lst2.begin(), lst2.end());  //输出：9)3 4
    return 0;
}
```

约瑟夫问题：有 n 只猴子，按顺时针方向围成一圈选大王（编号为 1~n），从第 1 号开始报数，一直数到 m，数到 m 的猴子退到圈外，剩下的猴子再接着从 1 开始报数。就这样，直到圈内只剩下一只猴子时，这个猴子就是猴王。编程求输入 n、m 后,输出最后猴王的编号。

输入数据：每行是用空格分开的两个整数，第一个是 n，第二个是 m（0<m, n<=1 000 000）。最后一行是：
0 0

输出要求：对于每行输入数据（最后一行除外），输出数据也是一行，即最后猴王的编号。

输入样例：
6 2
12 4
8 3
0 0

输出样例：
5
1
7
```c++
#include <list>
#include <iostream>
using namespace std;
int main()
{
    list<int> monkeys;
    int n, m;
    while (true) {
        cin >> n >> m;
        if (n == 0 && m == 0)
            break;
        monkeys.clear();  //清空list容器
        for (int i = 1; i <= n; ++i)  //将猴子的编号放入list
            monkeys.push_back(i);
        list<int>::iterator it = monkeys.begin();
        while (monkeys.size() > 1) { //只要还有不止一只猴子，就要找一只猴子让其出列
            for (int i = 1; i < m; ++i) { //报数
                ++it;
                if (it == monkeys.end())
                    it = monkeys.begin();
            }
            it = monkeys.erase(it); //删除元素后，迭代器失效，
                                    //要重新让迭代器指向被删元素的后面
            if (it == monkeys.end())
                it = monkeys.begin();
        }
        cout << monkeys.front() << endl; //front返回第一个元素的引用
    }
    return 0;
}
```