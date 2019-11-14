## Nginx安装
```
yum -y install gcc gcc-c++ wget
wget http://nginx.org/download/nginx-1.10.1.tar.gz
tar -zxvf nginx-1.10.1.tar.gz
```
### nginx目录结构
>* src目录: 存放nginx源码。
* man目录: 存放nginx帮助文档。
* html目录: 存放默认网站文件。
* contrib目录: 存放其它机构或组织贡献的文档资料。
* conf目录: 存放nginx服务器的配置文件。
* auto目录: 存放大量的脚本文件，和configure脚本程序相关。
* configure文件: Nginx自动安装脚本，用于环境检查，生成编译代码需要的makefile文件。
* CHANGES,CHANGES.ru,LICENSE和README都是Nginx服务器的相关资料。

### 编译安装nginx
```
yum -y install pcre-devel openssl-devel zlib-devel
```
```
cd nginx-1.10.1

./configure \
--prefix=/usr/local/nginx \
--with-http_ssl_module

make && make install
```
### nginx启动与停止
```
cd /usr/local/nginx/sbin
./nginx
ps -aux | grep nginx
./nginx -s top  //立即停止
./nginx -s quit //从容停止
kill nginx 主进程pid
killall nginx
```

|命令|说明|
|:-:|:-:|
|nginx -s reload|在nginx已经启动的情况下重新加载配置文件(平滑重启)|
|nginx -s reopen|重新打开日志文件|
|nginx -c /xxx/nginx.conf|以特定目录下的配置文件启动nginx|
|nginx -t|检查当前配置文件是否正确|
|nginx -t /xxx/nginx.conf|检查特定的nginx配置文件是否正确|
|nginx -v|显示版本信息|
|nginx -V|显示版本信息和编译选项|

### 其它
端口号查看
```
netstat -tlnp
```

创建软连接后可在任意目录下使用nginx
```
echo  $PATH
ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx  
```
添加系统服务 
```
vi /etc/init.d/nginx
```
```shell
#! /bin/bash
DAEMON=/usr/local/nginx/sbin/nginx
case "$1" in
    start)
        echo "Starting nginx daemon..."
        $DAEMON && echo "SUCCESS"
    ;;
    stop)
        echo "Stoping nginx daemon..."
        $DAEMON -s quit && echo "SUCCESS"
    ;;
    reload)
        echo "Starting nginx daemon..."
        $DAEMON -s reload && echo "SUCCESS"
    ;;
    restart)
        echo "Starting nginx daemon..."
        $DAEMON -s quit
        $DAEMON && echo "SUCCESS"
    ;;
    *)
        echo "Usage:service nginx(start|stop|restart|reload)"
        exit 2
    ;;
esac
```
```
chmod +x /etc/init.d/nginx
```
设置开机自启

在/etc/init.d/nginx中添加
```
#chkconfig: 35 85 15
```
```
chkconfig --add nginx
```
## Nginx配置
### 配置文件nginx.conf
```
main
events {...}
http{
    server {
        location{ ... }
    }
}
```

|块|说明|
|:-:|:-:|
|main|主要控制nginx子进程所属的用户和用户组，派生子进程数，错误日志位置与级别，pid位置，子进程优先级，进程对应CPU，进程能够打开的文件描述符数目等。|
|events|控制nginx处理🔗的方式|
|http|nginx处理http请求的主要配置块，大多数配置都在这里进行|
|server|nginx中主机的配置块，可用于配置多个虚拟主机|
|location|server中对应目录级别的控制块，可以有多个|

**默认配置指令**

|指令|说明|
|:-:|:-:|
|worker_processes|配置nginx的工作进程数，一般设置为cpu总核数或者总核数的两倍|
|worker_connections|配置nginx允许单个进程并发连接的最大请求数|
|include|用于引入配置文件|
|default_type|设置默认文件类型|
|sendfile|默认值位on，表示开启高效文件传输模式|
|keepalive_timeout|设置长连接超时时间(单位:秒)|
|listen|监听端口，默认监听80端口|
|server_name|设置主机域名|
|root|设置主机站点根目录地址|
|index|设置默认索引文件|
|error_page|自定义错误页面|

### 访问控制

### 日志文件
#### 访问日志
/usr/local/nginx/logs

```
log_format main 'xxxx'

access_log logs/access.log main;

access_log off; //关闭日志
```

|内置变量|含义|
|:-:|:-:|
|$remote_addr|客户端ip地址|
|$remote_usr|客户端用户名|
|$time_local|访问时的服务器时区|
|$request|请求的url和http协议|
|$status|记录请求返回的http状态码|
|$body_bytes_sent|发送给客户端的文件主体内容的大小|
|$http_referer|来路url地址|
|$http_user_agent|客户端浏览器信息|
|$http_x_forwarded_for|客户端ip地址列表(包括中间经过的代理)|

#### 错误日志
nginx.conf文件的error_log默认配置
```
error_log logs/error.log

error_log logs/error.log notice;

error_log logs/error.log info;

error_log /dev/null;
```
#### 日志文件切割
##### 手动切割
```
mv access.log 201xxxx.log
nginx -s reopen
```
##### 自动切割
编写autolog.sh
```
#！/bin/bash

logs_path = "/usr/local/nginx/logs/xxx"

mv $logs_path/access.log $logs_path/'date+"%Y%m%d%H%M"'.log

/usr/local/nginx/sbin/nginx -s reopen


chmod +x autolog.sh

crontab -e

0 0 * * * /usr/local/nginx/logs/xxx/autolog.sh > /dev/null 2>&1
```
### 虚拟主机
#### 基于端口配置虚拟主机
```
server{
    listen 8001;
    server_name 192.168.78.3;
    root html/html8001;
    index index.html index.htm;
}
server{
    listen 8002;
    server_name 192.168.78.3;
    root html/html8002;
    index index.html index.htm;
}
```
#### 基于ip配置nginx虚拟主机
```
cd /etc/sysconfig/network-scripts/
vim xxx
DEVICE = 
IPADDR = 
```
```
server{
    listen 80;
    server_name 192.168.78.3;
    root html/192.168.78.3;
    index index.html index.htm;
}
server{
    listen 80;
    server_name 192.168.78.4;
    root html/192.168.78.4;
    index index.html index.htm;
}
```
#### 基于域名配置虚拟主机
```
vim /etc/hosts
127.0.0.1 www.ng.test
127.0.0.1 ng.test
```
```
server{
    listen 80;
    server_name *.ng.test
    root html/www.ng.test
    index index.html index.htm;
}
```
### 设置目录列表
Nginx默认不允许列出整个目录。如果该站点目录下没有指定的文件，会报403错误。当开启目录列表功能后，上述情况不会报错，可以让该站点或目录下的文件以列表的形式展示。开启配置指令：```autoindex on;```。

上述指令在http块中，表示对所有站点有效；在server块中，对指定站点有效。在location块中，表示对某个目录有用。
```
autoindex_exact_size off;   //以kB/MB/GB为单位显示文件大小
autoindex_localtime;        //显示文件的服务器时间
```
### 子配置文件引入
```
mkdir /usr/local/nginx/conf/vhost
cd vhost
touch www.ng.text.conf
vi www.ng.text.conf
server{
    xxxx;
}
```
```
include vhost/www.ng.test.conf;
include vhost/*.conf;
```
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
## 负载均衡与缓存
### 反向代理
#### 反向代理与正向代理的区别
正向代理:客户端将发送的请求和指定的目标服务器发送给代理服务器，代理服务器向目标服务器发起请求，并将获得的响应结果返回给客户端的过程。

反向代理:反向代理对于客户端来说就是目标服务器，客户端向反向代理服务器发送请求后，反向代理服务器将该请求转发给内部网络上的后端服务器，并将后端服务器上得到的响应结果返回给客户端。

在nginx配置文件中，proxy_pass指令通常在location块中进行设置。
```
server{
    listen 80;
    server_name test.ng.test;
    location / {
        proxy_pass http://192.168.78.128;
    }
}

server{
    listen 80;
    server_name test.web.com;
    location / {
        proxy_pass http://192.168.78.200;
    }
}
```

|指令|说明|
|:-:|:-:|
|proxy_set_header|在讲客户端请求发送给后端服务器之前，更改来自客户端的请求头信息|
|proxy_connect_timeout|配置nginx与后端代理服务器尝试建立连接的超时时间|
|proxy_read_timeout|配置nginx向后端服务器组发出read请求后，等待响应的超时时间|
|proxy_send_timeout|配置nginx向后端服务器组发出write请求后，等待响应的超时时间|
|proxy_redirect|用于修改后端服务器返回的响应头中的location和refresh|

### 负载均衡
### 缓存配置
### 邮件服务

## 模块配置与应用
### 模块概述
### 调试输出
### 响应状态相关
### 网页压缩
### 重写与重定向
### 防盗链配置
### 配置https网站

## 高可用负载均衡集群
### nginx配置优化
### lnmp分布式集群
### nginx+keepalived高可用方案
