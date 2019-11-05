## queue

queue 可以用 list 和 deque 实现，默认情况下用 deque 实现。

```c++
template < class T, class Cont = deque<T> >
class queue{
    ...
};
```

## priority_queue
priority_queue 是“优先队列”。它和普通队列的区别在于，优先队列的队头元素总是最大的——即执行 pop 操作时，删除的总是最大的元素；执行 top 操作时，返回的是最大元素的引用。

```c++
template < class T, class Container = vector <T>, class Compare = less<T> >
class priority_queue{
    ...
};
```