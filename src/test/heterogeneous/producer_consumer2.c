/****************************************************
* FILE  : producer_consumer2.c 
* AUTHOR: Eugene Cartwright
* LAST MODIFIED :   05/25/2010
* NOTE: This version of the original
*       producer_consumer.c file contains condition
*       variables.
 ***************************************************/
#include <hthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS     (2)
#define NUM_CONSUMERS   (1)
#define NUM_PRODUCERS   (1)
#define BUFFER_SIZE     (10)
#define PRODUCE         (1)
#define CONSUME         (0)
#define DEBUG_DISPATCH


typedef struct {
    int id;
    int size;
    int * data;
    int * fillCount;
    hthread_mutex_t * lock;
    hthread_cond_t * notempty;
    hthread_cond_t * notfull;
} info;

//Configure attriute for threads
void set_thread_attr(hthread_attr_t * attr) {

    hthread_attr_init(attr);
    hthread_attr_setdetachstate(attr,HTHREAD_CREATE_JOINABLE);
}

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

//PRODUCER
void * producer_thread (void *arg) {
    info * t_info = (info * ) arg;

    while(1) {
        int error = 0;
        
        //Acquire lock to avoid any race conditions
        hthread_mutex_lock(t_info->lock);
        
        //if Full, wait. Contain in loop just in case
        //it is woken up acidentally
        while ( *(t_info->fillCount) == BUFFER_SIZE){
           
           xil_printf("Thread #%d: Producer waiting!\r\n", t_info->id);
 
           error = hthread_cond_wait(t_info->notfull,t_info->lock);
           if (error != 0 ){
               xil_printf("Error: Producer %d could not wait\r\n",t_info->id);
           }
        }
        
        //xil_printf("Thread #%d: Producer signaled!\r\n", t_info->id);
        
        //Put item in buffer and increment
        t_info->data[*(t_info->fillCount)] = PRODUCE;
        *(t_info->fillCount)+=1;
        xil_printf("Thread #%d: Producer producing\r\n", t_info->id);
        
        //Release lock for others to use
        hthread_mutex_unlock(t_info->lock);

        //Allow others to step in
        error = hthread_cond_signal(t_info->notempty);
        if (error != 0 ){
            xil_printf("Error: Producer %d could not signal not empty\r\n",t_info->id);
        }
    }

    return ((void *) 10);
}

//CONSUMER
void * consumer_thread (void *arg) {
    int error = 0;
    
    info * t_info = (info * ) arg;

    while(1) {
        //Acquire lock to avoid any race conditions
        hthread_mutex_lock(t_info->lock);
        
        //if empty, sleep/move this thread to the end of thread pool
        while ( *(t_info->fillCount) == 0){

            //Signal a wait
            xil_printf("Thread #%d; Consumer waiting\r\n", t_info->id);
            error = hthread_cond_wait(t_info->notempty,t_info->lock);
            if (error != 0 ){
                xil_printf("Error: Consumer %d could not wait\r\n",t_info->id);
            }
        }
        
        //xil_printf("Thread #%d; Consumer signaled!\r\n", t_info->id);
                
        //Eat item in buffer and decrement
        t_info->data[*(t_info->fillCount)] = CONSUME;
        *(t_info->fillCount)-=1;
        xil_printf("Thread #%d:Consumer eating\r\n",t_info->id);

        //Release lock for others to use
        hthread_mutex_unlock(t_info->lock);
            
        //Allow others to step in
        error = hthread_cond_signal(t_info->notfull);
        if (error != 0 ){
            xil_printf("Error: Consumer %d could not signal notfull\r\n",t_info->id);
        }
    }

    return ((void *) 10 );
}


#ifndef HETERO_COMPILATION
#include "producer_consumer2_prog.h"
#endif


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else
//MAIN
int main() {

    //Shared data for the children
    int i,error,my_array[BUFFER_SIZE];
    int shared_counter = 0;

    //Make sure Num of threads match num of producers/consumers
    if (NUM_THREADS != (NUM_PRODUCERS + NUM_CONSUMERS)) {
            xil_printf("Number of threads specificied does not equal");
            xil_printf("number of producers + number of consumers\r\n");
            return (1);
    }

    info t_info[NUM_THREADS];
    hthread_t threads[NUM_THREADS];
    hthread_attr_t attr;

    // Set attribute for threads
    xil_printf("Set thread attributes\r\n");
    set_thread_attr(&attr);
    xil_printf("Done\r\n");


    // Create mutex
    hthread_mutex_t my_mutex; 
    create_mutex(&my_mutex);

    xil_printf("Create conditional variables\r\n");
    // Create conditional variable
    hthread_cond_t signal, signal2;
    create_signal(&signal);
    create_signal(&signal2);
    xil_printf("Done\r\n");

    xil_printf("Creating %d consumers..", NUM_CONSUMERS);
   
    //Create consumers
    for (i = 0; i < NUM_CONSUMERS; i++) {
        
        t_info[i].id = i;
        t_info[i].size = BUFFER_SIZE;
        t_info[i].fillCount = &shared_counter;
        t_info[i].data = &my_array[shared_counter];
        t_info[i].lock = &my_mutex;
        t_info[i].notfull = &signal;
        t_info[i].notempty = &signal2;

        //Create threads: consumer(s) 
        error = thread_create(&threads[i],&attr,consumer_thread_FUNC_ID, (void *) &t_info[i], i+2,0);

        //if unsuccessful in creating a thread
        if (error != 0 ){
            xil_printf("Unsuccessful creating consumer #%d. Error code: %d\r\n", i,error);
            return (1);
        }
    }
    xil_printf("Done\r\n");
    
    //Continue numbering
    int j = i; i = 0;
    
    xil_printf("Creating %d producers..", NUM_PRODUCERS);
   
    //Create producers
    for (i = 0; i < NUM_PRODUCERS; i++) {
        
        t_info[j].id = j;
        t_info[j].size = BUFFER_SIZE;
        t_info[j].fillCount = &shared_counter;
        t_info[j].data = &my_array[shared_counter];
        t_info[j].lock = &my_mutex;
        t_info[j].notfull = &signal;
        t_info[j].notempty = &signal2;

        //Create threads: consumer(s) 
        error = thread_create(&threads[j],NULL,producer_thread_FUNC_ID, (void *) &t_info[j],0,0);

        //if unsuccessful in creating a thread
        if (error != 0 ){
            xil_printf("Unsuccessful creating producer #%d. Error code: %d\r\n", j,error);
            return (1);
        }
        j++;
    } 
    xil_printf("Done\r\n");

    //Now join the threads
    for (i = 0 ; i < NUM_THREADS; i++) {
        error = hthread_join(threads[i],NULL);
        if (error != 0 ) {
           xil_printf("Join failed: Error code %d\r\n",error );
           return (1);
        }
    }
    
    return 0;
}

#endif
