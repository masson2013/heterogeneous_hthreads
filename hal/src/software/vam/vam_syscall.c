
#include <vam_syscall.h>
// #include <vam_maze.h>

void* _system_call_vamdler(Huint c,
                          void *p2,
                          void *p3,
                          void *p4,
                          void *p5,
                          void *p6,
                          void *p7,
                          void *p8)
{
  void *ret;

  switch( c )
  {

    case SYSCALL_VAM_GET_PR   : {
      ret = (void*)_VAM_GET_PR((vam_table_t*) p2, (int*) p3);
    }break;

    case SYSCALL_VAM_SET_PR   : {
      ret = (void*)_VAM_SET_PR((XTmrCtr*) p2,
                               (XHwIcap*) p3,
                               (hthread_mutex_t*) p4,
                               (vam_Bitstream_table_t*) p5,
                               (int*) p6,
                               (int*) p7);
    }break;

    case SYSCALL_VAM_GET_BRAM : {
      ret = (void*)_VAM_GET_BRAM((vam_table_t*) p2,
                                 (int*) p3,
                                 (u32*) p4,
                                 (int*) p5,
                                 (int*) p6,
                                 (int*) p7,
                                 (int*) p8);
    }break;

    case SYSCALL_VAM_DMA      : {
      ret = (void*)_VAM_DMA((XAxiCdma *) p2,
                            (u32 *) p3,
                            (u32 *) p4,
                            (int *) p5);
    }break;

    case SYSCALL_VAM_ROUTE    : {
      ret = (void*)_VAM_ROUTE((vam_table_t*) p2, (int *) p3, (int *) p4);
    }break;

    case SYSCALL_VAM_CONNECT  : {
      // ret = (void*)_VAM_CONNECT();
    }break;

    case SYSCALL_VAM_SET_INDEX: {
      ret = (void*)_VAM_SET_INDEX((vam_table_t*) p2, (int *) p3, (int *) p4, (int *) p5);
    }break;

    case SYSCALL_VAM_SET_SIZE: {
      ret = (void*)_VAM_SET_SIZE((vam_table_t*) p2, (int *) p3, (int *) p4, (int *) p5);
    }break;

    case SYSCALL_VAM_SET_STRIDE: {
      ret = (void*)_VAM_SET_STRIDE((vam_table_t*) p2, (int *) p3, (int *) p4, (int *) p5);
    }break;

    case SYSCALL_VAM_START    : {
      ret = (void*)_VAM_START((int *) p2, (int *) p3);
    }break;

    case SYSCALL_VAM_DONE     : {
      ret = (void*)_VAM_DONE((int *) p2, (int *) p3);
    }break;

    case SYSCALL_VAM_CLEAN    : {
      ret = (void*)_VAM_CLEAN((vam_table_t*) p2);
    }break;

    case SYSCALL_VAM_TABLE_INIT : {
      ret = (void*)_VAM_TABLE_INIT((vam_table_t*) p2);
    }break;

    // case SYSCALL_VAM_BITSTREAM_TABLE_INIT : {
    //   ret = (void*)_VAM_BITSTREAM_TABLE_INIT((vam_Bitstream_table_t*) p2, (int *) p3);
    // }break;

    case SYSCALL_VAM_TABLE_SHOW : {
      ret = (void*)_VAM_TABLE_SHOW((vam_table_t*) p2, (int*) p3);
    }break;

  }
  return ret;
}

Hint _VAM_TABLE_INIT(vam_table_t *VAM_TABLE)
{
  // unsigned int BRAM_LIST[ROW * COL][2 * COL - (ROW - 2) * 2]={
  //   {0xE0000000, 0xE1000000, NORTH, WEST},
  //   {0xE2000000, 0xE3000000, NORTH, EAST},
  //   {0xE4000000, 0xE5000000, SOUTH, WEST},
  //   {0xE6000000, 0xE7000000, SOUTH, EAST}
  //   };

  unsigned int BRAM_LIST[ROW * COL][2 * COL - (ROW - 2) * 2] = BLIST;
  int i;
  for(i = 0; i < ROW * COL; i++) {
    VAM_TABLE->item[i].Bitstream       =  NULL;
    VAM_TABLE->item[i].Status          =  0;
    VAM_TABLE->item[i].nBRAM           =  0;
    VAM_TABLE->item[i].x               =  i / COL + 1;
    VAM_TABLE->item[i].y               =  i % COL + 1;
    VAM_TABLE->item[i].BRAM1           =  BRAM_LIST[i][0];
    VAM_TABLE->item[i].BRAM2           =  BRAM_LIST[i][1];
    VAM_TABLE->item[i].BRAM1_DIR       =  BRAM_LIST[i][2];
    VAM_TABLE->item[i].BRAM2_DIR       =  BRAM_LIST[i][3];
    VAM_TABLE->item[i].NewWired        =  0;

    VAM_TABLE->item[i].AccType         =  BYPASS;
    VAM_TABLE->item[i].ACC1            =  0;
    VAM_TABLE->item[i].ACC2            =  0;

    VAM_TABLE->item[i].SRC             =  -1;
    VAM_TABLE->item[i].DES             =  -1;

    VAM_TABLE->item[i].B1_WR           =  0;
    VAM_TABLE->item[i].B1_StartIndex   =  0;
    VAM_TABLE->item[i].B1_Size         =  0;
    VAM_TABLE->item[i].B1_Stride       =  1;

    VAM_TABLE->item[i].B2_WR           =  0;
    VAM_TABLE->item[i].B2_StartIndex   =  0;
    VAM_TABLE->item[i].B2_Size         =  0;
    VAM_TABLE->item[i].B2_Stride       =  1;
  }

  return SUCCESS;
}

// Hint _VAM_BITSTREAM_TABLE_INIT(vam_Bitstream_table_t *BITSTREAM_TABLE, int *nSlave)
// {
//   switch (*nSlave) {
//     case 1: {
//       BITSTREAM_TABLE->item[VADD].BitAddr[0] = (u8*)group_0_acc_vadd_PR00_bit;
//       BITSTREAM_TABLE->item[VADD].BitAddr[1] = (u8*)group_0_acc_vadd_PR01_bit;
//       // BITSTREAM_TABLE->item[VADD].BitAddr[2] = (u8*)group_0_acc_vadd_PR10_bit;
//       // BITSTREAM_TABLE->item[VADD].BitAddr[3] = (u8*)group_0_acc_vadd_PR11_bit;

//       // BITSTREAM_TABLE->item[VMUL].BitAddr[0] = (u8*)group_0_acc_vmul_PR00_bit;
//       // BITSTREAM_TABLE->item[VMUL].BitAddr[1] = (u8*)group_0_acc_vmul_PR01_bit;
//       // BITSTREAM_TABLE->item[VMUL].BitAddr[2] = (u8*)group_0_acc_vmul_PR10_bit;
//       // BITSTREAM_TABLE->item[VMUL].BitAddr[3] = (u8*)group_0_acc_vmul_PR11_bit;
//     }break;

//     case 2: {
//       // BITSTREAM_TABLE->item[VADD].BitAddr[0] = (u8*)group_1_acc_vadd_PR00_bit;
//       // BITSTREAM_TABLE->item[VADD].BitAddr[1] = (u8*)group_1_acc_vadd_PR01_bit;
//       // BITSTREAM_TABLE->item[VADD].BitAddr[2] = (u8*)group_1_acc_vadd_PR10_bit;
//       // BITSTREAM_TABLE->item[VADD].BitAddr[3] = (u8*)group_1_acc_vadd_PR11_bit;

//       // BITSTREAM_TABLE->item[VMUL].BitAddr[0] = (u8*)group_1_acc_vmul_PR00_bit;
//       // BITSTREAM_TABLE->item[VMUL].BitAddr[1] = (u8*)group_1_acc_vmul_PR01_bit;
//       // BITSTREAM_TABLE->item[VMUL].BitAddr[2] = (u8*)group_1_acc_vmul_PR10_bit;
//       // BITSTREAM_TABLE->item[VMUL].BitAddr[3] = (u8*)group_1_acc_vmul_PR11_bit;
//     }break;
//   }
//   return SUCCESS;
// }


Hint _VAM_TABLE_SHOW(vam_table_t *VAM_TABLE, int *index)
{
  int i = *index;
  xil_printf("*********************************************************\r\n");
  xil_printf("Item (%d,%d):\r\n",         VAM_TABLE->item[i].x, VAM_TABLE->item[i].y);
  xil_printf("    Bits    :0x%08x\r\n",   VAM_TABLE->item[i].Bitstream);
  xil_printf("    Status  :%d\r\n",       VAM_TABLE->item[i].Status);
  xil_printf("    nBRAM   :%d\r\n",       VAM_TABLE->item[i].nBRAM);
  xil_printf("    BRAM1   :0x%08x\r\n",   VAM_TABLE->item[i].BRAM1);
  xil_printf("    BRAM2   :0x%08x\r\n",   VAM_TABLE->item[i].BRAM2);
  xil_printf("    B1_DIR  :%d\r\n",       VAM_TABLE->item[i].BRAM1_DIR);
  xil_printf("    B2_DIR  :%d\r\n",       VAM_TABLE->item[i].BRAM2_DIR);
  xil_printf("    NWired  :%d\r\n",       VAM_TABLE->item[i].NewWired);
  xil_printf("    AccType :%d\r\n",       VAM_TABLE->item[i].AccType);
  xil_printf("    ACC1    :%d\r\n",       VAM_TABLE->item[i].ACC1);
  xil_printf("    ACC2    :%d\r\n",       VAM_TABLE->item[i].ACC2);
  xil_printf("    SRC     :%d\r\n",       VAM_TABLE->item[i].SRC);
  xil_printf("    DES     :%d\r\n",       VAM_TABLE->item[i].DES);
  xil_printf("    B1_WR   :%d\r\n",       VAM_TABLE->item[i].B1_WR);
  xil_printf("    B1_Index:%d\r\n",       VAM_TABLE->item[i].B1_StartIndex);
  xil_printf("    B1_Size :%d\r\n",       VAM_TABLE->item[i].B1_Size);
  xil_printf("    B1_Str  :%d\r\n",       VAM_TABLE->item[i].B1_Stride);
  xil_printf("    B2_WR   :%d\r\n",       VAM_TABLE->item[i].B2_WR);
  xil_printf("    B2_Index:%d\r\n",       VAM_TABLE->item[i].B2_StartIndex);
  xil_printf("    B2_Size :%d\r\n",       VAM_TABLE->item[i].B2_Size);
  xil_printf("    B2_Str  :%d\r\n",       VAM_TABLE->item[i].B2_Stride);
  xil_printf("*********************************************************\r\n");

  // xil_printf("Item (%d,%d):\r\n \tBits:\t\t\t0x%08x\r\n \tStatus:\t\t\t%d\r\n \tnBRAM:\t\t\t%d\r\n \tBRAM1:\t\t\t0x%08x\r\n \tBRAM2:\t\t\t0x%08x\r\n \tB1_DIR:\t\t\t%d\t\r\n \tB2_DIR:\t\t\t%d\t\r\n \tNewWired\t\t%d\t\r\n", VAM_TABLE->item[i].x, VAM_TABLE->item[i].y,
  //   VAM_TABLE->item[i].Bitstream, VAM_TABLE->item[i].Status, VAM_TABLE->item[i].nBRAM, VAM_TABLE->item[i].BRAM1, VAM_TABLE->item[i].BRAM2, VAM_TABLE->item[i].BRAM1_DIR, VAM_TABLE->item[i].BRAM2_DIR, VAM_TABLE->item[i].NewWired);
  // xil_printf("\tIN1_AccType:\t%d\r\n \tIN1_Direction:\t%d\r\n \tIN1_PortType:\t%d\r\n \tIN1_StartIndex:\t%d\r\n \tIN1_Size:\t\t%d\r\n \tIN1_BRAM:\t\t0x%08x\r\n",
  //   VAM_TABLE->item[i].IN1_AccType, VAM_TABLE->item[i].IN1_Direction, VAM_TABLE->item[i].IN1_PortType,
  //     VAM_TABLE->item[i].IN1_StartIndex, VAM_TABLE->item[i].IN1_Size, VAM_TABLE->item[i].IN1_BRAM);

  // xil_printf("\tIN2_AccType:\t%d\r\n \tIN2_Direction:\t%d\r\n \tIN2_PortType:\t%d\r\n \tIN2_StartIndex:\t%d\r\n \tIN2_Size:\t\t%d\r\n \tIN2_BRAM:\t\t0x%08x\r\n",
  //   VAM_TABLE->item[i].IN2_AccType, VAM_TABLE->item[i].IN2_Direction, VAM_TABLE->item[i].IN2_PortType,
  //     VAM_TABLE->item[i].IN2_StartIndex, VAM_TABLE->item[i].IN2_Size, VAM_TABLE->item[i].IN2_BRAM);

  // xil_printf("\tOUT1_AccType:\t%d\r\n \tOUT1_Direction:\t%d\r\n \tOUT1_PortType:\t%d\r\n \tOUT1_StartIndex:%d\r\n \tOUT1_Size:\t\t%d\r\n \tOUT1_BRAM:\t\t0x%08x\r\n",
  //   VAM_TABLE->item[i].OUT1_AccType, VAM_TABLE->item[i].OUT1_Direction, VAM_TABLE->item[i].OUT1_PortType,
  //     VAM_TABLE->item[i].OUT1_StartIndex, VAM_TABLE->item[i].OUT1_Size, VAM_TABLE->item[i].OUT1_BRAM);
  return SUCCESS;
}

Hint _VAM_GET_PR(vam_table_t *VAM_TABLE, int *nPR)
{
  int i;
  for(i = 0; i < ROW * COL; i++) {
    if(VAM_TABLE->item[i].Status == PRFREE) {
      VAM_TABLE->item[i].Status   = PRBUSY;
      VAM_TABLE->item[i].AccType  = PRPASS;
      VAM_TABLE->item[i].SRC      = 5;
      *nPR = i;
      return SUCCESS;
    }
  }
  return FAILURE;
// The VAM_CLEAN() should change the Status back.
}

Hint _VAM_GET_BRAM(vam_table_t *VAM_TABLE, int *nPR, u32 *BRAMList, int *nIN, int *InSize, int *nOUT, int *OutSize)
{
  int nBRAM = *nIN + *nOUT;
  if(nBRAM < 1 || nBRAM > 2 || *nOUT > 1) {
    //xil_printf("Error for nBRAM\r\n");
    return FAILURE;
  }
  VAM_TABLE->item[*nPR].nBRAM = nBRAM;
  switch(nBRAM) {
    case 2: {
      BRAMList[1] = VAM_TABLE->item[*nPR].BRAM2;
    };
    case 1: {
      BRAMList[0] = VAM_TABLE->item[*nPR].BRAM1;
    }break;
    default: {
      return FAILURE;
    }
  }

  // xil_printf("nPR : %d, nIN : %d, nOut : %d\r\n", *nPR, *nIN, *nOUT);
  switch(*nIN) {
    case 2: {
      if (VAM_TABLE->item[*nPR].AccType  == PRPASS) {
        VAM_TABLE->item[*nPR].ACC2        =  VAM_TABLE->item[*nPR].BRAM2_DIR;
      }

      VAM_TABLE->item[*nPR].B2_WR         =  0;
      VAM_TABLE->item[*nPR].B2_StartIndex =  0;
      VAM_TABLE->item[*nPR].B2_Size       =  *InSize;
      VAM_TABLE->item[*nPR].B2_Stride     =  1;
    }

    case 1: {
      if (VAM_TABLE->item[*nPR].AccType  == PRPASS) {
        VAM_TABLE->item[*nPR].ACC1        =  VAM_TABLE->item[*nPR].BRAM1_DIR;
      }
      VAM_TABLE->item[*nPR].B1_WR         =  0;
      VAM_TABLE->item[*nPR].B1_StartIndex =  0;
      VAM_TABLE->item[*nPR].B1_Size       =  *InSize;
      VAM_TABLE->item[*nPR].B1_Stride     =  1;
    }

    case 0: {
      // VAM_TABLE->item[*nPR].IN2_Size = *InSize;
      // VAM_TABLE->item[*nPR].IN1_Size = *InSize;
    }break;
    default: {
      return FAILURE;
    }
  }

  switch(*nOUT) {
    case 1: {
      if (*nIN == 1) {
        VAM_TABLE->item[*nPR].B2_WR         =  1;
        VAM_TABLE->item[*nPR].B2_StartIndex =  0;
        VAM_TABLE->item[*nPR].B2_Size       =  *OutSize;
        VAM_TABLE->item[*nPR].B2_Stride     =  1;
        VAM_TABLE->item[*nPR].DES         =  VAM_TABLE->item[*nPR].BRAM2_DIR;
      }
      else {
        VAM_TABLE->item[*nPR].B1_WR         =  1;
        VAM_TABLE->item[*nPR].B1_StartIndex =  0;
        VAM_TABLE->item[*nPR].B1_Size       =  *OutSize;
        VAM_TABLE->item[*nPR].B1_Stride     =  1;
        VAM_TABLE->item[*nPR].DES         =  VAM_TABLE->item[*nPR].BRAM1_DIR;
      }
      // VAM_TABLE->item[*nPR].OUT1_AccType      = PRPASS;
      // VAM_TABLE->item[*nPR].OUT1_PortType     = BRAMTYPE;
    };
    case 0: {
      // VAM_TABLE->item[*nPR].OUT1_Size         = *OutSize;
    }break;
    default: {
      return FAILURE;
    }
  }

  int cmd;
  cmd = 0x11000000 | VAM_TABLE->item[*nPR].B1_WR;
  // putnum(cmd);
  putdfslx(cmd, *nPR, FSL_DEFAULT);
  cmd = 0x12000000 | VAM_TABLE->item[*nPR].B1_StartIndex;
  // putnum(cmd);
  putdfslx(cmd, *nPR, FSL_DEFAULT);
  cmd = 0x13000000 | VAM_TABLE->item[*nPR].B1_Size;
  // putnum(cmd);
  putdfslx(cmd, *nPR, FSL_DEFAULT);
  cmd = 0x14000000 | VAM_TABLE->item[*nPR].B1_Stride;
  // putnum(cmd);
  putdfslx(cmd, *nPR, FSL_DEFAULT);

  cmd = 0x21000000 | VAM_TABLE->item[*nPR].B2_WR;
  // putnum(cmd);
  putdfslx(cmd, *nPR, FSL_DEFAULT);
  cmd = 0x22000000 | VAM_TABLE->item[*nPR].B2_StartIndex;
  // putnum(cmd);
  putdfslx(cmd, *nPR, FSL_DEFAULT);
  cmd = 0x23000000 | VAM_TABLE->item[*nPR].B2_Size;
  // putnum(cmd);
  putdfslx(cmd, *nPR, FSL_DEFAULT);
  cmd = 0x24000000 | VAM_TABLE->item[*nPR].B2_Stride;
  // putnum(cmd);
  putdfslx(cmd, *nPR, FSL_DEFAULT);

  return SUCCESS;
}

Hint _VAM_ROUTE(vam_table_t *VAM_TABLE, int *PR, int *nPR)
{

  int Status;

  int i;
  int Src = PR[0];
  int Des;
  for (i = 1; i < *nPR; i++) {
    Des = PR[i];
    Status = VAM_MAZE(VAM_TABLE, Src, Des);
    if (Status != SUCCESS) return FAILURE;
    Src = Des;
  }
  _VAM_CONNECT(VAM_TABLE);
  return SUCCESS;
}

Hint _VAM_CONNECT(vam_table_t *VAM_TABLE)
{
  int i;
  int cmd = 0x00000000;
  ////////////////////////////////////////////////
  for (i = 0; i < ROW * COL; i++) {
    if (VAM_TABLE->item[i].NewWired == 1) {
      cmd  = 0x01000000;
      cmd |= VAM_TABLE->item[i].ACC1 << 20;
      cmd |= VAM_TABLE->item[i].ACC2 << 16;
      cmd |= VAM_TABLE->item[i].SRC  << (4 - VAM_TABLE->item[i].DES) * 4;
      // xil_printf("cmd:0x%08x\r\n", cmd);
      putdfslx(cmd, i, FSL_DEFAULT);

      // if (VAM_TABLE->item[i].IN1_Direction != -1) {
        // VAM_DIR(IN1, i,
        //   VAM_TABLE->item[i].IN1_AccType,
        //   VAM_TABLE->item[i].IN1_Direction,
        //   VAM_TABLE->item[i].IN1_PortType,
        //   VAM_TABLE->item[i].IN1_StartIndex,
        //   VAM_TABLE->item[i].IN1_Size);
      // }

      // if (VAM_TABLE->item[i].IN2_Direction != -1) {
        // VAM_DIR(IN2, i,
        //   VAM_TABLE->item[i].IN2_AccType,
        //   VAM_TABLE->item[i].IN2_Direction,
        //   VAM_TABLE->item[i].IN2_PortType,
        //   VAM_TABLE->item[i].IN2_StartIndex,
        //   VAM_TABLE->item[i].IN2_Size);
      // }

      // if (VAM_TABLE->item[i].OUT1_Direction != -1) {
        // VAM_DIR(OUT1, i,
        //   VAM_TABLE->item[i].OUT1_AccType,
        //   VAM_TABLE->item[i].OUT1_Direction,
        //   VAM_TABLE->item[i].OUT1_PortType,
        //   VAM_TABLE->item[i].OUT1_StartIndex,
        //   VAM_TABLE->item[i].OUT1_Size);
      // }
    }
  }
  //*///////////////////////////////////////////////
  return SUCCESS;
}

Hint _VAM_SET_INDEX(vam_table_t *VAM_TABLE, int *nPR, int *type, int *para)
{
  VAM_TABLE->item[*nPR].B1_StartIndex = *para;
  int cmd = 0x12000000 | VAM_TABLE->item[*nPR].B1_StartIndex;
  putdfslx(cmd, *nPR, FSL_DEFAULT);
  return SUCCESS;
}

Hint _VAM_SET_SIZE(vam_table_t *VAM_TABLE, int *nPR, int *type, int *para)
{
  VAM_TABLE->item[*nPR].B1_Size = *para;
  int cmd = 0x13000000 | VAM_TABLE->item[*nPR].B1_Size;
  putdfslx(cmd, *nPR, FSL_DEFAULT);
  return SUCCESS;
}

Hint _VAM_SET_STRIDE(vam_table_t *VAM_TABLE, int *nPR, int *type, int *para)
{
  VAM_TABLE->item[*nPR].B1_Stride = *para;
  int cmd = 0x14000000 | VAM_TABLE->item[*nPR].B1_Stride;
  putdfslx(cmd, *nPR, FSL_DEFAULT);
  return SUCCESS;
}

Hint _VAM_START(int *PR, int *nPR)
{
  int i;
  for (i = 0; i < *nPR; i++) {
    putdfslx(0x0A000000,  PR[i],    FSL_DEFAULT);
  }
  return SUCCESS;
}

Hint _VAM_DONE(int *PR, int *nPR)
{
  int i;
  int ret;
  for (i = 0; i < *nPR; i++) {
    getdfslx(ret,  PR[i],    FSL_DEFAULT);
  }
  return SUCCESS;
}

Hint _VAM_CLEAN(vam_table_t *VAM_TABLE)
{
  int i;
  for (i = 0; i < ROW * COL; i++) {
    if (VAM_TABLE->item[i].NewWired == 1) {
      VAM_TABLE->item[i].Status          =  PRFREE;
      VAM_TABLE->item[i].NewWired        =  0;
      VAM_TABLE->item[i].AccType         =  BYPASS;
      VAM_TABLE->item[i].ACC1            =  0;
      VAM_TABLE->item[i].ACC2            =  0;

      VAM_TABLE->item[i].SRC             =  -1;
      VAM_TABLE->item[i].DES             =  -1;

      VAM_TABLE->item[i].B1_WR           =  0;
      VAM_TABLE->item[i].B1_StartIndex   =  0;
      VAM_TABLE->item[i].B1_Size         =  0;
      VAM_TABLE->item[i].B1_Stride       =  1;

      VAM_TABLE->item[i].B2_WR           =  0;
      VAM_TABLE->item[i].B2_StartIndex   =  0;
      VAM_TABLE->item[i].B2_Size         =  0;
      VAM_TABLE->item[i].B2_Stride       =  1;
    }
  }
  return SUCCESS;
}

Hint _VAM_DMA(XAxiCdma *InstancePtr, u32 *SrcAddr, u32 *DstAddr, int *byte_Length)
{
  Hint Status;
  Status = XAxiCdma_Transfer(InstancePtr, *SrcAddr, *DstAddr, *byte_Length * 4, NULL, NULL);
  if (Status != SUCCESS) {return FAILURE;}
  return SUCCESS;
}

//*******************************************************************************
//    XAxiCdma_Initialize
//*******************************************************************************
Hint XAxiCdma_Initialize(XAxiCdma * InstancePtr, u16 DeviceId)
{
  XAxiCdma_Config * CdmaCfgPtr = NULL;
  #ifdef HETERO_COMPILATION
  if (DeviceId == XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_DEVICE_ID)
  {
    // Unique ID of this instance
    CdmaCfgPtr -> DeviceId    = XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_DEVICE_ID;
    // Physical address of this instance
    CdmaCfgPtr ->BaseAddress  = XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_BASEADDR;
    // Whether support unaligned transfers
    CdmaCfgPtr ->HasDRE       = XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_INCLUDE_DRE;
    // Whether hardware build is lite mode
    CdmaCfgPtr ->IsLite       = XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_USE_DATAMOVER_LITE;
    // Length of a word in bits
    CdmaCfgPtr ->DataWidth    = XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_M_AXI_DATA_WIDTH;
    CdmaCfgPtr ->BurstLen     = XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_M_AXI_MAX_BURST_LEN;
  }
  #endif
  if (DeviceId ==XPAR_PERIPHERALS_CENTRAL_DMA_DEVICE_ID)
  {
    // Unique ID of this instance
    CdmaCfgPtr -> DeviceId= XPAR_PERIPHERALS_CENTRAL_DMA_DEVICE_ID;
    // Physical address of this instance
    CdmaCfgPtr ->BaseAddress=   XPAR_PERIPHERALS_CENTRAL_DMA_BASEADDR;
    // Whether support unaligned transfers
    CdmaCfgPtr ->HasDRE= XPAR_PERIPHERALS_CENTRAL_DMA_INCLUDE_DRE;
    // Whether hardware build is lite mode
    CdmaCfgPtr ->IsLite = XPAR_PERIPHERALS_CENTRAL_DMA_USE_DATAMOVER_LITE;
    // Length of a word in bits
    CdmaCfgPtr ->DataWidth = XPAR_PERIPHERALS_CENTRAL_DMA_M_AXI_DATA_WIDTH;
    CdmaCfgPtr ->BurstLen =XPAR_PERIPHERALS_CENTRAL_DMA_M_AXI_MAX_BURST_LEN;
  }
  int Status = XAxiCdma_CfgInitialize(InstancePtr , CdmaCfgPtr, CdmaCfgPtr->BaseAddress);
  if (Status != SUCCESS) {
    return FAILURE;
  }
  return SUCCESS;
}
//*******************************************************************************
//    XAxiCdma_Transfer
//*******************************************************************************
Hint XAxiCdma_Transfer(XAxiCdma *InstancePtr, u32 SrcAddr, u32 DstAddr, int byte_Length, XAxiCdma_CallBackFn SimpleCallBack, void *CallbackRef)
{
 int Status, CDMA_Status;

 Status = XAxiCdma_SimpleTransfer(InstancePtr, (u32) SrcAddr , (u32) DstAddr, byte_Length, NULL, NULL);

   if (Status != SUCCESS)
   {
      CDMA_Status = XAxiCdma_GetError(InstancePtr);
      if (CDMA_Status != 0x0) {
        XAxiCdma_Reset(InstancePtr);
        //xil_xil_printf("Error Code = %x\r\r\n",CDMA_Status);
      }
      return FAILURE;
  }

      while (XAxiCdma_IsBusy(InstancePtr)); // Wait

    CDMA_Status = XAxiCdma_GetError(InstancePtr);
    if (CDMA_Status != 0x0) {
      XAxiCdma_Reset(InstancePtr);
      //xil_xil_printf("Error Code = %x\r\r\n",CDMA_Status);
      return FAILURE;
    }

  return SUCCESS;

}

Hint _VAM_SET_PR(XTmrCtr *timer, XHwIcap *icap, hthread_mutex_t *mutex, vam_Bitstream_table_t *BITSTREAM_TABLE, int *nPR, int *nFunctor)
{
  if (icap == NULL) {
    return FAILURE;
  }

  u32 *BitName;
  Hint Status;
  BitName = BITSTREAM_TABLE->item[*nFunctor].BitAddr[*nPR];
  // BITSTREAM_TABLE->t_start = XTmrCtr_GetValue(timer, 0);
  if (hthread_mutex_lock(mutex)) return FAILURE;
  Status = XHwIcap_DeviceWrite(icap, BitName, BITSTREAM_TABLE->bitsize);
  if (Status != SUCCESS){
     xil_printf("error writing to ICAP (%d)\r\n", Status);
     return FAILURE;
  }
  // BITSTREAM_TABLE->t_end = XTmrCtr_GetValue(timer, 0);
  hthread_mutex_unlock(mutex);

  return SUCCESS;

  // u8 *BitName;
  // Hint Status;
  // BitName = BITSTREAM_TABLE->item[*nFunctor].BitAddr[*nPR];
  // u32  HeaderLength, BitstreamLength;
  // Status = VAM_PR_INIT(BitName, &HeaderLength, &BitstreamLength);
  // if (Status != SUCCESS) {putnum(0xdead0021); return FAILURE;}
  // Status = VAM_Do_PR(icap, BitName, HeaderLength, BitstreamLength);
  // if (Status != SUCCESS) {putnum(0xdead0022); return FAILURE;}
  // return SUCCESS;
}

//*******************************************************************************
//    VAM_PR_INIT
//*******************************************************************************
Hint VAM_PR_INIT(u8 *PR_BIT, u32 *HeaderLength, u32 *BitstreamLength)
{
    XHwIcap_Bit_Header bit_header;
    bit_header = XHwIcap_ReadHeader(PR_BIT, 0);
    *HeaderLength = bit_header.HeaderLength;
    *BitstreamLength = bit_header.BitstreamLength;

#ifdef DEBUG
    xil_printf("Bitstream:0x%08x\r\n", PR_BIT);
    xil_printf("HeaderLength:     %d\r\n", bit_header.HeaderLength);
    xil_printf("BitstreamLength:   %d\r\n", bit_header.BitstreamLength);
    xil_printf("DesignName  :     %s\r\n", bit_header.DesignName);
    xil_printf("PartName:     %s\r\n", bit_header.PartName);
    xil_printf("Date:       %s\r\n", bit_header.Date);
    xil_printf("Time:      %s\r\n", bit_header.Time);
    xil_printf("MagicLength:    %d\r\n", bit_header.MagicLength);
#endif

    int i;
    u32 *Buffer = (u32 *)&PR_BIT[bit_header.HeaderLength];
    for (i=0; i<bit_header.BitstreamLength/4; i++){
      if ( (Buffer[i] != 0x00000000) && (Buffer[i] != 0xFFFFFFFF) ) {
        Buffer[i] = Little2Big32(Buffer[i]);
      }
    }
  return SUCCESS;
}

//*******************************************************************************
//    VAM_Do_PR
//*******************************************************************************
Hint VAM_Do_PR(XHwIcap *icap, u32 *PR_BIT, u32 BitstreamLength)
{
  Hint Status;
  // u32 *Buffer = (u32 *)&PR_BIT[HeaderLength];
  Status = XHwIcap_DeviceWrite(icap, PR_BIT, BitstreamLength);
  if (Status != SUCCESS){
     xil_printf("error writing to ICAP (%d)\r\n", Status);
     return FAILURE;
  }
  return SUCCESS;
}

Hint xhwicap_initialize(XHwIcap *instanceptr)
{
     //If you do not put it here, then initization is going to fail.
     //XDcfg_SelectIcapInterface(&devcfg) ;

    XHwIcap_Config *ConfigPtr;
    ConfigPtr = XHwIcap_LookupConfig( XPAR_HWICAP_0_DEVICE_ID);
    if (NULL == ConfigPtr) {
      putnum(0xdead0001);
      //xil_printf("XHwIcap_LookupConfig() failed\r\n");
      return FAILURE;
    }

    int Status = XHwIcap_CfgInitialize(instanceptr, ConfigPtr,   ConfigPtr->BaseAddress);
    if (Status != SUCCESS) {
      putnum(0xdead0002);
      //xil_printf("XHwIcap_CfgInitialize failed\r\n");
      return FAILURE;
    }
    return SUCCESS;
}

/* Parse Bitfile header */
XHwIcap_Bit_Header XHwIcap_ReadHeader(u8 *Data, u32 Size)
{
    u32 I;
    u32 Len;
    u32 Tmp;
    XHwIcap_Bit_Header Header;
    u32 Index;

    /* Start Index at start of bitstream */
    Index=0;

    /* Initialize HeaderLength.  If header returned early inidicates
     * failure.
     */
    Header.HeaderLength = XHI_BIT_HEADER_FAILURE;

    /* Get "Magic" length */
    Header.MagicLength = Data[Index++];
    Header.MagicLength = (Header.MagicLength << 8) | Data[Index++];

    /* Read in "magic" */
    for (I=0; I<Header.MagicLength-1; I++) {
        Tmp = Data[Index++];
        if (I%2==0 && Tmp != XHI_EVEN_MAGIC_BYTE)
        {
          return Header;   /* INVALID_FILE_HEADER_ERROR */
        }
        if (I%2==1 && Tmp != XHI_ODD_MAGIC_BYTE)
        {
            return Header;   /* INVALID_FILE_HEADER_ERROR */
        }
    }

    /* Read null end of magic data. */
    Tmp = Data[Index++];

    /* Read 0x01 (short) */
    Tmp = Data[Index++];
    Tmp = (Tmp << 8) | Data[Index++];

    /* Check the "0x01" half word */
    if (Tmp != 0x01)
    {
       return Header;   /* INVALID_FILE_HEADER_ERROR */
    }


    /* Read 'a' */
    Tmp = Data[Index++];
    if (Tmp != 'a')
    {
        return Header;    /* INVALID_FILE_HEADER_ERROR  */
    }

    /* Get Design Name length */
    Len = Data[Index++];
    Len = (Len << 8) | Data[Index++];

    /* allocate space for design name and final null character. */
    Header.DesignName = (u8 *)malloc(Len);

    /* Read in Design Name */
    for (I=0; I<Len; I++)
    {
        Header.DesignName[I] = Data[Index++];
    }

    /* Read 'b' */
    Tmp = Data[Index++];
    if (Tmp != 'b')
    {
        return Header;  /* INVALID_FILE_HEADER_ERROR */
    }

    /* Get Part Name length */
    Len = Data[Index++];
    Len = (Len << 8) | Data[Index++];

    /* allocate space for part name and final null character. */
    Header.PartName = (u8 *)malloc(Len);

    /* Read in part name */
    for (I=0; I<Len; I++)
    {
        Header.PartName[I] = Data[Index++];
    }

    /* Read 'c' */
    Tmp = Data[Index++];
    if (Tmp != 'c')
    {
        return Header;  /* INVALID_FILE_HEADER_ERROR */
    }

    /* Get date length */
    Len = Data[Index++];
    Len = (Len << 8) | Data[Index++];

    /* allocate space for date and final null character. */
    Header.Date = (u8 *)malloc(Len);

    /* Read in date name */
    for (I=0; I<Len; I++)
    {
        Header.Date[I] = Data[Index++];
    }

    /* Read 'd' */
    Tmp = Data[Index++];
    if (Tmp != 'd')
    {
        return Header;  /* INVALID_FILE_HEADER_ERROR  */
    }

    /* Get time length */
    Len = Data[Index++];
    Len = (Len << 8) | Data[Index++];

    /* allocate space for time and final null character. */
    Header.Time = (u8 *)malloc(Len);

    /* Read in time name */
    for (I=0; I<Len; I++)
    {
        Header.Time[I] = Data[Index++];
    }

    /* Read 'e' */
    Tmp = Data[Index++];
    if (Tmp != 'e')
    {
        return Header;  /* INVALID_FILE_HEADER_ERROR */
    }

    /* Get byte length of bitstream */
    Header.BitstreamLength = Data[Index++];
    Header.BitstreamLength = (Header.BitstreamLength << 8) | Data[Index++];
    Header.BitstreamLength = (Header.BitstreamLength << 8) | Data[Index++];
    Header.BitstreamLength = (Header.BitstreamLength << 8) | Data[Index++];

    Header.HeaderLength = Index;

    return Header;
}
