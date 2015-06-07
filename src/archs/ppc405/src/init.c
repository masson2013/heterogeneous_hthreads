/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
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

/** \internal
  * \file       init.c
  * \brief      The implementation of the Hybrid Threads initialization
  *             functionality.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the implementations for the Hybrid Thread initialization
  * functionality.
  */
#include <hthread.h>
#include <sys/core.h>
#include <sys/syscall.h>
#include <sys/exception.h>
#include <arch/cache.h>
#include <arch/arch.h>
#include <arch/asm.h>
#include <arch/smp.h>

// The location of the vector table
extern void _hvectors();

void _init_exceptions( void )
{
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Enabling PPC405 Software Exceptions...\n" );

    // Set the Exception Vector Prefix Register
    mtevpr( _hvectors );
}

void _init_interrupts( void )
{
#if 0
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Initializing Interrupts...\n" );

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Enabling PPC405 Interrupt Acknowledgment...\n" );
    XIntc_mEnableIntr(  NONCRIT_PIC_BASEADDR,
                        DECISION_INTR_MASK  |
                        TIMER1_INTR_MASK    |
                        TIMER2_INTR_MASK    |
                        PREEMPT_INTR_MASK );

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "\tCritical Interrupts...\n" );
    XIntc_mEnableIntr(  CRIT_PIC_BASEADDR,
                        ACCESS_INTR_MASK );

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "\tMaster Interrupts...\n" );
    XIntc_mMasterEnable( NONCRIT_PIC_BASEADDR );
    XIntc_mMasterEnable( CRIT_PIC_BASEADDR );

    intr_ack( NONCRIT_PIC_BASEADDR, 0xFFFFFFFF );
    intr_ack( CRIT_PIC_BASEADDR, 0xFFFFFFFF );
#endif
#ifdef HTHREADS_SMP
    Huint cpu_to_pic[2] = NONCRIT_PIC_BASEADDRS;

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Enabling PPC405 Critical Exceptions...\n" );
    ormsr( MSR_CE );

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Enabling PPC405 External Exceptions...\n" );
    ormsr( MSR_EE );

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Enabling PPC405 Machine Exceptions...\n" );
    ormsr( MSR_ME );

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Enabling PIC Interrupts...\n" );

    // Enable the correct scheduler interrupt based on processor id
    if(_get_procid() == 0)
        intr_enable( cpu_to_pic[_get_procid()], 0xFFFFFFFB );
    else
        intr_enable( cpu_to_pic[_get_procid()], 0xFFFFFFFD );

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Clearing PIC Interrupts...\n" );
    intr_ack( cpu_to_pic[_get_procid()], 0xFFFFFFFF );

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Enabling PIC Master Enable...\n" );
    intr_menable( cpu_to_pic[_get_procid()] );
#endif
}

void _init_arch_specific(void)
{
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Setting up PPC405...\n" );

    // Setup the system cache
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Setting up PPC405 Cache...\n" );

#ifdef HTHREADS_SMP
    // Enable the cache for the first 128MB of main memory
    // This allows shared system data to be stored in a non-cachable
    // region of memory
    ppc405_dcache_enable( 0xC000000F ); 
    ppc405_icache_enable( 0xC0000000 );
#else
    //ppc405_dcache_enable( 0xC000000F );
    ppc405_dcache_disable();    // FIXME : Jason - disable the data cache while testing on V5
    ppc405_icache_enable( 0xC0000000 );
#endif
    // Setup exceptions and interrupts
    _init_exceptions();
}

void _arch_enable_intr( void )
{
    _init_interrupts();
}

void _arch_enter_user( void )
{
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Enabling PPC405 User Mode...\n" );
    //ormsr( MSR_PR );
}

void _arch_cpuid_init( void )
{
    _init_cpuid();
}