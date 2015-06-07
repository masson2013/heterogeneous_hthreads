/************************************************************************************
* Copyright (c) 2012, University of Arkansas, Fayetteville - CSDL lab ,http://hthreads.csce.uark.edu
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

/*###############################################################################
// File:     src/test/heterogenous/cond_var.c
// Author:    Abazar Sadeqian
// Date:     14 Nov 2012
//
// 
// Desc:   This code was first written to test HW threads, interacting with OPB_hwti in order to get the timing of cond_wait and cond_signal system calls.
           I tweaked it to be a hetergeneous application, testing hthread_cores.
	   Let us say we have 10 slave CPUs. This C application loops over all slaves and perform the follwoing tasks:
		1- Create a HW thread on Salve#i , and creates a SW thread to interact with.
		2- The HW thread and SW thread keeps signaling and waiting on each other for ITERATIN times.
		3- After joining on both hw and sw thread, we create another hw thread on next microblaze with a new Sw thread to interact with.
//
// How to use:  leave the Num_sw_threads to be always one. Just change the ITERAATION  any number you want. This can be used for a good stress test.  
		Currently, it is part of the "Comprehensive testing of hthreads"
		   
//
// revisions: 1- Create as many HW thread as number of slave microblazes, and run two  different complemntary worker thread on Slave and host.
	      2- This code can be executed on both Numa and SMP systems, Virtex6 and Virtex5 Boards with changeable number of Slaves.	


//Futuer work : 1- Generate more computaions of HW/SW threads interactions, for example HW/HW thread , SW/SW thread.
		2- Change to code to test Cond_Broadcast as well.
				
//###############################################################################*/


#include <stdio.h>
#include <hthread.h>
#include <stdlib.h>
#include <string.h>
#define DEBUG_DISPATCH

#define  XPAR_XPS_TIMER_0_BASEADDR XPAR_AXI_TIMER_0_BASEADDR

#define NUM_SW_THREADS                     1 // It should be always one, for this test  
      
#define TEST_PASSED                         0

#define THREAD_SOFTWARE_CREATE_FAILED       2
#define THREAD_SOFTWARE_JOIN_FAILED         3

#define THREAD_HARDWARE_CREATE_FAILED       4
#define THREAD_HARDWARE_JOIN_FAILED         5 

#define THREAD_HARDWARE_INCORRECT_RETURN    6
#define THREAD_SOFTWARE_INCORRECT_RETURN    7

#define FINAL_JOIN_ERROR                    8

#define TEST_FAILED                         9

#define MALLC_ERROR                         10

#define RETURN(x)                          { xil_printf("%d\r\n",x); \
                                            xil_printf("END\r\n"); \
                                            return x;}


#define ITERATION 100
struct data {
	Huint size;
	hthread_mutex_t * myMutex1;
        hthread_cond_t  *myCond1;  
        hthread_mutex_t * myMutex2;
        hthread_cond_t  *myCond2;  
        Huint var1;
        Huint var2;

};


//Create a unique mutex if needing more than one
void create_mutex(hthread_mutex_t * mutex_ptr)
{
    static int mutexnum = 0;    // Static: holds value across calls

    // Allocate and setup mutex number
    hthread_mutexattr_t attr;
    hthread_mutexattr_init(&attr);
    hthread_mutexattr_setnum(&attr, mutexnum++);

    xil_printf("Creating mutex %d\r\n", mutexnum);

    // Initialize mutex
    hthread_mutex_init(mutex_ptr, &attr);
    xil_printf("Done\r\n");
}

//Create a unique signal if needing more than one
void create_signal(hthread_cond_t * signal_ptr)
{
    static int signalnum = 0;    // Static: holds value across calls

    // Allocate and setup signal number
    hthread_condattr_t attr;
    hthread_condattr_init(&attr);
    hthread_condattr_setnum(&attr, signalnum++);

    xil_printf("Initializing conditional variable %d\r\n", signalnum);

    // Initialize signal
    hthread_cond_init(signal_ptr, &attr);
    xil_printf("Done\r\n");
}

//===================================================================
// Slave thread
//===================================================================
void * worker_thread_1(void* arg)
{  
    struct data *  workerdata;
    workerdata = (struct data *) arg;
    //xil_printf( "Software thread starting...\r\n" );
    int i;
    for (  i=0 ; i< ITERATION+1 ;i++)
    {

           /*cond wait*/                                           //xil_printf( "starting Wait condition...\r\n" ); 
            hthread_mutex_lock( workerdata->myMutex2 );           // xil_printf( "locked the mutex for waiting...\r\n" ); 
            workerdata->var2 = 1;
	    hthread_cond_wait(workerdata->myCond2,workerdata->myMutex2 );  
            workerdata->var2 = 2;
	    hthread_mutex_unlock( workerdata->myMutex2 );           //xil_printf( "Unlocked the mutex after waiting...\r\n" );
          

            //cond signal           
            while (workerdata->var1 != 1) ;   
	    hthread_mutex_lock( workerdata->myMutex1 );	            // xil_printf( "locked the mutex for signaling...\r\n" ); 
	    hthread_cond_signal(workerdata->myCond1); 
            workerdata->var1 =3;
	    hthread_mutex_unlock( workerdata->myMutex1 );          //  xil_printf( "Unlocked the mutex after signaling...\r\n" );
           
     }

   return NULL; 
}

void * worker_thread_2(void* arg)
{  
    struct data *  workerdata;
    workerdata = (struct data *) arg;
    //xil_printf( "Software thread starting...\r\n" );
    int i;
    for (  i=0 ; i< ITERATION+1 ;i++)
    {
	   //cond signal           
            while (workerdata->var2 != 1) ;   
	    hthread_mutex_lock( workerdata->myMutex2 );	            // xil_printf( "locked the mutex for signaling...\r\n" ); 
	    hthread_cond_signal(workerdata->myCond2); 
            workerdata->var2 =3;
	    hthread_mutex_unlock( workerdata->myMutex2 );          //  xil_printf( "Unlocked the mutex after signaling...\r\n" );

           /*cond wait*/                                           //xil_printf( "starting Wait condition...\r\n" ); 
            hthread_mutex_lock( workerdata->myMutex1 );           // xil_printf( "locked the mutex for waiting...\r\n" ); 
            workerdata->var1 = 1;
	    hthread_cond_wait(workerdata->myCond1,workerdata->myMutex1 );  
            workerdata->var1 = 2;
	    hthread_mutex_unlock( workerdata->myMutex1 );           //xil_printf( "Unlocked the mutex after waiting...\r\n" ); 
           
     }

   return NULL; 
}

// Conditional includes
#ifndef HETERO_COMPILATION
#include "cond_var_prog.h"
#endif


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else


int main(int argc, char *argv[]) 
{	
	
    	struct data	myData;
	Huint               i, j,retVal;  

	xil_printf("Number of Slave CPU= %d , Number of Sw threads=%d , Number of iterations=%d \r\n",NUM_AVAILABLE_HETERO_CPUS, 1,ITERATION);
//=================================================================
// Allocate NUM_THREADS threads, AND Set up attributes for a hardware thread
//=================================================================
	hthread_t * tid = (hthread_t *) malloc(sizeof(hthread_t) * 2);
	hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * 1);
	
	if ( tid == 0 	|| attr == 0 ) 
	   RETURN(MALLC_ERROR) 
	
	for (i = 0; i < 1; i++)	{ 
		hthread_attr_init(&attr[i]);
		hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
	}

        xil_printf("Allocating  thread ids...... Finished\r\n");
//=================================================================
// Initializing mutex and con_variables
//=================================================================
   hthread_mutex_t mutex1,mutex2;
   hthread_cond_t  cond1,cond2;

   // Create mutex

   create_mutex(&mutex1);
   create_mutex(&mutex2);
   create_signal(&cond1);
   create_signal(&cond2);

   
   myData.myMutex1 = &mutex1;
   myData.myCond1 = &cond1;
   myData.myMutex2 = &mutex2;
   myData.myCond2 = &cond2;
   myData.size = ITERATION;
   myData.var1 = 0;
   myData.var2 = 0;

   /*xil_printf( "Struct address is %x\r\n", (Huint)&myData );
   xil_printf( "Mutex1 address is %x\r\n", (Huint)myData.myMutex1 );
   xil_printf( "Cond1 address is %x\r\n", (Huint)myData.myCond1 );
   xil_printf( "Mutex2 address is %x\r\n", (Huint)myData.myMutex2 );
   xil_printf( "Cond2 address is %x\r\n", (Huint)myData.myCond2 );*/	

   xil_printf("Initializing data .......Finished\r\n");

//=================================================================
// Creating  one HW  and  one sw thread; then join on them
//=================================================================
	for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
	{

#if 0
                #ifdef SPLIT_BRAM 
		if (microblaze_create_DMA( &tid[0], &attr[0], worker_thread_1_FUNC_ID, (void*)(&myData), 0,0,i) ) 
                #else
 		if (microblaze_create( &tid[0], &attr[0], worker_thread_1_FUNC_ID, (void*)(&myData), i) ) 
                #endif 
			RETURN(THREAD_HARDWARE_CREATE_FAILED)
#endif	
#if 1		
			if (thread_create( &tid[0], &attr[0], worker_thread_1_FUNC_ID, (void*)(&myData), 2, 0) )		
			//if (hthread_create( &tid[0], NULL, worker_thread_1, (void*)(&myData)) )			
			RETURN(THREAD_SOFTWARE_CREATE_FAILED);	
#endif			
	
		if (hthread_create( &tid[1], NULL, worker_thread_2, (void*)(&myData)) )			
			RETURN(THREAD_SOFTWARE_CREATE_FAILED);	

		if (hthread_join(tid[0], (void *) &retVal ))          
			RETURN(THREAD_HARDWARE_JOIN_FAILED)
		if (hthread_join(tid[1], (void *) &retVal ))	
	      		RETURN(THREAD_SOFTWARE_JOIN_FAILED)
 	}     
        
	xil_printf("Creating HW  and sw threads and joining on them....... Finished \r\n");
	
//=================================================================
// Test to see if the test failed or no ( The job is done?)
//=================================================================  
	//Since we joined, that means the job is done;
	xil_printf("Testing to see if the job is done........... Finished \r\n");	
//=================================================================
// Free the used resources and declare Sucess
//=================================================================  
	for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)	
		hthread_attr_destroy( &attr[i] );  
	
         RETURN(TEST_PASSED)
}

#endif

