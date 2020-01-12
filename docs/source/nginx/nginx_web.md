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
通常将Nginx分为5大模块：核心模块，标准http模块，可选http模块，邮件服务模块和第三方模块。

查看nginx默认加载的核心模块和标准http模块：
```
# cd ~/nginx-1.10.1/objs
# less ngx_modules.c
```

```c
extern ngx_module_t ngx_core_module;
extern ngx_module_t ngx_errlog_module;
extern ngx_module_t ngx_conf_module;
extern ngx_module_t ngx_openssl_module;
extern ngx_module_t ngx_regex_module;
extern ngx_module_t ngx_events_module;
extern ngx_module_t ngx_event_core_module;
extern ngx_module_t ngx_epoll_module;
...
```
### 调试输出
配置文件的调试可使用```echo-nginx-module```第三方模块。
```
wget https://github.com/openresty/echo-nginx-module/archive/v0.60.tar.gz
tar -zxvf v0.60.tar.gz
mv echo-nginx-module-0.60 echo-nginx-module
```
```
nginx -v //查看当前nginx版本及其编译选项

cd nginx-1.10.1
./configure \
--prefix=/usr/local/nginx \
--with-http_ssl_module \
--add-module=/root/echo-nginx-module

make

cd objs
mv /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx.bak
cp nginx /usr/local/nginx/sbin/nginx
```
```
location / {
    root html;
    index index.html index.htm
    default_type text/plain;
    echo "This is an echo module";aw
}
```
### 响应状态相关
安装```ngx_http_stub_status_module```和```ngx_http_sub_module```模块。

```
--with-http_stub_status_module \
--with-http_sub_module
```

```
server{
    listen 80;
    server_name www.test.com;
    root html/test.com;
    index index.html index.htm;
    stub_status;
}

sub_filter aaa 'bbb';   //把aaa替换为bbb
sub_filter_once on;     //默认替换一次
sub_filter_once off;    //替换全部
```
### 网页压缩
Nginx服务器为网页压缩专门提供了gzip模块，并且模块中的相关指令均可以设置在http,server或location块中，实现服务器端安装指定的设置进行压缩。

|指令|说明|
|:-:|:-:|
|gzip|开启或关闭gzip模块|
|gzip_buffers|设置系统获取几个单位的缓存用于存储gzip的压缩结果数据流|
|gzip_comp_level|gzip的压缩比，压缩级别是1-9，1最低9最高，压缩级别越高压缩率越大，压缩时间越长|
|gzip_disable|对一些特定的User-Agent不实用压缩功能|
|gzip_min_length|设置允许压缩页面的最小字数，页面字节数从响应消息头的Content-Length中进行获取|
|gzip_http_version|识别http协议版本，其值可以是1.1(默认)或1.0|
|gzip_proxied|用于设置启用或禁用从服务器上收到响应内容的gzip压缩功能|
|gzip_types|匹配MIME类型进行压缩。且无论是否指定，text/html类型总是会被压缩的|
|gzip_vary|用于在响应消息头中添加Vary:Accept-Encoding，使代理服务器根据请求头中的Accept-Encoding识别是否启用gzip压缩|

用于客户端访问网页时，对文本，javascript和css文件进行压缩输出。
```
http{
    ...
    gzip on;
    gzip_types text/plain application/javascript text/css;
    ...
}

gzip_buffers 4 16k;     //表示原始数据大小以16K为单位的4倍申请内存。
gzip_comp_level 4;
gzip_disable "MSIE[1-6].";
gzip_min_length 5k;
gzip_http_version 1.0;
gzip_proxied any;
gazip_vary on;
```

Nginx作为反向代理时，gzip_proxied指令的常用参数值如下

|指令|说明|
|:-:|:-:|
|any|无条件压缩所有响应数据|
|off|关闭反向代理的压缩|
|expired|如果消息头中包含Expires则启用压缩|
|no-cache|如果消息头中包含Cache-Control:no-cache则启用压缩|
|no-store|如果消息头中包含cache-control:no-store则启用压缩|
|private|如果消息头中包含cache-control:private则启用压缩|
|no_last_modified|如果消息头中不包含Last-Modified则启用压缩|
|no_etag|如果消息头中不包含ETag则启用压缩|
|auth|如果消息头中不包含Authorization头信息则启用压缩|

### 重写与重定向

```
resrite regex replacement [flag];
```

|参数值|说明|
|:-:|:-:|
|last|终止rewrite，继续匹配其他规则|
|break|终止rewrite，不在继续匹配|
|redirect|临时重定向，返回的http状态码为302|
|permanent|永久重定向，饭后http状态码为301|

当flag的值为last或break时，表示当前的设置为 **重写**，当flag的值为redirect或permanent时表示**重定向**。

```
server{
    listen 80;
    server_name test.ng.test;
    index index.html index.htm;
    root html;
    if(!-e $request_filename){
        rewrite "^/.*" /default/default.html break;
    }
}
```

|判断符号|说明|判断符号|说明|
|:-:|:-|:-:|:-|
|=|判断变量是否相等|!=|判断变量是否不想等|
|~|判断大小写正则匹配|～*|不区分大小写正则匹配|
|!~|区分大小写正则不匹配|!~*|不区分大小写正则不匹配|
|-f|判断文件是否存在|!-f|判断文件不存在|
|-d|判断目录是否存在|!-d|判断目录不存在|
|-e|判断文件或者目录存在|!-e|判断文件或者目录不存在|
|-x|判断可执行文件|!-x|判断不可执行文件|

```
server{
    listen 80;
    server_name test.ng.test;
    root html;
    location /break/{
        rewrite ^/break/(.*)/test/$1 break;
        echo "break page";
    }
    location /last/{
        rewrite ^/last/(.*)/test/$1 last;
        echo "last page";
    }
    location /test/{
        echo "test page";
    }
}
```
rewrite的重定向就是将用户访问的url修改为重定向的地址，只需将flag的可选参数设置为redirect或permanent即可实现。
```
server{
    listen 80;
    server_name test.ng.test;
    root html;
    set $name $1;
    rewrite ^/img-([0-9]+)\.jpg$/img/$name.jpg permanent;
}
```
上述示例中，利用set指令为变量$name赋值，$s1表示符合正则表达式第一个子模式的值。

**redirect**返回http状态码是302(临时重定向)，使得搜索引擎在抓取新内容的同时保留旧的网址。**permanent**饭后的http状态码是301(永久重定向)，会让搜索引擎在抓取新内容的同时也将旧的网址永久替换为重定向之后的网址。

### 防盗链配

http请求消息中的referer字段，用于保存当前网页的来源url地址。当用户打开一个含有图片内容的网页时，浏览器会在图片的请求消息中将网页的url放在referer中，从而使图片所在的服务器能够追踪它被显示的网页地址。

```
server{
    listen 80;
    server_name www.ng.test;
    root html/ng.test;
    index index.html index.htm;
}

server{
    listen 80;
    server_name www.test.com;
    root html/test.com;
    index index.html index.htm;
}
```

```
<h1>welcome to www.ng.test!</h1>
<img src="img/2.jpg" width="200" />
```

```
<h1>welcome to www.test.com!</h1>
<img src="http://www.ng.test/img/2.jpg" width="200" />
```

```
server{
    listen 80;
    server_name www.ng.test;
    root html/ng.test;
    index index.html index.htm;

    location ~* \.(gif|jpg|png|swf|flv)${
        valid_referers www.ng.test ng.test;
        if($invalid_referer){
            return 403;
        }
    }
}
```

|参数值|说明|
|:-:|:-|
|none|匹配没有referer的http请求，如valid_referers none;|
|blocked|匹配http请求中含有referer,但是被防火墙或者代理服务器修改，去掉了https://或http://的情况，如valid_referers blocked;|
|server_names|允许文件资源链出的域名白名单，如valid_referers www.ng.test ng.test;|
|string|任意的字符串，如valid_referers \*.ng.test ng.\*;|
|regular expression|正则表达式，如valid_referers ~\.img\.;|

图片防盗链如果只根据referer进行验证，这种方式存在伪造referer的问题。而对于图片之外的下载资源，如果不需要考虑资源链接的长期有效性，可以使用nginx提供的secure_link和secure_link_md5指令来实现下载地址的加密和时效性。

下载防盗链的实现原理就是在服务器端根据特定规则对下载地址进行加密，并在用户请求下载链接时，验证加密链接是否有效，防止用户伪造下载链接。同时，为了避免加密后的链接被盗链，在加密时添加过期时间，使得下载地址只在一定时间内有效，过期后只能到原网站获取新的地址。

1.重新编译nginx,然后重新生成nginx的二进制可执行文件，替换掉nginx安装目录中的可执行文件/usr/local/nginx/sbin/nginx即可。
```
--with-http_secure_link_module
```
2.创建php文件cdown.php，用于生成加密的下载链接
```php
<?php
$secret='ng.test';      //自定义密钥
$path='/down/web/nginx-1.10.1.tar.gz';  //下载文件路径
$expire=time()+60;  //生成过期时间，60表示60秒
//用文件路径，密钥，过期时间生成加密串
$md5=base64_encode(md5($secret.$path.$expire, true));   
$md5=strtr($md5,'+/','-_');
$md5=str_replace('=','',$md5);
//生成加密后的下载链接
echo '<a href="http://www.ng.test/down/web/nginx-1.10.1.tar.gz?st='.$md5.'&e='.expire.'">nginx-1.10.1</a>'
//输出加密后的下载地址
echo '<br>http://www.ng.test/down/web/nginx-1.10.1.tar.gz?st='.$md5.'&e='.$expire;
?>
```
3.修改nginx配置文件
```
location / {
    secure_link $arg_st,$arg_e;
    secure_link_md5 ng.test$uri$arg_e;
    if($secure_link=""){
        return 403;     #处理加密串不等的情况
    }
    if($secure_link="0"){
        return 403;     #加密串相等时，处理下载链接过期的情况
    }
}
```
### 配置https   
**HTTPS**(Hypertext Transfer Protocol Secure)超文本传输安全协议是HTTP(超文本传输协议)，SSL(Secure Sockets Layer)安全套接层和TLS(Transport Layer Security)传输安全的组合，用于提供加密通信和鉴定网络服务器的身份。

要想实现HTTPS加密网站，在服务器端首先要获得CA(CertificationAuthority)认证机构颁发的服务器数字证书(CRT)。Nginx服务器中的ngx_http_ssl_module模块用于提供HTTPS网站的配置。

OpenSSL是一个非常强大的安全套接字层密码库，它包含了主要的密码算法，常用的密钥，证书封装管理以及SSL协议，证书签发等多种功能。其中，OpenSSL程序是由3部分组成的，分别为openssl命令行工具，libcrypto公共加密库和libssl实现SSL协议。


1.生成服务器的RSA私钥
```
mkdir /usr/local/nginx/conf/ssl
cd /usr/local/nginx/conf/ssl
openssl genrsa -out server.key 2048
```

|参数|说明|
|:-:|:-|
|genrsa|表示用于生成RSA私钥|
|out server.key|表示输出的文件名为server.key，文件所在目录为执行当前openssl命令时所在目录|
|2048|密钥长度为2048(长度越长，安全性越强)|

2.生成服务器的CSR证书请求文件
CSR证书请求文件是服务端的公钥，用于提交给CA机构进行签名。
```
openssl req-new-key server.key -out server.csr
```

|参数|说明|
|:-:|:-|
|Country Name(2 letter code)|符合ISO的2个字母的国家代码，如中国CN|
|State or Province Name(full name)|省份，如Beijing|
|Locality Name|城市|
|Organization Name|公司名称|
|Organizational Unit|组织单位|
|Common Name|使用SSL加密的网站域名|
|Email Address|邮箱地址|
|A challenge password|有些CA机构需要密码，通常省略|
|An optional company name|可选公司名称|

在填写信息时要删除字符时，通过ctrl+backspace键进行操作。

3.CA为服务器认证证书
```
openssl x509 -req-days 30 \
-in server.csr -signkey server.key -out server.crt
```
4.配置HTTPS网站
```
server{
    listen 443;
    server_name www.test.com;
    root html/test.com;
    ssl on;
    ssl_certificate         /usr/local/nginx/conf/ssl/server.crt;
    ssl_certificate_key     /usrlocal/nginx/conf/ssl/server.key;
}
```