/*********** PLATFORM : Vivado_pr_SMP6 **********************************/
#include <stdio.h>
#include <hthread.h>
#include "fsl.h"
#include "xtmrctr.h"
#include "xaxicdma.h"
//#define DEBUG_DISPATCH
//#define SLAVE_DEBUG

#define SIZE 2048

//#define SOFTWARE //if defined, then all threads will do the computation via Microlbaze in SW Vs. HW.

//#define  PRINT_MORE


#define BRAMA 0xE0000000
#define BRAMB 0xE0010000
#define BRAMC 0xE0020000

typedef struct
{
   int * dataA;
   int * dataB; 
   int * dataC;
   Huint vector_size;
   //Huint time;
   //XTmrCtr *timer;
    char * format1;
    char * format2;	
}data;

typedef struct
{
   int * matrixA;
   int * matrixB; 
   int * matrixC;
   Huint a_rows;
   Huint a_cols; //b_rows ==a_cols
   Huint b_rows;
   Huint b_cols;
   }matrix_data;


int XAxiCdma_Initialize(XAxiCdma * InstancePtr, u16 DeviceId);
int XAxiCdma_Transfer(XAxiCdma *InstancePtr, u32 SrcAddr, u32 DstAddr, int byte_Length, XAxiCdma_CallBackFn SimpleCallBack, void *CallbackRef);
int my_XTmrCtr_Initialize(XTmrCtr * InstancePtr, u16 DeviceId);


void * matrix_multiply_thread(void * arg) 
{
   matrix_data * package = (matrix_data *) arg;
   Hint * dataA = package->matrixA;
   Hint * dataB = package->matrixB;
   Hint * dataC = package->matrixC; 
     
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

	Status = XAxiCdma_Transfer(&mydma, (u32) package->matrixA , (u32) BRAMA, package->a_rows * package->a_cols *4, NULL, NULL);
	Status = XAxiCdma_Transfer(&mydma, (u32) package->matrixB , (u32) BRAMB, package->b_rows * package->b_cols *4, NULL, NULL);
		
   //computation
   //Tell the acc to go , with start and end addr
#ifdef SOFTWARE
  sw_matrix_multiply(BRAMA,BRAMB,  BRAMC, package->a_rows, package->a_cols ,  package->b_rows , package->b_cols);
#else   
	putfslx( package->a_rows, 0,FSL_DEFAULT);
	putfslx( package->b_cols, 0,FSL_DEFAULT);
	putfslx( package->a_cols, 0,FSL_DEFAULT);
	getfslx(e, 0, FSL_DEFAULT);
#endif		
    Status = XAxiCdma_Transfer(&mydma, (u32) BRAMC , (u32) package->matrixC, package->a_rows * package->b_cols *4, NULL, NULL);
  
    //package->time= XTmrCtr_GetValue(mytimer,1);  
    
    return (void *) 0;
}

void * bubblesort_thread(void * arg) 
{




   data * package = (data *) arg;
   Hint * dataA = package->dataA;
   Hint * dataB = package->dataB;
   Hint * dataC = package->dataC; 
     
   Hint * brama = (Hint *) BRAMA;
   Hint * bramb = (Hint *) BRAMB;
   Hint * bramc = (Hint *) BRAMC;
   
   
   int e,Status;
   //int time = package->time;
   //XTmrCtr * mytimer =package->timer;

  
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

   //XTmrCtr_Reset(mytimer,1);  
	Status = XAxiCdma_Transfer(&mydma, (u32) package->dataA , (u32) BRAMA, package->vector_size *4, NULL, NULL);
		
   //computation
#ifdef SOFTWARE

sw_bubblesort(BRAMA, package->vector_size) ;
#else
   //Tell the acc to go , with start and end addr
	putfslx(  ((SIZE-1) <<15)|0, 0,FSL_DEFAULT);
	getfslx(e, 0, FSL_DEFAULT);
#endif
		
    Status = XAxiCdma_Transfer(&mydma, (u32) BRAMA , (u32) package->dataA, package->vector_size *4, NULL, NULL); 
  
    //package->time= XTmrCtr_GetValue(mytimer,1);  
    
    return (void *) 0;
}

void * quicksort_thread(void * arg) 
{

 
  //microblaze_invalidate_icache();
    //microblaze_enable_icache();

   data * package = (data *) arg;
   Hint * dataA = package->dataA;
   Hint * dataB = package->dataB;
   Hint * dataC = package->dataC; 
     
   Hint * brama = (Hint *) BRAMA;
   Hint * bramb = (Hint *) BRAMB;
   Hint * bramc = (Hint *) BRAMC;
   

   int e,Status;
   //int time = package->time;
   //XTmrCtr * mytimer =package->timer;

  
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

      //XTmrCtr_Reset(mytimer,1);  
	Status = XAxiCdma_Transfer(&mydma, (u32) package->dataA , (u32) BRAMA, package->vector_size *4, NULL, NULL);

#ifdef SOFTWARE
    Huint * startPtr = (Huint *) BRAMA;
    Huint * endPtr   = (Huint *) (startPtr + package->vector_size-1);
    sw_quicksort(startPtr, endPtr);
#else
   //computation
   //Tell the acc to go , with start and end addr
   int ttmp = (  ((package->vector_size-1)*4)    <<15)| 0;
	putfslx( ttmp, 0,FSL_DEFAULT);	//endaddr,startaddr 	
	int ret =wait_4_acc((data *) package);
	 //putnum(ret);
#endif
	 
	 
	
    Status = XAxiCdma_Transfer(&mydma, (u32) BRAMA , (u32) package->dataA, package->vector_size *4, NULL, NULL); 
  
    //package->time= XTmrCtr_GetValue(mytimer,1);  
    
    return (void *) 0;
}


void * crc_thread(void * arg) 
{

   data * package = (data *) arg;
   Hint * dataA = package->dataA;
   Hint * dataB = package->dataB;
   Hint * dataC = package->dataC; 
     
   Hint * brama = (Hint *) BRAMA;
   Hint * bramb = (Hint *) BRAMB;
   Hint * bramc = (Hint *) BRAMC;
   
   
   int e,Status;
   //int time = package->time;
   //XTmrCtr * mytimer =package->timer;

  
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

   //XTmrCtr_Reset(mytimer,1);  
	Status = XAxiCdma_Transfer(&mydma, (u32) package->dataA , (u32) BRAMA, package->vector_size *4, NULL, NULL);
		
   //computation
#ifdef SOFTWARE   
   sw_crc( BRAMA, package->vector_size);
#else   
   putfslx( ( package->vector_size   <<15)|0, 0,FSL_DEFAULT);
   getfslx(e, 0, FSL_DEFAULT);
#endif

    Status = XAxiCdma_Transfer(&mydma, (u32) BRAMA , (u32) package->dataA, package->vector_size *4, NULL, NULL); 
  
    //package->time= XTmrCtr_GetValue(mytimer,1);  
    return (void *) 0;
}


void * vector_thread(void * arg) 
{

   data * package = (data *) arg;
   Hint * dataA = package->dataA;
   Hint * dataB = package->dataB;
   Hint * dataC = package->dataC; 
  
   Hint * brama = (Hint *) BRAMA;
   Hint * bramb = (Hint *) BRAMB;
   Hint * bramc = (Hint *) BRAMC;
   
   
   int e,Status;
   //int time = package->time;
   //XTmrCtr * mytimer =package->timer;

  
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
  

   //XTmrCtr_Reset(mytimer,1); 
  
   

  
//sending the data ********************************************** 
 /*for (e = 0; e < package->vector_size; e++) {
         brama[e] = dataA[e];
         bramb[e] = dataB[e];   }  
*/
	Status = XAxiCdma_Transfer(&mydma, (u32) package->dataA , (u32) BRAMA, package->vector_size *4, NULL, NULL);
	Status = XAxiCdma_Transfer(&mydma, (u32) package->dataB , (u32) BRAMB, package->vector_size *4, NULL, NULL);
	
	
  //computation


/* This if for HLS
   int cmd =1; //1=> means add, 2=> means subtraction
   int start =0;
   int end =  package->vector_size ;
	putfslx( cmd, 0, FSL_DEFAULT);
	putfslx( end, 0, FSL_DEFAULT);
	putfslx( start, 0, FSL_DEFAULT);
	getfslx(cmd, 0, FSL_DEFAULT); 
*/


#ifdef SOFTWARE
  for (e = 0; e < package->vector_size; e++)     bramc[e] = brama[e] + bramb[e];
#else
     putfslx((0 << 30) | (SIZE << 15) | 0, 0, FSL_DEFAULT);
	  getfslx(e, 0, FSL_DEFAULT);
#endif
 
 //sending the data back to dram **********************************************   
    Status = XAxiCdma_Transfer(&mydma, (u32) BRAMC , (u32) package->dataC, package->vector_size *4, NULL, NULL);
    
   // for (e = 0; e < package->vector_size; e++)         dataC[e] = bramc[e];
    
    
    //package->time= XTmrCtr_GetValue(mytimer,1);  
    return (void *) 0;
}



// Conditional includes
#ifndef HETERO_COMPILATION
#define XPAR_XPS_TIMER_0_BASEADDR XPAR_AXI_TIMER_0_BASEADDR
#include "hemps_acc_test_prog.h" 

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
 
   int e,ret,i,time,j;
 
   Hint * dataA = package.dataA;
   Hint * dataB = package.dataB;
   Hint * dataC = package.dataC; 
   
 // for (e = 0; e < package.vector_size; e++)       xil_printf("%d %d %d\r\n", dataA[e], dataB[e], dataC[e]);
   
   
//===============================================================================
	//Peripherals instantiation
//===============================================================================
   XTmrCtr mytimer;
   volatile int Status= XTmrCtr_Initialize(&mytimer, XPAR_PERIPHERALS_AXI_TIMER_0_DEVICE_ID);
   if (Status != XST_SUCCESS) {
      xil_printf("Timer initialization failed \r\n");
		return XST_FAILURE;
		}
		
		  
   XTmrCtr_SetResetValue(&mytimer, 0, 0);
   XTmrCtr_Start(&mytimer,0);
   //XTmrCtr_SetResetValue(&mytimer, 1, 0);
   //XTmrCtr_Start(&mytimer,1);
   //package.timer= &mytimer;
   
    
 
   hthread_t tid;
   hthread_attr_t attr;
   hthread_attr_init(&attr);      
//===============================================================================
//	Testing VectorAdd
//===============================================================================
#if 0
	 xil_printf(" \r\nVectoradd, size: %d********************************\r\n", SIZE);
//initializing data
   for (e = 0; e < package.vector_size; e++)
   {
      dataA[e] = rand() %1000;
      dataB[e] = rand()%1000;
      dataC[e] = 10;
   }
   
   XTmrCtr_Reset(&mytimer,0);   
   thread_create ( &tid, &attr , vector_thread_FUNC_ID , (void * )&package,STATIC_HW2, 0);
   
  
  if( hthread_join(tid, (void *) &ret))
   {
      xil_printf("Error joining child thread\r\n");
      while(1);
   }
   if (ret !=XST_SUCCESS){
      xil_printf("Thread returned XST_FAILURE\r\n");
      while(1);
   }


   time= XTmrCtr_GetValue(&mytimer,0);
   xil_printf("Total exe_time  %d us,\r\n",  (time)/100  );

   
	//Check to see if the result were right?
	#ifdef PRINT_MORE
   for (e = 0; e < 5; e++)        xil_printf("%d %d %d\r\n", dataA[e], dataB[e], dataC[e]);
   #endif
      for (e = 0; e < package.vector_size; e++)
    {
            if (dataC[e]!= dataA[e]+ dataB[e])
            {
                 xil_printf("Error at location %d \r\n", e);
                 while (1);
            }
    
    }
 
  xil_printf("Passed..................\r\n");
 
#endif 
 //===============================================================================
//	Testing CRC
//===============================================================================
#if 0
	 xil_printf(" \r\nCRC, size: %d********************************\r\n", SIZE);
	//Initiizing  data in DRAM
	int * check = (int *) malloc(sizeof(int) * SIZE);
	for (i =0; i <SIZE; i++)
	{
		package.dataA[i] = (rand() %1000 ) *8;
		check[i]= package.dataA[i];
	}
	//print some of the data
		#ifdef PRINT_MORE
	xil_printf("Data before processing:\r\n");
	for (i =0; i <8; i++)          xil_printf("%d,",  package.dataA[i]);
    #endif
   XTmrCtr_Reset(&mytimer,0);   
   thread_create ( &tid, &attr , crc_thread_FUNC_ID , (void * )&package,STATIC_HW1, 0);
   
  
  if( hthread_join(tid, (void *) &ret))
   {
      xil_printf("Error joining child thread\r\n");
      while(1);
   }
   if (ret !=XST_SUCCESS){
      xil_printf("Thread returned XST_FAILURE\r\n");
      while(1);
   }


   time= XTmrCtr_GetValue(&mytimer,0);
   xil_printf("Total exe_time  %d us,\r\n",  (time)/100  );


	//print some of the  processed data
		#ifdef PRINT_MORE
	xil_printf("Data After processing:\r\n");
	for (i =0; i <8; i++)          xil_printf("%d,",  package.dataA[i]);
      #endif

	sw_crc (check, SIZE);
	for ( i= 0; i<SIZE ; i++)
		if (check[i] != package.dataA[i])
		{
			xil_printf("Error at location %d \r\n", i);
			return 1;

		}

  xil_printf("Passed..................\r\n");
#endif
//===============================================================================
//	Testing quicksort
//===============================================================================
#if 1
	 xil_printf("\r\n Quicksort, size: %d********************************\r\n", package.vector_size);
  
 for (i =0; i <package.vector_size; i++)
	{
		package.dataA[i] = (rand() %1000 ) ;	
		//package.dataA[i]= SIZE-i;
	}
	
	package.format1="\n\r"; package.format2="   "; 
	
		#ifdef PRINT_MORE
	xil_printf("Data before processing:\r\n");
	for (i =0; i <8; i++)          xil_printf("%d,",  package.dataA[i]);
     #endif

   XTmrCtr_Reset(&mytimer,0);   
   thread_create ( &tid, &attr , quicksort_thread_FUNC_ID , (void * )&package,STATIC_HW0, 0);
   
  
  if( hthread_join(tid, (void *) &ret))
   {
      xil_printf("Error joining child thread\r\n");
      while(1);
   }
   if (ret !=XST_SUCCESS){
      xil_printf("Thread returned XST_FAILURE\r\n");
      while(1);
   }
   

   time= XTmrCtr_GetValue(&mytimer,0);
   xil_printf("Total exe_time  %d us,\r\n",  (time)/100  );


	//print some of the  processed data
		#ifdef PRINT_MORE
	xil_printf("Data After processing:\r\n");
	for (i =0; i <8; i++)          xil_printf("%d,",  package.dataA[i]);
	  #endif
	  
	for ( i= 0; i< (package.vector_size -1) ; i++)
		if ( package.dataA[i+1] < package.dataA[i])
		{
			xil_printf("Error at location %d \r\n", i);
			return 1;

		}  
    xil_printf("Passed..................\r\n"); 
    
 #endif   
 
 //===============================================================================
//	Testing bubble sort
//===============================================================================
#if 0
	 xil_printf("\r\n Bubblesort, size: %d********************************\r\n", package.vector_size);
  
 for (i =0; i <package.vector_size; i++)
	{
		package.dataA[i] = (rand() %1000 ) ;
		//package.dataA[i]= SIZE-i;
		
	}	
		#ifdef PRINT_MORE
	xil_printf("Data before processing:\r\n");
	for (i =0; i <8; i++)          xil_printf("%d,",  package.dataA[i]);
      #endif
      
   XTmrCtr_Reset(&mytimer,0);   
   thread_create ( &tid, &attr , bubblesort_thread_FUNC_ID , (void * )&package,STATIC_HW3, 0);
   
  
  if( hthread_join(tid, (void *) &ret))
   {
      xil_printf("Error joining child thread\r\n");
      while(1);
   }
   if (ret !=XST_SUCCESS){
      xil_printf("Thread returned XST_FAILURE\r\n");
      while(1);
   }


   time= XTmrCtr_GetValue(&mytimer,0);
   xil_printf("Total exe_time  %d us,\r\n",  (time)/100  );   



	//print some of the  processed data
		#ifdef PRINT_MORE
	xil_printf("Data After processing:\r\n");
	for (i =0; i <8; i++)          xil_printf("%d,",  package.dataA[i]);
      #endif
      
	for ( i= 0; i< (package.vector_size -1) ; i++)
		if ( package.dataA[i+1] < package.dataA[i])
		{
			xil_printf("Error at location %d \r\n", i);
			return 1;

		}  
    xil_printf("Passed..................\r\n"); 
    
 #endif   
 
 //===============================================================================
//	Testing Matrix multiply sort
//===============================================================================
#if 0
	  int size =64;
	  	matrix_data m_package;
	   m_package.a_rows = size;
      m_package.a_cols =size;
      m_package.b_rows =size;
      m_package.b_cols =size;
	 xil_printf("\r\n MatrixA: %d by %d, MatrixB:%d by %d**************************\r\n",m_package.a_rows,m_package.a_cols, m_package.b_rows,m_package.b_cols);
	 


   
   m_package.matrixA = (int *) malloc(sizeof(int) * m_package.a_rows * m_package.a_cols);
   m_package.matrixB = (int *) malloc(sizeof(int) * m_package.b_rows * m_package.b_cols);
   m_package.matrixC = (int *) malloc(sizeof(int) * m_package.a_rows * m_package.b_cols);
   
  // xil_printf (" %08x  ,  %08x  , %08x  , \r\n", m_package.dataA,m_package.dataB,m_package.dataC);

   assert(m_package.matrixA != NULL);
   assert(m_package.matrixB != NULL);
   assert(m_package.matrixC != NULL);
   assert (m_package.a_cols == m_package.b_rows);
 
   
   Hint * matrixA = m_package.matrixA;
   Hint * matrixB = m_package.matrixB;
   Hint * matrixC = m_package.matrixC; 
  
for (i = 0; i < m_package.a_rows * m_package.a_cols; i++)
       matrixA[i] =rand() %10;
       
for (i = 0; i < m_package.b_rows * m_package.b_cols; i++)
       matrixB[i] =rand() %10;
       
for (i = 0; i < m_package.a_rows * m_package.b_cols; i++)
       matrixC[i] =0;
       
   	#ifdef PRINT_MORE    
	xil_printf("Data before processing:\r\n");
	show_matrix ( matrixA , m_package.a_rows, m_package.a_cols);
	show_matrix ( matrixB , m_package.b_rows, m_package.b_cols);
	show_matrix ( matrixC , m_package.a_rows, m_package.b_cols);
	  #endif

   XTmrCtr_Reset(&mytimer,0);   
   thread_create ( &tid, &attr , matrix_multiply_thread_FUNC_ID , (void * )&m_package,STATIC_HW0, 0);
   
  
  if( hthread_join(tid, (void *) &ret))
   {
      xil_printf("Error joining child thread\r\n");
      while(1);
   }
   if (ret !=XST_SUCCESS){
      xil_printf("Thread returned XST_FAILURE\r\n");
      while(1);
   }


   time= XTmrCtr_GetValue(&mytimer,0);
   xil_printf("Total exe_time  %d us,\r\n",  (time)/100  );


	//print some of the  processed data
		#ifdef PRINT_MORE
	xil_printf("Data After processing:\r\n");
	show_matrix ( matrixC , m_package.a_rows, m_package.b_cols);
	   #endif
	
	int * tempC = (int *) malloc(sizeof(int) * m_package.a_rows * m_package.b_cols);
	sw_matrix_multiply( matrixA,matrixB,tempC, m_package.a_rows, m_package.a_cols , m_package.b_rows , m_package.b_cols);
	

	
	for (i = 0; i < (m_package.a_rows) * (m_package.b_cols) ; i++)       
          if ( matrixC[i] != tempC [i] )
          {
			   xil_printf("Error at location [%d] \r\n", i);
			   return 1;
		    }  
    xil_printf("Passed..................\r\n"); 
    
 #endif   
      
    
    
   XTmrCtr_Stop(&mytimer, 0);
   XTmrCtr_Stop(&mytimer, 1);
   xil_printf("FINISH\r\n");
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


int wait_4_acc(data * arg)
{  
/*
--      request send         6bitOpcode,10bitReseved,16bitparam1         32bit param2(if opcode is push or write)       
--      response from mb                       32bitMblaze_return

-- Request(form acc)                      Opcode-6bit        Parm1-16bit   Param2-32bits  Mblaze_ret32bits       next_state
--push                          16                    --             value          --                return_state
--pop                           17                    --              --            value             return_state
 

--Declare                        3                    num             --             --                return_state
--read(local variable)           4                    addr            --             value             return_state  
--write((local variable)         5                    addr            value          --                return_state




--call                          18                    next_pc          --             --               return_state   
--return                        19                    --               --             next_pc          next_pc(mb_ret value)   
--done                          0                     -----------------------------------------------------------------

*/

  // Memory sub-interface specific opcodes
  #define OPCODE_LOAD 			1
  #define OPCODE_STORE 			2
  #define OPCODE_DECLARE 		3
  #define OPCODE_READ 			4
  #define OPCODE_WRITE 			5
  #define OPCODE_ADDRESS 		6
  // Function sub-interface specific opcodes
  #define OPCODE_PUSH 			16
  #define OPCODE_POP 			17
  #define OPCODE_CALL 			18
  #define OPCODE_RETURN 		19

  #define OPCODE_MASK      		 0xFC000000
  #define PARAM1_MASK         		 0x0000FFFF


    register int opcode=0;
    register int param1=0;
    int param2=0;
    int mb_ret=0;    
    int return_state=0;        
    
    #define STACKSIZE			 300	//in words. The size of BRAM is 8k, and only 6kbyte of it is assigned to ldscript.ld( for boot kernel). The remaining 2k is used for scracth pad memeories like this.
    
    //int stack[40];
   int *stack =0x00001800;//To get access to whole stack of 128kbyte
    //putnum(&param2);print(arg->format1); putnum(&stack[0]);print(arg->format1);
    int stackptr = 0; 
    int frameptr = 0;
    int param_pushed_count = 0;
    int param_popped_count = 0;
   
   
    Hint i;   
   

    //first argument
    stack[stackptr++] = 0; 
    //initial number of parameters
    stack[stackptr++]=1;  
    //initial return frame pointer
    stack[stackptr++]=0;  
    //return state
    stack[stackptr++]=0;  
    frameptr = stackptr; 
    
    int max_stack =0;
    int num =0;
    
    do {
    
   // if (stackptr > max_stack)        max_stack = stackptr;

   //  num++;  
	//Read from  user core
	getfslx( opcode, 0, FSL_DEFAULT);
                
	

	//Decipher commands
        param1 =0 + ((opcode & PARAM1_MASK) );
	opcode = 0 + ((opcode & OPCODE_MASK) >> 26);
        
	          

	switch(opcode)
	{

/*

           case(OPCODE_LOAD):
		//return data from address givhen by user in value field
		mb_ret = * ((int*)0xE0010000 +param1/4);	//FIX TODO	
		putfslx( (int) mb_ret, 0, FSL_DEFAULT); 
		break;


	    case(OPCODE_STORE):
		//store to address given by user
		* ((int*)0xE0010000+param1/4)	 = param2;//FIX TODO
		putfslx( (int) 0, 0, FSL_DEFAULT); 
		break;	   
*/
	    case(OPCODE_DECLARE):
                stackptr+= param1;
                putfslx( (int) 0, 0, FSL_DEFAULT); 
               
		break;

	    case(OPCODE_READ):
	    
                mb_ret = stack[frameptr+param1]; 
                putfslx( (int) mb_ret, 0, FSL_DEFAULT); 
		break;

	    case(OPCODE_WRITE):
                getfslx( param2, 0, FSL_DEFAULT);
                stack[frameptr+param1] = param2;
                putfslx( (int) 0, 0, FSL_DEFAULT); 

		break;

	  
	    case(OPCODE_PUSH):
                 getfslx( param2, 0, FSL_DEFAULT);  
		if(stackptr < STACKSIZE - 1)
		{
		    stack[stackptr++] = param2;
		    param_pushed_count++;
		}
		else
		    ;//error

               putfslx( (int) 0, 0, FSL_DEFAULT); 
                    
		break;


	    case(OPCODE_POP):
	    
                		
		if(stackptr > 0 && stackptr < STACKSIZE){
		   
                      if (param_popped_count < stack[frameptr-3] ){ // stack[frameptr-3] is param_pushed_count.
                      mb_ret=stack[frameptr- param_popped_count-4]; //
                      param_popped_count++;    }               
		    
		
		}
		else
		  ;//error

		putfslx( (int) mb_ret, 0, FSL_DEFAULT); 
		break;



	    case(OPCODE_CALL):
		

		       //first write number of params to the stack
			stack[stackptr++] = param_pushed_count;
			param_pushed_count = 0;
                        param_popped_count =0;
			//write frame pointer to stack
			stack[stackptr++] = frameptr;
			//write return state to stack
			stack[stackptr++] = param1;
			//update stack and frame pointer
			frameptr = stackptr;

			//***********************************************
			// first parameter passed to function        <---- frameptr - 4
			// number of parameters passed to function   <---- frameptr - 3
			// old frameptr                              <---- frameptr - 2
			// return state                              <---- frameptr - 1
			//**********************************************

			putfslx( (int) 0, 0, FSL_DEFAULT); 
			break;
                    
		

	    case(OPCODE_RETURN):
		
		//read return state
		mb_ret = stack[frameptr-1];
		//read number of parameters invovled in this function
		stackptr = (frameptr - 3) - stack[frameptr-3];
		//restore frame pointer
		frameptr = stack[frameptr - 2];

		putfslx( (int) mb_ret, 0, FSL_DEFAULT);
		break;


           case (0) :              
		           return 11;
                break;

	    default:	//i.e. NOOP
		break;
	}

 #ifdef SLAVE_DEBUG     
putnum(opcode); print(arg->format2);putnum(param1);print(arg->format2);putnum(param2); print(arg->format2);putnum(mb_ret); print(arg->format2);putnum(stackptr);print(arg->format1);
#endif
    } while (1);
}


void sw_bubblesort(Huint * startPtr, int n ) 
{

int c, d,swap;
for (c = 0 ; c < ( n - 1 ); c++)
  {
    for (d = 0 ; d < n - c - 1; d++)
    {
      if (startPtr[d] > startPtr[d+1]) /* For decreasing order use < */
      {
        swap       = startPtr[d];
        startPtr[d]   = startPtr[d+1];
        startPtr[d+1] = swap;
      }
    }
  }

}  
  
void sw_quicksort(Huint * startPtr, Huint * endPtr ) {
    
   Huint pivot;
	Huint * leftPtr, * rightPtr;
	Huint temp, * tempPtr;

	//fflush( stdout );
	if ( startPtr == endPtr ) { return; }

	leftPtr = startPtr;
	rightPtr = endPtr;

	pivot = (*leftPtr + *rightPtr)/2;

	while (leftPtr < rightPtr) {
		while ((leftPtr < rightPtr) && (*leftPtr <= pivot) ) {
			leftPtr++;
		}

		while((leftPtr <= rightPtr) && (*rightPtr > pivot) ) {
			rightPtr--;
		}

		if ( leftPtr < rightPtr ) {
			temp = *leftPtr;
			*leftPtr = *rightPtr;
			*rightPtr = temp;
		}
	}
	
	if ( leftPtr == rightPtr ) {
		if ( *rightPtr >= pivot ) {
			leftPtr = rightPtr - 1;
		} else {
			rightPtr++;
		}
	} else {
		if ( *rightPtr > pivot ) {
			leftPtr = rightPtr - 1;
		} else {
			tempPtr = leftPtr;
			leftPtr = rightPtr;
			rightPtr = tempPtr;
		}
	}
	
   sw_quicksort( rightPtr, endPtr );
	sw_quicksort( startPtr, leftPtr );

    return;
}


void	sw_matrix_multiply(int * a, int * b, int * c,  char a_rows, char a_cols ,  char b_rows , char b_cols)
{
  assert( a_cols == b_rows);
  	char i, j, k=0;
  	int sum= 0;
   for (i=0; i<a_rows; i++){
      for (j=0; j<b_cols; j++){
         sum = 0;
         for (k=0; k<a_cols; k++){
            sum += a[i*a_cols+k] * b[k*b_cols+j];
            }
         c[i*b_cols+j] = sum;
      }
   }	  
}	


//------------------------------------------------------------------------------
// Input:   matrix - Matrix pointer
//          x - width of the matrix
//          y - hight of the matrix
// Output:  none
// Return:  none
// Purpose: This function show a matrix through the UART
//------------------------------------------------------------------------------


	
	
void show_matrix(int * matrix, short rows, short cols  )
{
	unsigned char i,j;
	for(i = 0; i < rows; i++) {
		for(j = 0; j < cols; j++) {
		   xil_printf( " %d ", matrix [i* cols + j]);			
		}
		xil_printf("\r\n");
   }
   
   xil_printf( "*******************************\r\n");
}


int sw_crc(void * list_ptr, int size) {

    int *array = (int *) list_ptr;

    for (array = list_ptr; array < (int *) list_ptr + size; array++) {
        *array = gen_crc(*array);
    }

    return 0;
}


//====================================================================================
// Author: Abazar
#define G_INPUT_WIDTH 32
#define G_DIVISOR_WIDTH 4

int gen_crc( int input)
{
  unsigned int result;
  result=input;
  unsigned int i=0;
  unsigned int divisor = 0xb0000000;
  unsigned int mask     =0x80000000;

       while(1){

              if ( ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) && ( (result&mask) == 0 ) ) {
                i++;
                divisor=divisor  /2;
                mask = mask /2;
              }
              else if ( ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) ) {

                i++;
                result = result ^ divisor;
                divisor=divisor  /2;
                mask=mask /2;
              }
              else {
               return result;
              }
       }
      return 0;
}

