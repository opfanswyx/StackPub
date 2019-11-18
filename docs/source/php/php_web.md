## cookie
cookie 常用于识别用户。cookie 是一种服务器留在用户计算机上的小文件。每当同一台计算机通过浏览器请求页面时，这台计算机将会发送 cookie。

```php
setcookie(name, value, expire, path, domain);
```
```php
<?php
$expire=time()+60*60*24*30;
setcookie("user", "atticus", $expire);

// 设置 cookie 过期时间为过去 1 小时
setcookie("user", "", time()-3600);


?>

<html>
.....
```

```php
<?php
// 输出 cookie 值
echo $_COOKIE["user"];

// 查看所有 cookie
print_r($_COOKIE);
?>
```
## session
PHP session 变量用于存储关于用户会话（session）的信息，或者更改用户会话（session）的设置。Session 变量存储单一用户的信息，并且对于应用程序中的所有页面都是可用的。

把用户信息存储到 PHP session 中之前，首先必须启动会话。session_start()函数必须位于 <html> 标签之前。
```php
<?php
session_start();

if(isset($_SESSION['views']))
{
        $_SESSION['views']=$_SESSION['views']+1;
}
else
{
        $_SESSION['views']=1;
}
echo "浏览量：". $_SESSION['views'];
?>
```

**销毁session**
```php
<?php
session_start();
if(isset($_SESSION['views']))
{
        unset($_SESSION['views']);
}
//session_destroy()将重置session，将失去所有已存储的session数据。
session_destroy();
?>
```