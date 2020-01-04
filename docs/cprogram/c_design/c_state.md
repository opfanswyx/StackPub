```c
#ifndef _CDPLAYER_H_
#define _CDPLAYER_H_

#ifdef __cplusplus
extern "C" {
#endif

/* 状态结构内部持有两个函数指针 */
typedef struct _State {
    const struct _State *(*stop)(const struct _State *pThis);   /* 停止 */
    const struct _State *(*playOrPause)(const struct _State \
        *This); /* 播放/暂停 */
} State;

void initialize();
void onStop();
void onPlayOrPause();

// for test
extern int cmdIdx;
extern const char *buf[10];

#ifdef __cplusplus
}
#endif

#endif
```


```c
#include <stdbool.h>
#include "cdplayer.h"

static const State *pCurrentState;

static const State *ignore(const State *pThis);
static const State *startPlay(const State *pThis);
static const State *stopPlay(const State *pThis);
static const State *pausePlay(const State *pThis);
static const State *resumePlay(const State *pThis);

const State IDLE = {
    ignore,
    startPlay
};

const State PLAY = {
    stopPlay,
    pausePlay
};

const State PAUSE = {
    stopPlay,
    resumePlay
};

int cmdIdx = 0;
const char *buf[10];

void initialize() {
    cmdIdx = 0;
    pCurrentState = &IDLE;
}

void onStop() {
    pCurrentState = pCurrentState->stop(pCurrentState);
}

void onPlayOrPause() {
    pCurrentState = pCurrentState->playOrPause(pCurrentState);
}

static const State *ignore(const State *pThis) {
    return pCurrentState;
}

static const State *stopPlay(const State *pThis) {
    buf[cmdIdx++] = "stop";
    return &IDLE;
}

static const State *pausePlay(const State *pThis) {
    buf[cmdIdx++] = "pause";
    return &PAUSE;
}

static const State *resumePlay(const State *pThis) {
    buf[cmdIdx++] = "resume";
    return &PLAY;
}

static const State *startPlay(const State *pThis) {
    buf[cmdIdx++] = "start";
    return &PLAY;
}
```