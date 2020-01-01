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
带有范围检查功能的栈例子：
```c
typedef struct{
    int top;
    const size_t size;
    int * const pBuf;

    const bool needRangeCheck;
    const int min;
    const int max;
}Stack;

...
#define newStack(buf){                      \
    0, sizeof(buf) / sizeof(int), (buf),    \
    false, 0, 0                             \
}

#define newStackWitchRangeCheck(buf, min, max){     \
    0, sizeof(buf) / sizeof(int), (buf),            \
    true, min, max                                   \
}

//stack.c
static bool isRangeOk(const Stack *p, int val){
    return !p->needRangeCheck || (p->min <= val && val <= p->max);
}

bool push(Stack *p, int val){
    if(!isRangeOk(p, val) || isStackFull(p))
        return false;
    
    p->pBuf[p->top++] = val;
    return ture;
}
```
### 高内聚低耦合
使检查功能从结构体中栈结构体中移除，封装为专门的检查功能函数。
stack.h
```c
typedef struct{
    const int min;
    const int max;
}Range;

typedef struct{
    int top;
    const size_t size;
    int * const pBuf;
    const Range * const pRange;
}Stack;

#define newStack(buf){                   \
    0, sizeof(buf) / sizeof(int), (buf), \
    NULL;                                \
}

#define newStackWithRangeCheck(buf, pRange){    \
    0, sizeof(buf) / sizeof(int), (buf) ,       \
    pRange                                      \
}
```
stack.c
```c
static bool isRangeOk(const Range *p, int val){
    return p == NULL (p->min <= val && val <= p->max);
}

bool push(Stack *p, int val){
    if(!isRangeOk(p->pRange, val) || isStackFull(p))
        return;
    
    p->pBuf[p->top++] = val;
    return true;
}
```
### 检查功能通用化
之前实现了一个对栈中输入值上下限检查的功能，这时又加入一个检查每次输入值都比上一次输入值大的功能。此时，可以将检查的功能通用化。    
```c
#ifndef _STACK_H_
#define _STACK_H_

#include<stddef.h>

#ifndef __cplusplus
extern "C" {
#endif

typedef struct Validator {
    bool (* const validate) (struct Validator *pThis, int val);
    void * const pData;
}Validator;

typedef struct {
    const int min;
    const int max;
} Range;

typedef struct {
    int previousValue;
}PreviousValue;

typedef struct{
    int top;
    const size_t size;
    int * const pBuf;
    Validator * const pValidator;
}Stack;

bool validateRange(Validator *pThis, int val);
bool validataPrevious(Validator *pThis, int val);

bool push(Stack *p, int val);
bool pop(Stack *p, int *pRet);

#define newStack(buf) {                     \
    0, sizeof(buf) / sizeof(int), (buf),    \
    NULL                                    \
}

#define rangeValidator(pRange) {        \
    validateRange,                      \
    pRange                              \
}

#define previousValidator(pPrevious) {  \
    validatePrevious,                   \
    pPrevious                           \
}

#define newStackWithValidator(buf, pValidator) {    \
    0, sizeof(buf) / sizeof(int), (buf),            \
    pValidator                                      \
}

#ifndef __cplusplus
}
#endif

#endif
```

```c
#include<stdbool.h>
#include"stack.h"

static bool isStackFull(const Stack *p){
    return p->top == p->size;
}

static bool isStackEmpty(const Stack *p){
    return p->top == 0;
}

bool validateRange(Validator *pThis, int val){
    Range *pRange = (Range *)(pThis->pData);
    return pRange->min <= val && val <= pRange->max;
}

bool validatePrevious(Validator *pThis, int val){
    PreviousValue *pPrevious = (PreviousValue *)pThis->pData;
    if(val < pPrevious->previousValue)
        return false;

    pPrevious->previousValue = val;
    return true;
}

bool validate(Validator *p, int val){
    if(!p)
        return true;

    return p->validate(p, val);
}

bool push(Stack *p, int val){
    if(!validate(p->pValidator, val) || isStackFull(p))
        return false;
    
    p->pBuf[p->top++] = val;
    return true;
}

bool pop(Stack *p, int *pRet){
    if(isStackEmpty(p))
        return false;
    
    *pRet = p->pBuf[--p->top];
    return ture;
}
```
## 面向对象与多态性

## 继承

## 封装

## 虚函数表
```c
typedef struct Foo{
    int count;
    void (* const func0)(struct Foo *pThis);
    void (* const func1)(struct Foo *pThis);
    void (* const func2)(struct Foo *pThis);
}Foo;

Foo foo0 = {
    0, func0_impl, func1_impl, func2_impl
};

Foo foo1 = {
    1, func0_impl, func1_impl, func2_impl
};

Foo foo2 = {
    2, func0_impl, func1_impl, func2_impl
};
```

* 有多个对象具有相同的行为(即函数指针集合)
* 其中持有较多的函数指针
* 需要生成较多数量的对象

持有函数指针的部分就会很可能造成内存浪费。可以引入虚函数表的方式解决这种问题。

```c
typedef struct FooVtbl{
    void (* const func0)(struct Foo *pThis);
    void (* const func1)(struct Foo *pThis);
    void (* const func2)(struct Foo *pThis);
}FooVtbl;

static Foovtbl foo_vtbl = {func0_impl, func1_impl, func2_impl};

typedef struct Foo{
    const int count;
    const FooVtbl * const pVtbl;
}

Foo foo0 = {0, &foo_foo_vtbl};
Foo foo1 = {1, &foo_foo_vtbl};
Foo foo2 = {2, &foo_foo_vtbl};

pFoo->pVtbl->func(pFoo);
```
这样的代码结构仅需要在对象中持有指向虚函数表的指针即可，而无需持有函数指针，节约内存。

## 非虚函数