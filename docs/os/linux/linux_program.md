
```c
/bin    //二进制文件目录，用于存放启动系统程序的标准路径
/usr/bin    //用户二进制文件路径，用于存放用户使用的标准程序
/usr/local  //本地二进制文件目录，用于存放软件安装程序
```

对于c语言来说，头文件几乎总是位于/usr/include目录及其子目录中。

标准系统库文件一般存储在/lib和/usr/lib目录中。

终极命令
```c
$ man
$ info
```

## 文件操作
```c
/dev/console    //系统控制台
/dev/tty        //控制终端
/dev/null   
```
### 底层文件访问
```c
#include<unistd.h>
size_t write(int fildes, const void *buf, size_t nbytes);   //把缓冲区buf前nbytes个字节写入与文件描述符fildes关联的文件中。
size_t read(int fildes, void *buf, size_t nbytes);  //从文件描述符fildes相关的文件里读入nbytes个字节数据，存放到buf中。
int close(int fildes);
#include<fcntl.h>
#include<sys/types.h>
#include<sys/stat.h>
int open(const char *path, int oflags);
int open(const char *path, int oflags, mode_t mode);

off_t lseek(int fildes, off_t offset, int whence);  //对文件描述符fildes的读写指针进行设置。
int fstat(int fildes, struct stat *buf);    //返回与打开文件描述符相关的文件的状态信息，写入buf结构
int stat(const char *path, struct stat *buf);   //当文件是一个符号链接时，返回该符号链接指向的文件的信息。
int lstat(const char *path, struct stat *buf);  //当文件是一个符号链接时，返回该符号链接本身的信息。

int dup(int fildes);        //赋值文件描述符fildes，返回一个新文件描述符
int dup2(int fildes, int fildes2);  //通过明确指定木办法描述符来把一个文件描述符复制为另外一个
```
### 标准I/O
```c
//stdin,stdout,stderr
#include<stdio.h>
FILE *fopen(const char *filename, const char *mode);
size_t fread(void *ptr, size_t size, size_t nitems, FILE *stream);  //数据从文件流stream读到由ptr指向的数据缓冲区里。size参数指定每个数据记录的长度，计数器nitems给出要传输的记录个数
size_t fwrite(const void *ptr, size_t size, size_t nitems, FILE *stream);
int fclose(FILE *stream);
int fflush(FILE *stream); //把文件流里的所有未写出数据立刻写出。fclose函数隐含执行了一次flush操作，所以不必再调用fclose之前调用fflush

int fseek(FILE *stream, long int offset, int whence); //文件流里为下一次读写操作指定位置

int fgetc(FILE *stream);
int getc(FILE *stream);
int getchar();      //从标准输入里读取下一个字符

int fputc(int c, FILE *stream);
int putc(int c,FILE *stream);   //但它可能被实现为一个宏
int putchar(int c);

/******
fgets把读到的字符写到s指向的字符串里，直到出现下面某种情况：遇到换行符，已经传输了n-1个字符，或者到达文件尾。
会把遇到的换行符也传递到接收字符串里，在加上一个表示结尾的空字节\0。一次调用最多只能传输n-1个字符，因为它必须要把空字节加上以结束字符串。
******/
char *fgets(char *s, int n, FILE *stream);
char *gets(char *s);    //它从标准输入读取数据并丢去遇到的换行符。它在接收字符串的尾部加上一个null字节。
```
### 格式化输入输出
```c
int printf(const char *format, ...);    //输出送到标准输出
int sprintf(char *s, const char *format, ...);  //把输出和一个结尾空字符写到作为参数传递过来的字符串2里
int fprintf(FILE *stream, const char *format, ...); //把输出送到一个指定的文件流。

int scanf(const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
int sscanf(const char *s, const char *format, ...);

/****
fgetpos: 获取文件流的当前位置。
fsetpos: 设置文件流的当前位置
ftell:  返回文件流当前位置的偏移
rewind: 重置文件流里的读写位置
freopen: 重新使用一个文件流
setvbuf: 设置文件流的缓冲机制
remove: 相当于unlink函数，如果参数path是一个目录，相当于rmdir函数
****/

#include<errno.h>
extern int errno;
int ferror(FILE *stream);
int feof(FILE *stream);
void clearerr(FILE *stream);

int fileno(FILE *stream);
FILE *fdopen(int fildes,const char *mode);
```
### 文件和目录维护
```c
#include<sys/stat.h>
#include<unistd.h>
int chmod(const char *path, mode_t mode);   //改变文件目录的访问权限
int chown(const char *path, uid_t owner, gid_t group);

int unlink(const char *path);
int link(const char *path1,const char *path2);
int symlink(const char *path1, const char *path2);

int mkdir(const char *path, mode_t mode);
int rmidr(const char *path);    //删除空目录

char *getcwd(char *buf, size_t size);   //获取当前目录的名字
int chdir(const char *path);    
```
### 扫描目录
```c
#include<sys/types.h>
#include<dirent.h>

DIR *opendir(const char *name);
struct dirent *readdir(DIR *dirp);
long int telldir(DIR *dirp);
void seekdir(DIR *dirp, long int loc);
int closedir(DIR *dirp);
```
### 错误处理
```c
#include<string.h>
#include<stdio.h>
char *strerror(int errnum);
void perror(const char *s);
```
### /proc文件系统
```c
cat /proc/cpuinfo   //查看cpu的详细信息
cat /proc/meminfo   //内存使用情况
cat /proc/version   //内核版本信息
cat /proc/sys/fs/file-max   //同时打开的文件总数
```
### fcntl和mmap
```c
int fcntl(int fildes, int cmd);     //对底层文件描述符提供更多的操作方法
int fcntl(int fildes, int cmd, long arg);       
```
**mmap**(内存映射)函数的作用是建立一段可以被两个或更多个程序读写的内存。一个程序对它所做出的修改可以被其他程序看见。该函数创建一个指向一段内存区域的指针，该内存区域与可以通过一个打开的文件描述符访问的文件的内容相关联。
```c
#include<sys/mman.h>
void *mmap(void *addr, size_t len, int prot, int flags, int fildes, off_t off);

int msync(void *addr, size_t len, int flags);   //把在该内存段的某个部分或整段中的修改写回到被映射的文件中

int munmap(void *addr, size_t len);     //释放内存段
```
## Linux环境
```c
int main(int argc, char *argv[])
//argc是程序参数的个数(包括程序名本身)，argv是一个代表参数自身的字符串数组(程序名为第一个元素argv[0])。
```
```c
#include<stdio.h>
int getopt(int argc, char *const argv[], const char *optstring);
extern char *optarg;
extern int optind, opterr, optopt;
//getopt_long
```
### 日志
```c
/usr/adm & /var/log
/var/log/messages
/var/log/mail
/etc/syslog.conf
/etc/syslog-ng/syslog-ng.conf   //检查系统配置
```
```c
#include<syslog.h>
void syslog(int priority, const char *message, arguments...);
//转换控制符%m用于插入与错误变量errno当前值对应的出错消息字符串
void closelog(void);
void openlog(const char *ident, int logopt, int facility);
int setlogmask(int maskpri);
```
## 数据管理
交换空间(swap space)
>按需换页的虚拟内存系统

### 文件锁定
文件段锁定(文件区域锁定)
```c
#include<fcntl.h>
int fcntl(int fildes, int command, ...);
int fcntl(int fildes, int command, struct flock *flock_structure);
```
fcntl对一个打开的文件描述符进行操作，并根据command参数的设置完成不同的任务。提供了3个用于文件锁定的命令选项。
```c
F_GETLK
F_SETLK
F_SETLKW
```
flock(文件锁)结构依赖具体的实现，至少包含以下成员：
```c
short l_type
short l_whence  //取值必须是SEEK_SET(文件头),SEEK_CUR(当前位置),SEEK_END(文件尾)中的一个。l_whence通常设置为SEEK_SET,这时l_start就从文件的开始计算
off_t l_start   //l_whence是l_start的相对偏移位置，l_start是该区域的第一个字节
off_t l_len
pid_t l_pid
```
l_type成员的取值定义在头文件fcntl.h中
```c
F_RDLCK     //共享(或读)锁。许多不同的进程可以拥有文件同一(或者重叠)区域上的共享锁。只要任一进程拥有一把共享锁，那么就没有进程可以再获得该区域上的独占锁。为了获得一把共享锁，文件必须以“读”或“读写”方式打开
F_UNLCK     //解锁，用来清除锁
F_WRLCK     //独占(或写)锁。只有一个进程可以在文件的任一特定区域拥有一把独占锁。一旦一个进程拥有了这样一把锁，任何其他进程都无法在该区域上获得任何类型的锁。为了获得一把独占锁，文件必须以“写”或“读/写”方式打开
```
**F_GETLK命令**
用于获取fildes打开的文件的锁信息。它不会尝试去锁定文件。

调用进程把自己想创建的锁类型信息传递给fcntl，使用F_GETLK命令的fcntl就会返回将会阻止获取锁的任何信息。

进程可能使用F_GETLK调用来查看文件中某个区域的当前锁状态。如果文件已被锁定从而阻止锁请求成功执行，fcntl会用相关信息覆盖flock结构。如果所请求可以成功执行，flock结构将保持不变，如果F_GETLK调用无法获得信息，它将返回-1表明失败。成功就返回非-1值。

**F_SETLK命令**
对fildes指向的文件的某个区域加锁或解锁。flock结构中使用的值:l_type,l_pid。与F_GETLK一样，要加锁的区域由flock结构中的l_start,l_whence和l_len的值定义。

如果锁成功，返回非-1值，失败返回-1。

**F_SETLKW命令**
与F_SETLK相同，但在无法获取锁时，这个调用将等待直到可以为止。一旦开始等待，只有在可以获取锁或收到一个信号时才会返回。


## MySQL
### 连接
1. 初始化一个连接句柄结构
2. 实际进行连接
```c
#include<mysql.h>
MYSQL *mysql_init(MYSQL *);
MYSQL *mysql_real_connect(MYSQL *connection,    //被mysql_init初始化的结构
        const char *server_host,        //可以是主机名也可以是ip地址
        const char *sql_user_name,
        const char *sql_password,
        const char *db_name,
        unsigned int port_number,       //0
        const char *unix_socket_name,   //NULL
        unsigned int flags);
void mysql_close(MYSQL *connection);
```
```c
int mysql_options(MYSQL *connection, enum option_to_set, const char *argument);
/******
1. 在mysql_init和mysql_real_connect之间即可。
2. MYSQL_OPT_CONNECT_TIMEOUT const unsigned int * 连接超时之前的等待秒速
3. MYSQL_OPT_COMPRESS None,使用NULL 网络连接中使用压缩机制
4. MYSQL_INIT_COMMAND const char * 每次建立后发送的命令
5. 成功的调用将返回0。
******/
```
### 错误处理
```c
unsigned int mysql_errno(MYSQL *connection);
char *mysql_error(MYSQL *connection);
```
### 执行
#### 不返回数据的语句UPDATE,DELETE,INSERT
```c
my_ulonglong mysql_affected_rows(MYSQL *connection);    //用于检查受影响的行数
```
#### 返回数据的语句
```c
MYSQL_RES *mysql_store_result(MYSQL *connection);   //提取所有的数据
my_ulonglong mysql_num_rows(MYSQL_RES *result);     //返回结果集中的行数
MYSQL_ROW mysql_fetch_row(MYSQL_RES *result);       //从mysql_store_result的结果中提取一行，放入一个行结构中
void mysql_data_seek(MYSQL_RES *result, myulonglong offset);    //在结果集中跳转，设置被下一个mysql_fetch_row操作的返回的行
MYSQL_ROW_OFFSET mysql_row_tell(MYSQL_RES *result);     //返回一个偏移值，表示结果集中的当前位置
MYSQL_ROW_OFFSET mysql_row_seek(MYSQL_RES *result, MYSQL_ROW_OFFSET offset);        //在结果集中移动当前位置，返回之前位置
void mysql_free_result(MYSQL_RES *result);
MYSQL_RES *mysql_use_result(MYSQL *connection); //逐行提取数据，未提取的数据网络中
unsigned int mysql_field_count(MYSQL *connection);
MYSQL_FIELD *mysql_fetch_field(MYSQL_RES *result);
```


## 开发工具
### make
### makefile
### 后缀和模式规则
### makefile文件和子目录

## 调试
### 预处理&宏
### GDB调试

## 进程与信号
UNIX标准定义进程为：一个其中运行着一个或多个线程的地址空间和这些线程所需要的系统资源。
**启动新进程**
它必须用一个shell来启动程序，使用system函数的效率不高。
```c
#include<stdlib.h>
int system(const char *string);
```
### 替换进程映像exec系列函数
exec系列函数把当前进程替换为一个新进程。可以使用exec函数讲程序的执行从一个程序切换到另一个程序。exec函数比system函数更有效，新的程序启动后，原来的程序不再运行。
```c
#include<stdio.h>
char **environ;
int execl(const char *path, const char *arg0, ..., (char *)0);
int execlp(const char *file, const char *arg0, ..., (char *)0);
int execle(const char *path, const char *arg0, ..., (char *)0, char *const envp[]);
int execv(const char *path, char *const argv[]);
int execvp(const char *file, char *const argv[]);
int execve(const char *path, char *const argv[], char *const envp[]);
```
### 复制进程映像fork
```c
#include<sys/types.h>
#include<unistd.h>
pid_t fork(void);
pid_t new_pid;
new_pid = fork();
switch(new_pid)
{
        case -1:        //error
                break;
        case 0:         //child
                break;
        default :       //parent
                break;
}
```
**wait等待一个进程**
```c
#include<sys/types.h>
#include<sys/wait.h>
pid_t wait(int *stat_loc);
pid_t waitpid(pid_t pid, int *stat_loc, int options);
/*pid参数如果为-1，waitpid将返回任一子进程信息。*/
```
**僵尸进程**

子进程终止时，与父进程之间的关联还会保持，直到父进程也正常终止或父进程调用wait才结束。代表子进程的表项不会立刻释放，仍然存在于系统中，它的退出码仍然保存，此时它成为一个僵尸进程。

### 信号

信号是unix和linux系统响应某些条件而产生的一个事件。

**处理信号**
```c
#include<stdio.h>
void (*signal(int sig, void (*func)(int)))(int);
```

**发送信号**
```c
#include<sys/types.h>
#include<signal.h>
int kill(pid_t pid, int sig);   //成功0，失败-1

#include<unistd.h>
unsigned int alarm(unsigned int seconds); //定时发送SIGALRM信号

int pause(void);        //把程序挂起直到一个信号出现为止
```

**一个健壮的信号接口**
```c
#include<signal.h>
int sigaction(int sig, const struct sigaction *act, struct sigaction *oact);
```
sigaction结构成员
```c
void (*) (int) sa_handler       //函数指针，指向接收到信号sig时将被调用的信号处理函数。可以设置为SIG_IGN和SIG_DFL,分别表示忽略和恢复
sigset_t sa_mask                //信号集,加入到进程的信号屏蔽字段的
int sa_flags                    //
```
**信号集**
```c
#include<signal.h>

int sigaddset(sigset_t *set, int signo);        //增加给定的信号
int sigemptyset(sigset_t *set);         //将信号集初始化为空
int sigfillset(sigset_t *set);          //将信号集初始化为包含所有已定义的信号
int sigdelset(sigset_t *set, int signo);        //删除给定的信号
int sigismember(sigset_t *set, int signo);      //判断一个给定的信号是否是一个信号集的成员
int sigprocmask(int how, const sigset_t *set, sigset_t *oset);
int sigpending(sigset_t *set);
int sigsuspend(const sigset_t *sigmask);
```

## POSIX线程
线程是一个进程内部的一个控制序列。

当进程执行fork调用时，将创建出该进程的一个新副本。这个新进程拥有自己的变量和自己的PID，它的时间调度也是独立的，它的执行几乎完全独立于父进程。

当进程中创建一个新线程时，新的执行线程将拥有自己的栈(因此也有自己的局部变量),但与它的创建者共享全局变量、文件描述符、信号处理函数和当前的目录状态。

**_PEENTRANT**宏定义来告诉编译器我们需要可重入功能。

```c
#include<pthread.h>

int pthread_create(pthread_t *thread, pthread_attr_t *attr, void *(*start_routine)(void *), void *arg);
```
1. 第一个参数写入一个标识符来引用新线程
2. 第二个参数设置线程属性，一般不需要时设置为NULL
3. 第三个参数启动线程将要执行的函数
4. 第四个参数传递给执行函数的参数
成功返回0，失败返回错误代码。

```c
#include<pthread.h>
void pthread_exit(void *retval);        //终止调用它的线程

int pthread_join(pthread_t th, void **thread_return);   //第二个参数执行一个指针，它指向另一个指针，而后者指向线程的返回值。
```

检查头文件/usr/include/pthread.h。如果这个文件中显示的版权日期是2003年或更晚，那几乎可以肯定使用的是NPTL实现。
```c
gcc -D_REENTRANT -I /usr/include/nptl thread1.c -o thread1 -L /usr/lib/nptl -lpthread

//如果系统默认使用NPTL线程库，那么编译程序就无需加上-I和-L选项。
gcc -D_REENTRANT thread1.c -o thread1 -lpthread
```
### 同步
#### 信号量
```c
#include<semaphore.h>

int sem_init(sem_t *sem, int pshared, unsigned int value);      //pshared参数控制信号量的类型，如果为0，表示这个信号量是当前进程的局部信号量，否则，这个信号量就可以在多个进程之间共享。

//该指针指向的对象是sem_init调用初始化的信号量
int sem_wait(sem_t *sem);       //减1，它会等待信号量有个非零值才会开始减法操作。如果对值为0的信号量调用sem_wait，这个函数就会等待。
int sem_post(sem_t *sem);       //以原子操作的方式给信号量的值加1。
int sem_destroy(sem_t *sem);
```
#### 互斥量
```c
#include<pthread.h>

int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *mutexattr);

int pthread_mutex_lock(pthread_mutex_t *mutex);

int pthread_mutex_unlock(pthread_mutex_t *mutex);

int pthread_mutex_destroy(pthread_mutex_t *mutex);

//成功时返回0，失败时返回错误代码。
```
### 线程属性
```c
#include<pthread.h>
int pthread_attr_init(pthread_attr_t *attr);
```
**线程调度**

**取消线程**

**多线程**

## 进程间通信：管道
### 进程管道
```c
#include<stdio.h>
FILE *popen(const char *command, const char *open_mode);
int pclose(FILE *stream_to_close);
//调用popen函数返回FILE*文件指针流，之后就可以通过fread与fwrite函数来处理流
```
### 底层的pipe函数

这个函数在两个程序之间传递数据不需要启动一个shell来解释请求命令
```c
#include<unistd.h>
int pipe(int file_descriptor[2]);
//pipe函数的参数是一个由两个整数类型的文件描述符组成的整组的指针。
```
写入file_descriptor[1]的所有数据都可以从file_descriptor[0]读回来。

pipe使用的是文件描述符不是文件流，所有必须使用底层的read和write调用来访问数据。

### 命名管道(不先关的进程之间)
命令行上创建命名管道
```c
mknod filename p
mkfifo filename
```
程序中
```c
#include<sys/types.h>
#include<sys/stat.h>

int mkfifo(const char *filename, mode_t mode);
int mknod(const char *filename, mode_t mode | S_IFIFO, (dev_t) 0);

/*open调用将阻塞，除非有一个进程以写方式打开同一个FIFO，否则不会返回。*/
open(const char *path, O_RDONLY); 

/*即使没有其他进程以写方式打开FIFO，这个open调用也将成功并立刻返回。*/
open(const char *path, O_RDONLY|O_NONBLOCK);

/*open调用将阻塞，直到有一个进程以读方式打开同一个FIFO为止*/
open(const char *path, O_WRONLY);

/*立刻返回*/
open(const char *path, O_WRONLY|O_NONBLOCK);
```
## 信号量、共享内存和消息队列
### 信号量
```c
#include<sys/sem.h>

/*直接控制信号量信息*/
int semctl(int sem_id, int sem_num, int command, ...);
union semun{
        int val;
        struct semid_ds *buf;
        unsigned short *array;
}

/*创建一个新的信号量或取得一个已有信号量的键
num_sems参数指定需要的信号量数目，它几乎总是取值为1
成功时返回一个正数即其他信号量函数将用到的信号量标识符，失败返回-1*/
int semget(key_t key, int num_sems, int sem_flags);

/*用于改变信号量的值*/
int semop(int sem_id, struct sembuf *sem_ops, size_t num_sem_ops);
struct sembuf{
        short sem_num;
        short sem_op;
        short sem_flg;
}
```
### 共享内存
```c
#include<sys/shm.h>

/*刚创建共享内存时，不能被任何进程访问，shmat函数启用对该共享内存的访问，将其连接到一个进程的地址空间中。
第二个参数shm_addr指定共享内存连接到当前进程中的地址位置，一般是空指针，表示让系统来选择共享内存出现的地址。*/
void *shmat(int shm_id, const void *shm_addr, int shmflg);

/**/
int shmctl(int shm_id, int cmd, struct shmid_ds *buf);
struct shmid_ds{
        uid_t shm_perm.uid;
        uid_t shm_perm.gid;
        mode_t shm_perm.mode;
}

/*将共享内存从当前进程中分离。
成功返回0，失败返回-1。
分离并未删除，只是使得该共享内存对当前进程不再可用*/
int shmdt(const void *shm_addr);

/*创建共享内存
成功返回一个共享内存标识符
以字节为单位指定需要共享的内存容量*/
int shmget(key_t key, size_t size, int shmflg);
```

### 消息队列
```c
#include<sys/msg.h>

/**/
int msgctl(int msqid, int cmd, struct msqid_ds *buf);
struct msqid_ds{
        uid_t msg_perm.uid;
        uid_t msg_perm.gid;
        mode_t msg_perm.mode;
}

/*创建和访问一个消息队列
成功时msgget函数返回一个正整数，即标识符，失败返回-1*/
int msgget(key_t key, int msgflg);

/*从一个消息队列中获取消息*/
int msgrcv(int msqid, void *msg_ptr, size_t msg_sz, long int msgtype, int msgflg);

/*用来把消息添加到消息队列中*/
int msgsnd(int msqid, const void *msg_ptr, size_t msg_sz, int msgflg);
struct my_message{
        long int message_type;
        //data
}
```

## 套接字
套接字的3个属性：域(domain)、类型(type)、协议(protocol)。
```c
#include<sys/types.h>
#include<sys/socket.h>

int socket(int domain, int type, int protocol);
```
|域|说明|
|---|---|
|AF_UNIX|unix域协议(文件系统套接字)|
|AF_INET|ARPA因特网协议(UNIX网络套接字)|

type参数指定套接字的通信特性。它的取值包括SOCK_STREAM和SOCK_DGRAM。

AF_UNIX域套接字地址格式
```c
struct sockaddr_un{
        sa_family_t sun_family;
        char sun_path[];
}
```
AF_INET域套接字地址格式
```c
struct sockaddr_in{
        short int sin_family;
        unsigned short int sin_port;
        struct in_addr sin_addr;
}
struct in_addr{
        unsigned long int s_addr;
}
```
### 命名套接字
```c
#include<sys/socket.h>
/*bind系统调用把参数address中的地址分配给与文件描述符socket关联的未命名套接字成功时返回0，失败时返回-1*/
int bind(int socket, const struct sockaddr *address, size_t address_len);
```
### 创建套接字队列
```c
#include<sys/socket.h>
/*listen函数将队列长度设置为backlcg参数的值
成功返回0，失败返回-1*/
int listen(int socket, int backlog); 
```
### 接受连接
```c
#include<sys/socket.h>
int accept(int socket, struct sockaddr *address, size_t *address_len);
```
如果套接字队列中没有未处理的连接，accept将阻塞直到客户建立连接为止。可以通过对套接字文件秒速符设置标志来改变这一行为。
```c
int flags=fcntl(socket, F_GETFL, 0);
fcntl(socket, F_SETFL, O_NONBLOCK|flags);
```
### 请求连接
```c
#include<sys/socket.h>
int connect(int socket, const struct sockaddr *address, size_t address_len);    //成功返回0，失败-1
```
## 主机字节序和网络字节序
```c
#include<netinet/in.h>
unsigned long int htonl(unsigned long int hostlong);
unsigned short int htons(unsigned short int hostshort);
unsigned long int ntohl(unsigned long int netlong);
unsigned long int ntohs(unsigned short int netshort);
```
### 套接字选项
```c
#include<sys/socket.h>
int setsockopt(int socket, int level, int option_name, const void *option_value, size_t option_len);
```
### select系统调用
```c
#include<sys/types.h>
#include<sys/time.h>

void FD_ZERO(fd_set *fdset);    //将fd_set初始化为空集合
void FD_CLR(int fd, fd_set *fdset);     //设置由参数fd传递的文件描述符
void FD_SET(int fd, fd_set *fdset);     //清除由参数fd传递的文件描述符
int FD_ISSET(int fd, fd_set *fdset);    //参数fd指向的文件描述符是由参数fdset指向的fd_set集合中的一个元素，返回非零值。

struct timeval{
        time_t tv_sec;
        long tv_usec;
}       //设定超时值来防止无限期的阻塞

/*select调用用于测试文件描述符集合中，是否有一个文件描述符已处于可读状态或可写状态或错误状态，它将阻塞以等待某个文件描述符进入上述这些状态。*/
int select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *errorfds, struct timeval *timeout);
```
