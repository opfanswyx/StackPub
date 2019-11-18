## PHP数据类型
```string```,```integer```,```float```,```boolean```,```array```,```object```,```NULL```。

PHP```var_dump()```函数返回变量的数据类型和值。

布尔型可以是TRUE或FALSE。

### 类型比较
php有两种比较方式:

* 松散比较：使用两个等号 == 比较，只比较值，不比较类型。
* 严格比较：用三个等号 === 比较，除了比较值，也比较类型。

```php
<?php
if(42 == "42") {
        echo '1 值相等';
}

echo PHP_EOL; // 换行符

if(42 === "42") {
        echo '2 类型相等';
} else {
        echo '3 不相等';
}
?>
```

## 常量
php常量值被定义后，默认是全局变量，在脚本的其他任何地方都不能被改变。

设置常量，使用 define() 函数:```bool define ( string $name , mixed $value [, bool $case_insensitive = false ] )```，该函数有三个参数:

* name: 必选参数，常量名称，标识符。
* value: 必选参数，常量的值。
* case_insensitive: 可选参数，设置为TURE，则该常量大小写不敏感。默认是大小写敏感。

### 魔术常量

* \_\_LINE\_\_  文件中的当前行号
* \_\_FILE\_\_  文件的完整路径和文件名
* \_\_DIR\_\_  文件所在的目录
* \_\_FUNCTION\_\_  函数名称
* \_\_CLASS\_\_  类的名称
* \_\_TRAIT\_\_  ???
* \_\_METHOD\_\_ 类的方法名
* \_\_NAMESPACE\_\_ 当前命名空间的名称



## PHP变量

php变量以$符号开始，变量名区分大小写，php变量没有声明，第一次赋值时被创建。php是弱类型语言，不必向php声明变量类型。

php变量有四种不同的作用域:```local```,```global```,```static```,```parameter```。

```global```关键字用于函数内访问全局变量。PHP 将所有全局变量存储在一个名为 $GLOBALS[index] 的数组中。index保存变量的名称。这个数组可以在函数内部访问，也可以直接用来更新全局变量。在函数内调用函数外定义的全局变量，我们需要在函数中的变量前加上```global```关键字。

函数局部变量变量声明为```static```关键字，在函数执行完不会被删除。

### echo与print

echo 和 print 区别:

* echo - 可以输出一个或多个字符串。
* print - 只允许输出一个字符串，返回值总为1。

>提示：echo输出的速度比print快，echo没有返回值，print有返回值1。

### 字符串变量

并置运算符```.```用于把两个字符串值连接起来。

```strlen()```函数返回字符串的长度（字节数）。

```strpos()```函数用于在字符串内查找一个字符或一段指定的文本。如果在字符串中找到匹配，该函数会返回第一个匹配的字符位置。如果未找到匹配，则返回 FALSE。

```php
<?php
echo strpos("Hello world!","world");
?>
```
### php超级全局遍历
超级全局变量在PHP 4.1.0之后被启用, 是PHP系统中自带的变量，在一个脚本的全部作用域中都可用。

PHP 超级全局变量:```$GLOBALS```,```$_SERVER```,```$_REQUEST```,```$_POST```,```$_GET```,```$_FILES```,```$_ENV```,```$_COOKIE```,```$_SESSION```.

$_SERVER 是一个包含了诸如头信息(header)、路径(path)、以及脚本位置(script locations)等等信息的数组。这个数组中的项目由 Web 服务器创建。

|$_SERVER中重要元素|描述|
|:-:|:-|
|$_SERVER['PHP_SELF']|当前执行脚本的文件名，与document root有关。|
|$_SERVER['SERVER_ADDR']|当前运行脚本所在的服务器的 IP 地址。|
|$_SERVER['REQUEST_METHOD']|访问页面使用的请求方法；例如，"GET", "HEAD"，"POST"，"PUT"。|
|$_SERVER['QUERY_STRING']|query string（查询字符串），如果有的话，通过它进行页面访问。|
|...|...|

```$_REQUEST```用于收集HTML表单提交的数据。

```$_POST```被应用于收集表单数据，在HTML form标签的指定该属性："method="post"。

```$_GET```同样被应用于收集表单数据，在HTML form标签的指定该属性："method="get"。$_GET 也可以收集URL中发送的数据。

## 运算符

### 逻辑运算符

|运算符|名称|实例|
|:-:|:-:|:-:|
|x and y|与||
|x or y|或||
|x xor y|异或|有且仅有一个为true，则返回true|
|x && y|与||
|x \|\| y|或||
|!x|非||

### 数组运算符

|运算符|名称|描述|
|:-:|:-:|:-:|
|x+y|集合|x和y的集合|
|x==y|相等|x和y具有相同的键值对，则返回true|
|x===y|恒等|x和y具有相同的键/值对，且顺序相同类型相同，则返回true|
|x!=y|不相等||
|x<>y|不相等||
|x!==y|不恒等| x不等于y，则返回true|

```php
<?php
$x = array("a" => "red", "b" => "green");
$y = array("c" => "blue", "d" => "yellow");
$z = $x + $y; // $x 和 $y 数组合并
var_dump($z);
var_dump($x == $y);
var_dump($x === $y);
var_dump($x != $y);
var_dump($x <> $y);
var_dump($x !== $y);
?>
```

三元运算发```(expr1) ? (expr2) : (expr3) ```。

### 组合比较符(PHP7+)

PHP7+ 支持组合比较符也称之为太空船操作符，符号为```<=>```。组合比较运算符实现两个变量的比较，不仅限于数值类数据的比较。```$c = $a <=> $b```;

解析如下：

* 如果 $a > $b, 则 $c 的值为 1。
* 如果 $a == $b, 则 $c 的值为 0。
* 如果 $a < $b, 则 $c 的值为 -1。

## 数组
在PHP中，```array()```函数用于创建数组，```count()```函数用于返回数组的长度（元素的数量）。

php中有三种类型的数组：

* 数值数组 - 带有数字 ID 键的数组
* 关联数组 - 带有指定的键的数组，每个键关联一个值
* 多维数组 - 包含一个或多个数组的数组

```php
<?php
$cars=array("Volvo","BMW","Toyota");
$arrlength=count($cars);

for($x=0;$x<$arrlength;$x++)
{
        echo $cars[$x];
        echo "<br>";
}
?>
```
### 关联数组

```php
$age=array("Peter"=>"35","Ben"=>"37","Joe"=>"43");

$age['Peter']="35";
$age['Ben']="37";
$age['Joe']="43";
```
遍历关联数组
```php
<?php
$age=array("Peter"=>"35","Ben"=>"37","Joe"=>"43");

foreach($age as $x=>$x_value)
{
        echo "Key=" . $x . ", Value=" . $x_value;
        echo "<br>";
}
?>
```

### 数组排序
php数组排序函数：

* sort() - 对数组进行升序排列。
* rsort() - 对数组进行降序排列。
* asort() - 根据关联数组的值，对数组进行升序排列。
* ksort() - 根据关联数组的键，对数组进行升序排列。
* arsort() - 根据关联数组的值，对数组进行降序排列。
* krsort() - 根据关联数组的键，对数组进行降序排列。

## 函数
```php
<?php
function functionName($fname,$punctuation)
{
    // 要执行的代码
    return $xxx;
}
?>
```

### 多维数组
多维数组是包含一个或多个数组的数组。在多维数组中，主数组中的每一个元素也可以是一个数组，子数组中的每一个元素也可以是一个数组。

```php
<?php
$sites = array
(
    "a"=>array
    (
        "aaa",
        "1111"
    ),
    "b"=>array
    (
        "bbb",
        "2222"
    ),
    "c"=>array
    (
        "ccc",
        "3333"
    )
);
print("<pre>"); // 格式化输出数组
print_r($sites);
print("</pre>");
?>
```

## 文件操作
include 和 require 除了处理错误的方式不同之外，在其他方面都是相同的：

* require 生成一个致命错误（E_COMPILE_ERROR），在错误发生后脚本会停止执行。
* include 生成一个警告（E_WARNING），在错误发生后脚本会继续执行。

### 打开文件

feof() 函数检测是否已到达文件末尾（EOF）。

fgets() 函数用于从文件中逐行读取文件。

fgetc() 函数用于从文件中逐字符地读取文件。

```php
<?php
$file=fopen("welcome.txt","r") or exit("无法打开文件!");
while (!feof($file))
{
    echo fgets($file). "<br>";
    echo fgetc($file);
}
fclose($file);
?>
```

## json函数

|函数|描述|
|:-:|:-:|
|json_encode|对变量进行JSON编码|
|json_decode|对JSON格式的字符串进行解码，转换为PHP变量|
|json_last_error|返回最后发生的错误|

### json_encode
```string json_encode ( $value [, $options = 0 ] )```

* value: 要编码的值。该函数只对 UTF-8 编码的数据有效。
* options:由以下常量组成的二进制掩码：JSON_HEX_QUOT, JSON_HEX_TAG, JSON_HEX_AMP, JSON_HEX_APOS, JSON_NUMERIC_CHECK,JSON_PRETTY_PRINT, JSON_UNESCAPED_SLASHES, JSON_FORCE_OBJECT

### json_decode
```mixed json_decode ($json_string [,$assoc = false [, $depth = 512 [, $options = 0 ]]])```

* json_string: 待解码的 JSON 字符串，必须是 UTF-8 编码数据
* assoc: 当该参数为 TRUE 时，将返回数组，FALSE 时返回对象。
* depth: 整数类型的参数，它指定递归深度
* options: 二进制掩码，目前只支持 JSON_BIGINT_AS_STRING 。
