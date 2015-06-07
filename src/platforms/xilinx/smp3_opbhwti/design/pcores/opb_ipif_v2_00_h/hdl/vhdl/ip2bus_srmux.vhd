-------------------------------------------------------------------------------
-- $Id: ip2bus_srmux.vhd,v 1.1 2003/03/15 01:05:25 ostlerf Exp $
-------------------------------------------------------------------------------
-- ip2bus_srmux.vhd - vhdl design file for the entity and architecture
--                            of the Mauna Loa IPIF IP to IPIF Bus Status Reply
--                            multiplexer (actually just a big OR gate).
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        ip2bus_srmux.vhd
--
-- Description:     This vhdl design file is for the entity and architecture  
--                  of the Mauna Loa IPIF IP to IPIF Bus Status Reply 
--                  multiplexer (actually just a big OR gate).        
--
-------------------------------------------------------------------------------
-- Structure:   
--              
--
--              ip2bus_srmux.vhd
--
-------------------------------------------------------------------------------
-- Author:      D. Thorpe
-- History:
--  DET        Apr-25-01      -- First version
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
--
-- Library definitions

library ieee;
use ieee.std_logic_1164.all;


-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------
entity ip2bus_srmux is
    port (
    
       -- Status Reply inputs from the IP
         IP2Bus_WrAck       : in    std_logic;
         IP2Bus_RdAck       : in    std_logic;
         IP2Bus_Retry       : in    std_logic;
         IP2Bus_Error       : in    std_logic;
         IP2Bus_ToutSup     : in    std_logic;
         
       -- Status Reply inputs from the Write FIFO
         WFIFO_WrAck        : in    std_logic;
         WFIFO_RdAck        : in    std_logic;
         WFIFO_Retry        : in    std_logic;
         WFIFO_Error        : in    std_logic;
         WFIFO_ToutSup      : in    std_logic;
         
       -- Status Reply inputs from the Read FIFO
         RFIFO_WrAck        : in    std_logic;
         RFIFO_RdAck        : in    std_logic;
         RFIFO_Retry        : in    std_logic;
         RFIFO_Error        : in    std_logic;
         RFIFO_ToutSup      : in    std_logic;
         
       -- Status Reply inputs from the DMA/SG engine
         DMA2Bus_WrAck       : in    std_logic;
         DMA2Bus_RdAck       : in    std_logic;
         DMA2Bus_Retry       : in    std_logic;
         DMA2Bus_Error       : in    std_logic;
         DMA2Bus_ToutSup     : in    std_logic;
         
       -- Status Reply inputs from the Interrupt Collector
         IRPT_WrAck         : in    std_logic;
         IRPT_RdAck         : in    std_logic;
         IRPT_Retry         : in    std_logic;
         IRPT_Error         : in    std_logic;
         IRPT_ToutSup       : in    std_logic;
         
       -- Status reply from the Reset block
         RESET_WrAck        : In    std_logic;
         RESET_RdAck        : in    std_logic;
         RESET_Retry        : in    std_logic;
         RESET_Error        : in    std_logic;
         RESET_ToutSup      : in    std_logic;
         
       -- Status Reply outputs to the Slave Attachment
         IP2Bus_WrAck_mx    : out   std_logic;
         IP2Bus_RdAck_mx    : out   std_logic;
         IP2Bus_Retry_mx    : out   std_logic;
         IP2Bus_Error_mx    : out   std_logic;
         IP2Bus_ToutSup_mx  : out   std_logic
         
        
         );
end ip2bus_srmux;




architecture implementation of ip2bus_srmux is


    
-- COMPONENTS

--TYPES
    
  -- no types
  
             
-- CONSTANTS
  -- no constants
  

--INTERNAL SIGNALS

 
--------------------------------------------------------------------------------------------------------------
-------------------------------------- start of logic -------------------------------------------------
  
begin
  
  
 -- The following code is for a simple 'OR' function of the input signals 
 -- to generate a single output. This method works in place of a multiplexer
 -- since by definition inactive signals are driven to a logic '0'.
 
    -- Combinational logic
    
    IP2Bus_WrAck_mx   <= IP2Bus_WrAck or 
                         WFIFO_WrAck  or 
                         RFIFO_WrAck  or 
                         DMA2Bus_WrAck or
                         IRPT_WrAck   or
                         RESET_WrAck;
                      
    IP2Bus_RdAck_mx   <= IP2Bus_RdAck or 
                         WFIFO_RdAck  or 
                         RFIFO_RdAck  or 
                         DMA2Bus_RdAck or
                         IRPT_RdAck   or
                         RESET_RdAck;
                      
    IP2Bus_Retry_mx   <= IP2Bus_Retry or 
                         WFIFO_Retry  or 
                         RFIFO_Retry  or 
                         DMA2Bus_Retry or
                         IRPT_Retry   or
                         RESET_Retry;
                      
    IP2Bus_Error_mx   <= IP2Bus_Error or 
                         WFIFO_Error  or 
                         RFIFO_Error  or 
                         DMA2Bus_Error or
                         IRPT_Error   or
                         RESET_Error;
     
    IP2Bus_ToutSup_mx <= IP2Bus_ToutSup or 
                         WFIFO_ToutSup  or 
                         RFIFO_ToutSup  or 
                         DMA2Bus_ToutSup or
                         IRPT_ToutSup   or
                         RESET_ToutSup;
     
                                         
      
end implementation;
  


