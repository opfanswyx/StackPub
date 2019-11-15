## Web服务搭建
### nginx+php
#### php安装与使用
##### 编译安装php

|选项|说明|
|:-:|:-:|
|--prefix|安装目录，默认目录为/usr/local，也可以设为/usr/local/php|
|--enable-fpm|开启php的fpm功能，提供php FastCGI管理器|
|--with-zlib|包含zlib库，支持数据压缩和解压缩|
|--enable-zip|开启zip功能|
|--enable-mbstring|开启mbstring功能，用于多子节字符串处理|
|--with-mcrypt|包含mcrypt加密支持(yilailibmcrypt)|
|--with-mysqli|包含mysql数据库访问支持|
|--with-pdo-mysql|包含基于PDO(php data object)的mysql数据库访问支持|
|--with-gd|包含gd库支持，用于php图像处理|
|--with-jpeg-dir|包含jpeg图像格式处理库(依赖libjpeg-devel)|
|--with-png-dir|包含png图像格式处理库(依赖libpng-devel)|
|--with-freetype-dir|包含freetype字体图像处理库(依赖freetype-devel)|
|--with-curl|包含curl支持(依赖curl-devel)|
|--with-openssl|包含openssl支持(依赖openssl-devel)|
|--with-mhash|包含mhash加密支持|
|--enable-bcmath|开启精准计算功能|
|--enable-opcache|开启opcache功能，一种php的代码优化器|

```
yum -y install libxml2-devel openssl-devel \
curl-devel libjpeg-devel libpng-devel freetype-devel
//https://sourceforge.net/projects/mcrypt
tar -zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure
make && make install
```

```
//http://php.net
cd php-5.6.27
./configure --prefix=/usr/local/php--enable-fpm\
--with-zlib --enable-zip --enable-mbstring --with-mcrypt --with-mysql \
--with-mysqli --with-pdo-mysql --with-gd --with-jpeg-dir --with-png-dir \
--with-freetype-dir --with-curl --with-openssl --with-mhash --enable-bcmath \
--enable-opcache

make && make install
```
```
<?php
    echo "Hello World!\n";
?>

/usr/local/php/bin/php -f test.php
```

#### php与nginx整合
##### FastCGI & PHP-FPM
php提供的php-fpm是一个FastCGI进程管理器，其可执行文件位于php安装目录下的sbin目录中。在启动php-fpm之前，需要先创建配置文件。在etc目录下提供了默认配置文件php-fpm.conf.default，将该文件复制为php-fpm.conf即可。
```
cd /php-5.6.27
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
chkconfig--add php-fpm

service php-fpm start|reload|restart|stop
```
##### php配置文件
**php-fpm.conf**
PHP-FPM启动时，具体监听的端口号和工作用户在php-fpm.conf配置文件中可以修改。

";"开头的配置是注视掉，没生效的。
```
[global]
;pi=run/php-fpm.pid
;error_log=log/php-fpm.log
;daemonize=yes
;events.mechanism=epoll
[www]
user=nobody
group=nobody
listen=127.0.0.1:9000
;listen.owner=nobody
;listen.group=nobody
;listen.mode=0660
;listen.allowed_clients=127.0.0.1
pm=dynamic
;access.log=log/$pool.access.log
;php_flag[display_errors]=off
;php_admin_value[memory_limit]=32M
```

**php.ini**
php-fpm.conf只和PHP-FPM有关，php本身的配置文件为php.ini。
```
cd /usr/local/php/lib
ls | grep php.ini
php.ini-development     //开发环境
php.ini-production      //线上环境
```
```
[PHP]
output_buffering=4096   //输出缓冲(字节数)
;open_basedir=          //限制php脚本可访问的路径
disable_functions =     //禁用的函数列表
max_execution_time=30   //每个php脚本最长时间限制(秒)
memory_limit=128M       //每个php脚本最大内存使用限制
display_errors=On       //是否输出错误信息
log_errors=On           //是否开启错误日志
;error_log=php_errors.log   //错误日志保存位置
post_max_size=8M        //通过post提交的最大限制
default_mimetype="text/html"    //默认的mime类型
default_charset="UTF-8"         //默认字符集
file_uploads=On         //是否允许上传文件
;upload_tmp_dir=        //上传文件临时保存目录
upload_max_filesize=2M  //上传文件最大限制
allow_url_fopen=On      //是否允许打开远程文件
[Date]
;date.timezone=         //时区配置
[mail function]
;sendmail_path=         //sendmail的路径
[Session]
session.save_handler=files      //将会话以文件形式保存
;session.save_path="\tmp"       //回话保存目录
```
#### FastCGI环境变量
在nginx的conf目录中有一个fastcgi.conf文件，该文件中通过fastcgi_param数组型指令保存了一些环境变量。
```
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
fastcgi_param QUERY_STRING $query_string;
```

|选项|说明|示例|
|:-:|:-:|:-:|
|SCRIPT_FILENAME|脚本文件路径|/usr/local/nginx/html/index.php|
|QUERY_STRING|?后面的URL参数|a=1&b=2|
|REQUEST_METHOD|请求方式|POST|
|CONTENT_TYPE|请求内容的类型|application/x-www-form-urlencoded|
|CONTENT_LENGTH|请求内容长度|8|
|SCRIPT_NAME|脚本文件名|/index.php|
|REQUEST_URI|请求URI|/index.php?a=1&b=1|
|DOCUMENT_URI|文档uri|/index.php|
|DOCUMENT_ROOT|文档根目录|/usr/local/nginx/html|
|SERVER_PROTOCOL|HTTP协议版本|HTTP/1.1|
|REQUEST_SCHEME|请求协议(http/https)|http|
|GATEWAY_INTERFACE|网关接口|CGI/1.1|
|SERVER_SOFTWARE|服务器软件和版本|nginx/1.10.1|
|REMOTE_ADDR|来源地址|192.168.78.1|
|REMOTE_PORT|来源端口|60100|
|SERVER_ADDR|服务器地址|192.168.78.2|
|SERVER_PORT|服务器端口|80|
|SERVER_NAME|服务器名称|ng.test|

#### 在Nginx配置文件中支持php
```
server{
    listen 80;
    server_name ng.test www.ng.test;
    root html/www.ng.test;
    index index.html index.htm index.php;
    location ~\.php${
        fastcgi_pass 127.0.0.1:9000;
        include fastcgi.conf;
    }  
}
```

#### 判断php文件是否存在
404页面 & PATHINFO
```
location ~\.php${
    try_files $uri = 404;
    fastcgi_pass 127.0.0.1:9000;
    include fastcgi.conf;
}
```

### nginx+apache
[Apache HTTP Server(httpd)](https://httpd.apache.org)

```

```
### openresty
获取[OpenResty](https://openresty.org)

```
tar -zxvf openresty-1.11.2.1.tar.gz
cd openresty-1.11.2.1
yum -y install perl pcre-devel openssl-devel
./configure
make && make install
```
```
bin：存放二进制可执行文件。
luajit：存放LuaJIT(Lua代码解释器)相关的文件。
lualib：存放lua库文件。
nginx：OpenResty整合的Nginx存放在这个目录。
pod：存放用于bin/restydoc程序读取的pod文档。
resty.index：存放pkd文档索引。
site：OPM(OpenResty Package Manager)包的存放目录。
```
```
cd /usr/local/openresty/bin
./resty -e 'print("hello")'
./resty ~/hello.lua

vi conf/nginx.conf

worker_processes 1
error_log logs/error.log
events{
    worker_connections 1024;
}
http{
    server{
        listen 8080;
        location / {
            default_type text/html;
            content_by_lua_file test.lua;
        }
    }
}
```

## 模块配置与应用
### 模块概述
### 调试输出
### 响应状态相关
### 网页压缩
### 重写与重定向
### 防盗链配