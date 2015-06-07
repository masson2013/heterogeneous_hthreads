#ifndef _VAM_H_
#define _VAM_H_
#include <vam_common.h>
#include <vam_syscall.h>


//////////////////////////////

Hint VAM_TABLE_INIT           (vam_table_t *VAM_TABLE);
Hint VAM_TABLE_SHOW           (vam_table_t VAM_TABLE, int index);
Hint VAM_GET_PR               (vam_table_t *VAM_TABLE, int *nPR);
Hint VAM_SET_PR               (XTmrCtr *timer, XHwIcap *icap, hthread_mutex_t *mutex, vam_Bitstream_table_t *BITSTREAM_TABLE, int nPR, int nFunctor);
Hint VAM_GET_BRAM             (vam_table_t *VAM_TABLE, int nPR, u32 BRAMList[], int nIN, int InSize, int nOUT, int OutSize);
Hint VAM_ROUTE                (vam_table_t *VAM_TABLE, int PR[], int nPR);
Hint VAM_SET_INDEX            (vam_table_t *VAM_TABLE, int nPR, int type, int para);
Hint VAM_SET_SIZE             (vam_table_t *VAM_TABLE, int nPR, int type, int para);
Hint VAM_SET_STRIDE           (vam_table_t *VAM_TABLE, int nPR, int type, int para);
Hint VAM_START                (int PR[], int nPR);
Hint VAM_DONE                 (int PR[], int nPR);
Hint VAM_CLEAN                (vam_table_t *VAM_TABLE);
Hint VAM_DMA                  (XAxiCdma *InstancePtr,  u32 SrcAddr, u32 DstAddr, int byte_Length);
// Hint VAM_BITSTREAM_TABLE_INIT (vam_Bitstream_table_t *BITSTREAM_TABLE, int nSlave);
#endif
