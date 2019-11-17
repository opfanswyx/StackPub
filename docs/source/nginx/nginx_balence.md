
## 反向代理
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

## 负载均衡
nginx不仅可以作为一个web服务器或反向代理服务器，还可以按照权重，轮询，ip hash，URL hash等多种方式实现对后端服务器的负载均衡。

负载均衡(load balance)就是将负载分摊到多个操作单元上执行。nginx使用```upstream```指令实现负载均衡。

|配置方式|说明|
|:-:|:-|
|轮询方式|默认方式，每个请求按照时间顺序逐一分配到不同的后端服务器进行处理，如有宕机自动剔除。|
|权重方式|利用weight指定轮询的权重比率，与访问率成正比，用于后端服务器性能不均的情况。|
|ip_hash方式|每个请求按访问ip的hash结果分配，这样可以使每个访问固定一个后端服务器，可以解决session共享问题。|
|第三方模块|第三方模块采用fair时，按照每台服务器的响应时间来分配请求，响应时间短的优先分配，当第三方模块采用url_hash时，按照访问url的hash值来分配请求。|

### 一般轮询
```
#配置域名为test.ng.test的虚拟主机
server{
    listen 80;
    server_name test.ng.test;
    location / {
        proxy_pass http://web_server;
    }
}
#配置负载均衡服务器组
upstream web_server{
    server 192.168.78.100;
    server 192.168.78.101;

}
```
### 加权轮询
```
upstream web_server{
    server 192.168.78.100 weight=1 max_fails=1 fail_timeout=2;
    server 192.168.78.101 weight=2 max_fails=3 fail_timeot=3;
    server 192.168.78.102 backup;
}
```

|配置方式|说明|
|:-:|:-|
|max_fails|允许请求失败的次数，默认为1。当超过最大次数时，返回proxy_next_upstream指令定义的错误。|
|fail_timeout|经历max_fails失败后，暂停服务的时间。且在实际应用中max_fails一般与fail_timeout一起使用。|
|backup|预留的备份机器。|
|down|表示当前server不参与负载均衡|

### ip_hash
```
upstream web_server{
    ip_hash;
    server 192.168.78.100;
    server 192.168.78.101;
    server 192.168.78.102;
    server 192.168.78.103 down;
}
```
### 第三方模块
fair方式(web服务器响应时间)

* 备份以安装的nginx。```cp -r /usr/local/nginx /usr/local/nginx_old```
* 重新编译安装nginx。
```
unzip nginx-upstream-fair-mastre.zip
mv nginx-upstream-fair-master nginx-upstream-fair

cd nginx-1.10.1
./configure \
--prefix=/usr/local/nginx \
--with-http_ssl_module \
--add-module=/root/nginx-upstram-fair

make && make install
```
* 配置fair负载均衡
```
server{
    listen 80;
    server_name test.ng.test;
    location / {
        proxy_pass http://web_server;
    }
}

upstream web_server{
    server 192.168.78.100;
    server 192.168.78.102;
    fair;
}
```

## 缓存配置
利用反向代理服务对访问频率较多的内容进行缓存，有利于节省后端服务器资源。nginx提供两种web缓存方式:永久性缓存与临时性缓存。

### 永久性缓存配置
```
server{
    listen 80;
    server_name 192.168.78.3;
    location / {
        root cache; #nginx的cache目录
        proxy_store on;
        proxy_store_access user:rw group:rw all:r;
        proxy_temp_path cache_tmp;
        if(!-e $request_filename){
            proxy_pass http://192.168.78.100;
        }
    }
}
```
### 临时性缓存配置
nginx使用proxy_cache指令设置临时缓存，采用md5算法将请求连接进行哈希(hash)后，更具配置生成缓存文件目录。

1) 在nginx.conf的http块中添加:
```
#代理缓存内容源的临时目录
proxy_temp_path /usr/local/nginx/proxy_temp_dir;
proxy_cache_path /usr/local/nginx/proxy_cache_dir \
levels=1:2 keys_zone=cache_one:50m inactive=1m max_size=500m;
```

proxy_cache_path：

* /usrlocal/nginx/proxy_cache_dir参数: 表示用户自定义的缓存文件保存目录。
* levels参数:表示缓存目录下的层级目录结构，它是根据哈希后的请求url地址创建的，目录名称从哈希后的字符串结尾开始截取。</br>
假设哈希后的url地址为ad70998a15e...ce0 ,则levels=1:2表示，第一层子目录的名称是长度为1的字符0,第二层子目录的名称是长度为2的字符ce。
* keys_zone参数:指定缓存区名称及长度。例如cache_one:50m表示缓存区名称为cache_one，在内存中的空间是50MB。
* inactive参数:表示主动清空在指定时间内未被访问的缓存。1m表示清空在1分钟内未被访问过的缓存(1h,1d)。
* max_size:表示指定磁盘空间大小(500m,10g)。

2) 在server块中添加临时缓存配置
```
server{
    listen 80;
    server_name test.nd.test;
    #增加两个响应头信息，用于获取访问的服务器地址与缓存是否成功。
    add_header X-Via $server_addr;
    add_header X-Cache $upstream_cache_status;
    location / {
        #设置缓存区域名称
        proxy_cache cache_one;
        #以域名，uri，参数组合成web缓存的key值，nginx根据key值哈希
        proxy_cache_key $host$uri$is_args$args;  #is_args有参数时为？否则为空
        #对不同的http状态码设置不同的缓存时间
        proxy_cache_valid 200 10m; #200缓存10分钟
        proxy_cache_valid 304 1m;
        proxy_cache_valid 301 302 1h;
        proxy_cache_valid any 1m;   #其余未设置的状态码缓存1m
        #设置反向代理
        proxy_pass http://192.168.78.128;
    }
}
```
X-Via表示服务器地址，利用内置变量\$server_addr获取，另一个X-Cache表示缓存资源状态，利用内置变量\$upstream_cache_status获取。\$upstream_cache_status的返回值:HIT,MISS,EXPIRED,UPDATING,STALE,BYPASS,REVALIDATED。

|指令|说明|
|:-:|:-|
|proxy_cache_bypass|用于配置nginx向客户端发送响应数据时，不从缓存中获取条件。|
|proxy_cache_lock|用于设置是否开启缓存的锁🔒功能。|
|proxy_cache_lock_timeout|用于设置缓存的🔒功能开启以后的超时时间。|
|proxy_no_cache|配置在什么情况下不使用缓存功能|
|proxy_cache_min_uses|当同一个url被重复请求达到指定的次数后，才对该url进行缓存|
|proxy_cache_revalidate|用于当缓存内容过期时，nginx通过一次if-modified-since的请求头去验证缓存内容是否过期。|
|proxy_cahce_use_stale|设置状态，用于内容源web服务器处于这些状态时，nginx向客户端响应历史缓存数据。|

### 缓存清理配置
目前nginx提供缓存相关指令不支持清理url的缓存，需要借助第三方模块。

ngx_cache_purge模块下载地址:https://github.com/FRiCKLE/ngx_cache_purge_releases 。
```
cp -r /usr/local/nginx /usr/local/nginx_old2
unzip ngx_cache_pure-master.zip
mv ngx_cache_purge-master /usr/local/ngx_cache_purge
```
```
cd nginx-1.10.1
./configure \
--prefix=/usr/local/nginx \ 
--with-http_ssl_module \ 
--add-module=/usr/local/ngx_cache_purge

make && make install
```

```
location ~/purge(/.*){
    allow 192.168.78.1;
    deny all;
    proxy_cache_purge cache_one$host$1$is_args$args;
}
```
\$1表示location正则表达式中的子模式(/.*)的匹配结果，对应生成缓存key时的\$uri。

## 邮件服务

略。