## 我的VIM配置
配置文件链接：https://github.com/opfanswyx/Atticus_Vim

使用方法步骤：

1. 将下载文件夹里的.vimrc替代~/.vimrc(如果存在替换，不存在直接放进去)
2. 分别解压taglist和winmanager都会得到doc和plugin两个文件夹
3. 切换到~目录下查看是否存在.vim文件夹，如果存在则进入目录，不存在则创建.vim(mkdir .vim and cd .vim)
4. 进入.vim目录创建doc与plugin目录
5. 拷贝解压的doc与piugin里的文件到对应的~/.vim/下的doc与plugin目录里

### 常用技巧
1. i插入，在光标前插入
2. x删除当前光标所在的字符
3. dd删除并保持剪贴板，2dd删除2行
4. p黏贴 3p
5. hjkl左下右上
6. 数字0到行头
7. ^到本行第一个不是blank(空格，tab，换行，回车)字符
8. $到本行行尾
9. g_本行最后一个不是blank字符位置
10. /pattern 搜索出字符多个匹配，按n到下一个
11. yy拷贝当前行，相当于ddp
12. u撤销
13. <C-r>反撤销
14. .重复上一次命令 3.重复三次
15. NG到第N行 ：N如：137
16. gg到第一行
17. G到最后一行
18. <C-v>块操作<C-d>hjkl =自动缩进<>左右缩进
19. <C-p><C-n>自动补全

### VIM大冒险
下面这个游戏是一个使用VIM热键玩的游戏。可以在玩游戏的过程中熟悉Vim的热键。

点击链接开始游戏：https://vim-adventures.com/