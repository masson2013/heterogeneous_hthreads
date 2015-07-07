#include <vam.h>


Hint VAM_TABLE_INIT(vam_table_t *VAM_TABLE)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_TABLE_INIT,
                           (void*) VAM_TABLE,
                           NULL,
                           NULL,
                           NULL,
                           NULL,
                           NULL,
                           NULL);
}

// Hint VAM_BITSTREAM_TABLE_INIT(vam_Bitstream_table_t *BITSTREAM_TABLE, int nSlave)
// {
//   return (Hint)vam_do_syscall(SYSCALL_VAM_BITSTREAM_TABLE_INIT,
//                            (void*) BITSTREAM_TABLE,
//                            (int *) &nSlave,
//                            NULL,
//                            NULL,
//                            NULL,
//                            NULL,
//                            NULL);
// }


Hint VAM_TABLE_SHOW(vam_table_t VAM_TABLE, int index)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_TABLE_SHOW,
                           (void*) &VAM_TABLE,
                           (void*) &index,
                           NULL,
                           NULL,
                           NULL,
                           NULL,
                           NULL);
}

Hint VAM_GET_PR(vam_table_t *VAM_TABLE, int *nPR)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_GET_PR,
                           (void*) VAM_TABLE,
                           (void*) nPR,
                           NULL,
                           NULL,
                           NULL,
                           NULL,
                           NULL);
}

Hint VAM_GET_BRAM(vam_table_t *VAM_TABLE, int nPR, u32 BRAMList[], int nIN, int InSize, int nOUT, int OutSize)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_GET_BRAM,
                           (void*) VAM_TABLE,
                           (void*) &nPR,
                           (void*) BRAMList,
                           (void*) &nIN,
                           (void*) &InSize,
                           (void*) &nOUT,
                           (void*) &OutSize);
}

Hint VAM_ROUTE(vam_table_t *VAM_TABLE, int PR[], int nPR)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_ROUTE,
                           (void*) VAM_TABLE,
                           (void*) PR,
                           (void*) &nPR,
                           NULL,
                           NULL,
                           NULL,
                           NULL);
}

Hint VAM_START(int PR[], int nPR)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_START,
                           (void*) PR,
                           (void*) &nPR,
                           NULL,
                           NULL,
                           NULL,
                           NULL,
                           NULL);
}

Hint VAM_DONE(int PR[], int nPR)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_DONE,
                           (void*) PR,
                           (void*) &nPR,
                           NULL,
                           NULL,
                           NULL,
                           NULL,
                           NULL);
}

Hint VAM_CLEAN(vam_table_t *VAM_TABLE)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_CLEAN,
                           (void*) VAM_TABLE,
                           NULL,
                           NULL,
                           NULL,
                           NULL,
                           NULL,
                           NULL);
}

Hint VAM_SET_INDEX(vam_table_t *VAM_TABLE, int nPR, int type, int para)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_SET_INDEX,
                           (void*) VAM_TABLE,
                           (void*) &nPR,
                           (void*) &type,
                           (void*) &para,
                           NULL,
                           NULL,
                           NULL);
}


Hint VAM_SET_SIZE(vam_table_t *VAM_TABLE, int nPR, int type, int para)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_SET_SIZE,
                           (void*) VAM_TABLE,
                           (void*) &nPR,
                           (void*) &type,
                           (void*) &para,
                           NULL,
                           NULL,
                           NULL);
}


Hint VAM_SET_STRIDE(vam_table_t *VAM_TABLE, int nPR, int type, int para)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_SET_STRIDE,
                           (void*) VAM_TABLE,
                           (void*) &nPR,
                           (void*) &type,
                           (void*) &para,
                           NULL,
                           NULL,
                           NULL);
}


Hint VAM_DMA (XAxiCdma *InstancePtr,  u32 SrcAddr, u32 DstAddr, int byte_Length)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_DMA,
                           (void*) InstancePtr,
                           (void*) &SrcAddr,
                           (void*) &DstAddr,
                           (void*) &byte_Length,
                           NULL,
                           NULL,
                           NULL);
}

Hint VAM_SET_PR (XTmrCtr *timer, XHwIcap *icap, hthread_mutex_t *mutex, vam_Bitstream_table_t *BITSTREAM_TABLE, int nPR, int nFunctor)
{
  return (Hint)vam_do_syscall(SYSCALL_VAM_SET_PR,
                           (void*) timer,
                           (void*) icap,
                           (void*) mutex,
                           (void*) BITSTREAM_TABLE,
                           (void*) &nPR,
                           (void*) &nFunctor,
                           NULL);
}

// Hint VAM_CONNECT(vam_table_t *VAM_TABLE)
// {
//   return (Hint)vam_do_syscall(SYSCALL_VAM_CONNECT,
//                            (void*) VAM_TABLE,
//                            NULL,
//                            NULL,
//                            NULL,
//                            NULL,
//                            NULL,
//                            NULL);
// }



















