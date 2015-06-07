-------------------------------------------------------------------------------
-- $Id: plbv46_opb_bridge.vhd,v 1.1.2.1 2008/12/19 20:58:34 mlovejoy Exp $
-------------------------------------------------------------------------------
-- plbv46_opb_bridge.vhd -  Version v1_00_a
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
-- Filename:        plbv46_opb_bridge.vhd
-- VHDL Library:    plbv46_opb_bridge_v1_01_a
-- Version:         v1_00_a $Revision: 1.1.2.1 $
-- Description:     
--
-------------------------------------------------------------------------------
-- Structure:
--
--   plbv46_opb_bridge(syn)
--      plbv46_opb_bridge_v1_01_a.opb_master
--      plbv46_slave_burst_v1_01_a.plbv46_slave_burst
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY proc_common_v3_00_a;
USE proc_common_v3_00_a.proc_common_pkg.ALL;
USE proc_common_v3_00_a.family.ALL;
USE proc_common_v3_00_a.ipif_pkg.ALL;
-------------------------------------------------------------------------------

ENTITY plbv46_opb_bridge IS
   GENERIC (
      C_NUM_ADDR_RNG : integer := 1;

      C_RNG0_BASEADDR : std_logic_vector := X"FFFFFFFF";
      C_RNG0_HIGHADDR : std_logic_vector := X"00000000";

      C_RNG1_BASEADDR : std_logic_vector := X"FFFFFFFF";
      C_RNG1_HIGHADDR : std_logic_vector := X"00000000";

      C_RNG2_BASEADDR : std_logic_vector := X"FFFFFFFF";
      C_RNG2_HIGHADDR : std_logic_vector := X"00000000";

      C_RNG3_BASEADDR : std_logic_vector := X"FFFFFFFF";
      C_RNG3_HIGHADDR : std_logic_vector := X"00000000";

      -- Optimize slave interface for a point to point connection
      C_SPLB_P2P : integer RANGE 0 TO 1 := 0;

      -- Selects the addressing mode to use for Cacheline Read
      -- operations.
      -- 0 = Legacy Read mode (target word first)
      -- 1 = Realign target word address to Cacheline aligned and
      --     then do a linear incrementing addressing from start  
      --     to end of the Cacheline (PCI Bridge enhancement).

      -- The width of the Master ID bus
      -- This is set to log2(C_SPLB_NUM_MASTERS)
      C_SPLB_MID_WIDTH : integer RANGE 1 TO 4 := 3;

      -- The number of Master Devices connected to the PLB bus
      -- Research this to find out default value
      C_SPLB_NUM_MASTERS : integer RANGE 1 TO 16 := 8;

      -- The dwidth (in bits) of the smallest master that will
      -- access this ipif.  
      C_SPLB_SMALLEST_MASTER : integer RANGE 32 TO 128 := 32;

      --  width of the PLB Address Bus (in bits)
      C_SPLB_AWIDTH : integer RANGE 32 TO 36 := 32;

      --  Width of the PLB Data Bus (in bits)
      C_SPLB_DWIDTH : integer RANGE 32 TO 128 := 32;

      -- Ratio of PLB:OPB bus clocks periods. 1=1:1, 2=1:2
      C_BUS_CLOCK_PERIOD_RATIO : integer RANGE 1 TO 2 := 1;

      -- Select the target architecture type
      -- see the family.vhd package in the proc_common library
      C_FAMILY : string := virtex4
      );

   PORT (

      -- System signals ---------------------------------------------------------
      SPLB_Clk : IN std_logic;
      SPLB_Rst : IN std_logic;

      -- PLBv46 Bus Slave signals ------------------------------------------------------
      PLB_ABus       : IN std_logic_vector(0 TO 31);
      PLB_UABus      : IN std_logic_vector(0 TO 31);
      PLB_PAValid    : IN std_logic;
      PLB_SAValid    : IN std_logic;
      PLB_rdPrim     : IN std_logic;
      PLB_wrPrim     : IN std_logic;
      PLB_masterID   : IN std_logic_vector(0 TO C_SPLB_MID_WIDTH-1);
      PLB_abort      : IN std_logic;
      PLB_busLock    : IN std_logic;
      PLB_RNW        : IN std_logic;
      PLB_BE         : IN std_logic_vector(0 TO (C_SPLB_DWIDTH/8)-1);
      PLB_MSize      : IN std_logic_vector(0 TO 1);
      PLB_size       : IN std_logic_vector(0 TO 3);
      PLB_type       : IN std_logic_vector(0 TO 2);
      PLB_lockErr    : IN std_logic;
      PLB_wrDBus     : IN std_logic_vector(0 TO C_SPLB_DWIDTH-1);
      PLB_wrBurst    : IN std_logic;
      PLB_rdBurst    : IN std_logic;
      PLB_wrPendReq  : IN std_logic;
      PLB_rdPendReq  : IN std_logic;
      PLB_wrPendPri  : IN std_logic_vector(0 TO 1);
      PLB_rdPendPri  : IN std_logic_vector(0 TO 1);
      PLB_reqPri     : IN std_logic_vector(0 TO 1);
      PLB_TAttribute : IN std_logic_vector(0 TO 15);

      -- Slave Response Signals
      Sl_addrAck     : OUT std_logic;
      Sl_SSize       : OUT std_logic_vector(0 TO 1);
      Sl_wait        : OUT std_logic;
      Sl_rearbitrate : OUT std_logic;
      Sl_wrDAck      : OUT std_logic;
      Sl_wrComp      : OUT std_logic;
      Sl_wrBTerm     : OUT std_logic;
      Sl_rdDBus      : OUT std_logic_vector(0 TO C_SPLB_DWIDTH-1);
      Sl_rdWdAddr    : OUT std_logic_vector(0 TO 3);
      Sl_rdDAck      : OUT std_logic;
      Sl_rdComp      : OUT std_logic;
      Sl_rdBTerm     : OUT std_logic;
      Sl_MBusy       : OUT std_logic_vector (0 TO C_SPLB_NUM_MASTERS-1);
      Sl_MWrErr      : OUT std_logic_vector (0 TO C_SPLB_NUM_MASTERS-1);
      Sl_MRdErr      : OUT std_logic_vector (0 TO C_SPLB_NUM_MASTERS-1);
      Sl_MIRQ        : OUT std_logic_vector (0 TO C_SPLB_NUM_MASTERS-1);

      -- OPBv20 master signals
      OPB_Clk     : IN  std_logic;
      OPB_Rst     : IN  std_logic;
      Mn_request  : OUT std_logic;
      Mn_busLock  : OUT std_logic;
      Mn_select   : OUT std_logic;
      Mn_RNW      : OUT std_logic;
      Mn_BE       : OUT std_logic_vector(0 TO 32/8-1);
      Mn_seqAddr  : OUT std_logic;
      Mn_DBus     : OUT std_logic_vector(0 TO 32-1);
      Mn_ABus     : OUT std_logic_vector(0 TO 31);
      OPB_MGrant  : IN  std_logic;
      OPB_xferAck : IN  std_logic;
      OPB_errAck  : IN  std_logic;
      OPB_retry   : IN  std_logic;
      OPB_timeout : IN  std_logic;
      OPB_DBus    : IN  std_logic_vector(0 TO 32 - 1)
      );


END plbv46_opb_bridge;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

LIBRARY plbv46_slave_burst_v1_01_a;
LIBRARY plbv46_opb_bridge_v1_01_a;


ARCHITECTURE syn OF plbv46_opb_bridge IS
   --coverage off
   FUNCTION int2bool (
      CONSTANT i : integer)
      RETURN boolean IS
   BEGIN
      IF (i = 0) THEN
         RETURN FALSE;
      ELSE
         RETURN TRUE;
      END IF;
   END FUNCTION int2bool;
   --coverage on

   CONSTANT C_SIPIF_DWIDTH    : integer := 32;
   CONSTANT C_WR_BUFFER_DEPTH : integer := 16;

   -- Selects the addressing mode to use for Cacheline Read
   -- operations.
   -- 0 = Legacy Read mode (target word first). For this mode the cacheline
   --     transaction generates a sequence of addresses starting at the target
   --     word address and wrapping around to the start of the cache line. The
   --     bus2ip_burst signal asserts for all of the addresses. (This is not
   --     acceptable for the bridge because the opb_master would violate the
   -- OPBv20 spec for the Mn_seqAddr signal.)
   -- 1 = Realign target word address to Cacheline aligned and
   --     then do a linear incrementing addressing from start  
   --     to end of the Cacheline (PCI Bridge enhancement).
   CONSTANT C_CACHELINE_ADDR_MODE : integer RANGE 0 TO 1 := 1;

   -- The chip selects ARD array must be built from all available generics then
   -- reduced in size to those that are actually used. The first N pairs are
   -- used and the rest are ignored.
   CONSTANT C_ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE :=
      proc_common_v3_00_a.ipif_pkg.rebuild_slv64_array(
         num_valid_pairs => C_NUM_ADDR_RNG,
         slv64_array     => (
            0            => X"0000_0000" & C_RNG0_BASEADDR,
            1            => X"0000_0000" & C_RNG0_HIGHADDR,
            2            => X"0000_0000" & C_RNG1_BASEADDR,
            3            => X"0000_0000" & C_RNG1_HIGHADDR,
            4            => X"0000_0000" & C_RNG2_BASEADDR,
            5            => X"0000_0000" & C_RNG2_HIGHADDR,
            6            => X"0000_0000" & C_RNG3_BASEADDR,
            7            => X"0000_0000" & C_RNG3_HIGHADDR
            )
         );

   -- The chip enables are not decoded/used by the opb_master block but
   -- the ipif still needs at least one value defined to avoid creating
   -- VHDL errors.
   CONSTANT C_ARD_NUM_CE_ARRAY : INTEGER_ARRAY_TYPE(0 TO C_NUM_ADDR_RNG-1) := (OTHERS => 1);

   SIGNAL Bus2IP_Clk         : std_logic;  -- [IN]
   SIGNAL Bus2IP_Reset       : std_logic;  -- [IN]
   SIGNAL IP2Bus_Data        : std_logic_vector(0 TO C_SIPIF_DWIDTH-1);  -- [OUT]
   SIGNAL IP2Bus_WrAck       : std_logic;  -- [OUT]
   SIGNAL IP2Bus_RdAck       : std_logic;  -- [OUT]
   SIGNAL IP2Bus_AddrAck     : std_logic;  -- [OUT]
   SIGNAL IP2Bus_Error       : std_logic;  -- [OUT]
   SIGNAL Bus2IP_Addr        : std_logic_vector(0 TO C_SPLB_AWIDTH-1);  -- [IN]
   SIGNAL Bus2IP_Data        : std_logic_vector(0 TO C_SIPIF_DWIDTH-1);  -- [IN]
   SIGNAL Bus2IP_RNW         : std_logic;  -- [IN]
   SIGNAL Bus2IP_BE          : std_logic_vector(0 TO C_SIPIF_DWIDTH/8-1);  -- [IN]
   SIGNAL Bus2IP_Burst       : std_logic;  -- [IN]
   SIGNAL Bus2IP_BurstLength : std_logic_vector(0 TO log2(16 * (C_SPLB_DWIDTH/8)));  -- [IN]
   SIGNAL Bus2IP_WrReq       : std_logic;  -- [IN]
   SIGNAL Bus2IP_RdReq       : std_logic;  -- [IN]
   SIGNAL Bus2IP_CS          : std_logic_vector(0 TO ((C_ARD_ADDR_RANGE_ARRAY'length)/2)-1);  -- [IN]
   SIGNAL Bus2IP_RdCE        : std_logic_vector(0 TO calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);  -- [IN]
   SIGNAL Bus2IP_WrCE        : std_logic_vector(0 TO calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);  -- [IN]
BEGIN


   x_plbv46_slave_burst : ENTITY plbv46_slave_burst_v1_01_a.plbv46_slave_burst
      GENERIC MAP (


         C_ARD_ADDR_RANGE_ARRAY => C_ARD_ADDR_RANGE_ARRAY,  -- [SLV64_ARRAY_TYPE] 

         C_ARD_NUM_CE_ARRAY => C_ARD_NUM_CE_ARRAY,  -- [INTEGER_ARRAY_TYPE]

         C_SPLB_P2P => C_SPLB_P2P,  -- [integer RANGE 0 TO 1]
         -- Optimize slave interface for a point to point connection

         C_CACHLINE_ADDR_MODE => C_CACHELINE_ADDR_MODE,  -- [integer range 0 to 1]
         -- Selects the addressing mode to use for Cacheline Read operations.

         C_WR_BUFFER_DEPTH => C_WR_BUFFER_DEPTH,  -- [integer RANGE 0 TO 16]
         -- The number of C_SIPIF_DWIDTH wide storage locations for the write buffer
         -- Valid depths are 16, and 32. Setting to 0 removes the
         -- buffer.

         C_SPLB_MID_WIDTH => C_SPLB_MID_WIDTH,  -- [integer RANGE 0 TO 4]
         -- The width of the Master ID bus
         -- This is set to log2(C_SPLB_NUM_MASTERS)

         C_SPLB_NUM_MASTERS => C_SPLB_NUM_MASTERS,  -- [integer RANGE 1 TO 16]
         -- The number of Master Devices connected to the PLB bus
         -- Research this to find out default value

         C_SPLB_SMALLEST_MASTER => C_SPLB_SMALLEST_MASTER,  -- [integer RANGE 32 TO 128]
         -- The dwidth (in bits) of the smallest master that will
         -- access this ipif.  

         C_SPLB_AWIDTH => C_SPLB_AWIDTH,  -- [integer RANGE 32 TO 36]
         --  width of the PLB Address Bus (in bits)

         C_SPLB_DWIDTH => C_SPLB_DWIDTH,  -- [integer RANGE 32 TO 128]
         --  Width of the PLB Data Bus (in bits)

         C_SIPIF_DWIDTH => C_SIPIF_DWIDTH,  -- [integer RANGE 32 TO 128]
         --  Width of IPIF Data Bus (in bits)

         C_FAMILY => C_FAMILY)  -- [string]
      PORT MAP (

         -- System signals ---------------------------------------------------------
         SPLB_Clk => SPLB_Clk,  -- [IN  std_logic]
         SPLB_Rst => SPLB_Rst,  -- [IN  std_logic]

         -- Bus Slave signals ------------------------------------------------------
         PLB_ABus       => PLB_ABus,    -- [IN  std_logic_vector(0 TO 31)]
         PLB_UABus      => PLB_UABus,   -- [IN  std_logic_vector(0 TO 31)]
         PLB_PAValid    => PLB_PAValid,   -- [IN  std_logic]
         PLB_SAValid    => PLB_SAValid,   -- [IN  std_logic]
         PLB_rdPrim     => PLB_rdPrim,  -- [IN  std_logic]
         PLB_wrPrim     => PLB_wrPrim,  -- [IN  std_logic]
         PLB_masterID   => PLB_masterID,  -- [IN  std_logic_vector(0 TO C_SPLB_MID_WIDTH-1)]
         PLB_abort      => PLB_abort,   -- [IN  std_logic]
         PLB_busLock    => PLB_busLock,   -- [IN  std_logic]
         PLB_RNW        => PLB_RNW,     -- [IN  std_logic]
         PLB_BE         => PLB_BE,  -- [IN  std_logic_vector(0 TO (C_SPLB_DWIDTH/8)-1)]
         PLB_MSize      => PLB_MSize,   -- [IN  std_logic_vector(0 TO 1)]
         PLB_size       => PLB_size,    -- [IN  std_logic_vector(0 TO 3)]
         PLB_type       => PLB_type,    -- [IN  std_logic_vector(0 TO 2)]
         PLB_lockErr    => PLB_lockErr,   -- [IN  std_logic]
         PLB_wrDBus     => PLB_wrDBus,  -- [IN  std_logic_vector(0 TO C_SPLB_DWIDTH-1)]
         PLB_wrBurst    => PLB_wrBurst,   -- [IN  std_logic]
         PLB_rdBurst    => PLB_rdBurst,   -- [IN  std_logic]
         PLB_wrPendReq  => PLB_wrPendReq,   -- [IN  std_logic]
         PLB_rdPendReq  => PLB_rdPendReq,   -- [IN  std_logic]
         PLB_wrPendPri  => PLB_wrPendPri,   -- [IN  std_logic_vector(0 TO 1)]
         PLB_rdPendPri  => PLB_rdPendPri,   -- [IN  std_logic_vector(0 TO 1)]
         PLB_reqPri     => PLB_reqPri,  -- [IN  std_logic_vector(0 TO 1)]
         PLB_TAttribute => PLB_TAttribute,  -- [IN  std_logic_vector(0 TO 15)]

         -- Slave Response Signals
         Sl_addrAck     => Sl_addrAck,      -- [OUT std_logic]
         Sl_SSize       => Sl_SSize,  -- [OUT std_logic_vector(0 TO 1)]
         Sl_wait        => Sl_wait,  -- [OUT std_logic]
         Sl_rearbitrate => Sl_rearbitrate,  -- [OUT std_logic]
         Sl_wrDAck      => Sl_wrDAck,  -- [OUT std_logic]
         Sl_wrComp      => Sl_wrComp,  -- [OUT std_logic]
         Sl_wrBTerm     => Sl_wrBTerm,      -- [OUT std_logic]
         Sl_rdDBus      => Sl_rdDBus,  -- [OUT std_logic_vector(0 TO C_SPLB_DWIDTH-1)]
         Sl_rdWdAddr    => Sl_rdWdAddr,     -- [OUT std_logic_vector(0 TO 3)]
         Sl_rdDAck      => Sl_rdDAck,  -- [OUT std_logic]
         Sl_rdComp      => Sl_rdComp,  -- [OUT std_logic]
         Sl_rdBTerm     => Sl_rdBTerm,      -- [OUT std_logic]
         Sl_MBusy       => Sl_MBusy,  -- [OUT std_logic_vector (0 TO C_SPLB_NUM_MASTERS-1)]
         Sl_MWrErr      => Sl_MWrErr,  -- [OUT std_logic_vector (0 TO C_SPLB_NUM_MASTERS-1)]
         Sl_MRdErr      => Sl_MRdErr,  -- [OUT std_logic_vector (0 TO C_SPLB_NUM_MASTERS-1)]
         Sl_MIRQ        => Sl_MIRQ,  -- [OUT std_logic_vector (0 TO C_SPLB_NUM_MASTERS-1)]

         -- IP Interconnect (IPIC) port signals -----------------------------------------
         Bus2IP_Clk         => Bus2IP_Clk,   -- [OUT std_logic]
         Bus2IP_Reset       => Bus2IP_Reset,  -- [OUT std_logic]
         IP2Bus_Data        => IP2Bus_Data,  -- [IN  std_logic_vector (0 TO C_SIPIF_DWIDTH-1)]
         IP2Bus_WrAck       => IP2Bus_WrAck,  -- [IN  std_logic]
         IP2Bus_RdAck       => IP2Bus_RdAck,  -- [IN  std_logic]
         IP2Bus_AddrAck     => IP2Bus_AddrAck,      -- [IN  std_logic]
         IP2Bus_Error       => IP2Bus_Error,  -- [IN  std_logic]
         Bus2IP_Addr        => Bus2IP_Addr,  -- [OUT std_logic_vector (0 TO C_SPLB_AWIDTH-1)]
         Bus2IP_Data        => Bus2IP_Data,  -- [OUT std_logic_vector (0 TO C_SIPIF_DWIDTH-1)]
         Bus2IP_RNW         => Bus2IP_RNW,   -- [OUT std_logic]
         Bus2IP_BE          => Bus2IP_BE,  -- [OUT std_logic_vector (0 TO (C_SIPIF_DWIDTH/8)-1)]
         Bus2IP_Burst       => Bus2IP_Burst,  -- [OUT std_logic]
         Bus2IP_BurstLength => Bus2IP_BurstLength,  -- [OUT std_logic_vector (0 TO log2(C_SPLB_DWIDTH))]
         Bus2IP_WrReq       => Bus2IP_WrReq,  -- [OUT std_logic]
         Bus2IP_RdReq       => Bus2IP_RdReq,  -- [OUT std_logic]
         Bus2IP_CS          => Bus2IP_CS,  -- [OUT std_logic_vector (0 TO ((C_ARD_ADDR_RANGE_ARRAY'length)/2)-1)]
         Bus2IP_RdCE        => Bus2IP_RdCE,  -- [OUT std_logic_vector (0 TO calc_num_ce(C_ARD_NUM_CE_ARRAY)-1)]
         Bus2IP_WrCE        => Bus2IP_WrCE);  -- [OUT std_logic_vector (0 TO calc_num_ce(C_ARD_NUM_CE_ARRAY)-1)]


   
   x_opb_master : ENTITY plbv46_opb_bridge_v1_01_a.opb_master
      GENERIC MAP (
         -- Base address and high address pairs.
         C_ARD_ADDR_RANGE_ARRAY => C_ARD_ADDR_RANGE_ARRAY,  -- [SLV64_ARRAY_TYPE] 

         -- This array spcifies the number of Chip Enables (CE) that is
         -- required by the coresponding baseaddr pair.
         C_ARD_NUM_CE_ARRAY => C_ARD_NUM_CE_ARRAY,  -- [INTEGER_ARRAY_TYPE]

         C_SPLB_AWIDTH => C_SPLB_AWIDTH,  -- [integer RANGE 32 TO 36]
         --  width of the PLB Address Bus (in bits)

         C_SIPIF_DWIDTH => C_SIPIF_DWIDTH,  -- [integer] IPIF/IPIC data width
         
         C_SPLB_DWIDTH => C_SPLB_DWIDTH,  -- [integer RANGE 32 TO 128]
         
         C_BUS_CLOCK_PERIOD_RATIO => C_BUS_CLOCK_PERIOD_RATIO,  -- [integer]
         
         C_FAMILY       => C_FAMILY)  -- [string] Select the target architecture type
      PORT MAP (

         -- IP Interconnect (IPIC) Interface from PLBv46 IPIF
         Bus2IP_Clk         => Bus2IP_Clk,   -- [IN  std_logic]
         Bus2IP_Reset       => Bus2IP_Reset,        -- [IN  std_logic]
         IP2Bus_Data        => IP2Bus_Data,  -- [OUT std_logic_vector(0 TO 32-1)]
         IP2Bus_WrAck       => IP2Bus_WrAck,        -- [OUT std_logic]
         IP2Bus_RdAck       => IP2Bus_RdAck,        -- [OUT std_logic]
         IP2Bus_AddrAck     => IP2Bus_AddrAck,      -- [OUT std_logic]
         IP2Bus_Error       => IP2Bus_Error,        -- [OUT std_logic]
         Bus2IP_Addr        => Bus2IP_Addr,  -- [IN  std_logic_vector(0 TO 32-1)]
         Bus2IP_Data        => Bus2IP_Data,  -- [IN  std_logic_vector(0 TO 32-1)]
         Bus2IP_RNW         => Bus2IP_RNW,   -- [IN  std_logic]
         Bus2IP_BE          => Bus2IP_BE,  -- [IN  std_logic_vector(0 TO 32/8-1)]
         Bus2IP_Burst       => Bus2IP_Burst,        -- [IN  std_logic]
         Bus2IP_BurstLength => Bus2IP_BurstLength,  -- [IN  std_logic_vector(0 TO log2(C_SIPIF_DWIDTH))]
         Bus2IP_WrReq       => Bus2IP_WrReq,        -- [IN  std_logic]
         Bus2IP_RdReq       => Bus2IP_RdReq,        -- [IN  std_logic]
         Bus2IP_CS          => Bus2IP_CS,  -- [IN  std_logic_vector(0 TO ((C_ARD_ADDR_RANGE_ARRAY'length)/2)-1)]
         Bus2IP_RdCE        => Bus2IP_RdCE,  -- [IN  std_logic_vector(0 TO calc_num_ce(C_ARD_NUM_CE_ARRAY)-1)]
         Bus2IP_WrCE        => Bus2IP_WrCE,  -- [IN  std_logic_vector(0 TO calc_num_ce(C_ARD_NUM_CE_ARRAY)-1)]

         -- OPB Bus Master Interface
         OPB_Clk     => OPB_Clk,      -- [IN  std_logic]
         OPB_Rst     => OPB_Rst,      -- [IN  std_logic]
         Mn_request  => Mn_request,   -- [OUT std_logic]
         Mn_busLock  => Mn_busLock,   -- [OUT std_logic]
         Mn_select   => Mn_select,    -- [OUT std_logic]
         Mn_RNW      => Mn_RNW,       -- [OUT std_logic]
         Mn_BE       => Mn_BE,        -- [OUT std_logic_vector(0 TO 32/8-1)]
         Mn_seqAddr  => Mn_seqAddr,   -- [OUT std_logic]
         Mn_DBus     => Mn_DBus,      -- [OUT std_logic_vector(0 TO 32-1)]
         Mn_ABus     => Mn_ABus,      -- [OUT std_logic_vector(0 TO 31)]
         OPB_MGrant  => OPB_MGrant,   -- [IN  std_logic := '0']
         OPB_xferAck => OPB_xferAck,  -- [IN  std_logic := '0']
         OPB_errAck  => OPB_errAck,   -- [IN  std_logic := '0']
         OPB_retry   => OPB_retry,    -- [IN  std_logic := '0']
         OPB_timeout => OPB_timeout,  -- [IN  std_logic := '0']
         OPB_DBus    => OPB_DBus);    -- [IN std_logic_vector(0 TO 32 - 1)]

END ARCHITECTURE syn;  -- (architecture)
