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
### 配置https网站

## 缓存配置
## 邮件服务

