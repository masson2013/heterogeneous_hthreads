-------------------------------------------------------------------------------
-- $Id: ip2bus_srmux_blk.vhd,v 1.2 2004/11/23 01:04:03 jcanaris Exp $
-------------------------------------------------------------------------------
-- ip2bus_srmux_blk.vhd - VHD design file
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        ip2bus_srmux_blk.vhd
--
-- Description:     VHDL design file that is a wrapper around the IPIF status
--                  reply MUX design.
--
-------------------------------------------------------------------------------
-- Structure:
--
--              ip2bus_srmux_blk.vhd
--                    ip2bus_srmux.vhd
--
-------------------------------------------------------------------------------
-- Author:      D. Thorpe
--
-- History:
--  DET      Aug 21, 2001      -- First version adapted from Visual HDL output
--  LCW	Nov 8, 2004	  -- updated for NCSim
--
--
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
---------------------------------------------------------------------------------

library IEEE;
use IEEE.Std_Logic_1164.all;

library unisim;
use unisim.vcomponents.all;

library opb_ipif_v2_00_h;
use opb_ipif_v2_00_h.ip2bus_srmux;


entity ip2bus_srmux_blk is
  port (
        DMA2Bus_Error : in std_logic;
        DMA2Bus_RdAck : in std_logic;
        DMA2Bus_Retry : in std_logic;
        DMA2Bus_ToutSup : in std_logic;
        DMA2Bus_WrAck : in std_logic;
        Intr2Bus_Error : in std_logic;
        Intr2Bus_RdAck : in std_logic;
        Intr2Bus_Retry : in std_logic;
        Intr2Bus_ToutSup : in std_logic;
        Intr2Bus_WrAck : in std_logic;
        IP2Bus_Error : in std_logic;
        IP2Bus_Error_mx : out std_logic;
        IP2Bus_RdAck : in std_logic;
        IP2Bus_RdAck_mx : out std_logic;
        IP2Bus_Retry : in std_logic;
        IP2Bus_Retry_mx : out std_logic;
        IP2Bus_ToutSup : in std_logic;
        IP2Bus_ToutSup_mx : out std_logic;
        IP2Bus_WrAck : in std_logic;
        IP2Bus_WrAck_mx : out std_logic;
        RFIFO_Error : in std_logic;
        RFIFO_RdAck : in std_logic;
        RFIFO_Retry : in std_logic;
        RFIFO_ToutSup : in std_logic;
        RFIFO_WrAck : in std_logic;
        Rst2Bus_Error : in std_logic;
        Rst2Bus_RdAck : in std_logic;
        Rst2Bus_Retry : in std_logic;
        Rst2Bus_ToutSup : in std_logic;
        Rst2Bus_WrAck : in std_logic;
        WFIFO_Error : in std_logic;
        WFIFO_RdAck : in std_logic;
        WFIFO_Retry : in std_logic;
        WFIFO_ToutSup : in std_logic;
        WFIFO_WrAck : in std_logic
        );


end ip2bus_srmux_blk;


architecture implementation of ip2bus_srmux_blk is


begin

  I_IP2BUS_SRMUX: entity opb_ipif_v2_00_h.ip2bus_srmux
    port map (
              IP2Bus_WrAck => IP2Bus_WrAck,
              IP2Bus_RdAck => IP2Bus_RdAck,
              IP2Bus_Retry => IP2Bus_Retry,
              IP2Bus_Error => IP2Bus_Error,
              IP2Bus_ToutSup => IP2Bus_ToutSup,
              WFIFO_WrAck => WFIFO_WrAck,
              WFIFO_RdAck => WFIFO_RdAck,
              WFIFO_Retry => WFIFO_Retry,
              WFIFO_Error => WFIFO_Error,
              WFIFO_ToutSup => WFIFO_ToutSup,
              RFIFO_WrAck => RFIFO_WrAck,
              RFIFO_RdAck => RFIFO_RdAck,
              RFIFO_Retry => RFIFO_Retry,
              RFIFO_Error => RFIFO_Error,
              RFIFO_ToutSup => RFIFO_ToutSup,
              DMA2Bus_WrAck => DMA2Bus_WrAck,
              DMA2Bus_RdAck => DMA2Bus_RdAck,
              DMA2Bus_Retry => DMA2Bus_Retry,
              DMA2Bus_Error => DMA2Bus_Error,
              DMA2Bus_ToutSup => DMA2Bus_ToutSup,
              IRPT_WrAck => Intr2Bus_WrAck,
              IRPT_RdAck => Intr2Bus_RdAck,
              IRPT_Retry => Intr2Bus_Retry,
              IRPT_Error => Intr2Bus_Error,
              IRPT_ToutSup => Intr2Bus_ToutSup,
              RESET_WrAck => Rst2Bus_WrAck,
              RESET_RdAck => Rst2Bus_RdAck,
              RESET_Retry => Rst2Bus_Retry,
              RESET_Error => Rst2Bus_Error,
              RESET_ToutSup => Rst2Bus_ToutSup,
              IP2Bus_WrAck_mx => IP2Bus_WrAck_mx,
              IP2Bus_RdAck_mx => IP2Bus_RdAck_mx,
              IP2Bus_Retry_mx => IP2Bus_Retry_mx,
              IP2Bus_Error_mx => IP2Bus_Error_mx,
              IP2Bus_ToutSup_mx => IP2Bus_ToutSup_mx);
end implementation;

