## 观察者模式
在模板方法模式例子中，如果指定一个不存在的文件```int_sorter("no_such_file")```时，其内部```geit_file_pointer```函数内部```fopen```函数调用失败。导致外部```reader```函数与```do_with_buffer```函数也会检测出错误，将错误信息打印出来，导致错误信息被输出了2次。

```c
struct FileAccessorContext;

typedef struct FileErrorObserver{
    void (* const onError) (struct FileErrorObserver *pThis, \ 
        Struct FileAccessorContext *pFileCtx);
}FileErrorObserver;

extern FileErrorObserver default_file_error_observer;

typedef struct FileAccessorContext{
    FILE *fp;
    const char *pFname;
    const char *pMode;
    bool (* const processor)(struct FileAccessorContext *pThis);
    FileErrorObserver *pFileErrorObserver;
}FileAccessorContext;


```

```c
FileErrorObserver default_file_error_observer = {
    &default_file_error_handler
};

bool access_file(FileAccessorContext *pThis) {
    assert(pThis);
    if (pThis->pFileErrorObserver == NULL)
        pThis->pFileErrorObserver = &default_file_error_observer;
    bool ret = pThis->processor(pThis);
    if (pThis->fp != NULL) {
        if (fclose(pThis->fp) != 0) {
            pThis->pFileErrorObserver->onError( \ 
                pThis->pFileErrorObserver, pThis);
            ret = false;
        }
    }

    return ret;
}

FILE *get_file_pointer(FileAccessorContext *pThis) {
    assert(pThis);
    if (pThis->fp == NULL) {
        pThis->fp = fopen(pThis->pFname, pThis->pMode);
        if (pThis->fp == NULL) 
            pThis->pFileErrorObserver->onError( \ 
                pThis->pFileErrorObserver, pThis);
    }

    return pThis->fp;
}

static void default_file_error_handler(FileErrorObserver *pThis \
    FileAccessorContext *pFileCtx) {
    fprintf(stderr, "File access error '%s'(mode: %s): %s\n",   \
            pFileCtx->pFname, pFileCtx->pMode, strerror(errno));
}
```

```c
long file_size(FileAccessorContext *pFileCtx) {
    long save = file_current_pos(pFileCtx);
    if (save < 0) return -1;

    if (set_file_pos(pFileCtx, 0, SEEK_END) != 0) return -1;
    
    long size = file_current_pos(pFileCtx);
    set_file_pos(pFileCtx, save, SEEK_SET);

    return size;
}

long file_current_pos(FileAccessorContext *pThis) {
    assert(pThis);
    FILE *fp = get_file_pointer(pThis);
    if (fp == NULL) return -1;

    long ret = ftell(fp);
    if (ret < 0) pThis->pFileErrorObserver->onError( \
        pThis->pFileErrorObserver, pThis);
    return ret;
}

int set_file_pos(FileAccessorContext *pThis, long offset, int whence) {
    assert(pThis);
    FILE *fp = get_file_pointer(pThis);
    if (fp == NULL) return -1;

    int ret = fseek(fp, offset, whence);
    if (ret != 0) pThis->pFileErrorObserver->onError( \
        pThis->pFileErrorObserver, pThis);
    return ret;
}

bool read_file(FileAccessorContext *pThis, BufferContext *pBufCtx) {
    FILE *fp = get_file_pointer(pThis);
    if (fp == NULL) return false;

    if (pBufCtx->size != fread(pBufCtx->pBuf, 1, pBufCtx->size, fp)) {
        pThis->pFileErrorObserver->onError(pThis->pFileErrorObserver, \
            pThis);
        return false;
    }
    return true;
}

bool write_file(FileAccessorContext *pThis, BufferContext *pBufCtx) {
    FILE *fp = get_file_pointer(pThis);
    if (fp == NULL) return false;

    if (pBufCtx->size != fwrite(pBufCtx->pBuf, 1, pBufCtx->size, fp)) {
        pThis->pFileErrorObserver->onError(pThis->pFileErrorObserver, \
            pThis);
        return false;
    }
    return true;
}
```

```c
static bool reader(FileAccessorContext *pFileCtx);
static bool do_with_buffer(BufferContext *pBufCtx);
static bool writer(FileAccessorContext *pFileCtx);
static int comparator(const void *p1, const void *p2);
static void file_error(FileErrorObserver *pThis, \
    FileAccessorContext *pFileCtx);

typedef struct {
    BufferContext base;
    Context *pAppCtx;
} MyBufferContext;

typedef struct {
    FileAccessorContext base;
    MyBufferContext *pBufCtx;
} MyFileAccessorContext;

typedef struct {
    FileAccessorContext base;
    long size;
} SizeGetterContext;

static FileErrorObserver file_error_observer = {
    file_error
};

IntSorterError int_sorter(const char *pFname) {
    Context ctx = {pFname, ERR_CAT_OK};

    MyBufferContext bufCtx = {{NULL, 0, do_with_buffer}, &ctx};
    buffer(&bufCtx.base);
    return ctx.errorCategory;
}

static bool do_with_buffer(BufferContext *p) {
    MyBufferContext *pBufCtx = (MyBufferContext *)p;
    MyFileAccessorContext readFileCtx = {
        {NULL, pBufCtx->pAppCtx->pFname, "rb", reader, \
            &file_error_observer}, pBufCtx };

    if (! access_file(&readFileCtx.base)) return false;

    qsort(p->pBuf, p->size / sizeof(int), sizeof(int), comparator);

    MyFileAccessorContext writeFileCtx = {
        {NULL, pBufCtx->pAppCtx->pFname, "wb", writer, \
            &file_error_observer},pBufCtx};
    return access_file(&writeFileCtx.base);
}

static bool reader(FileAccessorContext *p) {
    MyFileAccessorContext *pFileCtx = (MyFileAccessorContext *)p;

    long size = file_size(p);
    if (size == -1) return false;

    if (! allocate_buffer(&pFileCtx->pBufCtx->base, size)) {
        pFileCtx->pBufCtx->pAppCtx->errorCategory = ERR_CAT_MEMORY;
        return false;
    }

    return read_file(p, &pFileCtx->pBufCtx->base);
}

static bool writer(FileAccessorContext *p) {
    MyFileAccessorContext *pFileCtx = (MyFileAccessorContext *)p;
    return write_file(p, &pFileCtx->pBufCtx->base);
}

static int comparator(const void *p1, const void *p2) {
    int i1 = *(const int *)p1;
    int i2 = *(const int *)p2;
    if (i1 < i2) return -1;
    if (i1 > i2) return 1;
    return 0;
}

static void file_error(FileErrorObserver *pThis, \ 
    FileAccessorContext *pFileCtx) {
    
    default_file_error_observer.onError(pThis, pFileCtx);

    MyFileAccessorContext *pMyFileCtx = (MyFileAccessorContext *)pFileCtx;
    pMyFileCtx->pBufCtx->pAppCtx->errorCategory = ERR_CAT_FILE;
}
```

```c
typedef struct ArrayList {
    const int capacity;
    void ** const pBuf;
    size_t index;

    struct ArrayList *(* const add)(struct ArrayList *pThis, void *pData);
    void *(* const remove)(struct ArrayList *pThis, void *pData);
    void *(* const get)(struct ArrayList *pThis, int index);
    size_t (* const size)(struct ArrayList *pThis);
} ArrayList;

ArrayList *add_to_array_list(ArrayList *pThis, void *pData);
void *remove_from_array_list(ArrayList *pThis, void *pData);
void *get_from_array_list(ArrayList *pThis, int index);
size_t array_list_size(ArrayList *pThis);

#define new_array_list(array) \
    {sizeof(array) / sizeof(void *), array, \
     0, add_to_array_list, remove_from_array_list, \
     get_from_array_list, array_list_size}

// データを末尾に追加し、自分自身を返す。
// サイズが足りない場合はassertエラーになる。
ArrayList *add_to_array_list(ArrayList *pThis, void *pData) {
    assert(pThis->capacity > pThis->index);
    pThis->pBuf[pThis->index++] = pData;
    return pThis;
}

// 指定されたデータを削除し、削除されたデータを返す。
// 見つからない場合はNULLが返る。
void *remove_from_array_list(ArrayList *pThis, void *pData) {
    int i;

    for (i = 0; i < pThis->index; ++i) {
        if (pThis->pBuf[i] == pData) {
            memmove(pThis->pBuf + i, pThis->pBuf + i + 1, \
            (pThis->index - i - 1) * sizeof(void *));
            --pThis->index;
            return pData;
        }
    }

    return NULL;
}

// 指定された場所のデータを返す。
// indexの値がデータの格納されている範囲外の場合はassertエラーになる。
void *get_from_array_list(ArrayList *pThis, int index) {
    assert(0 <= index && pThis->index > index);
    return pThis->pBuf[index];
}

// 格納されているデータの個数を返す。
size_t array_list_size(ArrayList *pThis) {
    return pThis->index;
}
```

```c
struct FileAccessorContext;

typedef struct FileErrorObserver {
    void (* const onError)(struct FileErrorObserver *pThis, \
    struct FileAccessorContext *pFileCtx);
} FileErrorObserver;

extern FileErrorObserver default_file_error_observer;

typedef struct FileAccessorContext {
    FILE *fp;
    const char *pFname;
    const char *pMode;
    ArrayList observer_table;

    bool (* const processor)(struct FileAccessorContext *pThis);
} FileAccessorContext;
```

```c
bool access_file(FileAccessorContext *pThis) {
    assert(pThis);
    bool ret = pThis->processor(pThis);
    if (pThis->fp != NULL) {
        if (fclose(pThis->fp) != 0) {
            fire_error(pThis);
            ret = false;
        }
    }

    return ret;
}

static void fire_error(FileAccessorContext *pThis) {
    ArrayList *pTbl = &pThis->observer_table;
    int i;
    for (i = 0; i < pTbl->index; ++i) {
        FileErrorObserver *pObserver = pTbl->get(pTbl, i);
        pObserver->onError(pObserver, pThis);
    }
}

void add_file_error_observer(FileAccessorContext *pThis, \
    FileErrorObserver *pErrorObserver) {
    ArrayList *pTable = &pThis->observer_table;
    pTable->add(pTable, pErrorObserver);
}

void remove_file_error_observer(FileAccessorContext *pThis, \
    FileErrorObserver *pErrorObserver) {
    ArrayList *pTable = &pThis->observer_table;
    pTable->remove(pTable, pErrorObserver);
}
```
