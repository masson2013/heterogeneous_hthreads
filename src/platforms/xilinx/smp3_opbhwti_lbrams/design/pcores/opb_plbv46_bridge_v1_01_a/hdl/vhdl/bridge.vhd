-------------------------------------------------------------------------------
-- $Id: bridge.vhd,v 1.1.2.1 2008/12/17 19:04:49 mlovejoy Exp $
-------------------------------------------------------------------------------
-- DISCLAIMER OF LIABILITY
--
-- This file contains proprietary and confidential information of
-- Xilinx, Inc. ("Xilinx"), that is distributed under a license
-- from Xilinx, and may be used, copied and/or disclosed only
-- pursuant to the terms of a valid license agreement with Xilinx.
--
-- XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
-- ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
-- EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
-- LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
-- MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
-- does not warrant that functions included in the Materials will
-- meet the requirements of Licensee, or that the operation of the
-- Materials will be uninterrupted or error-free, or that defects
-- in the Materials will be corrected. Furthermore, Xilinx does
-- not warrant or make any representations regarding use, or the
-- results of the use, of the Materials in terms of correctness,
-- accuracy, reliability or otherwise.
--
-- Xilinx products are not designed or intended to be fail-safe,
-- or for use in any application requiring fail-safe performance,
-- such as life-support or safety devices or systems, Class III
-- medical devices, nuclear facilities, applications related to
-- the deployment of airbags, or any other applications that could
-- lead to death, personal injury or severe property or
-- environmental damage (individually and collectively, "critical
-- applications"). Customer assumes the sole risk and liability
-- of any use of Xilinx products in critical applications,
-- subject only to applicable laws and regulations governing
-- limitations on product liability.
--
-- Copyright 2006, 2008 Xilinx, Inc.
-- All rights reserved.
--
-- This disclaimer and copyright notice must be retained as part
-- of this file at all times.
--
-------------------------------------------------------------------------------
-- Filename:        bridge.vhd
--
-- Description:     This block maintains state about the current status of
--                  plbv46 write operations, the state of plbv46 read
--                  operations and the availability of prefetch data in the
--                  LocalLink read buffer. It also provides a transaction
--                  timeout timer in the event that read data is never claimed
--                  or write data can't make it onto the PLBv46 bus.
--                  
--                  
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--
--
--
-------------------------------------------------------------------------------
-- Author:          TRD
-- Revision:        $Revision: 1.1.2.1 $
-- Date:            $11/06/2006$
--
-- History:
--   TRD   11/06/2006       Initial V46 Version
--   MLL   09/02/2008       Rev`d to proc_common v3, added coverage/off/on
--                          statements, new v1.01.a version and CHANGELOG
--                          removed
--   MLL   12/17/2008       Legal header updated
--                      
--
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
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY proc_common_v3_00_a;
USE proc_common_v3_00_a.family.ALL;  -- need C_FAMILY definitions

-------------------------------------------------------------------------------
ENTITY bridge IS
   
   GENERIC (
      -- BRIDGE CONFIGURATION          
      C_PREFETCH_TIMEOUT : integer RANGE 1 TO 32 := 10;  -- prefetch timeout counter size (bits)

      -- System wide Specification            
      C_FAMILY : string := "virtex4"  -- Xilinx FPGA Family  Type spartan3, virtex4,virtex5   
      );

   PORT (
      -- PLBV46 Master Burst Interface
      IP2Bus_MstRd_Req       : OUT std_logic;  -- User Logic Read Request 
      IP2Bus_MstWr_Req       : OUT std_logic;  -- User Logic Write Request 
      IP2Bus_Mst_Addr        : OUT std_logic_vector(0 TO 32-1);  -- User Logic Request Address
      IP2Bus_Mst_BE          : OUT std_logic_vector(0 TO (32/8)-1);  -- User Logic Request Byte Enables (only used during single data beat requests)
      IP2Bus_Mst_Length      : OUT std_logic_vector(0 TO 11);
      IP2Bus_Mst_Type        : OUT std_logic;  -- User Logic Request Type Indicator
      IP2Bus_Mst_Lock        : OUT std_logic;  -- User Logic Bus Lock Request
      IP2Bus_Mst_Reset       : OUT std_logic;  -- Optional User Logic Reset Request. 
      Bus2IP_Mst_CmdAck      : IN  std_logic;  -- Command Acknowledge Status
      Bus2IP_Mst_Cmplt       : IN  std_logic;  -- Command Complete Status
      Bus2IP_Mst_Error       : IN  std_logic;  -- Command Error Status
      Bus2IP_Mst_Rearbitrate : IN  std_logic;  -- Command Rearbitrate Status
      Bus2IP_Mst_Cmd_Timeout : IN  std_logic;  -- Command Timeout Status

      -- opb_slave Interface
      opbs_prefetch_req    : IN  std_logic;  -- opb slave prefetch request
      opbs_type            : IN  std_logic;  -- opb slave transaction request type
      opbs_prefetch_clr    : IN  std_logic;  -- opb slave prefetch clear
      opbs_postedwr_clr    : IN  std_logic;  -- opb slave posted write clear
      opbs_length          : IN  std_logic_vector(0 TO 11);  --   opb slave transaction length
      opbs_postedwrt_req   : IN  std_logic;  -- opb slave posted write request
      opbs_trans_addr      : IN  std_logic_vector(0 TO 31);  -- opb slave transaction address
      opbs_be              : IN  std_logic_vector(0 TO 3);  -- opb slave byte enable
      brdg_block           : OUT std_logic;  -- bridge block
      brdg_prefetch_cmplt  : OUT std_logic;  -- bridge prefetch complete
      brdg_prefetch_status : OUT std_logic;  -- bridge prefetch status

      -- Buffer Interface
      brdg_wr_bf_rst : OUT std_logic;  -- bridge write buffer reset
      brdg_rd_bf_rst : OUT std_logic;  -- bridge read buffer reset

      -- System
      MPLB_rst : IN std_logic;  -- plb reset
      MPLB_clk : IN std_logic   -- plb clock
      );

END ENTITY bridge;

LIBRARY ieee;
USE ieee.numeric_std.ALL;

ARCHITECTURE syn OF bridge IS

   --CONSTANT timeout_value : unsigned(0 TO C_PREFETCH_TIMEOUT) := ( 1 TO C_PREFETCH_TIMEOUT => '1', others => '0');
   SIGNAL timer_ns, timer_cs     : unsigned(0 TO C_PREFETCH_TIMEOUT);
   SIGNAL trigger_ns, trigger_cs : std_logic;
   SIGNAL transaction_timeout    : std_logic;

   TYPE   bridge_sm_type IS (REQ, CMD, WR, RD, FUFILL);
   SIGNAL bridge_cs, bridge_ns : bridge_sm_type;

   SIGNAL IP2Bus_MstWr_Req_ns, IP2Bus_MstWr_Req_cs          : std_logic;
   SIGNAL IP2Bus_MstRd_Req_ns, IP2Bus_MstRd_Req_cs          : std_logic;
   SIGNAL brdg_wr_bf_rst_ns, brdg_wr_bf_rst_cs              : std_logic;
   SIGNAL brdg_rd_bf_rst_ns, brdg_rd_bf_rst_cs              : std_logic;
   SIGNAL brdg_block_ns, brdg_block_cs                      : std_logic;
   SIGNAL brdg_prefetch_status_ns , brdg_prefetch_status_cs : std_logic;
   SIGNAL brdg_prefetch_cmplt_ns , brdg_prefetch_cmplt_cs   : std_logic;
   
BEGIN
   s1 : IP2Bus_Mst_Lock  <= '0';
   s2 : IP2Bus_Mst_Reset <= '0';

   s3: IP2Bus_Mst_BE(0 TO 3) <= opbs_be;
   s4: IP2Bus_Mst_Addr       <= opbs_trans_addr;
   
   capture : PROCESS (MPLB_clk, MPLB_rst) IS
   BEGIN
      IF (MPLB_rst = '1') THEN
         IP2Bus_Mst_Length     <= (others => '0');
         IP2Bus_Mst_Type       <= '0';
      ELSIF (rising_edge(MPLB_clk)) THEN
         IF (opbs_postedwrt_req OR opbs_prefetch_req) = '1' THEN
            -- These qualifier must be held until the request is cmd_ack'd by
            -- the master burst block. The address and byte enables will NOT
            -- change by design of the opb_slave
            IP2Bus_Mst_Length     <= opbs_length;
            IP2Bus_Mst_Type       <= opbs_type;
         END IF;
      END IF;
   END PROCESS capture;


   -- Transaction timeout
   -- This timer protects against an OPB master that never returns to claim the
   -- prefetch data. If the data isn't claimed then the bridge state machine
   -- can clear out the buffers and unlock the opb slave. This timer is in the
   -- OPB clock domain so it will count half the number of clocks if the
   -- plbv46:opb clock period ratio is 1:2!!!

   s8 : timer_ns <= timer_cs - 1;

   timeout : PROCESS (MPLB_clk, MPLB_rst) IS
   BEGIN
      IF (MPLB_rst = '1') THEN
         timer_cs <= (OTHERS => '0');
      ELSIF (rising_edge(MPLB_clk)) THEN
         IF (trigger_cs = '1') THEN
            timer_cs(0)                       <= '0';
            timer_cs(1 TO C_PREFETCH_TIMEOUT) <= (OTHERS => '1');
         ELSE
            timer_cs <= timer_ns;
         END IF;
      END IF;
   END PROCESS timeout;

   s9 : transaction_timeout <= timer_cs(0);



   bridge_sm : PROCESS (
      Bus2IP_Mst_CmdAck, Bus2IP_Mst_Cmplt, Bus2IP_Mst_Error,
      IP2Bus_MstRd_Req_cs, IP2Bus_MstWr_Req_cs,
      brdg_block_cs, brdg_prefetch_cmplt_cs,
      brdg_prefetch_status_cs, bridge_cs, opbs_postedwrt_req,
      opbs_prefetch_clr, opbs_prefetch_req,
      transaction_timeout
      ) IS
   BEGIN
      -- Hold current state by default
      bridge_ns <= bridge_cs;

      -- SM output signal defaults
      brdg_wr_bf_rst_ns       <= '0';
      brdg_rd_bf_rst_ns       <= '0';
      brdg_block_ns           <= brdg_block_cs;
      IP2Bus_MstRd_Req_ns     <= IP2Bus_MstRd_Req_cs;
      IP2Bus_MstWr_Req_ns     <= IP2Bus_MstWr_Req_cs;
      brdg_prefetch_status_ns <= brdg_prefetch_status_cs;
      brdg_prefetch_cmplt_ns  <= brdg_prefetch_cmplt_cs;
      trigger_ns              <= '1';

      CASE bridge_cs IS
         WHEN REQ =>
            
            IF (opbs_postedwrt_req OR opbs_prefetch_req) = '1' THEN
               IP2Bus_MstWr_Req_ns     <= opbs_postedwrt_req;
               IP2Bus_MstRd_Req_ns     <= opbs_prefetch_req;
               brdg_prefetch_cmplt_ns  <= '0';
               brdg_prefetch_status_ns <= '0';
               brdg_block_ns           <= '1';
               brdg_rd_bf_rst_ns       <= '1';
               bridge_ns               <= CMD;
            END IF;
            
         WHEN CMD =>
            IF (Bus2IP_Mst_Cmplt = '1') THEN
               IF (IP2Bus_MstWr_Req_cs) = '1' THEN
                  -- The write transaction timed out or errored out when the
                  -- master attempted to acquire the PLB. Clean out the posted
                  -- write data buffer as the contents are now stale.
                  IP2Bus_MstWr_Req_ns <= '0';
                  brdg_block_ns       <= '0';
                  brdg_wr_bf_rst_ns   <= '1';
                  bridge_ns           <= REQ;
               ELSE
                  -- Had to be a read request since the requests are mutually
                  -- exclusive. But it is a read prefetch error so the OPB_slave
                  -- needs notification of a prefetch complete but with a status
                  -- of error. It switches to status FUFILL because the OPB slave
                  -- must wait until it gets a read request that claims the buffer
                  -- so that it can spew error acks to the OPB master who wanted
                  -- the data. That means brdg_block must remain asserted
                  IP2Bus_MstRd_Req_ns     <= '0';
                  brdg_block_ns           <= '1';
                  brdg_prefetch_status_ns <= '1';  -- error status
                  brdg_prefetch_cmplt_ns  <= '1';
                  bridge_ns               <= FUFILL;
               END IF;  -- (IP2Bus_MstWr_Req_cs) = '1'
            ELSE
               IF (Bus2IP_Mst_CmdAck = '1') THEN
                  -- PLBv46 master is done acquiring the PLB and transaction
                  -- can commence.
                  IF (IP2Bus_MstWr_Req_cs) = '1' THEN
                     IP2Bus_MstWr_Req_ns <= '0';
                     bridge_ns           <= WR;
                  ELSE
                     IP2Bus_MstRd_Req_ns <= '0';
                     bridge_ns           <= RD;
                  END IF;  -- (IP2Bus_MstWr_Req_cs) = '1'
               END IF;  --(Bus2IP_Mst_CmdAck='1')
            END IF;  -- (Bus2IP_Mst_Cmplt = '1')
            
         WHEN WR =>
            IF (Bus2IP_Mst_Cmplt) = '1' THEN
               brdg_block_ns     <= '0';
               brdg_wr_bf_rst_ns <= '1';
               bridge_ns         <= REQ;
            END IF;
            
         WHEN RD =>
            IF (Bus2IP_Mst_Cmplt = '1') THEN
               brdg_block_ns           <= '1';
               brdg_wr_bf_rst_ns       <= '1';
               brdg_prefetch_status_ns <= Bus2IP_Mst_Error;
               brdg_prefetch_cmplt_ns  <= '1';
               bridge_ns <= FUFILL;
            END IF;
            
         WHEN FUFILL =>
            trigger_ns <= '0';
            IF ((transaction_timeout OR opbs_prefetch_clr) = '1') THEN
               brdg_rd_bf_rst_ns       <= '1';
               brdg_block_ns           <= '0';
               brdg_prefetch_cmplt_ns  <= '0';
               brdg_prefetch_status_ns <= '0';
               bridge_ns               <= REQ;
            END IF;
            
      END CASE;
   END PROCESS bridge_sm;



   bridge_reg : PROCESS(MPLB_clk, MPLB_rst)
   BEGIN
      IF (MPLB_rst = '1') THEN
         bridge_cs <= REQ;

         IP2Bus_MstRd_req_cs     <= '0';
         IP2Bus_MstWr_req_cs     <= '0';
         brdg_prefetch_cmplt_cs  <= '0';
         brdg_prefetch_status_cs <= '0';
         brdg_block_cs           <= '0';
         brdg_rd_bf_rst_cs       <= '1';
         brdg_wr_bf_rst_cs       <= '1';
         trigger_cs              <= '1';
         
      ELSIF (rising_edge(MPLB_clk)) THEN
         bridge_cs <= bridge_ns;

         IP2Bus_MstRd_req_cs     <= IP2Bus_MstRd_req_ns;
         IP2Bus_MstWr_req_cs     <= IP2Bus_MstWr_req_ns;
         brdg_prefetch_cmplt_cs  <= brdg_prefetch_cmplt_ns;
         brdg_prefetch_status_cs <= brdg_prefetch_status_ns;
         brdg_block_cs           <= brdg_block_ns;
         brdg_rd_bf_rst_cs       <= brdg_rd_bf_rst_ns;
         brdg_wr_bf_rst_cs       <= brdg_wr_bf_rst_ns OR opbs_postedwr_clr;
         trigger_cs              <= trigger_ns;
      END IF;
   END PROCESS bridge_reg;



   s10 : IP2Bus_MstRd_req     <= IP2Bus_MstRd_req_cs;
   s11 : IP2Bus_MstWr_req     <= IP2Bus_MstWr_req_cs;
   s12 : brdg_prefetch_cmplt  <= brdg_prefetch_cmplt_cs;
   s13 : brdg_prefetch_status <= brdg_prefetch_status_cs;
   s14 : brdg_block           <= brdg_block_cs;
   s15 : brdg_rd_bf_rst       <= brdg_rd_bf_rst_cs;
   s16 : brdg_wr_bf_rst       <= brdg_wr_bf_rst_cs;
   
END ARCHITECTURE syn;
