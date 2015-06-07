-------------------------------------------------------------------------------
-- $Id: burst_size_calc.vhd,v 1.5 2003/10/22 15:06:35 ostlerf Exp $
-------------------------------------------------------------------------------
-- Burst Size Calculation
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        burst_size_calc.vhd
-- Version:         
--------------------------------------------------------------------------------
-- Description:   This module calculates the size to use for a dma transfer.
--                The main complications are that for Rx channels the minimum
--                of LENGTH and PLENGTH must be used instead of LENGTH and
--                that for the last transfer there may be a need to round up
--                to include bytes that are insufficient to reach a unit of
--                C_BYTES_PER_SINGLE_TRANSFER.
--
-------------------------------------------------------------------------------
-- Structure: 
--              burst_size_calc.vhd
-------------------------------------------------------------------------------
-- Author:      FO
--
-- History:
--
--      FO      05/09/2003   -- First version
--
--      FLO     05/14/2003
-- ^^^^^^
--              Removed the pipe stage between LENGTH_cco comparison to
--              PLENGTH_cco and thre rest of the logic.
--              Corrected the high-order bits of MstNum from '1' to '0'. 
-- ~~~~~~

--      FLO     05/14/2003
-- ^^^^^^
--              Removed C_DMA_ALLOW_BURST; case is now handled as
--              C_DMA_BURST_SIZE = 1.
--              Added the option to handle the remainder (the amount left
--              to be moved by DMA when it is less than a full burst) as
--              a succession of single transactions rather than as a
--              short burst. This adds generic C_DMA_SHORT_BURST_REMAINDER
--              to the parameters. So, these options are now available:
--
--              1. Single transactions only when C_DMA_BURST_SIZE = 1.
--              2. Burst transactions, with remainders as singles when
--                 C_DMA_BURST_SIZE > 1 and
--                 C_DMA_SHORT_BURST_REMAINDER= false.
--              3. Burst transactions, with remainders as short burst when
--                 C_DMA_BURST_SIZE > 1 and
--                 C_DMA_SHORT_BURST_REMAINDER = true.
-- ~~~~~~
--      FLO     06/26/2003
-- ^^^^^^
--              Implemented XST WA for G.23 that was communicated by XST team.
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

library proc_common_v1_00_b;
use     proc_common_v1_00_b.proc_common_pkg.log2;

entity burst_size_calc is
    generic (
       C_LENGTH_WIDTH : positive := 11; 
       C_MSTNUM_WIDTH : positive := 5; 
       C_DMA_BURST_SIZE : positive := 16; 
       C_BYTES_PER_SINGLE_TRANSFER : positive := 4; 
       C_DMA_SHORT_BURST_REMAINDER : integer := 0
    );
    port (
        Bus2IP_Clk          : in  std_logic;
        LENGTH_cco          : in  std_logic_vector(0 to C_LENGTH_WIDTH-1);
        PLENGTH_cco         : in  std_logic_vector(0 to C_LENGTH_WIDTH-1);
        Rx_cco              : in  std_logic;
        MstNum              : out std_logic_vector(0 to C_MSTNUM_WIDTH-1)
    );
    -- Operational constraints:
    --      -  PLENGTH_cco is used only for Rx channels and for Rx channels, it is
    --         assumed that LENGTH_cco decrements if and only if PLENGTH_cco decrements
    --         by the same ammount. Thus, the relationship LENGTH_cco < PLENGTH_cco
    --         remains invariant as these quantities change value.
    --      -  C_BYTES_PER_SINGLE_TRANSFER must be a power of two.
    constant TPB       : positive := C_DMA_BURST_SIZE;  -- Transfers Per Burst
    constant BPST      : positive := C_BYTES_PER_SINGLE_TRANSFER;
    constant BPST_BITS : natural  := log2(BPST);
end burst_size_calc;
  

library unisim;
--use unisim.all;
use     unisim.VCOMPONENTS.all;

library ieee;
use ieee.numeric_std.UNSIGNED;
use ieee.numeric_std.TO_UNSIGNED;

library proc_common_v1_00_b;
use     proc_common_v1_00_b.or_muxcy;

architecture imp of burst_size_calc is

    type     bo2sl_type is array (boolean) of std_logic;
    constant bo2sl : bo2sl_type := ('0', '1');

  -- Number of of high-order bits that give a length in
  -- units of single transfers (units of the bus width).
  -- LW_STU stands for LENGTH_WIDTH in Single Transfer Units.
  constant LW_STU : positive := C_LENGTH_WIDTH-BPST_BITS;

  constant TPB_U  :  UNSIGNED(0 to LW_STU-1)
                  := (TO_UNSIGNED(TPB, LW_STU));

  constant TPB_BITS : natural := log2(TPB+1); -- 0 to TPB values to encode

  signal pl_gte_l            : std_logic; -- PLENGTH_cco >= LENGTH_cco (forced
                                          -- to true when not Rx_cco, which
                                          -- causes PLENGTH_cco to be ignored
                                          -- in downstream calculations).
  signal pl_gte_l_d1         : std_logic;

  signal min_pl_l_gte_tpb    : std_logic; -- min(PLENGTH_cco, LENGTH_cco) is
                                          -- greater than or equal to TPB

  signal min_pl_l_minus_tpb  : std_logic_vector(0 to C_LENGTH_WIDTH-1);
                                          -- min(PLENGTH_cco, LENGTH_cco) - TPB


  component or_muxcy is
      generic (
              C_NUM_BITS      : integer   := 8
              );
      port    (
              In_bus          : in std_logic_vector(0 to C_NUM_BITS-1);
              Or_out          : out std_logic     
              );
  end component or_muxcy;


begin

  DISALLOW_BURST_GEN: if C_DMA_BURST_SIZE = 1 generate
  begin
      MstNum <= std_logic_vector(TO_UNSIGNED(1, MstNum'length));
  end generate;



  ALLOW_BURST_GEN: if  C_DMA_BURST_SIZE > 1 generate ---(
  begin

  -- indentation waived

  PL_GTE_L_BLOCK: block ---(
      signal   brw_n    : std_logic_vector(0 to C_LENGTH_WIDTH);
      signal   lut      : std_logic_vector(0 to C_LENGTH_WIDTH-1);
      signal   mult_and : std_logic_vector(0 to C_LENGTH_WIDTH-1);
  
  begin
      --------------------------------------------------------------------------
      -- This block assigns:
      --
      -- pl_gte_l <= not Rx_cco or bo2sl(   PLENGTH_cco(0 to C_LENGTH_WIDTH-1)
      --                                  > LENGTH_cco(0 to C_LENGTH_WIDTH-1)
      --                                );
      --------------------------------------------------------------------------
  
      brw_n(brw_n'right) <= '1';
  
      PL_GTE_L_BIT_GEN: for i in C_LENGTH_WIDTH-1 downto 0 generate
      begin
  
          lut(i) <=     not (Rx_cco and  LENGTH_cco(i))
                    xor PLENGTH_cco(i);
            --
            -- When Rx_cco = '1', then the minimum of LENGTH_cco and
            -- PLENGTH_cco is used in the calculation of the burst
            -- size. Otherwise, only LENGTH_cco is used. A little trick
            -- is used to assure that LENGTH_cco is used when Rx_cco = '0'.
            -- The trick is that PLENGTH_cco is compared with a
            -- forced zero, assuring that pl_gte_l is true and that
            -- LENGTH_cco will be used in the next stage.
  
          ----------------------------------------------------------------------
          -- brw_n(i) <= (not lut(i) and not mult_and(i)) or
          --             (    lut(i) and brw_n(i+1));
          ----------------------------------------------------------------------
          I_MUXCY: MUXCY
            port map (
              DI => PLENGTH_cco(i),
              CI => brw_n(i+1),
              S  => lut(i),
              O  => brw_n(i)
            );
  
      end generate;
  
      pl_gte_l <= brw_n(0);
  
  end block;  ---)


  PL_GTE_L_D1_PROC: process(Bus2IP_Clk)
  begin
      if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
        pl_gte_l_d1 <= pl_gte_l;
      end if;
  end process;


  MIN_PL_L_MINUS_TPB_BLOCK: block ---(
      signal   brw_n : std_logic_vector(0 to C_LENGTH_WIDTH);
      signal   lut   : std_logic_vector(0 to C_LENGTH_WIDTH-1);
      constant TPBB_U :  UNSIGNED(0 to C_LENGTH_WIDTH-1)
                      := (TO_UNSIGNED(TPB*BPST, C_LENGTH_WIDTH));
      signal lut_tmp1   : std_logic_vector(0 to C_LENGTH_WIDTH-1); --XST WA for G.23
      signal lut_tmp2   : std_logic_vector(0 to C_LENGTH_WIDTH-1); --XST WA for G.23
  begin

      brw_n(brw_n'length-1) <= '1';

      MIN_PL_L_MINUS_TPB_BIT_GEN: for i in C_LENGTH_WIDTH-1 downto 0 generate
      begin

--        lut(i) <=     (   (    pl_gte_l_d1 and  LENGTH_cco(i))
--                       or (not pl_gte_l_d1 and PLENGTH_cco(i))
--                      )
--                  xor not TPBB_U(i);
-------------------
--        The above, using a cycle-delayed pl_gte_l may not
--        be permissable because MstNum likely is used
--        in state DONECHK when on the cycle right after cco changes.


          lut_tmp1(i) <= not TPBB_U(i); --XST WA for G.23
          lut_tmp2(i) <= (   (    pl_gte_l    and  LENGTH_cco(i))
                         or (not pl_gte_l    and PLENGTH_cco(i))
                        );
          lut(i) <= lut_tmp2(i)    
                    xor lut_tmp1(i);

--          lut(i) <=     (   (    pl_gte_l    and  LENGTH_cco(i))
--                         or (not pl_gte_l    and PLENGTH_cco(i))
--                        )
--                    xor not TPBB_U(i);

          ----------------------------------------------------------------------
          -- brw_n(i) <= (not lut(i) and not TPBB_U(i)) or (lut(i) and brw_n(i+1));
          ----------------------------------------------------------------------
          I_MUXCY: MUXCY
            port map (
              DI => (not TPBB_U(i)),
              CI => brw_n(i+1),
              S  => lut(i),
              O  => brw_n(i)
            );

          ----------------------------------------------------------------------
          -- min_pl_l_minus_tpb(i) <= lut(i) xor brw_n(i+1);
          ----------------------------------------------------------------------
          I_XORCY: XORCY
            port map (
              LI => lut(i),
              CI => brw_n(i+1),
              O  => min_pl_l_minus_tpb(i)
            );

      end generate;

      min_pl_l_gte_tpb <= brw_n(0);

  end block;  ---)



  MSTNUM_SINGLES_REM_GEN:
  if C_DMA_SHORT_BURST_REMAINDER = 0 generate  ---(
  begin

      MstNum <= std_logic_vector(TO_UNSIGNED(TPB, MstNum'length))
                when min_pl_l_gte_tpb = '1' else
                std_logic_vector(TO_UNSIGNED(1, MstNum'length));

  end generate;  ---)



  MSTNUM_BURST_REM_GEN:
  if C_DMA_SHORT_BURST_REMAINDER = 1 generate  ---(
      signal cry             : std_logic_vector(0 to TPB_BITS);
      signal lut             : std_logic_vector(0 to TPB_BITS-1);
      signal min_pl_l_lt_tpb : std_logic;
      signal mult_and_out    : std_logic_vector(0 to TPB_BITS-1);
      signal has_partial_bpst: std_logic; -- min(PLENGTH_cco, LENGTH_cco)
                                          -- divided by BPST leaves a non-zero
                                          -- remainder.
      signal mplmt_a  : std_logic_vector(0 to TPB_BITS-1);

      signal mstnum_a  : std_logic_vector(0 to TPB_BITS-1);

      constant tpb_a :  std_logic_vector(0 to TPB_BITS-1)
                     := std_logic_vector(TO_UNSIGNED(TPB, TPB_BITS));
  begin

      I_HAS_PARTIAL_BPST : or_muxcy
        generic map (
            C_NUM_BITS  => BPST_BITS
        )
        port map (
            In_bus      => min_pl_l_minus_tpb(C_LENGTH_WIDTH-BPST_BITS to
                                              C_LENGTH_WIDTH-1),
            Or_out      => has_partial_bpst
        );


      mplmt_a  <= min_pl_l_minus_tpb(C_LENGTH_WIDTH-TPB_BITS-BPST_BITS to
                                     C_LENGTH_WIDTH-BPST_BITS-1);

      min_pl_l_lt_tpb  <= not min_pl_l_gte_tpb;

      cry(cry'right) <= has_partial_bpst and min_pl_l_lt_tpb;

      MSTNUM_BIT_GEN: for i in TPB_BITS-1 downto 0 generate
      begin

          ----------------------------------------------------------------------
          lut(i) <=   (    min_pl_l_lt_tpb -- Use "amount left" if it is < TPB.
                       and (    mplmt_a(i) -- Reconstruct "amount left" by
                            xor tpb_a(i))  -- adding back TPB.
                      )
                   or (    not min_pl_l_lt_tpb
                       and tpb_a(i)        -- Use TPB if "amount left" >= TPB
                      );

          ----------------------------------------------------------------------
          -- mult_and_out(i) <= min_pl_l_lt_tpb and mplmt_a(i);
          ----------------------------------------------------------------------
          I_MULT_AND: MULT_AND
             port map (
                LO => mult_and_out(i),
                I1 => min_pl_l_lt_tpb,
                I0 => mplmt_a(i)
             );

          ----------------------------------------------------------------------
          -- cry(i) <= (not lut(i) and mult_and_out(i)) or (lut(i) and cry(i+1));
          ----------------------------------------------------------------------
          I_MUXCY: MUXCY
            port map (
              DI => mult_and_out(i),
              CI => cry(i+1),
              S  => lut(i),
              O  => cry(i)
            );

          ----------------------------------------------------------------------
          -- mstnum_a(i) <= lut(i) xor cry(i+1);
          ----------------------------------------------------------------------
          I_XORCY: XORCY
            port map (
              LI => lut(i),
              CI => cry(i+1),
              O  => mstnum_a(i)
            );

      end generate;

      MstNum(C_MSTNUM_WIDTH-TPB_BITS to C_MSTNUM_WIDTH-1) <= mstnum_a;

      XST_NULL_SLICE_WORKAROUND_MSTNUM_HIGH_BITS_GEN:
      if C_MSTNUM_WIDTH > TPB_BITS generate
          MstNum(0 to C_MSTNUM_WIDTH-TPB_BITS-1) <= (others => '0');
      end generate;

  end generate;  ---)


  -- indentation waived

  end generate; ---)

end imp;
