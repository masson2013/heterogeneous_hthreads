/*********** PLATFORM : Vivado_pr_SMP6 **********************************/
#include <stdio.h>
#include <hthread.h>
#include "fsl.h"
#include "xtmrctr.h"
#include "xaxicdma.h"
//#define DEBUG_DISPATCH

#define SIZE 2048


#define BRAMA 0xc2000000
#define BRAMB 0xc4000000
#define BRAMC 0xc6000000

typedef struct
{
   int * dataA;
   int * dataB; 
   int * dataC;
   Huint vector_size;
   Huint time;
   XTmrCtr *timer;
}data;


int XAxiCdma_Initialize(XAxiCdma * InstancePtr, u16 DeviceId);
int XAxiCdma_Transfer(XAxiCdma *InstancePtr, u32 SrcAddr, u32 DstAddr, int byte_Length, XAxiCdma_CallBackFn SimpleCallBack, void *CallbackRef);



void * foo_thread(void * arg) 
{
   data * package = (data *) arg;
   Hint * dataA = package->dataA;
   Hint * dataB = package->dataB;
   Hint * dataC = package->dataC; 
  
   Hint * brama = (Hint *) BRAMA;
   Hint * bramb = (Hint *) BRAMB;
   Hint * bramc = (Hint *) BRAMC;
   
   
   int e,Status;
   int time = package->time;
   XTmrCtr * mytimer =package->timer;

  
   XAxiCdma mydma;
   #ifndef HETERO_COMPILATION
      Status= XAxiCdma_Initialize(&mydma,XPAR_MAIN_AXI_CDMA_0_DEVICE_ID);    
   #else
      Status= XAxiCdma_Initialize(&mydma,XPAR_SLAVE_0_AXI_CDMA_0_DEVICE_ID);     
   #endif
    if (Status != XST_SUCCESS) {
         putnum(0xdeadbeef);
         return XST_FAILURE;
    }   
   XAxiCdma_IntrDisable(&mydma, XAXICDMA_XR_IRQ_ALL_MASK);
  

   XTmrCtr_Reset(mytimer,1); 
  
  
//sending the data ********************************************** 
/* for (e = 0; e < package->vector_size; e++) {
         brama[e] = dataA[e];
         bramb[e] = dataB[e];   } */    
	Status = XAxiCdma_Transfer(&mydma, (u32) package->dataA , (u32) BRAMA, package->vector_size *4, NULL, NULL);	
	Status = XAxiCdma_Transfer(&mydma, (u32) package->dataB , (u32) BRAMB, package->vector_size *4, NULL, NULL);
	
	
  //computation
 for (e = 0; e < package->vector_size; e++)     bramc[e] = brama[e] + bramb[e];
 /* 
   int cmd =1; //1=> means add, 2=> means subtraction
	putfslx( cmd, 0, FSL_DEFAULT);
	getfslx(cmd, 0, FSL_DEFAULT); 
 */ 
 
 //sending the data back to dram **********************************************   
    Status = XAxiCdma_Transfer(&mydma, (u32) BRAMC , (u32) package->dataC, package->vector_size *4, NULL, NULL);
    //for (e = 0; e < package->vector_size; e++)         dataC[e] = bramc[e];
    
    
    package->time= XTmrCtr_GetValue(mytimer,1);  
    return (void *) 0;
}



// Conditional includes
#ifndef HETERO_COMPILATION
#define XPAR_XPS_TIMER_0_BASEADDR XPAR_AXI_TIMER_0_BASEADDR
#include "vivado_pr_smp6_prog.h" 
#endif	


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else


int main(int argc, char *argv[]) 
{
   
  

   xil_printf("\r\n-----Begin Program-----\r\n"); 
   
  
//===============================================================================
   //Initilizing Data
//===============================================================================   
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
 // for (e = 0; e < package.vector_size; e++)       xil_printf("%d %d %d\r\n", dataA[e], dataB[e], dataC[e]);
   
   
//===============================================================================
	//Peripherals instantiation
//===============================================================================
   XTmrCtr mytimer;
   int Status= XTmrCtr_Initialize(&mytimer, XPAR_PERIPHERALS_AXI_TIMER_0_DEVICE_ID);
   if (Status != XST_SUCCESS) {
      xil_printf("Timer initialization failed \r\n");
		return XST_FAILURE;
		}
   XTmrCtr_SetResetValue(&mytimer, 0, 0);
   XTmrCtr_Start(&mytimer,0);
   XTmrCtr_SetResetValue(&mytimer, 1, 0);
   XTmrCtr_Start(&mytimer,1);
   package.timer= &mytimer;
   
   
   
//===============================================================================
	//Creating and joining on thread
//===============================================================================
   hthread_t tid;
   hthread_attr_t attr;
   hthread_attr_init(&attr);   
   
   
   
   XTmrCtr_Reset(&mytimer,0);   
   thread_create ( &tid, &attr , foo_thread_FUNC_ID , (void * )&package, STATIC_HW0, 0);
   
   int ret;
   if( hthread_join(tid, (void *) &ret))
   {
      xil_printf("Error joining child thread\r\n");
      while(1);
   }
   if (ret !=XST_SUCCESS){
      xil_printf("Thread returned XST_FAILURE\r\n");
      while(1);
   }
   int time= XTmrCtr_GetValue(&mytimer,0);
   
   xil_printf("Total exe_time with thread creatition overhead: %d us\r\n",  (time)/100 );
   xil_printf("Net exe_time of the body of the thread: %d us\r\n",  (package.time)/100 );
   

//===============================================================================
	//Check to see if the result were right?
//=============================================================================== 
   for (e = 0; e < 5; e++)        xil_printf("%d %d %d\r\n", dataA[e], dataB[e], dataC[e]);
 
      for (e = 0; e < package.vector_size; e++)
    {
            if (dataC[e]!= dataA[e]+ dataB[e])
            {
                 xil_printf("Error at location %d \r\n", e);
                 while (1);
            }
    
    }
   
   
   
   xil_printf("FINISH\r\n");
   return 0;
}

#endif







// Setup CDMA Controller===========================================================================
int XAxiCdma_Initialize(XAxiCdma * InstancePtr, u16 DeviceId)
{
    XAxiCdma_Config * CdmaCfgPtr;
    
    #ifdef HETERO_COMPILATION
  if (DeviceId == XPAR_SLAVE_0_AXI_CDMA_0_DEVICE_ID)
  {
    CdmaCfgPtr -> DeviceId= XPAR_SLAVE_0_AXI_CDMA_0_DEVICE_ID;            /**< Unique ID of this instance */
	 CdmaCfgPtr ->BaseAddress=   XPAR_SLAVE_0_AXI_CDMA_0_BASEADDR;     /**< Physical address of this instance */
	 CdmaCfgPtr ->HasDRE= XPAR_SLAVE_0_AXI_CDMA_0_INCLUDE_DRE;            /**< Whether support unaligned transfers */
	 CdmaCfgPtr ->IsLite = XPAR_SLAVE_0_AXI_CDMA_0_USE_DATAMOVER_LITE;             /**< Whether hardware build is lite mode */
	 CdmaCfgPtr ->DataWidth = XPAR_SLAVE_0_AXI_CDMA_0_M_AXI_DATA_WIDTH;          /**< Length of a word in bits */
	 CdmaCfgPtr ->BurstLen =XPAR_SLAVE_0_AXI_CDMA_0_M_AXI_MAX_BURST_LEN;
   } 
   #endif
   
   if (DeviceId ==XPAR_MAIN_AXI_CDMA_0_DEVICE_ID)
   {
    CdmaCfgPtr -> DeviceId= XPAR_MAIN_AXI_CDMA_0_DEVICE_ID;            /**< Unique ID of this instance */
	 CdmaCfgPtr ->BaseAddress=   XPAR_MAIN_AXI_CDMA_0_BASEADDR;     /**< Physical address of this instance */
	 CdmaCfgPtr ->HasDRE= XPAR_MAIN_AXI_CDMA_0_INCLUDE_DRE;            /**< Whether support unaligned transfers */
	 CdmaCfgPtr ->IsLite = XPAR_MAIN_AXI_CDMA_0_USE_DATAMOVER_LITE;             /**< Whether hardware build is lite mode */
	 CdmaCfgPtr ->DataWidth = XPAR_MAIN_AXI_CDMA_0_M_AXI_DATA_WIDTH;          /**< Length of a word in bits */
	 CdmaCfgPtr ->BurstLen =XPAR_MAIN_AXI_CDMA_0_M_AXI_MAX_BURST_LEN;
   }
   
    	

   int Status = XAxiCdma_CfgInitialize(InstancePtr , CdmaCfgPtr, CdmaCfgPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
		//xil_xil_printf("Status=%x\r\r\n",Status);
	}
	
	putnum(CdmaCfgPtr -> DeviceId);
	putnum(CdmaCfgPtr -> BaseAddress);
	putnum(CdmaCfgPtr -> HasDRE);
	putnum(CdmaCfgPtr -> IsLite);
	putnum(CdmaCfgPtr -> DataWidth);
	putnum(CdmaCfgPtr -> BurstLen);
	
	
	
	
	
	
	return XST_SUCCESS;
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
				//xil_xil_printf("Error Code = %x\r\r\n",CDMA_Status);
			}
			return XST_FAILURE;
	}

	  	while (XAxiCdma_IsBusy(InstancePtr)); // Wait
		CDMA_Status = XAxiCdma_GetError(InstancePtr);
		if (CDMA_Status != 0x0) {
			XAxiCdma_Reset(InstancePtr);
			//xil_xil_printf("Error Code = %x\r\r\n",CDMA_Status);
			return XST_FAILURE;
		}

  return XST_SUCCESS;

}



