## 访问者模式
```c
struct ValidatorVisitor;

typedef struct Validator {
    bool (* const validate)(struct Validator *pThis, int val);
    void (* const accept)(struct Validator *pThis, \
        struct ValidatorVisitor *pVisitor);
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

typedef struct ValidatorVisitor {
    void (* const visitRange)(struct ValidatorVisitor *pThis, \ 
        RangeValidator *p);
    void (* const visitPreviousValue)(struct ValidatorVisitor *pThis, \
        PreviousValueValidator *p);
} ValidatorVisitor;

void acceptRange(Validator *pThis, ValidatorVisitor *pVisitor);
void acceptPrevious(Validator *pThis, ValidatorVisitor *pVisitor);

bool validateRange(Validator *pThis, int val);
bool validatePrevious(Validator *pThis, int val);

#define newRangeValidator(min, max) \
    {{validateRange, acceptRange}, (min), (max)}

#define newPreviousValueValidator \
    {{validatePrevious, acceptPrevious}, 0}
```

```c
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

void acceptRange(Validator *p, ValidatorVisitor *pVisitor) {
    pVisitor->visitRange(pVisitor, (RangeValidator *)p);
}

void acceptPrevious(Validator *p, ValidatorVisitor *pVisitor) {
    pVisitor->visitPreviousValue(pVisitor, (PreviousValueValidator *)p);
}
```

```c
static void rangeView(ValidatorVisitor *pThis, RangeValidator *p);
static void previousValueView(ValidatorVisitor *pThis, \ 
    PreviousValueValidator *p);

typedef struct ViewVisitor {
    ValidatorVisitor base;
    char *pBuf;
    size_t size;
} ViewVisitor;

void printValidator(Validator *p, char *pBuf, size_t size) {
    ViewVisitor visitor = {{rangeView, previousValueView}, pBuf, size};
    p->accept(p, &visitor.base);
}

static void rangeView(ValidatorVisitor *pThis, RangeValidator *p) {
    ViewVisitor *pVisitor = (ViewVisitor* )pThis;
    snprintf(pVisitor->pBuf, pVisitor->size, \ 
        "Range(%d-%d)", p->min, p->max);
}

static void previousValueView(ValidatorVisitor *pThis, \ 
    PreviousValueValidator *p) {
    ViewVisitor *pVisitor = (ViewVisitor* )pThis;
    snprintf(pVisitor->pBuf, pVisitor->size, "Previous");
}
```


```c

```