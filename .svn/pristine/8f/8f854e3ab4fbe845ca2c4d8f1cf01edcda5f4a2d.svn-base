/*********** PLATFORM : SMP1 **********************************/
#include <stdio.h>
#include <hthread.h>
#include "fsl.h"
#include "xtmrctr.h"
#include "xaxicdma.h"


#define SIZE 4096


#define BRAMA 0xE0000000
#define BRAMB 0xE0010000
#define BRAMC 0xE0020000

typedef struct
{
   int * dataA;
   int * dataB; 
   int * dataC;
   Huint vector_size;
   Huint time;
}data;

/*
void * foo_thread(void * arg) 
{
    data * package = (data *) arg;
    
   int e;
   Hint * dataA = package->dataA;
   Hint * dataB = package->dataB;
   Hint * dataC = package->dataC; 
   for (e = 0; e < package->vector_size; e++)
   {
      dataC[e] = dataA[e] + dataB[e];
   }
   return (void *) 0;
}
*/

// -------------------------------------------------------------- //
//                    Reset and Clear FIFOS                       //
// -------------------------------------------------------------- //
void reset_accelerator(unsigned char fifo_depth) {

    // Reset the accelerator
    putfslx( 0, 1, FSL_DEFAULT);

    // Clean up any junk data between slave and Acc FIFO
    register unsigned char i, j;
    for (i = 0; i < fifo_depth; i++)
        getfslx(j, 0, FSL_NONBLOCKING);
}

// Setup CDMA Controller===========================================================================
int XAxiCdma_Initialize(XAxiCdma * InstancePtr, u16 DeviceId)
{
    XAxiCdma_Config * CdmaCfgPtr;
    CdmaCfgPtr = XAxiCdma_LookupConfig(DeviceId);
   	if (!CdmaCfgPtr) {
   		return XST_FAILURE;
   	}

   	int Status = XAxiCdma_CfgInitialize(InstancePtr , CdmaCfgPtr, CdmaCfgPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
		//xil_printf("Status=%x\r\n",Status);
	}
}

int XAxiCdma_Transfer(XAxiCdma *InstancePtr, u32 SrcAddr, u32 DstAddr, int byte_Length, XAxiCdma_CallBackFn SimpleCallBack, void *CallbackRef)
{
 int Status, CDMA_Status;
 Status = XAxiCdma_SimpleTransfer(InstancePtr, (u32) SrcAddr , (u32) DstAddr, byte_Length, NULL, NULL);
   if (Status != XST_SUCCESS) 
   {
			 CDMA_Status = XAxiCdma_GetError(InstancePtr);
			if (CDMA_Status != 0x0) {
				XAxiCdma_Reset(InstancePtr);
				//xil_printf("Error Code = %x\r\n",CDMA_Status);
			}
			return XST_FAILURE;
	}

	  	while (XAxiCdma_IsBusy(InstancePtr)); // Wait
		CDMA_Status = XAxiCdma_GetError(InstancePtr);
		if (CDMA_Status != 0x0) {
			XAxiCdma_Reset(InstancePtr);
			//xil_printf("Error Code = %x\r\n",CDMA_Status);
			return XST_FAILURE;
		}



}

void * foo_thread(void * arg) 
{
    data * package = (data *) arg;
   Hint * dataA = package->dataA;
   Hint * dataB = package->dataB;
   Hint * dataC = package->dataC; 
  
   Hint * brama = (Hint *) BRAMA;
   Hint * bramb = (Hint *) BRAMB;
   Hint * bramc = (Hint *) BRAMC;
   
   
   int e;
//manually sending the data
/*  

   for (e = 0; e < package->vector_size; e++)
   {
         brama[e] = dataA[e];
         bramb[e] = dataB[e];
   }
*/   




//Setting the timer 
   XTmrCtr mytimer;
   XTmrCtr_Initialize(&mytimer, XPAR_AXI_TIMER_0_DEVICE_ID);
   XTmrCtr_SetResetValue(&mytimer, 0, 0);
   XTmrCtr_Start(&mytimer,0);
  
   
   int Status,CDMA_Status;
   //setting up the dma
   XAxiCdma mydma;
   XAxiCdma_Initialize(&mydma, XPAR_AXI_CDMA_0_DEVICE_ID);     
   XAxiCdma_IntrDisable(&mydma, XAXICDMA_XR_IRQ_ALL_MASK);
  
  
  
   XTmrCtr_Reset(&mytimer,0);
   
	Status = XAxiCdma_Transfer(&mydma, (u32) package->dataA , (u32) BRAMA, package->vector_size *4, NULL, NULL);	
	Status = XAxiCdma_Transfer(&mydma, (u32) package->dataB , (u32) BRAMB, package->vector_size *4, NULL, NULL);
	
	
  //computation
// for (e = 0; e < package->vector_size; e++)     bramc[e] = brama[e] + bramb[e];

  // Acc vector add
   
     reset_accelerator(16);
     
     putfslx((00 << 30) | (SIZE << 15) | 0, 0, FSL_DEFAULT);
	  getfslx(e, 0, FSL_DEFAULT);
	
  /*   putfslx(48, 0, FSL_DEFAULT); //30H
     putfslx(SIZE, 0, FSL_DEFAULT);
     putfslx(0, 0, FSL_DEFAULT);
     getfslx(e,0, FSL_DEFAULT);
  */   
 
   
 Status = XAxiCdma_Transfer(&mydma, (u32) BRAMC , (u32) package->dataC, package->vector_size *4, NULL, NULL);
  
   
 //  for (e = 0; e < package->vector_size; e++)         dataC[e] = bramc[e];
  
  
  package->time =XTmrCtr_GetValue(&mytimer,0);
   return (void *) 0;
}



// Conditional includes
#ifndef HETERO_COMPILATION
#define XPAR_XPS_TIMER_0_BASEADDR XPAR_AXI_TIMER_0_BASEADDR
#include "vc707_pr_smp1_prog.h" 
#endif	


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else


int main(int argc, char *argv[]) 
{
   
  

   printf("\n-----Begin Program-----\n");
   
   
  
   
   data package;
   package.vector_size = SIZE;
   package.dataA = (int *) malloc(sizeof(int) * package.vector_size);
   package.dataB = (int *) malloc(sizeof(int) * package.vector_size);
   package.dataC = (int *) malloc(sizeof(int) * package.vector_size);  

   assert(package.dataA != NULL);
   assert(package.dataB != NULL);
   assert(package.dataC != NULL);
 
   int e;
 
   Hint * dataA = package.dataA;
   Hint * dataB = package.dataB;
   Hint * dataC = package.dataC; 
   for (e = 0; e < package.vector_size; e++)
   {
      dataA[e] = rand() %1000;
      dataB[e] = rand()%1000;
      dataC[e] = 10;
   }

 // for (e = 0; e < package.vector_size; e++)       printf("%d %d %d\n", dataA[e], dataB[e], dataC[e]);
   
   
   

   hthread_t tid;
   hthread_attr_t attr;
   hthread_attr_init(&attr);
   
   
   thread_create ( &tid, &attr , foo_thread_FUNC_ID , (void * )&package, STATIC_HW0, 0);
   
   int ret;
   if( hthread_join(tid, (void *) &ret))
   {
      printf("Error joining child thread\n");
      while(1);
   }
   
  // printf("Total cycles: %i\n", cycles);
   printf("Total exe_time: %2.0f us\n",  (float)(package.time)/100.0 );
   
 
  // for (e = 0; e < package.vector_size; e++)        printf("%d %d %d\n", dataA[e], dataB[e], dataC[e]);
 
      for (e = 0; e < package.vector_size; e++)
    {
            if (dataC[e]!= dataA[e]+ dataB[e])
            {
                 printf("Error at location %d \n", e);
                 while (1);
            }
    
    }
   
   
   
   printf("FINISH\n");
   return 0;
}








#endif


/*
int XTmrCtr_Initialize(XTmrCtr * InstancePtr, u16 DeviceId);
void XTmrCtr_Start(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
void XTmrCtr_Stop(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
u32 XTmrCtr_GetValue(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
void XTmrCtr_SetResetValue(XTmrCtr * InstancePtr, u8 TmrCtrNumber,
			   u32 ResetValue);
u32 XTmrCtr_GetCaptureValue(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
int XTmrCtr_IsExpired(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
void XTmrCtr_Reset(XTmrCtr * InstancePtr, u8 TmrCtrNumber);
*/
