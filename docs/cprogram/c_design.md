## 状态模式
```c
typedef struct State{
    const struct State *(* const stop)(const struct State *pThis);
    const struct State *(* const playOrPause)(const struct State *pThis);
}State;

void initialize();
void onStop();
void onPlayOrPause();

static const State *pCurrentState;

static const State *ignore(const State *pThis);
static const State *startPlay(const State *pThis);
static const State *stopPlay(const State *pThis);
static const State *pausePlay(const State *pThis);
static const State *resumePlay(const State *pThis);

static const State IDLE = {
    ignore,
    startPlay
};

static const State PLAY = {
    stopPlay,
    pausePlay
};

static const State PAUSE = {
    stopPlay,
    resumePlay
};

void initialize(){
    pCurrentState = &IDLE;
}

void onStop(){
    pCurrentState = pCurrentState->stop(pCurrentState);
}

void onPlayOrPause(){
    pCurrentState = pCurrentState->playOrPause(pCurrentState);
}

static const State *ignore(const State *pThis){
    return pCurrentState;
}

static const State *stopPlay(const State *pThis){
    return &IDLE;
}

static const State *pausePlay(const State *pThis){
    return &PAUSE;
}

static const State *resumePlay(const State *pThis){
    return &PLAY;
}

static const State *startPlay(const State *pThis){
    return &PLAY;
}

```
## 模版方法模式
```c

```
## 观察者模式

## 职责链模式

## 访问者模式