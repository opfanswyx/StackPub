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
    index index.html index.htm;jmnjnkhnb   
}
server{

}
```
#### 基于ip配置nginx虚拟主机

#### 基于域名配置虚拟主机

### 设置目录列表

### 自配置文件引入

## Web服务搭建
### nginx+php
### nginx+apache
### openresty


## 负载均衡与缓存
### 反向代理
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
