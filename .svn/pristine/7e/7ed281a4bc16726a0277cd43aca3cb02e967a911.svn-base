-------------------------------------------------------------------------------
-- $Id: slave_attachment.vhd,v 1.17 2007/03/30 16:44:50 gburch Exp $
-------------------------------------------------------------------------------
-- Slave attachment entity and architecture
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename        slave_attachment.vhd
--
-- Description:     OPB slave attachment for accessing arbitray byte(s) within
--                  word boundary aligned addresses on the OPB side.  Addresses
--                  are required to be contiguous word addresses starting at
--                  C_SLAVE_ATT_BAR with all lsbs are zero to C_SLAVE_ATT_BAR
--                  with all lsbs ones. This module has the master attachment
--                  functionality. This module is written to IEEE-93 vhdl specs.
--
--                  When supporting OPB sequential-address transactions
--                  (bursts), this implementation requires
--                  that OPB_seqAddr be negated for
--                  the last transfer of the burst. (This is more restrictive
--                  than the original OPB, which *recommends* early negation of
--                  OPB_seqAddr and OPB_busLock to allow overlapped
--                  arbitration.
--
-------------------------------------------------------------------------------
-- Structure: 
--
--              slave_attachment.vhd
-------------------------------------------------------------------------------
-- Author:      ML
-- History:
--      ML      04/20/01        -- First version
--
--      ALS     08/21/01    
-- ^^^^^^
--      Changed addr_sel_int to be of type integer. Addr_sel is then the
--      result of CONV_std_logic_vector function using addr_sel_int and the
--      C_SL_ATT_ADDR_SEL_WIDTH generic. 
--
--      Also changed the implementation of the master data buffer from registers
--      to SRL16 fifos.
-- ~~~~~~
--
--      ALS     08/24/01
-- ^^^^^^
--      Implemented Slave Only - No Burst logic using a state machine.
-- ~~~~~~
--
--      ALS     08/30/01
-- ^^^^^^
--      Added registers for OPB bus signals. Bus2IP address bus is no longer
--      zero'd as the address mux is a true mux.
--      Added pselect module for address decode.
-- ~~~~~~
--
--      ALS     09/10/01
-- ^^^^^^
--      Modified SLAVE ONLY NO BURST mode:
--      Pulled generation of Sln_Dbus_gtd_cmb from state machine. Instead, 
--      state machine just generates sln_dbus_rst. Sln_DBus_gtd is now
--      registered with IP2Bus_Data_mx as the D input, sln_dbus_rst as the
--      synchronous reset, and IP2Bus_RdAck_mx as the CE.
-- ~~~~~~
--
--      ALS     09/11/01
-- ^^^^^^
--      Modified SLAVE ONLY, BURST mode:
--      Implemented this logic as a state machine. Added bus registers.
-- ~~~~~~
--
--      ALS     09/13/01
-- ^^^^^^
--      Fixed implementation of Sln_ErrAck in both SLAVE ONLY BURST and NO 
--      BURST modes. IP must assert IP2Bus_RdAck or IP2Bus_WrAck when 
--      asserting IP2Bus_ErrAck. Changed sln_dbus_rst to sln_rst since this
--      signal will be used to reset both Sln_DBus and Sln_ErrAck.
-- ~~~~~~
--
--      ALS     09/18-19/01
-- ^^^^^^
--      Modified SLAVE ONLY BURST mode:
--      Implemented necessary changes to allow bursts to operate correctly.
-- ~~~~~~
--
--      ALS     09/25/01
-- ^^^^^^
--      Merged slv_attach.vhd and slave_attachment.vhd files. Incorporated new
--      generics and renamed generics as needed. Extended address bus to include
--      lower two bits. NO MODIFICATIONS TO THE SLAVE/MASTER module have been
--      made at this time.
-- ~~~~~~
--
--      ALS     09/28/01
-- ^^^^^^
--      Moved SRL_FIFOs to processor common library. Added library statement
--      and updated SRL_FIFO component declaration.
-- ~~~~~~
--
--      ALS     10/02/01
-- ^^^^^^
--      Modified SLAVE FULL mode to extend the address bus to include lower
--      two bits.
-- ~~~~~~
--      ALS     10/03/01
-- ^^^^^^
--      Implemented SLAVE FULL mode in a state machine. Added outputs 
--      SA2MA_Retry and SA2MA_Error.
-- ~~~~~~
--      ALS     10/22-26/01
-- ^^^^^^
--      Actual code implementation and debug
-- ~~~~~~
--      ALS     10/28-29/01
-- ^^^^^^
--      Combined the read burst and master burst counters. Worked on arbitration
--      between the two state machines.
-- ~~~~~~
--      ALS     11/10/01
-- ^^^^^^
--      Reviewed use of asynchronous resets in the code and cleaned up where 
--      necessary. In most cases, the asynchronous resets were stable, but were
--      removed anyway.
-- ~~~~~~
--      ALS     12/08/01
-- ^^^^^^
--      Removed reset on master burst counter, counter gets correct value loaded
--      Added negation of bus2ip_devicesel_mstr on transitions to MSTR_ACK state
--      so that bus2ip_devicesel_mstr correctly negates. Signal bus2ip_burst_reg
--      now uses bus2ip_burst_opb instead of bus2ip_burst_opb_reg so that it
--      negates properly. Bus2ip_burst_sa will now also negate with mstr_burst_fe.
--      Added synchronous reset of OPB_SeqAddr falling edge
--      to read request register.
-- ~~~~~~
--      ALS     12/10/01
-- ^^^^^^
--      ma2sa_rd_flag is now reset from mstr state machine during SET_REQ state
--      instead of being reset by sa2ma_rdrdy.
-- ~~~~~~
--      ALS     12/12/01
-- ^^^^^^
--      Qualified falling edge of OPB_SeqAddr with opb_busy to sequential reset
--      of Bus2IP_RdReq.
-- ~~~~~~
--      ALS     12/12/01
-- ^^^^^^
--      Changed the synchronous reset of bus2ip_rdreq_dec to also include
--      reset on the falling edge of OPB_SeqAddr.
--      Changed the synchronous reset of bus2ip_devicesel_dec to include
--      Valid_decode instead of valid_decode_d1.
--      (Change logged by FO)
-- ~~~~~~
--      FLO     1/2/02
-- ^^^^^^
--      Renamed Sln_DBus_gtd to the external name, Sln_DBus.
--      Removed the C_SL_ATT_ADDR_SEL_WIDTH parameter.
--      Some _sa signals go to _i suffix.
-- ~~~~~~
--      FLO     Since v1_23_d
-- ^^^^^^
--      Several name changes to signals and generics as part of effort
--      to improve consistency of naming throughout the OPB IPIF.
-- ~~~~~~
--      ALS     03/22/02
-- ^^^^^^
--      Changed signals
--          Sln_Retry <= sln_retry_i when OPB_Select='1' else '0';
--          Sln_XferAck <= sln_xferack_i when OPB_Select='1' else '0';
--          Sln_ErrAck <= sln_errack_i when OPB_Select='1' else '0';
--      to not rely on asynchronous reset for negation when OPB_Select
--      becomes '0';
--      (Change logged by FO)
-- ~~~~~~
--      ALS, SH     04/18/02
-- ^^^^^^
--      Last change mentioned above, not actually done. Now it is
--      done, along with that which follows.
--
--      Process SLVONLY_NOBURST_SLN_REG,
--      incorrectly had assignments to Sln_XferAck and Sln_ErrAck,
--      instead of to Sln_XferAck_i and Sln_ErrAck_i.
--      (Change logged by FO)
-- ~~~~~~
--      FLO         05/14/02
-- ^^^^^^
--      A couple of changes were needed to support the retained-state
--      retry mode implemented in the master attachment.
-- ~~~~~~
--      FLO         05/29/02
-- ^^^^^^
--      Removed defunct "Sln_retry <= sln_retry_i" signal assignments.
-- ~~~~~~
--      FLO         06/14/02
-- ^^^^^^
--      Implemented capability to inhibit slave-mode posted writes.
--      Since all slave-mode posted writes were due to OPB sequential
--      address (burst) transactions, the implementation was done
--      done in terms of masking the OPB_SeqAddr signal.
-- ~~~~~~
--      FLO      06/24/02
-- ^^^^^^
--      Implemented dynamic byte-enable capability.
-- ~~~~~~
--      FLO         07/17/02
-- ^^^^^^
--      Fix to zero Sln_Dbus upon retry response to local master.
-- ~~~~~~
--      FLO         08/12/02
-- ^^^^^^
--      Changed to Bus2IP_Burst to have same validity window as
--      Bus2IP_RdReq or Bus2IP_WrReq.
--
--      Added MA2SA_Retry to sensitivity list of SLN_DBUS_RST_PROCESS.
-- ~~~~~~
--      FLO   08/20/02
-- ^^^^^^
--      Fixed the "WrCE fallout" bug by adding
--      bus2ip_devicesel_dec_cmb <= '1';
--      under the SET_REQ state when other conditions are, write, non-burst,
--      ack not yet received and the next state going to WAIT_ACK.
-- ~~~~~~
--      FLO         09/04/02
-- ^^^^^^
--      Added capability to abort IPIC transaction if termination
--      is by OPB_timeout. Done for each of the versions, mstr,
--      slave-only-burst, and slave-only-no-burst.
--
-- ~~~~~~
--      FLO         09/10/02
-- ^^^^^^
--      Added port signal Bus2IP_LocalMstTrans. This signal is a qualifier
--      valid during any IPIC transfer. It is asserted during an IPIC
--      transfer if and only if the transfer is taking place as part of
--      a locally initiated master transaction. Local master transactions 
--      can be initiated either by an IPIF DMA[SG] engine or a IP-core
--      master, if either or both are present. If there is no IPIC
--      transfer in progress, the value of Bus2IP_LocalMstTrans may be
--      arbitrary.
-- ~~~~~~
--      FLO         09/11/02
-- ^^^^^^
--      Corrected write burst addressing by adding pipe stage on
--      Bus2IP_Addr_sa to match the Bus2IP_Data pipe stage. (Also
--      similarly pipelined Bus2IP_BE and Bus2IP_RNW for consistency
--      in the pipeline model.)
-- ~~~~~~
--      FLO         09/11/02
-- ^^^^^^
--      Added gating of sln_xferack by non-falling-edge
--      of obp_burst. This was needed to supress a spurious sln_xferack
--      generated when an opb seqaddr write sequence is followed immediately
--      by a new transaction without negation of OPB_select, i.e. when there
--      is no arbitration cycle.
-- ~~~~~~
--      FLO         09/13/02
-- ^^^^^^
--      Changed the cycle on which IP2Bus_PostedWrInh is interpreted to
--      be the first cycle after a rising edge on OPB_SeqAddr instead of
--      the cycle prior to this. IP2Bus_postedWrInh will have a long
--      logic path in the slave_attachment, so, from a performance
--      point of view (although not from a correctness point of
--      view), it should be registered in the IP core.
-- ~~~~~~
--      FLO         09/19/02
-- ^^^^^^
--      Reworked the "full slave" opb state machine and the generation
--      of the Bus2IP_RdReq signal to get correct behavior when a
--      read burst is not acknowledged immediately and the SM
--      goes into the WAIT_ACK state.
-- ~~~~~~
--      FLO         09/21/02
-- ^^^^^^
--      Corrected the timing for the Addr_Cntr_ClkEn and Addr_Sel signals
--      on opb read bursts. These were coming a cycle too late, causing
--      Bus2IP_Addr to be a cycle late for the second an later transfers.
-- ~~~~~~
--      FLO         09/27/02
-- ^^^^^^
--      Unified on just one OPB state machine, eliminating the independent
--      slave-only-with-burst and slave-only-no-burst state machines.
--      The slave-only modes have been broken since v2_00_d sp3
--      as a result of a need to make a succesion of quick changes to the
--      state machine supporting master operation for a core project facing a
--      deadline. The slave-only state machines, therefore, fell behind.
--      Unifying on a single state machine has the advantages of
--      bringing slave-only operation up to date with enhancements and
--      fixes and of making future maintenence easier.
--      The code to support master-operation is placed in an
--      if-generate and the no-burst mode ties signal en_seqaddr low.
--      These measures result in logic resources being trimmed for the
--      slave-only-with-burst and slave-only-no-burst cases.
-- ~~~~~~
--      FLO         11/01/02
-- ^^^^^^
--      - Changed Bus2IP_RdReq on bursts to not negate until
--        Sln_xferAck with not OPB_seqAddr. This, in turn,
--        requires a combinatorial gate-off by falling edge
--        of OPB_seqAddr for the bus2ip_rdreq_rfifo for
--        the read FIFO.
--      - Deleted some unused signals.
--      - Added opbsm state FIN_WR_BURST so that control does not
--        artificially stay in state ACK for an extra cycle as
--        a write burst terminates. Goal is to remove the "gating"
--        code that served to reverse the side-effects of staying
--        in ACK for the extra cycle.
--      - Sln_xferAck is now just sln_xferack_i without gating.
--      - Removed some no-longer-pertinent comments.
--      - Changed opb_burst to bracket all included IPIC transfers;
--        adjusted code relying on former opb_burst timing.
--      - Changed mstr_burst to bracket all included IPIC transfers;
--        adjusted code relying on former mstr_burst timing.
--      - Changed Bus2IP_Burst to be the OR of opb_burst and mstr_burst;
--        Bus2IP_Burst now should act correctly as a qualifer for each
--        IPIC transfer.
--      - The slave attachment, when performing a single read on
--        behalf of a local master doing a single OPB write, will
--        now respond to IP2Bus_Retry by retrying the single read.
--      - Added note in description that early negation of OPB_seqAddr
--        is required.
-- ~~~~~~
--      FLO         11/05/02
-- ^^^^^^
--      - Fixed master SM termination for write bursts; Bus2IP_WrReq
--        was held too long.
--      - Fixed master SM termination for read bursts; for read bursts
--        not getting ack every cycle, Bus2IP_RdReq was negated early
--        and Bus2IP_RdCE was negated late.
-- ~~~~~~
--      FLO         11/06/02
-- ^^^^^^
--      Renamed devicesel_rst to devicesel_inh_opb and added devicesel_inh_mstr.
--      Devicesel_inh_mstr and devicesel_inh_opb are then applied
--      to cause negation of CS and CE assertions the cycle after
--      ip2bus_retry_mx.
-- ~~~~~~
--      FLO         11/19/02
-- ^^^^^^
--      Added output port SA2MA_PostedWrInh.
-- ~~~~~~
--      FLO         12/05/02
-- ^^^^^^
--      When doing an IPIC read on behalf of a master doing an OPB write,
--      if the read (or the first read of an attempted burst) gets
--      IP2Bus_Retry, then SA2MA_Retry is returned to the master_attachment
--      and the transaction terminates.
-- ~~~~~~
--      FLO         01/06/03
-- ^^^^^^
--      Fixed three cases where
--      Bus2IP_RdReq was deasserted 1 clock before RdCE vector was deasserted.
-- ~~~~~~
--      FLO         01/09/03
-- ^^^^^^
--      Removed signals addrcntr_ce_mstr_cmb and addrcntr_ce_mstr_cmb_d1.
--      Now generating Addr_Cntr_ClkEn as
--          Addr_Cntr_ClkEn <= IP2Bus_RdAck_mx or Bus2IP_WrReq_i;
--      With this clock enable, the Bus2IP_amux.vhd address counter
--      increments for slave burst reads and master burst reads and
--      burst writes, as required, since these are the cases for which
--      the address counter is used. The address counter will also increment
--      harmlessly for others cases where the address counter is not used.
-- ~~~~~~
--  FLO      05/15/03
-- ^^^^^^
--  Added the C_ARD_ADDR_RANGE_ARRAY generic.
--  Changed the device-select behavior such that valid_decode is generated
--  and Bus2IP_DeviceSel asserted only if the bus address lies with in one
--  of the ARD address ranges. This is in contrast to the former behavior
--  behavior where the device was considered to be selected if the bus
--  address was inside the smallest power-of-two envelope that included
--  all of the ARD address ranges.
-- ~~~~~~
--  FLO      05/23/04
-- ^^^^^^
--  This failure mode was found during channelized HDLC integration, and fixed
--  between revisions 1.6 and 1.8 of opb_ipif_v2_05_a (see note, below). The
--  fix is now being applied also here to opb_ipif_v2_00_h.
--
--  The scenario was a dma write being started by the local ch_dma_sg. While
--  the IPIC read phase was going on, a software slave write to an IPIF
--  register occured. The a retry of the slave write started soon enough
--  that it was active when an IP2Bus_RdAck (for the read in support of the
--  DMA master transaction) occured. An error in the logic caused the
--  sln_dbus_ce to assert, which resulted in the master write data being
--  driven to the bus and being ORed with the slave data.
--  The fix implemented in the generation of sln_dbus_ce was to replace
--  valid_decode_d1 by opb_busy in the logic that enables sln_dbus to
--  take slave read data.
--
--  Note: opb_ipif_v2_05_a was later reverted to an earlier revision as
--        head but first opb_ipif_v2_06_a was created from opb_ipif_v2_05_a.
--        Thus, the place to see the change as a small delta is
--        between 1.6 and 1.8 (1.7 is a discontinuity)
--        of opb_ipif_v2_05_a, even though it is
--        not published in opb_ipif_v2_05_a but rather in opb_ipif_v2_06_a.
-- ~~~~~~
--  FLO      05/26/04
-- ^^^^^^
--      - An IPIC read timeout function was added to the slave_attachment.
--        New signal SA2MA_TimeOut communicates the timeout condition
--        to the master_attachment. The timeout can detect a hung
--        IPIC read occurring as the slave attachment reads into its read
--        buffer in support of a local master write OPB transaction.
--        The timeout function can be supressed by assertion of IP2Bus_ToutSup.
-- ~~~~~~
--  FLO      08/11/2004
-- ^^^^^^
--  Added input port MA2SA_RSRA (retained_state_retry_active).
--  Qualify mstr_burstcntr_ld by this signal.
-- ~~~~~~
--  FLO      08/20/2004
-- ^^^^^^
--  Changed way that bus2ip_devicesel gets delayed by a cycle for slave
--  burst writes. The former way was suceptible to an erroneous delay
--  during locally mastered transactions. An observed failure mode was
--  the CE for a single IPIC read of data for master write was correspondingly
--  delayed and, therefore, not asserted concurrently with the RdReq pulse.
-- ~~~~~
--  FLO      08/25/2004
-- ^^^^^^
--  Added port Bus2IP_RdReq_rfifo so that this signal, qualified by opb_busy,
--  can be generated here and passed up.
-- ~~~~~
--  FLO      09/22/2004
-- ^^^^^^
-- OPT  12c Deterministic departure from the slv_mstrsm MSTR_IDLE state
-- rather than possibly needing to return to the MSTR_IDLE state from
-- the MSTR_DEV_SEL state because it is detected that the slv_opbsm
-- started a transation on the same cycle. (see v2_05_a SA 11/11/03 and
-- 12/19/03, diff 1.3 1.5)
-- ~~~~~
--  FLO      09/22/2004
-- ^^^^^^
-- OPT  12b Simplified method of generating addr_sel address mux select signals.
-- BUG  12  Moved assertion of mstr_starting forward one cycle (into state MSTR_IDLE).
-- ~~~~~
--  FLO      09/22/04
-- ^^^^^^
--  BUG 10. When master state machine goes from state MSTR_SET_REQ to MSTR_IDLE--because
--  of either of ma2sa_select_d2 or MA2SA_Rd going low--then
--  bus2ip_devicesel_mstr_cmb is negated so that Bus2IP_Burst does not negate
--  before the CS/CE signals negate. (The CS/CE signals negate two cycles
--  after bus2ip_devicesel_mstr_cmb negates.) With this change, Bus2IP_Burst
--  and the CS/CE signals are expected to negate on the same cycle.
--  Issue was discovered relative to HDLC's generation of acceptable wrreq
--  signals to the write channel fifo for burst and non burst.
-- ~~~~~~
--  FLO      09/23/04
-- ^^^^^^
--  Timing optimizations:
--  - Replaced the ld_arith_reg for mstr_burstcntr_ce by ld_arith_reg2,
--    to get MA2SA_XferAck off the path through the MULTAND.
--  - Structured generation of mstr_burstcntr_ce to make MA2SA_XferAck
--    a late-arriving signal.
-- ~~~~~~
--  FLO      09/24/2004
-- ^^^^^^
--  -Added port SA2MA_BufOccMinus1, which gives the occupancy of the outgoing
--   FIFO that supports master write transactions.
--  -SA2MA_Retry now qualifies SA2MA_RdRdy.
--  -The master state machine now allows IPIC read retries on arbitrary beats,
--   not just on the first beat, as previously.
--  -Removed defunct signal sln_rst_mstr.
--  -Removed state MSTR_ACK, which wasn't really adding value, and
--   adjusted the mstr state machine accordingly.
--  -Removed states MSTR_WAIT_ACK and MSTR_RETRY and
--   adjusted the mstr state machine accordingly.
-- ~~~~~~
--  FLO      09/24/04
-- ^^^^^^
--  OPT  13.  CR184349 In slvopb_sm_cs state SET_REQ, which is active
--  for exactly one cycle before moving on, neither bus2ip_rdreq or
--  bus2ip_wrreq could be asserted. Nevertheless, there was logic in this state to
--  respond to IPIC response signals. This response logic was eliminated to reduce
--  code in this state. 
-- ~~~~~~
-- FLO     10/27/2004
-- ^^^^^^
-- - For locally mastered writes, sln_dbus_rst now tied to OPB_xferAck of
--   the last element from the output buffer instead of the last of
--   Mst_Num beats, i.e. keyed to the amount of data actually moved
--   instead of the amount requested.
-- ~~~~~~
-- GAB     3/30/2007
-- ^^^^^^
-- Added sln_dbus_fifo_empty to the sensitivity list of SLN_DBUS_RST_PROCESS
-- process.  This fixes CR435879.
-- ~~~~~~
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_com" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;     -- provides conv_std_logic_vector function
use ieee.std_logic_arith.conv_std_logic_vector;


-- PROC_COMMON library contains the pselect and srl_fifo components
library proc_common_v1_00_b;
use proc_common_v1_00_b.all;
use proc_common_v1_00_b.proc_common_pkg.log2;
use proc_common_v1_00_b.ld_arith_reg;

-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------
--  Definition of Generics
--      C_OPB_ABUS_WIDTH            -- OPB address bus width                
--      C_OPB_DBUS_WIDTH            -- OPB data bus width
--      C_IPIF_ABUS_WIDTH           -- IPIF address bus width
--      C_IPIF_DBUS_WIDTH           -- IPIF data bus width
--      C_DEV_ADDR_DECODE_WIDTH     -- number of upper address bits to decode 
--      C_DEV_BASEADDR              -- base address of slave attachment     
--      C_DEV_BURST_ENABLE          -- indicates if burst is supported      
--      C_DEV_IS_SLAVE_ONLY         -- indicates if device is slave only    
--      C_MA2SA_NUM_WIDTH           -- width of master to slave number  
--      C_ARD_ADDR_RANGE_ARRAY      -- The set of address ranges for decode
--
--
--  Definition of Ports
--      in Reset            
--
--      --OPB ports
--      in OPB_Clk          
--      in OPB_select       
--      in OPB_RNW          
--      in OPB_SeqAddr      
--      in OPB_BE           
--      in OPB_ABus         
--      in OPB_DBus         
--      in OPB_timeout
--
--      out Sln_DBus_gtd     
--      out Sln_xferAck      
--      out Sln_errAck       
--      out Sln_toutSup      
--      out Sln_retry        
--
--      --Master Attachment ports
--      in Bus_MnGrant      
--      in MA2SA_Select     
--      in MA2SA_XferAck    
--      in MA2SA_Rd         
--      in MA2SA_Num
--                          
--      out SA2MA_RdRdy      
--      out SA2MA_WrAck 
--      out SA2MA_Retry
--      out SA2MA_Error
--      out SA2MA_FifoRd
--      out SA2MA_FifoWr
--      out SA2MA_FifoBu
--      out SA2MA_PostedWrInh
--
--      -Address MUX ports
--      out Addr_Sel         
--      out Addr_Cntr_ClkEn  
--
--      -IP ports
--      out Bus2IP_Burst
--      out Bus2IP_RNW
--
--      out Bus2IP_BE_sa     
--      out Bus2IP_Addr_sa   
--      out Bus2IP_Data
--      out Bus2IP_DeviceSel  
--      out Bus2IP_WrReq  
--      out Bus2IP_RdReq  
--      out Bus2IP_LocalMstTrans
--
--      in IP2Bus_Data_mx   
--      in IP2Bus_WrAck_mx  
--      in IP2Bus_RdAck_mx  
--      in IP2Bus_Error_mx 
--      in IP2Bus_ToutSup_mx
--      in IP2Bus_Retry_mx  
--      in IP2Bus_PostedWrInh
-------------------------------------------------------------------------------

library ipif_common_v1_00_d;
use     ipif_common_v1_00_d.ipif_pkg.SLV64_ARRAY_TYPE;

entity slave_attachment is
    generic (
        C_OPB_ABUS_WIDTH        : integer := 32;        
        C_OPB_DBUS_WIDTH        : integer := 32;           
        C_IPIF_ABUS_WIDTH       : integer := 24;           
        C_IPIF_DBUS_WIDTH       : integer := 32;
        C_DEV_ADDR_DECODE_WIDTH : integer := 8;          
        C_DEV_BASEADDR          : std_logic_vector := x"80000000";  
        C_DEV_BURST_ENABLE      : boolean := true;           
        C_DEV_IS_SLAVE_ONLY     : boolean := false;           
        C_MA2SA_NUM_WIDTH       : integer := 4;
        C_ARD_ADDR_RANGE_ARRAY  : SLV64_ARRAY_TYPE
                                :=
        (  -- This is just a representative set included
           -- here so that the slave_attachment entity can be
           -- independently synthesized. This default is not
           -- intended to be useful for any particular application.
         X"0000_0000_7000_1100",
         X"0000_0000_7000_113F",

         X"0000_0000_7000_1000",
         X"0000_0000_7000_10FF",

         X"0000_0000_7000_2100",
         X"0000_0000_7000_21FF",

         X"0000_0000_7000_2200",
         X"0000_0000_7000_22FF",

         X"0000_0000_7000_2000",
         X"0000_0000_7000_2007",

         X"0000_0000_7000_2010",
         X"0000_0000_7000_2017",

         X"0000_0000_7000_2300",
         X"0000_0000_7000_23FF",

         X"0000_0000_7000_0000",
         X"0000_0000_7000_003F",

         X"0000_0000_7000_0040",
         X"0000_0000_7000_0043",

         X"0000_0000_7000_1200",
         X"0000_0000_7000_12FF"
        )

        );
    port(        
        Reset           : in std_logic;
        OPB_Clk         : in std_logic;
        OPB_select      : in std_logic;
        OPB_RNW         : in std_logic;
        OPB_SeqAddr     : in std_logic;
        OPB_BE          : in std_logic_vector (0 to C_OPB_DBUS_WIDTH/8-1);
        OPB_ABus        : in std_logic_vector (0 to C_OPB_ABUS_WIDTH-1);
        OPB_DBus        : in std_logic_vector (0 to C_OPB_DBUS_WIDTH-1);
        OPB_timeout     : in std_logic;
        Sln_DBus        : out std_logic_vector (0 to C_OPB_DBUS_WIDTH-1);
        Sln_xferAck     : out std_logic;
        Sln_errAck      : out std_logic;
        Sln_toutSup     : out std_logic;
        Sln_retry       : out std_logic;
        Bus_MnGrant     : in std_logic := '0';
        MA2SA_Select    : in std_logic := '0';
        MA2SA_XferAck   : in std_logic := '0';
        MA2SA_Retry     : in std_logic := '0';
        MA2SA_RSRA      : in std_logic := '0';
        MA2SA_Rd        : in std_logic := '0';
        MA2SA_Num       : in std_logic_vector(0 to C_MA2SA_NUM_WIDTH-1)
                             := (others => '0');
        SA2MA_RdRdy     : out std_logic; -- Cycle pulse indicating rd complete
        SA2MA_WrAck     : out std_logic;
        SA2MA_Retry     : out std_logic; -- Cycle pulse; qualifies SA2MA_RdRdy
        SA2MA_Error     : out std_logic;
        SA2MA_FifoRd    : out std_logic; -- Rd the output fifo for mstr writes
        SA2MA_FifoWr    : out std_logic; -- Wr the output fifo for mstr writes
        SA2MA_FifoBu    : out std_logic; -- Read back up signal, output fifo
        SA2MA_PostedWrInh:out std_logic; -- IPIC cannot currently take posted wr
        SA2MA_TimeOut   : out std_logic;
        SA2MA_BufOccMinus1 : out std_logic_vector(0 to 4); -- The occupancy
            -- of the output buffer (sln_dbus_fifo) minus 1, as a signed
            -- number. Valid values are -1 to 15. Since the only negative value
            -- is when the occupancy is -1+1=0, SA2MA_BufOccMius1(0) can be
            -- used as a "fifo empty" indicator.
        Addr_Sel        : out std_logic_vector (0 to 1);
        Addr_Cntr_ClkEn : out std_logic;
        Bus2IP_Burst    : out std_logic;
        Bus2IP_RNW      : out std_logic;
        Bus2IP_BE_sa    : out std_logic_vector (0 to C_IPIF_DBUS_WIDTH/8-1);
        Bus2IP_Addr_sa  : out std_logic_vector (0 to C_IPIF_ABUS_WIDTH-1);
        Bus2IP_Data     : out std_logic_vector (0 to C_IPIF_DBUS_WIDTH-1);
        Bus2IP_DeviceSel: out std_logic;
        Bus2IP_WrReq    : out std_logic;
        Bus2IP_RdReq    : out std_logic;
        Bus2IP_RdReq_rfifo : out std_logic;
        Bus2IP_LocalMstTrans: out std_logic;
        IP2Bus_Data_mx  : in std_logic_vector (0 to C_IPIF_DBUS_WIDTH-1);
        IP2Bus_WrAck_mx : in std_logic;
        IP2Bus_RdAck_mx : in std_logic;
        IP2Bus_Error_mx : in std_logic;
        IP2Bus_ToutSup_mx: in std_logic;
        IP2Bus_Retry_mx : in std_logic;
        IP2Bus_PostedWrInh: in std_logic;

        Devicesel_inh_opb_out  :  out std_logic;
        Devicesel_inh_mstr_out :  out std_logic
        
        );
end slave_attachment;

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

architecture implementation of slave_attachment is

-------------------------------------------------------------------------------
-- Constant Declarations
-------------------------------------------------------------------------------
  constant RESET_ACTIVE : std_logic := '1';

  constant ZEROES : std_logic_vector(0 to 256)
                   := (others=>'0');

-------------------------------------------------------------------------------
-- Function Declarations
-------------------------------------------------------------------------------

    function num_bits_to_designate_ar(ar_idx: natural) return natural is
      constant LI: natural := C_ARD_ADDR_RANGE_ARRAY(0)'length-C_OPB_ABUS_WIDTH;
      constant RI: natural := C_ARD_ADDR_RANGE_ARRAY(0)'length-1;
      variable j: natural := LI;
    begin
        while j <= RI and
              C_ARD_ADDR_RANGE_ARRAY(2*ar_idx  )(j) =
              C_ARD_ADDR_RANGE_ARRAY(2*ar_idx+1)(j)
        loop
            j := j+1;
        end loop;
        return j-LI;
    end num_bits_to_designate_ar;


-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------                       

signal opb_abus_d1          : std_logic_vector(0 to C_OPB_ABUS_WIDTH-1);
signal opb_dbus_d1          : std_logic_vector (0 to C_OPB_DBUS_WIDTH-1);
signal opb_rnw_d1           : std_logic;
signal opb_select_d1        : std_logic;
signal opb_be_d1            : std_logic_vector(0 to C_OPB_DBUS_WIDTH/8-1);

signal opb_rnw_d2           : std_logic;

--------------------------------------------------------------------------------
-- These signals are used to implement the IP2Bus_PostedWrInh functionality.
-- This implementation of the functionality follows the strategy of inhibiting
-- the posted-write burst behavior that is normally performed when
-- an OPB transaction is qualified by assertion of OPB_SeqAddr. This
-- strategy is chosen for a low-risk enhancement to a working slave attachment.
-- If IP2Bus_PostedWrInh is asserted during the first cycle of the OPB
-- transaction--which will allways be the cycle following a OPB_SeqAddr
-- rising edge,  any posted-write IPIC burst behavior from that
-- transactions will be inhibited by the slave attachment.
-- Thus, the "and" combination of OPB_SeqAddr and en_seqaddr becomes the
-- effective OPB_SeqAddr. It is false, masking out OPB_SeqAddr whenever
-- posted writes are to be inhibited, and is identical to OPB_SeqAddr (within
-- propagation delay), otherwise.
--------------------------------------------------------------------------------
signal opb_seqaddr_d1       : std_logic;  -- OPB_SeqAddr delayed by one clock
signal eff_seqaddr_d1       : std_logic;  -- Effective value of opb_seqaddr_d1
                                          -- after considering the possibility
                                          -- that IP2Bus_PosterDrInh might
                                          -- disable burst behavior.
signal en_seqaddr           : std_logic;  -- OPB_SeqAddr and en_seqaddr are
                                          -- the effective OPB_SeqAddr after
                                          -- accouting for possible inhibit.

-- sln_dbus fifo signals
signal sln_dbus_rst         : std_logic := '0';
signal sln_dbus_ce          : std_logic := '0';
signal sln_dbus_data        : std_logic_vector(0 to C_OPB_DBUS_WIDTH-1);
signal sln_dbus_fifo_rst    : std_logic := '0';
signal sln_dbus_fifo_wr     : std_logic := '0';
signal sln_dbus_fifo_rd     : std_logic := '0';
signal sln_dbus_fifo_bu     : std_logic_vector(0 to 3
                                              ) := "0000";
signal sln_dbus_fifo_empty  : std_logic := '1';

-- Full slave state machine signals
type SLVFULL_MSTRSMTYPE is (MSTR_IDLE,MSTR_DEVICE_SEL,MSTR_SET_REQ);
signal slv_mstrsm_cs, slv_mstrsm_ns : SLVFULL_MSTRSMTYPE;
type SLVFULL_OPBSMTYPE is (OPB_IDLE,ACK,RETRY,SET_DEVICESEL,SET_REQ,WAIT_ACK,FIN_WR_BURST);
signal slv_opbsm_cs, slv_opbsm_ns   : SLVFULL_OPBSMTYPE;

signal sln_retry_i              : std_logic := '0';
signal sln_retry_cmb            : std_logic := '0';
signal sln_xferack_i            : std_logic := '0';
signal sln_xferack_cmb          : std_logic := '0';
signal sln_errack_i             : std_logic := '0';
signal sln_rst_cmb              : std_logic := '0';     -- used to reset Sln_Dbus and Sln_errAck
signal sln_dbus_i           : std_logic_vector(0 to C_OPB_DBUS_WIDTH-1 );

signal opb_burst                : std_logic;
signal opb_burst_set            : std_logic;
signal opb_burst_rst            : std_logic;
signal mstr_burst               : std_logic;
signal mstr_burst_set           : std_logic;
signal mstr_burst_rst           : std_logic;
signal mstr_burst_cnt           : std_logic_vector(0 to C_MA2SA_NUM_WIDTH-1);
signal mstr_burstcntr_ld_n      : std_logic := '0';
signal mstr_burstcntr_ce        : std_logic := '0';
signal mstr_burstcntr_cehlp     : std_logic := '0';

signal read_buf_data            : std_logic_vector(0 to C_OPB_DBUS_WIDTH-1);

signal addr_sel_i               : std_logic_vector (0 to 1);
signal addr_cntr_clken_i        : std_logic := '0';

signal bus2ip_rdreq_mstr_cmb    : std_logic := '0';
signal bus2ip_rdreq_mstr        : std_logic := '0';
signal bus2ip_rdreq_opb_cmb     : std_logic := '0';
signal bus2ip_rdreq_opb         : std_logic := '0';
signal bus2ip_rdreq_dec_cmb     : std_logic := '0';
signal bus2ip_rdreq_dec         : std_logic := '0';
signal bus2ip_wrreq_mstr_cmb    : std_logic := '0';
signal bus2ip_wrreq_mstr        : std_logic := '0';
signal bus2ip_wrreq_opb_cmb     : std_logic := '0';
signal bus2ip_wrreq_opb         : std_logic := '0';
signal bus2ip_wrreq_dec_cmb     : std_logic := '0';
signal bus2ip_wrreq_dec         : std_logic := '0';


signal mstr_busy_cmb            : std_logic := '0';
signal mstr_busy                : std_logic := '0';
signal opb_busy_cmb             : std_logic := '0';
signal opb_busy_reg             : std_logic := '0';
signal opb_busy                 : std_logic := '0';

signal sa2ma_rdrdy_cmb          : std_logic := '0';
signal sa2ma_rdrdy_i            : std_logic := '0';
signal sa2ma_retry_cmb          : std_logic := '0';
signal sa2ma_wrack_cmb          : std_logic := '0';

signal opb_starting             : std_logic := '0';
signal mstr_starting            : std_logic := '0';
signal devicesel_inh_opb         : std_logic := '0';
signal devicesel_inh_mstr        : std_logic := '0';
signal devicesel_set             : std_logic := '0';

signal bus2ip_devicesel_i        : std_logic := '0';
signal bus2ip_devicesel_opb_cmb  : std_logic := '0';
signal bus2ip_devicesel_opb      : std_logic := '0';
signal bus2ip_devicesel_mstr_cmb : std_logic := '0';
signal bus2ip_devicesel_mstr     : std_logic := '0';

signal bus2ip_burst_mstr        : std_logic := '0';

signal ma2sa_xferack_d1         : std_logic := '0';
signal ma2sa_xferack_d2         : std_logic := '0';
signal ma2sa_select_d1          : std_logic := '0';
signal ma2sa_select_d2          : std_logic := '0';
signal ma2sa_rd_d1              : std_logic := '0';
signal ma2sa_select_re          : std_logic := '0';
signal ma2sa_rd_re              : std_logic := '0';
signal ma2sa_rd_flag            : std_logic := '0';
signal ma2sa_rd_flag_rst        : std_logic := '0';
signal ma2sa_rd_flag_set        : std_logic := '0';

signal valid_decode             : std_logic := '0';
signal valid_decode_d1          : std_logic := '0';

signal Bus2IP_Burst_rd_gateoff_needed : std_logic;
signal rd_or_wr_req_p1          : std_logic;
signal rd_or_wr_req             : std_logic;

signal Bus2IP_WrReq_i           : std_logic;


-------------------------------------------------------------------------------
-- Component Declarations
-------------------------------------------------------------------------------

component srl_fifo_rbu is
  generic (
    C_DWIDTH : positive := 8;     -- changed to positive
    C_DEPTH  : positive := 16;    -- changed to positive
    C_XON    : boolean  := false  -- added for mixed mode sims
    );
  port (
    Clk           : in  std_logic;
    Reset         : in  std_logic;
    FIFO_Write    : in  std_logic;
    Data_In       : in  std_logic_vector(0 to C_DWIDTH-1);
    FIFO_Read     : in  std_logic;
    Data_Out      : out std_logic_vector(0 to C_DWIDTH-1);
    FIFO_Full     : out std_logic;
    FIFO_Empty    : out std_logic;
    Addr          : out std_logic_vector(0 to log2(C_DEPTH)-1);
    Num_To_Reread : in  std_logic_vector(0 to log2(C_DEPTH)-1);
    Underflow     : out std_logic;
    Overflow      : out std_logic
    );
end component srl_fifo_rbu;

-- PSELECT is used to decode the upper address bits
component pselect is
    generic (
    C_AB     : integer := 9;
    C_AW     : integer := 32;
    C_BAR    : std_logic_vector
    );
  port (
    A        : in   std_logic_vector(0 to C_AW-1);
    AValid   : in   std_logic;
    CS       : out  std_logic
    );
end component pselect;


  constant RST_VAL : std_logic_vector(0 to C_MA2SA_NUM_WIDTH-1)
                   := (others=>'0');

component ld_arith_reg
    generic (
        C_ADD_SUB_NOT : boolean := false;
        C_REG_WIDTH   : natural := 8;
        C_RESET_VALUE : std_logic_vector;
        C_LD_WIDTH    : natural :=  8;
        C_LD_OFFSET   : natural :=  0;
        C_AD_WIDTH    : natural :=  8;
        C_AD_OFFSET   : natural :=  0
    );
    port (
        CK       : in  std_logic;
        RST      : in  std_logic; -- Reset to C_RESET_VALUE. (Overrides OP,LOAD)
        Q        : out std_logic_vector(0 to C_REG_WIDTH-1);
        LD       : in  std_logic_vector(0 to C_LD_WIDTH-1); -- Load data.
        AD       : in  std_logic_vector(0 to C_AD_WIDTH-1); -- Arith data.
        LOAD     : in  std_logic;  -- Enable for the load op, Q <= LD.
        OP       : in  std_logic   -- Enable for the arith op, Q <= Q + AD.
                                   -- (Q <= Q - AD if C_ADD_SUB_NOT = false.)
                                   -- (Overrrides LOAD.)
    );
end component;


-------------------------------------------------------------------------------
-- slave_attachment implementation
-------------------------------------------------------------------------------
begin


--- 
--------------------------------------------------------------------------------
-- Here are parts of the implementation that are common to the three
-- implementations for master, slave with burst, slave without burst.
--------------------------------------------------------------------------------

  OPB_INREGS: process (OPB_Clk) begin
      if OPB_Clk'event and OPB_Clk='1' then
          if Reset = RESET_ACTIVE  then
              opb_abus_d1 <= (others => '0');
              opb_dbus_d1 <= (others => '0');
              opb_rnw_d1 <= '0';
              opb_select_d1 <= '0';
              opb_be_d1 <= (others => '0');
              opb_seqaddr_d1 <= '0';
          else
              opb_abus_d1 <= OPB_ABus;
              opb_dbus_d1 <= OPB_DBus;
              opb_rnw_d1 <= OPB_RNW;
              opb_select_d1 <= OPB_select;
              opb_be_d1 <= OPB_BE;
              opb_seqaddr_d1 <= OPB_SeqAddr;
          end if;
      end if;
  end process OPB_INREGS;


  ADDR_PROC: process (OPB_Clk) begin
      if OPB_Clk'event and OPB_Clk='1' then
          Bus2IP_BE_sa   <= opb_be_d1;
          Bus2IP_Addr_sa <= opb_abus_d1(C_OPB_ABUS_WIDTH-C_IPIF_ABUS_WIDTH to
                                        C_OPB_ABUS_WIDTH-1);
          opb_rnw_d2   <= opb_rnw_d1;
      end if;
  end process ADDR_PROC;


  en_seqaddr <= '0' when  not C_DEV_BURST_ENABLE and C_DEV_IS_SLAVE_ONLY
                          -- Note, the implementation at the time of
                          -- this writing always enables burst when
                          -- there is a local master.
                else
                    (   (    not ip2bus_postedwrinh
                         and not opb_seqaddr_d1
                             -- Using the 'not opb_seqaddr_dq' gating
                             -- causes
                        )
                     or OPB_RNW
                     or eff_seqaddr_d1
                    );
  
  EFF_SEQADDR_PROC: process (OPB_Clk)
  begin
      if OPB_Clk'event and OPB_Clk='1' then
          if Reset = RESET_ACTIVE  then
              eff_seqaddr_d1 <= '0';
          else
              eff_seqaddr_d1 <= OPB_SeqAddr and en_seqaddr;
          end if;
      end if;
  end process EFF_SEQADDR_PROC;


--------------------------------------------------------------------------------
-- Decode the address
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- This option assumes that the address range of the device comprises the
-- smallest power of two that envelopes all of the individual address ranges.
--------------------------------------------------------------------------------
--VALID_DECODE_WITH_ENVELOPE_BLOCK: if false generate
--begin
--  SLVFULL_ATTCH_PSELECT_I: pselect
--      generic map (C_AB   => C_DEV_ADDR_DECODE_WIDTH,
--                   C_AW   => C_OPB_ABUS_WIDTH,
--                   C_BAR  => C_DEV_BASEADDR)
--      port map (A         => opb_abus_d1,
--                AValid    => opb_select_d1,
--                CS        => valid_decode);
--end generate;

--------------------------------------------------------------------------------
-- This option assumes that the address range of the device is non-monolithic
-- and comprises the union of the individual address ranges but not the holes
-- between them.
--------------------------------------------------------------------------------
VALID_DECODE_BLOCK: if true generate   ---(

    constant NUM_ARS : positive := C_ARD_ADDR_RANGE_ARRAY'length/2;
    signal or_chain : std_logic_vector(0 to NUM_ARS);

    constant LI: natural := C_ARD_ADDR_RANGE_ARRAY(0)'length-C_OPB_ABUS_WIDTH;
    constant RI: natural := C_ARD_ADDR_RANGE_ARRAY(0)'length-1;

begin
    or_chain(0) <= '0';

    AR_HIT_GEN: for i in 0 to NUM_ARS-1 generate
        signal psel_out: std_logic;
    begin

        AR_HIT_PSELECT_I: pselect
        generic map (C_AB   => num_bits_to_designate_ar(i),
                     C_AW   => C_OPB_ABUS_WIDTH,
                     C_BAR  => C_ARD_ADDR_RANGE_ARRAY(2*i)(LI to RI)
        )
        port map (A         => opb_abus_d1,
                  AValid    => opb_select_d1,
                  CS        => psel_out
        );

        or_chain(i+1) <= or_chain(i) or psel_out;

    end generate;

    valid_decode <= or_chain(NUM_ARS);

end generate;   ---)



-- register the output from the pselect module
VALID_DECODE_REG: process(OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk = '1' then
        if Reset = RESET_ACTIVE  then
            valid_decode_d1 <= '0';
        else
            valid_decode_d1 <= valid_decode;
        end if;
    end if;
end process VALID_DECODE_REG;
              

OPB_BURST_FLAG: process(OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk = '1' then
        if Reset = RESET_ACTIVE  or opb_burst_rst = '1' then
            opb_burst <= '0';
        elsif opb_burst_set = '1' then
            opb_burst <= '1';
        end if;
    end if;
end process OPB_BURST_FLAG;



--------------------------------------------------------------------------------
-- Slave Full OPB Transaction State Machine
-- SLVFULL_OPBSM_CMB:     combinational process for determining next state
-- SLVFULL_OPBSM_REG:     state machine registers
--
--  This state machine is used in conjunction with the SLVFULL_MSTRSM to handle
-- both OPB and master transactions. If the master state machine is busy, as
-- indicated by mstr_busy, an OPB retry is issued. If an OPB transaction is 
-- in progress, as indicated by Valid_Decode, then the master state machine 
-- waits.
--------------------------------------------------------------------------------
SLVFULL_OPBSM_CMB:
    process (OPB_SeqAddr, en_seqaddr, opb_rnw_d1, IP2Bus_WrAck_mx, IP2Bus_RdAck_mx,
             valid_decode, eff_seqaddr_d1, IP2Bus_Retry_mx, sln_retry_i,
             slv_opbsm_cs, addr_sel_i, opb_burst, mstr_busy, valid_decode_d1,
             OPB_timeout, bus2ip_rdreq_dec)
    begin
        -- set defaults
        opb_busy_cmb <= '1';
        bus2ip_devicesel_opb_cmb <= '0';
        bus2ip_rdreq_opb_cmb <= '0';
        bus2ip_wrreq_opb_cmb <= '0';
        sln_retry_cmb <= sln_retry_i;
        sln_xferack_cmb <= '0';
        sln_rst_cmb <= '0';
        devicesel_inh_opb <= '0';
        opb_starting <= '0';
        opb_burst_set <= '0';
        opb_burst_rst <= '0';
        slv_opbsm_ns <= slv_opbsm_cs;
 
        case slv_opbsm_cs is
        
        -------------------------- OPB_IDLE --------------------------
            when OPB_IDLE =>
                -- dead state to give OPB_select and Valid_Decode time
                -- to negate. Proceed immediately to SET_DEVICESEL
                slv_opbsm_ns <= SET_DEVICESEL;
                opb_busy_cmb <= '0';
                opb_burst_rst <= '1';
 
        -------------------------- SET_DEVICESEL --------------------------
            when SET_DEVICESEL =>
                opb_busy_cmb <= '0';    -- negate opb_busy
                
                if valid_decode = '1' then
                   if mstr_busy = '1' then
                        -- master is executing a transaction
                        -- issue a retry
                        sln_retry_cmb <= '1';
                        slv_opbsm_ns <= RETRY;
                    else
                        -- master is not executing a transaction
                        opb_starting <= '1';
                        opb_busy_cmb <= '1';
                        if opb_rnw_d1 = '1' then
                            -- set read request and devicesel
                            bus2ip_devicesel_opb_cmb <= '1';
                        elsif eff_seqaddr_d1 = '0' then
                            -- only preset write request and 
                            -- Bus2IP_DeviceSel if not a burst
                            bus2ip_wrreq_opb_cmb <= '1';
                            bus2ip_devicesel_opb_cmb <= '1';
                        end if ;
                        slv_opbsm_ns <= SET_REQ;
                    end if;
                end if;
 
        -------------------------- SET_REQ --------------------------
            when SET_REQ =>
                opb_busy_cmb <= '1';
                bus2ip_devicesel_opb_cmb <= '1';
                opb_burst_set <= eff_seqaddr_d1;
                if (opb_rnw_d1 = '1') then
                    -- read transaction
                    -- wait for IP2BUS_RDACK
                    bus2ip_rdreq_opb_cmb <= '1';
                    slv_opbsm_ns <= WAIT_ACK;
                elsif eff_seqaddr_d1 = '1' then
                    -- write burst transaction,
                    -- don't wait for IP2BUS_WRACK
                    sln_xferack_cmb <= '1';
                    bus2ip_devicesel_opb_cmb <= '0';
                    slv_opbsm_ns <= ACK;
                else
                    slv_opbsm_ns <= WAIT_ACK;
                end if;
 
        -------------------------- WAIT_ACK --------------------------
            when WAIT_ACK =>
                if valid_decode_d1 = '1' then
                    bus2ip_devicesel_opb_cmb <= '1';
                end if;
                
                bus2ip_rdreq_opb_cmb <= bus2ip_rdreq_dec and eff_seqaddr_d1;
                
                if (opb_rnw_d1 = '1' and IP2Bus_RdAck_mx = '1') then
                    -- read transaction has completed
                    sln_xferack_cmb <= '1';
                    bus2ip_rdreq_opb_cmb <= OPB_seqAddr and en_seqaddr;
                    devicesel_inh_opb <= not (OPB_seqAddr and en_seqaddr);
                    if eff_seqaddr_d1 = '1' then
                    else
                        -- single opb read that's finished, negate opb_busy
                        -- and Bus2IP_DeviceSel
                        opb_busy_cmb <= '0';
                        bus2ip_devicesel_opb_cmb <= '0';
                    end if ;
                    slv_opbsm_ns <= ACK;
                elsif (opb_rnw_d1 = '0' and IP2Bus_WrAck_mx = '1') then
                    -- single write transaction has completed
                    opb_busy_cmb <= '0';
                    sln_xferack_cmb <= '1';
                    slv_opbsm_ns <= ACK;
                    bus2ip_devicesel_opb_cmb <= '0';
                elsif (IP2Bus_Retry_mx = '1') then
                    -- retry
                    bus2ip_devicesel_opb_cmb <= '0';
                    devicesel_inh_opb <= '1';
                    opb_busy_cmb <= '0';
                    sln_retry_cmb <= '1';
                    slv_opbsm_ns <= RETRY;
                elsif (OPB_timeout = '1') then
                    bus2ip_devicesel_opb_cmb <= '0';
                    devicesel_inh_opb <= '1';
                    slv_opbsm_ns <= OPB_IDLE;
                else
                    slv_opbsm_ns <= WAIT_ACK;
                end if;

        -------------------------- ACK --------------------------
            when ACK =>
                if opb_burst = '0' then
                    -- single transaction, terminate transfer
                    -- Read-burst termination, if the rdacks are not
                    -- immediate, also comes through here.
                    -- Write-bursts can also terminate through this state.
                    slv_opbsm_ns <= OPB_IDLE;
                    sln_rst_cmb <= '1';
                    opb_busy_cmb <= '0';
                    devicesel_inh_opb <= opb_rnw_d1;
                elsif (opb_rnw_d1 = '1' and (OPB_SeqAddr and en_seqaddr) = '0') then
                    -- end of read burst
                    slv_opbsm_ns <= OPB_IDLE;
                    sln_rst_cmb <= '1';                
                    devicesel_inh_opb <= '1';
                    opb_busy_cmb <= '0';
                elsif (opb_rnw_d1 = '0' and (OPB_SeqAddr and en_seqaddr) = '0') then
                    -- end of write burst
                    bus2ip_wrreq_opb_cmb <= '1'; -- Need one more cycle of wrreq
                    slv_opbsm_ns <= FIN_WR_BURST;
                    sln_rst_cmb <= '1';
                    bus2ip_devicesel_opb_cmb <= '1';
                else
                    -- continue burst
                    bus2ip_devicesel_opb_cmb <= '1';
                    if opb_rnw_d1 = '1' then
                        bus2ip_rdreq_opb_cmb <= '1';
                    else
                        bus2ip_wrreq_opb_cmb <= '1';
                    end if ;
                    if (opb_rnw_d1 = '0' or 
                      (opb_rnw_d1 = '1' and IP2Bus_RdAck_mx = '1')) then
                        --write burst or read burst with immediate read ack
                        sln_xferack_cmb <= '1';
                        slv_opbsm_ns <= ACK;
                    else
                        -- read burst without immediate read ack
                        slv_opbsm_ns <= WAIT_ACK;
                        sln_rst_cmb <= '1';
                    end if;
                end if;
 
        -------------------------- FIN_WR_BURST --------------------------
            when FIN_WR_BURST =>
                slv_opbsm_ns <= OPB_IDLE;
                opb_busy_cmb <= '0';

        -------------------------- RETRY --------------------------
            when RETRY =>
                opb_busy_cmb <= '0';
                slv_opbsm_ns <= OPB_IDLE;
  
        -------------------------- DEFAULT --------------------------
            when others =>
 
                slv_opbsm_ns <= OPB_IDLE;
        end case;
    end process;
    
    SLVFULL_OPBSM_REG: process (OPB_Clk)
    begin
 
        if (OPB_Clk'event and OPB_Clk = '1') then
            if (Reset = RESET_ACTIVE) then
                slv_opbsm_cs <= OPB_IDLE;
                bus2ip_wrreq_opb <= '0';
                bus2ip_rdreq_opb <= '0';
                bus2ip_devicesel_opb <= '0';
            else
                -- reset state machine when valid_decode is negated
                if valid_decode = '0' then
                    slv_opbsm_cs <= SET_DEVICESEL;
                else
                    slv_opbsm_cs <= slv_opbsm_ns;
                end if;
                bus2ip_wrreq_opb <= bus2ip_wrreq_opb_cmb;
                bus2ip_rdreq_opb <= bus2ip_rdreq_opb_cmb;
                -- signal below is used a CE to bus2ip data reg
                bus2ip_devicesel_opb <= bus2ip_devicesel_opb_cmb;
            end if;
        end if;
    end process;

    OPBBUSY_REG: process (OPB_Clk)
    begin
    if (OPB_Clk'event and OPB_Clk = '1') then
            if (Reset = RESET_ACTIVE) then
                opb_busy_reg <= '0';
            else
                opb_busy_reg <= opb_busy_cmb;
            end if;
        end if;
    end process;
    -- set when rising edge of valid decode
    -- and master state machine not busy
    opb_busy <= '1' when opb_starting = '1' 
                else opb_busy_reg;


---(
GEN_INCLUDE_MSTR_STUFF: if (not C_DEV_IS_SLAVE_ONLY) generate

    signal ipic_timeout_cnt      : std_logic_vector(0 to 4); -- Timeout when
            -- the MSB becomes '1' after counting up from zero.
    signal ipic_timeout          : std_logic;

    signal ipic_timeout_cntr_rst : std_logic;

    signal sa2ma_timeout_cmb     : std_logic;

begin

ipic_timeout <= ipic_timeout_cnt(ipic_timeout_cnt'left);
 
--------------------------------------------------------------------------------
-- Register the Master attachment input signals
--------------------------------------------------------------------------------
SLVFULL_MSTR_INREGS: process(OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk = '1' then
        if Reset = RESET_ACTIVE then
            ma2sa_xferack_d1    <= '0';
            ma2sa_xferack_d2    <= '0';
            ma2sa_select_d1     <= '0';
            ma2sa_select_d2     <= '0';
            ma2sa_rd_d1         <= '0';
            ma2sa_rd_re         <= '0';
        else
            ma2sa_xferack_d1    <= MA2SA_XferAck;
            ma2sa_xferack_d2    <= ma2sa_xferack_d1;
            ma2sa_select_d1     <= MA2SA_Select;
            ma2sa_select_d2     <= ma2sa_select_d1;
            ma2sa_rd_d1         <= MA2SA_Rd;
            ma2sa_rd_re         <= MA2SA_Rd and not(ma2sa_rd_d1);            
        end if;
    end if;
end process SLVFULL_MSTR_INREGS;

-- generate rising edge signal for ma2sa_select for use with burst counter      
ma2sa_select_re <= MA2SA_Select and not(ma2sa_select_d1);

-- MA2SA_RDFLAG registers a rising edge on MA2SA_Rd when opb is busy
-- so that when the OPB is done, the master state machine can proceed
-- it can be reset when SA2MA_RdRdy is asserted indicating that the 
-- read cycle is complete
MA2SA_RDFLAG: process(OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk = '1' then
--        if Reset = RESET_ACTIVE or sa2ma_rdrdy_i = '1' then
        if Reset = RESET_ACTIVE or ma2sa_rd_flag_rst = '1' then
            ma2sa_rd_flag    <= '0';
        elsif (ma2sa_rd_re = '1' and opb_busy = '1') or
              ma2sa_rd_flag_set = '1' then
            ma2sa_rd_flag <= '1';
        end if;
    end if;
end process MA2SA_RDFLAG;

--------------------------------------------------------------------------------
-- Set the Master transaction flags
-- If the MA2SA_Num > 1, then the master is doing either a read or
-- write burst transaction. When the burst count is 0, negate the burst flag.
--------------------------------------------------------------------------------

MSTR_BURST_FLAG: process(OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk = '1' then
        if mstr_burst_rst = '1' then
            mstr_burst <= '0';
        elsif mstr_burst_set = '1' then
            mstr_burst <= '1';
        end if;
    end if;
end process MSTR_BURST_FLAG;



--------------------------------------------------------------------------------
-- Master burst counter
-- Counter will be loaded from MA2SA_Num and will down count each IP2Bus_RdAck
-- or MA2SA_XferAck. 
--------------------------------------------------------------------------------
--ToDo, Synplify pro 7.1beta2 and earlier have a bug that precludes declaring
--      RST_VAL within a block enclosing the instance.
--burst_counter: block
--  constant RST_VAL : std_logic_vector(0 to C_MA2SA_NUM_WIDTH-1)
--                   := (others=>'0');
--begin
  MSTR_BURST_CNTR_I: entity proc_common_v1_00_b.ld_arith_reg2
    generic map (
        C_ADD_SUB_NOT => false,
        C_REG_WIDTH   => C_MA2SA_NUM_WIDTH,
        C_RESET_VALUE => RST_VAL,
        C_LD_WIDTH    => C_MA2SA_NUM_WIDTH,
        C_LD_OFFSET   => 0,
        C_AD_WIDTH    => 1,
        C_AD_OFFSET   => 0,
        C_LOAD_OVERRIDES => true
    )
    port map (
        CK   => OPB_Clk,             -- in  std_logic;
        RST  => Reset,               -- in  std_logic; --Reset to C_RESET_VALUE.
                                     -- (RST overrides OP,LOAD)
        Q    => mstr_burst_cnt,      -- out std_logic_vector(0 to C_REG_WIDTH-1);
        LD   => MA2SA_Num,           -- in  std_logic_vector(0 to C_LD_WIDTH-1);
                                     -- Load data.
        AD   => "1",                 -- in  std_logic_vector(0 to C_AD_WIDTH-1);
                                     -- Arith data.
        LOAD_n => mstr_burstcntr_ld_n, -- in  std_logic; --Enable for load
        OP   => mstr_burstcntr_ce    -- in  std_logic  --Enable for the arith op
                                                       --(OP overrrides LOAD.)
    );
--end block;

mstr_burstcntr_ld_n <= not ( ma2sa_rd_re or 
                             sa2ma_rdrdy_i or 
                             (ma2sa_select_re and not(MA2SA_Rd) and not(MA2SA_RSRA))
                           );
-- clock enable the counter during each remote read transfer ack, local read
-- read ack, or remote write transfer ack
mstr_burstcntr_cehlp <= (IP2Bus_RdAck_mx and bus2ip_devicesel_mstr) or
                        (ma2sa_xferack_d1 and not(MA2SA_Rd)); -- The goal of
    -- introducing mstr_burstcntr_cehlp is to guide synthesis to put
    -- MA2SA_XferAck in the "late-arriving" logic path in the generation of
    -- mstr_burstcntr_ce.

 
mstr_burstcntr_ce <= (MA2SA_XferAck and MA2SA_Rd) or 
                     mstr_burstcntr_cehlp;


--------------------------------------------------------------------------------
-- IPIC timeout counter.
--------------------------------------------------------------------------------
  I_IPIC_TIMEOUT_CNTR: ld_arith_reg  --Configured as simple, resettable up cntr.
    generic map (
        C_ADD_SUB_NOT => true,
        C_REG_WIDTH   => ipic_timeout_cnt'length,
        C_RESET_VALUE => ZEROES(ipic_timeout_cnt'range),
        C_LD_WIDTH    => 1,
        C_LD_OFFSET   => 0,
        C_AD_WIDTH    => 1,
        C_AD_OFFSET   => 0
    )
    port map (
        CK   => OPB_Clk,
        RST  => ipic_timeout_cntr_rst,
        Q    => ipic_timeout_cnt,
        LD   => "0",
        AD   => "1",
        LOAD => '0',
        OP   => '1'
    );

--------------------------------------------------------------------------------
-- Slave Full Master Transaction State Machine
-- SLVFULL_MASTRANS_SM_CMB:     combinational process for determining next state
-- SLVFULL_MASTRANS_SM_REG:     state machine registers
--
--  This state machine is used in conjunction with the SLVFULL_OPBSM to handle
-- both OPB and master transactions. If the master state machine is busy, as
-- indicated by mstr_busy, an OPB retry is issued. If an OPB transaction is 
-- in progress, as indicated by valid_decode, then the master state machine 
-- waits.
--------------------------------------------------------------------------------
-- Combinational process
SLVFULL_MASTRANS_SM_CMB: process (opb_busy, MA2SA_Rd, ma2sa_rd_re,
                         addr_sel_i, ma2sa_xferack_d1, MA2SA_XferAck, ma2sa_rd_flag,
                         mstr_burst, IP2Bus_RdAck_mx, mstr_burst_cnt, MA2SA_Num,
                         IP2Bus_WrAck_mx, IP2Bus_Retry_mx,slv_mstrsm_cs, ma2sa_rd_d1,
                         ma2sa_select_d2, ipic_timeout, IP2Bus_ToutSup_mx)
begin
    bus2ip_devicesel_mstr_cmb <= '0';
    bus2ip_rdreq_mstr_cmb <= '0';
    bus2ip_wrreq_mstr_cmb <= '0';
    SA2MA_Retry_cmb <= '0';
    mstr_busy_cmb <= '1';
    SA2MA_RdRdy_cmb <= '0';
    SA2MA_WrAck_cmb <= '0';
    slv_mstrsm_ns <= slv_mstrsm_cs;
    ma2sa_rd_flag_rst <= '0';
    ma2sa_rd_flag_set <= '0';
    mstr_burst_rst <= '0';
    mstr_burst_set <= '0';
    devicesel_inh_mstr <= '0';
    mstr_starting <= '0';
    ipic_timeout_cntr_rst <= '1';
    sa2ma_timeout_cmb <= '0';

    case slv_mstrsm_cs is
         -------------------------- MSTR_IDLE --------------------------
       when MSTR_IDLE =>
            -- wait in this state until a rising edge of MA2SA_Rd or 
            -- MA2SA_XferAck during a write
            mstr_busy_cmb <= '0';
            mstr_burst_rst <= '1';
            if (    opb_busy = '0'
                and (   ma2sa_rd_re = '1'
                     or ma2sa_rd_flag = '1'
                     or (MA2SA_Rd = '0'and MA2SA_XferAck = '1')
                    )
               ) then
                mstr_starting <= '1';
                bus2ip_devicesel_mstr_cmb <= '1';
                mstr_busy_cmb <= '1';
                slv_mstrsm_ns <= MSTR_DEVICE_SEL;
            end if;

         -------------------------- MSTR_DEVICE_SEL --------------------------
        when MSTR_DEVICE_SEL =>
                bus2ip_devicesel_mstr_cmb <= '1';
                if MA2SA_Rd = '1' then
                    bus2ip_rdreq_mstr_cmb <= '1';
                else
                    bus2ip_wrreq_mstr_cmb <= ma2sa_xferack_d1;
                end if ;
                if MA2SA_Num > conv_std_logic_vector(1, C_MA2SA_NUM_WIDTH) then
                    mstr_burst_set <= '1';
                end if;
                ma2sa_rd_flag_rst <= '1';
                slv_mstrsm_ns <= MSTR_SET_REQ;

         -------------------------- MSTR_SET_REQ --------------------------
        when MSTR_SET_REQ =>
            ipic_timeout_cntr_rst <= IP2Bus_RdAck_mx or IP2Bus_ToutSup_mx;
            bus2ip_devicesel_mstr_cmb <= '1';
            --
            if (MA2SA_Rd = '0' and ma2sa_select_d2 = '0' and mstr_burst = '1')
                  -- Abort a local-master burst read.
               or
               (MA2SA_Rd = '0' and ma2sa_rd_d1 = '1')
                  -- Abort a local-master write.
               then
                bus2ip_devicesel_mstr_cmb <= '0';
                slv_mstrsm_ns <= MSTR_IDLE;
            elsif MA2SA_Rd = '1' then
                -- Local read in support of mstr write
                if IP2Bus_RdAck_mx = '1' then
                    if mstr_burst = '0' then
                        -- single read has completed,
                        -- negate Bus2IP_DeviceSel
                        SA2MA_RdRdy_cmb <= '1';
                        bus2ip_devicesel_mstr_cmb <= '0';
                        slv_mstrsm_ns <= MSTR_IDLE;
                    elsif mstr_burst_cnt = conv_std_logic_vector(1, C_MA2SA_NUM_WIDTH) then
                          -- burst is complete, assert MA2SA_RdRdy and end transaction
                          bus2ip_devicesel_mstr_cmb <= '0';
                          SA2MA_RdRdy_cmb <= '1';
                          devicesel_inh_mstr <= '1';
                          slv_mstrsm_ns <= MSTR_IDLE;
                    else
                        -- burst read, keep req asserted
                        -- set address mux to counter
                        bus2ip_rdreq_mstr_cmb <= '1';
                    end if ;
                elsif IP2Bus_Retry_mx = '1' then
                    -- Retry response on single read.
                    -- Signal sa2ma_retry and terminate the transaction.
                    SA2MA_RdRdy_cmb <= '1';
                    sa2ma_retry_cmb <= '1';
                    bus2ip_devicesel_mstr_cmb <= '0';
                    devicesel_inh_mstr <= '1';
                    mstr_busy_cmb <= '0';
                    slv_mstrsm_ns <= MSTR_IDLE;
                elsif ipic_timeout = '1' then
                    sa2ma_timeout_cmb <= '1';
                    bus2ip_devicesel_mstr_cmb <= '0';
                    devicesel_inh_mstr <= '1';
                    mstr_busy_cmb <= '0';
                    slv_mstrsm_ns <= MSTR_IDLE;
                else
                    -- waiting for ack, keep req asserted if burst
                    -- prepare counter 
                    if mstr_burst = '1' then 
                        bus2ip_rdreq_mstr_cmb <= '1';
                    end if;
                end if;
            elsif mstr_burst = '1' and
                  mstr_burst_cnt=conv_std_logic_vector(1,C_MA2SA_NUM_WIDTH) and
                  ma2sa_xferack_d1 = '1' then
                -- write burst finished
                slv_mstrsm_ns <= MSTR_IDLE;
                bus2ip_devicesel_mstr_cmb <= '0';
                bus2ip_wrreq_mstr_cmb <= '1';
            elsif mstr_burst = '1' then
                -- write burst not finished,
                -- stay in this state and pass ma2sa_xferack_d2
                -- on as the wrreq and addrcntr_ce
                bus2ip_wrreq_mstr_cmb <= ma2sa_xferack_d1;
            elsif (IP2Bus_WrAck_mx = '1') then
                -- single write completed
                -- assert WrAck, negate Bus2IP_DeviceSel
                SA2MA_WrAck_cmb <= '1';
                slv_mstrsm_ns <= MSTR_IDLE;
                bus2ip_devicesel_mstr_cmb <= '0';
            elsif (IP2Bus_Retry_mx = '1') then
                -- single write with retry response
                SA2MA_Retry_cmb <= '1';
                slv_mstrsm_ns <= MSTR_IDLE;
                bus2ip_devicesel_mstr_cmb <= '0';
                devicesel_inh_mstr <= '1';
            end if;


        -------------------------- DEFAULT --------------------------
        when others =>
            slv_mstrsm_ns <= MSTR_IDLE;
    end case;
end process SLVFULL_MASTRANS_SM_CMB;

SLVFULL_MASTRANS_SM_REG: process (OPB_Clk)
begin

    if (OPB_Clk'event and OPB_Clk = '1') then
        if (Reset = RESET_ACTIVE) then
            bus2ip_wrreq_mstr <= '0';
            bus2ip_rdreq_mstr <= '0';
            bus2ip_devicesel_mstr <= '0';
            SA2MA_Retry <= '0';
            mstr_busy <= '0';
            sa2ma_rdrdy_i <= '0';
            SA2MA_WrAck <= '0';
            SA2MA_TimeOut <= '0';
            slv_mstrsm_cs <= MSTR_IDLE;
        else
            bus2ip_wrreq_mstr <= bus2ip_wrreq_mstr_cmb;
            bus2ip_rdreq_mstr <= bus2ip_rdreq_mstr_cmb;
            bus2ip_devicesel_mstr <= bus2ip_devicesel_mstr_cmb;
            SA2MA_Retry <= sa2ma_retry_cmb;
            mstr_busy <= mstr_busy_cmb;
            sa2ma_rdrdy_i <= sa2ma_rdrdy_cmb;
            SA2MA_WrAck <= sa2ma_wrack_cmb;
            SA2MA_TimeOut <= sa2ma_timeout_cmb;
            slv_mstrsm_cs <= slv_mstrsm_ns;
        end if;
    end if;
end process;
SA2MA_RdRdy <= sa2ma_rdrdy_i;

SA2MA_ERROR_PROCESS: process (OPB_Clk)
begin
    if (OPB_Clk'event and OPB_Clk = '1') then
        if (Reset = RESET_ACTIVE) then
            SA2MA_Error <= '0';
        elsif mstr_busy = '1' then
            SA2MA_Error <= IP2Bus_Error_mx;
        end if;
    end if;
end process SA2MA_ERROR_PROCESS;

SA2MA_PostedWrInh <= IP2Bus_PostedWrInh;


--------------------------------------------------------------------------------
-- These signals control the output fifo that is used to buffer up outgoing
-- master data.
--------------------------------------------------------------------------------
  sln_dbus_fifo_rst <= not MA2SA_Rd;

  sln_dbus_fifo_wr  <= MA2SA_Rd and bus2ip_devicesel_mstr and IP2Bus_RdAck_mx;

  sln_dbus_fifo_rd  <= MA2SA_Rd and not sln_dbus_fifo_empty and
                       (Bus_MnGrant or MA2SA_XferAck);

  sln_dbus_fifo_bu(sln_dbus_fifo_bu'length-1)  <=  MA2SA_Rd and
                                                   MA2SA_Retry;

  sln_dbus_fifo_bu(0 to sln_dbus_fifo_bu'length-2)  <=  (others => '0');

  SA2MA_FifoWr      <= sln_dbus_fifo_wr;

  SA2MA_FifoRd      <= sln_dbus_fifo_rd;

  SA2MA_FifoBu      <= sln_dbus_fifo_bu(sln_dbus_fifo_bu'length-1);

-- Instantiate the FIFO
SLN_DBUS_FIFO: srl_fifo_rbu 
  generic map (
    C_DWIDTH => 32,
    C_DEPTH  => 16
    )
  port map (
    Clk           => OPB_Clk,
    Reset         => sln_dbus_fifo_rst,      
    FIFO_Write    => sln_dbus_fifo_wr,
    Data_In       => IP2Bus_Data_mx,    
    FIFO_Read     => sln_dbus_fifo_rd,   
    Data_Out      => read_buf_data,   
    FIFO_Full     => open,   
    FIFO_Empty    => sln_dbus_fifo_empty, 
    Addr          => SA2MA_BufOccMinus1(1 to 4),
    Num_To_Reread => sln_dbus_fifo_bu,
    Underflow     => open,
    Overflow      => open
    );

  SA2MA_BufOccMinus1(0) <= sln_dbus_fifo_empty;

end generate GEN_INCLUDE_MSTR_STUFF;
---)

GEN_EXCLUDE_MSTR_STUFF : if C_DEV_IS_SLAVE_ONLY generate
    read_buf_data <= (others => '0');   
    ma2sa_rd_d1 <= '0';
    ma2sa_xferack_d1 <= '0';
    mstr_burst <= '0';
    mstr_burst_cnt <= (others => '0');
    bus2ip_devicesel_mstr_cmb <= '0';
    bus2ip_devicesel_mstr <= '0';
    bus2ip_wrreq_mstr_cmb <= '0';
    bus2ip_rdreq_mstr_cmb <= '0';
    mstr_busy <= '0';
    mstr_busy_cmb <= '0';
    SA2MA_Retry <= '0';
    SA2MA_WrAck <= '0';
    SA2MA_RdRdy <= '0';
    SA2MA_Error <= '0';
    SA2MA_FifoWr <= '0';
    SA2MA_FifoRd <= '0';
    SA2MA_FifoBu <= '0';
    SA2MA_PostedWrInh <= '0';
end generate GEN_EXCLUDE_MSTR_STUFF;


--------------------------------------------------------------------------------
-- Slave attachment outputs
--------------------------------------------------------------------------------

Bus2IP_LocalMstTrans <= mstr_busy;

Sln_toutSup <= IP2Bus_ToutSup_mx and opb_busy;
            
SLVFULL_OPB_OUTREGS: process (OPB_Clk)
begin
        if OPB_Clk'event and OPB_Clk='1' then
            if (Reset = RESET_ACTIVE or OPB_Select='0') then
                sln_retry_i <= '0';
                sln_xferack_i <= '0';
            else
                sln_xferack_i <= sln_xferack_cmb;
                -- assert retry when asserted from the state machine 
                sln_retry_i <= sln_retry_cmb;
            end if;
            if (Reset = RESET_ACTIVE or sln_rst_cmb = '1' or OPB_Select='0') then
                sln_errack_i <= '0';
            elsif mstr_busy = '0' then
                sln_errack_i <= IP2Bus_Error_mx;
            end if;
    end if;
end process SLVFULL_OPB_OUTREGS;
Sln_Retry <= sln_retry_i when OPB_Select='1' else '0';
Sln_XferAck <= sln_xferack_i;
Sln_ErrAck <= sln_errack_i when OPB_Select='1' else '0';

--------------------------------------------------------------------------------
-- OPB data bus process
-- Data is to be driven on the OPB data bus during a read by a remote master or
-- during a write by the local master. Data to be written on the bus by the 
-- local master comes from the read buffer FIFO.
--------------------------------------------------------------------------------
SLN_DBUS_RST_PROCESS: process (valid_decode_d1, MA2SA_XferAck, mstr_burst_cnt, 
                               MA2SA_Rd, sln_rst_cmb, Bus_MnGrant,
                               MA2SA_Retry,sln_dbus_fifo_empty)
-- this process generates the reset for the opb data bus registers
begin
    if valid_decode_d1 = '0' then
        --master transaction
        if    MA2SA_Rd = '0'
           or MA2SA_Retry = '1'
           or (    MA2SA_XferAck = '1'
               and sln_dbus_fifo_empty = '1'
              )
        then
            sln_dbus_rst <= '1';
        else
            sln_dbus_rst <= '0';
        end if;
    else
        -- OPB transaction
        -- don't reset if MA2SA_Rd=1 and BusMnGrant = '1' because master will
        -- be driving the data bus in the next clock
        if MA2SA_Rd = '1' and Bus_MnGrant = '1' then
            sln_dbus_rst <= '0';
        else
            sln_dbus_rst <= sln_rst_cmb;
        end if;
    end if;
end process SLN_DBUS_RST_PROCESS;


SLN_DATA_PROCESS: process(IP2Bus_Data_mx, read_buf_data, ma2sa_rd_d1, Bus_MnGrant, MA2SA_Select)
-- this process creates the mux for the opb data bus input
begin
    if ma2sa_rd_d1 = '1' and (Bus_MnGrant = '1' or MA2SA_Select = '1') then
        sln_dbus_data <= read_buf_data;
    else
        sln_dbus_data <= IP2Bus_Data_mx;
    end if;
end process SLN_DATA_PROCESS;

SLN_CE_PROCESS: process(IP2Bus_RdAck_mx, Bus_MnGrant, MA2SA_XferAck, opb_busy)
-- this process creates the mux for the ce for the opb data bus registers
-- sln_dbus_rst is asserted whenever MA2SA_Rd = '0' and valid_decode = '0'
begin
    if (opb_busy        = '1' and IP2Bus_RdAck_mx = '1') or
       Bus_MnGrant = '1' or
       MA2SA_XferAck = '1' then
        sln_dbus_ce <= '1';
    else
        sln_dbus_ce <= '0';
    end if;
end process SLN_CE_PROCESS;
    
SLN_DBUS_REG: process (OPB_Clk)
begin
    if (OPB_Clk'event and OPB_Clk = '1') then
            if (sln_dbus_rst = '1' or Reset = RESET_ACTIVE) then
                sln_dbus_i <= (others => '0');
            elsif sln_dbus_ce = '1' then
                sln_dbus_i <= sln_dbus_data;                
            end if;           
    end if;
end process SLN_DBUS_REG;     

Sln_DBus <= sln_dbus_i;
--------------------------------------------------------------------------------
-- Bus2IP Signal Muxes
-- Signals from the IPIF to the IP are either driven from the OPB state machine
-- or the master state machine
--------------------------------------------------------------------------------

DEVICESEL_PROCESS: process (OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk='1' then
        if Reset = RESET_ACTIVE then
            bus2ip_devicesel_i <= '0';
        else
            bus2ip_devicesel_i <= bus2ip_devicesel_opb_cmb or bus2ip_devicesel_mstr_cmb;
        end if;
    end if;
end process DEVICESEL_PROCESS;
-- reset Bus2IP_DeviceSel when read burst ends
-- Bus2IP_DeviceSel <= '0' when (devicesel_inh_opb or devicesel_inh_mstr) = '1' 
--                else bus2ip_devicesel_i;

-- Moved devicesel_inh_opb, devicesel_inh_mstr to address decode
Bus2IP_DeviceSel <= bus2ip_devicesel_i;

        
WRREQ_PROCESS: process (OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk='1' then
        if Reset = RESET_ACTIVE then
            Bus2IP_WrReq_i <= '0';
        else
            Bus2IP_WrReq_i <= bus2ip_wrreq_opb or bus2ip_wrreq_mstr_cmb;
        end if;
    end if;
end process WRREQ_PROCESS;

Bus2IP_WrReq <= Bus2IP_WrReq_i;


RDREQ_PROCESS: process (OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk='1' then
        if Reset = RESET_ACTIVE then
            bus2ip_rdreq_dec <= '0';
        else
            bus2ip_rdreq_dec <= bus2ip_rdreq_opb_cmb or bus2ip_rdreq_mstr_cmb;
        end if;
    end if;
end process RDREQ_PROCESS;
-- quickly reset Bus2IPB_RdReq_sa with OPB_SeqAddr falling edge if doing an OPB transaction

Bus2IP_RdReq <= bus2ip_rdreq_dec;

--  ----------------------------------------------------------------------------
--  -- The RFIFO moves burst data on every cycle and requires negation of
--  -- the RdReq signal to the RFIFO at an exact point relative to the last
--  -- data taken from the FIFO--so that the FIFO can back up properly.
--  -- When the RFIFO read is from a slave OPB transaction,
--  -- Thus, the falling edge of OPB_seqAddr must negate the standard
--  -- Bus2IP_RdReq signal to get the right timing, and
--  -- there is a requirement that OPB_seqAddr is low for the last
--  -- transfer of a locked seqaddr transaction (which is a stronger
--  -- requirement than given by the OPB spec, which merely suggests this).
--  ----------------------------------------------------------------------------
    Bus2IP_RdReq_rfifo <= Bus2IP_RdReq_dec and
                          not (opb_busy and not OPB_seqAddr and opb_seqaddr_d1);
                              ------------------------------------------------
                              -- Falling edge of seqAddr on an OPB
                              -- transaction to which this device is responding.


rd_or_wr_req_p1 <= (bus2ip_rdreq_opb and OPB_SeqAddr) or --For early fe; re ok
                   bus2ip_rdreq_mstr_cmb or
                   bus2ip_wrreq_opb or
                   bus2ip_wrreq_mstr_cmb;

RD_OR_WR_REQ_PROCESS: process (OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk='1' then
        if Reset = RESET_ACTIVE then
            rd_or_wr_req <= '0';
        else
            rd_or_wr_req <= rd_or_wr_req_p1;
        end if;
    end if;
end process RD_OR_WR_REQ_PROCESS;



Bus2ip_Burst <= opb_burst or mstr_burst;

ADDRMUXSIGS_PROCESS: process (OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk='1' then
        if (Reset = RESET_ACTIVE)     then addr_sel_i <= "00";
        elsif opb_starting = '1'      then addr_sel_i <= "00";
        elsif mstr_starting = '1'     then addr_sel_i <= "01";
        elsif addr_cntr_clken_i = '1' then addr_sel_i <= "10";
        else
            null;
        end if;
    end if;
end process ADDRMUXSIGS_PROCESS;

Addr_Sel <= addr_sel_i;

addr_cntr_clken_i <= (IP2Bus_RdAck_mx or  -- Covers slave or master burst read...
                      Bus2IP_WrReq_i      -- ...covers master burst write.
                     ) and
                     (mstr_burst or
                      opb_burst
                     );

Addr_Cntr_ClkEn   <= addr_cntr_clken_i;

BUS2IPDATA_PROCESS: process (OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk='1' then
        if Reset = RESET_ACTIVE then
            Bus2IP_Data    <= (others => '0');
        elsif (bus2ip_devicesel_opb = '1' or 
            (MA2SA_Rd='0' and ma2sa_xferack_d1 = '1')) then
            Bus2IP_Data    <= opb_dbus_d1;
        end if;
    end if;
end process BUS2IPDATA_PROCESS;

Bus2IP_RNW    <= opb_rnw_d2 when mstr_busy = '0'
                 else ma2sa_rd_d1;
                 
Devicesel_inh_opb_out   <=  devicesel_inh_opb; 
Devicesel_inh_mstr_out  <=  devicesel_inh_mstr;

end implementation;
