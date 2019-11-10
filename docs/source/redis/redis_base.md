## Redis源码安装
```
git clone --branch 2.8 --depth 1 git@github.com:antirez/redis.git
cd redis
make
cd src
./redis-server --daemonzie yes
./redis-cli
```

redis命令参考:

[redis命令](http://redisdoc.com/)