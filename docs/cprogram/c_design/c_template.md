## 模版方法模式
资源管理（文件，内存等）是一件麻烦的事情，因为在分配资源后还必须释放资源（例如：fopen打开了文件后必须用fclose关闭文件；使用malloc分配内存后，必须使用free释放掉内存）。而使用资源的具体逻辑代码被夹在管理（分配和释放）资源的代码之间，甚至需要在多处使用资源返回处都需要释放资源。
```c
int range(const char *pFname){
    FILE *fp = fopen(pFname, "r");
    if(NULL == fp)
        return -1;
    /* 使用资源部分 */
    int min = INT_MAX;
    int max = INT_MIN;

    char buf[256];

    while((fgets(buf, sizeof(buf), fp)) != NULL){
        int value = atoi(buf);
        min = min > value ? value : min;
        max = max < value ? value : max;
    }
    
    fclose(fp);     /* 释放资源 */

    return max - min;
}
```
对于这样的程序结构，模板(Template)方法模式非常有效。模板方法将程序中的处理部分作为可以被替代的函数(使用函数指针实现模板方法)，将其它处理作为固定部分，使其可以被重复利用。
```c
/* read_file函数负责打开文件与关闭文件等固定的处理部分 */
int read_file(const char *pFname, int (*processor)(File *fp)){
    File *fp = fopen(pFname, "r");
    if(NULL == fp){
        return -1;
    }
    /* 资源处理内部，不在需要fclose函数。 */
    int ret = processor(fp);

    fclose(fp);
    return ret;
}

static int range_processor(File *fp){
    int min = INT_MAX;
    int max = INT_MIN;

    char buf[256];

    while((fgets(buf, sizeof(buf), fp)) != NULL){
        if(buf[0] == '\n)
            return -1;
        int value = atoi(buf);
        min = min > value ? value : min;
        max = max < value ? value : max;
    }

    return max - min;
}

int range(const char *pFname){
    return read_file(pFname, range_processor);
}
```
为了程序更通用（例如：能返回非int类型的值），在c语言中多是用void指针或联合体来解决。下面使用对象并继承对象的方式解决这个问题。
```c
/* 对象A */
typedef struct FileReaderContext{
    const char * const pFname;
    void (* const processor)(struct FileReaderContext *pThis, FILE *fp);
}

/* 继承对象A */
typedef struct{
    FileReaderContext base;
    int result
}MyFileReaderContext;

static void calc_range(FileReaderContext *p, FILE *p){
    MyFileReaderContext *pCtx = (MyFileReaderContext *)p;
    pCtx->result = range_processor(fp);
}

int read_file(FileReaderContext *pCtx){
    FILE *fp = fopen(pCtx->pFname, "r");
    if(NULL = fp)
        return -1;
    
    /* processor是calc_range函数 */
    pCtx->processor(pCtx, fp);

    fclose(fp);
    return 0;
}

int range(const char *pFname){
    MyFileReaderContext ctx = {{pFname, calc_range}, 0};

    if(read_file(&ctx.base) != 0){
        fprintf(stderr, "Cannot open file '%s'.\n",pFname);
    }

    return ctx.result;
}
```
当需要使用多种资源时，该如何处理？
例如：考虑如下将一个文件中的数据读取至内存中，进行排序后再输出至另一个文件的情况。
```c
static long file_size(FILE *fp);
int process_file(
    const char *pInputFileName,
    const char *pOutputFileName,
    void (*sorter)(void *pBuf))
{
    FILE *fpInp = fopen(pInputFileName, "rb");
    if(NULL == fpInp)
        return FILE_OPEN_ERROR;
    long size = file_size(fpInp);
    void *p = malloc(size);
    if(NULL == p)
        return NO_MEMORY_ERROR;     /* 没有close的return */
    fread(p,size,1,fpInp);
    ...
}
```
梳理一下处理流程：

* 以只读方式打开要读取的文件
* 使用fseek，ftell获取该文件的大小
* 关闭该文件
* 分配可以容纳该文件的内存空间
* 以只读方式打开要读取的文件
* 读取文件内存
* 关闭文件
* 将内存中的内容排序
* 以可写的方式打开写入的文件
* 写入该文件
* 关闭该文件
* 释放内存

处理文件的模板方法。
```c
typedef struct FileAccessorContext{
    const char * const pFname;
    const char * const pMode;
    void (* const processor)(struct FileAccessorContext *pThis, FILE *fp);
}FileAccessorContext;

bool access_file(FileAccessorContext *pCtx){
    FILE *fp = fopen(pCtx->pFname, pCtx->pMode);
    if(NULL == fp)
        return false;
    pCtx->processor(pCtx,fp);
    
    fclose(fp);
    return ture;
}
```
分配内存的模板方法。
```c
typedef struct BufferContext{
    void *pBuf;
    size_t size;
    void (*processor)(struct BufferContext *p);
}BufferContext;

bool buffer(BufferContext *pThis){
    pThis->pBuf = malloc(pThis->size);
    if(NULL == pThis->pBuf)
        return false;
    
    pThis->processor(pThis);

    free(pThis->pBuf);
    return ture;
}
```
获取文件大小函数。
```c
typedef struct{
    FileAccessorContext base;
    long size;
}SizeGetterContext;

static long file_size(const char *pFname){
    SizeGetterContext ctx = {{pFname, "rb", size_reader}, 0};

    if(!access_file(&ctx.base)){
        return -1;
    }
    return ctx.size;
}

static void size_reader(FileAccessorContext *p, FILE *fp){
    SizeGetterContext *pThis = (SizeGetterContext *)p;
    pThis->size = -1;

    if(fseek(fp, 0, SEEK_END) == 0)
        pThis->size = ftell(fp);
}
```

```c
typedef enum{
    ERR_CAT_OK = 0,
    ERR_CAT_FILE,
    ERR_CAT_MEMORY
}IntSorterError;

typedef struct{
    const char * const pFname;
    int errorCategory;
}Context;

typedef struct {
    BufferContext base;
    Context *pAppCtx;
}MyBufferContext;

IntSorterError int_sorter(const char *pFname){
    Context ctx = {pFname, ERR_CAT_OK};

    long size = file_size(pFname);

    if(size == -1){
        file_error(&ctx);
        return ctx.errorCategory;
    }

    MyBufferContext bufCtx = {{NULL, size, do_with_buffer}, &ctx};
    if(!buffer(&bufCtx.base)){
        ctx.errorCategory = ERR_CAT_MEMORY;
    }

    return ctx.errorCategory;
}

static void file_error(Context *pCtx){
    fprintf(stderr, "%s:%s\n", pCtx->pFname, strerror(errno));
    pCtx->errorCategory = ERR_CAT_FILE;
}
```

```c
typedef struct{
    FileAccessorCOntext base;
    MyBufferContext *pBufCtx;
}MyFileAccessorContext;

static void do_with_buffer(BufferContext *p){
    MyBufferContext *pBufCtx = (MyBufferContext *)p;
    MyFileAccessorContext readFileCtx = {{pBufCtx->pAppCtx->pFname,"rb", \
        reader}, pBufCtx};

    if(!access_file(&readFileCtx.base)){
        file_error(pBufCtx->pAppCtx);
        return;
    }

    qsort(p->pBuf, p->size / sizeof(int), sizeof(int), comparator);

    MyFileAccessorContext writeFileCtx = {{pBufCtx->pAppCtx->pFname,"wb", \ 
        writer},pBufCtx};
    if(!access_file(&writeFileCtx.base)){
        file_error(pBufCtx->pAppCtx);
        return;
    }
}

static void reader(FileAccessorContext *p, FILE *fp){
    MyFileAccessorContext *pFileCtx = (MyFileAccessorContext *)p;
    MyBufferContext *pBufCtx = pFileCtx->pBufCtx;

    if(pBufCtx->base.size != fread(pBufCtx->base.pBuf, 1, \
        pBufCtx->Base.size, fp)){
        file_error(pBufCtx->pAppCtx);
    }
}

static void writer(FileAccessorContext *p, FILE *fp){
    MyFileAccessorContext *pFileCtx = (MyFileAccessorContext *)p;
    MyBufferContext *pBufCtx = pFileCtx->pBufCtx;

    if(fwrite(pBufCtx->base.pBuf,1,pBufCtx->base.size, fp) != \
        pBufCtx->base.size){
        file_error(pBufCtx->pAppCtx);
    }
}
```
如上的处理流程中一共两次打开和关闭文件：首先打开文件计算大小，关闭，然后打开文件读取内容，关闭。为此还可以修改一下，将获取所需内存大小推迟至调用用户自定义函数后处理。内存分配函数指定大小的内存，并将其保存至上下文中返回给用户自定义函数处理。

延迟分配内存。
```c
typedef struct BufferContext{
    void *pBuf;
    size_t size;
    bool (*processor)(struct BufferContext *p);
}BufferContext;

bool buffer(BufferContext *pThis){
    assert(pThis);
    /* 不在分配内存 */
    bool ret = pThis->processor(pThis);
    free(pThis->pBuf);
    return ret;
}
/* 内存分配函数 */
void *allocate_buffer(BufferContext *pThis, size_t size){
    assert(pThis);
    assert(pThis->pBuf == NULL);

    pThis->pBuf = malloc(size);
    pThis->size = size;
    return pThis->pBuf;
}
```
延迟打开文件。
```c
typedef struct FileAccessorContext{
    FILE *fp;
    const char * const pFname;
    const char * const pMode;
    bool (* const processor)(struct FileAccessorContext *pThis)
}FileAccessorContext;


bool access_file(FileAccessorContext *pThis){
    assert(pThis);
    /* 不在打开文件 */
    bool ret = pThis->processor(pThis);
    if(pThis->fp != NULL){
        if(fclose(pThis->fp) != 0)
            ret = false;
    }
    return ret;
}
/* 打开文件函数 */
FILE *get_file_pointer(FileAccessorContext *pThis){
    assert(pThis);
    if(pThis->fp == NULL){
        pThis->fp = fopen(pThis->pFname, pThis->pMode);
    }
    return pThis->fp;
}
```
延迟分配资源的int_sorter函数。
```c
/* context是应用程自身数据的上下文 */
typedef struct{
    const char * const pFname;
    int errorCategory;
}Context;

IntSorterError int_sorter(const char *pFname){
    Context ctx = {pFname, ERROR_CAT_OK};
    MyBufferContext bufCtx = {{NULL, 0, do_with_buffer}, &ctx};

    buffer(&bufCtx.base);

    return ctx.errorCategory;
}

static bool do_with_buffer(BufferContext *p){
    MyBufferContext *pBufCtx = (MyBufferContext *)p;
    MyFileAccessorContext readFileCtx = \
        {{NULL,pBufCtx->pAppCtx->pFname,"rb",reader}, pBufCtx};

    if(!access_file(&readFileCtx.base)){
        file_error(pBufCtx->pAppCtx);
        return false;
    }

    qsort(p->pBuf, p->size / sizeof(int), sizeof(int), comparator);

    MyFileAccessorContext writeFileCtx = \
        {{NULL,pBufCtx->pAppCtx->pFname,"wb",write}, pBufCtx};
    if(!access_file(&writeFileCtx.base)){
        file_error(pBufCtx->pAppCtx);
        return false;
    }

    return ture;
}

static bool reader(FileAccessorContext *p){
    MyFileAccessorContext *pFileCtx = (MyFileAccessorContext *)p;
    MyBufferContext *pBufCtx = pFileCtx->pBufCtx;

    long size = file_size(p);
    if(size == -1){
        file_error(pBufCtx->pAppCtx);
        return false;
    }

    if(!allocate_buffer(&pBufCtx->base, size)){
        pBufCtx->pAppCtx->errorCategory = ERR_CAT_MEMORY;
        return false;
    }

    FILE *fp = get_file_pointer(p);
    if(pBufCtx->base.size != fread(pBufCtx->base.pBuf, 1, \ 
        pBufCtx->base.size, fp)){
        file_error(pBufCtx->pAppCtx);
        return false;
    }

    return ture;
}

static bool writer(FileAccessorContext *p){
    MyFileAccessorContext *pFileCtx = (MyFileAccessorContext *)p;
    MyBufferContext *pBufCtx = pFileCtx->pBufCtx;

    FILE *fp = get_file_pointer(p);
    if(fwrite(pBufCtx->base.pBuf, 1, pBufCtx->base.size, fp) != \
        pBufCtx->base.size){
            file_error(pBufCtx->pAppCtx);
            return false;
        }
    return ture;
}

static long file_size(FileAccessorContext *pThis){
    long save = file_current_pos(pThis);
    if(save < 0)
        return -1;

    if(set_file_pos(pThis, 0, SEEK_END) != 0)
        return -1;
    
    long size = file_current_pos(pThis);
    if(set_file_pos(pThis, save, SEEK_SET) != 0)
        return -1;
    
    return size;
}

static long file_current_pos(FileAccessorContext *pFileCtx){
    assert(pFileCtx);
    FILE *fp = get_file_pointer(pFileCtx);
    if(NULL == fp)
        return -1;

    return ftell(fp);
}

static int set_file_pos(FileAccessorContext *pFileCtx, long offset, \
    int whence){
    assert(pFileCtx);
    FILE *fp = get_file_pointer(pFileCtx);
    if(NULL == fp)
        return -1;

    return fseek(fp, offset, whence);
}
```
