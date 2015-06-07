-------------------------------------------------------------------------------
-- $Id: buffer_x16.vhd,v 1.1.2.1 2008/12/17 19:04:49 mlovejoy Exp $
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
-- Filename:        buffer_x16.vhd
--
-- Description:     This block provides a 16-deep fifo buffer with LocalLink
--                  interfaces on both ends. SOF and EOF bits are stored along
--                  with the data in the fifo.
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


-------------------------------------------------------------------------------
ENTITY buffer_x16 IS
   GENERIC (
      C_DWIDTH : INTEGER := 32;
      C_FAMILY : string := "virtex4"  -- Xilinx FPGA Family  Type spartan3, virtex4,virtex5   
      );
   PORT (

      -- Source Interface
      bfs_data      : OUT std_logic_vector(0 TO 31);  -- Read data output to user logic
      bfs_sof_n     : OUT std_logic;  -- Active low signal indicating the starting data beat of a read local link transfer (unused by slave)
      bfs_eof_n     : OUT std_logic;  -- Active low signal indicating the ending data beat of a Read local link transfer. (Unused by slave)
      bfs_src_rdy_n : OUT std_logic;  -- Asserts active low to indicate the presence of valid data on signal bfs_data.
      bfs_src_dsc_n : OUT std_logic;  -- Active low signal indicating that the read local link source (master) needs to discontinue the transfer. (Unused. Drive high)
      bfs_dst_rdy_n : IN  std_logic;  -- Destination (ie the slave) asserts active low to signal it is ready to take valid data on bfs_data.
      bfs_dst_dsc_n : IN  std_logic;  -- Active low signal that the read local link destination needs to discontinue the transfer.

      -- Destination (Sink) Interface 
      bfd_data      : IN  std_logic_vector(0 TO 31);
      bfd_sof_n     : IN  std_logic;
      bfd_eof_n     : IN  std_logic;
      bfd_src_rdy_n : IN  std_logic;
      bfd_src_dsc_n : IN  std_logic;
      bfd_dst_rdy_n : OUT std_logic;
      bfd_dst_dsc_n : OUT std_logic;

      -- System Interface
      rst : IN std_logic;     --  reset
      clk : IN std_logic      --  clock
      );
END ENTITY buffer_x16;

-------------------------------------------------------------------------------

LIBRARY proc_common_v3_00_a;
use     proc_common_v3_00_a.proc_common_pkg.log2;

ARCHITECTURE syn OF buffer_x16 IS
   CONSTANT PDLY : time := 1 NS;
   CONSTANT C_DEPTH : integer := 16;
   CONSTANT ZEROES : std_logic_vector(0 TO log2(C_DEPTH)-1) := (OTHERS => '0');

   SIGNAL bfs_src_rdy_n_i : std_logic;
   SIGNAL bfd_dst_rdy_n_i : std_logic;
   SIGNAL FIFO_write      : std_logic;
   SIGNAL FIFO_read       : std_logic;
   SIGNAL read_data       : std_logic_vector(0 TO C_DWIDTH-1+2);
   SIGNAL write_data      : std_logic_vector(0 TO C_DWIDTH-1+2);
BEGIN
   s0 : write_data <= bfd_sof_n & bfd_eof_n & bfd_data AFTER PDLY;
   -- Source data valid and not fifo full
   s1 : FIFO_write <= bfd_src_rdy_n NOR bfd_dst_rdy_n_i AFTER PDLY;
   -- Fifo not empty and destination ready to receive
   s2 : FIFO_read  <= bfs_src_rdy_n_i NOR bfs_dst_rdy_n AFTER PDLY;

   I_SRL_FIFO_RBU_F : ENTITY proc_common_v3_00_a.srl_fifo_rbu_f
      GENERIC MAP (
         C_DWIDTH => C_DWIDTH+2,
         C_DEPTH  => C_DEPTH,
         C_FAMILY => C_FAMILY
         )
      PORT MAP (
         Clk           => Clk,
         Reset         => rst,
         FIFO_Write    => FIFO_Write,
         Data_In       => write_data,
         FIFO_Read     => FIFO_Read,
         Data_Out      => read_data,
         FIFO_Full     => bfd_dst_rdy_n_i,
         FIFO_Empty    => bfs_src_rdy_n_i,
         Addr          => OPEN,
         Num_To_Reread => ZEROES,
         Underflow     => OPEN,
         Overflow      => OPEN
         );

   s3 : bfd_dst_rdy_n <= bfd_dst_rdy_n_i AFTER PDLY;
   s4 : bfs_src_rdy_n <= bfs_src_rdy_n_i AFTER PDLY;
   s5 : bfs_sof_n     <= read_data(0) AFTER PDLY;
   s6 : bfs_data      <= read_data(2 TO 31+2) AFTER PDLY;
   s7 : bfs_eof_n     <= read_data(1) AFTER PDLY;

   s8 : bfd_dst_dsc_n <= '1';  -- Can't terminate
   s9 : bfs_src_dsc_n <= '1';  -- Can't terminate
   
END ARCHITECTURE syn;

