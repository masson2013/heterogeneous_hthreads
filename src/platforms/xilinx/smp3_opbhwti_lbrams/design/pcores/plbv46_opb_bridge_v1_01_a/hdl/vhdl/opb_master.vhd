
-------------------------------------------------------------------------------
-- $Id: opb_master.vhd,v 1.1.2.1 2008/12/19 20:58:34 mlovejoy Exp $
-------------------------------------------------------------------------------
-- opb_master.vhd -  Version v1_0_a
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
-- Copyright 2006, 2007, 2008 Xilinx, Inc.
-- All rights reserved.
--
-- This disclaimer and copyright notice must be retained as part
-- of this file at all times.
--
-- Filename:        opb_master.vhd
-- Version:         v1_01_a
-- Description: 
--
-------------------------------------------------------------------------------
-- Structure:
--
-------------------------------------------------------------------------------
-- Author:      <Tim Davis>
--
-- History:
--
--  TRD     9/8/2006
-- ~~~~~~
--  - Initial release of v1_00_a
-- ^^^^^^
--  MLL     8/28/2008
--  New version plbv46_opb_bridge_v1_01_a to include new
--  plbv46_slave_burst_v1_01_a and proc_common v3.00.a.
--  Also added coverage off/on for code coverage testing.
--  Removed Changelog and DISCLAIMER OF LIABILITY updated.
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
--
-- NOTES:
-- 1) The CE's from the IPIC are not used but included for consistency to make
-- it easier to connect things up. That unfortunately makes it necessary to
-- include the C_ARD_ADDR_RANGE_ARRAY and C_ARD_NUM_CE_ARRAY generics. **Maybe**
-- there is a chance these might be used in the future.
--
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--use ieee.std_logic_misc.all;

LIBRARY proc_common_v3_00_a;
USE proc_common_v3_00_a.proc_common_pkg.ALL;
--use proc_common_v2_00_a.proc_common_pkg.log2;
--use proc_common_v2_00_a.proc_common_pkg.max2;
USE proc_common_v3_00_a.family.ALL;
USE proc_common_v3_00_a.ipif_pkg.ALL;

--LIBRARY unisim;
--USE unisim.vcomponents.ALL;

LIBRARY plbv46_opb_bridge_v1_01_a;
USE plbv46_opb_bridge_v1_01_a.ALL;

-------------------------------------------------------------------------------

ENTITY opb_master IS
   GENERIC (
      -- Base address and high address pairs.
      C_ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE :=
      (
         X"0000_0000_7000_0000",  -- IP user0 base address
         X"0000_0000_7000_00FF",  -- IP user0 high address
         X"0000_0000_7000_0100",  -- IP user1 base address
         X"0000_0000_7000_01FF"   -- IP user1 high address
         );

      -- This array speifies the number of Chip Enables (CE) that is
      -- required by the cooresponding baseaddr pair.
      C_ARD_NUM_CE_ARRAY : INTEGER_ARRAY_TYPE :=
      (
         1,                   -- User0 CE Number
         8                    -- User1 CE Number
         );

      --  width of the PLB Address Bus (in bits)
      C_SPLB_AWIDTH : integer RANGE 32 TO 36 := 32;

      --  Width of IPIF (Hence IPIC) Data Bus (in bits). This parameter is kept
      --  for consistency with the plbv46_slave_burst core but should always be
      --  32 to match the OPB data width.

      C_SPLB_DWIDTH : integer RANGE 32 TO 128 := 128;

      C_SIPIF_DWIDTH : integer RANGE 32 TO 32 := 32;

      -- PLB:OPB clock period ratio.  1=1:1, 2=1:2
      C_BUS_CLOCK_PERIOD_RATIO : integer RANGE 1 TO 2 := 1;

      C_FAMILY : string := virtex4  -- Select the target architecture type
      );
   PORT (

      -- IP Interconnect (IPIC) Interface from PLBv46 IPIF
      Bus2IP_Clk         : IN  std_logic;
      Bus2IP_Reset       : IN  std_logic;
      IP2Bus_Data        : OUT std_logic_vector(0 TO C_SIPIF_DWIDTH-1);
      IP2Bus_WrAck       : OUT std_logic;
      IP2Bus_RdAck       : OUT std_logic;
      IP2Bus_AddrAck     : OUT std_logic;
      IP2Bus_Error       : OUT std_logic;
      Bus2IP_Addr        : IN  std_logic_vector(0 TO C_SPLB_AWIDTH-1);
      Bus2IP_Data        : IN  std_logic_vector(0 TO C_SIPIF_DWIDTH-1);
      Bus2IP_RNW         : IN  std_logic;
      Bus2IP_BE          : IN  std_logic_vector(0 TO C_SIPIF_DWIDTH/8-1);
      Bus2IP_Burst       : IN  std_logic;
      Bus2IP_BurstLength : IN  std_logic_vector(0 TO log2(16 * (C_SPLB_DWIDTH/8)));
      Bus2IP_WrReq       : IN  std_logic;
      Bus2IP_RdReq       : IN  std_logic;
      Bus2IP_CS          : IN  std_logic_vector(0 TO ((C_ARD_ADDR_RANGE_ARRAY'length)/2)-1);
      Bus2IP_RdCE        : IN  std_logic_vector(0 TO calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);
      Bus2IP_WrCE        : IN  std_logic_vector(0 TO calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);

      -- OPB Bus Master Interface
      OPB_Clk     : IN  std_logic;
      OPB_Rst     : IN  std_logic;
      Mn_request  : OUT std_logic;
      Mn_busLock  : OUT std_logic;
      Mn_select   : OUT std_logic;
      Mn_RNW      : OUT std_logic;
      Mn_BE       : OUT std_logic_vector(0 TO 32/8-1);
      Mn_seqAddr  : OUT std_logic;
      Mn_DBus     : OUT std_logic_vector(0 TO 32-1);
      Mn_ABus     : OUT std_logic_vector(0 TO 32-1);
      OPB_MGrant  : IN  std_logic := '0';
      OPB_xferAck : IN  std_logic := '0';
      OPB_errAck  : IN  std_logic := '0';
      OPB_retry   : IN  std_logic := '0';
      OPB_timeout : IN  std_logic := '0';
      OPB_DBus    : IN  std_logic_vector(0 TO 32 - 1)
      );
END ENTITY opb_master;

ARCHITECTURE syn OF opb_master IS
   CONSTANT prop_delay : time := 1 NS;  -- For simulation clarity only

   CONSTANT ce_all_zero : std_logic_vector(Bus2IP_WrCE'range) := (OTHERS => '0');

   TYPE bridge_state_type IS (REQUEST, TRANSACT, WAIT_DESELECT, FORCEWT);


   SIGNAL bridge_ns, bridge_cs                 : bridge_state_type;
   SIGNAL Mn_select_ns, Mn_select_cs           : std_logic;
   SIGNAL Mn_busLock_ns, Mn_busLock_cs         : std_logic;
   SIGNAL Mn_seqAddr_ns, Mn_seqAddr_cs         : std_logic;
   SIGNAL Mn_RNW_ns, Mn_RNW_cs                 : std_logic;
   SIGNAL Mn_BE_ns, Mn_BE_cs                   : std_logic_vector(0 TO 3);
   SIGNAL IP2Bus_AddrAck_ns, IP2Bus_AddrAck_cs : std_logic;
   SIGNAL IP2Bus_WrAck_ns, IP2Bus_WrAck_cs     : std_logic;
   SIGNAL IP2Bus_RdAck_ns, IP2Bus_RdAck_cs     : std_logic;
   SIGNAL IP2Bus_Error_ns, IP2Bus_Error_cs     : std_logic;

   SIGNAL ce_reduce     : std_logic;  -- 'OR' Reduce of the Bus2IP chip enables
   SIGNAL bus2ip_select : std_logic;  --  Indicates transaction req from bus
BEGIN

   --coverage off
   ASSERT (C_SPLB_AWIDTH = 32)
      REPORT "The PLB Address Width does not equal 32 which is required by the OPB bus."
      SEVERITY FAILURE;
   --coverage on



   -- The bridge reacts when one of the chip enables from the IPIC interface
   -- asserts indicating a request to the bridge. For smallest amount of logic
   -- there should only be one chip enable per (chip select) address region.
   -- The s1, s2, and s3 signal assignments below use an OR-reduce operation on
   -- the read and write IPIC chip enables to identify when the
   -- plbv46_slave_burst is requesting access to the OPB bus. In the 1:2 clock
   -- ratio case the select signal deassertion period needs to be stretched.
   
   s1 : ce_reduce <= '0' AFTER prop_delay WHEN
                     Bus2IP_WrCE = ce_all_zero
                     AND Bus2IP_RdCE = ce_all_zero
                     ELSE
                     '1' AFTER prop_delay;


   
   select_gen1 : IF (C_BUS_CLOCK_PERIOD_RATIO = 1) GENERATE
      -- No pulse stretching is required in the 1:1 clock ratio case.
      s2 : bus2ip_select <= ce_reduce;
   END GENERATE select_gen1;



   select_gen2 : IF (C_BUS_CLOCK_PERIOD_RATIO = 2) GENERATE
      -- This process stretches the low going pulse of the ce_reduce to
      -- ensure that it lasts for two Bus2IP_clk periods which equals one
      -- OPB_CLK period. That way the state machine can see the
      -- deassertion of the IPIC interface request.
      PROCESS (Bus2IP_Clk, ce_reduce) IS
         VARIABLE ce_reduce_dly1 : std_logic;
      BEGIN
         s3 : bus2ip_select <= ce_reduce AND ce_reduce_dly1;
         IF (rising_edge(Bus2IP_Clk)) THEN
            ce_reduce_dly1 := ce_reduce;
         END IF;
      END PROCESS;
   END GENERATE select_gen2;



   --
   -- The state machine connects the two protocols -- opb and ipic
   --
   
   bfsm : PROCESS (Bus2IP_BE, Bus2IP_Burst, Bus2IP_RNW, IP2Bus_AddrAck_cs,
                   IP2Bus_Error_cs, IP2Bus_RdAck_cs, IP2Bus_WrAck_cs, Mn_BE_cs,
                   Mn_RNW_cs, Mn_busLock_cs, Mn_select_cs,
                   Mn_seqAddr_cs, OPB_MGrant, OPB_errAck, OPB_retry,
                   OPB_timeout, OPB_xferAck, bridge_cs, bus2ip_select) IS
      -- Combinatorial Next state and output decoding
   BEGIN
      -- Default to holding current state of all outputs
      bridge_ns         <= bridge_cs         AFTER prop_delay;
      Mn_select_ns      <= Mn_select_cs      AFTER prop_delay;
      Mn_busLock_ns     <= Mn_busLock_cs     AFTER prop_delay;
      Mn_seqAddr_ns     <= Mn_seqAddr_cs     AFTER prop_delay;
      Mn_RNW_ns         <= Mn_RNW_cs         AFTER prop_delay;
      Mn_BE_ns          <= Mn_BE_cs          AFTER prop_delay;
      IP2Bus_AddrAck_ns <= IP2Bus_AddrAck_cs AFTER prop_delay;
      IP2Bus_WrAck_ns   <= IP2Bus_WrAck_cs   AFTER prop_delay;
      IP2Bus_RdAck_ns   <= IP2Bus_RdAck_cs   AFTER prop_delay;
      IP2Bus_Error_ns   <= IP2Bus_Error_cs   AFTER prop_delay;

      CASE bridge_cs IS
         WHEN REQUEST =>
            IP2Bus_Error_ns   <= '0' AFTER prop_delay;
            IP2Bus_AddrAck_ns <= '0' AFTER prop_delay;
            IP2Bus_WrAck_ns   <= '0' AFTER prop_delay;
            IP2BUS_RdAck_ns   <= '0' AFTER prop_delay;

            -- Waiting for a request from the PLBv46 IPIF
            -- (plbv46_slave_burst_v1_01_a) via Chip enable assertion

            IF (OPB_MGrant = '1') THEN
               -- Because Mn_request is combinatorially dependent on
               -- bus2ip_select='1' already it would seem that the following if
               -- condition is redundant. This is true except when bus parking
               -- is activated in which case the OPB_MGrant can assert without
               -- Mn_request ever asserting. DONT'T REMOVE THIS CONDITION!
               -- (OPB Arbiter bus parking on this Master permits a faster
               -- response by pre-issuing the grant prior to a request. Note
               -- that the request never has to be asserted. I'm assuming it
               -- can be without harm.)
               IF (bus2ip_select = '1') THEN
                  bridge_ns     <= TRANSACT     AFTER prop_delay;
                  Mn_select_ns  <= '1'          AFTER prop_delay;
                  Mn_busLock_ns <= Bus2IP_Burst AFTER prop_delay;
                  Mn_seqAddr_ns <= Bus2IP_Burst AFTER prop_delay;
                  Mn_RNW_ns     <= Bus2IP_RNW   AFTER prop_delay;
                  Mn_BE_ns      <= Bus2IP_BE    AFTER prop_delay;
               END IF;
            END IF;
            
         WHEN TRANSACT =>
            IP2Bus_AddrAck_ns <= OPB_xferAck AND NOT OPB_retry  AFTER prop_delay;
            IP2Bus_WrAck_ns   <= OPB_xferAck AND NOT Bus2IP_RNW AFTER prop_delay;
            IP2BUS_RdAck_ns   <= OPB_xferAck AND Bus2IP_RNW     AFTER prop_delay;
            IP2BUS_Error_ns   <= (OPB_xferAck AND OPB_errAck)
                                 OR (OPB_timeout AND NOT OPB_xferAck) AFTER prop_delay;
            IF (bus2ip_select = '1') THEN
               IF (OPB_retry = '1') THEN
                  -- IPIF still wants to get it's request satisfied but the SM
                  -- must go back to re-request the OPB bus again. Retry and
                  -- xferAck are mutually exclusive so the IPIF won't be ack'd
                  -- on retry. The slave can retry indefinately. (Note: This
                  -- should be fixed eventually via a retry timeout counter.)
                  bridge_ns     <= FORCEWT         AFTER prop_delay;
                  Mn_seqAddr_ns <= '0'             AFTER prop_delay;
                  Mn_busLock_ns <= '0'             AFTER prop_delay;
                  Mn_RNW_ns     <= '0'             AFTER prop_delay;
                  mn_BE_ns      <= (OTHERS => '0') AFTER prop_delay;
                  Mn_select_ns  <= '0'             AFTER prop_delay;
               ELSIF (OPB_xferAck) = '1' THEN
                  IF(NOT Bus2IP_Burst) = '1' THEN
                     -- End of transaction from IPIF
                     bridge_ns     <= WAIT_DESELECT   AFTER prop_delay;
                     Mn_seqAddr_ns <= '0'             AFTER prop_delay;
                     Mn_busLock_ns <= '0'             AFTER prop_delay;
                     Mn_RNW_ns     <= '0'             AFTER prop_delay;
                     mn_BE_ns      <= (OTHERS => '0') AFTER prop_delay;
                     Mn_select_ns  <= '0'             AFTER prop_delay;
                  END IF;
               ELSIF OPB_timeout = '1' THEN
                  -- OPB_xferAck takes precedence over OPB_timeout
                  bridge_ns     <= WAIT_DESELECT   AFTER prop_delay;
                  Mn_seqAddr_ns <= '0'             AFTER prop_delay;
                  Mn_busLock_ns <= '0'             AFTER prop_delay;
                  Mn_RNW_ns     <= '0'             AFTER prop_delay;
                  mn_BE_ns      <= (OTHERS => '0') AFTER prop_delay;
                  Mn_select_ns  <= '0'             AFTER prop_delay;
               END IF;
            ELSE
               -- This represents an OPB "Master Abort"
               bridge_ns     <= REQUEST         AFTER prop_delay;
               -- Must deassert bus lock here in case of abnormal termination
               Mn_seqAddr_ns <= '0'             AFTER prop_delay;
               Mn_busLock_ns <= '0'             AFTER prop_delay;
               Mn_RNW_ns     <= '0'             AFTER prop_delay;
               mn_BE_ns      <= (OTHERS => '0') AFTER prop_delay;
               Mn_select_ns  <= '0'             AFTER prop_delay;
            END IF;

         WHEN WAIT_DESELECT =>
            -- The plbv46_burst_slave_v1_00_a pipelines its Bus2IP chip
            -- selects. They won't disappear until the *ack is sampled
            -- high at the next rising edge. This state checks that it IS
            -- deasserted. Otherwise, the state machine will recognize a NEW
            -- transaction immediately after the first one completes.
            IP2Bus_AddrAck_ns <= '0'     AFTER prop_delay;
            IP2Bus_WrAck_ns   <= '0'     AFTER prop_delay;
            IP2BUS_RdAck_ns   <= '0'     AFTER prop_delay;
            IP2BUS_Error_ns   <= '0'     AFTER prop_delay;
            bridge_ns         <= REQUEST AFTER prop_delay;

         WHEN FORCEWT =>
            -- After a retry the master is required to stay off the bus for one
            -- clock.
            bridge_ns <= REQUEST AFTER prop_delay;
            
         --coverage off
         WHEN OTHERS => NULL;
         --coverage on
      END CASE;
   END PROCESS bfsm;



   state : PROCESS (OPB_Clk, OPB_Rst) IS
      -- State Machine state register
   BEGIN
      IF (OPB_Rst = '1') THEN
         bridge_cs <= REQUEST AFTER prop_delay;
      ELSIF (rising_edge(OPB_Clk)) THEN
         bridge_cs <= bridge_ns AFTER prop_delay;
      END IF;
   END PROCESS state;



   oreg : PROCESS (OPB_Clk, OPB_Rst) IS
      -- State Machine output registers
   BEGIN
      IF (OPB_Rst = '1') THEN
         Mn_select_cs      <= '0'             AFTER prop_delay;
         Mn_busLock_cs     <= '0'             AFTER prop_delay;
         Mn_seqAddr_cs     <= '0'             AFTER prop_delay;
         Mn_RNW_cs         <= '0'             AFTER prop_delay;
         Mn_BE_cs          <= (OTHERS => '0') AFTER prop_delay;
         IP2Bus_AddrAck_cs <= '0'             AFTER prop_delay;
         IP2Bus_WrAck_cs   <= '0'             AFTER prop_delay;
         IP2Bus_RdAck_cs   <= '0'             AFTER prop_delay;
         IP2Bus_Error_cs   <= '0'             AFTER prop_delay;
      ELSIF (rising_edge(OPB_Clk)) THEN
         Mn_select_cs      <= Mn_select_ns      AFTER prop_delay;
         Mn_busLock_cs     <= Mn_busLock_ns     AFTER prop_delay;
         Mn_seqAddr_cs     <= Mn_seqAddr_ns     AFTER prop_delay;
         Mn_RNW_cs         <= Mn_RNW_ns         AFTER prop_delay;
         Mn_BE_cs          <= Mn_BE_ns          AFTER prop_delay;
         IP2Bus_AddrAck_cs <= IP2Bus_AddrAck_ns AFTER prop_delay;
         IP2Bus_WrAck_cs   <= IP2Bus_WrAck_ns   AFTER prop_delay;
         IP2Bus_RdAck_cs   <= IP2Bus_RdAck_ns   AFTER prop_delay;
         IP2Bus_Error_cs   <= IP2Bus_Error_ns   AFTER prop_delay;
      END IF;
   END PROCESS oreg;



   apath : PROCESS (Bus2IP_Addr(0 TO 31), Mn_select_cs) IS
      -- Master address bus registers
   BEGIN
      IF Mn_select_cs = '0' THEN
         -- The Master's ABus is or'd externally with the other Master ABus'.
         -- The master must not drive its ABus unless it is selected.
         Mn_ABus <= (OTHERS => '0');
      ELSE
         -- PLBv46 spec, pg 32, sect 2.5.1.1, "For non-line transfers, this
         -- 32-bit bus indicates the lowest numbered byte address of the target
         -- data to be read/written over the PLB."
         Mn_ABus <= Bus2IP_Addr(0 TO 31);
      END IF;
   END PROCESS apath;



   mn_dpath : PROCESS (Bus2IP_Data(0 TO 31), Bus2IP_RNW, Mn_select_cs) IS
      -- Master data bus registers
   BEGIN
      IF (NOT Mn_select_cs OR Bus2IP_RNW) = '1' THEN
         -- The Master's DBus is or'd externally with the slave's bus. On Reads
         -- the master must not be driving anything or the data on the OPB_DBus
         -- will be corrupted. It must not drive anything on writes if not
         -- selected either.
         Mn_DBus <= (OTHERS => '0');
      ELSE
         Mn_DBus <= Bus2IP_Data(0 TO 31);
      END IF;
   END PROCESS mn_dpath;

   

   s2 : IP2Bus_Data(0 TO 31) <= OPB_DBus AFTER prop_delay;

   clkratio1to1 : IF (C_BUS_CLOCK_PERIOD_RATIO = 1) GENERATE
      -- Does the opb_master only see acks when its select is asserted? Or does it
      -- see every device's ack? IE Does it need to qualify the acks w/ select?
      s3 : IP2Bus_AddrAck <= IP2Bus_AddrAck_ns;
      s4 : IP2Bus_WrAck   <= IP2Bus_WrAck_ns;
      s5 : IP2Bus_RdAck   <= IP2Bus_RdAck_ns;
      s6 : IP2Bus_Error   <= IP2Bus_Error_ns;
   END GENERATE clkratio1to1;


   clkratio1to2 : IF (C_BUS_CLOCK_PERIOD_RATIO = 2) GENERATE
      --
      -- To jump the clock domain boundary the longer (OPB_Clk period) acks are
      -- translated to a single pulse in the (PLB_Clk period) domain. Note that
      -- the OPB_CLK is "data" with respect to the BUS2IP_CLK (plb clock) even
      -- though both are presumably generated from the same DLL.
      --
      --                         __    __    __                                      
      -- BUS2IP_Clk           __/  \__/  \__/  \__/
      --                         _____       _____ 
      -- OPB_Clk              __/     \_____/     \                      
      --                          ___________   
      -- IP2Bus_AddrAck_ns    ___/           \______
      --                                _____       
      -- IP2Bus_AddrAck       _________/     \______
      --                                                            
      s3 : IP2Bus_AddrAck <= IP2Bus_AddrAck_ns AND NOT OPB_CLK;
      s4 : IP2Bus_WrAck   <= IP2Bus_WrAck_ns AND NOT OPB_CLK;
      s5 : IP2Bus_RdAck   <= IP2Bus_RdAck_ns AND NOT OPB_CLK;
      s6 : IP2Bus_Error   <= IP2Bus_Error_ns AND NOT OPB_CLK;
   END GENERATE clkratio1to2;



   s10 : Mn_request <= '1' AFTER prop_delay WHEN bus2ip_select = '1' AND bridge_cs = REQUEST ELSE
                       '0' AFTER prop_delay;  -- The request has to drop synchronously
                              -- in case the grant is simply the
                              -- request fed back asynchronously.
   s11 : Mn_select  <= Mn_select_cs;
   s12 : Mn_busLock <= Mn_busLock_cs;
   s13 : Mn_seqAddr <= Mn_seqAddr_cs;
   s14 : Mn_RNW     <= Mn_RNW_cs;
   s15 : Mn_BE      <= Mn_BE_cs;

END ARCHITECTURE syn;
