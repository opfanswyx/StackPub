## 命名空间
定义命名空间```namespace MyProject;```，子命名空间```namespace MyProject\Sub\Level; ```。

## 类

* 类使用 class 关键字后加上类名定义。
* 类名后的一对大括号({})内可以定义变量和方法。
* 类的变量使用 var 来声明, 变量也可以初始化值。
* 函数定义类似 PHP 函数的定义，但函数只能通过该类及其实例化的对象访问。

```php
<?php
class phpClass {
  var $var1;
  var $var2 = "constant string";
  
  function myfunc ($arg1, $arg2) {
     [..]
  }
  [..]
}
?>
```

类创建后，使用```new```运算符来实例化该类的对象。
### 访问控制
PHP 对属性或方法的访问控制，是通过在前面添加关键字 public（公有）， protected（受保护）或 private（私有）来实现的。

* public（公有）：公有的类成员可以在任何地方被访问。
* protected（受保护）：受保护的类成员则可以被其自身以及其子类和父类访问。
* private（私有）：私有的类成员则只能被其定义所在的类访问。

## 构造析构函数
构造函数```void __construct ([ mixed $args [, $... ]] )```。

析构函数```void __destruct ( void )```。

```php
<?php
class MyDestructableClass {
   function __construct() {
       print "构造函数\n";
       $this->name = "MyDestructableClass";
   }

   function __destruct() {
       print "销毁 " . $this->name . "\n";
   }
}

$obj = new MyDestructableClass();
?>
```
## 继承
PHP使用关键字 extends 来继承一个类，PHP不支持多继承。

```php
class Child extends Parent {
   // 代码部分
}
```

PHP不会在子类的构造方法中自动的调用父类的构造方法。要执行父类的构造方法，需要在子类的构造方法中调用 parent::__construct() 。

### 方法重写
如果从父类继承的方法不能满足子类的需求，可以对其进行改写，这个过程叫方法的覆盖（override），也称为方法的重写。
## 接口
要实现一个接口，使用 implements 操作符。类中必须实现接口中定义的所有方法，否则会报一个致命错误。类可以实现多个接口，用逗号来分隔多个接口的名称。
```php
<?php

// 声明一个'iTemplate'接口
interface iTemplate
{
    public function setVariable($name, $var);
    public function getHtml($template);
}


// 实现接口
class Template implements iTemplate
{
    private $vars = array();
  
    public function setVariable($name, $var)
    {
        $this->vars[$name] = $var;
    }
  
    public function getHtml($template)
    {
        foreach($this->vars as $name => $value) {
            $template = str_replace('{' . $name . '}', $value, $template);
        }
 
        return $template;
    }
}
```
## 抽象类
任何一个类，如果它里面至少有一个方法是被声明为抽象的，那么这个类就必须被声明为抽象的。

定义为抽象的类不能被实例化。继承一个抽象类的时候，子类必须定义父类中的所有抽象方法；另外，这些方法的访问控制必须和父类中一样（或者更为宽松）。

## 关键字

### static关键字
声明类属性或方法为 static(静态)，就可以不实例化类而直接访问。静态属性不可以由对象通过 -> 操作符来访问。
### final关键字
如果父类中的方法被声明为 final，则子类无法覆盖该方法。如果一个类被声明为 final，则不能被继承。

## 异常处理
当异常被抛出时，其后的代码不会继续执行，PHP 会尝试查找匹配的 "catch" 代码块。

如果异常没有被捕获，而且又没用使用 set_exception_handler() 作相应的处理的话，那么将发生一个严重的错误（致命错误），并且输出 "Uncaught Exception" （未捕获异常）的错误消息。

1. Try - 使用异常的函数应该位于 "try" 代码块内。如果没有触发异常，则代码将照常继续执行。但是如果异常被触发，会抛出一个异常。
2. Throw - 里规定如何触发异常。每一个 "throw" 必须对应至少一个 "catch"。
3. Catch - "catch" 代码块会捕获异常，并创建一个包含异常信息的对象。

```php
<?php
// 创建一个有异常处理的函数
function checkNum($number)
{
        if($number>1)
        {
                throw new Exception("变量值必须小于等于 1");
        }
                return true;
}
       
// 在 try 块 触发异常
try
{
        checkNum(2);
        // 如果抛出异常，以下文本不会输出
        echo '如果输出该内容，说明 $number 变量';
}
// 捕获异常
catch(Exception $e)
{
        echo 'Message: ' .$e->getMessage();
}
?>
```
### 自定义Exception 类
```php
<?php
class customException extends Exception
{
        public function errorMessage()
        {
                // 错误信息
                $errorMsg = '错误行号 '.$this->getLine().' in '.$this->getFile()
                .': <b>'.$this->getMessage().'</b> 不是一个合法的 E-Mail 地址';
                return $errorMsg;
        }
}

$email = "someone@example...com";

try
{
        // 检测邮箱
        if(filter_var($email, FILTER_VALIDATE_EMAIL) === FALSE)
        {
                // 如果是个不合法的邮箱地址，抛出异常
                throw new customException($email);
        }
}

catch (customException $e)
{
//display custom message
echo $e->errorMessage();
}
?>
```
### 顶层异常处理器
set_exception_handler() 函数可设置处理所有未捕获异常的用户定义函数。
```php
<?php
function myException($exception)
{
        echo "<b>Exception:</b> " , $exception->getMessage();
}

set_exception_handler('myException');

throw new Exception('Uncaught Exception occurred');
?>
```