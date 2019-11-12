# tmux基本技巧

## 会话session

###创建一个tmux的会话

```
tmux
tmux new -s name
```

###退出tmux会话

```
#后台运行
tmux attach
ctrl+b d
#退出不后台运行
exit
```

###列出所有的tmux会话

```
tmux ls
tmux list-sessions
```

###装载一个会话

```
tmux attach
tmux attach -t name
```

###销毁一个会话

```
tmux kill-session -t name
```

##窗口windows

### 创建一个新窗口

```
crtl+b c
```

### 窗口间切换

```
ctrl+b n(next的意思)
ctrl+b p(previous)
ctrl+b 0/1/2...
```

### 关闭窗口

```
exit
ctrl+b &
```

##面板pane

####（均在按下ctrl+b之后松开，然后按下相应的按键）

```
?	显示快捷键帮助
"	纵向分割窗口（上下二分）
% 横向分割窗口(左右二分)
o 跳转到下一个分割窗口
上下方向键  上一个及下一个分割窗口
crtl+b X(大写)
exit
crtl+b :命令模式
```

