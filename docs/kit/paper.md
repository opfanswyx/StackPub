## C++ primer学习笔记
### 变量和基本类型
#### 基本内置类型

位(比特序列)(bit,b)，字节(byte,Byte,B)，存储的基本单元为字(word)。

```c
1byte = 8 bit 
​​1KB   = 1024B 
1MB   = 1024KB 
1GB   = 1024MB
1TB   = 1024MB
```

赋给无符号类型一个超出它表示范围的值时，结果是初始值对无符号类型表示数值总数**取模后的余数**。

**当一个算术表达式中既有无符号数又有int值时，那个int值就会转换成无符号数**。

指定字面值类型

|前缀/后缀|类型|
|:-:|:-:|
|u|char16_t|
|U|char32_t|
|L|wchar_t|
|u8|char|
|u or U|float|
|l or L|long double|
|ll or LL|long long|

#### 变量
**数据类型**决定变量所占内存空间的大小和布局方式，该空间能存储的值的范围，以及变量能参与的运算。

变量**定义**：**类型说明符(type specifier)**，随后紧跟一个或多个**变量名**组成的列表，变量名以逗号分隔，最后以分号结束，变量名的类型由类型说明符指定。

变量**初始化**不是**赋值**，初始化的含义是创建变量时赋予其一个初始值，而赋值的含义是把对象的当前值擦除，而以一个新值来替代。

列表初始化用于内置类型的变量时：如果存在初始值丢失信息的风险，则编译器将报错。
```c++
long double ld = 3.1415926536;
int a{ld}, b = {ld};  //错误：转换未执行，存在丢失信息风险
int c(ld), d = ld;    //正确：转换执行，丢失部分值
```
定义函数体内部的内置变量类型将不被**默认初始化**。

变量**声明**规定了变量的类型和名字，除此之外，变量**定义**还申请存储空间，也可能会为变量赋一个初始值。声明一个变量且非定义它，需要在变量名前添加关键字extern，且不要显示初始化该变量。
```c++
extern int i;   //声明
extern double pi = 3.1415;  //extern语句如果包含初始值不再是申明，而变成定义
```
变量能且只能被定义一次，但可以被多次声明。

#### 复合类型

复合类型是指基于其他类型定义的类型。

一条声明语句由一个**基本数据类型**(base type)和紧随其后的一个**声明符**(declarator)列表组成。每个声明符命名了一个变量并指定该变量为与基本数据类型有关的某种类型。

**引用**(reference)并非对象，只是为一个已经存在的对象所起的另外一个名字。引用只能绑定在对象上，不能与字面值或某个表达式的计算结果绑定在一起。

引用本身不是一个对象，所以不能定义引用的引用，且一旦定义了引用，就无法令其再绑定到另外的对象。

C++程序最好使用```nullptr```，同时避免使用```NULL```。

不能定义指向引用的指针，可以定义**对指针的引用**。
```c++
int i = 42;
int *a;       //a是一个指针
int *&p = a;  //p是一个对指针a的引用
p = &i;       //p引用了一个指针，给p赋值&i就是令a指向i
*p = 0;       //解引用p得到i，也就是a指向的对象，将i的值改为0
```

#### const限定符
const对象必须初始化。const对象仅在文件内有效。

const引用(常引用)

在初始化常量引用时允许用任意表达式作为初始值，只要该表达式的结果能转换成引用的类型即可。允许一个常量引用绑定非常量的对象，字面值，甚至是一般表达式。

允许一个常量的指针指向一个非常量对象。

```指向常量的指针```(不能改变其所指对象的值)：const位于*之前。

```常量指针```(不变的是指针本身而非指向的那个值)：const关键字位于* 和var之间。

```顶层const```指针本身是个常量。

```底层const```指针指向的对象是一个常量。


```常量表达式```指不会改变并且在编译过程就能得到计算结果的表达式。一个对象是不是常量表达式由它的数据类型和初始值共同决定。

```constexpr变量```c++11允许将变量声明为constexpr类型以便由编译器来验证变量的值是否是一个常量表达式。

```c++
const int *p = nullptr;     //
constexpr int *q = nullptr; //constexpr把它所定义的对象置为顶层const，constexpr指针既可以指向常量也可以指向一个非常量。
```

类型别名```typedef```和```using```
```c++
typedef double wages;
typedef wages base, *p;

using SI = Sales_item;
```

```c++
typedef char *pstring;
const pstring cstr = 0;
const pstring *ps;
```
上述示例中，const是对给定类型的修饰。pstring实际上指向char的指针，因此，const pstring就是指向char的常量指针，而非指向常量字符的指针。

当引用被用作初始值时，真正参与初始化的其实是引用对象的值。编译器以引用对象的类型作为auto的类型。
```c++
int i = 0, &r = i;
auto a = r; //a是一个整数(r是i的别名，而i是一个整数)
```
auto一般会忽略掉顶层const，同时底层const则会保留。
```c++
const int ci = i, &cr = ci;
auto b = ci;        //b是一个整数(ci的顶层const特性被忽略掉了)
auto c = cr;        //c是一个整数(cr是ci的别名，ci本身是一个顶层const)
auto d = &i;        //d是一个整型指针(整数的地址就是指向整数的指针)
1. auto e = &ci;    //e是一个指向整数常量的指针(对常量对象取地址是一种底层const)
const auto f = ci;  //ci的推演类型是int，f是const int
2. auto &g = ci;    //g是一个整型常量引用，绑定到ci
auto &h = 42;       //错误，不能为非常量引用绑定字面值
const auto &j = 42; //可以为常量引用绑定字面值
```
设置一个类型为auto的引用时(2)，初始值中的顶层const常量属性仍然保留，如果给初始值绑定一个引用(1)，则此时的常量就不是顶层常量了。

#### decltype类型指示符
decltype选择并返回操作数的数据类型。编译器分析表达式的类型，实际不计算表达式的值。
```c++
decltype(fun()) sum = x;  //sum的类型就是函数fun()的返回类型
```
decltype返回该变量的类型(包括顶层const和引用在内)
```c++
const int ci = 0, &cj = ci;
decltype(ci) x = 0;       //x的类型时const int
decltype(cj) y = x;       //y的类型时const int&, y绑定到变量x
decltype(cj) z;           //错误:z是一个引用，必须初始化
```
##### decltype和引用
decltype使用的表达式不是一个变量，则decltype返回表达式结果对应的类型。
```c++
int i = 42, *p = &i, &r = i;
decltype(r + 0) b;    //加法的结果是int，因此b是一个(未初始化的)int
decltype(*p) c;       //c是int&,必须初始化
```
如果表达式的内容是解引用操作，则decltype将得到引用类型。

```decltype((variable))```的结果永远是引用，而```decltype(cariable)```结果只有当variable本身就是一个引用时才是引用。

### 字符串，向量和数组
头文件不应包含using声明
#### string
```c++
#include<string>
using std::string;
```

string类及其他大多数标准库类型都定义了几种配套的类型。这些配套类型体现了标准库类型与机器无关的特性。c++11新标准允许编译器通过auto或者decltype来推断变量的类型```auto len = line.size();```。注意string::size_type是无符号类型，小心与负值的比较。

字符串字面值与string是不同的类型，当把string对象和字符字面值及字符串字面值混在一条语句中使用时，必须确保每个加法运算符(+)的两侧的运算对象至少有一个是string。

```c++
for(auto c : s)
  ispunct(c);
for(auto &c : s)  //引用类型
  toupper(c);
for(decltype(s.size())index = 0;
  index != s.size() && !isspace(s[index]); ++index)
    s[index] = toupper(s[index]);
```

#### vector

vector表示对象的集合，其中所有对象的类型都相同。引用不是对象，所以不存在包含引用的vector。
```c++
#include<vector>
using std::vector;

vector<vector<string>> file;

vector<int>::size_type;
```

```vector```不能用下标形式添加元素，只能对确定已存在的元素执行下标操作。

##### vector迭代器
```begin```成员负责返回指向第一个元素的迭代器，```end```成员负责返回指向容器“尾元素的下一个位置”的迭代器，该迭代器指示的是容器的一个本不存在的“尾后”元素。特殊情况下如果容器为空，则begin和end返回的是同一个迭代器。
```c++
for(auto it = s.begin(); it != s.end() && !isspace(*it); ++it)
  *it = toupper(*it);
```
###### 迭代器类型
```c++
vector<int>::iterator it;
vector<int>::const_iterator it2;  //读取但不能修改
```
```c++
vector<int> v;
const vector<int> cv;
auto it1 = v.begin();   //vector<int>::iterator
auto it2 = cv.begin();  //vector<int>::const_iterator
```
为了便于专门(不论vector对象本身是否是常量)得到const_iterator类型的返回值，c++11引入了两个新函数，分别是cbegin和cend。

使用了迭代器的循环体，都不要向迭代器所属的容器添加元素。

##### 数组

```c++
int *ptrs[10];              //含有10个指针的数组
int &refs[10] = ?;          //错误
int (*parray)[10] = &arr;
int (&parrRef)[10] = arr;
int *(&array)[10] = ptrs;   //array是数组的引用，该数组含有10个指针
```
```c++
int int_arr[] = {0,1,2,3,4,5};
vector<int> ivec(begin(int_arr), end(int_arr));
```
```c++
size_t cnt = 0;
for(auto &row : ia)
  for(auto &clo : row)
    std::cout << col << endl;  
```

### 表达式

### 语句

### 函数

### 类

### IO库

### 顺序容器

### 泛型算法

### 关联容器

### 动态内存

### 拷贝控制

### 操作重载与类型转换

### 面向对象设计

### 模板与泛型编程

### 其它
