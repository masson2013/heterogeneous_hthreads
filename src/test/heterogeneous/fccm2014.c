// Compilation Key: 00111111101111800 6 64 8192 9601 system01

/*********** PLATFORM : PR_6SMP **********************************/
//00011111101111800_5_64_8192_1600
/************************************************************************************
* Copyright (c) 2014, University of Arkansas - Hybridthreads Group
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
*     * Neither the name of the University of Kansas nor the name of the
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




/* File:  fccm2014.c
 * Authors: Eugene Cartwright / Alborz S. 
 
 
 * Description: The program calls  15 Polymorphic threads and 120 threads. The threads may call up to three polymorphic functions:Crc,vectoradd and sort
                 At the end of the program, it prints the runtime details of Partial reconfigurartion as well as other useful info.
 
 
 *plaftorm : This program runs on any HEMPS system with 6 slaves. Pr_6smp is the one that is fully tested .
*/
 
 
 
 

#include <hthread.h>
#include <stdio.h>
#include <accelerator.h>
#include <arch/htime.h>



#define NO_PACKAGES 135 //120 threads and then 15 host calls



//**************************************************************************
//Macros for printing the details of the program
//**************************************************************************
//#define DEBUG_DISPATCH
#define TIMING
//#define MORE_INFO_TIMING



//**************************************************************************
//Select runtime optimization available
//**************************************************************************
#define SELF_AWARE_SCHEDULING_ENABLED  
#define PROFILING_ENABLED              

//**************************************************************************
//Select the system type
//**************************************************************************
#define DYNAMIC_ACC
//#define STATIC_ACC
//#define BASE_CASE
//#define MIXED_SYSTEM


 #define PERORMANCE_IMPROVED 10 //this goes along with finding the opt.num.of threads. If u just care about speed,put 0; else put 10% => do not create more threads unless it is at least 10 percent faster
#define NO_THREADS 6 //Put a number between 1 and 6. This for the case when Training is Off.

//#define MANUAL_TABLE  //USE THIS in espesial cases. it has the hardcoded version of two tuning table for base case, and for system with accelerators.



//These Functions are being used just by Host_crc, host_sort and host_vector. User should not use them.
//=======================================================
void * crc_thread( void * arg);
void * sort_thread( void * arg);
void * vector_add_thread( void * arg);
Hint sort_sw_thread(void * arg);
Hint crc_sw_thread(void * arg);
Hint vector_add_sw_thread(void * arg);
//=====================================================

// Primitives Threads used by user
void * worker_crc_thread( void * arg);
void * worker_sort_thread( void * arg);
void * worker_vector_thread( void * arg);

void * worker_sort_crc_thread( void * arg);
void * worker_sort_vector_thread( void * arg);
void * worker_crc_sort_thread( void * arg);
void * worker_crc_vector_thread( void * arg);
void * worker_vector_sort_thread( void * arg);
void * worker_vector_crc_thread( void * arg);
void * worker_vector_crc_sort_thread( void * arg);
void * worker_vector_sort_crc_thread( void * arg);
void * worker_crc_vector_sort_thread( void * arg);
void * worker_crc_sort_vector_thread( void * arg);
void * worker_sort_crc_vector_thread( void * arg);
void * worker_sort_vector_crc_thread( void * arg);

#ifndef HETERO_COMPILATION
#include "fccm2014_prog.h"
#include <arch/htime.h>
#endif

#include "host_call.h"
#include "fpl2013.h"

#ifdef HETERO_COMPILATION
int main() { return 0; }
#else


int main(){

    printf("*********************************************************\n");
    printf("*       HEMPS C code   for PR/6smp systems               \n");
    printf("*                                                       *\n");
    printf("*      Author: Eugene Cartwright/Alborz S.              *\n");
    printf("*********************************************************\n");

   /* Initialize accelerator entries in slave table and last_used_acc field in VHWTIs, we  use this to tell the Microblazes what type of accelerator 
    they have when they boot up. */
    _hwti_set_last_accelerator(base_array[0],CRC); slave_table[0].last_used_acc=CRC;
    _hwti_set_last_accelerator(base_array[1],CRC);  slave_table[1].last_used_acc=CRC;

    _hwti_set_last_accelerator(base_array[2],SORT);  slave_table[2].last_used_acc=SORT;
    _hwti_set_last_accelerator(base_array[3],SORT);  slave_table[3].last_used_acc=SORT;

    _hwti_set_last_accelerator(base_array[4],VECTOR);  slave_table[4].last_used_acc=VECTOR;
    _hwti_set_last_accelerator(base_array[5],VECTOR);  slave_table[5].last_used_acc=VECTOR;
    

//=====================================================
  /*This timer goes off every timerPeriod microseconds in order to have a round robin scheduling between software threads runnin on the host.*/
 //=====================================================   
	#define TimerInitMask 0x00000062   //initilizing the timer and loading the pre load reg. but not starting.
	#define TimerStartMask  0x000000D2
	#define timePeriod      200 //in microseconds

	#define base_timer0  XPAR_XPS_TIMER_0_BASEADDR
	volatile int *TCSR0 = (int*) (base_timer0+0x0);
	volatile int *TLR0 = (int*) (base_timer0+0x4);

	*TLR0=timePeriod*100;	 
	*TCSR0=TimerInitMask ; //starting the timer;
	*TCSR0=TimerStartMask;




//===================================================================
//Online tuning
//====================================================================
unsigned int i,b;
#ifdef PROFILING_ENABLED

  #ifdef MANUAL_TABLE
     init_tuning_table_manual();     
  #else
     init_tuning_table();
     //print_finer_info(); 
  #endif
#else
    for (i=0; i<NUM_OF_ACCELERATORS*NUM_OF_SIZES;i++){
	tuning_table[i].sw_time =1000;	
	tuning_table[i].hw_time =1;
	tuning_table[i].chunks = 1;
        tuning_table[i].optimal_thread_num =NO_THREADS;
    }
    for (i=NUM_OF_SIZES; i<2*NUM_OF_SIZES;i++)// for sort, we want to be fair, so we assign 8 to chunks.
	tuning_table[i].chunks = 8;
       
#endif
   
 
//===================================================================
//Telling the system who are u? Should be Automized later*/
//====================================================================
 #define MAIN_PR_FLAG     (0xC0000000)
#define MAIN_ACC_FLAG    (0x80000000)
#define NO_ACC_FLAG    (0x00000000)

   
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {       
#ifdef BASE_CASE
        _hwti_set_accelerator_flags(base_array[i], 0);
        slave_table[i].last_used_acc=123456; //so that we do not get a wrong best ratio for base case.
#endif
#ifndef BASE_CASE
    #ifdef STATIC_ACC
        _hwti_set_accelerator_flags(base_array[i], MAIN_ACC_FLAG);
    #endif
    #ifdef DYNAMIC_ACC
        _hwti_set_accelerator_flags(base_array[i], MAIN_PR_FLAG);
    #endif
#endif
    }

#ifdef MIXED_SYSTEM
    _hwti_set_accelerator_flags(base_array[0], MAIN_PR_FLAG);
    _hwti_set_accelerator_flags(base_array[1], NO_ACC_FLAG);
    _hwti_set_accelerator_flags(base_array[2], MAIN_ACC_FLAG);
    _hwti_set_accelerator_flags(base_array[3], MAIN_PR_FLAG);
    _hwti_set_accelerator_flags(base_array[4], MAIN_ACC_FLAG);
    _hwti_set_accelerator_flags(base_array[5], NO_ACC_FLAG);
#endif
    
    
 
 //===================================================================
//Printing the information about the system.
//====================================================================
 printf ("Here is the profling results for the accelerators\n");
int data_size;
	for(data_size = 64 ; data_size <=  4096 ; data_size*=2) {
		Huint index = get_index(data_size);
	printf("CRC   ,size : %4i ,chunks = %2i, hw_time:%5ius, sw_time:%5ius , Opt:%i \r\n",data_size, tuning_table[CRC*NUM_OF_SIZES+index].chunks , tuning_table[CRC*NUM_OF_SIZES+index].hw_time,tuning_table[CRC*NUM_OF_SIZES+index].sw_time,tuning_table[CRC*NUM_OF_SIZES+index].optimal_thread_num);
	printf("SORT  ,size : %4i ,chunks = %2i, hw_time:%5ius, sw_time:%5ius , Opt:%i \r\n",data_size, tuning_table[SORT*NUM_OF_SIZES+index].chunks , tuning_table[SORT*NUM_OF_SIZES+index].hw_time,tuning_table[SORT*NUM_OF_SIZES+index].sw_time,tuning_table[SORT*NUM_OF_SIZES+index].optimal_thread_num);
	printf("VECTOR,size : %4i ,chunks = %2i, hw_time:%5ius, sw_time:%5ius , Opt:%i \r\n",data_size, tuning_table[VECTOR*NUM_OF_SIZES+index].chunks , tuning_table[VECTOR*NUM_OF_SIZES+index].hw_time,tuning_table[VECTOR*NUM_OF_SIZES+index].sw_time,tuning_table[VECTOR*NUM_OF_SIZES+index].optimal_thread_num);
              printf("***************\n");} 
              
              
  printf("There are %i slave processors in this HEMPS system\n", NUM_AVAILABLE_HETERO_CPUS);
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
   {    
      char * s1="Mblaze";
      char * s2;
      int j= _hwti_get_accelerator_flags(base_array[i]);
      switch (j){
          case (NO_ACC_FLAG): s2=" No Accelerator"; break;
          case (MAIN_ACC_FLAG): s2=" Static Accelerator"; break;
          case (MAIN_PR_FLAG): s2=" Dynamic Accelerator"; break;
       }
      printf("Slave Processor #%i is a %s , and it has %s \n", i, s1,s2);

   }

    


//===================================================================
//Initilizing the threads and packages
//====================================================================

	// Instantiate threads and thread attribute structures
	hthread_t threads[NO_PACKAGES];
	hthread_attr_t attr[NO_PACKAGES];
	
	for(i = 0; i < NO_PACKAGES; i++) {
		hthread_attr_init(&attr[i]);
		hthread_attr_setdetachstate(&attr[i], HTHREAD_CREATE_DETACHED);
	}

	volatile Data package[NO_PACKAGES];
	srand(1); //so that each time we have the same data;
        printf("You have to wait untill all the data is being allocated and initialized ....\n");
	for (i=0; i<NO_PACKAGES; i++)
            if (i <120)
                //init_package(Data * package,        sort_size,            crc_size,              vector_size) 
                //init_package((Data *)&package[i], 60 * pow(2,(rand()%4)) ,60* pow(2,(rand()%5)),60 * pow(2,(rand()%6))); //for host
		init_package((Data *)&package[i],pow(2,(rand()%4+6)) ,pow(2,(rand()%5+6)),pow(2,(rand()%6+6))) ;  //for slaves. 6 -> 64 ; 12-> 2^12 =4096
            else
                 init_package((Data *)&package[i], 60 * pow(2,(rand()%4)) ,60* pow(2,(rand()%5)),60 * pow(2,(rand()%6))); //for host




	printf("Starting Timer!\n");
	hthread_time_t start = hthread_time_get();
	hthread_time_t start1,stop1,diff1 ;
//===================================================================
//starting the thread creation
//====================================================================



//Copy the generated code from python here, and then replace @@ with ;\n. and change the No.of package constatn at the top

	
	while(get_num_free_slaves()<3);
	package[0].thread_type ="Vector";
	thread_create(&threads[0], &attr[0], worker_vector_thread_FUNC_ID, (void *) &package[0], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[1].thread_type ="Sort,Vector";
	thread_create(&threads[1], &attr[1], worker_sort_vector_thread_FUNC_ID, (void *) &package[1], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[2].thread_type ="Sort,Crc,vector";
	thread_create(&threads[2], &attr[2], worker_sort_crc_vector_thread_FUNC_ID, (void *) &package[2], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[3].thread_type ="Crc";
	thread_create(&threads[3], &attr[3], worker_crc_thread_FUNC_ID, (void *) &package[3], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[4].thread_type ="Vector,sort, Crc";
	thread_create(&threads[4], &attr[4], worker_vector_sort_crc_thread_FUNC_ID, (void *) &package[4], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[5].thread_type ="Vector,sort, Crc";
	thread_create(&threads[5], &attr[5], worker_vector_sort_crc_thread_FUNC_ID, (void *) &package[5], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[6].thread_type ="Vector,Crc,sort";
	thread_create(&threads[6], &attr[6], worker_vector_crc_sort_thread_FUNC_ID, (void *) &package[6], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[7].thread_type ="Sort,Crc,vector";
	thread_create(&threads[7], &attr[7], worker_sort_crc_vector_thread_FUNC_ID, (void *) &package[7], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[8].thread_type ="Vector,Crc,sort";
	thread_create(&threads[8], &attr[8], worker_vector_crc_sort_thread_FUNC_ID, (void *) &package[8], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[9].thread_type ="Sort";
	thread_create(&threads[9], &attr[9], worker_sort_thread_FUNC_ID, (void *) &package[9], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[10].thread_type ="Crc";
	thread_create(&threads[10], &attr[10], worker_crc_thread_FUNC_ID, (void *) &package[10], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[11].thread_type ="Sort,Vector,Crc";
	thread_create(&threads[11], &attr[11], worker_sort_vector_crc_thread_FUNC_ID, (void *) &package[11], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[12].thread_type ="CRC, Sort";
	thread_create(&threads[12], &attr[12], worker_crc_sort_thread_FUNC_ID, (void *) &package[12], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[13].thread_type ="crc,Sort,Vector";
	thread_create(&threads[13], &attr[13], worker_crc_sort_vector_thread_FUNC_ID, (void *) &package[13], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[14].thread_type ="Vector,Crc";
	thread_create(&threads[14], &attr[14], worker_vector_crc_thread_FUNC_ID, (void *) &package[14], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[15].thread_type ="Crc,vector,sort";
	thread_create(&threads[15], &attr[15], worker_crc_vector_sort_thread_FUNC_ID, (void *) &package[15], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[16].thread_type ="Sort,Crc";
	thread_create(&threads[16], &attr[16], worker_sort_crc_thread_FUNC_ID, (void *) &package[16], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[17].thread_type ="Vector,Crc,sort";
	thread_create(&threads[17], &attr[17], worker_vector_crc_sort_thread_FUNC_ID, (void *) &package[17], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[18].thread_type ="Vector, sort";
	thread_create(&threads[18], &attr[18], worker_vector_sort_thread_FUNC_ID, (void *) &package[18], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[19].thread_type ="CRC, Sort";
	thread_create(&threads[19], &attr[19], worker_crc_sort_thread_FUNC_ID, (void *) &package[19], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[20].thread_type ="Vector";
	thread_create(&threads[20], &attr[20], worker_vector_thread_FUNC_ID, (void *) &package[20], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[21].thread_type ="Sort,Crc";
	thread_create(&threads[21], &attr[21], worker_sort_crc_thread_FUNC_ID, (void *) &package[21], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[22].thread_type ="Sort,Vector";
	thread_create(&threads[22], &attr[22], worker_sort_vector_thread_FUNC_ID, (void *) &package[22], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[23].thread_type ="Vector,Crc";
	thread_create(&threads[23], &attr[23], worker_vector_crc_thread_FUNC_ID, (void *) &package[23], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[24].thread_type ="Vector,sort, Crc";
	thread_create(&threads[24], &attr[24], worker_vector_sort_crc_thread_FUNC_ID, (void *) &package[24], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[25].thread_type ="Sort";
	thread_create(&threads[25], &attr[25], worker_sort_thread_FUNC_ID, (void *) &package[25], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[26].thread_type ="Vector,Crc,sort";
	thread_create(&threads[26], &attr[26], worker_vector_crc_sort_thread_FUNC_ID, (void *) &package[26], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[27].thread_type ="Vector,Crc";
	thread_create(&threads[27], &attr[27], worker_vector_crc_thread_FUNC_ID, (void *) &package[27], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[28].thread_type ="Vector,sort, Crc";
	thread_create(&threads[28], &attr[28], worker_vector_sort_crc_thread_FUNC_ID, (void *) &package[28], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[29].thread_type ="Vector, sort";
	thread_create(&threads[29], &attr[29], worker_vector_sort_thread_FUNC_ID, (void *) &package[29], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[30].thread_type ="Sort,Crc,vector";
	thread_create(&threads[30], &attr[30], worker_sort_crc_vector_thread_FUNC_ID, (void *) &package[30], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[31].thread_type ="Crc,vector,sort";
	thread_create(&threads[31], &attr[31], worker_crc_vector_sort_thread_FUNC_ID, (void *) &package[31], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[32].thread_type ="CRC, Sort";
	thread_create(&threads[32], &attr[32], worker_crc_sort_thread_FUNC_ID, (void *) &package[32], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[33].thread_type ="Sort,Vector,Crc";
	thread_create(&threads[33], &attr[33], worker_sort_vector_crc_thread_FUNC_ID, (void *) &package[33], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[34].thread_type ="Vector";
	thread_create(&threads[34], &attr[34], worker_vector_thread_FUNC_ID, (void *) &package[34], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[35].thread_type ="Sort,Crc,vector";
	thread_create(&threads[35], &attr[35], worker_sort_crc_vector_thread_FUNC_ID, (void *) &package[35], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[36].thread_type ="Crc";
	thread_create(&threads[36], &attr[36], worker_crc_thread_FUNC_ID, (void *) &package[36], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[37].thread_type ="CRC, Sort";
	thread_create(&threads[37], &attr[37], worker_crc_sort_thread_FUNC_ID, (void *) &package[37], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[38].thread_type ="Sort,Vector";
	thread_create(&threads[38], &attr[38], worker_sort_vector_thread_FUNC_ID, (void *) &package[38], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[39].thread_type ="crc,Sort,Vector";
	thread_create(&threads[39], &attr[39], worker_crc_sort_vector_thread_FUNC_ID, (void *) &package[39], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[40].thread_type ="Crc,vector,sort";
	thread_create(&threads[40], &attr[40], worker_crc_vector_sort_thread_FUNC_ID, (void *) &package[40], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[41].thread_type ="Sort";
	thread_create(&threads[41], &attr[41], worker_sort_thread_FUNC_ID, (void *) &package[41], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[42].thread_type ="Vector,Crc,sort";
	thread_create(&threads[42], &attr[42], worker_vector_crc_sort_thread_FUNC_ID, (void *) &package[42], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[43].thread_type ="Vector,sort, Crc";
	thread_create(&threads[43], &attr[43], worker_vector_sort_crc_thread_FUNC_ID, (void *) &package[43], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[44].thread_type ="Sort,Crc,vector";
	thread_create(&threads[44], &attr[44], worker_sort_crc_vector_thread_FUNC_ID, (void *) &package[44], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[45].thread_type ="Vector, sort";
	thread_create(&threads[45], &attr[45], worker_vector_sort_thread_FUNC_ID, (void *) &package[45], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[46].thread_type ="Vector, sort";
	thread_create(&threads[46], &attr[46], worker_vector_sort_thread_FUNC_ID, (void *) &package[46], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[47].thread_type ="Vector,Crc,sort";
	thread_create(&threads[47], &attr[47], worker_vector_crc_sort_thread_FUNC_ID, (void *) &package[47], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[48].thread_type ="CRC, Sort";
	thread_create(&threads[48], &attr[48], worker_crc_sort_thread_FUNC_ID, (void *) &package[48], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[49].thread_type ="Crc, Vector";
	thread_create(&threads[49], &attr[49], worker_crc_vector_thread_FUNC_ID, (void *) &package[49], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[50].thread_type ="Vector";
	thread_create(&threads[50], &attr[50], worker_vector_thread_FUNC_ID, (void *) &package[50], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[51].thread_type ="Sort,Crc";
	thread_create(&threads[51], &attr[51], worker_sort_crc_thread_FUNC_ID, (void *) &package[51], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[52].thread_type ="Vector,Crc,sort";
	thread_create(&threads[52], &attr[52], worker_vector_crc_sort_thread_FUNC_ID, (void *) &package[52], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[53].thread_type ="Sort,Vector";
	thread_create(&threads[53], &attr[53], worker_sort_vector_thread_FUNC_ID, (void *) &package[53], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[54].thread_type ="Sort,Vector,Crc";
	thread_create(&threads[54], &attr[54], worker_sort_vector_crc_thread_FUNC_ID, (void *) &package[54], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[55].thread_type ="Sort,Vector,Crc";
	thread_create(&threads[55], &attr[55], worker_sort_vector_crc_thread_FUNC_ID, (void *) &package[55], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[56].thread_type ="crc,Sort,Vector";
	thread_create(&threads[56], &attr[56], worker_crc_sort_vector_thread_FUNC_ID, (void *) &package[56], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[57].thread_type ="CRC, Sort";
	thread_create(&threads[57], &attr[57], worker_crc_sort_thread_FUNC_ID, (void *) &package[57], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[58].thread_type ="Sort";
	thread_create(&threads[58], &attr[58], worker_sort_thread_FUNC_ID, (void *) &package[58], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[59].thread_type ="Vector";
	thread_create(&threads[59], &attr[59], worker_vector_thread_FUNC_ID, (void *) &package[59], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[60].thread_type ="Sort,Crc";
	thread_create(&threads[60], &attr[60], worker_sort_crc_thread_FUNC_ID, (void *) &package[60], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[61].thread_type ="Vector,Crc";
	thread_create(&threads[61], &attr[61], worker_vector_crc_thread_FUNC_ID, (void *) &package[61], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[62].thread_type ="Crc, Vector";
	thread_create(&threads[62], &attr[62], worker_crc_vector_thread_FUNC_ID, (void *) &package[62], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[63].thread_type ="Sort,Crc";
	thread_create(&threads[63], &attr[63], worker_sort_crc_thread_FUNC_ID, (void *) &package[63], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[64].thread_type ="Sort";
	thread_create(&threads[64], &attr[64], worker_sort_thread_FUNC_ID, (void *) &package[64], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[65].thread_type ="Crc, Vector";
	thread_create(&threads[65], &attr[65], worker_crc_vector_thread_FUNC_ID, (void *) &package[65], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[66].thread_type ="Sort,Crc,vector";
	thread_create(&threads[66], &attr[66], worker_sort_crc_vector_thread_FUNC_ID, (void *) &package[66], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[67].thread_type ="crc,Sort,Vector";
	thread_create(&threads[67], &attr[67], worker_crc_sort_vector_thread_FUNC_ID, (void *) &package[67], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[68].thread_type ="Sort,Crc";
	thread_create(&threads[68], &attr[68], worker_sort_crc_thread_FUNC_ID, (void *) &package[68], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[69].thread_type ="Crc";
	thread_create(&threads[69], &attr[69], worker_crc_thread_FUNC_ID, (void *) &package[69], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[70].thread_type ="Sort,Vector,Crc";
	thread_create(&threads[70], &attr[70], worker_sort_vector_crc_thread_FUNC_ID, (void *) &package[70], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[71].thread_type ="Crc,vector,sort";
	thread_create(&threads[71], &attr[71], worker_crc_vector_sort_thread_FUNC_ID, (void *) &package[71], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[72].thread_type ="Sort,Vector,Crc";
	thread_create(&threads[72], &attr[72], worker_sort_vector_crc_thread_FUNC_ID, (void *) &package[72], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[73].thread_type ="crc,Sort,Vector";
	thread_create(&threads[73], &attr[73], worker_crc_sort_vector_thread_FUNC_ID, (void *) &package[73], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[74].thread_type ="Vector,sort, Crc";
	thread_create(&threads[74], &attr[74], worker_vector_sort_crc_thread_FUNC_ID, (void *) &package[74], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[75].thread_type ="Vector";
	thread_create(&threads[75], &attr[75], worker_vector_thread_FUNC_ID, (void *) &package[75], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[76].thread_type ="Sort,Vector,Crc";
	thread_create(&threads[76], &attr[76], worker_sort_vector_crc_thread_FUNC_ID, (void *) &package[76], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[77].thread_type ="Crc,vector,sort";
	thread_create(&threads[77], &attr[77], worker_crc_vector_sort_thread_FUNC_ID, (void *) &package[77], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[78].thread_type ="Crc, Vector";
	thread_create(&threads[78], &attr[78], worker_crc_vector_thread_FUNC_ID, (void *) &package[78], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[79].thread_type ="crc,Sort,Vector";
	thread_create(&threads[79], &attr[79], worker_crc_sort_vector_thread_FUNC_ID, (void *) &package[79], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[80].thread_type ="Vector, sort";
	thread_create(&threads[80], &attr[80], worker_vector_sort_thread_FUNC_ID, (void *) &package[80], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[81].thread_type ="Sort,Vector";
	thread_create(&threads[81], &attr[81], worker_sort_vector_thread_FUNC_ID, (void *) &package[81], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[82].thread_type ="Vector,Crc,sort";
	thread_create(&threads[82], &attr[82], worker_vector_crc_sort_thread_FUNC_ID, (void *) &package[82], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[83].thread_type ="Crc, Vector";
	thread_create(&threads[83], &attr[83], worker_crc_vector_thread_FUNC_ID, (void *) &package[83], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[84].thread_type ="CRC, Sort";
	thread_create(&threads[84], &attr[84], worker_crc_sort_thread_FUNC_ID, (void *) &package[84], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[85].thread_type ="Crc,vector,sort";
	thread_create(&threads[85], &attr[85], worker_crc_vector_sort_thread_FUNC_ID, (void *) &package[85], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[86].thread_type ="Vector,Crc";
	thread_create(&threads[86], &attr[86], worker_vector_crc_thread_FUNC_ID, (void *) &package[86], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[87].thread_type ="Sort";
	thread_create(&threads[87], &attr[87], worker_sort_thread_FUNC_ID, (void *) &package[87], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[88].thread_type ="crc,Sort,Vector";
	thread_create(&threads[88], &attr[88], worker_crc_sort_vector_thread_FUNC_ID, (void *) &package[88], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[89].thread_type ="Vector, sort";
	thread_create(&threads[89], &attr[89], worker_vector_sort_thread_FUNC_ID, (void *) &package[89], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[90].thread_type ="Crc, Vector";
	thread_create(&threads[90], &attr[90], worker_crc_vector_thread_FUNC_ID, (void *) &package[90], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[91].thread_type ="Sort";
	thread_create(&threads[91], &attr[91], worker_sort_thread_FUNC_ID, (void *) &package[91], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[92].thread_type ="Sort,Crc,vector";
	thread_create(&threads[92], &attr[92], worker_sort_crc_vector_thread_FUNC_ID, (void *) &package[92], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[93].thread_type ="Vector,sort, Crc";
	thread_create(&threads[93], &attr[93], worker_vector_sort_crc_thread_FUNC_ID, (void *) &package[93], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[94].thread_type ="Crc,vector,sort";
	thread_create(&threads[94], &attr[94], worker_crc_vector_sort_thread_FUNC_ID, (void *) &package[94], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[95].thread_type ="Crc, Vector";
	thread_create(&threads[95], &attr[95], worker_crc_vector_thread_FUNC_ID, (void *) &package[95], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[96].thread_type ="Sort,Crc";
	thread_create(&threads[96], &attr[96], worker_sort_crc_thread_FUNC_ID, (void *) &package[96], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[97].thread_type ="Crc";
	thread_create(&threads[97], &attr[97], worker_crc_thread_FUNC_ID, (void *) &package[97], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[98].thread_type ="Vector,Crc";
	thread_create(&threads[98], &attr[98], worker_vector_crc_thread_FUNC_ID, (void *) &package[98], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[99].thread_type ="Crc";
	thread_create(&threads[99], &attr[99], worker_crc_thread_FUNC_ID, (void *) &package[99], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[100].thread_type ="Sort,Vector";
	thread_create(&threads[100], &attr[100], worker_sort_vector_thread_FUNC_ID, (void *) &package[100], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[101].thread_type ="Vector";
	thread_create(&threads[101], &attr[101], worker_vector_thread_FUNC_ID, (void *) &package[101], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[102].thread_type ="Crc, Vector";
	thread_create(&threads[102], &attr[102], worker_crc_vector_thread_FUNC_ID, (void *) &package[102], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[103].thread_type ="Crc";
	thread_create(&threads[103], &attr[103], worker_crc_thread_FUNC_ID, (void *) &package[103], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[104].thread_type ="Sort,Vector,Crc";
	thread_create(&threads[104], &attr[104], worker_sort_vector_crc_thread_FUNC_ID, (void *) &package[104], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[105].thread_type ="Vector, sort";
	thread_create(&threads[105], &attr[105], worker_vector_sort_thread_FUNC_ID, (void *) &package[105], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[106].thread_type ="Sort,Crc,vector";
	thread_create(&threads[106], &attr[106], worker_sort_crc_vector_thread_FUNC_ID, (void *) &package[106], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[107].thread_type ="CRC, Sort";
	thread_create(&threads[107], &attr[107], worker_crc_sort_thread_FUNC_ID, (void *) &package[107], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[108].thread_type ="crc,Sort,Vector";
	thread_create(&threads[108], &attr[108], worker_crc_sort_vector_thread_FUNC_ID, (void *) &package[108], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[109].thread_type ="Vector,Crc";
	thread_create(&threads[109], &attr[109], worker_vector_crc_thread_FUNC_ID, (void *) &package[109], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[110].thread_type ="Vector";
	thread_create(&threads[110], &attr[110], worker_vector_thread_FUNC_ID, (void *) &package[110], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[111].thread_type ="Vector,Crc";
	thread_create(&threads[111], &attr[111], worker_vector_crc_thread_FUNC_ID, (void *) &package[111], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[112].thread_type ="Sort,Vector";
	thread_create(&threads[112], &attr[112], worker_sort_vector_thread_FUNC_ID, (void *) &package[112], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[113].thread_type ="Crc,vector,sort";
	thread_create(&threads[113], &attr[113], worker_crc_vector_sort_thread_FUNC_ID, (void *) &package[113], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[114].thread_type ="Sort,Crc";
	thread_create(&threads[114], &attr[114], worker_sort_crc_thread_FUNC_ID, (void *) &package[114], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[115].thread_type ="Sort";
	thread_create(&threads[115], &attr[115], worker_sort_thread_FUNC_ID, (void *) &package[115], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[116].thread_type ="Vector,sort, Crc";
	thread_create(&threads[116], &attr[116], worker_vector_sort_crc_thread_FUNC_ID, (void *) &package[116], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[117].thread_type ="Vector, sort";
	thread_create(&threads[117], &attr[117], worker_vector_sort_thread_FUNC_ID, (void *) &package[117], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[118].thread_type ="Sort,Vector";
	thread_create(&threads[118], &attr[118], worker_sort_vector_thread_FUNC_ID, (void *) &package[118], DYNAMIC_HW, 0);
	
	while(get_num_free_slaves()<3);
	package[119].thread_type ="Crc";
	thread_create(&threads[119], &attr[119], worker_crc_thread_FUNC_ID, (void *) &package[119], DYNAMIC_HW, 0);


	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[120].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[120].sort_data, package[120].sort_size, package[120].sort_valid);
while(*(package[120].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 0,package[120].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[120].exe_time=diff1;
;
      while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[121].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[121].crc_data, package[121].crc_size, package[121].crc_valid);
while(*(package[121].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 1,package[121].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[121].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[122].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[122].sort_data, package[122].sort_size, package[122].sort_valid);
while(*(package[122].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 2,package[122].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[122].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[123].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[123].crc_data, package[123].crc_size, package[123].crc_valid);
while(*(package[123].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 3,package[123].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[123].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[124].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[124].sort_data, package[124].sort_size, package[124].sort_valid);
while(*(package[124].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 4,package[124].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[124].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[125].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[125].dataA, package[125].dataB, package[125].dataC, package[125].vector_size, package[125].vector_valid);
while(*(package[125].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 5,package[125].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[125].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[126].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[126].crc_data, package[126].crc_size, package[126].crc_valid);
while(*(package[126].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 6,package[126].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[126].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[127].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[127].crc_data, package[127].crc_size, package[127].crc_valid);
while(*(package[127].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 7,package[127].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[127].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[128].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[128].dataA, package[128].dataB, package[128].dataC, package[128].vector_size, package[128].vector_valid);
while(*(package[128].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 8,package[128].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[128].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[129].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[129].sort_data, package[129].sort_size, package[129].sort_valid);
while(*(package[129].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 9,package[129].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[129].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[130].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[130].sort_data, package[130].sort_size, package[130].sort_valid);
while(*(package[130].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 10,package[130].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[130].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[131].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[131].dataA, package[131].dataB, package[131].dataC, package[131].vector_size, package[131].vector_valid);
while(*(package[131].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 11,package[131].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[131].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[132].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[132].dataA, package[132].dataB, package[132].dataC, package[132].vector_size, package[132].vector_valid);
while(*(package[132].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 12,package[132].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[132].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[133].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[133].crc_data, package[133].crc_size, package[133].crc_valid);
while(*(package[133].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 13,package[133].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[133].exe_time=diff1;
;
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[134].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[134].crc_data, package[134].crc_size, package[134].crc_valid);
while(*(package[134].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 14,package[134].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[134].exe_time=diff1;

#if 0
	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[135].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[135].dataA, package[135].dataB, package[135].dataC, package[135].vector_size, package[135].vector_valid);
while(*(package[135].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 15,package[135].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[135].exe_time=diff1;
;

	while(get_num_free_slaves()<NUM_AVAILABLE_HETERO_CPUS);
package[136].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[136].crc_data, package[136].crc_size, package[136].crc_valid);
while(*(package[136].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 16,package[136].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[136].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[137].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[137].crc_data, package[137].crc_size, package[137].crc_valid);
while(*(package[137].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 17,package[137].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[137].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[138].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[138].crc_data, package[138].crc_size, package[138].crc_valid);
while(*(package[138].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 18,package[138].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[138].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[139].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[139].sort_data, package[139].sort_size, package[139].sort_valid);
while(*(package[139].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 19,package[139].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[139].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[140].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[140].crc_data, package[140].crc_size, package[140].crc_valid);
while(*(package[140].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 20,package[140].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[140].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[141].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[141].crc_data, package[141].crc_size, package[141].crc_valid);
while(*(package[141].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 21,package[141].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[141].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[142].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[142].dataA, package[142].dataB, package[142].dataC, package[142].vector_size, package[142].vector_valid);
while(*(package[142].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 22,package[142].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[142].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[143].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[143].dataA, package[143].dataB, package[143].dataC, package[143].vector_size, package[143].vector_valid);
while(*(package[143].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 23,package[143].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[143].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[144].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[144].sort_data, package[144].sort_size, package[144].sort_valid);
while(*(package[144].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 24,package[144].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[144].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[145].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[145].crc_data, package[145].crc_size, package[145].crc_valid);
while(*(package[145].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 25,package[145].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[145].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[146].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[146].dataA, package[146].dataB, package[146].dataC, package[146].vector_size, package[146].vector_valid);
while(*(package[146].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 26,package[146].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[146].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[147].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[147].dataA, package[147].dataB, package[147].dataC, package[147].vector_size, package[147].vector_valid);
while(*(package[147].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 27,package[147].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[147].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[148].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[148].sort_data, package[148].sort_size, package[148].sort_valid);
while(*(package[148].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 28,package[148].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[148].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[149].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[149].crc_data, package[149].crc_size, package[149].crc_valid);
while(*(package[149].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 29,package[149].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[149].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[150].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[150].sort_data, package[150].sort_size, package[150].sort_valid);
while(*(package[150].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 30,package[150].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[150].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[151].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[151].dataA, package[151].dataB, package[151].dataC, package[151].vector_size, package[151].vector_valid);
while(*(package[151].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 31,package[151].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[151].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[152].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[152].sort_data, package[152].sort_size, package[152].sort_valid);
while(*(package[152].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 32,package[152].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[152].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[153].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[153].sort_data, package[153].sort_size, package[153].sort_valid);
while(*(package[153].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 33,package[153].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[153].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[154].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[154].dataA, package[154].dataB, package[154].dataC, package[154].vector_size, package[154].vector_valid);
while(*(package[154].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 34,package[154].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[154].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[155].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[155].crc_data, package[155].crc_size, package[155].crc_valid);
while(*(package[155].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 35,package[155].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[155].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[156].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[156].dataA, package[156].dataB, package[156].dataC, package[156].vector_size, package[156].vector_valid);
while(*(package[156].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 36,package[156].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[156].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[157].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[157].dataA, package[157].dataB, package[157].dataC, package[157].vector_size, package[157].vector_valid);
while(*(package[157].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 37,package[157].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[157].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[158].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[158].sort_data, package[158].sort_size, package[158].sort_valid);
while(*(package[158].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 38,package[158].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[158].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[159].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[159].dataA, package[159].dataB, package[159].dataC, package[159].vector_size, package[159].vector_valid);
while(*(package[159].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 39,package[159].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[159].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[160].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[160].dataA, package[160].dataB, package[160].dataC, package[160].vector_size, package[160].vector_valid);
while(*(package[160].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 40,package[160].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[160].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[161].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[161].crc_data, package[161].crc_size, package[161].crc_valid);
while(*(package[161].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 41,package[161].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[161].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[162].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[162].crc_data, package[162].crc_size, package[162].crc_valid);
while(*(package[162].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 42,package[162].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[162].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[163].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[163].dataA, package[163].dataB, package[163].dataC, package[163].vector_size, package[163].vector_valid);
while(*(package[163].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 43,package[163].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[163].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[164].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[164].dataA, package[164].dataB, package[164].dataC, package[164].vector_size, package[164].vector_valid);
while(*(package[164].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 44,package[164].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[164].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[165].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[165].dataA, package[165].dataB, package[165].dataC, package[165].vector_size, package[165].vector_valid);
while(*(package[165].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 45,package[165].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[165].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[166].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[166].sort_data, package[166].sort_size, package[166].sort_valid);
while(*(package[166].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 46,package[166].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[166].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[167].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[167].crc_data, package[167].crc_size, package[167].crc_valid);
while(*(package[167].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 47,package[167].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[167].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[168].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[168].sort_data, package[168].sort_size, package[168].sort_valid);
while(*(package[168].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 48,package[168].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[168].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[169].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[169].dataA, package[169].dataB, package[169].dataC, package[169].vector_size, package[169].vector_valid);
while(*(package[169].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 49,package[169].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[169].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[170].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[170].sort_data, package[170].sort_size, package[170].sort_valid);
while(*(package[170].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 50,package[170].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[170].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[171].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[171].crc_data, package[171].crc_size, package[171].crc_valid);
while(*(package[171].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 51,package[171].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[171].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[172].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[172].dataA, package[172].dataB, package[172].dataC, package[172].vector_size, package[172].vector_valid);
while(*(package[172].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 52,package[172].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[172].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[173].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[173].crc_data, package[173].crc_size, package[173].crc_valid);
while(*(package[173].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 53,package[173].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[173].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[174].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[174].sort_data, package[174].sort_size, package[174].sort_valid);
while(*(package[174].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 54,package[174].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[174].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[175].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[175].crc_data, package[175].crc_size, package[175].crc_valid);
while(*(package[175].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 55,package[175].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[175].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[176].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[176].dataA, package[176].dataB, package[176].dataC, package[176].vector_size, package[176].vector_valid);
while(*(package[176].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 56,package[176].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[176].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[177].thread_type ="vector";
start1 = hthread_time_get();
host_vector_add(package[177].dataA, package[177].dataB, package[177].dataC, package[177].vector_size, package[177].vector_valid);
while(*(package[177].vector_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], vector , with %i size is done\n", 57,package[177].vector_size);
hthread_time_diff(diff1, stop1, start1);
package[177].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[178].thread_type ="Crc";
start1 = hthread_time_get();
host_crc(package[178].crc_data, package[178].crc_size, package[178].crc_valid);
while(*(package[178].crc_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], CRC , with %i size is done\n", 58,package[178].crc_size);
hthread_time_diff(diff1, stop1, start1);
package[178].exe_time=diff1;
;
	while(get_num_free_slaves()<6);
package[179].thread_type ="sort";
start1 = hthread_time_get();
host_sort(package[179].sort_data, package[179].sort_size, package[179].sort_valid);
while(*(package[179].sort_valid) !=1);
stop1 = hthread_time_get();
//printf("package[%i], sort , with %i size is done\n", 59,package[179].sort_size);
hthread_time_diff(diff1, stop1, start1);
package[179].exe_time=diff1;
;
#endif	


	while((thread_counter + (NUM_AVAILABLE_HETERO_CPUS - get_num_free_slaves()) ) > 0);
	hthread_time_t stop = hthread_time_get();
//===================================================================
//All threads are finished exectuing, checking the results
//====================================================================
	
	printf("---------------------------\n");
	int  number_of_errors = 0;	
	for (i=0; i<NO_PACKAGES; i++)
		number_of_errors += check_package((Data *)&package[i]);
	//printf("---------------------------\n");
	printf("\nNumber of Errors = %d\n\n", number_of_errors);



//===================================================================
//printing the results
//====================================================================

 	printf ("Pack   Exe time        crc    sort     vector  thread_type \n" );
		for (i=0; i <   NO_PACKAGES ; i++) 
                          if (i<10 || (NO_PACKAGES-i) <10)
			printf (" %3i   %6.0f uS    %5d     %5d    %5d  %s \n", i, 1.0 *(package[i].exe_time)/100 ,*package[i].crc_valid*package[i].crc_size,
		*package[i].sort_valid*package[i].sort_size,*package[i].vector_valid*package[i].vector_size, package[i].thread_type);
	
	hthread_time_t diff;
	hthread_time_diff(diff, stop, start);
	printf("Total Execution Time: %.2f ms\n", hthread_time_msec(diff));
	printf("Total Execution Time: %.2f us\n", hthread_time_usec(diff));
    

        print_finer_info();

for (i=0; i<NO_PACKAGES; i++){
	free(package[i].sort_data);
	free(package[i].crc_data);
	free(package[i].crc_data_check);
	free(package[i].dataA); 
	free(package[i].dataB);
	free(package[i].dataC);
	free(package[i].sort_valid);
	free(package[i].crc_valid);
	free(package[i].vector_valid);
}




    return 0;
}
#endif


