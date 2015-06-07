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

/** \file       hendian.h
  * \brief      Header file for the endianness conversion macros.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#ifndef _HYBRID_THREADS_ENDIAN_H_
#define _HYBRID_THREADS_ENDIAN_H_

#define ___from_littles(n)                  \
({                                          \
    Hushort _n = (Hushort)(n);              \
    Hushort _r;                             \
                                            \
    _r  = (_n) >> 8;                        \
    _r |= (_n) << 8;                        \
    _r;                                     \
})

#define ___from_littlel(n)                  \
({                                          \
    Huint _n = (n);                         \
    Huint _r;                               \
                                            \
    _r  = (_n) >> 24;                       \
    _r |= ((_n) >>  8) & 0x0000FF00;        \
    _r |= ((_n) <<  8) & 0x00FF0000;        \
    _r |= ((_n) << 24) & 0xFF000000;        \
                                            \
    _r;                                     \
})
    
#define ___to_littles(n)    ___from_littles(n)
#define ___to_littlel(n)    ___from_littlel(n)

#define little_to_bigs(n)   ___to_littles(n)
#define little_to_bigl(n)   ___to_littlel(n)
#define big_to_littles(n)   ___from_littles(n)
#define big_to_littlel(n)   ___from_littlel(n)

#endif
