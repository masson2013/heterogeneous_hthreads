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

#define MATRIXSIZE 1000
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



#define SIZE 1
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
#include "mbhwti_prog.h"
#include <arch/htime.h>
#include <log/log.h>

void * worker_cond_var( void * inputData ) {

	struct data *  workerdata;
	workerdata = (struct data *) inputData;
	
	int i;
	for (  i=0 ; i< SIZE+1 ;i++)	{

		/*cond wait*/                                           //printf( "starting Wait condition...\n" ); 
		hthread_mutex_lock( workerdata->myMutex2 );            //printf( "locked the mutex for waiting...\n" ); 
		workerdata->var2 = 1;
		hthread_cond_wait(workerdata->myCond2,workerdata->myMutex2 );  
		workerdata->var2 = 2;
		hthread_mutex_unlock( workerdata->myMutex2 );           // printf( "Unlocked the mutex after waiting...\n" );

		//cond signal           
		while (workerdata->var1 != 1) ;   
		hthread_mutex_lock( workerdata->myMutex1 );	             //printf( "locked the mutex for signaling...\n" ); 
		hthread_cond_signal(workerdata->myCond1); 
		workerdata->var1 =3;
		hthread_mutex_unlock( workerdata->myMutex1 );            //printf( "Unlocked the mutex after signaling...\n" );
	}
	return 5;	
}

void readHWTStatus( void* baseAddr) {
    printf( "  Timer is :: %i \n", read_reg(baseAddr+0x00000004) );
    printf( "  HWT Thread ID %x \n", read_reg(baseAddr) );
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
    printf( "  HWT Heap Pointer %x \n", read_reg(baseAddr + 0x00000040) );
}

int vectoradd (int opb_hwti )
{
	hthread_attr_t      hwAttr;
	hthread_t           hwThread;
	hthread_mutex_t     mutex;
	struct matrix       matrixData;
	Huint           i, j;  
	hthread_time_t start,stop;
	start= hthread_time_get();
	void *status;

	hthread_mutex_init( &mutex, NULL );    
	matrixData.matrixMutex = &mutex;	
	hthread_attr_init(&hwAttr);
	// Initialize matrixData
	matrixData.size = MATRIXSIZE;
	matrixData.index = 0;
	matrixData.X = (Huint *) malloc( sizeof( Huint ) * MATRIXSIZE );
	matrixData.Y = (Huint *) malloc( sizeof( Huint ) * MATRIXSIZE );
	matrixData.Z = (Huint *) malloc( sizeof( Huint ) * MATRIXSIZE );	
	if ( matrixData.X == 0 		|| matrixData.Y == 0|| matrixData.Z == 0 ) {	printf( "malloc error\n" );return 1;	}
	for( i = 0; i < MATRIXSIZE; i++ ) {		matrixData.X[i] = i;		matrixData.Y[i] = i;		matrixData.Z[i] = 0;	}
	
 #ifdef SLAVE_DEBUG
	printf("Opcode    Function     Address     Value       Value_MB   Address_MB\r\n");
	matrixData.format1="\n\r"; matrixData.format2="   "; 
#endif 	
	if (opb_hwti==1){
		hthread_attr_sethardware( &hwAttr, 0x63000000 );
	        j = hthread_create( &hwThread, &hwAttr, NULL, (void*)(&matrixData) );}	
	else
	    #ifdef SPLIT_BRAM
	       j= microblaze_create_DMA(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&matrixData),0,0,0); 
	    #else
	       j= microblaze_create(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&matrixData),0); 
	    #endif
	    	
	        
	printf( "HW thread created, returned %x\n", j ); 
	//   int *c;        c= 0x11000000;printf ("%x\n",*c);	while (1);       
	j= hthread_join(hwThread, &status);
	printf( "hthread_join , returned %i\n",status);	
	if (opb_hwti==1)	readHWTStatus(0x63000000);


	for( i = 0; i < MATRIXSIZE; i++ ) {if ( matrixData.Z[i] != 2 * i ) {printf( "Error at %i, matrix is %i \n", i, matrixData.Z[i] ); return 1;}	}	
        hthread_attr_destroy( &hwAttr );       
	free( matrixData.X );
	free( matrixData.Y );
	free( matrixData.Z );
	return 0;
}

int quicksort(int opb_hwti)
{
	hthread_attr_t      hwAttr;
	hthread_t           hwThread;
	struct sortData input;
	Huint           i, j;		
	hthread_attr_init( &hwAttr );
	void *status;

	input.startAddr = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint));   
	input.endAddr = input.startAddr + ARRAY_SIZE - 1;
	Huint * ptr;
	for( ptr = input.startAddr; ptr <= input.endAddr; ptr++ ) *ptr = rand() % 1000;	
	input.cacheOption = 0;	
	//for( i=0; i<ARRAY_SIZE; i++ )	printf( " %i \n",* (input.startAddr+i) );

#ifdef SLAVE_DEBUG
	printf("Opcode    Function     Address     Value       Value_MB   Address_MB\r\n");
	input.format1="\n\r"; input.format2="   "; 
#endif      
	if (opb_hwti==1){
		hthread_attr_sethardware( &hwAttr, 0x63010000 );
	        j = hthread_create( &hwThread, &hwAttr, NULL, (void*)(&input) );}	
	else	
	    #ifdef SPLIT_BRAM
	       j= microblaze_create_DMA(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&input),0,0,1); 
	    #else
	       j= microblaze_create(&hwThread, &hwAttr, worker_thread_FUNC_ID, (void*)(&input),1); 
	    #endif 
	printf( "HW thread created, returned %i\n", j );        
	j= hthread_join(hwThread, &status);
	printf( "hthread_join , returned %i\n",status);	
	if (opb_hwti==1)	readHWTStatus(0x63010000);
	
	//for( i=0; i<ARRAY_SIZE; i++ ) printf( " %i \n",* (input.startAddr+i) );
        for( i=0; i<(ARRAY_SIZE-1); i++ )  if  ((* (input.startAddr+i)) > (* (input.startAddr+i+1)))  	       { printf( " Error\n" );return 1;}
	free( input.startAddr) ;        
	return 0;

}

int condvar(int opb_hwti)
{
	hthread_t       tid1, tid2;
	hthread_attr_t  attr1, attr2;
	hthread_mutex_t mutex1,mutex2;
	hthread_cond_t  cond1,cond2;
	struct data	myData;
	Huint           i, j;
	void *status;

	// Initialize the hybridthreads system
	hthread_mutex_init( &mutex1, NULL );
	hthread_cond_init( &cond1, NULL );
	hthread_mutex_init( &mutex2, NULL );
	hthread_cond_init( &cond2, NULL );
	cond2.num =1 ; mutex2.num = 1; 
	myData.myMutex1 = &mutex1;
	myData.myCond1 = &cond1;
	myData.myMutex2 = &mutex2;
	myData.myCond2 = &cond2;
	myData.size = SIZE;
	myData.var1 = 0;
	myData.var2 = 0;	
	 hthread_attr_init( &attr1 );
	 hthread_attr_init( &attr2 ); 
	 
 #ifdef SLAVE_DEBUG
	printf("Opcode    Function     Address     Value       Value_MB   Address_MB\r\n");
	myData.format1="\n\r"; myData.format2="   "; 
#endif   
        j = hthread_create( &tid2, &attr2, worker_cond_var, (void*)(&myData) );	             //printf( "sw thread  created, returned %x\n", j );
	if (opb_hwti==1){
		hthread_attr_sethardware( &attr1, 0x63020000 );
	        j = hthread_create( &tid1, &attr1, NULL, (void*)(&myData) );}	
	else	
	    #ifdef SPLIT_BRAM
	       j= microblaze_create_DMA(&tid1, &attr1, worker_thread_FUNC_ID, (void*)(&myData),0,0,2); 
	    #else
	       j= microblaze_create(&tid1, &attr1, worker_thread_FUNC_ID, (void*)(&myData),2); 
	    #endif 
	//printf( "hw thread created, returned %x\n", j );   		
	
	j = hthread_join( tid1, &status);	                                             printf( "hw thread joined,  returned %i\n",status );
	j = hthread_join( tid2, &status );	                                             printf( "sw thread joined, returned %x\n", status );
	if (opb_hwti==1)	readHWTStatus(0x63020000);  	
		
	hthread_attr_destroy( &attr1 );  
	hthread_attr_destroy( &attr2 ); 
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
   
   

   printf("\n********************************************\n VectorAdd  on Microblaze 0\n");
   vectoradd(0);  
   printf("\n********************************************\n quicksort  on Microblaze 1\n");    
   quicksort(0); 
   printf("\n********************************************\n cond_var  on Microblaze 2\n");  
   condvar(0);
   
   //In numa3_hwti platform there are no opb_hwtis
   #ifndef SPLIT_BRAM
   printf("\n********************************************\n VectorAdd  on opb_hwti 0x63000000\n");
   vectoradd(1);  
   printf("\n********************************************\n quicksort  on opb_hwti 0x63010000\n");    
   quicksort(1);   
   printf("\n********************************************\n cond_var  on opb_hwti 0x63020000\n");
   condvar(1);   
    #endif
 

   
    printf("FINISH\n");
    return 0;
}

#endif
