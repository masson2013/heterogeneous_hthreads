#ifndef _VAM_COMMON_H_
#define _VAM_COMMON_H_

#include <stdio.h>
#include <stdlib.h>
#include <htconst.h>
#include <httype.h>
#include <xstatus.h>
#include <xtmrctr.h>
#include "fsl.h"
#include "xaxicdma.h"
#include "xhwicap_l.h"
#include "xhwicap_i.h"
#include "xhwicap.h"

#define ROW 2
#define COL 2

#define BLIST {{0xE0000000, 0xE1000000, NORTH, WEST},{0xE2000000, 0xE3000000, NORTH, EAST},{0xE4000000, 0xE5000000, SOUTH, WEST},{0xE6000000, 0xE7000000, SOUTH, EAST}};
// #define BLIST {{0xE0000000, 0xE1000000, NORTH, WEST},{0xE2000000, 0x00000000, NORTH, 0},{0xE3000000, 0x00000000, NORTH, 0},{0xE4000000, 0xE5000000, NORTH, EAST},{0xE6000000, 0xE7000000, SOUTH, WEST},{0xE8000000, 0x00000000, SOUTH, 0},{0xE9000000, 0x00000000, SOUTH, 0},{0xEA000000, 0xEB000000, SOUTH, EAST}};

#define VMUL        0
#define VADD        1
#define VSUB        2
#define REDUCE      3
#define VMREDUCE    4
#define VADDREDUCE  5
#define VSUBREDUCE  6
#define ACCMM       7
#define ACCMMM      8
#define fAVG        9
#define fSVSUB      10
#define fVPOWER     11
#define fINNER      12

#define PRFREE 0
#define PRBUSY 1

#define NORTH   1
#define EAST    2
#define SOUTH   3
#define WEST    4

#define NA      -1
#define IN1      0
#define IN2      1
#define OUT1    2
#define OUT2    5
// #define BRAM    33
#define BRAMTYPE  3
#define SP      4
#define SPTYPE    4
#define PRPASS    5
#define BYPASS    6

typedef struct{
  u8    *Bitstream;
  char   Status;
  char   nBRAM;
  char   x;
  char   y;
  u32    BRAM1;
  u32    BRAM2;
  u32    BRAM1_DIR;
  u32    BRAM2_DIR;
  char   NewWired;
  char   AccType;
  char   ACC1;
  char   ACC2;
  char   SRC;
  char   DES;
  char   B1_WR;
  int    B1_StartIndex;
  int    B1_Size;
  int    B1_Stride;
  char   B2_WR;
  int    B2_StartIndex;
  int    B2_Size;
  int    B2_Stride;
}vam_table_item;

// typedef struct{
//   u8    *Bitstream;
//   int    Status;
//   int    nBRAM;
//   int    x;
//   int    y;
//   u32    BRAM1;
//   u32    BRAM2;
//   u32    BRAM1_DIR;
//   u32    BRAM2_DIR;
//   int    NewWired;
//   int    IN1_AccType;
//   int    IN1_Direction;
//   int    IN1_PortType;
//   int    IN1_StartIndex;
//   int    IN1_Size;
//   u32    IN1_BRAM;
//   int    IN2_AccType;
//   int    IN2_Direction;
//   int    IN2_PortType;
//   int    IN2_StartIndex;
//   int    IN2_Size;
//   u32    IN2_BRAM;
//   int    OUT1_AccType;
//   int    OUT1_Direction;
//   int    OUT1_PortType;
//   int    OUT1_StartIndex;
//   int    OUT1_Size;
//   u32    OUT1_BRAM;
// }vam_table_item;

typedef struct{
  vam_table_item item[ROW * COL];
}vam_table_t;

#endif
