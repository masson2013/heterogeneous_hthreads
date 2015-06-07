#ifndef _VAM_SYSCALL_H_
#define _VAM_SYSCALL_H_

#include <vam_common.h>
#include <vam_maze.h>
#include <hthread.h>

#define vam_do_syscall  _system_call_vamdler

#define SYSCALL_VAM_GET_PR                10
#define SYSCALL_VAM_SET_PR                11
#define SYSCALL_VAM_GET_BRAM              12
#define SYSCALL_VAM_DMA                   13
#define SYSCALL_VAM_ROUTE                 14
#define SYSCALL_VAM_CONNECT               15
#define SYSCALL_VAM_TABLE_SHOW            16
#define SYSCALL_VAM_START                 17
#define SYSCALL_VAM_DONE                  18
#define SYSCALL_VAM_CLEAN                 19
#define SYSCALL_VAM_TABLE_INIT            20
#define SYSCALL_VAM_SET_INDEX             21
#define SYSCALL_VAM_SET_SIZE              22
#define SYSCALL_VAM_SET_STRIDE            23
#define SYSCALL_VAM_BITSTREAM_TABLE_INIT  24


#define Little2Big32(A) ((((u32)(A) & 0xff000000) >> 24) | (((u32)(A) & 0x00ff0000) >> 8) | \
             (((u32)(A) & 0x0000ff00) << 8) | (((u32)(A) & 0x000000ff) << 24))
#define XHI_EVEN_MAGIC_BYTE     0x0f
#define XHI_ODD_MAGIC_BYTE      0xf0
// #define XHI_OP_IDLE  -1
#define XHI_BIT_HEADER_FAILURE -1
// #define XHI_MLR                  15

typedef struct{
  u32 *BitAddr[ROW * COL];
}vam_Bitstream_table_item;

typedef struct{
  int bitsize;
  Huint t_start;
  Huint t_end;
  u8 *BitName;
  vam_Bitstream_table_item item[20];
}vam_Bitstream_table_t;

typedef struct
{
    u32  HeaderLength;     /* Length of header in 32 bit words */
    u32 BitstreamLength;  /* Length of bitstream to read in bytes*/
    u8 *DesignName;       /* Design name read from bitstream header */
    u8 *PartName;         /* Part name read from bitstream header */
    u8 *Date;             /* Date read from bitstream header */
    u8 *Time;             /* Bitstream creation time read from header */
    u32 MagicLength;      /* Length of the magic numbers in header */
} XHwIcap_Bit_Header;

#define XHwIcap_mGetType(Header) ((Header >> XHI_TYPE_SHIFT) & XHI_TYPE_MASK)
#define XHwIcap_mGetOp(Header) ((Header >> XHI_OP_SHIFT) & XHI_OP_MASK)
#define XHwIcap_mGetRegister(Header) ((Header >> XHI_REGISTER_SHIFT) & XHI_REGISTER_MASK)
#define XHwIcap_mGetWordCountType1(Header) (Header & XHI_WORD_COUNT_MASK_TYPE_1)
#define XHwIcap_mGetWordCountType2(Header) (Header & XHI_WORD_COUNT_MASK_TYPE_2)

void* _system_call_vamdler(Huint c, void *p2, void *p3, void *p4, void *p5, void *p6, void *p7, void *p8);
Hint _VAM_TABLE_INIT(vam_table_t *VAM_TABLE);
// Hint _VAM_BITSTREAM_TABLE_INIT(vam_Bitstream_table_t *BITSTREAM_TABLE, int *nSlave);
Hint _VAM_GET_PR(vam_table_t *VAM_TABLE, int *nPR);
Hint _VAM_SET_PR(XTmrCtr *timer, XHwIcap *icap, hthread_mutex_t *mutex, vam_Bitstream_table_t *BITSTREAM_TABLE, int *nPR, int *nFunctor);
Hint _VAM_GET_BRAM(vam_table_t *VAM_TABLE, int *nPR, u32 *BRAMList, int *nIN, int *InSize, int *nOUT, int *OutSize);
Hint _VAM_TABLE_SHOW(vam_table_t *VAM_TABLE, int *index);
Hint _VAM_ROUTE(vam_table_t *VAM_TABLE, int *PR, int *nPR);
Hint _VAM_CONNECT(vam_table_t *VAM_TABLE);
Hint _VAM_SET_INDEX(vam_table_t *VAM_TABLE, int *nPR, int *type, int *para);
Hint _VAM_SET_SIZE(vam_table_t *VAM_TABLE, int *nPR, int *type, int *para);
Hint _VAM_SET_STRIDE(vam_table_t *VAM_TABLE, int *nPR, int *type, int *para);
Hint _VAM_CLEAN(vam_table_t *VAM_TABLE);
Hint _VAM_DMA(XAxiCdma *InstancePtr, u32 *SrcAddr, u32 *DstAddr, int *byte_Length);
Hint XAxiCdma_Initialize    (XAxiCdma * InstancePtr, u16 DeviceId);
Hint XAxiCdma_Transfer      (XAxiCdma *InstancePtr, u32 SrcAddr, u32 DstAddr, int byte_Length,
                                XAxiCdma_CallBackFn SimpleCallBack, void *CallbackRef);
Hint VAM_PR_INIT(u8 *PR_BIT, u32 *HeaderLength, u32 *BitstreamLength);
Hint VAM_Do_PR(XHwIcap *icap, u32 *PR_BIT, u32 BitstreamLength);
Hint xhwicap_initialize(XHwIcap * instanceptr);

XHwIcap_Bit_Header XHwIcap_ReadHeader(u8 *Data, u32 Size);

#endif
