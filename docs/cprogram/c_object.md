## 模块化
朴素的栈实现例子：
```c
#ifndef _STACK_H_
#define _STACK_H_

bool push(int val);
bool pop(int *pRet);
#endif
```
```c
#include<stdbool.h>
#include "stack.h"

int buf[16];
int top = 0;

bool isStackFull(void){
    return top == sizeof(buf) / sizeof(int);
}

bool isStackEmpty(void){
    return top == 0;
}

bool push(int iVal){
    if(isStackFull())
        return false;
    buf[top++] = val;
    return true;
}

bool pop(int *pRet){
    if(isStackEmpty())
        return false;
    *pRet = buf[--top];
    return true;
}
```
问题1:

查看stack.h发现，push(),pop()都被公开在全局命名空间中。

答:在函数名和变量名前指定static修饰符，使函数和变量只在该编译单位内部有效，可以有效避免名字冲突。

问题2:

以上实现方法仅有一个栈，如果需要多种类型的栈，该如何处理？

答：```使用结构体将数据结构与代码块分离```

## 使用结构体将数据结构与代码块分离
可持有多个栈的例子：
```c
#ifndef _STACK_H_
#define _STACK_H_

#include<stddef.h>

#ifdef __cplusplus
extern "C"{
#endif

typedef struct{
    int top;
    const size_t size;
    int * const pBuf;
}Stack;

bool push(Stack *p, int iVal);
bool Pop(Stack *p, int *pRet);

#define newStack(buf){                      \
    0, sizeof(buf) / sizeof(int), (buf)     \ 
}

#ifdef __cplusplus
}
#endif

#endif
```

```c
#include<stdbool.h>
#include "stack.h"

static bool isStackFull(const Stack *p){
    return p->top == p->size;
}

static bool isStackEmpty(const Stack *p){
    return p->top == 0;
}

bool push(Stack *p, int iVal){
    if(isStackFull(p))
        return false;
    p->pBuf[p->top++] = iVal;
    return true;
}

bool pop(Stack *p, int *pRet){
    if(isStackEmpty(p))
        return false;
    *pRet = p->pBuf[--p->top];
    return true;
}


int buf[16];
Stack stack = newStack(buf);
Stack stack = {0, sizeof(buf) / sizeof(int), (buf)};
```
## C与面向对象

## 面向对象与多态性

## 继承

## 封装

## 虚函数表

## 非虚函数