/* $Id: xdma_channel.c,v 1.3 2006/07/18 17:56:33 xduan Exp $ */
/******************************************************************************
*
*       XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*       AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
*       SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
*       OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
*       APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
*       THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*       AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*       FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*       WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*       IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*       REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*       INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*       FOR A PARTICULAR PURPOSE.
*
*       (c) Copyright 2001-2004 Xilinx Inc.
*       All rights reserved.
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xdma_channel.c
*
* <b>Description</b>
*
* This file contains the DMA channel component. This component supports
* a distributed DMA design in which each device can have it's own dedicated
* DMA channel, as opposed to a centralized DMA design. This component
* performs processing for DMA on all devices.
*
* See xdma_channel.h for more information about this component.
*
* @note
*
* None.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a xd  10/27/04  Doxygenated for inclusion in API documentation
* 1.00b ecm 10/31/05  Updated for the check sum offload changes.
* 1.00b xd  03/22/06  Fixed a multi-descriptor packet related bug that sgdma
*                     engine is restarted in case no scatter gather disabled
*                     bit is set yet
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xdma_channel.h"
#include "xbasic_types.h"
#include "xio.h"

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/


/*****************************************************************************/
/**
*
* This function initializes a DMA channel.  This function must be called
* prior to using a DMA channel.  Initialization of a channel includes setting
* up the registers base address, and resetting the channel such that it's in a
* known state.  Interrupts for the channel are disabled when the channel is
* reset.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @param
*
* BaseAddress contains the base address of the registers for the DMA channel.
*
* @return
*
* XST_SUCCESS indicating initialization was successful.
*
* @note
*
* None.
*
******************************************************************************/
XStatus XDmaChannel_Initialize(XDmaChannel *InstancePtr,
                                    Xuint32 BaseAddress)
{
    /* assert to verify input arguments, don't assert base address */

    XASSERT_NONVOID(InstancePtr != XNULL);

    /* setup the base address of the registers for the DMA channel such
     * that register accesses can be done
     */
    InstancePtr->RegBaseAddress = BaseAddress;

    /* initialize the scatter gather list such that it indicates it has not
     * been created yet and the DMA channel is ready to use (initialized)
     */
    InstancePtr->GetPtr = XNULL;
    InstancePtr->PutPtr = XNULL;
    InstancePtr->CommitPtr = XNULL;
    InstancePtr->LastPtr = XNULL;

    InstancePtr->TotalDescriptorCount = 0;
    InstancePtr->ActiveDescriptorCount = 0;

    InstancePtr->ActivePacketCount = 0;
    InstancePtr->Committed = XFALSE;

    InstancePtr->IsReady = XCOMPONENT_IS_READY;

    /* initialize the version of the component
     */
    XVersion_FromString(&InstancePtr->Version, "1.00a");

    /* reset the DMA channel such that it's in a known state and ready
     * and indicate the initialization occurred with no errors, note that
     * the is ready variable must be set before this call or reset will assert
     */
    XDmaChannel_Reset(InstancePtr);

    return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function determines if a DMA channel component has been successfully
* initialized such that it's ready to use.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @return
*
* XTRUE if the DMA channel component is ready, XFALSE otherwise.
*
* @note
*
* None.
*
******************************************************************************/
Xboolean XDmaChannel_IsReady(XDmaChannel *InstancePtr)
{
    /* assert to verify input arguments used by the base component */

    XASSERT_NONVOID(InstancePtr != XNULL);

    return InstancePtr->IsReady == XCOMPONENT_IS_READY;
}

/*****************************************************************************/
/**
*
* This function gets the software version for the specified DMA channel
* component.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @return
*
* A pointer to the software version of the specified DMA channel.
*
* @note
*
* None.
*
******************************************************************************/
XVersion *XDmaChannel_GetVersion(XDmaChannel *InstancePtr)
{
    /* assert to verify input arguments */

    XASSERT_NONVOID(InstancePtr != XNULL);
    XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* return a pointer to the version of the DMA channel */

    return &InstancePtr->Version;
}

/*****************************************************************************/
/**
*
* This function performs a self test on the specified DMA channel.  This self
* test is destructive as the DMA channel is reset and a register default is
* verified.
*
* @param
*
* InstancePtr is a pointer to the DMA channel to be operated on.
*
* @return
*
* XST_SUCCESS is returned if the self test is successful, or one of the
* following errors.
*                                       <br><br>
* - XST_DMA_RESET_REGISTER_ERROR        Indicates the control register value
*                                       after a reset was not correct
*
* @note
*
* This test does not performs a DMA transfer to test the channel because the
* DMA hardware will not currently allow a non-local memory transfer to non-local
* memory (memory copy), but only allows a non-local memory to or from the device
* memory (typically a FIFO).
*
******************************************************************************/

#define XDC_CONTROL_REG_RESET_MASK  0x98000000UL /* control reg reset value */

XStatus XDmaChannel_SelfTest(XDmaChannel *InstancePtr)
{
    Xuint32 ControlReg;

    /* assert to verify input arguments */

    XASSERT_NONVOID(InstancePtr != XNULL);
    XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* reset the DMA channel such that it's in a known state before the test
     * it resets to no interrupts enabled, the desired state for the test
     */
    XDmaChannel_Reset(InstancePtr);

    /* this should be the first test to help prevent a lock up with the polling
     * loop that occurs later in the test, check the reset value of the DMA
     * control register to make sure it's correct, return with an error if not
     */
    ControlReg = XDmaChannel_GetControl(InstancePtr);
    if (ControlReg != XDC_CONTROL_REG_RESET_MASK)
    {
        return XST_DMA_RESET_REGISTER_ERROR;
    }

    return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function resets the DMA channel. This is a destructive operation such
* that it should not be done while a channel is being used.  If the DMA channel
* is transferring data into other blocks, such as a FIFO, it may be necessary
* to reset other blocks.  This function does not modify the contents of a
* scatter gather list for a DMA channel such that the user is responsible for
* getting buffer descriptors from the list if necessary.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XDmaChannel_Reset(XDmaChannel *InstancePtr)
{
    /* assert to verify input arguments */

    XASSERT_VOID(InstancePtr != XNULL);
    XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* reset the DMA channel such that it's in a known state, the reset
     * register is self clearing such that it only has to be set
     */
    XIo_Out32(InstancePtr->RegBaseAddress + XDC_RST_REG_OFFSET, XDC_RESET_MASK);
}

/*****************************************************************************/
/**
*
* This function gets the control register contents of the DMA channel.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @return
*
* The control register contents of the DMA channel. One or more of the
* following values may be contained the register.  Each of the values are
* unique bit masks.
*                               <br><br>
* - XDC_DMACR_SOURCE_INCR_MASK  Increment the source address
*                               <br><br>
* - XDC_DMACR_DEST_INCR_MASK    Increment the destination address
*                               <br><br>
* - XDC_DMACR_SOURCE_LOCAL_MASK Local source address
*                               <br><br>
* - XDC_DMACR_DEST_LOCAL_MASK   Local destination address
*                               <br><br>
* - XDC_DMACR_SG_ENABLE_MASK    Scatter gather enable
*                               <br><br>
* - XDC_DMACR_GEN_BD_INTR_MASK  Individual buffer descriptor interrupt
*                               <br><br>
* - XDC_DMACR_LAST_BD_MASK      Last buffer descriptor in a packet
*
* @note
*
* None.
*
******************************************************************************/
Xuint32 XDmaChannel_GetControl(XDmaChannel *InstancePtr)
{
    /* assert to verify input arguments */

    XASSERT_NONVOID(InstancePtr != XNULL);
    XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* return the contents of the DMA control register */

    return XIo_In32(InstancePtr->RegBaseAddress + XDC_DMAC_REG_OFFSET);
}

/*****************************************************************************/
/**
*
* This function sets the control register of the specified DMA channel.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @param
*
* Control contains the value to be written to the control register of the DMA
* channel. One or more of the following values may be contained the register.
* Each of the values are unique bit masks such that they may be ORed together
* to enable multiple bits or inverted and ANDed to disable multiple bits.
* - XDC_DMACR_SOURCE_INCR_MASK  Increment the source address
* - XDC_DMACR_DEST_INCR_MASK    Increment the destination address
* - XDC_DMACR_SOURCE_LOCAL_MASK Local source address
* - XDC_DMACR_DEST_LOCAL_MASK   Local destination address
* - XDC_DMACR_SG_ENABLE_MASK    Scatter gather enable
* - XDC_DMACR_GEN_BD_INTR_MASK  Individual buffer descriptor interrupt
* - XDC_DMACR_LAST_BD_MASK      Last buffer descriptor in a packet
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XDmaChannel_SetControl(XDmaChannel *InstancePtr, Xuint32 Control)
{
    Xuint32 Register;
    /* assert to verify input arguments except the control which can't be
     * asserted since all values are valid
     */
    XASSERT_VOID(InstancePtr != XNULL);
    XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /*
     * set the DMA control register to the specified value, not altering the
     * other fields in the register
     */

    Register = XIo_In32(InstancePtr->RegBaseAddress + XDC_DMAC_REG_OFFSET);
    Register &= XDC_DMACR_TX_CS_INIT_MASK;
    XIo_Out32(InstancePtr->RegBaseAddress + XDC_DMAC_REG_OFFSET,
              Register | Control);
}

/*****************************************************************************/
/**
*
* This function gets the status register contents of the DMA channel.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @return
*
* The status register contents of the DMA channel. One or more of the
* following values may be contained the register. Each of the values are
* unique bit masks.
*                               <br><br>
* - XDC_DMASR_BUSY_MASK         The DMA channel is busy
*                               <br><br>
* - XDC_DMASR_BUS_ERROR_MASK    A bus error occurred
*                               <br><br>
* - XDC_DMASR_BUS_TIMEOUT_MASK  A bus timeout occurred
*                               <br><br>
* - XDC_DMASR_LAST_BD_MASK      The last buffer descriptor of a packet
*
* @note
*
* None.
*
******************************************************************************/
Xuint32 XDmaChannel_GetStatus(XDmaChannel *InstancePtr)
{
    /* assert to verify input arguments */

    XASSERT_NONVOID(InstancePtr != XNULL);
    XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* return the contents of the DMA status register */

    return XIo_In32(InstancePtr->RegBaseAddress + XDC_DMAS_REG_OFFSET);
}

/*****************************************************************************/
/**
*
* This function sets the interrupt status register of the specified DMA channel.
* Setting any bit of the interrupt status register will clear the bit to
* indicate the interrupt processing has been completed. The definitions of each
* bit in the register match the definition of the bits in the interrupt enable
* register.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @param
*
* Status contains the value to be written to the status register of the DMA
* channel.  One or more of the following values may be contained the register.
* Each of the values are unique bit masks such that they may be ORed together
* to enable multiple bits or inverted and ANDed to disable multiple bits.
* - XDC_IXR_DMA_DONE_MASK       The dma operation is done
* - XDC_IXR_DMA_ERROR_MASK      The dma operation had an error
* - XDC_IXR_PKT_DONE_MASK       A packet is complete
* - XDC_IXR_PKT_THRESHOLD_MASK  The packet count threshold reached
* - XDC_IXR_PKT_WAIT_BOUND_MASK The packet wait bound reached
* - XDC_IXR_SG_DISABLE_ACK_MASK The scatter gather disable completed
* - XDC_IXR_BD_MASK             A buffer descriptor is done
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XDmaChannel_SetIntrStatus(XDmaChannel *InstancePtr, Xuint32 Status)
{
    /* assert to verify input arguments except the status which can't be
     * asserted since all values are valid
     */
    XASSERT_VOID(InstancePtr != XNULL);
    XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* set the interrupt status register with the specified value such that
     * all bits which are set in the register are cleared effectively clearing
     * any active interrupts
     */
    XIo_Out32(InstancePtr->RegBaseAddress + XDC_IS_REG_OFFSET, Status);
}

/*****************************************************************************/
/**
*
* This function gets the interrupt status register of the specified DMA channel.
* The interrupt status register indicates which interrupts are active
* for the DMA channel.  If an interrupt is active, the status register must be
* set (written) with the bit set for each interrupt which has been processed
* in order to clear the interrupts.  The definitions of each bit in the register
* match the definition of the bits in the interrupt enable register.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @return
*
* The interrupt status register contents of the specified DMA channel.
* One or more of the following values may be contained the register.
* Each of the values are unique bit masks.
*                               <br><br>
* - XDC_IXR_DMA_DONE_MASK       The dma operation is done
*                               <br><br>
* - XDC_IXR_DMA_ERROR_MASK      The dma operation had an error
*                               <br><br>
* - XDC_IXR_PKT_DONE_MASK       A packet is complete
*                               <br><br>
* - XDC_IXR_PKT_THRESHOLD_MASK  The packet count threshold reached
*                               <br><br>
* - XDC_IXR_PKT_WAIT_BOUND_MASK The packet wait bound reached
*                               <br><br>
* - XDC_IXR_SG_DISABLE_ACK_MASK The scatter gather disable completed
*                               <br><br>
* - XDC_IXR_SG_END_MASK         Current descriptor was the end of the list
*                               <br><br>
* - XDC_IXR_BD_MASK             A buffer descriptor is done
*
* @note
*
* None.
*
******************************************************************************/
Xuint32 XDmaChannel_GetIntrStatus(XDmaChannel *InstancePtr)
{
    /* assert to verify input arguments */

    XASSERT_NONVOID(InstancePtr != XNULL);
    XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* return the contents of the interrupt status register */

    return XIo_In32(InstancePtr->RegBaseAddress + XDC_IS_REG_OFFSET);
}

/*****************************************************************************/
/**
*
* This function sets the interrupt enable register of the specified DMA
* channel.  The interrupt enable register contains bits which enable
* individual interrupts for the DMA channel.  The definitions of each bit
* in the register match the definition of the bits in the interrupt status
* register.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @param
*
* Enable contains the interrupt enable register contents to be written
* in the DMA channel. One or more of the following values may be contained
* the register. Each of the values are unique bit masks such that they may be
* ORed together to enable multiple bits or inverted and ANDed to disable
* multiple bits.
* - XDC_IXR_DMA_DONE_MASK       The dma operation is done
* - XDC_IXR_DMA_ERROR_MASK      The dma operation had an error
* - XDC_IXR_PKT_DONE_MASK       A packet is complete
* - XDC_IXR_PKT_THRESHOLD_MASK  The packet count threshold reached
* - XDC_IXR_PKT_WAIT_BOUND_MASK The packet wait bound reached
* - XDC_IXR_SG_DISABLE_ACK_MASK The scatter gather disable completed
* - XDC_IXR_SG_END_MASK         Current descriptor was the end of the list
* - XDC_IXR_BD_MASK             A buffer descriptor is done
*
* @return
*
* None.
*
* @note
*
* None.
*
******************************************************************************/
void XDmaChannel_SetIntrEnable(XDmaChannel *InstancePtr, Xuint32 Enable)
{
    /* assert to verify input arguments except the enable which can't be
     * asserted since all values are valid
     */
    XASSERT_VOID(InstancePtr != XNULL);
    XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* set the interrupt enable register to the specified value */

    XIo_Out32(InstancePtr->RegBaseAddress + XDC_IE_REG_OFFSET, Enable);
}

/*****************************************************************************/
/**
*
* This function gets the interrupt enable of the DMA channel.  The
* interrupt enable contains flags which enable individual interrupts for the
* DMA channel. The definitions of each bit in the register match the definition
* of the bits in the interrupt status register.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @return
*
* The interrupt enable of the DMA channel.  One or more of the following values
* may be contained the register. Each of the values are unique bit masks.
*                               <br><br>
* - XDC_IXR_DMA_DONE_MASK       The dma operation is done
*                               <br><br>
* - XDC_IXR_DMA_ERROR_MASK      The dma operation had an error
*                               <br><br>
* - XDC_IXR_PKT_DONE_MASK       A packet is complete
*                               <br><br>
* - XDC_IXR_PKT_THRESHOLD_MASK  The packet count threshold reached
*                               <br><br>
* - XDC_IXR_PKT_WAIT_BOUND_MASK The packet wait bound reached
*                               <br><br>
* - XDC_IXR_SG_DISABLE_ACK_MASK The scatter gather disable completed
*                               <br><br>
* - XDC_IXR_BD_MASK             A buffer descriptor is done
*
* @note
*
* None.
*
******************************************************************************/
Xuint32 XDmaChannel_GetIntrEnable(XDmaChannel *InstancePtr)
{
    /* assert to verify input arguments */

    XASSERT_NONVOID(InstancePtr != XNULL);
    XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* return the contents of the interrupt enable register */

    return XIo_In32(InstancePtr->RegBaseAddress + XDC_IE_REG_OFFSET);
}

/*****************************************************************************/
/**
*
* This function starts the DMA channel transferring data from a memory source
* to a memory destination. This function only starts the operation and returns
* before the operation may be complete.  If the interrupt is enabled, an
* interrupt will be generated when the operation is complete, otherwise it is
* necessary to poll the channel status to determine when it's complete.  It is
* the responsibility of the caller to determine when the operation is complete
* by handling the generated interrupt or polling the status.  It is also the
* responsibility of the caller to ensure that the DMA channel is not busy with
* another transfer before calling this function.
*
* @param
*
* InstancePtr contains a pointer to the DMA channel to operate on.
*
* @param
*
* SourcePtr contains a pointer to the source memory where the data is to
* be transferred from and must be 32 bit aligned.
*
* @param
*
* DestinationPtr contains a pointer to the destination memory where the data
* is to be transferred and must be 32 bit aligned.
*
* @param
*
* ByteCount contains the number of bytes to transfer during the DMA operation.
*
* @return
*
* None.
*
* @note
*
* The DMA hw will not currently allow a non-local memory transfer to non-local
* memory (memory copy), but only allows a non-local memory to or from the device
* memory (typically a FIFO).
* <br><br>
* It is the responsibility of the caller to ensure that the cache is
* flushed and invalidated both before and after the DMA operation completes
* if the memory pointed to is cached. The caller must also ensure that the
* pointers contain a physical address rather than a virtual address
* if address translation is being used.
*
******************************************************************************/
void XDmaChannel_Transfer(XDmaChannel *InstancePtr,
                               Xuint32 *SourcePtr,
                               Xuint32 *DestinationPtr,
                               Xuint32 ByteCount)
{
    /* assert to verify input arguments and the alignment of any arguments
     * which have expected alignments
     */
    XASSERT_VOID(InstancePtr != XNULL);
    XASSERT_VOID(SourcePtr != XNULL);
    XASSERT_VOID(((Xuint32)SourcePtr & 3) == 0);
    XASSERT_VOID(DestinationPtr != XNULL);
    XASSERT_VOID(((Xuint32)DestinationPtr & 3) == 0);
    XASSERT_VOID(ByteCount != 0);
    XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    /* setup the source and destination address registers for the transfer */

    XIo_Out32(InstancePtr->RegBaseAddress + XDC_SA_REG_OFFSET,
              (Xuint32)SourcePtr);

    XIo_Out32(InstancePtr->RegBaseAddress + XDC_DA_REG_OFFSET,
              (Xuint32)DestinationPtr);

    /* start the DMA transfer to copy from the source buffer to the
     * destination buffer by writing the length to the length register
     */
    XIo_Out32(InstancePtr->RegBaseAddress + XDC_LEN_REG_OFFSET, ByteCount);
}
