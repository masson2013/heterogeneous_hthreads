#ifndef _VAM_MAZE_H_
#define _VAM_MAZE_H_

#include <vam_common.h>

#define stack_init_size 200
#define stack_increment 10
#define OVERFLOW 0
#define OK 1
#define ERROR 0
#define TRUE 1
#define FALSE 0
typedef int Status;
#define MAZE_PASSED 3
#define MAZE_BLOACKED 7

#define MROW ROW+2
#define MCOL COL+2

typedef struct{
  int x;
  int y;
}PosType;

typedef struct {
  int ord;      // The Step number
  PosType seat; // The Position (x,y)
  int di;       // The Direction of next step
}SElemType;

typedef struct{
  SElemType *base;
  SElemType *top;
  int stacksize;
}SqStack;

Hint    InitStack     (SqStack *s, SElemType *Static_Stack);
Hint    Push          (SqStack *s, SElemType e);
Hint    Pop           (SqStack *s, SElemType *e);
Hint    StackEmpty    (SqStack *s);
Hint    Pass          (int mg[][MCOL], PosType e);
PosType NextPos       (PosType *Cur, int dir);
Hint    FootPrint     (int mg[][MCOL], PosType e, int type);
void    VAM_MAZE_SHOW (int maze[][MCOL]);
Hint    VAM_WIRED     (vam_table_t *VAM_TABLE, SElemType Pos1, SElemType Pos2) ;
Hint    VAM_MAZE_PATH (int mg[][MCOL], PosType start, PosType end, SqStack *s);
Hint    VAM_MAZE      (vam_table_t *VAM_TABLE, int Start, int End);

#endif
