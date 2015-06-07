-------------------------------------------------------------------------------
-- $Id: addr_load_and_incr.vhd,v 1.1 2003/03/15 01:05:24 ostlerf Exp $
-------------------------------------------------------------------------------
-- addr_load_and_incr - entity and architecture
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        addr_load_and_incr.vhd
--
-- Description:     Module to load an address, increment present address and
--                  synchronously reset using Virtex primitives.
--
--      This module instantiates Virtex primitives to realize a module requiring
--      minimal FPGA resources that synchronously loads Bus_input data on
--      Bus_output when Incr_N_Load is low. and synchronously increments
--      Bus_output when Incr_N_Load is high. Both operations are gated by
--      FDRE_CE which is the register clock enable.  A synchronous reset is
--      performed via FDRE_Reset which takes precidence over FDRE_CE and
--      the D-input. One LUT is required per bus-bit.
--
--      Note that this module was designed because I was not successful in
--      inferring FDRE FFs with synplicity's 6.2 release.
--
-------------------------------------------------------------------------------
--
--              addr_load_and_incr.vhd
--                 unisim
--
-------------------------------------------------------------------------------
-- Author:      MLL
-- History:
--  MLL      09/27/01      -- First version
--
--  <initials>      <date> 
-- ^^^^^^
--
-------------------------------------------------------------------------------
library unisim;
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------
entity addr_load_and_incr is
    generic (
        C_BUS_WIDTH         : integer
        );

    port(
       --Bus ports
        Bus_Clk             : in STD_LOGIC;
        FDRE_CE             : in STD_LOGIC;
        FDRE_Reset          : in STD_LOGIC;
        Incr_N_Load         : in STD_LOGIC;
        Bus_input           : in STD_LOGIC_VECTOR (0 to C_BUS_WIDTH-1);
        Bus_output          : out STD_LOGIC_VECTOR (0 to C_BUS_WIDTH-1)
        );
end addr_load_and_incr;
-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of addr_load_and_incr is

constant RESET_ACTIVE: std_logic := '1';

--signals
signal Bus_cry                 : STD_LOGIC_VECTOR (0 to C_BUS_WIDTH-1);
signal Bus_qxu                 : STD_LOGIC_VECTOR (0 to C_BUS_WIDTH-1);
signal Bus_s                   : STD_LOGIC_VECTOR (0 to C_BUS_WIDTH-1);
signal Bus_c                   : STD_LOGIC_VECTOR (0 to C_BUS_WIDTH-1);

component LUT4
   generic(
      INIT : bit_vector(15 downto 0)
      );
   port(
      O                        : out  std_ulogic;
      I0                       : in   std_ulogic;
      I1                       : in   std_ulogic;
      I2                       : in   std_ulogic;
      I3                       : in   std_ulogic
      );
end component;

component XORCY
   port(
      O                        :  out   STD_ULOGIC;
      LI                       :  in    STD_ULOGIC;
      CI                       :  in    STD_ULOGIC);
end component;

component MUXCY_L
   port(
      LO                       :  out   STD_ULOGIC;
      DI                       :  in    STD_ULOGIC;
      CI                       :  in    STD_ULOGIC;
      S                        :  in    STD_ULOGIC);
end component;

component FDRE
   port(
      Q                        :  out   STD_ULOGIC;
      D                        :  in    STD_ULOGIC;
      C                        :  in    STD_ULOGIC;
      CE                       :  in    STD_ULOGIC;
      R                        :  in    STD_ULOGIC);
end component;

begin

Bus_output <= Bus_c;

Load_and_increment_vector_Generate: for j in 0 to C_BUS_WIDTH-2 generate
begin
   I_LUT4_add_incr: LUT4
      generic map(
      INIT => X"1BE4"
      )
   port map(
      O => Bus_qxu(j),
      I0 => Incr_N_Load,
      I1 => Bus_input(j),
      I2 => Bus_c(j),
      I3 => '0'
      );

   I_XORCY_add_incr: XORCY
   port map(
      O => Bus_s(j),
      LI => Bus_qxu(j),
      CI => Bus_cry(j+1)
      );

   I_FDRE_add_incr: FDRE
   port map(
      Q => Bus_c(j),
      C => Bus_Clk,
      CE => FDRE_CE,
      D => Bus_s(j),
      R => FDRE_Reset
      );
  
   I_MUXCY_L_add_incr: MUXCY_L
   port map(
      LO => Bus_cry(j),
      DI => '0',
      CI => Bus_cry(j+1),
      S =>Bus_qxu(j)
      );
end generate Load_and_increment_vector_Generate;

   I_LUT4_add_incr: LUT4
      generic map(
      INIT => X"1BE4"
      )
   port map(
      O => Bus_qxu(C_BUS_WIDTH-1),
      I0 => Incr_N_Load,
      I1 => Bus_input(C_BUS_WIDTH-1),
      I2 => Bus_c(C_BUS_WIDTH-1),
      I3 => '0'
      );

   I_XORCY_add_incr: XORCY
   port map(
      O => Bus_s(C_BUS_WIDTH-1),
      LI => Bus_qxu(C_BUS_WIDTH-1),
      CI => Incr_N_Load
      );

   I_FDRE_add_incr: FDRE
   port map(
      Q => Bus_c(C_BUS_WIDTH-1),
      C => Bus_Clk,
      CE => FDRE_CE,
      D => Bus_s(C_BUS_WIDTH-1),
      R => FDRE_Reset
      );

   I_MUXCY_L_add_incr: MUXCY_L
   port map(
      LO => Bus_cry(C_BUS_WIDTH-1),
      DI => '0',
      CI => Incr_N_Load,
      S =>Bus_qxu(C_BUS_WIDTH-1)
      );
 
end implementation;
