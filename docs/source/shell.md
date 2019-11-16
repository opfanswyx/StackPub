Shell(壳)处于内核与用户之间。主要功能为命令解释，```ls /bin/*sh```。
## 变量
Shell中的变量在使用前无须定义，在使用时创建。shell中使用$符号来引用变量。

|引用格式|返回值|举例|
|:-:|:-:|:-|
|$var|返回变量值|var="hello",$var即hello|
|${var}|返回变量值|var="hello",${var}即hello|
|${#var}|返回变量的长度|var="hello",${#var}即5|
|${var:start_index}|返回从start_index开始到字符串末尾的子串，字符串中的下标从0开始|var="hello",${var:2}即llo|
|${var:start_index:length|返回从start_index开始的长度length个字符。当start_index为负值，表示从末尾往前数start_index|var="helloworld"</br> ${var:2:3}即llo</br> ${var:-4:3}即orl|
|${var#string}|返回从左边删除string前的字符串，包括string，匹配最近的字符|var="helloworld",${var#*o}即world,\*表示通配符|
|${var##string}|返回从左边删除string前的字符串，包括string，匹配最长的字符|var="helloworld",${var##*o}即rld|
|${var:=newstring}|当var为空或未定义，则返回newstring，并把newstring赋给var，否则返回原值|var="",${var:=hello}即hello,var=hello; </br> var="hello", ${var:=world}即hello|
|${var:-newstring}|当var为空或未定义，则返回newstring，否则返回原值|var="",${var:-hello}即hello,var仍为空; </br> var="hello", ${var:-world}即hello|
|${var:+newstring}|当var为空，则返回空值，否则返回newstring|var="",${var:+hello}为空; </br> var="hello", ${var:+world}即world|
|${var:?newstring}|当var为空或未定义，则将newstring写入标准错误流，该语句失败；否则返回原值|var="", \${var:?hello}将hello写入标准错误流，此时输出为bash:var:hello; </br> var="hello",${var:?world}即hello|
|${var/substring/newstring}|将var中第一个substring替换为newstring并返回新的var|var="hello",${var/ell/wyx}即hwyxo|
|${var//substring/newstring}|将var中所有substring替换为newstring并返回新的var|var="hellohello"，${var//ell/wyx}即hwyxohwyxo|

shell脚本中通过echo关键字打印变量，通过read关键字读取变，```read var```。

### 环境变量
环境变量又称为永久变量，与局部变量相对，用于创建的shell和从该shell派生的子shell或进程中。为了区别于局部变量，环境变量中的字母全部为大写。

```
export 变量名(=值)
```
### 位置变量
位置变量即执行脚本时传入脚本中对应脚本位置的变量。类似函数的参数，引用方法为$符号加上位置参数，如$0,$1,$2,其中$0为脚本名称。

使用```shift```可以移动位置变量对应的参数，shift每执行一次，参数序列顺序左移一个位置。

### 标准变量
标准变量也是环境变量，在bash环境建立时生成。该变量自动解析，通过查看etc目录下的profile文件可以查看系统中的标准环境变量。

使用env命令可以查看系统中的环境变量，包括环境变量和标准变量。

### 特殊变量

* \# 传递到脚本或函数的参数数量。 
* ？ 前一个命令执行情况，0表示成功，其它值表示失败。
* $ 运行当前脚本的当前进程id号。
* ! 运行脚本最后一个命令。
* \* 传递给脚本或函数的全部参数。

### 变量的运算

**let**
let命令可以进行算术运算和数值表达式测试。
```
let 表达式
((算术表达式))

#!/bin/sh
i = 1
let i=i+2
((i+=2))
```

**expr**
```
expr 3+5
8
```
## 条件语句

### 条件判断
```
test 选项 参数
if test -f file
then
    ...
fi
```
\[命令与test命令功能相同,需要注意的是\[命令也是命令,命令与选项之间应有空格。因此在\[\]符号与\[\]符号中的检查条件之间需要留出空格，否则产生错误。
```
if [ -f file ]; then
...
fi
```

**字符串比较**

|条件|说明|
|:-|:-|
|str1=str2|相等结果为真|
|str1!=str2|不想等结果为真|
|-n str|字符串不为空，则结果为真|
|-z str|字符串为空，则结果为真|

**算术比较**

|条件|说明|
|:-|:-|
|expr1 -eq expr2|表达式返回值相同，则结果为真|
|expr1 -ne expr2|表达式返回值不同，则结果为真|
|expr1 -gt expr2|expr1的返回值大于expr2的返回值，则结果为真|
|expr1 -ge expr2|expr1的返回值大于等于expr2的返回值，则结果为真|
|expr1 -lt expr2|expr1的返回值小于expr2的返回值，则结果为真|
|expr1 -le expr2|expr1的返回值小于等于expr2的返回值，则结果为真|
|!expr|当表达式结果为假，则结果为真|

**文件测试**

|条件|说明|
|:-|:-|
|-d file|file是目录，则结果为真|
|-f file|file是普通文件，则结果为真|
|-r file|file可读，则结果为真|
|-w file|file可写，则结果为真|
|-x file|file可执行，则结果为真|
|-s file|file文件大小不为0，则结果为真|
|-a file|file存在，则结果为真||

### if条件语句
```
if [ 条件判断语句 ]; then
...
fi

if [ 条件判断语句 ]; then
...
else
...
fi

if [ 条件判断语句 ]; then
...
elif [ 条件判断语句 ]; then
...
else
...
fi
```
### select语句
```
select 变量 in 列表
do 
...
    [break]
done
```
```
#!/bin/sh
#select
echo "please gei me a number:"
select data_sum in "one" "two" "three" "four"
do 
    echo "you input "$data_sum
    break
done
exit 0
```
### case语句
```
case var in
    option1)...;;
    'option2')...;;
    "option3")...;;
    ...
    *)...
esac
exit 0
```
匹配选项可以使用(单引号/双引号)，也可以直接列出。选项后需添加一个\)，每个匹配条件 都以;;结尾，最后一个匹配项*类似C语言中的default，是一个通配符，该匹配项不需要;;结尾。

## 循环

## 函数

## 调试