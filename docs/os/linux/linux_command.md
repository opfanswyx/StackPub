## 文件操作命令
```
cp -R 递归处理，将当前目录下的文件及子目录一并处理
cp -p 复制的同时不修改文件属性，包括所有者，所属组，权限和时间
cp -f 强制复制文件或目录，无论目的文件或目录是否已经存在
```

**more**

|快捷键|说明|
|:-:|:-:|
|f/Space|显示下一页|
|Enter|显示下一行|
|q/Q|退出|

```
head -n filename  查看文件的前n行

tail -n filename  查看文件的后n行
```
### 文件🔍搜索命令
```
which/whereis 可以查看linux命令所在的目录，which能找到命令的别名，
whereis同时展示命令帮助文档所在的路径。

find (-name|-size|-user) 更具文件名/文件大小/文件所有者查找
find /etc -name passwd

locate locate与find -name相同，速度更快，locate在/var/lib/locatedb
中查找，updatedb更新。

grep 用于在文件中搜索与字符串匹配的行并输出。 grep root /etc/services
```

```
netstat -a      所有端口
netstat -at     所有tcp端口
netstat -au     所有udp端口
```
