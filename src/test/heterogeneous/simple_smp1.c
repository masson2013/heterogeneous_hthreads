
/*********** PLATFORM : SMP1 **********************************/

#include <stdio.h>
#include <hthread.h>
#include "time_lib.h"
#include "fsl.h"
#include <stdlib.h>
#include <string.h>
#include <util/rops.h>
#include <sys/core.h>
#include <dma/dma.h>
#include <arch/htime.h>

        #define ARRAY_SIZE 4096
	#define ACC_GLOBAL_BRAM_A 	0xE0000000
	#define ACC_GLOBAL_BRAM_B 	0xE0010000
	#define ACC_GLOBAL_BRAM_C	0xE0020000

typedef struct {
	Huint * startAddr1;
	Huint * startAddr2;
	Huint * startAddr3;	
}Data3;

int transfer_dma ( void * src, void * des , int size)
{
	dma_config_t    dma_config;
	dma_t           dma;              
	dma_config.base=0x84050000;

	dma_create(&dma,&dma_config);
        dma_transfer(&dma, src, des, size, DMA_SIZE_WORD, DMA_SOURCE_INC, DMA_DESTINATION_INC);
        while(!dma_getdone(&dma));
        if (dma_geterror(&dma)) {
            printf("DMA ERROR\n");
            return 1; }
return 0;
} 

int foo_thread(void * arg)
{
	Data3 *myarg = (Data3 *) arg;

	transfer_dma(myarg->startAddr1, (void *)(ACC_GLOBAL_BRAM_A),ARRAY_SIZE*sizeof(Huint));
	transfer_dma(myarg->startAddr2, (void *)(ACC_GLOBAL_BRAM_B),ARRAY_SIZE*sizeof(Huint));


    Huint i = 0;
#if 0
    Huint * a = (Huint *) ACC_GLOBAL_BRAM_A;
    Huint * b = (Huint *) ACC_GLOBAL_BRAM_B;
    Huint * c = (Huint *) ACC_GLOBAL_BRAM_C; 

    for (i = 0; i < ARRAY_SIZE; i++) {
        c[i] = a[i] + b[i];
    }

#else

       	putfslx(0, 1,FSL_DEFAULT);//reset the core

        putfslx(48, 0, FSL_DEFAULT);
	putfslx((Huint)ARRAY_SIZE, 0, FSL_DEFAULT);
	putfslx(0, 0, FSL_DEFAULT);	


	getfslx(i, 0, FSL_DEFAULT);



#endif

     transfer_dma((void *)(ACC_GLOBAL_BRAM_C), myarg->startAddr3, ARRAY_SIZE*sizeof(Huint));	 




   return 0;


}


// Conditional includes
#ifndef HETERO_COMPILATION
#include "smp1_prog.h"
#endif





#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else



int main(int argc, char *argv[])
{ 
        print("-- Starting main() --\r\n");




        hthread_t mythread;
        hthread_attr_t  myattr;

        hthread_attr_init(&myattr);

        Data3 input3;
	input3.startAddr1 = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint)); 
	input3.startAddr2 = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint)); 
	input3.startAddr3 = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint)); 
        int j;

         for( j = 0; j < ARRAY_SIZE; j++ ){*(input3.startAddr1 +j) = rand()%1000;	/*printf( " %i \n",*(input3.startAddr1 +j) );*/}
               printf( "**************************************************************\r\n"); 
         for( j = 0; j < ARRAY_SIZE; j++ ){*(input3.startAddr2 +j) = rand()%1000;	/*printf( " %i \n",*(input3.startAddr2+j) );*/}

               printf( "**************************************************************\r\n"); 



       hthread_time_t start, stop,diff;
       start=hthread_time_get();
       thread_create(&mythread,&myattr,foo_thread_FUNC_ID, (void *) &input3, STATIC_HW0,0);
       hthread_join(mythread,NULL);
       stop=hthread_time_get();

        hthread_time_diff(diff, stop, start);
	printf("Total Execution Time: %.2f us\n", hthread_time_usec(diff));


	        for ( j=0 ; j<ARRAY_SIZE ; j++)	 if (   (*(input3.startAddr3+j)) !=  (*(input3.startAddr1+j)) + (*(input3.startAddr2+j))   )  printf( "Error at  %i ,  %i \n",j,(*(input3.startAddr3+j)) ); 


        // for( j = 0; j < ARRAY_SIZE; j++ ){printf( " %i \n",*(input3.startAddr3+j ));}



	
        print("\r\n-- Exiting main() --\r\n");

   return 0;
}


#endif

