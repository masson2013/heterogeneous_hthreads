-------------------------------------------------------------------------------
-- $Id: opb_plbv46_bridge.vhd,v 1.1.2.1 2008/12/17 19:04:49 mlovejoy Exp $
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
-- Filename:        opb_plbv46_bridge.vhd
--
-- Description:     This bridge accepts OPB master transactions directed at any
--                  one of up-to four address ranges and bridges them to the
--                  PLBV46 bus. Write transactions are accepted immediately and
--                  posted to an internal write buffer. The write data is
--                  transported to the PLBV46 bus as soon as it is ready. Read
--                  requests are satisfied through a prefetch mechanism. Once
--                  the read prefetch has completed on the PLBV46 bus and data
--                  from the read has been buffered internal to the bridge an
--                  OPB request that matches the address of the original
--                  prefetch can claim the buffer contents.
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
USE proc_common_v3_00_a.proc_common_pkg.ALL;  -- need log2()
USE proc_common_v3_00_a.family.ALL;           -- need C_FAMILY definitions

LIBRARY opb_plbv46_bridge_v1_01_a;
LIBRARY plbv46_master_burst_v1_01_a;

-------------------------------------------------------------------------------

ENTITY opb_plbv46_bridge IS
   
   GENERIC (
      -- OPB Address range definition
      C_NUM_ADDR_RNG  : integer RANGE 1 TO 4      := 1;  -- Number of Address Ranges   
      C_RNG0_BASEADDR : std_logic_vector(0 TO 31) := X"FFFFFFFF";  -- Address range definition base address  
      C_RNG0_HIGHADDR : std_logic_vector(0 TO 31) := X"00000000";  -- Address range definition high address  
      C_RNG1_BASEADDR : std_logic_vector(0 TO 31) := X"FFFFFFFF";  -- Address range definition base address  
      C_RNG1_HIGHADDR : std_logic_vector(0 TO 31) := X"00000000";  -- Address range definition high address  
      C_RNG2_BASEADDR : std_logic_vector(0 TO 31) := X"FFFFFFFF";  -- Address range definition base address  
      C_RNG2_HIGHADDR : std_logic_vector(0 TO 31) := X"00000000";  -- Address range definition high address  
      C_RNG3_BASEADDR : std_logic_vector(0 TO 31) := X"FFFFFFFF";  -- Address range definition base address  
      C_RNG3_HIGHADDR : std_logic_vector(0 TO 31) := X"00000000";  -- Address range definition high address

      -- BRIDGE CONFIGURATION          
      C_BUS_CLOCK_PERIOD_RATIO : integer RANGE 1 TO 2  := 1;
      C_PREFETCH_TIMEOUT       : integer RANGE 1 TO 32 := 10;  -- prefetch timeout counter size (bits)

      -- PLB I/O Specification            
      C_MPLB_AWIDTH        : integer RANGE 32 TO 64  := 32;  -- Used Address bits out of the available 64 bits of PLBV46 addressing 
      C_MPLB_DWIDTH        : integer RANGE 32 TO 128 := 32;  --Width of the PLB Data Bus to which the Master is attached  
      C_MPLB_NATIVE_DWIDTH : integer RANGE 32 TO 128 := 32;  --Specifies the internal native data width of the Master   
      C_FAMILY             : string                  := "virtex4"  -- Xilinx FPGA Family  Type spartan3, virtex4,virtex5   
      );

   PORT (

      -------------------------------------------------------------------------
      -- PLBV46 Bus Master Interface
      -------------------------------------------------------------------------
      -- System Ports
      MPLB_Clk : IN  std_logic;
      MPLB_Rst : IN  std_logic;
      MD_Error : OUT std_logic;

      -- Master Request/Qualifiers to PLB V4.6 (outputs)
      M_request  : OUT std_logic;
      M_priority : OUT std_logic_vector(0 TO 1);
      M_busLock  : OUT std_logic;
      M_RNW      : OUT std_logic;
      M_BE       : OUT std_logic_vector(0 TO (C_MPLB_DWIDTH/8) - 1);
      M_MSize    : OUT std_logic_vector(0 TO 1);
      M_size     : OUT std_logic_vector(0 TO 3);
      M_type     : OUT std_logic_vector(0 TO 2);
      M_ABus     : OUT std_logic_vector(0 TO 31);
      M_wrBurst  : OUT std_logic;
      M_rdBurst  : OUT std_logic;
      M_wrDBus   : OUT std_logic_vector(0 TO C_MPLB_DWIDTH-1);

      -- PLB Reply to Master (inputs)
      PLB_MAddrAck     : IN std_logic;
      PLB_MSSize       : IN std_logic_vector(0 TO 1);
      PLB_MRearbitrate : IN std_logic;
      PLB_MTimeout     : IN std_logic;
      PLB_MRdErr       : IN std_logic;
      PLB_MWrErr       : IN std_logic;
      PLB_MRdDBus      : IN std_logic_vector(0 TO C_MPLB_DWIDTH-1);
      PLB_MRdDAck      : IN std_logic;
      PLB_MRdBTerm     : IN std_logic;
      PLB_MWrDAck      : IN std_logic;
      PLB_MWrBTerm     : IN std_logic;

      -- Included PLB ports but unused in the design
      M_TAttribute  : OUT std_logic_vector(0 TO 15);
      M_lockErr     : OUT std_logic;
      M_abort       : OUT std_logic;
      M_UABus       : OUT std_logic_vector(0 TO 31);
      PLB_MBusy     : IN  std_logic;
      PLB_MIRQ      : IN  std_logic;
      PLB_MRdWdAddr : IN  std_logic_vector(0 TO 3);

      --------------------------------------------------------------------------
      -- OPB Bus Slave Interface
      --------------------------------------------------------------------------
      -- System Interface
      SOPB_rst : IN std_logic;  -- opb reset
      SOPB_clk : IN std_logic;  -- opb clock

      -- Slave ports
      OPB_Select  : IN  std_logic;  -- OPB select
      OPB_RNW     : IN  std_logic;  -- OPB Read not Write
      OPB_BE      : IN  std_logic_vector(0 TO (32/8)-1);  -- OPB transaction byte enables
      OPB_seqAddr : IN  std_logic;  -- OPB sequential address
      OPB_DBus    : IN  std_logic_vector(0 TO 32-1);  -- OPB master data bus
      OPB_ABus    : IN  std_logic_vector(0 TO 32-1);  -- OPB Slave address bus
      Sl_xferAck  : OUT std_logic;  -- OPB Slave transfer acknowledgement
      Sl_errAck   : OUT std_logic;  -- OPB Slave transaction error acknowledgement
      Sl_retry    : OUT std_logic;  -- OPB Slave transaction retry
      Sl_ToutSup  : OUT std_logic;  -- OPB Slave timeout suppress
      Sl_DBus     : OUT std_logic_vector(0 TO 32-1)   -- OPB Slave data BUS
      );



   -- Platform Specification Attributes
   
   ATTRIBUTE IMP_NETLIST                      : string;
   ATTRIBUTE IMP_NETLIST OF opb_plbv46_bridge : ENTITY IS "TRUE";

   ATTRIBUTE IPTYPE                      : string;
   ATTRIBUTE IPTYPE OF opb_plbv46_bridge : ENTITY IS "BRIDGE";

   ATTRIBUTE STYLE                      : string;
   ATTRIBUTE STYLE OF opb_plbv46_bridge : ENTITY IS "HDL";

   ATTRIBUTE HDL                      : string;
   ATTRIBUTE HDL OF opb_plbv46_bridge : ENTITY IS "VHDL";

--   ATTRIBUTE BUSIF : string;
--   ATTRIBUTE BUSIF OF C_RNG0_BASEADDR : CONSTANT IS "SOPB";
--   ATTRIBUTE BUSIF OF C_RNG0_HIGHADDR : CONSTANT IS "SOPB";
--   ATTRIBUTE BUSIF OF C_RNG1_BASEADDR : CONSTANT IS "SOPB";
--   ATTRIBUTE BUSIF OF C_RNG1_HIGHADDR : CONSTANT IS "SOPB";
--   ATTRIBUTE BUSIF OF C_RNG2_BASEADDR : CONSTANT IS "SOPB";
--   ATTRIBUTE BUSIF OF C_RNG2_HIGHADDR : CONSTANT IS "SOPB";
--   ATTRIBUTE BUSIF OF C_RNG3_BASEADDR : CONSTANT IS "SOPB";
--   ATTRIBUTE BUSIF OF C_RNG3_HIGHADDR : CONSTANT IS "SOPB";

   ATTRIBUTE SIGIS             : string;
   ATTRIBUTE SIGIS OF SOPB_rst : SIGNAL IS "RST";
   ATTRIBUTE SIGIS OF SOPB_clk : SIGNAL IS "CLK";
   ATTRIBUTE SIGIS OF MPLB_rst : SIGNAL IS "RST";
   ATTRIBUTE SIGIS OF MPLB_clk : SIGNAL IS "CLK";
   
END ENTITY opb_plbv46_bridge;

ARCHITECTURE syn OF opb_plbv46_bridge IS
   CONSTANT C_MPLB_SMALLEST_SLAVE      : integer RANGE 32 TO 128 := 32;
   CONSTANT C_INHIBIT_CC_BLE_INCLUSION : integer RANGE 0 TO 1    := 0;

   -- IP Master Request/Qualifiers
   SIGNAL IP2Bus_MstRd_Req : std_logic;                         -- [In]
   SIGNAL IP2Bus_MstWr_Req : std_logic;                         -- [In]
   SIGNAL IP2Bus_Mst_Addr : std_logic_vector(0 TO
                                             C_MPLB_AWIDTH-1);  -- [in]
   SIGNAL IP2Bus_Mst_Length : std_logic_vector(0 TO 11);        -- [in]
   SIGNAL IP2Bus_Mst_BE : std_logic_vector(0 TO
                                           (C_MPLB_NATIVE_DWIDTH/8) -1);  -- [in]
   SIGNAL IP2Bus_Mst_Type  : std_logic;                         -- [in]
   SIGNAL IP2Bus_Mst_Lock  : std_logic;                         -- [In]
   SIGNAL IP2Bus_Mst_Reset : std_logic;                         -- [In]

   -- IP Master Primary Read Request Status Reply
   SIGNAL Bus2IP_Mst_CmdAck      : std_logic;  -- [Out]
   SIGNAL Bus2IP_Mst_Cmplt       : std_logic;  -- [Out]
   SIGNAL Bus2IP_Mst_Error       : std_logic;  -- [Out]
   SIGNAL Bus2IP_Mst_Rearbitrate : std_logic;  -- [Out]
   SIGNAL Bus2IP_Mst_Cmd_Timeout : std_logic;  -- [out]

   -- IP Master Primary Read LocalLink Interface
   SIGNAL Bus2IP_MstRd_d : std_logic_vector(0 TO
                                            C_MPLB_NATIVE_DWIDTH-1);  -- [out]
   SIGNAL Bus2IP_MstRd_rem : std_logic_vector(0 TO
                                              (C_MPLB_NATIVE_DWIDTH/8)-1);  -- [out]
   SIGNAL Bus2IP_MstRd_sof_n     : std_logic;                         -- [Out]
   SIGNAL Bus2IP_MstRd_eof_n     : std_logic;                         -- [Out]
   SIGNAL Bus2IP_MstRd_src_rdy_n : std_logic;                         -- [Out]
   SIGNAL Bus2IP_MstRd_src_dsc_n : std_logic;                         -- [Out]

   SIGNAL IP2Bus_MstRd_dst_rdy_n : std_logic;  -- [In]
   SIGNAL IP2Bus_MstRd_dst_dsc_n : std_logic;  -- [In]




   -- IP Master Primary Write LocalLink Interface
   SIGNAL IP2Bus_MstWr_d : std_logic_vector(0 TO
                                            C_MPLB_NATIVE_DWIDTH-1);  -- [In]
   SIGNAL IP2Bus_MstWr_rem : std_logic_vector(0 TO
                                              (C_MPLB_NATIVE_DWIDTH/8)-1) :=  (OTHERS => '1');  -- [In]
   SIGNAL IP2Bus_MstWr_sof_n     : std_logic;                         -- [In]
   SIGNAL IP2Bus_MstWr_eof_n     : std_logic;                         -- [In]
   SIGNAL IP2Bus_MstWr_src_rdy_n : std_logic;                         -- [In]
   SIGNAL IP2Bus_MstWr_src_dsc_n : std_logic;                         -- [In]

   SIGNAL Bus2IP_MstWr_dst_rdy_n : std_logic;  -- [Out]
   SIGNAL Bus2IP_MstWr_dst_dsc_n : std_logic;  -- [Out]



   -- OPB slave to Bridge Interface 
   SIGNAL brdg_block           : std_logic;  -- [IN]  bridge block
   SIGNAL brdg_prefetch_cmplt  : std_logic;  -- [IN]  bridge prefetch complete
   SIGNAL brdg_prefetch_status : std_logic;  -- [IN] bridge prefetch status
   SIGNAL brdg_prefetch_addr   : std_logic_vector(0 TO 31);  -- [IN]  bridge prefetch address
   SIGNAL opbs_prefetch_req    : std_logic;  -- [OUT] opb slave prefetch request
   SIGNAL opbs_type            : std_logic;  -- [OUT] opb slave transaction request type
   SIGNAL opbs_prefetch_clr    : std_logic;  -- [OUT] opb slave prefetch clear
   SIGNAL opbs_postedwr_clr    : std_logic;  -- [OUT] opb slave posted write clear
   SIGNAL opbs_trans_addr      : std_logic_vector(0 TO 31);  -- [OUT] opb slave transaction address
   SIGNAL opbs_length          : std_logic_vector(0 TO 11);  -- [OUT] opb slave transaction length
   SIGNAL opbs_postedwrt_req   : std_logic;  -- [OUT] opb slave posted write request
   SIGNAL opbs_be              : std_logic_vector(0 TO 3);  -- [OUT] opb slave byte enable

   -- Local Link Read Buffer
   SIGNAL bfs_data       : std_logic_vector(0 TO 31);  -- [IN]  Read data output to user logic
   SIGNAL bfs_sof_n      : std_logic;  -- [IN]  Active low signal indicating the starting data beat of a read local link transfer (unused by slave)
   SIGNAL bfs_eof_n      : std_logic;  -- [IN]  Active low signal indicating the ending data beat of a Read local link transfer. (Unused by slave)
   SIGNAL bfs_src_rdy_n  : std_logic;  -- [IN]  Asserts active low to indicate the presence of valid data on signal bfs_data.
   SIGNAL bfs_src_dsc_n  : std_logic;  -- [IN]  Active low signal indicating that the read local link source (master) needs to discontinue the transfer. (Unused. Drive high)
   SIGNAL bfs_dst_rdy_n  : std_logic;  -- [OUT] Destination (ie the slave) asserts active low to signal it is ready to take valid data on bfs_data.
   SIGNAL bfs_dst_dsc_n  : std_logic;  -- [OUT] Active low signal that the read local link destination needs to discontinue the transfer.
   SIGNAL brdg_rd_bf_rst : std_logic;  -- [IN]

   -- Local Link Write Buffer
   SIGNAL bfd_data       : std_logic_vector(0 TO 31);  -- [OUT]
   SIGNAL bfd_sof_n      : std_logic;                  -- [OUT]
   SIGNAL bfd_eof_n      : std_logic;                  -- [OUT]
   SIGNAL bfd_src_rdy_n  : std_logic;                  -- [OUT]
   SIGNAL bfd_src_dsc_n  : std_logic;                  -- [OUT]
   SIGNAL bfd_dst_rdy_n  : std_logic;                  -- [IN]
   SIGNAL bfd_dst_dsc_n  : std_logic;                  -- [IN]
   SIGNAL brdg_wr_bf_rst : std_logic;                  -- [IN]


BEGIN

   x_plbv46_master_burst : ENTITY plbv46_master_burst_v1_01_a.plbv46_master_burst
      GENERIC MAP (

         -- PLB Parameters 

         C_MPLB_AWIDTH => C_MPLB_AWIDTH,  -- [INTEGER range 32 to 36]
         -- Number of PLBV46 Address Bus bits actually used.

         C_MPLB_DWIDTH => C_MPLB_DWIDTH,  -- [INTEGER range 32 to 128]
         --  Width of the PLBV46 Data Bus Attachment (in bits)

         C_MPLB_NATIVE_DWIDTH => C_MPLB_NATIVE_DWIDTH,  -- [INTEGER range 32 to 32]
         --  Set this equal to largest data bus width needed by IPIF
         --  and IP elements.

         C_MPLB_SMALLEST_SLAVE => C_MPLB_SMALLEST_SLAVE,
         -- Indicates the Native Data Width of the smallest slave
         -- on the PLB connected to this Master. If this parameter's
         -- value is less than the native Data width of the Master,
         -- then the Conversion Cycle and Burst Length Expansion
         -- Adapter will be included in the Master's implementation.

         C_INHIBIT_CC_BLE_INCLUSION => C_INHIBIT_CC_BLE_INCLUSION,
         -- This parameter will inhibit the automatic inclusion
         -- of the Conversion Cycle and Burst length Expansion
         -- Adapter. This override is useful if the connected PLB has
         -- narrow Slaves attached to it but this Master will not access
         -- those narrow Slaves.

         -- FPGA Family Parameter      
         C_FAMILY => C_FAMILY)  -- [String]
      PORT MAP (

         -- System Ports
         MPLB_Clk => MPLB_Clk,  -- [In  std_logic]
         MPLB_Rst => MPLB_Rst,  -- [In  std_logic]
         MD_Error => MD_Error,  -- [Out std_logic]

         -- Master Request/Qualifiers to PLB V4.6 (outputs)
         M_request  => M_request,   -- [out std_logic]
         M_priority => M_priority,  -- [out std_logic_vector(0 to 1)]
         M_busLock  => M_busLock,   -- [out std_logic]
         M_RNW      => M_RNW,     -- [out std_logic]
         M_BE       => M_BE,  -- [out std_logic_vector(0 to (C_MPLB_DWIDTH/8) - 1)]
         M_MSize    => M_MSize,   -- [out std_logic_vector(0 to 1)]
         M_size     => M_size,    -- [out std_logic_vector(0 to 3)]
         M_type     => M_type,    -- [out std_logic_vector(0 to 2)]
         M_ABus     => M_ABus,    -- [out std_logic_vector(0 to 31)]
         M_wrBurst  => M_wrBurst,   -- [out std_logic]
         M_rdBurst  => M_rdBurst,   -- [out std_logic]
         M_wrDBus   => M_wrDBus,  -- [out std_logic_vector(0 to C_MPLB_DWIDTH-1)]

         -- PLB Reply to Master (inputs)
         PLB_MAddrAck     => PLB_MAddrAck,      -- [in  std_logic]
         PLB_MSSize       => PLB_MSSize,   -- [in  std_logic_vector(0 to 1)]
         PLB_MRearbitrate => PLB_MRearbitrate,  -- [in  std_logic]
         PLB_MTimeout     => PLB_MTimeout,      -- [in  std_logic]
         PLB_MRdErr       => PLB_MRdErr,   -- [in  std_logic]
         PLB_MWrErr       => PLB_MWrErr,   -- [in  std_logic]
         PLB_MRdDBus      => PLB_MRdDBus,  -- [in  std_logic_vector(0 to C_MPLB_DWIDTH-1)]
         PLB_MRdDAck      => PLB_MRdDAck,  -- [in  std_logic]
         PLB_MRdBTerm     => PLB_MRdBTerm,      -- [in  std_logic]
         PLB_MWrDAck      => PLB_MWrDAck,  -- [in  std_logic]
         PLB_MWrBTerm     => PLB_MWrBTerm,      -- [in  std_logic]

         -- Included PLB ports but unused in the design
         M_TAttribute  => M_TAttribute,   -- [out std_logic_vector(0 to 15)]
         M_lockErr     => M_lockErr,      -- [out std_logic]
         M_abort       => M_abort,        -- [out std_logic]
         M_UABus       => M_UABus,        -- [out std_logic_vector(0 to 31)]
         PLB_MBusy     => PLB_MBusy,      -- [in  std_logic]
         PLB_MIRQ      => PLB_MIRQ,       -- [in  std_logic]
         PLB_MRdWdAddr => PLB_MRdWdAddr,  -- [in  std_logic_vector(0 to 3)]

         -- IP Master Request/Qualifiers
         IP2Bus_MstRd_Req  => IP2Bus_MstRd_Req,   -- [In  std_logic]
         IP2Bus_MstWr_Req  => IP2Bus_MstWr_Req,   -- [In  std_logic]
         IP2Bus_Mst_Addr   => IP2Bus_Mst_Addr,  -- [in  std_logic_vector(0 toC_MPLB_AWIDTH-1)]
         IP2Bus_Mst_Length => IP2Bus_Mst_Length,  -- [in  std_logic_vector(0 to 11)]
         IP2Bus_Mst_BE     => IP2Bus_Mst_BE,  -- [in  std_logic_vector(0 to(C_MPLB_NATIVE_DWIDTH/8) -1)]
         IP2Bus_Mst_Type   => IP2Bus_Mst_Type,  -- [in  std_logic]
         IP2Bus_Mst_Lock   => IP2Bus_Mst_Lock,  -- [In  std_logic]
         IP2Bus_Mst_Reset  => IP2Bus_Mst_Reset,   -- [In  std_logic]

         -- IP Master Primary Read Request Status Reply
         Bus2IP_Mst_CmdAck      => Bus2IP_Mst_CmdAck,       -- [Out std_logic]
         Bus2IP_Mst_Cmplt       => Bus2IP_Mst_Cmplt,        -- [Out std_logic]
         Bus2IP_Mst_Error       => Bus2IP_Mst_Error,        -- [Out std_logic]
         Bus2IP_Mst_Rearbitrate => Bus2IP_Mst_Rearbitrate,  -- [Out std_logic]
         Bus2IP_Mst_Cmd_Timeout => Bus2IP_Mst_Cmd_Timeout,  -- [out std_logic]

         -- IP Master Primary Read LocalLink Interface
         Bus2IP_MstRd_d         => Bus2IP_MstRd_d,  -- [out std_logic_vector(0 to C_MPLB_NATIVE_DWIDTH-1)]
         Bus2IP_MstRd_rem       => OPEN,  -- [out std_logic_vector(0 to (C_MPLB_NATIVE_DWIDTH/8)-1)]
         Bus2IP_MstRd_sof_n     => Bus2IP_MstRd_sof_n,      -- [Out std_logic]
         Bus2IP_MstRd_eof_n     => Bus2IP_MstRd_eof_n,      -- [Out std_logic]
         Bus2IP_MstRd_src_rdy_n => Bus2IP_MstRd_src_rdy_n,  -- [Out std_logic]
         Bus2IP_MstRd_src_dsc_n => Bus2IP_MstRd_src_dsc_n,  -- [Out std_logic]

         IP2Bus_MstRd_dst_rdy_n => IP2Bus_MstRd_dst_rdy_n,  -- [In  std_logic]
         IP2Bus_MstRd_dst_dsc_n => IP2Bus_MstRd_dst_dsc_n,  -- [In  std_logic]

         -- IP Master Primary Write LocalLink Interface
         IP2Bus_MstWr_d         => IP2Bus_MstWr_d,  -- [In  std_logic_vector(0 to C_MPLB_NATIVE_DWIDTH-1)]
         IP2Bus_MstWr_rem       => IP2Bus_MstWr_rem,  -- [In  std_logic_vector(0 to (C_MPLB_NATIVE_DWIDTH/8)-1)]
         IP2Bus_MstWr_sof_n     => IP2Bus_MstWr_sof_n,      -- [In  std_logic]
         IP2Bus_MstWr_eof_n     => IP2Bus_MstWr_eof_n,      -- [In  std_logic]
         IP2Bus_MstWr_src_rdy_n => IP2Bus_MstWr_src_rdy_n,  -- [In  std_logic]
         IP2Bus_MstWr_src_dsc_n => IP2Bus_MstWr_src_dsc_n,  -- [In  std_logic]

         Bus2IP_MstWr_dst_rdy_n => Bus2IP_MstWr_dst_rdy_n,   -- [Out std_logic]
         Bus2IP_MstWr_dst_dsc_n => Bus2IP_MstWr_dst_dsc_n);  -- [Out std_logic]



   x_rd_buffer : ENTITY opb_plbv46_bridge_v1_01_a.buffer_x16
      GENERIC MAP (
         C_FAMILY => C_FAMILY)  -- [string] Xilinx FPGA Family Type spartan3, virtex4, virtex5
      PORT MAP (

         -- Source Interface (from the OPB slave)
         bfs_data      => bfs_data,  -- [OUT std_logic_vector(0 TO 31)] Read data output to user logic
         bfs_sof_n     => bfs_sof_n,  -- [OUT std_logic] Active low signal indicating the starting data beat of a read local link transfer (unused by slave)
         bfs_eof_n     => bfs_eof_n,  -- [OUT std_logic] Active low signal indicating the ending data beat of a Read local link transfer. (Unused by slave)
         bfs_src_rdy_n => bfs_src_rdy_n,  -- [OUT std_logic] Asserts active low to indicate the presence of valid data on signal bfs_data.
         bfs_src_dsc_n => bfs_src_dsc_n,  -- [OUT std_logic] Active low signal indicating that the read local link source (master) needs to discontinue the transfer. (Unused. Drive high)
         bfs_dst_rdy_n => bfs_dst_rdy_n,  -- [IN  std_logic] Destination (ie the slave) asserts active low to signal it is ready to take valid data on bfs_data.
         bfs_dst_dsc_n => bfs_dst_dsc_n,  -- [IN  std_logic] Active low signal that the read local link destination needs to discontinue the transfer.

         -- Destination (Sink) Interface (to the plbv46_master_burst)
         bfd_data      => Bus2IP_MstRd_d,  -- [IN  std_logic_vector(0 TO 31)]
         bfd_sof_n     => Bus2IP_MstRd_sof_n,      -- [IN  std_logic]
         bfd_eof_n     => Bus2IP_MstRd_eof_n,      -- [IN  std_logic]
         bfd_src_rdy_n => Bus2IP_MstRd_src_rdy_n,  -- [IN  std_logic]
         bfd_src_dsc_n => Bus2IP_MstRd_src_dsc_n,  -- [IN  std_logic]
         bfd_dst_rdy_n => IP2Bus_MstRd_dst_rdy_n,  -- [OUT std_logic]
         bfd_dst_dsc_n => IP2Bus_MstRd_dst_dsc_n,  -- [OUT std_logic]

         -- System Interface
         rst => brdg_rd_bf_rst,  -- [IN  std_logic] reset
         clk => MPLB_clk);       -- [IN std_logic] clock



   x_wr_buffer : ENTITY opb_plbv46_bridge_v1_01_a.buffer_x16
      GENERIC MAP (
         C_FAMILY => C_FAMILY)  -- [string] Xilinx FPGA Family Type spartan3, virtex4, virtex5
      PORT MAP (

         -- Source Interface (from the plbv46_master_burst)
         bfs_data      => IP2Bus_MstWr_d,  -- [OUT std_logic_vector(0 TO 31)] Read data output to user logic
         bfs_sof_n     => IP2Bus_MstWr_sof_n,  -- [OUT std_logic] Active low signal indicating the starting data beat of a read local link transfer (unused by slave)
         bfs_eof_n     => IP2Bus_MstWr_eof_n,  -- [OUT std_logic] Active low signal indicating the ending data beat of a Read local link transfer. (Unused by slave)
         bfs_src_rdy_n => IP2Bus_MstWr_src_rdy_n,  -- [OUT std_logic] Asserts active low to indicate the presence of valid data on signal bfs_data.
         bfs_src_dsc_n => IP2Bus_MstWr_src_dsc_n,  -- [OUT std_logic] Active low signal indicating that the read local link source (master) needs to discontinue the transfer. (Unused. Drive high)
         bfs_dst_rdy_n => Bus2IP_MstWr_dst_rdy_n,  -- [IN  std_logic] Destination (ie the slave) asserts active low to signal it is ready to take valid data on bfs_data.
         bfs_dst_dsc_n => Bus2IP_MstWr_dst_dsc_n,  -- [IN  std_logic] Active low signal that the read local link destination needs to discontinue the transfer.

         -- Destination (Sink) Interface (to the opb_slave)
         bfd_data      => bfd_data,       -- [IN  std_logic_vector(0 TO 31)]
         bfd_sof_n     => bfd_sof_n,      -- [IN  std_logic]
         bfd_eof_n     => bfd_eof_n,      -- [IN  std_logic]
         bfd_src_rdy_n => bfd_src_rdy_n,  -- [IN  std_logic]
         bfd_src_dsc_n => bfd_src_dsc_n,  -- [IN  std_logic]
         bfd_dst_rdy_n => bfd_dst_rdy_n,  -- [OUT std_logic]
         bfd_dst_dsc_n => bfd_dst_dsc_n,  -- [OUT std_logic]

         -- System Interface
         rst => brdg_wr_bf_rst,  -- [IN  std_logic] reset
         clk => MPLB_clk);       -- [IN std_logic] clock


   
   x_bridge : ENTITY opb_plbv46_bridge_v1_01_a.bridge
      GENERIC MAP (
         -- BRIDGE CONFIGURATION          
         C_PREFETCH_TIMEOUT => C_PREFETCH_TIMEOUT,  --

         -- System wide Specification            
         C_FAMILY => C_FAMILY)  -- [string] Xilinx FPGA Family Type spartan3, virtex4, virtex5
      PORT MAP (
         -- PLBV46 Master Burst Interface
         IP2Bus_MstRd_Req       => IP2Bus_MstRd_Req,  -- [OUT std_logic] User Logic Read Request
         IP2Bus_MstWr_Req       => IP2Bus_MstWr_Req,  -- [OUT std_logic] User Logic Write Request
         IP2Bus_Mst_Addr        => IP2Bus_Mst_Addr,  -- [OUT std_logic_vector(0 TO 32-1)] User Logic Request Address
         IP2Bus_Mst_BE          => IP2Bus_Mst_BE,  -- [OUT std_logic_vector(0 TO (32/8)-1)] User Logic Request Byte Enables (only used during single data beat requests)
         IP2Bus_Mst_Length      => IP2Bus_Mst_Length,  -- [OUT std_logic_vector(0 TO 11)]
         IP2Bus_Mst_Type        => IP2Bus_Mst_Type,  -- [OUT std_logic] User Logic Request Type Indicator
         IP2Bus_Mst_Lock        => IP2Bus_Mst_Lock,  -- [OUT std_logic] User Logic Bus Lock Request
         IP2Bus_Mst_Reset       => IP2Bus_Mst_Reset,  -- [OUT std_logic] Optional User Logic Reset Request.
         Bus2IP_Mst_CmdAck      => Bus2IP_Mst_CmdAck,  -- [IN  std_logic] Command Acknowledge Status
         Bus2IP_Mst_Cmplt       => Bus2IP_Mst_Cmplt,  -- [IN  std_logic] Command Complete Status
         Bus2IP_Mst_Error       => Bus2IP_Mst_Error,  -- [IN  std_logic] Command Error Status
         Bus2IP_Mst_Rearbitrate => Bus2IP_Mst_Rearbitrate,  -- [IN  std_logic] Command Rearbitrate Status
         Bus2IP_Mst_Cmd_Timeout => Bus2IP_Mst_Cmd_Timeout,  -- [IN  std_logic] Command Timeout Status

         -- opb_slave Interface
         opbs_prefetch_req    => opbs_prefetch_req,  -- [IN  std_logic] opb slave prefetch request
         opbs_type            => opbs_type,  -- [IN std_logic] opb slave transaction request type
         opbs_prefetch_clr    => opbs_prefetch_clr,  -- [IN  std_logic] opb slave prefetch clear
         opbs_postedwr_clr    => opbs_postedwr_clr,  -- [IN  std_logic] opb slave posted write clear
         opbs_length          => opbs_length,  -- [IN  std_logic_vector(0 TO 11)] opb slave transaction length
         opbs_postedwrt_req   => opbs_postedwrt_req,  -- [IN  std_logic] opb slave posted write request
         opbs_trans_addr      => opbs_trans_addr,  -- [IN  std_logic_vector(0 TO 31)] opb slave transaction address
         opbs_be              => opbs_be,  -- [IN  std_logic_vector(0 TO 3)] opb slave byte enable
         brdg_block           => brdg_block,   -- [OUT std_logic] bridge block
         brdg_prefetch_cmplt  => brdg_prefetch_cmplt,  -- [OUT std_logic] bridge prefetch complete
         brdg_prefetch_status => brdg_prefetch_status,  -- [OUT std_logic] bridge prefetch status

         -- Buffer Interface
         brdg_wr_bf_rst => brdg_wr_bf_rst,  -- [OUT std_logic] bridge write buffer reset
         brdg_rd_bf_rst => brdg_rd_bf_rst,  -- [OUT std_logic] bridge read buffer reset

         -- System
         MPLB_rst => MPLB_rst,   -- [IN  std_logic] plb reset
         MPLB_clk => MPLB_clk);  -- [IN  std_logic] plb clock


   
   x_opb_slave : ENTITY opb_plbv46_bridge_v1_01_a.opb_slave
      GENERIC MAP (
         -- OPB Address range definition
         C_NUM_ADDR_RNG  => C_NUM_ADDR_RNG,  -- [integer RANGE 1 TO 4] Number of Address Ranges
         C_RNG0_BASEADDR => C_RNG0_BASEADDR,  -- [std_logic_vector(0 TO 31)] Address range definition base address
         C_RNG0_HIGHADDR => C_RNG0_HIGHADDR,  -- [std_logic_vector(0 TO 31)] Address range definition high address
         C_RNG1_BASEADDR => C_RNG1_BASEADDR,  -- [std_logic_vector(0 TO 31)] Address range definition base address
         C_RNG1_HIGHADDR => C_RNG1_HIGHADDR,  -- [std_logic_vector(0 TO 31)] Address range definition high address
         C_RNG2_BASEADDR => C_RNG2_BASEADDR,  -- [std_logic_vector(0 TO 31)] Address range definition base address
         C_RNG2_HIGHADDR => C_RNG2_HIGHADDR,  -- [std_logic_vector(0 TO 31)] Address range definition high address
         C_RNG3_BASEADDR => C_RNG3_BASEADDR,  -- [std_logic_vector(0 TO 31)] Address range definition base address
         C_RNG3_HIGHADDR => C_RNG3_HIGHADDR,  -- [std_logic_vector(0 TO 31)] Address range definition high address

         -- BRIDGE CONFIGURATION          
         C_BUS_CLOCK_PERIOD_RATIO => C_BUS_CLOCK_PERIOD_RATIO,  -- [integer RANGE 1 TO 2]

         -- PLB I/O Specification            
         C_FAMILY => C_FAMILY)  -- [string] Xilinx FPGA Family Type spartan3, virtex4, virtex5
      PORT MAP (

         -- OPBS Interface
         brdg_block           => brdg_block,  -- [IN  std_logic] bridge block
         brdg_prefetch_cmplt  => brdg_prefetch_cmplt,  -- [IN  std_logic] bridge prefetch complete
         brdg_prefetch_status => brdg_prefetch_status,  -- [IN std_logic] bridge prefetch status

         opbs_prefetch_req  => opbs_prefetch_req,  -- [OUT std_logic] opb slave prefetch request
         opbs_type          => opbs_type,  -- [OUT std_logic] opb slave transaction request type
         opbs_prefetch_clr  => opbs_prefetch_clr,  -- [OUT std_logic] opb slave prefetch clear
         opbs_postedwr_clr  => opbs_postedwr_clr,  -- [OUT std_logic] opb slave posted write clear
         opbs_trans_addr    => opbs_trans_addr,  -- [OUT std_logic_vector(0 TO 31)] opb slave transaction address
         opbs_length        => opbs_length,  -- [OUT std_logic_vector(0 TO 11)] opb slave transaction length
         opbs_postedwrt_req => opbs_postedwrt_req,  -- [OUT std_logic] opb slave posted write request
         opbs_be            => opbs_be,  -- [OUT std_logic_vector(0 TO 3)] opb slave byte enable

         -- Local Link Read Buffer
         bfs_data      => bfs_data,  -- [IN  std_logic_vector(0 TO 31)] Read data output to user logic
         bfs_sof_n     => bfs_sof_n,  -- [IN  std_logic] Active low signal indicating the starting data beat of a read local link transfer (unused by slave)
         bfs_eof_n     => bfs_eof_n,  -- [IN  std_logic] Active low signal indicating the ending data beat of a Read local link transfer. (Unused by slave)
         bfs_src_rdy_n => bfs_src_rdy_n,  -- [IN  std_logic] Asserts active low to indicate the presence of valid data on signal bfs_data.
         bfs_src_dsc_n => bfs_src_dsc_n,  -- [IN  std_logic] Active low signal indicating that the read local link source (master) needs to discontinue the transfer. (Unused. Drive high)
         bfs_dst_rdy_n => bfs_dst_rdy_n,  -- [OUT std_logic] Destination (ie the slave) asserts active low to signal it is ready to take valid data on bfs_data.
         bfs_dst_dsc_n => bfs_dst_dsc_n,  -- [OUT std_logic] Active low signal that the read local link destination needs to discontinue the transfer.

         -- Local Link Write Buffer
         bfd_data      => bfd_data,       -- [OUT std_logic_vector(0 TO 31)]
         bfd_sof_n     => bfd_sof_n,      -- [OUT std_logic]
         bfd_eof_n     => bfd_eof_n,      -- [OUT std_logic]
         bfd_src_rdy_n => bfd_src_rdy_n,  -- [OUT std_logic]
         bfd_src_dsc_n => bfd_src_dsc_n,  -- [OUT std_logic]
         bfd_dst_rdy_n => bfd_dst_rdy_n,  -- [IN  std_logic]
         bfd_dst_dsc_n => bfd_dst_dsc_n,  -- [IN  std_logic]

         -- OPB Slave Interface
         OPB_Select  => OPB_Select,  -- [IN  std_logic] OPB Master select
         OPB_RNW     => OPB_RNW,  -- [IN  std_logic] OPB Read not Write
         OPB_BE      => OPB_BE,  -- [IN  std_logic_vector(0 TO (32/8)-1)] OPB transaction byte enables
         OPB_seqAddr => OPB_seqAddr,  -- [IN  std_logic] OPB sequential address
         OPB_DBus    => OPB_DBus,  -- [IN  std_logic_vector(0 TO 32-1)] OPB master data bus
         OPB_ABus    => OPB_ABus,  -- [IN  std_logic_vector(0 TO 32-1)] OPB Slave address bus
         Sl_xferAck  => Sl_xferAck,  -- [OUT std_logic] OPB Slave transfer acknowledgement
         Sl_errAck   => Sl_errAck,  -- [OUT std_logic] OPB Slave transaction error acknowledgement
         Sl_retry    => Sl_retry,  -- [OUT std_logic] OPB Slave transaction retry
         Sl_ToutSup  => Sl_ToutSup,  -- [OUT std_logic] OPB Slave timeout suppress
         Sl_DBus     => Sl_DBus,  -- [OUT std_logic_vector(0 TO 32-1)] OPB Slave data BUS

         -- System Interface
         MPLB_rst => MPLB_rst,   -- [IN  std_logic] plb reset
         MPLB_clk => MPLB_clk,   -- [IN  std_logic] plb clock
         SOPB_rst => SOPB_rst,   -- [IN  std_logic] opbv46 reset
         SOPB_clk => SOPB_clk);  -- [IN std_logic] opbv46 clock

END ARCHITECTURE syn;
