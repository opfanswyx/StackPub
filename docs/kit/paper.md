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
当形参是引用类型时，它对应的实参被**引用传递**(passed by reference)，和其他引用一样，引用形参也是它绑定的对象的别名，使用引用避免拷贝。

当实参的值拷贝给形参时，形参和实参是两个相互独立的对象。对应的实参被**值传递**(passed by value)。

当形参是const时，使用实参初始化形参时会忽略掉顶层const(顶层const作用于对象本身)。当形参有顶层const时，传给它常量对象或者非常量对象都是可以的。

可以使用非常量初始化一个底层const对象，但是反过来不行。普通的引用必须用同类型的对象初始化。

由于不能把const对象，字面值或者需要类型转换的对象传递给普通的引用形参，尽量使用常量引用。

```cpp
void print(int (&arr)[10]){   //数组引用形参
  ...
}
```

**initializer_lister**类型的形参用于实参数量未知但是全部实参的类型相同的情况。

调用一个返回引用的函数得到左值，其它返回类型得到右值。可以为返回类型是非常量引用的函数的结果赋值。
```cpp
char &get_val(string &str, string::size_type ix){
  return str[ix];
}

int main(){
  string s("a value");
  cour << s << endl;
  get_val(s,0) = 'A';
  cout << s << endl;
  return 0;
}
```
c++11规定，函数可以返回**花括号包围的值的列表**。类似于其他返回结果，此处的列表也用来对表示函数返回的临时量进行初始化。
```cpp
vector<string> process(){
  if(expected.empty())
    return {};
  else if(expected == actual)
    return {"functionX", "okay"};
  else
    return {"functionX", expected, actual};
}
```

返回数组指针的函数声明```int (*func(int i))[10];```该声明可以使用类型别名简化。
```cpp
typedef int arrT[10];
using arrT = int[10];

arrT* func(int i);
```
c++11还有一种简化上述func声明的方法，即**尾置返回类型**(treiling return type)。任何函数的定义都能使用尾置返回。尾置返回类型跟在形参列表后面并以一个```->```符号开头。为了表示函数真正的返回类型跟在形参列表之后，在本应该出现返回类型的地方放置一个auto：
```cpp
//func接受一个int类型的实参，返回一个指针，该指针指向含有10个整数的数组
auto func(int i) -> int(*)[10];
```

如果知道函数返回的指针将指向哪个数组，就可以使用decltype关键字声明返回类型。
```cpp
int odd[] = {1,3,5,7,9};
int even[] = {0,2,4,6,8};
decltype(odd) *arrPtr(int i){
  //返回一个指向数组的指针
  return (i % 2) ? &add : &even;
}
```
decltype并不负责把数组类型转换成对应的指针，所以decltype的结果是个数组，想表示arrPtr返回指针还必须在函数声明时加一个*符号。

#### 重载
顶层const不影响传入函数的对象。一个拥有顶层const和不拥有顶层const无法区分。

某种类型的指针或引用指向的是否是常量可以实现重载，此时的const的底层const。
```cpp
Record lookup(Phone);
Record lookup(const Phone);

Record lookup(Phone *);
Record lookup(Phone *const);
//以下都是构成重载
Record lookup(Account&);
Record lookup(const Account&);

Record lookup(Account*);
Record lookup(const Account*);
```

在给定的作用域中一个形参只能被赋予一次默认实参。通常在函数声明中指定默认实参，并将该声明放在合适的头文件中。

#### 内联函数和constexpr函数
内联函数(inline)机制用于优化规模较小，流程直接，频繁调用的函数。

**constexpr函数**是指能用于常量表达式的函数。函数的返回类型及所有形参的类型都是字面值类型，而且函数体中必须有且只有一条return语句。
```cpp
constexpr int new_sz() { return 42; }
constexpr int foo = new_sz();
```
constexpr函数被隐式的指定为内联函数。constexpr函数体中可以有其他语句，只要这些语句不被运行时执行就行。

内联函数和constexpr函数通常定义在头文件中。

assert是一种预处理宏。首先对expr求值，如果表达式为假(即0)，assert输出信息并且终止程序的执行。如果表达式为真(非0)，assert什么也不做。
```cpp
assert (expr);
```

除了assert外，也可以使用NDEBUG编写自己的条件调试代码。如果NDEBUG未定义，将执行#ifndef和#endif之间的代码；如果定义了NDEBUG，这些代码将忽略掉：
```cpp
void print(const int ia[], size_t size)
{
#ifndef NDEBUG
    cerr << __FUNC__ << ": array size is " << size << endl;
#endif
  ...
}
```

#### 函数指针
```cpp
bool lengthCompare(const string &, const string &);
bool (*pf) (const string &, const string &);
```
重载函数指针类型必须与重载函数中的某一个精确匹配。
```cpp
void ff(int *);
void ff(unsigned int);

void (*pf1)(unsigned int) = ff;
```
函数指针形参，我们可以直接把函数作为实参使用，它会自动转换成指针。
```cpp
//第三个参数是函数类型，它会自动的转换成指向函数的指针
void useBigger(const string &s1, const string &s2,
          bool pf(const string &, const string &));
//显示的将形参定义成指向函数的指针
void useBigger(const string &s1, const string &s2,
          bool (*pf)(const string &, const string &));
//自动将函数转换成函数指针
useBigger(s1, s2, lengthCompare);
```
返回指向函数的指针
```cpp
using F = int(int *, int);      //F是函数类型，不是指针
using PF = int(*)(int *, int);  //PF是指针类型

PF f1(int);     //f1返回指向函数的指针
F f1(int);      //错误
F *f1(int);     //显示地指定返回类型是指向函数的指针

int (*f1(int))(int *, int);
//尾置返回类型
auto f1(int) -> int (*)(int *, int); 
```
decltype作用于某个函数时，它返回函数类型而非指针类型，应该显示地加上```*```以表明我们需要返回指针。

### 类

类的基本思想是数据**抽象**和**封装**。

默认情况下，this的类型是指向类类型非常量版本的常量指针。
#### 构造函数(constructor)
构造函数的任务是初始化类对象的数据成员，无论何时只要类对象被创建，就会执行构造函数。

构造函数不能声明为const的，当创建一个const对象时，直到构造函数完成初始化过程，对象才能真正取得“常量”属性。

如果类没有显示地定义一个构造函数，则编译器会隐式的定义一个默认构造函数，默认构造函数无须任何实参。

在c++11标准中，如果我们需要默认行为，那么可以通过在参数列表后面加上**= default**来要求编译器生成构造函数，其中= default既可以和声明一起出现在类内部，也可以出现在类外部。

除了定义数据和函数成员之外，类还可以自定义某种类型在类中的别名。

```cpp
class Screen{
public:
    typedef std::string::size_type pos;
private:
    pos cursor = 0;
    pos height = 0, width = 0;
    std::string contents;
};
```
如果类成员是const，引用或者属于某种未提供默认构造函数的类类型，必须通过构造函数初始值列表为这些成员提供初值。

定义在类内部的成员函数是自动inline的。我们可以在类的内部把inline作为声明的一部分显示地声明成函数，也能在类的外部用inline关键字修饰函数的定义。inline成员函数也应该与相应的类定义在同一个头文件中。

**委托构造函数**使用所属类的其他构造函数执行它自己的初始化过程，或者把它自己的一些(或全部)职责委托给其他构造函数。
```cpp
class Sales_data{
public:
  //非委托构造函数
  Sales_data(std:string s, unsigned cnt, double price):
      bookNo(s), units_sold(cnt), revenue(cnt * price) {}
  //其余构造函数委托另一个构造函数
  Sales_data() : Sales_data("", 0, 0) {}
  Sales_data(std::string s) : Sales_data(s, 0, 0) {}
  Sales_data(std::istream &is) : Sales_data() { read(is, *this);}
}
```
**转换构造函数**只接受一个实参，则它实际上定义了转换为此类类型的隐式转换机制。

将构造函数加以**explicit**声明，可以抑制构造函数隐式转换。

#### 聚合类
聚合类：所有成员都是public的。没有定义任何构造函数。没有类初始值。没有基类，也没有virtual函数。
#### 字面值常量类

#### 类的静态成员

### IO库

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

### 顺序容器

|||
|:-|:-|
|vector|可变大小数组。支持快速随机访问。在尾部之外的位置插入或删除元素可能很慢。|
|deque|双端队列。支持快速随机访问。在头尾位置插入/删除速度很快。|
|list|双向链表。只支持双向顺序访问。在list中任何位置进行插入/删除操作速度都很快。|
|forward_list|单向链表。只支持单向顺序访问。在链表任何位置进行插入/删除操作速度很快。|
|array|固定大小数组，支持快速随机访问。不能添加或删除元素。|
|string|与vector相似的容器，但专门用于保存字符，随机访问快，在尾部插入/删除速度块。|

#### 容器适配器
适配器(adaptor)接受一种已有的容器类型，使其行为看起来像一种不同的容器。

顺序容器的适配器：stack，queue和priority_queue。

### 泛型算法
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
#### 参数绑定
#### 额外的迭代器
插入迭代器，流迭代器，反向迭代器，移动迭代器。
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

### 动态内存
shared_ptr,unique_ptr,weak_ptr.
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

### 拷贝控制
**拷贝构造函数**和**移动构造函数**定义类当用同类型的另一个对象**初始化**本对象时做什么。

**拷贝赋值运算符**和**移动赋值运算符**定义类一个对象**赋予**同类型的另一个对象时做什么。

拷贝构造函数第一个参数是自身类类型的引用，且任何额外参数都有默认值。虽然可以定义一个接受非const引用的拷贝构造函数，但此参数几乎总是一个const引用。拷贝构造函数常被隐式地使用，通常不应该是explicit的。

#### 对象移动
标准库容器，string和shared_ptr类既支持移动也支持拷贝。IO类和unique_ptr类可以移动但不能拷贝。

**右值引用**必须绑定到右值的引用。只能绑定到一个将要销毁的对象。
```cpp
int i = 42;     
int &r = i;   
int &&rr = i;           //不能将一个右值引用绑定到一个左值上
int &r2 = i * 42;       //i * 42是一个右值
const int &r3 = i * 42; //可以将一个const的引用绑定到一个右值上
int &&rr2 = i *42;
```
变量是左值，不能将一个右值引用直接绑定到一个变量上，即使这个变量是右值引用类型也不行。
```cpp
int &&rr1 = 42;
int &&rr2 = rr1;  //错误：表达式rr1是左值。
```

新标准库中**move**函数可以获取绑定到左值上的右值引用。
```cpp
int &&rr3 = std::move(rr1);
```

类似拷贝构造函数，移动构造函数第一个参数是该类型的一个引用。该引用是一个右值引用。移动构造函数必须确保移后源对象处于这样一个状态--销毁后是无害的。一旦资源完成移动，源对象必须不再指向被移动的资源--这些资源的所有权已经归属新创建的对象。
```cpp
StrVec::StrVec(StrVec &&s) noexcept //移动操作不应抛出任何异常
//成员初始化器接管s中的资源
  : elements(s.elements), first_free(s.first_free), 
  cap(s.cap)
{
  s.elements = s.first_free = s.cap = nullptr;
}
```
不抛出异常的移动构造函数和移动赋值运算符必须标记为noexcept。
```cpp
StrVec &StrVec::operator=(StrVec &&rhs) noexcept
{
  if(this != &rhs)
  {
    free();
    elements    = rhs.elements;
    first_free  = rhs.first_free;
    cap          = rhs.cap;
    rhs.elements = rhs.first_free = rhs.cap = nullptr;
  }
  return *this;
}
```
如果一个类既有移动构造函数，也有拷贝构造函数则**移动右值，拷贝左值**，如果没有移动构造函数，右值也被拷贝。

可以通过标准库的**make_move_iterator**函数将一个普通迭代器转换为一个**移动迭代器**。
### 操作重载与类型转换
当运算符作用于类类型的运算对象时，可以通过重载重新定义该运算符的含义。
### 面向对象设计
面向对象程序设计的核心思想是数据抽象，继承和动态绑定。

在c++中，当我们使用基类的引用(或指针)调用一个虚函数时将会发生动态绑定。

### 模板与泛型编程
#### 函数模版
#### 类模版

### 其它