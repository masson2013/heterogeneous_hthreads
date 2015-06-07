#include <stdio.h>
#include <errno.h>
#include <hthread.h>
#include "time_lib.h"
#include "fsl.h"
#include <stdlib.h>
#include <string.h>
#include <util/rops.h>
#include <sys/core.h>
#include <sys/syscall.h>
#include <manager/commands.h>
#include <scheduler/commands.h>
#include <condvar/commands.h>
#include <manager/hardware.h>
#include <dma/dma.h>
#include <arch/htime.h>



//#define ICAP_DEBUG 
//#define PRINT_DATA
//#define SLAVE_DEBUG
//#define DEBUG_DISPATCH


//#define PARTIAL_RECONFIG
//#define COMPACT_FLASH

#define ENC_BASE 0X86000000


struct Data {
    char * original;
    char * encrypted;
	char * decrypted;	
    hthread_mutex_t  *dmamutex;	
    hthread_time_t start;
    hthread_time_t stop;	
};





//threads for slave microblaze intracting with HW accelerator cores.
void * worker_master_thread(void* arg);
void * worker_slave_thread(void * arg);



// Conditional includes
#ifndef HETERO_COMPILATION
#include "encryp_prog.h"
#include <arch/htime.h>
#include <log/log.h>
#endif

#ifndef HETERO_COMPILATION


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else


int main(int argc, char *argv[])
{ 
        print("-- Starting main() --\r\n");
	Huint i,j;
	void * status;  	
	hthread_t     ms_thread;
   	hthread_t     slave_thread;

	hthread_attr_t ms_attr, slave_attr;
	hthread_attr_init( &ms_attr );
	hthread_attr_init( &slave_attr );

	struct Data ms_data;
	ms_data.original = "This is the trusted one# \n";
	j=thread_create(&ms_thread, &ms_attr, worker_master_thread_FUNC_ID, (void *) &ms_data, STATIC_HW0, 0);
	printf("created master thread, returned %i \n", j);
        j= hthread_join(ms_Thread, &status);  
	printf("joined on master thread, returned %i \n", j);
	printf("original message is :  %s \n", ms_data.orignial);
	printf("encrypted message is :  %s \n", ms_data.encrypted);
	printf("decrypted message is :  %s \n", ms_data.decrypted);

	
   

   print("\r\n-- Exiting main() --\r\n");
   return 0;
}


#endif


//==========================================================
//Function definitions.
//==========================================================

  

	
           
	
//======================================================================

void * worker_master_thread(void* arg)
{  
 

		
	struct Data *myarg = (struct Data *) arg;
	counter = 0;

	int * ptr = (int *) ENC_BASE;
	*(ptr+2) = 1; // high address  register 11
	*(ptr+3) = 4; // low address register 8


	//setup the table

	//setup the CORE
	*(ptr+4) = 1; //encryption mode
	*(ptr+6) = 10; //offset

    // Loop through each character until a NULL character is found
    while( myarg.original[counter] != (char)# )
    {
	*(ptr+5) = myarg.original[counter];
        counter = counter + 1;
	myarg.encrypted[counter]= *(ptr+7);
    }	

    counter=0;	
	*(ptr+4) = 0; //decryption mode		
    // Loop through each character until a NULL character is found
    while( myarg.original[counter] != (char)# )
    {
	*(ptr+5) = myarg.encrypted[counter];
        counter = counter + 1;
	myarg.decrypted[counter]= *(ptr+7);
    }		


    return (void*)0;
}


//=======================
void * worker_thread_sort(void * arg)
{

		struct Data *myarg = (struct Data *) arg;
myarg->start= hthread_time_get();
	register int i,j;
	putfslx(0, 1,FSL_DEFAULT);//reset the core
	// flush the FSL fifos from any junk data which might happen to be in there after PR.
 	for (i =0; i < 16; i++)      getfslx( j, 0, FSL_NONBLOCKING);
	Huint size;
	


	dma_config_t    dma_config;
	dma_t           dma;              
	dma_config.base=0x85050000;
	dma_create(&dma,&dma_config);
	size = myarg->endAddr - myarg->startAddr +1;

#if 1
	int chuncks ;
	chuncks = myarg->chuncks;
	
	 pipeline_sort(&dma, chuncks, myarg->startAddr , size);
	if (chuncks != 1)
		merge_sort(chuncks,  size,(int *)(ACC_GLOBAL_BRAM_A),myarg->startAddr );
	else
		//DMA the sorted data back to the dram.
		 transfer_dma(&dma, (void *) (ACC_GLOBAL_BRAM_A),myarg->startAddr,size*4);

	
#else
	transfer_dma(&dma, myarg->startAddr,(void *) (ACC_GLOBAL_BRAM_A),size*4);
	quickSort( (int *) (ACC_GLOBAL_BRAM_A), (int *) (ACC_GLOBAL_BRAM_A) +size-1 );

	//DMA the sorted data back to the dram.
	 transfer_dma(&dma, (void *) (ACC_GLOBAL_BRAM_A),myarg->startAddr,size*4);
#endif

myarg->stop= hthread_time_get();
	return (void *)(0); 
	 
}	

//=======================
void * worker_thread_vector(void * arg)
{

	//return;
	register int i,j;
	putfslx(0, 1,FSL_DEFAULT);//reset the core
	// flush the FSL fifos from any junk data which might happen to be in there after PR.
 	for (i =0; i < 100; i++)      getfslx( j, 0, FSL_NONBLOCKING);
	
	Data3 *myarg = (Data3 *) arg;
	
	
#if 1

	pipeline_vector(1, myarg->startAddr1,myarg->startAddr2,myarg->startAddr3, ARRAY_SIZE);

#else



		//transfer_dma(myarg->startAddr1, (void *)(ACC_GLOBAL_BRAM_A),ARRAY_SIZE*sizeof(Huint));
		dma_config_t    dma_config;
                dma_t           dma;              
                dma_config.base=0x85050000;
                dma_create(&dma,&dma_config);         
                dma_transfer(&dma,myarg->startAddr1, (void *)(ACC_GLOBAL_BRAM_A),ARRAY_SIZE*sizeof(Huint), DMA_SIZE_WORD, DMA_SOURCE_INC, DMA_DESTINATION_INC);
                while(!dma_getdone(&dma));
                if (dma_geterror(&dma)) {
                    printf("DMA ERROR\n");
                    return 1; }cp 


//3 ways to make the dma work	
		
	




		//transfer_dma(myarg->startAddr2, (void *)(ACC_GLOBAL_BRAM_B), ARRAY_SIZE*sizeof(Huint));     

                 dma_create(&dma,&dma_config);  //first
      		 dma_transfer(&dma,myarg->startAddr2, (void *)(ACC_GLOBAL_BRAM_B),ARRAY_SIZE*sizeof(Huint), DMA_SIZE_WORD, DMA_SOURCE_INC, DMA_DESTINATION_INC);
                while(!dma_getdone(&dma));
                if (dma_geterror(&dma)) {
                    printf("DMA ERROR\n");
                    return 1; }

//second
 //dma_transfer(&dma,myarg->startAddr2, (void *)(0xD0000000),1*sizeof(Huint), DMA_SIZE_WORD, DMA_SOURCE_INC, DMA_DESTINATION_INC);
                //while(!dma_getdone(&dma));
                //if (dma_geterror(&dma)) {
                //    printf("DMA ERROR\n");
                //    return 1; }


		

//third
		//putnum(10);
		//for (i =0; i < 1500; i++)      getfslx( j, 0, FSL_NONBLOCKING);


		putfslx(48, 0, FSL_DEFAULT);
		putfslx((Huint)ARRAY_SIZE, 0, FSL_DEFAULT);
		putfslx(0, 0, FSL_DEFAULT);

		//putfslx((00 << 30) | (ARRAY_SIZE << 15) | 0, 0, FSL_DEFAULT);

		
		getfslx(i, 0, FSL_DEFAULT);

#if 0
		putfslx(48, 0, FSL_DEFAULT);
		putfslx((Huint)ARRAY_SIZE, 0, FSL_DEFAULT);
		putfslx(0, 0, FSL_DEFAULT);


		//putfslx((00 << 30) | (ARRAY_SIZE << 15) | 0, 0, FSL_DEFAULT);

		
				
		getfslx(i, 0, FSL_DEFAULT);
 #endif  

		   
		//transfer_dma((void *)(ACC_GLOBAL_BRAM_C), myarg->startAddr3, ARRAY_SIZE*sizeof(Huint));	
		dma_transfer(&dma, (void *)(0XE0020000),myarg->startAddr3, ARRAY_SIZE*sizeof(Huint), DMA_SIZE_WORD, DMA_SOURCE_INC, DMA_DESTINATION_INC);
                while(!dma_getdone(&dma));
                if (dma_geterror(&dma)) {
                    printf("DMA ERROR\n");
                    return 1; }
 #endif

	return (void *) (0);
}
 
//====================================================================================
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
              //printf( "result is %x , i is %i \n " , result , i );           
             
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


//===========================
void quickSort(Huint * startPtr, Huint * endPtr) {
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
	
	quickSort( rightPtr, endPtr );
	quickSort( startPtr, leftPtr );
}

//===========================
int bubble_sort(int * n, int * array)
{
	int i=0;
	int n_new;
	int swapped=0;
	int temp;
	//printf ( " n is %i\r\n", n);
	while(1){
	
		if  (i>= *n){		  
		   *n=n_new;
		    return swapped;}
		 if (array[i] > array[i+1]){
		     temp=array[i];
		     array[i]=array[i+1];
		     array[i+1]= temp;
		     swapped=1;
		     n_new=i;}
		  i++;
        }
return 0;

}

//==============================================================================
void * sw_quicksort( void * arg ) 
{
	struct Data * data=(struct Data *) arg;;
	
	fflush( stdout );
        quickSort( data->startAddr, data->endAddr );

	return 0;
}

//===========================
void * sw_bubblesort( void * arg ) 
{
        struct Data * data=(struct Data *) arg;
        int *array;
        array=(int *) data->startAddr;
       

	typedef enum
	{
	reset,
	idle,
	before_begin,
	begin_sort,
	for_loop,
	cond_check,
	cond_body
	} STATE_MACHINE_TYPE;
	STATE_MACHINE_TYPE current_state, next_state = reset;

	// ****************************************************
	// Definitions for FSM signals
	// ****************************************************
	int swapped, swapped_next;
	int i, i_next;
	int n, n_next;
	int n_new, n_new_next;
	int data1, data1_next;
	int data2, data2_next;
	
      //****************************************************
      // Initialization for FSM signals
      // ****************************************************
      swapped = 0;
      i = 0;
      n = 0;
      n_new = 0;
      data1 = 0;
      data2 = 0;

      // ****************************************************
       // FSM Loop...
      // ****************************************************
       while(1){

          // ****************************************************
          // Transition all state variables
          // ****************************************************
          // Transition the current state
          current_state = next_state;

          // Transition all signals
          swapped = swapped_next;
          i = i_next;
          n = n_next;
          n_new = n_new_next;
          data1 = data1_next;
          data2 = data2_next;


          // ****************************************************
          // FSM Body
          // ****************************************************
         
          switch (current_state) {
            case before_begin :             
              n_new_next = n;                
              next_state = begin_sort;
              break;
            case begin_sort :             
              if ( ( swapped == 0 ) ) {                
               return 0;
              }
              else if ( ( swapped == 1 ) ) {
               
                swapped_next = 0;
                i_next = 0;
                data1_next = array[0];
                next_state = for_loop;
              }
              
              break;
            case cond_body :
             
              array[i + 1] = data1;
              n_new_next = i;
              swapped_next = 1;
              i_next = i + 1;
               
              next_state = for_loop;
              break;
            case cond_check :
              
              if ( ( data1 <= data2 ) ) {
                
                data1_next = data2;
                i_next = i + 1;
                next_state = for_loop;
              }
              else if ( ( data1 > data2 ) ) {
               
                array[i] = data2;
                next_state = cond_body;
              }
              
              break;
            case for_loop :
             
              if ( ( i >= n ) ) {
               
                n_next = n_new;
                next_state = begin_sort;
              }
              else if ( ( i < n ) ) {
              
                data2_next = array[i + 1];
                next_state = cond_check;
              }
              
              break;            
            case idle : 
              n_next = ARRAY_SIZE-1;
              swapped_next = 1;                
              next_state = before_begin;
              break;
            case reset :   
              next_state = idle;
              break;
            default :
              next_state = reset;
              break;
          }

       }
    

      return 0;
}
//===========================
void * sw_bubblesortfast( void * arg ) 
{
        struct Data * data=(struct Data *) arg;
        int *array;
        array=(int *) data->startAddr;
        int n;
        n= ARRAY_SIZE-1;
        int i,n_new,swapped,temp;
	while ( 1) {       
        i=0;	
	swapped=0;	
	while(i<n){		
		 if (array[i] > array[i+1]){
		     temp=array[i];
		     array[i]=array[i+1];
		     array[i+1]= temp;
		     swapped=1;
		     n_new=i;}
		  i++;
                }
         n=n_new;
         if (swapped == 0 )      
            return 0;      
                
        }
    
return 1;      
	
}



//===========================
void * sw_crc(void * arg)
{


   Hint i,j;
   
   struct Data *myarg = (struct Data *) arg;
   
   //generating the CRC'ed data for each input
   Hint *ptr;
   for ( ptr=myarg->startAddr ; ptr<=myarg->endAddr ; ptr++)
      *ptr= gen_crc(*ptr);
     

   


    return (void*)0;
}
