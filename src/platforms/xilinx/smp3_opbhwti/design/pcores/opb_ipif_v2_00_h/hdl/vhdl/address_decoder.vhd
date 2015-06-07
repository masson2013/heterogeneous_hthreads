-------------------------------------------------------------------------------
-- $Id: address_decoder.vhd,v 1.3 2003/05/19 05:19:19 ostlerf Exp $
-------------------------------------------------------------------------------
-- address_decoder - entity/architecture pair
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        address_decoder.vhd
--
-- Description:     Address decoder utilizing unconstrained arrays for Base
--                  Address specification, target data bus size, and ce number.
--
-------------------------------------------------------------------------------
--
--                  -- address_decoder.vhd
--
-------------------------------------------------------------------------------
-- Author:      D. Thorpe
-- History:
--  DET        02-12-2002      -- First version
--
--
--  FLO        03-11-2002      -- Modified for use with OPB IPIF
--
-- ToDo List
--   (1) Disable CE, CS if the byte-enable pattern doesn't match the size, or
--       alternatively, generate an error.
--
--
--  FLO      05/16/2003
-- ^^^^^^
--  Fixed pselect component declaration with generic C_BAR as a constrained
--  array. The pselect instance was being tied to the pselect entity with
--  C_BAR declared as an unconstrained array. ModelSim 7.2b detected
--  this error but earlier ModelSims, Synplify and XST allow it.
-- ~~~~~~
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
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;     
--use ieee.std_logic_unsigned.CONV_INTEGER;  --Used in byte count compare 2 MA2SA_Num
--use ieee.std_logic_arith.conv_std_logic_vector;

library Unisim;
use Unisim.vcomponents.all;
--use Unisim.all;

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.all;
use proc_common_v1_00_b.pselect;
--use proc_common_v1_00_b.or_gate;

library ipif_common_v1_00_d;
use ipif_common_v1_00_d.ipif_pkg.all;

-------------------------------------------------------------------------------
-- Port declarations
-------------------------------------------------------------------------------

entity address_decoder is
  generic (
    C_BUS_AWIDTH      : Integer := 32;
    C_USE_REG_OUTPUTS : Boolean := true;
    
    C_ARD_ADDR_RANGE_ARRAY  : SLV64_ARRAY_TYPE
      -- := (                                                            
      --     X"1000_0000", --  IP user0 base address       
      --     X"1000_01FF", --  IP user0 high address       
      --     X"1000_0200", --  IP user1 base address       
      --     X"1000_02FF", --  IP user1 high address       
      --     X"1000_2000", --  IP user2 base address
      --     X"1000_20FF", --  IP user2 high address
      --     X"1000_2100", --  IPIF Interrupt base address       
      --     X"1000_21ff", --  IPIF Interrupt high address       
      --     X"1000_2200", --  IPIF Reset base address           
      --     X"1000_22FF", --  IPIF Reset high address           
      --     X"1000_2300", --  IPIF WrFIFO Registers base address
      --     X"1000_23FF", --  IPIF WrFIFO Registers high address
      --     X"7000_0000", --  IPIF WrFIFO Data base address     
      --     X"7000_00FF", --  IPIF WrFIFO Data high address     
      --     X"8000_0000", --  IPIF RdFIFO Registers base address
      --     X"8FFF_FFFF", --  IPIF RdFIFO Registers high address                                                   
      --     X"9000_0000", --  IPIF RdFIFO Data base address                                                        
      --     X"9FFF_FFFF"  --  IPIF RdFIFO Data high address                                                        
      --    )
            ;                                                                    
                                                                                  
    C_ARD_DWIDTH_ARRAY  : INTEGER_ARRAY_TYPE
      -- := (                                                            
      --     64  ,    -- User0 data width                          
      --     64  ,    -- User1 data width                                 
      --     64  ,    -- User2 data width                                 
      --     32  ,    -- IPIF Interrupt data width                                   
      --     32  ,    -- IPIF Reset data width                                       
      --     32  ,    -- IPIF WrFIFO Registers data width 
      --     64  ,    -- IPIF WrFIFO Data data width     
      --     32  ,    -- IPIF RdFIFO Registers data width
      --     64       -- IPIF RdFIFO Data width          
      --    )
            ;
                      
    C_ARD_NUM_CE_ARRAY   : INTEGER_ARRAY_TYPE
      -- := (                                                            
      --     8,     -- User0 CE Number
      --     1,     -- User1 CE Number
      --     1,     -- User2 CE Number
      --     16,    -- IPIF Interrupt CE Number
      --     1,     -- IPIF Reset CE Number
      --     2,     -- IPIF WrFIFO Registers CE Number
      --     1,     -- IPIF WrFIFO Data data CE Number
      --     2,     -- IPIF RdFIFO Registers CE Number
      --     1      -- IPIF RdFIFO Data CE Number
      --    )
    
    );   
  port (
    Bus_clk         : in  std_logic;
    Bus_rst         : in  std_logic;

    Address_In      : in  std_logic_vector(0 to C_BUS_AWIDTH-1);
    Address_Valid   : In std_logic;
    Bus_RNW         : In std_logic;
    IP2Bus_RdAck_mx : In std_logic;
    IP2Bus_WrAck_mx : In std_logic;
    Bus2IP_Burst    : In std_logic;
    
    Addr_Match      : Out   std_logic;
    CS_Out          : Out   std_logic_vector(0 to ((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
    CS_Size         : Out   std_logic_vector(0 to 2);
    CE_Out          : out   std_logic_vector(0 to calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);
    RdCE_Out        : out   std_logic_vector(0 to calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);
    WrCE_Out        : out   std_logic_vector(0 to calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);

    Devicesel_inh_opb  : in std_logic;
    Devicesel_inh_mstr : in std_logic
    );
end entity address_decoder;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------

architecture IMP of address_decoder is


-- local type declarations ----------------------------------------------------
type decode_bit_array_type is Array(natural range 0 to (
                                     (C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1) of integer;

type size_array_type is Array(natural range 0 to (
                                     (C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1) of 
                                     std_logic_vector(0 to 2);
   
   
-- functions ------------------------------------------------------------------
   
 function Addr_Bits (x,y : std_logic_vector(0 to C_BUS_AWIDTH-1)) 
 return integer is
   variable addr_nor : std_logic_vector(0 to C_BUS_AWIDTH-1);
 begin
   addr_nor := x xor y;
   for i in 0 to C_BUS_AWIDTH-1 loop
     if addr_nor(i)='1' then return i;
     end if;
   end loop;
   return(C_BUS_AWIDTH);
 end function Addr_Bits;


 function Get_Addr_Bits (baseaddrs : SLV64_ARRAY_TYPE) 
 return decode_bit_array_type is
     Variable num_bits : decode_bit_array_type;
 begin
    for i in 0 to ((baseaddrs'length)/2)-1 loop
       num_bits(i) :=  Addr_Bits(
                         baseaddrs(i*2)(   baseaddrs(0)'length-C_BUS_AWIDTH
                                        to baseaddrs(0)'length-1
                                       ), 
                         baseaddrs(i*2+1)(   baseaddrs(0)'length-C_BUS_AWIDTH
                                          to baseaddrs(0)'length-1
                                         ) 
                       );
    end loop;
    return(num_bits);
 end function Get_Addr_Bits;
 
 
 
 function encode_size (size : integer) return std_logic_vector is
 
    Variable enc_size : Std_logic_vector(0 to 2);
    
 begin
     
     Case size Is
        When 8 => 
           enc_size := "001";
        When 16 => 
           enc_size := "010";
        When 32 => 
           enc_size := "011";
        When 64 => 
           enc_size := "100";
        When 128 => 
           enc_size := "101";
        When others   => 
           enc_size := "000";
     End case;
     
     return(enc_size);    
     
 end function encode_size;
 
--ToDo, remove
--  function bool2int(b: boolean) return integer is
--    type tab_type is array (false to true) of integer;
--    constant tab : tab_type := (false => 0, true => 1);
--  begin
--    return tab(b);
--  end bool2int;
-- 
--
-------------------------------------------------------------------------------
---- Function calc_start_ce_index
----
---- This function is used to process the array specifying the number of Chip
---- Enables required for a Base Address specification. The CE Size array is 
---- input to the function and an integer index representing the index of the 
---- target module in the ce_num_array. An integer is returned reflecting the 
---- starting index of the assigned Chip Enables within the CE, RdCE, and 
---- WrCE Buses.
-------------------------------------------------------------------------------
-- function calc_start_ce_index (ce_num_array : INTEGER_ARRAY_TYPE;
--                               index        : integer) return integer is
--    Variable ce_num_sum : integer := 0;
-- begin
--   for i in 0 to index-1 loop
--       ce_num_sum := ce_num_sum + ce_num_array(i)
--                                + bool2int(ce_num_array(i)=0);
--   End loop;
--   return(ce_num_sum);
-- end function calc_start_ce_index;
--
--
-------------------------------------------------------------------------------
---- Function calc_num_ce
----
---- This function is used to process the array specifying the number of Chip
---- Enables required for a Base Address specification. The array is input to
---- the function and an integer is returned reflecting the total number of 
---- Chip Enables required for the CE, RdCE, and WrCE Buses
-------------------------------------------------------------------------------
--  function calc_num_ce (ce_num_array : INTEGER_ARRAY_TYPE) return integer is
--     Variable ce_num_sum : integer := 0;
--  begin
--    for i in 0 to (ce_num_array'length)-1 loop
--        ce_num_sum := ce_num_sum + ce_num_array(i)
--                                 + bool2int(ce_num_array(i)=0);
--    End loop;
--    return(ce_num_sum);
--  end function calc_num_ce;

 
-- Components------------------------------------------------------------------
component pselect is  
  generic (
    C_AB     : integer;
    C_AW     : integer;
    C_BAR    : std_logic_vector
    );
  port (
    A        : in   std_logic_vector(0 to C_AW-1);
    AValid   : in   std_logic;
    CS       : out  std_logic
    );
end component pselect;

component or_gate is
  generic (
    C_OR_WIDTH   : natural;
    C_BUS_WIDTH  : natural;
    C_USE_LUT_OR : boolean
    );
  port (
    A : in  std_logic_vector(0 to C_OR_WIDTH*C_BUS_WIDTH-1);
    Y : out std_logic_vector(0 to C_BUS_WIDTH-1)
    );
end component or_gate;



-- constants
constant NUM_BASE_ADDRS  : integer := (C_ARD_ADDR_RANGE_ARRAY'length)/2;

Constant DECODE_BITS     : decode_bit_array_type := Get_Addr_Bits(C_ARD_ADDR_RANGE_ARRAY);

Constant NUM_SIZES       : integer := C_ARD_DWIDTH_ARRAY'length;

Constant NUM_CE_SIGNALS : integer := calc_num_ce(C_ARD_NUM_CE_ARRAY);



-- Signals
 signal CS_Out_i        : std_logic_vector(0 to ((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
 signal CE_Out_i        : std_logic_vector(0 to NUM_CE_SIGNALS-1);  
 signal CS_Size_i       : std_logic_vector(0 to 2); 
 signal CS_Size_array   : size_array_type;
 Signal size_or_bus     : std_logic_vector(0 to (3*NUM_SIZES)-1);
 Signal decode_hit      : std_logic_vector(0 to 0);





------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Begin architecture
-------------------------------------------------------------------------------

begin -- architecture IMP

  -----------------------------------------------------------------------------
  -- Universal Address Decode Block
  -----------------------------------------------------------------------------
  MEM_DECODE_GEN: for bar_index in 0 to NUM_BASE_ADDRS-1 generate
  begin  
      -- Instantiate the basic Base Address Decoders
      MEM_SELECT_I: pselect
        generic map (
          C_AB     => DECODE_BITS(bar_index),
          C_AW     => C_BUS_AWIDTH,
          C_BAR    => C_ARD_ADDR_RANGE_ARRAY(bar_index*2)
                         (   C_ARD_ADDR_RANGE_ARRAY(0)'length-C_BUS_AWIDTH
                          to C_ARD_ADDR_RANGE_ARRAY(0)'length-1
                         ) 
    	)
        port map (
          A        => Address_In,       -- [in]
          AValid   => Address_Valid,     -- [in]
          CS       => CS_Out_i(bar_index)  -- [out]
  		);        

       -- Generate the size outputs
       Assign_size : process (CS_Out_i(bar_index))
           Begin
             If (CS_Out_i(bar_index) = '1') Then
                CS_Size_array(bar_index) <=  encode_size(C_ARD_DWIDTH_ARRAY(bar_index));
             else
                CS_Size_array(bar_index) <= (others => '0');
             End if;
           End process; -- assign_size


       -------------------------------------------------------------------------
       -- Now expand the individual chip enables for each base address.
       -------------------------------------------------------------------------
       DECODE_REGBITS: for ce_index in
                             0 to   C_ARD_NUM_CE_ARRAY(bar_index)
                                  - 1
       generate
          Constant NEXT_CE_INDEX_START   : integer := calc_start_ce_index(C_ARD_NUM_CE_ARRAY,bar_index);
          constant CE_DECODE_ADDR_SIZE   : Integer range 0 to 15 := log2(C_ARD_NUM_CE_ARRAY(bar_index));   
       begin
          ---------------------------------------------------------------------
          -- There is only one CE required so just use the output of the 
          -- pselect as the CE.
          ---------------------------------------------------------------------
          CE_IS_CS : if (CE_DECODE_ADDR_SIZE = 0) generate
            Constant ARRAY_INDEX           : integer := ce_index;
            Constant BASEADDR_INDEX        : integer := bar_index;
          begin
              CE_Out_i(NEXT_CE_INDEX_START+ARRAY_INDEX) <= CS_Out_i(BASEADDR_INDEX);
          end generate CE_IS_CS;  
                    
          
          ---------------------------------------------------------------------
          -- Multiple CEs are required so expand and decode as needed by the 
          -- specified number of CEs.
          ---------------------------------------------------------------------
          CE_EXPAND : if (CE_DECODE_ADDR_SIZE > 0) generate
            
            Constant ARRAY_INDEX           : integer := ce_index;
            Constant BASEADDR_INDEX        : integer := bar_index;
            constant CE_DECODE_SKIP_BITS   : Integer range 0 to 8  := log2(C_ARD_DWIDTH_ARRAY(BASEADDR_INDEX)/8); 
            constant CE_ADDR_WIDTH         : Integer range 0 to 31 := CE_DECODE_ADDR_SIZE + CE_DECODE_SKIP_BITS;   
            constant ADDR_START_INDEX      : integer range 0 to 31 := C_BUS_AWIDTH-CE_ADDR_WIDTH;
            constant ADDR_END_INDEX        : integer range 0 to 31 := C_BUS_AWIDTH-CE_DECODE_SKIP_BITS-1;
            Signal   compare_address  : std_logic_vector(0 to CE_DECODE_ADDR_SIZE-1);

          begin   
             INDIVIDUAL_CE_GEN : process (Address_In, CS_Out_i(BASEADDR_INDEX), compare_address)
                Begin
                  compare_address <= Address_In(ADDR_START_INDEX to ADDR_END_INDEX);
                  if compare_address = ARRAY_INDEX then
                      CE_Out_i(NEXT_CE_INDEX_START+ARRAY_INDEX) <= CS_Out_i(BASEADDR_INDEX);
                  else
                      CE_Out_i(NEXT_CE_INDEX_START+ARRAY_INDEX) <= '0';
                  end if;
                End process INDIVIDUAL_CE_GEN;  
          end generate CE_EXPAND;  

       end generate DECODE_REGBITS;
 
  end generate MEM_DECODE_GEN;    



   OR_CS_Size : process (CS_Size_array)
      Begin
        for i in 0 to NUM_SIZES-1 loop
           size_or_bus(3*i to 3*i+2) <= CS_Size_array(i);
        End loop; 
      End process; -- OR_CS_SIZE


   I_OR_SIZES :  or_gate 
     generic map(
       C_OR_WIDTH   => NUM_SIZES,
       C_BUS_WIDTH  => 3,
       C_USE_LUT_OR => TRUE
       )
     port map(
       A => size_or_bus,
       Y => CS_Size_i
       );



   I_OR_CS :  or_gate 
     generic map(
       C_OR_WIDTH   => NUM_BASE_ADDRS,
       C_BUS_WIDTH  => 1,
       C_USE_LUT_OR => TRUE
       )
     port map(
       A => CS_Out_i,
       Y => decode_hit
       );

-------------------------------------------------------------------------------
-- end of decoder block
-------------------------------------------------------------------------------


 
 

-------------------------------------------------------------------------------
-- Non-Registered Outputs Selection
-------------------------------------------------------------------------------
NOREG_OUTPUTS : if (C_USE_REG_OUTPUTS = False) generate

  -- Assign output signals to combinational signals
  Addr_Match   <= decode_hit(0) ;
  CS_Out       <= CS_Out_i   ;
  CS_Size      <= CS_Size_i  ;
  CE_Out       <= CE_Out_i   ;
  
  SET_NOREG_RW_CE : process (CE_Out_i, Bus_RNW)
    Begin
       for i in 0 to NUM_CE_SIGNALS-1 loop
          RdCE_Out(i)   <=  CE_Out_i(i) and Bus_RNW;     
          WrCE_Out(i)   <=  CE_Out_i(i) and not(Bus_RNW);

       End loop; 
       
     End process; -- SET_NOREG_RW_CE
  
end generate NOREG_OUTPUTS; 
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
--                     PLB REQUIRED REGISTERING
-------------------------------------------------------------------------------
-- The following logic is required by the PLB. It latches and holds the
-- signals necesary for the completion of the data phase of a PLB access.
-- It also generates the correct RdCE and WrCE timing for interfacing to
-- legacy OPB modules 
-------------------------------------------------------------------------------
REGISTER_OUTPUTS : if (C_USE_REG_OUTPUTS = True) generate
 
 signal CS_Out_i_reg    : std_logic_vector(0 to ((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
 signal CE_Out_i_reg    : std_logic_vector(0 to NUM_CE_SIGNALS-1);  
 signal RdCE_Out_i_reg  : std_logic_vector(0 to NUM_CE_SIGNALS-1);  
 signal WrCE_Out_i_reg  : std_logic_vector(0 to NUM_CE_SIGNALS-1); 
 signal CS_Size_i_reg   : std_logic_vector(0 to 2); 
 Signal decode_hit_reg  : std_logic;
 signal ff_reset        : std_logic;
 signal rdce_reset      : std_logic;
 signal wrce_reset      : std_logic;
 
begin

   ff_reset <= '1' when (Bus2IP_Burst = '0' and (   IP2Bus_WrAck_mx = '1'
                                                 or IP2Bus_RdAck_mx = '1'
                                                 )
                        )
                        or Bus_rst = '1' or 
                        (Devicesel_inh_opb or Devicesel_inh_mstr) = '1'
                        else '0' ;
                        
   rdce_reset <= '1' when (Bus2IP_Burst = '0' and IP2Bus_RdAck_mx = '1')
            or Bus_rst = '1'
            or Bus_RNW = '0' or 
            (Devicesel_inh_opb or Devicesel_inh_mstr) = '1' else '0';                        
            
   wrce_reset <= '1' when (Bus2IP_Burst = '0' and IP2Bus_WrAck_mx = '1')
            or Bus_rst = '1'
            or Bus_RNW = '1' or 
            (Devicesel_inh_opb or Devicesel_inh_mstr) = '1'
            else '0';                        
            
   REGCS_GEN: for i in 0 to ((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1 generate
     REGCS_FF_I: FDR
       port map (
         Q  => CS_Out_i_reg(i),
         C  => Bus_clk,
         D  => CS_Out_i(i),
         R  => ff_reset
         );
   end generate REGCS_GEN;

   REGCS_SIZE_GEN: for i in 0 to 2 generate
     REGCS_SIZE_FF_I: FDR
       port map (
         D  => CS_Size_i(i),
         C  => Bus_clk,
         Q  => CS_Size_i_reg(i),
         R  => ff_reset
         );
   end generate REGCS_SIZE_GEN;
   
   REGCE_GEN: for i in 0 to NUM_CE_SIGNALS-1 generate
     REGCE_FF_I: FDR
       port map (
         D  => CE_Out_i(i),
         C  => Bus_clk,
         Q  => CE_Out_i_reg(i),
         R  => ff_reset
         );
     REGRDCE_FF_I: FDR
       port map (
         D  => CE_Out_i(i),
         C  => Bus_clk,
         Q  => RdCE_Out_i_reg(i),
         R  => rdce_reset
         );
     REGWRCE_FF_I: FDR
       port map (
         D  => CE_Out_i(i),
         C  => Bus_clk,
         Q  => WrCE_Out_i_reg(i),
         R  => wrce_reset
         );         
   end generate REGCE_GEN;


--    -- Register the CS and CE signals          
--    REGCS_PROCESS: process(Bus_clk)
--    begin
-- 
--      if (Bus_clk'event and Bus_clk='1') then
--          if    (Bus2IP_Burst = '0' and (   IP2Bus_WrAck_mx = '1'
--                                         or IP2Bus_RdAck_mx = '1'
--                                        )
--                )
--             or Bus_rst = '1'
--          then
--             CS_Out_i_reg   <= (others => '0');
--             CS_Size_i_reg  <= (others => '0');
--             CE_Out_i_reg   <= (others => '0');
--          else
--             CS_Out_i_reg   <= CS_Out_i;
--             CS_Size_i_reg  <= CS_Size_i; 
--             CE_Out_i_reg   <= CE_Out_i;
--          end if;
--      end if;
-- 
--      if (Bus_clk'event and Bus_clk='1') then
--          if    (Bus2IP_Burst = '0' and IP2Bus_RdAck_mx = '1')
--             or Bus_rst = '1'
--             or Bus_RNW = '0'
--          then
--             RdCE_Out_i_reg   <= (others => '0');
--          else
--             RdCE_Out_i_reg   <= CE_Out_i;
--          end if;
--      end if;
-- 
--      if (Bus_clk'event and Bus_clk='1') then
--          if    (Bus2IP_Burst = '0' and IP2Bus_WrAck_mx = '1')
--             or Bus_rst = '1'
--             or Bus_RNW = '1'
--          then
--             WrCE_Out_i_reg   <= (others => '0');
--          else
--             WrCE_Out_i_reg   <= CE_Out_i;
--          end if;
--      end if;
-- 
--    end process;


   -- Register the Decode hit signal
   REG_DECODE_HIT : process (Bus_clk)
   Begin
      if (Bus_clk'event and Bus_clk='1') then
          
          if  Bus_rst = '1' then
             decode_hit_reg <=  '0';
          else 
             decode_hit_reg <= decode_hit(0);
          end if;
          
      end if;
   End process; -- REG_DECODE_HIT




  -- Assign output signals to registered signals
  Addr_Match   <= decode_hit_reg ;
  CS_Out       <= CS_Out_i_reg   ;
  CS_Size      <= CS_Size_i_reg  ;
  CE_Out       <= CE_Out_i_reg   ;
  RdCE_Out     <= RdCE_Out_i_reg ;
  WrCE_Out     <= WrCE_Out_i_reg ;


end generate REGISTER_OUTPUTS; 
-------------------------------------------------------------------------------          
          
          
          
end architecture IMP;

