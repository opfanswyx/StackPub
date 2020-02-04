## 正则表达式(Regular Expression,regexp)
pcre/grep/

### 定位符

|定位符|说明|
|:-:|:-:|
|^|匹配字符串的开始|
|$|匹配字符串结尾的位置|

### 选折符
当要查找的条件有多个，只要其中一个满足即成立时，使用选择符"|"。
```
grep -p --color 'Linux|UNIX'
```
### 字符范围
|示例|说明|
|:-:|:-:|
|[abc]|匹配字符a,b,c|
|[^abc]|匹配除a,b,c以外的字符|
|[a-z]|匹配字母a-z范围内的字符|

```
[^a-z]
[a-zA-Z0-9]
```
### 点字符和限定符
点字符"."用来匹配任意一个字符。

限定符(?,+,*,{})用于匹配某个字符出现的次数。

|字符|说明|示例|
|:-:|:-:|:-:|
|.|匹配一个任意字符|s.t-->sat,set,sit|
|?|匹配前面的字符零次或者一次|colou?r-->color,colour|
|+|匹配前面的字符一次或者多次|go+gle-->goole,gooooole|
|*|匹配前面的字符零次或者多次|go*gle-->gogle,goooogle|
|{n}|匹配前面的字符n次|go{2}gle-->google|
|{n,}|匹配前面的字符至少n次|go{3,}gle-->gooogle,gooooooogle|
|{n,m}|匹配前面的字符至少n次，最多m次|employe{0,2}-->employ,employe,employee|

当点字符和限定符连用时，可以实现匹配指定数量的**任意字符**。

正则表达式支持贪婪匹配和惰性匹配两种，默认情况下是贪婪匹配。当要实现惰性匹配 ，在上一个限定符后面加上"?"符号。

|匹配方式|示例|说明|
|:-:|:-:|:-:|
|贪婪|a.*b|最先出现的a到最后出现的b-->**a00b00bab**c|
|惰性|a.*?b|最先出现的a到最先出现的b-->**a00b**00b**ab**c|

### 小括号
小括号的两个作用，一是改变作用范围，二是分组。

|示例|说明|
|:-:|:-:|
|thir\|fourth|**thir**th**fourth**|
|(thir\|four)th|**thirth fourth**|
|app{2}|**appp**pappapp|
|(app){2}|apppp**appapp**(分组后表示匹配2个app)|

### 反斜杠

反斜杠"\"有两个作用，一是作为转义字符，二是表示一些不可打印的字符，指定预定义字符集等。

|字符|说明|
|:-:|:-:|
|\d|任意一个十进制数字，相当于[0-9]|
|\D|任意一个非十进制的数字|
|\w|任意一个单词字符，相当于[a-zA-z0-9]|
|\W|任意一个非单词字符|
|\s|任意一个空白字符(空格，水平制表符)|
|\S|任意一个非空白字符|
|\b|单词分界符，\bapple --> test **apple**|
|\B|非单词分界符，\Bple --> test ap**ple**|
|\xhh|表示hh(十六进制2位数字)对应的ASCII字符，如\x61是a|

### 示例
只允许访问html,css,jpg扩展名

```
^.*?\.(html|css|jpg)$
```

验证ip地址

```
0~99:    [1-9]?\d
100~199: 1\d{2}
200~255: 2([0-4]\d|5[0-5])
0~255:   [1-9]?\d|1\d{2}|2([0-4]\d|5[0-5]) 
0.0.0.0: ^(0\.){3}0$  -->  ^(()\.){3}()$
ip地址:   ^(([1-9]?\d|1\d{2}|2([0-4]\d|5[0-5]))\.){3}([1-9]?\d|1\d{2}|2([0-4]\d|5[0-5]))$
```

验证日期格式

```
验证年份:  [1-9]\d{3}
验证月份:  [1-9]|1[0-2]
验证天数:  [1-9]|[1-2]\d|3[01]
完整正则表达式: ^[1-9]\d{3}-([1-9]|1[0-2])-([1-9]|[1-2]\d|3[01])$
```