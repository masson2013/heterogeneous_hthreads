--SINGLE_FILE_TAG
-------------------------------------------------------------------------------
-- $Id: ipif_steer_pkg.vhd,v 1.1 2003/05/07 21:48:34 ostlerf Exp $
-------------------------------------------------------------------------------
-- STEER_TYPES - package
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        ipif_steer_pkg.vhd
-- Version:         v1.00.a
-- Description:     Type declaration for IPIF steering logic
--
--
-------------------------------------------------------------------------------
-- Structure: 
--
--              ipif_steer_pkg.vhd
--
-------------------------------------------------------------------------------
-- Author:      BLT
-- History:
--  BLT             5-13-2002      -- First version
-- ^^^^^^
--      First version of steering logic package.
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
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

package STEER_TYPES is
  TYPE integer_array_type is array(natural range <>) of integer;
end package STEER_TYPES;