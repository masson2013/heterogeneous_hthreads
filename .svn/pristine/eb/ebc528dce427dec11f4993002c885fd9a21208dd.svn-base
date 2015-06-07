

#include <stdio.h>
#include <hthread.h>
#include <stdlib.h>
#include <string.h>



struct data {

	hthread_mutex_t * matrixMutex;
};


void * delay() {
    
    volatile int e, x = 0,y = 0;
    for (e = 0; e < 1000000; e++) 
    {
        x+=y;
        x+=2;
    }
    return (void *) 1;
}
//===================================================================
// Slave thread
//===================================================================
void * worker_thread(void* arg)
{  


   struct data * inputMatrix;  
   inputMatrix = (struct data *) arg;

 int status = 0;
   while(1);
  //  status = hthread_mutex_trylock( inputMatrix->matrixMutex );
  
     //int cmd = mutex_cmd( 2, 2, 0 );
   //putnum(cmd);
   

      
 
   //status= hthread_mutex_unlock( inputMatrix->matrixMutex );
      


   return status;   
   
}
 


// Conditional includes
#ifndef HETERO_COMPILATION
#include "simple_mutex_prog.h"
#endif


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else


int main(int argc, char *argv[]) 
{	

	xil_printf("Start\r\n");
	
	int retval=100;
	hthread_t tid;
	hthread_attr_t attr;
	hthread_attr_init(&attr);

	struct data mydata;	
	hthread_mutex_t mutex;
	hthread_mutex_init( &mutex, NULL );   
	mydata.matrixMutex = &mutex;
	
	hthread_mutex_lock( &mutex ); 
	
	thread_create( &tid, &attr, worker_thread_FUNC_ID,(void *)(&mydata), 2, 0 );
	
	hthread_mutex_unlock( &mutex );
	
	
	while(1) {
	   hthread_mutex_lock( &mutex );
      hthread_mutex_unlock( &mutex );
   }
	
	
	hthread_join(tid, &retval);
	xil_printf("return = %d\r\n",retval);
	
	xil_printf("Finish\r\n");
	
	
	
}

#endif

