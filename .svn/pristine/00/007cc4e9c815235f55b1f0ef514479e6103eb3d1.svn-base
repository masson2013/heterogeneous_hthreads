#include "mbhwti.h"
#include <stdio.h>
#include <errno.h>
#include <hthread.h>
#include "time_lib.h"
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


struct matrix {	
	Huint size;	
	Huint * X;
	Huint * Y;
	Huint * Z;	
        Huint var2;
	char * format1;
        char * format2;	
};


struct sortData {
    Huint * startAddr;
    Huint * endAddr;
    Huint cacheOption;
    char * format1;
    char * format2;	
};


 struct crc_data {
    Huint size;
    Huint * startAddr;
   
    char * format1;
    char * format2;
} ;



//#define SLAVE_DEBUG
//#define DEBUG_DISPATCH
//==========================================================
//Workerer thread
//==========================================================

#define STACKSIZE			 80	//in words


#ifdef SLAVE_DEBUG
#define SEND(VALUE,FUNC)  putfslx( (int) VALUE, 0, FSL_DEFAULT);        putfslx( (int) FUNC, 1, FSL_DEFAULT);\
                          print(targ->format2);print(targ->format2);putnum(VALUE); print(targ->format2);putnum(FUNC); print(targ->format1);
#else
#define SEND(VALUE,FUNC)  putfslx( (int) VALUE, 0, FSL_DEFAULT);                     putfslx( (int) FUNC, 1, FSL_DEFAULT);                       
#endif

void * worker_thread(void* arg)
{  

#ifdef SLAVE_DEBUG
         struct matrix * targ = (struct matrix *)arg;	  
#endif

    register int from_user_opcode;
    register int from_user_func;
    int from_user_addr;
    int from_user_val;    
    int to_user_val;        
    register int from_userFSL2;    
    
   // int stack[STACKSIZE];
    int *stack =0x00004000;//To get access to whole stack of 128kbyte
    int stackptr = 0; 
    int frameptr = 0;
    int param_count = 0;
   
   //replacement for hthread_self()
    //int tid = extract_id((*(volatile Huint*)(encode_cmd(0,HT_CMD_CURRENT_THREAD))));
    Hint i;
    Huint cmd; //for condition variable calls
    int tid= _current_thread();
   

    //first argument
    stack[stackptr++] = (int)arg; 
    //initial number of parameters
    stack[stackptr++]=1;  
    //initial return frame pointer
    stack[stackptr++]=0;  
    //return state
    stack[stackptr++]=0;  
    frameptr = stackptr;
   
    int cnt;
	for (cnt =0; cnt < 100; cnt++){
       // in order to flush the FSL fifos from any junk data which might happen to be in there after PR of HWhtreads.
        getfslx( from_user_val, 0, FSL_NONBLOCKING);
	getfslx( from_user_addr, 1, FSL_NONBLOCKING);
	getfslx( from_userFSL2, 2, FSL_NONBLOCKING);}

    //Tell accelerator to go once thread has been dispatched - func must be 0x3 
    putfslx( 0, 0, FSL_DEFAULT);    putfslx( 0x00030000, 1, FSL_DEFAULT);   
    //SEND(0,0x00030000);    
   
    do {
	//Read from user core
	getfslx( from_user_val, 0, FSL_DEFAULT);
	getfslx( from_user_addr, 1, FSL_DEFAULT);
	getfslx( from_userFSL2, 2, FSL_DEFAULT);

	//Decipher commands
	from_user_opcode = 0 + ((from_userFSL2 & OPCODE_MASK) >> 10);
	from_user_func = 0 + ((from_userFSL2 & FUNC_MASK) >> 16);              
#ifdef SLAVE_DEBUG     
  putnum(from_user_opcode); print(targ->format2);putnum(from_user_func); print(targ->format2);putnum(from_user_addr); print(targ->format2);putnum(from_user_val);
#endif
	switch(from_user_opcode)
	{
	    case(OPCODE_LOAD):
		//return data from address givhen by user in value field
		to_user_val = (*(int*)(from_user_addr));		
		SEND(to_user_val,0x00020000);
		break;


	    case(OPCODE_STORE):
		//store to address given by user
		(*(int*)(from_user_addr)) = from_user_val;
		SEND(0,0x00020000);
		break;


	    case(OPCODE_DECLARE):
                stackptr+= from_user_val;
                param_count+= from_user_val;
                SEND(0,0x00020000);
		break;

	    case(OPCODE_READ):
                to_user_val = stack[frameptr+from_user_addr]; 
                SEND(to_user_val,0x00020000);
		break;

	    case(OPCODE_WRITE):
                stack[frameptr+from_user_addr] = from_user_val;
                SEND(0,0x00020000);

		break;

	    case(OPCODE_ADDRESS):
		
                ;unsigned int priority = (*(volatile Huint*)(sched_cmd(0, tid, HT_CMD_SCHED_GETSCHEDPARAM)));               
                to_user_val =from_user_val +frameptr+priority;
                SEND(to_user_val,0x00020000);
		break;


	    case(OPCODE_PUSH): 
		if(stackptr < STACKSIZE - 1)
		{
		    stack[stackptr++] = from_user_val;
		    param_count++;
		}
		else
		    to_user_val = 0;//error

                SEND(0,0x00020000);
                    
		break;


	    case(OPCODE_POP):
                		
		if(stackptr > 0 && stackptr < STACKSIZE){
		    if(stack[frameptr-3] > from_user_val){
			to_user_val = stack[(frameptr-from_user_val)-4];
		    }
		
		}
		else
		    to_user_val = 0;//error

		SEND(to_user_val,0x00020000);
		break;



	    case(OPCODE_CALL):
		switch(from_user_func)
		{
		    case(FUNCTION_HTHREAD_SELF):
			tid = hthread_self();
                        SEND(tid,from_user_val<< 16);
    			
			break;

		    case(FUNCTION_HTHREAD_CREATE):
			//first get place to store tid
			;hthread_t* create_tid = (hthread_t*) stack[--stackptr];
			//then get address of attribute (or 
			hthread_attr_t* create_attr = (hthread_attr_t*) stack[--stackptr];
			//and address of function
			void* create_func = (void*)stack[--stackptr];

			if(create_attr == 0)
			    hthread_create(create_tid, NULL, create_func, (void*)stack[--stackptr]);
			else
			    hthread_create(create_tid, create_attr, create_func, (void*)stack[--stackptr]);
			break;

			SEND(0, from_user_val<<16);

		    case(FUNCTION_HTHREAD_JOIN):
			//need tid of thread to join
			;hthread_t* join_tid = (hthread_t*)stack[--stackptr];
			void* return_val = (void*)stack[--stackptr];
			//need addr to store return value
			hthread_join(*join_tid, &return_val);

			
			break;

		    case(FUNCTION_HTHREAD_YIELD):
			hthread_yield(); //does nothing as a HW thread
			break;

		    case(FUNCTION_HTHREAD_EQUAL):
                          ;hthread_t* equal_tid = (hthread_t*)stack[--stackptr]; 
                          // If the two thread IDs are equal, pthread_equal() returns a nonzero value;  otherwise, it returns 0.This function always succeeds.
                          to_user_val= hthread_equal(*equal_tid, *(hthread_t*)stack[--stackptr]);
                          SEND(to_user_val,from_user_val<<16);
                        
			break;

		    case(FUNCTION_HTHREAD_EXIT):
			return( stack[--stackptr]);                  
			break;

		    case(FUNCTION_HTHREAD_EXIT_ERROR):
			break;

		    case(FUNCTION_HTHREAD_MUTEXATTR_INIT):
			break;

		    case(FUNCTION_HTHREAD_MUTEXATTR_DESTROY):
			break;

		    case(FUNCTION_HTHREAD_MUTEXATTR_SETNUM):
			break;

		    case(FUNCTION_HTHREAD_MUTEXATTR_GETNUM):
			break;

		    case(FUNCTION_HTHREAD_MUTEX_INIT):
			;hthread_mutex_t* temp_mtx = (hthread_mutex_t*) stack[--stackptr];
			hthread_mutexattr_t* temp_mtxattr = (hthread_mutexattr_t*) stack[--stackptr];
			if((int)temp_mtxattr == 0)
				hthread_mutex_init(temp_mtx, NULL);
			else
				hthread_mutex_init(temp_mtx, temp_mtxattr);		
			
			
                        SEND(0,from_user_val<< 16); //??
			break;

		    case(FUNCTION_HTHREAD_MUTEX_DESTROY):
			break;

                     case(FUNCTION_HTHREAD_MUTEX_LOCK):
			//-- Read the parameter the user passed in
	                //-- Parameter should be previously initialized mutex struct's address
			;hthread_mutex_t* lock_mtx = stack[--stackptr];

			//--------|--load command--|-pack bits-|-command type-|-id of thread-|--mutex to lock--|
			i = (*(volatile Huint*)(mutex_cmd( HT_MUTEX_LOCK, tid, lock_mtx->num)));
			if(i == HT_MUTEX_BLOCK)
			    _run_sched(Htrue);
			
			if(i != SUCCESS)
			    to_user_val = 1;	//if we have an error, inform user
			else
			    to_user_val =0; //otherwise, tell user to return to it's next state

			SEND(to_user_val,from_user_val<< 16);
			break;

		    case(FUNCTION_HTHREAD_MUTEX_UNLOCK):
			;hthread_mutex_t* unlock_mtx = stack[--stackptr];

			//|--load command--|pack bits|--command type--|-id of thread-|--mutex to unlock--|
			((*(volatile Huint*)mutex_cmd( HT_MUTEX_UNLOCK, tid, unlock_mtx->num))); //TODO : revert it back to hthread_self()
			//hthread_mutex_unlock((hthread_mutex_t*) stack[--stackptr]);
		
			SEND(0,from_user_val<< 16);
			break;

		    case(FUNCTION_HTHREAD_MUTEX_TRYLOCK):
			;hthread_mutex_t* try_mtx = stack[--stackptr];

			//-----|--load command--|-pack bits-|-command type-|-id of thread-|-mutex to try-|
			while((*(volatile Huint*)(mutex_cmd( HT_MUTEX_TRY,tid, try_mtx->num))) != 0);

			SEND(0, from_user_val<<16);
			break;

                   


                   case(FUNCTION_HTHREAD_COND_WAIT):
			//take previously-initialized cond_var from stack
			;hthread_cond_t* wait_cond = (hthread_cond_t*) stack[--stackptr];
			//also take currently-held mutex from stack
			//hthread_cond_wait(wait_cond, (hthread_mutex_t*)(stack[--stackptr]));

			hthread_mutex_t* cond_mtx = (hthread_mutex_t*) stack[--stackptr];
			//try to perform a wait while the condvar manager is busy
			cmd = cvr_sema_cmd(HT_CMD_WAIT, tid, wait_cond->num);
			do
			{
		    	    i = (*(volatile Huint*)(cmd));
			} while( i == HT_CONDVAR_FAILED);

			//then unlock the owned mutex
			i = (*(volatile Huint*)mutex_cmd( HT_MUTEX_UNLOCK, tid, cond_mtx->num));
			//if( sta != SUCCESS )  return sta;

			//and wait
			_run_sched( Htrue );

			//once we are awoken (after a broadcast)
			//  attempt to lock the mutex
		 	i = (*(volatile Huint*)mutex_cmd( HT_MUTEX_LOCK, tid, cond_mtx->num));
			if(i == HT_MUTEX_BLOCK)
			    _run_sched(Htrue);

			//will return once we've been signalled
			//and will tell user to return to what it was doing
                        SEND(0,from_user_val<< 16);
			break; 

                    case(FUNCTION_HTHREAD_COND_BROADCAST):
			;hthread_cond_t* broadcast_cond = (hthread_cond_t*) stack[--stackptr];
			//hthread_cond_broadcast(broadcast_cond);

			// Form the address used to issue the command to the condition variables
			cmd = cvr_sema_cmd( HT_CMD_BROADCAST, 0, broadcast_cond->num );

			// Continue to loop while the condition variable core says that its busy
			do
			{
			    i = (*(volatile Huint*)( cmd ));
			} while( i == HT_CONDVAR_FAILED );

                        SEND(0,from_user_val<< 16);
			break; 

                     
                    case(FUNCTION_HTHREAD_COND_SIGNAL):
			;hthread_cond_t* signal_cond = (hthread_cond_t*) stack[--stackptr];
			//hthread_cond_signal(signal_cond);
			// Form the address used to issue the command to the condition variables
		        cmd = cvr_sema_cmd( HT_CMD_SIGNAL, 0, signal_cond->num );

		        // Continue to loop while the condition variable core says that its busy
		        do
		        {
		             i = (*(volatile Huint*)( cmd ));
		        } while( i == HT_CONDVAR_FAILED );


                        SEND(0,from_user_val<< 16);
			break; 
                  

		    default:	//User-defined function
			//first write number of params to the stack
			stack[stackptr++] = param_count;
			param_count = 0;
			//write frame pointer to stack
			stack[stackptr++] = frameptr;
			//write return state to stack
			stack[stackptr++] = from_user_val;
			//update stack and frame pointer
			frameptr = stackptr;

			//***********************************************
			// first parameter passed to function        <---- frameptr - 4
			// number of parameters passed to function   <---- frameptr - 3
			// old frameptr                              <---- frameptr - 2
			// return state                              <---- frameptr - 1
			//**********************************************

			SEND(0,from_user_func<<16);
			break;
                    
		}

		break;

	    case(OPCODE_RETURN):
		//set the return value
		to_user_val = from_user_val;
		//read return state
		int to_user_func = stack[frameptr-1];
		//read number of parameters invovled in this function
		stackptr = (frameptr - 3) - stack[frameptr-3];
		//restore frame pointer
		frameptr = stack[frameptr - 2];

		SEND(to_user_val, to_user_func<<16);
		break;

	    default:	//i.e. NOOP
		break;
	}

    } while (1);


    return (void*)0;

}





// Conditional includes
#ifndef HETERO_COMPILATION
#include "mbhwti_prog.h"
#include <arch/htime.h>
#include <log/log.h>



void readHWTStatus( void* baseAddr) {
    printf( "Timer is :: %i us \n", read_reg(baseAddr+0x00000004)/100 );
    printf( "HWT Result %i us \n", read_reg(baseAddr + 0x00000014)/100 );
   /* printf( "  HWT Thread ID %x \n", read_reg(baseAddr) );
    printf( "  HWT Status  %x \n", read_reg(baseAddr + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(baseAddr + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(baseAddr + 0x00000010) );
    printf( "  HWT Result %i \n", read_reg(baseAddr + 0x00000014) );
    printf( "  HWT Reg Master Write %x \n", read_reg(baseAddr + 0x00000024) );
    printf( "  HWT DEBUG SYSTEM %x \n", read_reg(baseAddr + 0x00000028) );
    printf( "  HWT DEBUG USER %x \n", read_reg(baseAddr + 0x0000002C) );
    printf( "  HWT Timer %d \n", read_reg(baseAddr + 0x00000034) );
    printf( "  HWT Stack Pointer %x \n", read_reg(baseAddr + 0x00000038) );
    printf( "  HWT Frame Pointer %x \n", read_reg(baseAddr + 0x0000003C) );
    printf( "  HWT Heap Pointer %x \n", read_reg(baseAddr + 0x00000040) );*/
}

int vectoradd (int opb_hwti,int size )
{
	hthread_attr_t      hwAttr;
	hthread_t           hwThread;
	
	struct matrix       matrixData;
	Huint           i, j;  
	hthread_time_t start,stop,diff;
	
	void *status;

	
	hthread_attr_init(&hwAttr);
	// Initialize matrixData
	matrixData.size = size;
if (opb_hwti==1)
{	
	matrixData.X = (Huint *) (0xE0000000);
	matrixData.Y = (Huint *) (0xE0004000);
	matrixData.Z = (Huint *) (0xE0008000);	
}
else
{
	matrixData.X = (Huint *) (0xE0010000);
	matrixData.Y = (Huint *) (0xE0014000);
	matrixData.Z = (Huint *) (0xE0018000);	

}
	
	for( i = 0; i < size; i++ ) {		matrixData.X[i] = i;		matrixData.Y[i] = i;		matrixData.Z[i] = 0;	}
	
 #ifdef SLAVE_DEBUG
	printf("Opcode    Function     Address     Value       Value_MB   Address_MB\r\n");
	matrixData.format1="\n\r"; matrixData.format2="   "; 
#endif 	


        start=hthread_time_get();   
	if (opb_hwti==1){
		hthread_attr_sethardware( &hwAttr, 0x63000000 );
	        j = hthread_create( &hwThread, &hwAttr, NULL, (void*)(&matrixData) );}	
	else{
	   
	       j= microblaze_create(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&matrixData),0); 
	}	   
	    	
        
	//printf( "HW thread created, returned %x\n", j ); 
	
	 j= hthread_join(hwThread, &status);
         stop=hthread_time_get();
         hthread_time_diff(diff, stop, start);	       
	 printf("exe_time:%.0f us \r\n",hthread_time_usec(diff));
#ifdef MORE_INFO
	printf( "hthread_join , returned %i\n",status);	
	if (opb_hwti==1)	readHWTStatus(0x63000000);
#endif

	for( i = 0; i < size; i++ ) {if ( matrixData.Z[i] != 2 * i ) {printf( "\n*********Error at %i, matrix is %i ********\n", i, matrixData.Z[i] ); return 1;}	}	
        hthread_attr_destroy( &hwAttr );       
	
	return 0;
}

int quicksort(int opb_hwti,int size)
{
	hthread_attr_t      hwAttr;
	hthread_t           hwThread;
	struct sortData input;
	Huint           i, j;		
	hthread_attr_init( &hwAttr );
	void *status;
	hthread_time_t start,stop,diff;
if (opb_hwti==1)
	input.startAddr = (Huint*) (0xE0000000);
else
	input.startAddr = (Huint*) (0xE0020000);

	input.endAddr = input.startAddr + size - 1;
	Huint * ptr;
	for( ptr = input.startAddr , i=0; ptr <= input.endAddr; ptr++ ,i++) *ptr = (size-i);	
	input.cacheOption = 0;	
	//for( i=0; i<ARRAY_SIZE; i++ )	printf( " %i \n",* (input.startAddr+i) );

#ifdef SLAVE_DEBUG
	printf("Opcode    Function     Address     Value       Value_MB   Address_MB\r\n");
	input.format1="\n\r"; input.format2="   "; 
#endif      

	start=hthread_time_get();
	if (opb_hwti==1){
		hthread_attr_sethardware( &hwAttr, 0x63010000 );
	        j = hthread_create( &hwThread, &hwAttr, NULL, (void*)(&input) );}	
	else	
	   
	       j= microblaze_create(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&input),1);
	  
	//printf( "HW thread created, returned %i\n", j );        
	j= hthread_join(hwThread, &status);
         stop=hthread_time_get();
         hthread_time_diff(diff, stop, start);	       
	 printf("exe_time:%.2f us \r\n",hthread_time_usec(diff));
#ifdef MORE_INFO
	printf( "hthread_join , returned %i\n",status);	
	if (opb_hwti==1)	readHWTStatus(0x63010000);
#endif	
	//for( i=0; i<ARRAY_SIZE; i++ ) printf( " %i \n",* (input.startAddr+i) );
        for( i=0; i<(size-1); i++ )  if  ((* (input.startAddr+i)) > (* (input.startAddr+i+1)))  	       { printf( "\n ******************Error********\n" );return 1;}
	
	return 0;

}

//====================================================================================
// Author: Abazar
#define G_INPUT_WIDTH 32
#define G_DIVISOR_WIDTH 4

Hint gen_crc( Hint input)
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

int crc(int opb_hwti,int size)
{
	hthread_attr_t      hwAttr;
	hthread_t           hwThread;
	struct crc_data input,input_check;
	Huint           i, j;		
	hthread_attr_init( &hwAttr );
	void *status;
	hthread_time_t start,stop,diff;

 
        input.size= size;
if (opb_hwti==1)
	input.startAddr = (Huint*) (0xE0000000);
else
	input.startAddr = (Huint*) (0xE0030000);

        input_check.startAddr = (Huint*) (malloc(sizeof(Huint) *size));
	
	Huint * ptr;
	for( ptr = input.startAddr , i=0; i<size; ptr++ ,i++)  *ptr =*(input_check.startAddr+i) =(rand() % 1000) * 8;	
	
	//for( i=0; i<5; i++ )	printf( " %i , %i \n",* (input.startAddr+i), * (input_check.startAddr+i) );

#ifdef SLAVE_DEBUG
	printf("Opcode    Function     Address     Value       Value_MB   Address_MB\r\n");
	input.format1="\n\r"; input.format2="   "; 
#endif      

	start=hthread_time_get();
	if (opb_hwti==1){
		hthread_attr_sethardware( &hwAttr, 0x63020000 );
	        j = hthread_create( &hwThread, &hwAttr, NULL, (void*)(&input) );}	
	else	
	   
	       j= microblaze_create(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&input),2);
	  
	//printf( "HW thread created, returned %i\n", j );        
	j= hthread_join(hwThread, &status);
         stop=hthread_time_get();
         hthread_time_diff(diff, stop, start);	       
	 printf("exe_time:%.2f us \r\n",hthread_time_usec(diff));
#ifdef MORE_INFO
	printf( "hthread_join , returned %i\n",status);	
	if (opb_hwti==1)	readHWTStatus(0x63020000);
#endif	
	//for( i=0; i<5; i++ ) printf( " %i , %i \n",* (input.startAddr+i)  , gen_crc(*(input_check.startAddr+i) ));
        for( i=0; i<(size-1); i++ )  if  (  (* (input.startAddr+i)) != gen_crc(*(input_check.startAddr+i))   )  { printf( "\n ******************Error********\n" );return 1;}
	
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
   for (data_size=64; data_size<=4096 ; data_size*=2)
{
   printf("VectorAdd  on Microblaze 0,data_size=%i,  ",data_size);
   vectoradd(0,data_size);  
   printf("quicksort  on Microblaze 1,data_size=%i,  ",data_size);  
   quicksort(0,data_size);  
   printf("crc        on Microblaze 2,data_size=%i,  ",data_size);  
   crc(0,data_size);  


   printf("VectorAdd  on opb_hwti,    data_size=%i,  ",data_size);  
   vectoradd(1,data_size);  
   printf("quicksort  on opb_hwti,    data_size=%i,  ",data_size);  
   quicksort(1,data_size);    
   printf("crc        on opb_hwti,    data_size=%i,  ",data_size);  
   crc(1,data_size);  
   printf("***************************************************\n");
}   
 

   
    printf("FINISH\n");
    return 0;
}

#endif
