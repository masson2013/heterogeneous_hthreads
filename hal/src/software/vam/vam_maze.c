#include <vam_maze.h>


//Build an empty stack
Hint InitStack(SqStack *s, SElemType *Static_Stack) {
  s->base = Static_Stack;
  //s->base =(SElemType *)malloc(stack_init_size * sizeof(SElemType));
  if(!s->base) return FAILURE;
  s->top=s->base;
  s->stacksize=stack_init_size;
  return SUCCESS;
}

//Push the element into the stack
Hint Push(SqStack *s,SElemType e) {
  if(s->top-s->base>=s->stacksize){
    s->base=(SElemType *)realloc(s->base,(s->stacksize+stack_increment) *sizeof(SElemType));
  if(!s->base) return FAILURE;
  s->top=s->base+s->stacksize;
  s->stacksize+=stack_increment;
  }
  *s->top++=e;
  return OK;
}

//Pop an element out of the stack
Hint Pop(SqStack *s,SElemType *e) {
  if(s->top==s->base)
    return ERROR;
  *e=*--s->top;
  return OK;
}

//Check the stack is empty or not
Hint StackEmpty(SqStack *s) {
  if (s->top==s->base)
    return OK;
  return OVERFLOW;
}

//Is Pos can be passed
Hint Pass(int mg[][MCOL], PosType e) {
  if (mg[e.x][e.y]==0)  // zero can pass
    return OK;      // return OK if can pass
  return OVERFLOW;    // other case return failed
}

//Next step
PosType NextPos(PosType *Cur, int dir) {
  PosType Next;
  switch(dir) {
    case 1:Next.x = Cur->x;    //EAST
         Next.y = Cur->y+1;
         break;
    case 2:Next.x = Cur->x+1;  //SOUTH
         Next.y = Cur->y;
         break;
      case 3:Next.x = Cur->x;    //WEST
         Next.y = Cur->y-1;
         break;
    case 4:Next.x = Cur->x-1;  //NORTH
         Next.y = Cur->y;
         break;
  }
  return Next;
}

//Leave the footprint
Hint FootPrint(int mg[][MCOL], PosType e, int type) {
  mg[e.x][e.y] = type;
  return OK;
}

void VAM_MAZE_SHOW(int maze[][MCOL]) {
  int i;
  int j;
  for (i = 0; i < MROW; i++) {
    for (j = 0; j < MCOL; j++) {
      xil_printf("%d\t", maze[i][j]);
    }
    xil_printf("\r\n");
  }

}

Hint VAM_WIRED(vam_table_t *VAM_TABLE, SElemType Pos1, SElemType Pos2) {
  int Start = (Pos1.seat.x - 1) * COL + (Pos1.seat.y -1);
  int End   = (Pos2.seat.x - 1) * COL + (Pos2.seat.y -1);

  //cout << "Start: " << Start << ", " << "End: " << End << endl;

  VAM_TABLE->item[End].Status = PRBUSY;
  switch (Pos1.di) {
    // EAST
    case 1: {
      if (VAM_TABLE->item[Start].DES == -1) VAM_TABLE->item[Start].DES = EAST;
      if (VAM_TABLE->item[End].SRC   == -1) VAM_TABLE->item[End].SRC   = WEST;
      if (VAM_TABLE->item[End].AccType == PRPASS) {
        if (VAM_TABLE->item[End].nBRAM == 0) {
          VAM_TABLE->item[End].ACC1 = WEST;
        }
        else {
          VAM_TABLE->item[End].ACC2 = WEST;
        }
      }
      // VAM_TABLE->item[Start].OUT1_Direction    = EAST;
      // if (VAM_TABLE->item[End].IN1_Direction     == -1) {
      //   VAM_TABLE->item[End].IN1_Direction    = WEST;
      //   if (VAM_TABLE->item[Start].OUT1_Size   == 0 && VAM_TABLE->item[End].IN1_Size != 0) {
      //     VAM_TABLE->item[Start].OUT1_Size   = VAM_TABLE->item[End].IN1_Size;
      //   }
      //   else {
      //     VAM_TABLE->item[End].IN1_Size     = VAM_TABLE->item[Start].OUT1_Size;
      //   }
      // }
      // else {
      //   VAM_TABLE->item[End].IN2_Direction    = WEST;
      //   if (VAM_TABLE->item[Start].OUT1_Size   == 0 && VAM_TABLE->item[End].IN2_Size != 0) {
      //     VAM_TABLE->item[Start].OUT1_Size   = VAM_TABLE->item[End].IN2_Size;
      //   }
      //   else {
      //     VAM_TABLE->item[End].IN2_Size     = VAM_TABLE->item[Start].OUT1_Size;
      //   }
      // }
    }break;

    // SOUTH
    case 2: {
      if (VAM_TABLE->item[Start].DES == -1) VAM_TABLE->item[Start].DES = SOUTH;
      if (VAM_TABLE->item[End].SRC   == -1) VAM_TABLE->item[End].SRC   = NORTH;
      if (VAM_TABLE->item[End].AccType == PRPASS) {
        if (VAM_TABLE->item[End].nBRAM == 0) {
          VAM_TABLE->item[End].ACC1 = NORTH;
        }
        else {
          VAM_TABLE->item[End].ACC2 = NORTH;
        }
      }
      // VAM_TABLE->item[Start].OUT1_Direction     = SOUTH;
      // if (VAM_TABLE->item[End].IN1_Direction     == -1) {
      //   VAM_TABLE->item[End].IN1_Direction    = NORTH;
      //   if (VAM_TABLE->item[Start].OUT1_Size   == 0 && VAM_TABLE->item[End].IN1_Size != 0) {
      //     VAM_TABLE->item[Start].OUT1_Size   = VAM_TABLE->item[End].IN1_Size;
      //   }
      //   else {
      //     VAM_TABLE->item[End].IN1_Size     = VAM_TABLE->item[Start].OUT1_Size;
      //   }
      // }
      // else {
      //   VAM_TABLE->item[End].IN2_Direction    = NORTH;
      //   if (VAM_TABLE->item[Start].OUT1_Size   == 0 && VAM_TABLE->item[End].IN2_Size != 0) {
      //     VAM_TABLE->item[Start].OUT1_Size   = VAM_TABLE->item[End].IN2_Size;
      //   }
      //   else {
      //     VAM_TABLE->item[End].IN2_Size     = VAM_TABLE->item[Start].OUT1_Size;
      //   }
      // }
    }break;

    // WEST
    case 3: {
      if (VAM_TABLE->item[Start].DES == -1) VAM_TABLE->item[Start].DES = WEST;
      if (VAM_TABLE->item[End].SRC   == -1) VAM_TABLE->item[End].SRC   = EAST;
      if (VAM_TABLE->item[End].AccType == PRPASS) {
        if (VAM_TABLE->item[End].nBRAM == 0) {
          VAM_TABLE->item[End].ACC1 = EAST;
        }
        else {
          VAM_TABLE->item[End].ACC2 = EAST;
        }
      }
      // VAM_TABLE->item[Start].OUT1_Direction     = WEST;
      // if (VAM_TABLE->item[End].IN1_Direction     == -1) {
      //   VAM_TABLE->item[End].IN1_Direction    = EAST;
      //   if (VAM_TABLE->item[Start].OUT1_Size   == 0 && VAM_TABLE->item[End].IN1_Size != 0) {
      //     VAM_TABLE->item[Start].OUT1_Size   = VAM_TABLE->item[End].IN1_Size;
      //   }
      //   else {
      //     VAM_TABLE->item[End].IN1_Size     = VAM_TABLE->item[Start].OUT1_Size;
      //   }
      // }
      // else {
      //   VAM_TABLE->item[End].IN2_Direction     = EAST;
      //   if (VAM_TABLE->item[Start].OUT1_Size   == 0 && VAM_TABLE->item[End].IN2_Size != 0) {
      //     VAM_TABLE->item[Start].OUT1_Size   = VAM_TABLE->item[End].IN2_Size;
      //   }
      //   else {
      //     VAM_TABLE->item[End].IN2_Size     = VAM_TABLE->item[Start].OUT1_Size;
      //   }
      // }
    }break;

    // NORTH
    case 4: {
      if (VAM_TABLE->item[Start].DES == -1) VAM_TABLE->item[Start].DES = NORTH;
      if (VAM_TABLE->item[End].SRC   == -1) VAM_TABLE->item[End].SRC   = SOUTH;
      if (VAM_TABLE->item[End].AccType == PRPASS) {
        if (VAM_TABLE->item[End].nBRAM == 0) {
          VAM_TABLE->item[End].ACC1 = SOUTH;
        }
        else {
          VAM_TABLE->item[End].ACC2 = SOUTH;
        }
      }
      // VAM_TABLE->item[Start].OUT1_Direction     = NORTH;
      // if (VAM_TABLE->item[End].IN1_Direction     == -1) {
      //   VAM_TABLE->item[End].IN1_Direction    = SOUTH;
      //   if (VAM_TABLE->item[Start].OUT1_Size   == 0 && VAM_TABLE->item[End].IN1_Size != 0) {
      //     VAM_TABLE->item[Start].OUT1_Size   = VAM_TABLE->item[End].IN1_Size;
      //   }
      //   else {
      //     VAM_TABLE->item[End].IN1_Size     = VAM_TABLE->item[Start].OUT1_Size;
      //   }
      // }
      // else {
      //   VAM_TABLE->item[End].IN2_Direction    = SOUTH;
      //   if (VAM_TABLE->item[Start].OUT1_Size   == 0 && VAM_TABLE->item[End].IN1_Size != 0) {
      //     VAM_TABLE->item[Start].OUT1_Size   = VAM_TABLE->item[End].IN1_Size;
      //   }
      //   else {
      //     VAM_TABLE->item[End].IN1_Size     = VAM_TABLE->item[Start].OUT1_Size;
      //   }
      // }
    }break;

    default: {

    }break;
  }

  //  if (VAM_TABLE->item[Start].OUT1_AccType == BYPASS) {
  //   if (VAM_TABLE->item[Start].OUT1_Size   == 0 && VAM_TABLE->item[End].IN1_Size != 0) {
  //     VAM_TABLE->item[Start].OUT1_Size   = VAM_TABLE->item[End].IN1_Size;
  //   }
  //   else {
  //     VAM_TABLE->item[End].IN1_Size     = VAM_TABLE->item[Start].OUT1_Size;
  //   }
  //   VAM_TABLE->item[Start].IN1_Size = VAM_TABLE->item[Start].OUT1_Size;
  //    //VAM_TABLE->item[End].OUT1_Size = VAM_TABLE->item[End].IN1_Size;
  //  }
  return SUCCESS;
}

Hint VAM_MAZE_PATH(int mg[][MCOL], PosType start, PosType end, SqStack *s) {
  PosType curpos;
  int Status;

  SElemType Static_Stack[20]; // 20 is the MAX depth of stack. Change later if need.
  Status = InitStack(s, Static_Stack);
  if (Status != SUCCESS) {putnum(0xdead000C); return FAILURE;}
  SElemType e;
  int curstep;

  curpos  = start;  // Set the start as the current step
  curstep = 0;    // Step Counter

  do {
    // If the current pos can be passed
    if (Pass(mg, curpos)) {
      //Leave Foot Print
      FootPrint(mg, curpos, MAZE_PASSED);
      e.di   = 1; // Direction
      e.ord  = curstep;
      e.seat = curpos;
      Push(s,e); // Push to stack
      if (curpos.x == end.x && curpos.y == end.y) {
        // Touch Down! Reach the Des
        return SUCCESS;
      }
      curpos = NextPos(&curpos, 1);
      curstep++;
    }
    else {
      if (!StackEmpty(s)) {
        Pop(s, &e);
        while (e.di == 4 && !StackEmpty(s)) {
          FootPrint(mg, e.seat, MAZE_BLOACKED);
          Pop(s, &e);
        }
        if (e.di < 4) {
          e.di++;
          Push(s, e);
          curpos = NextPos(&e.seat, e.di);
        }
      }
    }
  }while (!StackEmpty(s));
  return FAILURE;
}

Hint VAM_MAZE(vam_table_t *VAM_TABLE, int Start, int End) {
  int Status;
  SqStack S;
  PosType Src, Des;

  Src.x = VAM_TABLE->item[Start].x;
  Src.y = VAM_TABLE->item[Start].y;
  Des.x = VAM_TABLE->item[End].x;
  Des.y = VAM_TABLE->item[End].y;

  int maze[MROW][MCOL];
  int i;
  int j;
  for (i = 0; i < MROW; i++) {
    for (j = 0; j < MCOL; j++) {
      if (i == 0 || j == 0 || i == MROW - 1 || j == MCOL - 1) {
        maze[i][j] = 1;
      }
      else if (i == Src.x && j == Src.y) {
        maze[i][j] = 0;
      }
      else if (i == Des.x && j == Des.y) {
        maze[i][j] = 0;
      }
      else {
        maze[i][j] = VAM_TABLE->item[(i - 1) * COL + (j - 1)].Status;
      }
    }
  }

  Status = VAM_MAZE_PATH(maze, Src, Des, &S);
  if (Status != SUCCESS) {return FAILURE;}

  SElemType Pos1;
  SElemType Pos2;
  Pop(&S, &Pos2);
  int tmpPR;
  tmpPR = (Pos2.seat.x - 1) * COL + (Pos2.seat.y -1);
  VAM_TABLE->item[tmpPR].NewWired = 1;

  do {
    Pop(&S, &Pos1);
    tmpPR = (Pos1.seat.x - 1) * COL + (Pos1.seat.y -1);
    VAM_TABLE->item[tmpPR].NewWired = 1;
    // xil_printf("Pos1: (%d, %d) -> (%d, %d) \r\n", Pos1.seat.x, Pos1.seat.y, Pos2.seat.x, Pos2.seat.y);

    VAM_WIRED(VAM_TABLE, Pos1, Pos2);

    Pos2 = Pos1;
  }while (!StackEmpty(&S));

  return SUCCESS;
}
