## 职责链模式
```c
#ifndef _STACK_H_
#define _STACK_H_

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct Validator {
    bool (* const validate)(struct Validator *pThis, int val);
} Validator;

typedef struct {
    Validator base;
    const int min;
    const int max;
} RangeValidator;

typedef struct {
    Validator base;
    int previousValue;
} PreviousValueValidator;

typedef struct ChainedValidator {
    Validator base;
    Validator *pWrapped;
    Validator *pNext;
} ChainedValidator;

typedef struct {
    int top;
    const size_t size;
    int * const pBuf;
    Validator * const pValidator;
} Stack;

bool validateRange(Validator *pThis, int val);
bool validatePrevious(Validator *pThis, int val);
bool validateChain(Validator *pThis, int val);

#define newRangeValidator(min, max) \
    {{validateRange}, (min), (max)}

#define newPreviousValueValidator \
    {{validatePrevious}, 0}

#define newChainedValidator(wrapped, next)       \
    {{validateChain}, (wrapped), (next)}

bool push(Stack *p, int val);
bool pop(Stack *p, int *pRet);

#define newStack(buf) {                  \
    0, sizeof(buf) / sizeof(int), (buf), \
    NULL                                 \
} 

#define newStackWithValidator(buf, pValidator) { \
    0, sizeof(buf) / sizeof(int), (buf),         \
    pValidator                                   \
}

#ifdef __cplusplus
}
#endif

#endif
```

```c
#include <stdbool.h>
#include "stack.h"

static bool isStackFull(const Stack *p) {
    return p->top == p->size;
}

static bool isStackEmpty(const Stack *p) {
    return p->top == 0;
}

bool validateRange(Validator *p, int val) {
    RangeValidator *pThis = (RangeValidator *)p;
    return pThis->min <= val && val <= pThis->max;
}

bool validatePrevious(Validator *p, int val) {
    PreviousValueValidator *pThis = (PreviousValueValidator *)p;
    if (val < pThis->previousValue) return false;
    pThis->previousValue = val;
    return true;
}

bool validate(Validator *p, int val) {
    if (! p) return true;
    return p->validate(p, val);
}

// true: 成功, false: 失敗
bool push(Stack *p, int val) {
    if (! validate(p->pValidator, val) || isStackFull(p)) return false;
    p->pBuf[p->top++] = val;
    return true;
}

// true: 成功, false: 失敗
bool pop(Stack *p, int *pRet) {
    if (isStackEmpty(p)) return false;
    *pRet = p->pBuf[--p->top];
    return true;
}

bool validateChain(Validator *p, int val) {
    ChainedValidator *pThis = (ChainedValidator *)p;

    p = pThis->pWrapped;
    if (! p->validate(p, val)) return false;

    p = pThis->pNext;
    return !p || p->validate(p, val);
}
```