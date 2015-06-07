/*********** PLATFORM : Vivado_pr_SMP6 **********************************/
#include <stdio.h>
#include <hthread.h>
#include "fsl.h"
#include "xtmrctr.h"
#include "xaxicdma.h"
//#define DEBUG_DISPATCH

#define SIZE 4096*4  //2Mbyte of data

#define BRAM_SIZE 4096

#define  hemps //comment it if you wanna test the MB only version

#define BRAMA 0xE0000000
#define BRAMB 0xE0010000
#define BRAMC 0xE0020000

typedef struct
{
   int * dataA;
   int * dataB; 
   int * dataC;
   Huint vector_size;
}data;


int XAxiCdma_Initialize(XAxiCdma * InstancePtr, u16 DeviceId);
int XAxiCdma_Transfer(XAxiCdma *InstancePtr, u32 SrcAddr, u32 DstAddr, int byte_Length, XAxiCdma_CallBackFn SimpleCallBack, void *CallbackRef);



void * foo_thread(void * arg) 
{



   data * package = (data *) arg;
   Hint * a_ptr = package->dataA;
   Hint * b_ptr = package->dataB;
   Hint * c_ptr = package->dataC; 
   Huint size  = package->vector_size;

   Hint * brama = (Hint *) BRAMA;
   Hint * bramb = (Hint *) BRAMB;
   Hint * bramc = (Hint *) BRAMC;


   int e,Status;


   XAxiCdma mydma;
   #ifndef HETERO_COMPILATION
      Status= XAxiCdma_Initialize(&mydma, XPAR_PERIPHERALS_CENTRAL_DMA_DEVICE_ID);    
   #else
      Status= XAxiCdma_Initialize(&mydma,XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_DEVICE_ID);     
   #endif
   if (Status != XST_SUCCESS) {
      putnum(0xdeadbeef);
      return XST_FAILURE;
   }   
   XAxiCdma_IntrDisable(&mydma, XAXICDMA_XR_IRQ_ALL_MASK);



  
   Huint iterations = size / BRAM_SIZE;
   // If there is a remainder in this 
    // division, round up.
    if ((size % BRAM_SIZE) != 0) {
        iterations++;
    }

  
  
   Huint i = 0;
   Huint new_size = 0;
   Huint * new_a_ptr = 0;
   Huint * new_b_ptr = 0;
   Huint * new_c_ptr = 0;
   for (i = 0; i < iterations; i++) {

      // Calculate the size for this iteration
        new_size = (size < (BRAM_SIZE*(i+1))) ? size-(BRAM_SIZE*i) : BRAM_SIZE; 

      // Calculate the starting pointer for this iteration
      new_a_ptr = (Huint *) ((Huint *)a_ptr + BRAM_SIZE*i);
      new_b_ptr = (Huint *) ((Huint *)b_ptr + BRAM_SIZE*i);
      new_c_ptr = (Huint *) ((Huint *)c_ptr + BRAM_SIZE*i);



      //sending the data ********************************************** 
      /*for (e = 0; e < package->vector_size; e++) {
      brama[e] = dataA[e];
      bramb[e] = dataB[e];   }  
      */
    
   
      Status = XAxiCdma_Transfer(&mydma, (u32) new_a_ptr , (u32) BRAMA, new_size *4, NULL, NULL);
      Status = XAxiCdma_Transfer(&mydma, (u32) new_b_ptr , (u32) BRAMB, new_size *4, NULL, NULL);


      #ifndef hemps	
      //For MBLAZE WITH  no accelerator
      for (e = 0; e < new_size; e++)     bramc[e] = brama[e] + bramb[e];
      #else
      //For Vivado_accelerator
      int cmd =1; //1=> means add, 2=> means subtraction
      int start =0;
      int end =  new_size ;
      putfslx( cmd, 0, FSL_DEFAULT);
      putfslx( end, 0, FSL_DEFAULT);
      putfslx( start, 0, FSL_DEFAULT);
      getfslx(cmd, 0, FSL_DEFAULT); 

      //For hdl_accelerator
      /*
      putfslx((0 << 30) | (new_size << 15) | 0, 0, FSL_DEFAULT);
      getfslx(e, 0, FSL_DEFAULT);
      */
     #endif

      //sending the data back to dram **********************************************   
      Status = XAxiCdma_Transfer(&mydma, (u32) BRAMC , (u32) new_c_ptr, new_size *4, NULL, NULL);
      // for (e = 0; e < new_size; e++)         dataC[e] = bramc[e];
   }   


   return (void *) 0;
}



// Conditional includes
#ifndef HETERO_COMPILATION
#define XPAR_XPS_TIMER_0_BASEADDR XPAR_AXI_TIMER_0_BASEADDR
#include "vivado_strong_scal_prog.h" 

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
   
  // xil_printf (" %08x  ,  %08x  , %08x  , \r\n", package.dataA,package.dataB,package.dataC);

   assert(package.dataA != NULL);
   assert(package.dataB != NULL);
   assert(package.dataC != NULL);
 
   int e;
 
   Hint * dataA = package.dataA;
   Hint * dataB = package.dataB;
   Hint * dataC = package.dataC; 
/*   
   for (e = 0; e < package.vector_size; e++)
   {
      dataA[e] = rand() %1000;
      dataB[e] = rand()%1000;
      dataC[e] = 10;
   }
 */  
 // for (e = 0; e < package.vector_size; e++)       xil_printf("%d %d %d\r\n", dataA[e], dataB[e], dataC[e]);
   
   
//===============================================================================
	//Peripherals instantiation
//===============================================================================
   volatile XTmrCtr * mytimer = (XTmrCtr*) malloc( sizeof (XTmrCtr));
   
   assert (mytimer !=NULL);

    
      
   if    (mytimer->IsReady !=0x11111111 )
   {
      int Status= XTmrCtr_Initialize(mytimer, XPAR_PERIPHERALS_AXI_TIMER_0_DEVICE_ID);
      if (Status != XST_SUCCESS) {
         xil_printf("Timer initialization failed \r\n");
		   return XST_FAILURE;
		   }
	}	 
      XTmrCtr_SetResetValue(mytimer, 0, 0);
      XTmrCtr_Start(mytimer,0);

   //xil_printf("Isready:%x, Isstarted%x \r\n",mytimer->IsReady , mytimer->IsStartedTmrCtr0);

   
   
//===============================================================================
	//Creating and joining on thread
//===============================================================================
#define NUM_AVAILABLE_HETERO_CPUS 1
   hthread_t tid[NUM_AVAILABLE_HETERO_CPUS];
   hthread_attr_t attr[NUM_AVAILABLE_HETERO_CPUS];
   data sub_package[NUM_AVAILABLE_HETERO_CPUS];
 int i; 
 int  sub_size = package.vector_size /NUM_AVAILABLE_HETERO_CPUS; 
   for ( i=0; i <NUM_AVAILABLE_HETERO_CPUS ; i++)
   {
      hthread_attr_init(&attr[i]);  
      sub_package[i].vector_size=  sub_size;
      sub_package[i].dataA= package.dataA + sub_size * i ;
      sub_package[i].dataB= package.dataB + sub_size * i ;
      sub_package[i].dataC= package.dataC + sub_size * i ;
   }  

 xil_printf("Data size:%d, No. threads:%d, Starting the calucation....\r\n", SIZE,NUM_AVAILABLE_HETERO_CPUS);
 XTmrCtr_Reset(mytimer,0);   
for ( i=0; i <NUM_AVAILABLE_HETERO_CPUS ; i++)
{  
   thread_create ( &tid[i], &attr[i] , foo_thread_FUNC_ID , (void * )&sub_package[i], i+2, 0);
}   
  
   int ret;
   for ( i=0; i <NUM_AVAILABLE_HETERO_CPUS ; i++)
{  
   if( hthread_join(tid[i], (void *) &ret))
   {
      xil_printf("Error joining child thread\r\n");
      while(1);
   }
   if (ret !=XST_SUCCESS){
      xil_printf("Thread returned XST_FAILURE\r\n");
      while(1);
   }
}
       int time= XTmrCtr_GetValue(mytimer,0);
   xil_printf("Total exe_time : %d us\r\n", (time)/100 );
   

//===============================================================================
	//Check to see if the result were right?
//=============================================================================== 
   //for (e = 0; e < package.vector_size; e=e+1000)        xil_printf(" %5d: %d %d %d\r\n", e, dataA[e], dataB[e], dataC[e]);
 
      for (e = 0; e < package.vector_size; e++)
    {
            if (dataC[e]!= dataA[e]+ dataB[e])
            {
                 xil_printf("%d %d %d\r\n", dataA[e], dataB[e], dataC[e]);
                 xil_printf("Error at location %d \r\n", e);
                 while (1);
            }
    
    }
 
   
   
   xil_printf("FINISH\r\n");
      XTmrCtr_Stop(mytimer,0);
   free(mytimer);
   return 0;
}

#endif







// Setup CDMA Controller===========================================================================
int XAxiCdma_Initialize(XAxiCdma * InstancePtr, u16 DeviceId)
{
    XAxiCdma_Config * CdmaCfgPtr;
    
   #ifdef HETERO_COMPILATION
     if (DeviceId == XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_DEVICE_ID)
  {
    CdmaCfgPtr -> DeviceId=      XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_DEVICE_ID;            /**< Unique ID of this instance */
	 CdmaCfgPtr ->BaseAddress=    XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_BASEADDR;     /**< Physical address of this instance */
	 CdmaCfgPtr ->HasDRE=         XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_INCLUDE_DRE;            /**< Whether support unaligned transfers */
	 CdmaCfgPtr ->IsLite =        XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_USE_DATAMOVER_LITE;             /**< Whether hardware build is lite mode */
	 CdmaCfgPtr ->DataWidth =     XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_M_AXI_DATA_WIDTH;          /**< Length of a word in bits */
	 CdmaCfgPtr ->BurstLen =      XPAR_GROUP_0_SLAVE_0_LOCAL_DMA_M_AXI_MAX_BURST_LEN;
   } 
   #endif
   
   if (DeviceId ==XPAR_PERIPHERALS_CENTRAL_DMA_DEVICE_ID)
   {
    CdmaCfgPtr -> DeviceId= XPAR_PERIPHERALS_CENTRAL_DMA_DEVICE_ID;            /**< Unique ID of this instance */
	 CdmaCfgPtr ->BaseAddress=   XPAR_PERIPHERALS_CENTRAL_DMA_BASEADDR;     /**< Physical address of this instance */
	 CdmaCfgPtr ->HasDRE= XPAR_PERIPHERALS_CENTRAL_DMA_INCLUDE_DRE;            /**< Whether support unaligned transfers */
	 CdmaCfgPtr ->IsLite = XPAR_PERIPHERALS_CENTRAL_DMA_USE_DATAMOVER_LITE;             /**< Whether hardware build is lite mode */
	 CdmaCfgPtr ->DataWidth = XPAR_PERIPHERALS_CENTRAL_DMA_M_AXI_DATA_WIDTH;          /**< Length of a word in bits */
	 CdmaCfgPtr ->BurstLen =XPAR_PERIPHERALS_CENTRAL_DMA_M_AXI_MAX_BURST_LEN;
   }
   
    	

   int Status = XAxiCdma_CfgInitialize(InstancePtr , CdmaCfgPtr, CdmaCfgPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
		//xil_xil_printf("Status=%x\r\r\n",Status);
	}
	/*putnum(CdmaCfgPtr -> DeviceId);
	putnum(CdmaCfgPtr -> BaseAddress);
	putnum(CdmaCfgPtr -> HasDRE);
	putnum(CdmaCfgPtr -> IsLite);
	putnum(CdmaCfgPtr -> DataWidth);
	putnum(CdmaCfgPtr -> BurstLen);
	*/
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



