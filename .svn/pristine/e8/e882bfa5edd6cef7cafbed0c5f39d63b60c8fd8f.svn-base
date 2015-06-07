/*********** PLATFORM : SMP1 **********************************/
#include <stdio.h>
#include <errno.h>
#include <hthread.h>
//#include "time_lib.h"
#include "fsl.h"
#include <stdlib.h>
#include <string.h>
#include <util/rops.h>
#include <stdlib.h>
#include <sys/core.h>
#include <sys/syscall.h>
#include <manager/commands.h>
#include <scheduler/commands.h>
#include <condvar/commands.h>
#include <manager/hardware.h>
#include <dma/dma.h>


#define SIZE 32

struct sortData {
    Huint * startAddr;
    Huint * endAddr;
    char * format1;
    char * format2;	
};





//#define SLAVE_DEBUG
//#define DEBUG_DISPATCH
//==========================================================
//Workerer thread
//==========================================================

#define STACKSIZE			 300	//in words

void reset_accelerator(unsigned char fifo_depth) {

    // Reset the accelerator
    putfslx( 0, 1, FSL_DEFAULT);

    // Clean up any junk data between slave and Acc FIFO
    register unsigned char i, j;
    for (i = 0; i < fifo_depth; i++)
        getfslx(j, 0, FSL_NONBLOCKING);
}

// -------------------------------------------------------------- //
//                     DMA Transfer Wrapper                       //
// -------------------------------------------------------------- //
int transfer_dma(dma_t * dma, void * src, void * des, int size) {
    dma_reset(dma);        
    dma_transfer(dma, src, des, size, DMA_SIZE_WORD, DMA_SOURCE_INC, DMA_DESTINATION_INC);

    // Wait until done
    while(!dma_getdone(dma));

    // Check for any errors
    if (dma_geterror(dma)) 
        return FAILURE;
    else
        return SUCCESS;
} 





void wait_4_acc(void * arg)
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
    
    
   // int stack[STACKSIZE];
    int *stack =0x00002000;//To get access to whole stack of 128kbyte
    int stackptr = 0; 
    int frameptr = 0;
    int param_pushed_count = 0;
    int param_popped_count = 0;
    int ret=0;
    int max_stack =0;
   
   
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
  

         struct sortData * targ = (struct sortData *)arg;	  
     

   
    do {

   //if (stackptr >max_stack) max_stack=stackptr; 
   //ret++;   
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
          //  putnum(ret); putnum(max_stack);
              
		return (void*)0;
                break;

	    default:	//i.e. NOOP
		break;
	}
 #ifdef SLAVE_DEBUG     
putnum(opcode); print(targ->format2);putnum(param1);print(targ->format2);putnum(param2); print(targ->format2);putnum(mb_ret); print(targ->format1);
#endif

    } while (1);


    

}


void * worker_thread(void* arg)
{  
 struct sortData * targ = (struct sortData *)arg;	
            // Reset the core    
            reset_accelerator(16);
            int size=(targ->endAddr - targ->startAddr ) +1;

    dma_t local_dma;
    dma_config_t local_dma_config;
    local_dma_config.base = 0x84050000;
    dma_create(&local_dma, &local_dma_config);
	
  
	//transfer the data to local bram
	transfer_dma(&local_dma, (void *) targ->startAddr, (void *) 0xE0000000, size*4);


	//Tell the acc to go , with start and end addr
	putfslx((  ((size-1)*4)    <<15)| 0   , 0,FSL_DEFAULT);	//endaddr,startaddr  //FIX TODO

	 wait_4_acc((void *) arg);


	//transfer the data back from local bram
	transfer_dma(&local_dma,  (void *) 0xE0000000, (void *) targ->startAddr, size*4);


            return 0;
}



// Conditional includes
#ifndef HETERO_COMPILATION
#include "smp1_prog.h"
#include <arch/htime.h>
#include <log/log.h>




int quicksort(int size)
{
	hthread_attr_t      hwAttr;
	hthread_t           hwThread;
	struct sortData input;
	Huint           i, j;		
	hthread_attr_init( &hwAttr );
	void *status;
	hthread_time_t start,stop,diff;
	//input.startAddr = (Huint*) (0xE0000000);
        input.startAddr= (Huint*)malloc (sizeof(Huint) *size);
	input.endAddr = input.startAddr + size - 1;
 

	Huint * ptr;
	for( ptr = input.startAddr , i=0; ptr <= input.endAddr; ptr++ ,i++)  *ptr= rand() %1000 ; //*ptr = (size-i);	
	//for( i=0; i<100; i++ )	printf( " %i \n",* (input.startAddr+i) );

#ifdef SLAVE_DEBUG
	printf("Opcode     param1     param2     mb_ret \r\n");
	input.format1="\n\r"; input.format2="   "; 
#endif      

	start=hthread_time_get();
	   
	j= microblaze_create(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&input),0);
	  
	//printf( "HW thread created, returned %i\n", j );        
	j= hthread_join(hwThread, &status);
         stop=hthread_time_get();
         hthread_time_diff(diff, stop, start);	       
	 printf("exe_time:%.2f us \r\n",hthread_time_usec(diff));
	//printf( "hthread_join , returned %i\n",status);	
	

	//for( i=0; i<100; i++ ) printf( " %i \n",* (input.startAddr+i) );
        for( i=0; i<(size-1); i++ )  if  ((* (input.startAddr+i)) > (* (input.startAddr+i+1)))        { printf( "\n *********Error at location %i********\n", i );return 1;}
	
	return 0;

}


        
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
   
   
int data_size;
   for (data_size=4096; data_size<=4096 ; data_size*=2)
{
   
   printf("quicksort  on Microblaze 1,data_size=%i,  ",data_size);  
   quicksort(data_size);     
   printf("***********************************\n");
}   
 

   
    printf("FINISH\n");
    return 0;
}

#endif
