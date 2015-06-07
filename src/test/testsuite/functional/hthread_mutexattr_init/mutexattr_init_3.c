/*   
  Upon success hthread_mutexattr_init returns 0.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

void * testThread ( void * arg ) {
	int retVal;
	hthread_mutexattr_t * attr = (hthread_mutexattr_t *) arg;
	
	//Initialize an attribute, and check the return value
	retVal = hthread_mutexattr_init( attr );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_mutexattr_t attr;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test mutexattr_init_1\n" );

	//Set up the arguments for the test
	arg = (int) &attr;
	
	//Run the tests
	hthread_create( &test_thread, NULL, testThread, (void *) arg );
	hthread_join( test_thread, (void *) &retVal );

	//Evaluate the results
	if ( retVal == EXPECTED_RESULT ) {
		printf("Test PASSED\n");
		return PTS_PASS;
	} else {
		printf("Test FAILED [expecting %d, received%d]\n", EXPECTED_RESULT, retVal );
		return PTS_FAIL;
	}	
}