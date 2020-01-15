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
const对象必须初始化。const对象仅在文件内有效。为了让const对象在对文件内有效，可以在const变量不管声明还是定义都添加extern关键字。
```c
extern const int bufSize = fcn();   //file.cc
extern const int bufSize;   //file.h
```

在初始化**常量引用**(const引用)时允许用任意表达式作为初始值，只要该表达式的结果能转换成引用的类型即可。允许一个常量引用绑定非常量的对象，字面值，甚至是一般表达式。

允许一个常量的指针指向一个非常量对象。

**指向常量的指针(pointer to const)**(不能改变其所指对象的值)：const位于*之前。指向常量的指针也没有要求所指的对象必须是一个常量。仅仅要求不能通过该指针改变对象的值，也没有规定那个对象的值不能通过其它途径改变

**常量指针(const pointer)**(不变的是指针本身而非指向的那个值)：const关键字位于* 和var之间。const指针必须初始化，且初始化后它的值(存放指针的那个地址)不能在改变。

**顶层const**(top-level const)指针本身是个常量。顶层const可以表示任意的对象是常量(如算术类型，类，指针等)。

**底层const**(low-level const)指针指向的对象是一个常量。与指针和引用等复合类型有关。

```c
int i = 0;
int *const p1 = &i;       //不能改变P1的值，这是一个顶层const
const int ci = 42;        //不能改变ci的值，这是一个顶层const
const int *p2 = &ci;      //允许改变p2的值，这是一个底层const
const int *const p3 = p2; //靠右的const是顶层const，靠左的是底层const
const int &r = ci;        //用于声明引用的const都是底层const
```
执行对象的拷贝操作时，顶层const和底层const常量的区别明显。其中，顶层const不受影响，拷入拷出必须具有相同的底层const资格或者两个对象的数据类型必须能够转换(非常量可以转换成常量，反之则不行)。
```c
i = ci;   //正确:拷贝ci的值，ci是一个顶层const，对此操作无影响。
p2 = p3;  //正确:p2和p3指向的对象类型相同，p3顶层const的部分不影响。

int *p = p3;  //错误:p3包含底层const的定义。
p2 = p3;      //正确:p2和p3都是底层const。
p2 = &i;      //正确:int*能转换成const int *。
int &r = ci;  //错误:普通的int &不能绑定到int常量上。
const int &r2 = i;  //正确:const int&可以绑定到一个普通int上。
```

```常量表达式```指值不会改变并且在编译过程就能得到计算结果的表达式。一个对象是不是常量表达式由它的数据类型和初始值共同决定。

**constexpr变量**c++11允许将变量声明为constexpr类型以便由编译器来验证变量的值是否是一个常量表达式。声明为constexpr的变量一定是一个常量，而且必须用常量表达式初始化。

constexpr声明一个指针，限定符constexpr仅对指针有效，与指针所指的对象无关。constexpr把它所定义的对象置为顶层const，constexpr指针既可以指向常量也可以指向一个非常量。
```c++
const int *p = nullptr;     //p是一个指向整型常量的指针
constexpr int *q = nullptr; //q是一个指向整数的常量指针
```

类型别名```typedef```和```using```
```c++
typedef double wages;
typedef wages base, *p;   //base是double的同义词，p是double *的同义词

using SI = Sales_item;
```

const是对给定类型的修饰。pstring实际上指向char的指针，因此，const pstring就是指向char的常量指针，而非指向常量字符的指针。
```c++
typedef char *pstring;
const pstring cstr = 0;
const pstring *ps;
```

#### auto类型说明符

当引用被用作初始值时，真正参与初始化的其实是引用对象的值。编译器以**引用对象的类型作为auto的类型**。
```c++
int i = 0, &r = i;
auto a = r; //a是一个整数(r是i的别名，而i是一个整数)
```
auto一般会**忽略掉顶层const**，同时底层const则会保留。
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
decltype处理顶层const和引用的方式与auto有些许不同(**引用对象的类型作为auto的类型**)。如果decltype使用的表达式是一个变量,则**decltype返回该变量的类型(包括顶层const和引用在内)**。引用从来都作为其所指对象的同义词出现，只有在decltype处是一个例外。
```c++
const int ci = 0, &cj = ci;
decltype(ci) x = 0;       //x的类型时const int
decltype(cj) y = x;       //y的类型时const int&, y绑定到变量x
decltype(cj) z;           //错误:z是一个引用，必须初始化
```
##### decltype和引用
decltype使用的表达式不是一个变量，则decltype返回**表达式结果**对应的类型。
```c++
int i = 42, *p = &i, &r = i;
decltype(r + 0) b;    //加法的结果是int，因此b是一个(未初始化的)int
decltype(*p) c;       //c是int&,必须初始化
```
如果表达式的内容是解引用操作(*)p，则decltype将得到引用类型。

decltype和auto的另一个重要区别是，如果decltype使用的是一个不加括号的变量，则得到的结果就是该变量的类型；如果给变量加一层或多层括号，编译器会把它当成一个表达式，decltype就会得到引用的类型。**decltype((variable))**的结果永远是引用，而**decltype(cariable)**结果只有当variable本身就是一个引用时才是引用。

### 字符串，向量和数组
头文件不应包含using声明。
#### string(可变长的字符序列)
```c++
#include<string>
using std::string;
```

如果使用等号(=)初始化一个变量，实际执行的是**拷贝初始化**(copy initialization)，编译器把等号右侧的初始值拷贝到新创建的对象中去。如果不使用等号，则执行的是**直接初始化**(direct initialization)。
```c++
string s1;
string s2(s1);
string s2 = s1;
string s3 = "hello";  //拷贝初始化
string s3("value");   //直接初始化
string s4(n, 'c');    //直接初始化
```

string类及其他大多数标准库类型都定义了几种配套的类型。这些配套类型体现了**标准库类型与机器无关的特性**。c++11新标准允许编译器通过auto或者decltype来推断变量的类型```auto len = line.size();```。注意string::size_type是无符号类型，小心与负值的比较。

string**相等性(==和!=)验证规则**：

1. 如果两个string对象的长度不同，而且较短string对象的每个字符都与较长string对象对应为止上的字符串相同，就说较短string对象小于较长string对象。
2. 如果两个string对象在某些对应的位置上不一致，则string对象比较的结果其实是string对象中第一对相异字符比较的结果。

**字符串字面值**与string是不同的类型，当把string对象和字符字面值及字符串字面值混在一条语句中使用时，必须确保每个加法运算符(+)的两侧的运算对象至少有一个是string。

```c++
for(auto c : s)
  ispunct(c);
for(auto &c : s)  //引用类型
  toupper(c);
for(decltype(s.size())index = 0;
  index != s.size() && !isspace(s[index]); ++index)
    s[index] = toupper(s[index]);
```

#### vector(对象的集合)
vector表示对象的集合，其中所有对象的类型都相同。集合中的每个对象都有一个与之对应的索引，索引用于访问对象。引用不是对象，所以不存在包含引用的vector。

```c++
#include<vector>
using std::vector;

vector<vector<string>> file;
vector<int>::size_type;
```

```c++
vector<T> v1;               //v1是一个空vector
vector<T> v2(v1);           //v2中包含有v1所有元素的副本
vector<T> v2 = v1;          //等价于v2(v1)
vector<T> v3(n, val);       //v3包含了n个重复的元素
vector<T> v4(n);            //v4包含了n个重复执行了值初始化的对象
vector<T> v5{a,b,c...};     //v5包含了初始值个数的元素,列表初始化
vector<T> v5 = {a,b,c...};  //等价于v5{a,b,c...}
```

**vector**不能用下标形式添加元素，只能对确定已存在的元素执行下标操作。

##### vector迭代器
**begin**成员负责返回指向第一个元素的迭代器，**end**成员负责返回指向容器**尾元素的下一个位置**的迭代器，该迭代器指示的是容器的一个本不存在的**尾后元素**(off-the-end iterator)。特殊情况下如果容器为空，则begin和end返回的是同一个迭代器，都是尾后迭代器。试图解引用一个非法迭代器或者尾后迭代器都是未定义行为。
```c++
for(auto it = s.begin(); it != s.end() && !isspace(*it); ++it)
  *it = toupper(*it);
```
###### 迭代器类型
如果vector对象或string对象是一个常量，只能使用const_iterator；如果vector对象或string对象不是常量，则既能使用iterator也能使用const_iterator。
```c++
vector<int>::iterator it;
vector<int>::const_iterator it2;  //读取但不能修改
```
如果对象是常量，begin和end返回const_iterator；如果对象不是常量，返回iterator。
```c++
vector<int> v;
const vector<int> cv;
auto it1 = v.begin();   //vector<int>::iterator
auto it2 = cv.begin();  //vector<int>::const_iterator
```
为了便于专门(不论vector对象本身是否是常量)得到const_iterator类型的返回值，c++11引入了两个新函数，分别是cbegin和cend。

**使用了迭代器的循环体，都不要向迭代器所属的容器添加元素**。

##### 数组
不能将数组的内容拷贝给其它数组作为初始值，也不能用数组为其他数组赋值。
```c++
int *ptrs[10];              //含有10个指针的数组
int &refs[10] = ?;          //错误
int (*parray)[10] = &arr;   //parray指向一个含有10个整数的数组
int (&parrRef)[10] = arr;   //parrRef引用一个含有10个整数的数组
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
当一个对象被用作**右值**的时候，用的是对象的值(内容)；当对象被用作**左值**的时候，用的是对象的身份(在内存中的位置)。在需要右值的地方可以用左值来替代，但是不能把右值当成左值使用。

**左移运算**：m<<n表示把m左移n位，最左边的n位被丢弃，右边补上n个0。00001010<<2=00101000

**右移运算**：m>>n表示把m右移n位，最右边的n位被丢弃，左边的情况分两种：

1. 如果数字是一个无符号数值，则用0填补最左边的n位。00001010>>2=00000010
2. 如果数字是一个有符号数值，则用数字的符号位填补 最左边的n位。(如果数字是正数，右移之后左边补0，如果是负数，左边补1)。10001010>>3=11110001

**sizeof**运算符返回一个**表达式**或一个**类型名**所占用的字节数。其所得的值类型是一个size_t类型的常量表达式。
```c++
sizeof (type)
sizeof expr   //sizeof返回的是表达式结果类型的大小。sizeof并不实际计算其运算对象的值。
```

sizeof运算符的结果部分地依赖于其作用的类型：

1. 对char或者类型为char的表达式执行sizeof运算，结果为1。
2. 对引用类型执行sizeof运算得到被引用对象所占空间的大小。
3. 对指针执行sizeof运算得到指针本身所占空间的大小。
4. 对解引用指针执行sizeof运算得到指针指向的对象所占空间的大小，指针不需要有效。
5. 对数组执行sizeof运算得到整个数组所占空间大小，等价于对数组中所有的元素各执行一次sizeof运算并将所得结果求和。
6. 对string对象或vector对象执行sizeof运算只返回该类型固定部分的大小，不会计算对象中的元素占用了多少空间。

因为sizeof运算能得到整个数组的大小，所以可以用数组的大小除以单个元素的大小得到数组中元素的个数:
```cpp
constexpr size_t sz = sizeof(ia) / sizeof(*ia);
int arr[sz];
```

**逗号运算符**(comma operator)，按照从左到右的顺序依次求值。首先对左侧的表达式求值，然后将求值结果丢掉，符号运算符真正的结果是右侧表达式的值。如果右侧运算对象的值是左值，那么最终的求值结果也是左值。
```cpp
j = 10;
i = (j++, j+100, 999+j);  //i = 1010
```

隐式转换(implicit conversion)
显示类型转换(cast)

1. static_cast，任何具有明确定义的类型转换，只要不包含底层const，都可以使用static_cast。
```cpp
void *p = &d;
double *dp = static_cast<double *>(p);
```
2. const_cast只能改变运算对象的底层const，用于把常量对象转换成非常量对象。
```cpp
const char *pc;
char *p = const_cast<char*>(pc);
```
3. reinterpret_cast通常为运算对象的位模式提供较低层次上的重新解释。
```cpp
int *p;
chat *pc = reinterpret_cast<char *>(ip);
```
4. dynamic_cast与运行时类型识别有关。

### 语句
**范围for语句**(range for statement)
```cpp
for(declaration : expression)
  statement
```
```cpp
vector<int> v = {0,1,2,3,4,5,6,7,8,9};
for(auto &r : v){
  r *= 2;
}
```
#### try语句块与异常处理

1. throw表达式(throw expression)异常检测部分使用throw表达式来表示它遇到来无法处理的问题。一般说throw引发(raise)了异常。
2. try语句块(try block)异常处理部分。try语句块与多个catch子句组成。try语句块中代码抛出的异常通常会被某个catch子句结束。
3. 异常类(exception class)，用于在throw表达式和相关的catch子句之间传递异常的具体信息。

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
