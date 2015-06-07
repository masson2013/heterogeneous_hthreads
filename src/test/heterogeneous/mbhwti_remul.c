/*********** PLATFORM : HWTI_MBLAZE_6SMP **********************************/
#include "mbhwti.h"
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

#define MATRIXSIZE 100
struct matrix {	
	Huint size;
	Huint index;
	Huint * X;
	Huint * Y;
	Huint * Z;
	hthread_mutex_t * matrixMutex;
        Huint var2;
	char * format1;
        char * format2;	
};

#define ARRAY_SIZE 20
struct sortData {
    Huint * startAddr;
    Huint * endAddr;
    Huint cacheOption;
    Huint * X;
    Huint * Y;
    Huint * Z;	
    Huint var2; 	
    char * format1;
    char * format2;	
};



#define SIZE 1000
struct data {       
	Huint size;
	hthread_mutex_t * myMutex1;
        hthread_cond_t  *myCond1;  
        hthread_mutex_t * myMutex2;
        hthread_cond_t  *myCond2;  
        Huint var1;
        Huint var2;
        char * format1;
        char * format2;

};

#define DEBUG 1
//#define PRINT_DATA
//#define SLAVE_DEBUG
#define DEBUG_DISPATCH
#define PARTIAL_RECONFIG
//#define COMPACT_FLASH

//==========================================================
//Worker thread
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
    
    int stack[STACKSIZE];
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
#include "mbhwti_remul_prog.h"
#include <arch/htime.h>
#include <log/log.h>
#include "recon.h"
#endif


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else


static	XSysAce SysAce;
static	XHwIcap_Config *ConfigPtr;


int main(int argc, char *argv[])
{ 
	int Status;        
       	hthread_time_t start,stop;
	Huint i,j;	
	print("-- Starting main() --\r\n");
//==============================================================================
//Initiliazing ICAP and ACE contorller
//==============================================================================     
	Status = XSysAce_Initialize(&SysAce, XPAR_SYSACE_0_DEVICE_ID);
	if (Status != XST_SUCCESS) return XST_FAILURE;
	print("System ACE Controller Initialized\r\n");
	
	ConfigPtr = XHwIcap_LookupConfig(XPAR_HWICAP_0_DEVICE_ID);
	if (ConfigPtr == NULL) 	return XST_FAILURE;	
	print("After HWICAP LookupConfig\r\n");
	
	Status = XHwIcap_CfgInitialize(&HwIcap, ConfigPtr,ConfigPtr->BaseAddress);
	if (Status != XST_SUCCESS) return XST_FAILURE;	
	print("HWICAP Initialized\r\n");  
	//key = XUartLite_RecvByte(XPAR_RS232_UART_1_BASEADDR);Xil_Out32(HWTI_BASEADDR+0x00000200,0x0000000A);//printf("\033[H\033[J"); //clears the screen   


//==============================================================================
//Creating threads to run on Microblazes using accelerators
//==============================================================================    
	

#if 0
        struct sortData  sort_data1 ; init_bubblesort_data(&sort_data1);
	print("\r\n***********bubble_sort(0,&data)**************\r\n");  
	//bubble_sort(&sort_data1);

	struct sortData  sort_data2 ; init_bubblesort_data(&sort_data2);
       	print("\r\n***********bubble_sort(1,&data)**************\r\n");  
	//bubble_sort(&sort_data2);	

	hthread_create(&sw1, NULL,bubble_sort,&sort_data1);
	hthread_create(&sw2, NULL,bubble_sort,&sort_data2);


	struct matrix  vector_data1 ; init_matirx_data(&vector_data1);
	print("\r\n***********vector_add(0,&data1)**************\r\n");  
	vector_add(0,&vector_data1);

	struct matrix  vector_data2 ; init_matirx_data(&vector_data2);
	print("\r\n***********vector_add(0,&data)**************\r\n");  
	vector_add(1,&vector_data2);

	print("\r\n***********cond_var(0)**************\r\n");  
	cond_var(0);
	print("\r\n***********cond_var(1)**************\r\n");  
	cond_var(1);

#endif

#if 0
	//struct sortData  sort_data1 ; init_bubblesort_data(&sort_data1);
	//struct matrix  vector_data2 ; init_matirx_data(&vector_data2);
	struct matrix  vector_data1 ; init_matirx_data(&vector_data1);
	hthread_t sw1,sw2;
	j=hthread_create(&sw1, NULL,cond_var,NULL); printf( "sw1 created, returned %x\n", j );
	//j=hthread_create(&sw2, NULL,vector_add,&vector_data1);printf( "sw2 created, returned %x\n", j );
	j=hthread_join(sw1,&Status); printf( " sw1 joined, returned %i\n; ",Status );
	//j=hthread_join(sw2,&Status); printf( " sw2 joined, returned %i\n; ",Status );
	free( vector_data1.X );		free( vector_data1.Y );		free( vector_data1.Z );  

#endif

#if 0
	struct matrix  vector_data ; 
	struct sortData  sort_data ; 	
	hthread_t sw[6];
int c;
for ( c=0 ; c <2 ; c++)
{ 	
	for (i=0; i <6 ; i++)	
	{
		if (i<6){
		init_matirx_data(&vector_data);
	        vector_add(i,&vector_data);
	        free( vector_data.X );		free( vector_data.Y );		free( vector_data.Z );} 
	}
	
	for (i=0; i <6 ; i++)	
	{
		if (i<6){
		init_bubblesort_data(&sort_data);
	        bubble_sort(i,&sort_data);}
	       
	}
}	 
 #endif
 
#if 1 
	struct matrix  vector_data ; 
	struct sortData  sort_data ; 	

	int c;
	hthread_attr_t      hwAttr;
	hthread_t           hwThread;
	hthread_attr_init   (&hwAttr ); 
	void                *status;
	
for ( c=0 ; c <2 ; c++)
{ 	
	for (i=0; i <1 ; i++)	
	{	
	        //vectoradd	
		init_matirx_data(&vector_data);	      	
		j=microblaze_create_pr(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&vector_data),i,"add");		
		j= hthread_join(hwThread, &status);  
		printf( "Joined On hw_thread. Execution time: %iu \r\n\n", (uint)status/100);               
               //Check to see if data is sorted correclty + freeing the resources.
	       for( j = 0; j < MATRIXSIZE; j++ ) {if ( vector_data.Z[j] != 2 * j )printf( "Error at %i, matrix is %i \n", j, vector_data.Z[j] ); break;	}	
	       free( vector_data.X );		free( vector_data.Y );		free( vector_data.Z ); 
	       
	       
	       //buble sort
	       init_bubblesort_data(&sort_data);
	       j=microblaze_create_pr(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&sort_data),i,"sort");	      
	       j= hthread_join(hwThread, &status);                     
               printf( "Joined On hw_thread. Execution time: %iu \r\n\n", (uint)status/100);
               
               //Check to see if data is sorted correclty + freeing the resources.
       		 for( j=0; j<(ARRAY_SIZE-1); j++ )   if  ((* (sort_data.startAddr+j)) > (* (sort_data.startAddr+j+1)))    {printf( " Error\n" );break;}
	        free( sort_data.startAddr) ;        
	       
	}
	
} 
#endif

#if 0
        struct matrix  vector_data ; 
	init_matirx_data(&vector_data);	    
         printf( "%x\r\n",NUM_AVAILABLE_HETERO_CPUS);
	
	hthread_attr_t      hwAttr[NUM_AVAILABLE_HETERO_CPUS+2];
	hthread_t           hwThread[NUM_AVAILABLE_HETERO_CPUS+2];
	void                *status;	
	
	for (i=0; i <NUM_AVAILABLE_HETERO_CPUS+2 ; i++)	
	{	
	        hthread_attr_init   (&hwAttr[i] ); 		
		j=dynamic_create_smart_pr(&hwThread[i], &hwAttr[i], worker_thread_FUNC_ID, (void*)(&vector_data),"add");
	}
		
	for (i=0; i <NUM_AVAILABLE_HETERO_CPUS+2 ; i++)
	{			
		j= hthread_join(hwThread[i], &status);  
		printf( "Joined On hw_thread %i. Execution time: %iu \r\n\n", i, (uint)status/100);  
	}	             
               //Check to see if data is sorted correclty + freeing the resources.
	       for( j = 0; j < MATRIXSIZE; j++ ) {if ( vector_data.Z[j] != 2 * j )printf( "Error at %i, matrix is %i \n", j, vector_data.Z[j] ); break;	}	
	       free( vector_data.X );		free( vector_data.Y );		free( vector_data.Z ); 
	
#endif
  	
   print("\r\n-- Exiting main() --\r\n");
   return 0;
}


#endif
