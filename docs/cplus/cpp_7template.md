## 模板和泛型
在C++中，数据的类型也可以通过参数来传递，在函数定义时可以不指明具体的数据类型，当发生函数调用时，编译器可以根据传入的实参自动推断数据类型。这就是类型的参数化。

### 函数模板(Function TempLate)
```c++
template <typename 类型参数1 , typename 类型参数2 , ...> 返回值类型  函数名(形参列表){
    //在函数体中可以使用类型参数
}
```
### 类模板(Class Template)
```c++
template<typename 类型参数1 , typename 类型参数2 , …> class 类名{
    //TODO:
};

template<typename 类型参数1 , typename 类型参数2 , …>
返回值类型 类名<类型参数1 , 类型参数2, ...>::函数名(形参列表){
    //TODO:
}
```
可变长数组实现
```c++
#include <iostream>
#include <cstring>
using namespace std;
template <class T>
class CArray
{
    int size;   //数组元素的个数
    T *ptr;     //指向动态分配的数组
public:
    CArray(int s = 0);          //s代表数组元素的个数
    CArray(CArray & a);
    ~CArray();
    void push_back(const T & v); //用于在数组尾部添加一个元素v
    CArray & operator=(const CArray & a); //用于数组对象间的赋值
    T length() { return size; }
    T & operator[](int i)      //用以支持根据下标访问数组元素，如a[i] = 4;和n = a[i]这样的语句
    {       
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
    memcpy(ptr, a.ptr, sizeof(T) * a.size);
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
### 函数模板**重载**
C++允许对函数模板进行重载。
```c++
#include <iostream>
using namespace std;
template<class T> void Swap(T &a, T &b);  //交换基本类型的值
template<typename T> void Swap(T a[], T b[], int len);  //交换两个数组
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
#### 函数模板实参推断
在使用类模板创建对象时，需要显式的指明实参。而对于函数模板，调用函数时可以不显式地指明实参。

但是对于函数模板，类型转换受到更多的限制，仅能进行```const 转换```和```数组或函数指针转换```，其他的类型转换都不能应用于函数模板。

### 模板的显示具体化(Explicit Specialization)
模板中的语句（函数体或者类体）不一定就能适应所有的类型，可能会有个别的类型没有意义，或者会导致语法错误。(例如：>能够用来比较 int、float、char 等基本类型数据的大小，但是却不能用来比较结构体变量、对象以及数组的大小，因为我们并没有针对结构体、类和数组重载>)

#### 函数模板的显示具体化
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
#### 类模板的显示具体化
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
#### 部分显示具体化

部分显式具体化只能用于类模板，不能用于函数模板。

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
### 非类型参数
C++ 对模板的支持非常自由，模板中除了可以包含类型参数，还可以包含非类型参数。T 是一个类型参数，它通过class或typename关键字指定。N 是一个非类型参数，用来传递数据的值，而不是类型，它和普通函数的形参一样，都需要指明具体的类型。
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
### 非类型参数限制
非类型参数的类型不能随意指定，它受到了严格的限制，只能是一个整数，或者是一个指向对象或函数的指针（也可以是引用）。

模板的实例化是由编译器完成（隐式实例化）的，而不是由链接器完成的，这可能会导致在链接期间找不到对应的实例。所以不能将模板的声明和定义分散到多个文件中
### 模板实例化
模板的实例化是由编译器完成的，而不是由链接器完成的，这可能会导致在链接期间找不到对应的实例。所以模板定义（实现）部分应当合并放在一起。
#### 模板的显式实例化
显式实例化一个类模板时，会一次性实例化该类的所有成员，包括成员变量和成员函数。

有了类模板的显式实例化，就可以将类模板的声明和定义分散到不同的文件中。
```c
template void Swap(double &a, double &b);

template class Point<char*, char*>;

extern template declaration;  //实例化声明
template declaration;  //实例化定义
```
### 类模板与继承
类模板和类模板之间、类模板和类之间可以互相继承。
#### 类模板从类模板派生
```c++
template <class T1, class T2>
class A
{
    Tl v1; T2 v2;
};
template <class T1, class T2>
class B : public A <T2, T1>
{
    T1 v3; T2 v4;
};
template <class T>
class C : public B <T, T>
{
    T v5;
};
int main()
{
    B<int, double> obj1;
    C<int> obj2;
    return 0;
}
```
#### 类模板从模板类派生
```c++
template<class T1, class T2>
class A{ T1 v1; T2 v2; };
template <class T>
class B: public A <int, double>{T v;};
int main() { B <char> obj1; return 0; }
```
#### 类模板从普通类派生
```c++
class A{ int v1; };
template<class T>
class B: public A{ T v; };
int main (){ B <char> obj1; return 0; }
```
#### 普通类从模板类派生
```c++
template <class T>
class A{ T v1; int n; };
class B: public A <int> { double v; };
int main() { B obj1; return 0; }
```
### 类模板与友元
#### 函数、类、类的成员函数作为类模板的友元
```c++
void Func1() {  }
class A {  };
class B
{
public:
    void Func() { }
};
template <class T>
class Tmpl
{
    friend void Func1();
    friend class A;
    friend void B::Func();
};
int main()
{
    Tmpl<int> i;
    Tmpl<double> f;
    return 0;
}
```
#### 函数模板作为类模板的友元
```c++
#include <iostream>
#include <string>
using namespace std;
template <class T1, class T2>
class Pair
{
private:
    T1 key;  //关键字
    T2 value;  //值
public:
    Pair(T1 k, T2 v) : key(k), value(v) { };
    bool operator < (const Pair<T1, T2> & p) const;
    template <class T3, class T4>
    friend ostream & operator << (ostream & o, const Pair<T3, T4> & p);
};
template <class T1, class T2>
bool Pair <T1, T2>::operator< (const Pair<T1, T2> & p) const
{  //“小”的意思就是关键字小
    return key < p.key;
}
template <class Tl, class T2>
ostream & operator << (ostream & o, const Pair<T1, T2> & p)
{
    o << "(" << p.key << "," << p.value << ")";
    return o;
}
int main()
{
    Pair<string, int> student("Tom", 29);
    Pair<int, double> obj(12, 3.14);
    cout << student << " " << obj;
    return 0;
}
```
#### 函数模板作为类的友元
```c++
#include <iostream>
using namespace std;
class A
{
    int v;
public:
    A(int n) :v(n) { }
    template <class T>
    friend void Print(const T & p);
};
template <class T>
void Print(const T & p)
{
    cout << p.v;
}
int main()
{
    A a(4);
    Print(a);
    return 0;
}
```
#### 类模板作为类模板的友元
```c++
#include <iostream>
using namespace std;
template<class T>
class A
{
public:
    void Func(const T & p)
    {
        cout << p.v;
    }
};
template <class T>
class B
{
private:
    T v;
public:
    B(T n) : v(n) { }
    template <class T2>
    friend class A;  //把类模板A声明为友元
};
int main()
{
    B<int> b(5);
    A< B<int> > a;  //用B<int>替换A模板中的 T
    a.Func(b);
    return 0;
}
```
### 类模板中的静态成员
类模板中可以定义静态成员，从该类模板实例化得到的所有类都包含同样的静态成员。
```c++
#include <iostream>
using namespace std;
template <class T>
class A
{
private:
    static int count;
public:
    A() { count ++; }
    ~A() { count -- ; };
    A(A &) { count ++ ; }
    static void PrintCount() { cout << count << endl; }
};
template<> int A<int>::count = 0;
template<> int A<double>::count = 0;
int main()
{
    A<int> ia;
    A<double> da;
    ia.PrintCount();
    da.PrintCount();
    return 0;
}
```