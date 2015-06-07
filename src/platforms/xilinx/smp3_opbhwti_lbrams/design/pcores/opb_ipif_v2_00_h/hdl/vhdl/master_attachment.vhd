-------------------------------------------------------------------------------
-- $Id: master_attachment.vhd,v 1.13 2004/11/23 01:04:03 jcanaris Exp $
-------------------------------------------------------------------------------
-- Master Attachment - entity and architecture
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        master_attachment.vhd
--
-- Description:     Master attachment for Xilinx OPB
--
-------------------------------------------------------------------------------
--
--              master_attachment.vhd
--                 addr_load_and_incr.vhd
--
-------------------------------------------------------------------------------
-- Author:      MLL
-- History:
--  MLL      05/09/01      -- First version
--
--  MLL      09/18/01      -- Changed construct from if-then to state machine
--
--      FLO     12/13/01
-- ^^^^^^
--      Fixed component declaration addr_load_and_incr.
-- ~~~~~~
--
--      FLO     1/2/02
-- ^^^^^^
--      Removed _gtd from signals.
-- ~~~~~~
--      FLO     5/2/02
-- ^^^^^^
--      Removed _gtd from signals.
-- ~~~~~~
--
--      FLO     5/14/02
-- ^^^^^^
--      Retained-state retry optimization.
-- ~~~~~~
--      FLO      06/24/02
-- ^^^^^^
--      Implemented dynamic byte-enable capability.
-- ~~~~~~
--  FLO      06/28/02
-- ^^^^^^
--  Moved the contents of mst_module.vhd into a block in this file.
-- ~~~~~~
--  FLO      09/24/02
-- ^^^^^^
--  Changed the implementation of signal DMA_Request_HasPriority
--  so that master arbitration has a least recently serviced
--  grant behavior. Previous to the change, one master could
--  lock out the other for as long as it immediately re-requested.
-- ~~~~~~
--  FLO      10/11/02
-- ^^^^^^
--  Added state and logic to remember the outgoing master address that
--  is destroyed by the act of release of the bus (see Note, below)
--  and to use the remembered "shadow" address when restarting transactions under
--  retained-state retry. Adds about 33 FF and 34 LUT.
--
--  Note: Destroyed by using the reset of the address counter as a
--        way of driving zero to the bus.)
-- ~~~~~~
--  FLO      11/06/02
-- ^^^^^^
--  Added signal retained_state_retry_active to the sensitivity list for
--  the state-machine combinatorial process.
-- ~~~~~~
--  FLO      11/19/02
-- ^^^^^^
--  Master read operations do not start until new signal SA2MA_PostedWrInh
--  is false.
-- ~~~~~~
--  FLO      11/19/02
-- ^^^^^^
--  Added generic C_MASTER_ARB_MODEL, which allows for user-parameterized
--  arbitration behavior when there are both DMA and IP masters. Supports
--  fair, DMA-priority and IP-priority modes.
-- ~~~~~~
--  FLO      11/26/02
-- ^^^^^^
--  Master read operations from the IP master do *not* wait until
--  SA2MA_PostedWrInh is false. (See first 11/19/02, above.)
-- ~~~~~~
--  FLO      11/26/02
-- ^^^^^^
--  - Toggle priority when retry is not handled as retained-state.
--  - Added handling when SA reports that a master write operation
--    has received a retry on the first IPIC read.
-- ~~~~~~
--  FLO      01/07/03
-- ^^^^^^
--  - Added one clock cycle of delay to Bus2IP_MstRdAck and Bus2IP_MstLastAck
--    for a burst master read. This change makes these two signals assert
--    on the same cycle that the corresponding IPIC posted write is
--    taking place. Note that this behavior is dependent on the slave
--    attachment implementation; any change to the slave attachment's
--    MA2SA_XferAck to Bus2IP_WrReq timing needs a corresponding adjustment
--    here.
-- ~~~~~~
--  FLO      02/21/03
-- ^^^^^^
--  - Fixed incompatibility with grant parking onto this master.
--    Details: Several places OPB_MnGrant was used under the assumption that
--    it would only assert when Mn_request was true. Under parking, this
--    assumption doesn't hold. The fix is to qualify OPB_MnGrant by
--    anding it with Mn_request to produce qualified grant signal
--    bus_mngrant_i. This qualified signal is used locally in the
--    master attachment and is passed as Bus_MnGrant to the slave attachment.
-- ~~~~~~
--  FLO      05/18/2003
-- ^^^^^^
--  Changed the ack_counter to automatically adjust its required range
--  from the C_MA2SA_NUM_WIDTH parameter. Previously this was hard-coded
--  for size 8 bursts.
-- ~~~~~~
--  FLO      05/21/2004
-- ^^^^^^
--  The signal XXX2Bus_MstBE is now available one cycle earlier so that it
--  will be valid when Mst_rd_starting_pulse pulses for one clock. This
--  fixes a problem where, if both DMA and IP masters are present,
--  the wrong MstBE values would be placed into the "BE FIFO" for
--  locally mastered read operations.
-- ~~~~~~
--  FLO      05/26/2004
-- ^^^^^^
--  Added signal SA2MA_TimeOut to the interface. Assertion of this new
--  signal will terminate a master transaction with Bus2IP_MstTimeOut.
-- ~~~~~~
--  FLO      05/26/2004
-- ^^^^^^
--  Drive the low-order two Mn_Abus bits to match the numerically lowest
--  Mn_BE bit that is asserted.
-- ~~~~~~
--  FLO      05/27/2004
-- ^^^^^^
--  Removal of an VHDL alias construct.
-- ~~~~~~
--  FLO      08/11/2004
-- ^^^^^^
--  Added ouput port MA2SA_RSRA (retained_state_retry_active).
-- ~~~~~~
--  FLO      09/24/2004
-- ^^^^^^
--  Changed from up to down counter for counting acks.
--  (Part of v2_00_i 1.1 -> 1.3)
-- ~~~~~~
--  FLO      09/24/2004
-- ^^^^^^
--  -Added signal SA2MA_BufOccMinus1.
--  -Implemented write of any read data to the OPB before responding with
--   Bus2IP_MstRetry if the retry is signaled via SA2MA_Retry.
--  -Distinguish "clean retry" (all data, which is partial, is written
--   before retry) and "dirty retry" (some data read from IPIC but not
--   written to OPB before retry. Use Bus2IP_MstLastAck asserted concurrently
--   with Bus2IP_MstRetry as the indication of clean retry.
--  -Using bus2ip_msttimeout_i to exit state
--   Wait_for_Rdrdy on the timeout event.
-- ~~~~~~
-- FLO     10/27/2004
-- ^^^^^^
-- - On locally mastered writes, mn_seqaddr gets asserted if and only if
--   multiple beats have been buffered.
-- ~~~~~~
--  LCW	Nov 8, 2004	  -- updated for NCSim

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
library unisim;
use unisim.vcomponents.all;

library opb_ipif_v2_00_h;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.UNSIGNED;
use ieee.numeric_std."=";

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.log2;
use proc_common_v1_00_b.ld_arith_reg;
-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------
entity master_attachment is
    generic (
        C_OPB_ABUS_WIDTH    : integer;                 -- 32 bits
        C_OPB_DBUS_WIDTH    : integer;                 -- Only 32 bits is
                      --supported due to the fact the the DMA registers
                      --were only defined for a 32-bit bus
        C_MA2SA_NUM_WIDTH   : integer :=4;             -- 4 bits
        C_DMA_ONLY          : boolean;                 -- No IP-Master function
        C_IP_MSTR_ONLY      : boolean;                 -- No DMA-Master function
                            --Only one of C_DMA_ONLY or C_IP_MSTR_ONLY can be true
        C_MASTER_ARB_MODEL  : integer := 0
            --  0:FAIR  1:DMA_PRIORITY  2:IP_PRIORITY
        );

    port(
        Reset               : in STD_LOGIC;

       --OPB ports
        OPB_Clk             : in STD_LOGIC;
        OPB_MnGrant         : in STD_LOGIC;
        OPB_XferAck         : in STD_LOGIC;
        OPB_ErrAck          : in STD_LOGIC;
        OPB_TimeOut         : in STD_LOGIC;
        OPB_Retry           : in STD_LOGIC;

       --Master Attachment to OPB ports
        Mn_Request          : out STD_LOGIC;
        Mn_Select           : out STD_LOGIC;
        Mn_RNW              : out STD_LOGIC;
        Mn_SeqAddr          : out STD_LOGIC;
        Mn_BusLock          : out STD_LOGIC;
        Mn_BE               : out STD_LOGIC_VECTOR(0 to C_OPB_DBUS_WIDTH/8-1);
        Mn_ABus             : out STD_LOGIC_VECTOR(0 to C_OPB_ABUS_WIDTH-1);

       --Master Attachment to SA ports
        Bus_MnGrant         : out STD_LOGIC;
        MA2SA_Select        : out STD_LOGIC;
        MA2SA_XferAck       : out STD_LOGIC;
        MA2SA_Retry         : out STD_LOGIC;
        MA2SA_RSRA          : out STD_LOGIC;
        MA2SA_Rd            : out STD_LOGIC;
        MA2SA_Num           : out STD_LOGIC_VECTOR(0 to C_MA2SA_NUM_WIDTH-1);
        SA2MA_RdRdy         : in STD_LOGIC;
        SA2MA_WrAck         : in STD_LOGIC;
        SA2MA_Retry         : in STD_LOGIC;
        SA2MA_Error         : in STD_LOGIC;
        SA2MA_FifoRd        : in STD_LOGIC;
        SA2MA_FifoWr        : in STD_LOGIC;
        SA2MA_FifoBu        : in STD_LOGIC;
        SA2MA_PostedWrInh   : in STD_LOGIC;
        SA2MA_TimeOut       : in STD_LOGIC;
        SA2MA_BufOccMinus1  : in STD_LOGIC_VECTOR(0 to 4);

       --Master Attachment from IP ports
        Mstr_Sel_ma         : out STD_LOGIC;

       --Master Attachment from IP ports
        IP2Bus_Addr         : in STD_LOGIC_VECTOR(0 to C_OPB_ABUS_WIDTH-1)
                              := (others => '0');
        IP2Bus_MstBE        : in STD_LOGIC_VECTOR(0 to C_OPB_DBUS_WIDTH/8-1)
                              := (others => '0');
        IP2Bus_MstWrReq     : in STD_LOGIC := '0';
        IP2Bus_MstRdReq     : in STD_LOGIC := '0';
        IP2Bus_MstBurst     : in STD_LOGIC := '0';
        IP2Bus_MstBusLock   : in STD_LOGIC := '0';

       --Master Attachment to IP ports
        Bus2IP_MstWrAck_ma  : out STD_LOGIC;
        Bus2IP_MstRdAck_ma  : out STD_LOGIC;
        Bus2IP_MstRetry     : out STD_LOGIC;
        Bus2IP_MstError     : out STD_LOGIC;
        Bus2IP_MstTimeOut   : out STD_LOGIC;
        Bus2IP_MstLastAck   : out STD_LOGIC;

       --Master Attachment from DMA ports
        DMA2Bus_Addr        : in STD_LOGIC_VECTOR(0 to C_OPB_ABUS_WIDTH-1)
                              := (others => '0');
        DMA2Bus_MstBE       : in STD_LOGIC_VECTOR(0 to C_OPB_DBUS_WIDTH/8-1)
                              := (others => '0');
        DMA2Bus_MstWrReq    : in STD_LOGIC := '0';
        DMA2Bus_MstRdReq    : in STD_LOGIC := '0';
        DMA2Bus_MstNum      : in STD_LOGIC_VECTOR(0 to C_MA2SA_NUM_WIDTH-1);
        DMA2Bus_MstBurst    : in STD_LOGIC := '0';
        DMA2Bus_MstBusLock  : in STD_LOGIC := '0'
        );

end master_attachment;
-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of master_attachment is

constant ZEROES : std_logic_vector(0 to 256) := (others => '0');

constant RESET_ACTIVE: std_logic := '1';

    type     bo2sl_type is array (boolean) of std_logic;
    constant bo2sl_table : bo2sl_type := ('0', '1');
    function bo2sl(b: boolean) return std_logic is
    begin
      return bo2sl_table(b);
    end bo2sl;

constant RETAIN_ADDRESS_OVER_RETRY : boolean := not C_DMA_ONLY;
  -- The dma_sg takes the responsibility of keeping the presented
  -- master address up-to-date with successful bus transfers;
  -- extra logic to maintain the address under retained-state-retry
  -- operation can be ommitted if dma_sg is the only master.

constant FAIR         : integer := 0;
constant DMA_PRIORITY : integer := 0;
constant IP_PRIORITY  : integer := 0;

--signals
signal MA2SA_XferAck_i         : std_logic;
signal Mst_SM_cs_EQ_Wait_state : std_logic;
signal Mst_SM_cs_EQ_Wait_For_Req : std_logic;
signal Bus2IP_MstLastAck_i     : std_logic;
signal MA2SA_Num_i             : std_logic_vector(0 to C_MA2SA_NUM_WIDTH-1);
signal DMA_sel_IP_sel_not      : std_logic;
signal DMA_sel_IP_sel_not_p1   : std_logic;
signal DMA_Request_HasPriority : std_logic;
signal Reset_withNotReqs       : std_logic;
signal XXX2Bus_MstBurst        : std_logic;
signal XXX2Bus_MstBusLock      : std_logic;
signal XXX2Bus_MstRdReq        : std_logic;
signal XXX2Bus_MstWrReq        : std_logic;
signal XXX2Bus_RNW             : std_logic;
signal XXX2Bus_MstBE           : std_logic_vector(0 to C_OPB_DBUS_WIDTH/8-1);
signal xxx2bus_mstbe_fifo      : std_logic_vector(0 to C_OPB_DBUS_WIDTH/8-1);
signal XXX2Bus_Addr            : std_logic_vector(0 to C_OPB_ABUS_WIDTH-1);
signal Xfer_in_progress        : std_logic;
signal FDRE_CE                 : std_logic;
signal FDRE_Reset              : std_logic;
signal FDRE_SeqAddr_BusLock_Reset: std_logic;
signal Incr_N_Load             : std_logic;
signal FDRE_MA2SA_Rd_Reset     : std_logic;
signal Get_off_OPB_nxt_clk     : std_logic;
signal Clear_SeqAddr_BusLock   : std_logic;
signal Mst_rd_starting_pulse   : std_logic;
signal be_fifo_wr              : std_logic;
signal ma2sa_rd_i              : std_logic;
signal bus_mngrant_i           : std_logic;
signal mn_request_i            : std_logic;
signal be_fifo_bu   : std_logic_vector(0 to 3 --ToDo, eventually from generics
                                      ) := "0000";

signal loadable_Bus_Addr            : std_logic_vector(0 to C_OPB_ABUS_WIDTH-1);
signal mn_abus_i                    : std_logic_vector(0 to C_OPB_ABUS_WIDTH-1);
signal mn_abus_shadow               : std_logic_vector(0 to C_OPB_ABUS_WIDTH-1);
signal retained_state_retry_active    : std_logic;
signal retained_state_retry_active_p1 : std_logic;
signal FDRE_CE_d1                     : std_logic;
signal toggle_priority                : std_logic;
signal sa2ma_bufocc_eq0               : std_logic;
signal sa2ma_bufocc_eq1               : std_logic;
signal ipic_rd_was_retried            : std_logic;
signal all_buffered_data_written      : std_logic;
signal ma2sa_rd_i_set                 : std_logic;

signal bus2ip_msttimeout_i     : std_logic;

signal mn_seqaddr_cmb          : std_logic;
signal multiple_beats          : std_logic;


begin
--Combinatorial operations
Mstr_Sel_ma <= DMA_sel_IP_sel_not;
FDRE_CE <= bus_mngrant_i or MA2SA_XferAck_i;
MA2SA_XferAck <= MA2SA_XferAck_i;
Bus2IP_MstLastAck <= Bus2IP_MstLastAck_i;
sa2ma_bufocc_eq0 <= SA2MA_BufOccMinus1(0);
sa2ma_bufocc_eq1 <= bo2sl(SA2MA_BufOccMinus1(1 to 4) = "0000");

FDRE_Reset <= Get_off_OPB_nxt_clk or Reset_withNotReqs;

I_LUT4: LUT4
--Generate reset signal to force reset when master aborts request
   generic map(
      INIT => X"AAAE"
      )
   port map(
      O => Reset_withNotReqs,
      I0 => Reset,
      I1 => Xfer_in_progress,
      I2 => XXX2Bus_MstWrReq,
      I3 => XXX2Bus_MstRdReq
      );

Mn_ABus <= mn_abus_i;

I_Addr_ld_inc: entity opb_ipif_v2_00_h.addr_load_and_incr
--Instantiate module to load word address bus and increment when bursting
   generic map(
      C_BUS_WIDTH => C_OPB_ABUS_WIDTH-2
      )
    port map(
      Bus_Clk => OPB_Clk,
      FDRE_CE => FDRE_CE,
      FDRE_Reset => FDRE_Reset,
      Incr_N_Load => Incr_N_Load,
      Bus_input => loadable_Bus_Addr(0 to C_OPB_ABUS_WIDTH-3),
      Bus_output => mn_abus_i(0 to C_OPB_ABUS_WIDTH-3)
      );

Mn_ABus_byte_bits_vector_Generate_0: for j in C_OPB_ABUS_WIDTH-2 to 
                                              C_OPB_ABUS_WIDTH-2 generate
--Instantiate FF to load high byte-lane bit in 32-bit bus
   signal bit0 : std_logic;
   signal X : std_logic_vector(0 to 3);
begin
   X <= xxx2bus_mstbe_fifo;
   -- Hand optimized expression for the high bit of the four byte-lane case.
   -- True if the first bit of X, scanning from left to right, is 2 or 3.
   bit0 <=    ( not X(0) and not X(1)              and     X(3) )
           or ( not X(0) and not X(1) and     X(2)              );
   --
   I_FDRE: FDRE
   port map(
      Q => mn_abus_i(j),
      C => OPB_Clk,
      CE => FDRE_CE,
      D => bit0,
      R => FDRE_Reset
      );
end generate Mn_ABus_byte_bits_vector_Generate_0;


Mn_ABus_byte_bits_vector_Generate_1: for j in C_OPB_ABUS_WIDTH-1 to
                                             C_OPB_ABUS_WIDTH-1 generate
--Instantiate FF to load low byte-lane bit in 32-bit bus
   signal bit1 : std_logic;
   signal X : std_logic_vector(0 to 3);
begin
   X <= xxx2bus_mstbe_fifo;
   -- Hand optimized expression for the low bit of the four byte-lane case.
   -- True if the first bit of X, scanning from left to right, is 1 or 3.
   bit1 <=    ( not X(0) and     X(1)                           )
           or ( not X(0)              and not X(2) and     X(3) );
   --
   I_FDRE: FDRE
   port map(
      Q => mn_abus_i(j),
      C => OPB_Clk,
      CE => FDRE_CE,
      D => bit1,
      R => FDRE_Reset
      );
end generate Mn_ABus_byte_bits_vector_Generate_1;


--------------------------------------------------------------------------------
-- The update clock cycle for the mn_abus_shadow is one clock after the
-- update of mn_abus. This timing relationship is established here.
--------------------------------------------------------------------------------
I_RDRE_CE_D1: FDE
  port map(
     Q       => FDRE_CE_d1,
     D       => FDRE_CE,
     C       => OPB_Clk,
     CE      => '1'
  );

--------------------------------------------------------------------------------
-- Register to shadow the Mn_ABus; can be used to restore the address under
-- retained-state retry. All changes are shadowed except the clear caused by
-- FDRE_Reset for the purpose of releasing opb_abus.
--------------------------------------------------------------------------------
INCLUDE_MN_ABUS_SHADOW: if RETAIN_ADDRESS_OVER_RETRY generate
    MN_ABUS_SHADOW_GEN: for i in 0 to C_OPB_ABUS_WIDTH-1 generate
      FDE_I: FDE
        port map(
           Q       => mn_abus_shadow(i),
           D       => mn_abus_i(i),
           C       => OPB_Clk,
           CE      => FDRE_CE_d1
        );
    end generate;
end generate;


I_SeqAddr_BusLock_LUT2: LUT2
--Generate reset signal to force reset of Mn_SeqAddr and Mn_BusLock
   generic map(
      INIT => X"E"
      )
   port map(
      O => FDRE_SeqAddr_BusLock_Reset,
      I0 => FDRE_Reset,
      I1 => Clear_SeqAddr_BusLock
      );

I_FDRE_Mn_BusLock: FDRE
--Instantiate module to gate BusLock signal
   port map(
      Q => Mn_BusLock,
      C => OPB_Clk,
      CE => FDRE_CE,
      D => XXX2Bus_MstBusLock,
      R => FDRE_SeqAddr_BusLock_Reset
      );

MULTIPLE_BEATS_PROC : process(OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk = '1' then
        if Reset = '1' then
            multiple_beats   <= '0';
        elsif SA2MA_RdRdy = '1' then
            multiple_beats   <=     not sa2ma_bufocc_eq0
                                and not sa2ma_bufocc_eq1; -- Two or more
                                  -- beats have been buffered for
                                  -- transfer to the OPB.
        end if;
    end if;
end process;

mn_seqaddr_cmb <=     XXX2Bus_MstBurst
                  and (    XXX2Bus_MstRdReq
                        or multiple_beats
                      );

I_FDRE_Mn_SeqAddr: FDRE
--Instantiate module to gate Sequential address signal
   port map(
      Q => Mn_SeqAddr,
      C => OPB_Clk,
      CE => FDRE_CE,
      D => mn_seqaddr_cmb,
      R => FDRE_SeqAddr_BusLock_Reset
      );

Set_RNW_signal_PROCESS: process(XXX2Bus_MstRdReq)
--Process to set XXX2Bus_RNW
begin
   if(XXX2Bus_MstRdReq = '1') then
      XXX2Bus_RNW <= '1';
   else
      XXX2Bus_RNW <= '0';
   end if;
end process Set_RNW_signal_PROCESS;

I_FDRE_Mn_RNW: FDRE
--Instantiate module to gate RNW signal
   port map(
      Q => Mn_RNW,
      C => OPB_Clk,
      CE => FDRE_CE,
      D => XXX2Bus_RNW,
      R => FDRE_Reset
      );

Bit_Enable_vector_Generate: for j in 0 to C_OPB_DBUS_WIDTH/8-1 generate
--Instantiate modules to gate Byte enable signals
begin
   I_FDRE_Mn_BE: FDRE
   port map(
      Q => Mn_BE(j),
      C => OPB_Clk,
      CE => FDRE_CE,
      D => xxx2bus_mstbe_fifo(j),
      R => FDRE_Reset
      );
end generate Bit_Enable_vector_Generate;


MA2SA_RD_I_PROC : process (OPB_Clk)
begin
    if OPB_Clk'event and OPB_Clk = '1'  then
        if    FDRE_MA2SA_Rd_Reset = '1' then ma2sa_rd_i <= '0';
        elsif ma2sa_rd_i_set = '1'      then ma2sa_rd_i <= '1';
        else  null;
        end if;
    end if;
end process;

MA2SA_Rd <= ma2sa_rd_i;


FDRE_MA2SA_Rd_Reset <=    Reset_withNotReqs
                       or Bus2IP_MstLastAck_i
                       or Mst_SM_cs_EQ_Wait_state;


-- Instantiate the FIFO

be_fifo_wr <= SA2MA_FifoWr or Mst_rd_starting_pulse;

be_fifo_bu(0 to be_fifo_bu'length-2) <= (others => '0');
be_fifo_bu(be_fifo_bu'length-1) <= SA2MA_FifoBu;

--ToDo, eventually use a generic and generate to exclude
-- this fifo and associated logic when the system does not
-- use dynamic byte enables.
SLN_DBUS_FIFO: entity proc_common_v1_00_b.srl_fifo_rbu
  generic map (
    C_DWIDTH => C_OPB_DBUS_WIDTH/8,
    C_DEPTH  => 16
    )
  port map (
    Clk           => OPB_Clk,
    Reset         => Mst_SM_cs_EQ_Wait_state,
    FIFO_Write    => be_fifo_wr,
    Data_In       => XXX2Bus_MstBe,
    FIFO_Read     => SA2MA_FifoRd,
    Data_Out      => xxx2bus_mstbe_fifo,
    FIFO_Full     => open,
    FIFO_Empty    => open,
    Addr          => open,
    Num_To_Reread => be_fifo_bu,
    Underflow     => open,
    Overflow      => open
    );


    Bus_MnGrant <= bus_mngrant_i;
    Mn_Request <= mn_request_i;

--*************************************************
Include_IP_or_DMA_MUXing: if(not(C_DMA_ONLY) and not(C_IP_MSTR_ONLY)) generate
--Muxing of IP master or DMA master signals

    XXX2Bus_MstRdReq <= (    DMA_sel_IP_sel_not and DMA2Bus_MstRdReq) or
                        (not DMA_sel_IP_sel_not and  IP2Bus_MstRdReq);


    XXX2Bus_MstWrReq <= (    DMA_sel_IP_sel_not and DMA2Bus_MstWrReq) or
                        (not DMA_sel_IP_sel_not and  IP2Bus_MstWrReq);


    XXX2Bus_MstBurst <= (    DMA_sel_IP_sel_not and DMA2Bus_MstBurst) or
                        (not DMA_sel_IP_sel_not and  IP2Bus_MstBurst);


    XXX2Bus_MstBusLock <= XXX2Bus_MstBurst or
                          (    DMA_sel_IP_sel_not and DMA2Bus_MstBusLock) or
                          (not DMA_sel_IP_sel_not and  IP2Bus_MstBusLock);

   XXX2Bus_MstBE_vector_Generate: for j in 0 to C_OPB_DBUS_WIDTH/8-1 generate
   begin
     XXX2Bus_MstBE(j) <= DMA2Bus_MstBE(j) when (DMA_sel_IP_sel_not_p1) = '1'
                                          else
                         IP2Bus_MstBE(j);
   end generate XXX2Bus_MstBE_vector_Generate;


   XXX2Bus_MstABus_vector_Generate: for j in 0 to
      (C_OPB_ABUS_WIDTH-1) generate
   begin
      XXX2Bus_Addr(j) <= (    DMA_sel_IP_sel_not and DMA2Bus_Addr(j)) or
                         (not DMA_sel_IP_sel_not and  IP2Bus_Addr(j));
   end generate XXX2Bus_MstABus_vector_Generate;
end generate Include_IP_or_DMA_MUXing;

loadable_Bus_Addr <= mn_abus_shadow when RETAIN_ADDRESS_OVER_RETRY and
                                         retained_state_retry_active='1'
                     else
                     XXX2Bus_Addr;


DMA_Master_Only: if(C_DMA_ONLY) generate
begin
   XXX2Bus_MstRdReq <= DMA2Bus_MstRdReq;
   XXX2Bus_MstWrReq <= DMA2Bus_MstWrReq;
   XXX2Bus_Addr <= DMA2Bus_Addr;
   XXX2Bus_MstBE <= DMA2Bus_MstBE;
   XXX2Bus_MstBurst <= DMA2Bus_MstBurst;
   XXX2Bus_MstBusLock <= DMA2Bus_MstBusLock or DMA2Bus_MstBurst;
end generate DMA_Master_Only;

IP_Master_Only: if(C_IP_MSTR_ONLY) generate
begin
   XXX2Bus_MstRdReq <= IP2Bus_MstRdReq;
   XXX2Bus_MstWrReq <= IP2Bus_MstWrReq;
   XXX2Bus_Addr <= IP2Bus_Addr;
   XXX2Bus_MstBE <= IP2Bus_MstBE;
   XXX2Bus_MstBurst <= IP2Bus_MstBurst;
   XXX2Bus_MstBusLock <= IP2Bus_MstBusLock or IP2Bus_MstBurst;
end generate IP_Master_Only;


Set_Value_of_MA2SA_Num_PROCESS: process(
    DMA_sel_IP_sel_not, IP2Bus_MstBurst, DMA2Bus_MstNum
)
begin
  if(DMA_sel_IP_sel_not = '0') then
        MA2SA_Num_i <= (others => '0');
        MA2SA_Num_i(MA2SA_Num'right-3) <=     IP2Bus_MstBurst;
        MA2SA_Num_i(MA2SA_Num'right  ) <= not IP2Bus_MstBurst;
  else
        MA2SA_Num_i <= DMA2Bus_MstNum;
  end if;
end process Set_Value_of_MA2SA_Num_PROCESS;

MA2SA_Num <= MA2SA_Num_i;


No_Arbiter_DMA_Only: if(C_DMA_ONLY) generate
   --Fix DMA_sel_IP_sel_not if DMA only
begin
  DMA_sel_IP_sel_not    <= '1';
  DMA_sel_IP_sel_not_p1 <= '1';
  DMA_Request_HasPriority <= '1';
end generate No_Arbiter_DMA_Only;

No_Arbiter_IP_Master_Only: if(C_IP_MSTR_ONLY) generate
   --Fix DMA_sel_IP_sel_not if IP master only
begin
  DMA_sel_IP_sel_not    <= '0';
  DMA_sel_IP_sel_not_p1 <= '0';
  DMA_Request_HasPriority <= '0';
end generate No_Arbiter_IP_Master_Only;

Insert_Arbiter: if(not(C_DMA_ONLY) and not(C_IP_MSTR_ONLY)) generate
   Priority_Arbitration_PROCESS: process(OPB_Clk)
   --Process to set priority for IP and DMA requests that occur at the
   --same time
   begin
      if(OPB_Clk'event and OPB_Clk = '1') then
         -----------------------------------------------------------------------
         -- Keep track of priority.
         -----------------------------------------------------------------------
         if(Reset = RESET_ACTIVE) then
           DMA_Request_HasPriority <= '0';
         elsif toggle_priority = '1' then
           DMA_Request_HasPriority <= not(DMA_Request_HasPriority);
         elsif (C_MASTER_ARB_MODEL = DMA_PRIORITY) then
           DMA_Request_HasPriority <= '1';
         elsif (C_MASTER_ARB_MODEL = IP_PRIORITY) then
           DMA_Request_HasPriority <= '0';
         elsif (C_MASTER_ARB_MODEL = FAIR) and (Bus2IP_MstLastAck_i = '1') then
           DMA_Request_HasPriority <= not(DMA_sel_IP_sel_not);
         end if;
         -----------------------------------------------------------------------
         -- Master selection.
         -----------------------------------------------------------------------
      end if;
   end process Priority_Arbitration_PROCESS;

    DMA_sel_IP_sel_not_p1 <=

      not bo2sl(C_MASTER_ARB_MODEL = IP_PRIORITY)
      --
      when (Reset = RESET_ACTIVE) else               -- Reset condition


      (DMA2Bus_MstWrReq or (DMA2Bus_MstRdReq and not SA2MA_PostedWrInh)) and
      (DMA_Request_HasPriority or not (IP2Bus_MstWrReq or IP2Bus_MstRdReq))
      -------------------------------------------------------------
      -- Above, new value is true when
      -- DMA requesting and either DMA has priority or IP not
      -- requesting.
      -------------------------------------------------------------
      --
      when (Mst_SM_cs_EQ_Wait_For_Req and            -- Condition to compute new
            (DMA2Bus_MstWrReq or DMA2Bus_MstRdReq or
             IP2Bus_MstWrReq or IP2Bus_MstRdReq)
           ) = '1' else

      DMA_sel_IP_sel_not;                            -- Otherwise, retain state


    ARB_REG_PROC : process(OPB_Clk)
    begin
        if OPB_Clk'event and OPB_Clk = '1' then
            DMA_sel_IP_sel_not       <= DMA_sel_IP_sel_not_p1;
        end if;
    end process;

end generate Insert_Arbiter;


FSM_AND_RELATED_LOGIC: block

constant RESET_ACTIVE: std_logic := '1';

--signals
signal Mn_Select_i             : std_logic;
signal Mn_Select_p1            : std_logic;
signal Bus2IP_MstLastAck_i_p1: std_logic;
signal last_mstrd_burst_ack_d1 : std_logic;
signal Bus2IP_MstWrAck_ma_p1   : std_logic;
signal Bus2IP_MstRdAck_ma_p1   : std_logic;
signal Bus2IP_MstRdAck_ma_p1_d1: std_logic;
signal either_ack              : std_logic;
signal acks_left               : std_logic_vector(0 to C_MA2SA_NUM_WIDTH-1);
signal acks_left_eq1           : std_logic;
signal acks_left_eq2           : std_logic;
signal acks_left_ld            : std_logic;
signal Bus2IP_MstError_Flag    : std_logic;
signal bus2ip_mstretry_i       : std_logic;
signal bus2ip_mstretry_i_p1    : std_logic;
signal Mst_SM_cs_EQ_Wait_state_i : std_logic;

type Master_Attach_SMtype is (Wait_state,
                              Wait_For_Req,
                              Wait_for_RdRdy,
                              Mn_Req,
                              Burst_Count_Acks,
                              Check_Retry_Type
                             );

signal Mst_SM_cs, Mst_SM_ns : Master_Attach_SMtype;

begin
--Combinatorial operations
Incr_N_Load <= not bus_mngrant_i;
bus_mngrant_i <= OPB_MnGrant and mn_request_i;
MA2SA_XferAck_i <= OPB_XferAck and Mn_Select_i;
MA2SA_Retry   <= OPB_Retry and Mn_Select_i;
MA2SA_RSRA    <= retained_state_retry_active;
Mn_Select <= Mn_Select_i;
MA2SA_Select <= Mn_Select_i;
Mst_SM_cs_EQ_Wait_state <= Mst_SM_cs_EQ_Wait_state_i;
Bus2IP_MstError <= Bus2IP_MstError_Flag;
Get_off_OPB_nxt_clk <= not mn_select_p1;

-- State machine combinational process
Mst_SM: process (Mst_SM_cs, XXX2Bus_MstWrReq,
                 XXX2Bus_MstRdReq, SA2MA_RdRdy, OPB_TimeOut,
                 OPB_Retry, bus_mngrant_i, MA2SA_XferAck_i,
                 MA2SA_Num_i, Mn_Select_i,
                 bus2ip_msttimeout_i, Bus2IP_MstLastAck_i, Bus2IP_MstRetry_i,
                 DMA2Bus_MstRdReq, DMA2Bus_MstWrReq, SA2MA_PostedWrInh,
                 IP2Bus_MstRdReq, IP2Bus_MstWrReq, retained_state_retry_active,
                 SA2MA_TimeOut, acks_left_eq1, acks_left_eq2,
                 DMA_sel_IP_sel_not_p1,
                 ma2sa_rd_i, sa2ma_bufocc_eq0, sa2ma_bufocc_eq1, all_buffered_data_written)

  begin
      -- Set default values
      Mst_SM_ns <= Mst_SM_cs;
      mn_request_i <= '0';
      mn_select_p1  <= '0';
      Xfer_in_progress <= '1';
      Mst_SM_cs_EQ_Wait_state_i <= '0';
      Mst_SM_cs_EQ_Wait_For_Req <= '0';
      Clear_SeqAddr_BusLock <= '0';
      Mst_rd_starting_pulse <= '0';
      retained_state_retry_active_p1 <= retained_state_retry_active;
      toggle_priority <= '0';
      acks_left_ld <= '0';
      ma2sa_rd_i_set <= '0';
      case Mst_SM_cs is
         when Wait_state =>
            Mst_SM_ns <= Wait_For_Req;
            Clear_SeqAddr_BusLock <= '1';
            Mst_SM_cs_EQ_Wait_state_i <= '1';
            Xfer_in_progress <= '0';
            retained_state_retry_active_p1 <= '0';
         when Wait_For_Req =>
            Mst_SM_cs_EQ_Wait_For_Req <= '1';
            Xfer_in_progress <= '0';
            if ((not DMA_sel_IP_sel_not_p1 and IP2Bus_MstWrReq) or
                (    DMA_sel_IP_sel_not_p1 and DMA2Bus_MstWrReq)) = '1' then
               ma2sa_rd_i_set <= '1';
               Mst_SM_ns <= Wait_for_RdRdy;
            elsif ((not DMA_sel_IP_sel_not_p1 and IP2Bus_MstRdReq) or
                   (    DMA_sel_IP_sel_not_p1 and (DMA2Bus_MstRdReq and
                                                   not SA2MA_PostedWrInh))
                  ) = '1' then
               -- DMA reads do not proceed until posted writes
               -- can be accepted because the slave sets the rate
               -- for this data, which can be at one per clock.
               -- An IP master read proceeds without checking
               -- posted write inhibit, so, the IP master read request
               -- may occur only if IPIC posted writes will succeed and
               -- such posted writes will occur without regard to the
               -- state of the PostedWrInh signal.
               Mst_rd_starting_pulse <= '1';
               Mst_SM_ns <= Mn_Req;
            end if;
         when Wait_for_RdRdy =>
            if(SA2MA_RdRdy and not sa2ma_bufocc_eq0) = '1' then
               Mst_SM_ns <= Mn_Req;
            elsif (bus2ip_mstretry_i or bus2ip_msttimeout_i) = '1' then
               toggle_priority <= '1';
               Mst_SM_ns <= Wait_state;
            end if;
         when Mn_Req =>
            mn_request_i <= '1';
            acks_left_ld <= not retained_state_retry_active;
            if(bus_mngrant_i = '1') then
               Mst_SM_ns <= Burst_Count_Acks;
               mn_select_p1 <= '1';
            end if;  -- mn_request_i must deassert in response
                     -- to OPB_MnGrant to assure that bus_mngrant_i
                     -- is asserted for exactly one clock.
                     -- In this state bus_mngrant_i is asserted iff
                     -- OPB_MnGrant is asserted (since mn_request_i = '1').
         when Check_Retry_Type =>
                 if (XXX2Bus_MstRdReq or XXX2Bus_MstWrReq)='1' then
                     Mst_SM_ns <= Mn_Req;     -- Transaction continued.
                     retained_state_retry_active_p1 <= '1';
                 else
                     toggle_priority <= '1';
                     Mst_SM_ns <= Wait_state; -- Transaction aborted.
                 end if;
         when Burst_Count_Acks =>
            mn_select_p1 <= Mn_Select_i
                        and not (   (    MA2SA_XferAck_i   -- End transaction
                                     and (acks_left_eq1 or -- if done or ...
                                          (ma2sa_rd_i and sa2ma_bufocc_eq0)
                                         )
                                    )
                                 or OPB_Retry               -- retry response or
                                 or OPB_TimeOut             -- timeout response.
                                );
            if(bus2ip_mstretry_i = '1') then
               if not (ma2sa_rd_i and all_buffered_data_written) = '1' then
                 Mst_SM_ns <= Check_Retry_Type;
               else
                 toggle_priority <= '1';
                 Mst_SM_ns <= Wait_state;
               end if;
            elsif(bus2ip_msttimeout_i = '1') then
               Mst_SM_ns <= Wait_state;
            elsif(Bus2IP_MstLastAck_i = '1') then
               Mst_SM_ns <= Wait_state;
            end if;
            if(MA2SA_XferAck_i = '1') then
               if (acks_left_eq2 or (ma2sa_rd_i and sa2ma_bufocc_eq1)) = '1' then
                  Clear_SeqAddr_BusLock <= '1';
               end if;
            end if;
         when others =>
            Mst_SM_ns <= Wait_state;
      end case;
   end process Mst_SM;

Mst_SM_Reg: process (OPB_Clk)
  begin
     if (OPB_Clk'event and OPB_Clk = '1') then
       if (Reset_withNotReqs = RESET_ACTIVE) then
          Mst_SM_cs <= Wait_state;
       else
          Mst_SM_cs <= Mst_SM_ns;
       end if;
       retained_state_retry_active <= retained_state_retry_active_p1;
    end if;
end process Mst_SM_Reg;

ms_select_REG: process (OPB_Clk)
  begin
     if (OPB_Clk'event and OPB_Clk = '1') then
       if (Reset = RESET_ACTIVE) then
          Mn_Select_i <= '0';
       else
          Mn_Select_i <= mn_select_p1;
       end if;
    end if;
end process ms_select_REG;

Register_ErrAck_Flag_PROCESS: process (OPB_Clk)
begin
   if(OPB_Clk'event and OPB_Clk = '1') then
      if(Reset = RESET_ACTIVE or Mst_SM_cs_EQ_Wait_state_i = '1') then
         Bus2IP_MstError_Flag <= '0';
      elsif((OPB_ErrAck = '1' and Mn_Select_i = '1') or
            (SA2MA_Error = '1' and Xfer_in_progress = '1')) then
         Bus2IP_MstError_Flag <= '1';  -- Flag error to be noted with LastAck
                                       -- to local master
      end if;
   end if;
end process Register_ErrAck_Flag_PROCESS;

RETRY_HELP_PROC: process (OPB_Clk)
begin
   if(OPB_Clk'event and OPB_Clk = '1') then
      if (bus2ip_mstretry_i_p1 and Bus2IP_MstLastAck_i_p1) = '1' or
         (Reset = RESET_ACTIVE) then
           -- As bus2ip_mstretry_i is set, ipic_rd_was_retried is cleared. This
           -- makes bus2ip_mstretry_i a one-clock pulse when it is caused in part
           -- by ipic_rd_was_retried.
          ipic_rd_was_retried <= '0';
      elsif (SA2MA_RdRdy) = '1' then
          ipic_rd_was_retried <= SA2MA_Retry;
      end if;
      --
      if (SA2MA_RdRdy) = '1' or (Reset = RESET_ACTIVE) then
          all_buffered_data_written <= sa2ma_bufocc_eq0; -- If there is
          -- no buffered data at RdRdy, then there is none to write.
      elsif (sa2ma_bufocc_eq0 and MA2SA_XferAck_i) = '1' then -- This captures
          -- the point at which all buffered data is written because the
          -- buffer proper (fifo) is empty so the only word left is in
          -- the output register, and it is being ack'ed.
          all_buffered_data_written <= '1';
      end if;
   end if;
end process;

bus2ip_mstretry_i_p1 <= (OPB_Retry and Mn_Select_i) or
                        (ipic_rd_was_retried and all_buffered_data_written) or
                        (XXX2Bus_MstRdReq and SA2MA_Retry);

Register_OPB_Retry_PROCESS: process (OPB_Clk)
begin
   if(OPB_Clk'event and OPB_Clk = '1') then
      if(Reset = RESET_ACTIVE) then bus2ip_mstretry_i <= '0';
      else                          bus2ip_mstretry_i <= bus2ip_mstretry_i_p1;
      end if;
   end if;
end process Register_OPB_Retry_PROCESS;

Bus2IP_MstRetry <= bus2ip_mstretry_i;

Register_Time_Out_PROCESS: process (OPB_Clk)
begin
   if(OPB_Clk'event and OPB_Clk = '1') then
      if(Reset = RESET_ACTIVE) then
         bus2ip_msttimeout_i <= '0';
      else
         bus2ip_msttimeout_i <= (OPB_TimeOut and Mn_Select_i) or SA2MA_TimeOut;
      end if;
   end if;
end process Register_Time_Out_PROCESS;

Bus2IP_MstTimeOut <= bus2ip_msttimeout_i;

  either_ack <= Bus2IP_MstRdAck_ma_p1 or Bus2IP_MstWrAck_ma_p1;
  --
  ACKS_LEFT_I : entity proc_common_v1_00_b.ld_arith_reg
    generic map (
        C_ADD_SUB_NOT => false,
        C_REG_WIDTH   => MA2SA_Num_i'length,
        C_RESET_VALUE => ZEROES(0 to MA2SA_Num_i'length-1),
        C_LD_WIDTH   => MA2SA_Num_i'length,
        C_AD_WIDTH   => 1
    )
    port map (
        CK     => OPB_Clk,
        RST    => '0',
        Q      => acks_left,
        LD     => MA2SA_Num_i,
        AD     => "1",
        LOAD   => acks_left_ld,
        OP     => either_ack
    );
  --
  acks_left_eq1 <= bo2sl(UNSIGNED(acks_left) = 1);
  acks_left_eq2 <= bo2sl(UNSIGNED(acks_left) = 2);

Mst_Ack_COMB_PROCESS: process(XXX2Bus_MstRdReq, XXX2Bus_MstWrReq,
                              XXX2Bus_MstBurst,
                              SA2MA_WrAck, MA2SA_XferAck_i,
                              acks_left_eq1, acks_left_eq2, MA2SA_Num_i)
begin
      Bus2IP_MstWrAck_ma_p1 <= '0';
      Bus2IP_MstRdAck_ma_p1 <= '0';
      if(XXX2Bus_MstRdReq = '1') then
         if(XXX2Bus_MstBurst = '1') then  --Fire and forget with Burst
            Bus2IP_MstRdAck_ma_p1 <= MA2SA_XferAck_i;
         else                             --Wait for local Write Ack
            Bus2IP_MstRdAck_ma_p1 <= SA2MA_WrAck;  --when single Xfer
         end if;
      elsif(XXX2Bus_MstWrReq = '1') then
         Bus2IP_MstWrAck_ma_p1 <= MA2SA_XferAck_i;
      end if;
end process Mst_Ack_COMB_PROCESS;

RD_BURST_ACK_DELAY_PROC : process (OPB_Clk)
begin
  if OPB_Clk'event and OPB_Clk = '1' then
    Bus2IP_MstRdAck_ma_p1_d1 <= Bus2IP_MstRdAck_ma_p1;
    last_mstrd_burst_ack_d1 <= XXX2Bus_MstRdReq and XXX2Bus_MstBurst and
                               MA2SA_XferAck_i and acks_left_eq1;
  end if;
end process;

    Bus2IP_MstLastAck_i_p1 <=    last_mstrd_burst_ack_d1  -- When MstRd, burst
                              or (    XXX2Bus_MstRdReq
                                  and not XXX2Bus_MstBurst
                                  and SA2MA_WrAck         -- When MstRd, ~burst
                                  and acks_left_eq1)
                              or (    XXX2Bus_MstWrReq
                                  and MA2SA_XferAck_i     -- When MstWr
                                  and acks_left_eq1)
                              or (    bus2ip_mstretry_i_p1 -- When retry
                                  and (   (    XXX2Bus_MstWrReq
                                           and all_buffered_data_written)
                                       or (    XXX2Bus_MstRdReq
                                           and SA2MA_Retry)));
                                  -- Note, for retries Bus2IP_MstLastAck serves
                                  -- as a qualifier. It is asserted iff
                                  -- no data is "in limbo", i.e. all data that
                                  -- has been read from the IPIC/OPB has
                                  -- been written to the OPB/IPIC or that
                                  -- any read data that has been discarded
                                  -- is rereadable (aka idempotent,
                                  -- non-destructive readable, pre-fetchable).
                                  -- For loccally mastered writes,
                                  -- (XXX2Bus_MstWrReq = '1'), Bus2IP_MstLastAck
                                  -- is asserted iff buffered data has been
                                  -- written.
                                  -- For loccally mastered reads,
                                  -- (XXX2Bus_MstRdReq = '1'), Bus2IP_MstLastAck
                                  -- is always asserted even though the data read
                                  -- from the OPB (and not accepted by the IPIC)
                                  -- is discarded. The consequence is that any
                                  -- OPB data read as the first part of a locally
                                  -- mastered read operation must either be
                                  -- re-readable or there must be a guarantee
                                  -- that the IPIC will not refuse it by
                                  -- replying with retry.



MSTLASTACK_REG_PROCESS: process(OPB_Clk)
begin
   if(OPB_Clk'event and OPB_Clk = '1') then
      if(Reset = RESET_ACTIVE) then         --Synchronous Reset
         Bus2IP_MstLastAck_i <= '0';
      else
         Bus2IP_MstLastAck_i <= Bus2IP_MstLastAck_i_p1;
      end if;
   end if;
end process;


Mst_Ack_REG_PROCESS: process(OPB_Clk)
begin
   if(OPB_Clk'event and OPB_Clk = '1') then
      if(Reset = RESET_ACTIVE) then         --Synchronous Reset
         Bus2IP_MstRdAck_ma    <= '0';
         Bus2IP_MstWrAck_ma    <= '0';
      else
         Bus2IP_MstWrAck_ma    <= Bus2IP_MstWrAck_ma_p1;
         if (XXX2Bus_MstRdReq and XXX2Bus_MstBurst) = '0' then
             Bus2IP_MstRdAck_ma    <= Bus2IP_MstRdAck_ma_p1;
         else
             Bus2IP_MstRdAck_ma    <= Bus2IP_MstRdAck_ma_p1_d1;
         end if;
      end if;
   end if;
end process Mst_Ack_REG_PROCESS;


end block FSM_AND_RELATED_LOGIC;
---
end implementation;
