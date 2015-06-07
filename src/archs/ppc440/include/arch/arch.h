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

/**	\internal
  *	\file	    arch.h
  * \brief      Declaration of architecture dependent functionality.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  */
#ifndef _HYBRID_THREADS_PPC405_ARCH_
#define _HYBRID_THREADS_PPC405_ARCH_

#include <hthread.h>
#include <sys/internal.h>
#include <arch/asm.h>
#include <arch/context.h>

// By default do no enable architecture debugging
#ifndef ARCH_DEBUG
#define ARCH_DEBUG  0
#endif

extern Huint _arch_setup_thread(Huint, hthread_thread_t*, hthread_start_t, void *);
extern Huint _arch_destroy_thread(Huint,hthread_thread_t*, Huint);
extern void  _arch_enter_user(void);
extern void  _arch_enable_intr(void);
extern void  _init_arch_specific(void);
extern void  _disable_prempt(void);
extern void  _enable_prempt(void);

extern ppc405_context_t    ppc405_context_table[ MAX_THREADS ];

#ifdef HTHREADS_SMP
#define _get_procid()   mfsprg7()
#else
#define _get_procid()   0
#endif

#endif