-------------------------------------------------------------------------------
-- $Id: opb_slave.vhd,v 1.1.2.1 2008/12/17 19:04:49 mlovejoy Exp $
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
-- Filename:        opb_slave.vhd
--
-- Description:     This block maintains state about the current status of
--                  plbv46 write operations, the state of plbv46 read
--                  operations and the availability of prefetch data in the
--                  LocalLink read buffer. It also provides a transaction
--                  timeout timer in the event that read data is never claimed
--                  or write data can't make it onto the PLBv46 bus.
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
--   MLL   12/17/2008       Legal header updated and Changelog
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
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY proc_common_v3_00_a;
USE proc_common_v3_00_a.family.ALL;  -- need C_FAMILY definitions

-------------------------------------------------------------------------------
ENTITY opb_slave IS
   
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
      C_BUS_CLOCK_PERIOD_RATIO : integer RANGE 1 TO 2 := 1;

      -- PLB I/O Specification            
      C_FAMILY : string := "virtex4"  -- Xilinx FPGA Family  Type spartan3, virtex4,virtex5   
      );

   PORT (

      -- OPB slave to Bridge Interface 
      brdg_block           : IN  std_logic;  -- bridge block
      brdg_prefetch_cmplt  : IN  std_logic;  -- bridge prefetch complete
      brdg_prefetch_status : IN  std_logic;  -- bridge prefetch status
      opbs_prefetch_req    : OUT std_logic;  -- opb slave prefetch request
      opbs_type            : OUT std_logic;  -- opb slave transaction request type
      opbs_prefetch_clr    : OUT std_logic;  -- opb slave prefetch clear
      opbs_postedwr_clr    : OUT  std_logic;  -- opb slave posted write clear
      opbs_trans_addr      : OUT std_logic_vector(0 TO 31);  -- opb slave transaction address
      opbs_length          : OUT std_logic_vector(0 TO 11);  -- opb slave transaction length
      opbs_postedwrt_req   : OUT std_logic;  -- opb slave posted write request
      opbs_be              : OUT std_logic_vector(0 TO 3);  -- opb slave byte enable

      -- Local Link Read Buffer
      bfs_data      : IN  std_logic_vector(0 TO 31);  -- Read data output to user logic
      bfs_sof_n     : IN  std_logic;  -- Active low signal indicating the starting data beat of a read local link transfer (unused by slave)
      bfs_eof_n     : IN  std_logic;  -- Active low signal indicating the ending data beat of a Read local link transfer. (Unused by slave)
      bfs_src_rdy_n : IN  std_logic;  -- Asserts active low to indicate the presence of valid data on signal bfs_data.
      bfs_src_dsc_n : IN  std_logic;  -- Active low signal indicating that the read local link source (master) needs to discontinue the transfer. (Unused. Drive high)
      bfs_dst_rdy_n : OUT std_logic;  -- Destination (ie the slave) asserts active low to signal it is ready to take valid data on bfs_data.
      bfs_dst_dsc_n : OUT std_logic;  -- Active low signal that the read local link destination needs to discontinue the transfer.

      -- Local Link Write Buffer
      bfd_data      : OUT std_logic_vector(0 TO 31);
      bfd_sof_n     : OUT std_logic;
      bfd_eof_n     : OUT std_logic;
      bfd_src_rdy_n : OUT std_logic;
      bfd_src_dsc_n : OUT std_logic;
      bfd_dst_rdy_n : IN  std_logic;
      bfd_dst_dsc_n : IN  std_logic;

      -- OPB Slave Interface
      OPB_Select  : IN  std_logic;  -- OPB Master select
      OPB_RNW     : IN  std_logic;  -- OPB Read not Write
      OPB_BE      : IN  std_logic_vector(0 TO (32/8)-1);  -- OPB transaction byte enables
      OPB_seqAddr : IN  std_logic;  -- OPB sequential address
      OPB_DBus    : IN  std_logic_vector(0 TO 32-1);  -- OPB master data bus
      OPB_ABus    : IN  std_logic_vector(0 TO 32-1);  -- OPB Slave address bus
      Sl_xferAck  : OUT std_logic;  -- OPB Slave transfer acknowledgement
      Sl_errAck   : OUT std_logic;  -- OPB Slave transaction error acknowledgement
      Sl_retry    : OUT std_logic;  -- OPB Slave transaction retry
      Sl_ToutSup  : OUT std_logic;  -- OPB Slave timeout suppress
      Sl_DBus     : OUT std_logic_vector(0 TO 32-1);  -- OPB Slave data bus

      -- System Interface
      MPLB_rst : IN std_logic;  --   plb reset
      MPLB_clk : IN std_logic;  --   plb clock
      SOPB_rst : IN std_logic;  --   OPB reset
      SOPB_clk : IN std_logic   -- OPB clock

      );
END ENTITY opb_slave;

LIBRARY ieee;
USE ieee.numeric_std.ALL;

ARCHITECTURE syn OF opb_slave IS

   -- Asserts high when OPB_ABus matches one of the proscribed address ranges
   SIGNAL arng_match_ns : std_logic;  -- address range match 

   -- Max Number of words that can be read or written in PLBv46 master burst
   -- transaction. This becomes the ack_count as the burst is processed.
   SIGNAL max_words_ns               : unsigned(0 TO 5-1);
   SIGNAL ack_count_ns, ack_count_cs : unsigned(0 TO 5-1);

   SIGNAL transaction_addr_cs         : std_logic_vector(0 TO 31);
   SIGNAL transaction_be_cs           : std_logic_vector(0 TO 3);
   SIGNAL capture_transaction_addr_ns : std_logic;
   SIGNAL prefetch_match_ns           : std_logic;
   SIGNAL post_writedata_ns           : std_logic;
   SIGNAL accept_trans_ns             : std_logic;  -- accept transaction
   SIGNAL deny_trans_ns               : std_logic;  -- deny transaction
   SIGNAL retry_read_prefetch_ns, retry_read_prefetch_cs     : std_logic;

   SIGNAL opbs_postedwrt_req_ns, opbs_postedwrt_req_cs : std_logic;
   SIGNAL opbs_prefetch_clr_ns , opbs_prefetch_clr_cs  : std_logic;
   SIGNAL opbs_postedwr_clr_ns , opbs_postedwr_clr_cs  : std_logic;
   SIGNAL opbs_prefetch_req_ns , opbs_prefetch_req_cs  : std_logic;
   SIGNAL opbs_type_ns , opbs_type_cs                  : std_logic;
   SIGNAL opbs_length_ns , opbs_length_cs              : unsigned(0 TO 11);

   SIGNAL Sl_xferAck_ns, Sl_xferAck_cs : std_logic;
   SIGNAL Sl_errAck_ns , Sl_errAck_cs  : std_logic;
   SIGNAL Sl_retry_ns , Sl_retry_cs    : std_logic;

   SIGNAL bfs_dst_rdy_n_ns, bfs_dst_rdy_n_cs : std_logic;
   SIGNAL bfs_data_cs                        : std_logic_vector(0 TO 32-1);

   SIGNAL bfd_sof_n_ns, bfd_sof_n_cs         : std_logic;
   SIGNAL bfd_eof_n_ns, bfd_eof_n_cs         : std_logic;
   SIGNAL bfd_src_rdy_n_ns, bfd_src_rdy_n_cs : std_logic;
   SIGNAL bfd_data_cs                        : std_logic_vector(0 TO 32-1);
   
   
BEGIN

   ----------------------------------------------------------------------------
   -- ABUS_DECODE
   --
   -- An internal block rather then an external block (entity+arch) makes good
   -- sense here because the internal workings are relevant to the state
   -- machine operation. Placing the logic externally makes the guts harder to
   -- reference. Plus we get a new namespace for the necessary
   -- functions+signals. 
   ----------------------------------------------------------------------------
   abus_decode : BLOCK IS
      --
      -- 0                                 31
      -- |                                 |
      -- +---------------------------------+
      -- |         j   |            k      | OPB_Abus breakdown
      -- +---------------------------------+
      -- | Bits to     |   memory range    |                  
      -- | Compare     |    block size     |
      
      FUNCTION Addr_Bits (x, y : std_logic_vector(0 TO 32-1))
      -- Find the number of unique address bits necessary for an address range.
      -- This is equal to (32 - block size). For example baseaddr=0x0f00_0000 and
      -- highaddr=0x0fff_ffff then the first '1' bit of the xor operation is found at
      -- bit index 8. The block size is therefore 2**(32-8) = 2**24.
      RETURN integer IS
      VARIABLE addr_nor        : std_logic_vector(0 TO 32-1);
   BEGIN
      addr_nor := x XOR y;
      FOR i IN 0 TO 32-1 LOOP
         IF addr_nor(i) = '1' THEN
            RETURN i;
         END IF;
      END LOOP;
      --coverage off
      RETURN(32);
      --coverage on
   END FUNCTION Addr_Bits;

   FUNCTION min_j (
      CONSTANT j0, j1, j2, j3 :    integer RANGE 0 TO 32;
      CONSTANT C_NUM_ADDR_RNG : IN integer)
      RETURN integer IS
      VARIABLE m : integer := 33;
      -- The min_j function returns the minimum number of bits used in an address
      -- range size calculation amongst the four address ranges. A given "J"
      -- value can only participate in the MIN operation if it is enabled. That
      -- means C_NUM_ADDR_RNG is high enough to include the given J sub n. 
   BEGIN
      IF (j0 < m AND C_NUM_ADDR_RNG >= 1) THEN m := j0; END IF;
      --coverage off
      IF (j1 < m AND C_NUM_ADDR_RNG >= 2) THEN m := j1; END IF;
      IF (j2 < m AND C_NUM_ADDR_RNG >= 3) THEN m := j2; END IF;
      IF (j3 < m AND C_NUM_ADDR_RNG >= 4) THEN m := j3; END IF;
      --coverage on
      RETURN m;
   END FUNCTION min_j;

   FUNCTION abus_match (
      SIGNAL   opb_abus     : std_logic_vector;
      CONSTANT baseaddr     : std_logic_vector;
      CONSTANT j            : integer RANGE 0 TO 32;
      CONSTANT num_addr_rng : integer RANGE 1 TO 4;
      CONSTANT rng_num      : integer RANGE 0 TO 3)
      RETURN std_logic IS
   BEGIN
      IF (rng_num < num_addr_rng) THEN
         -- The baseaddr is valid and can be used in matching. This is
         -- necessary because if the address pair isn't used the baseaddr and
         -- highaddr don't require values that make sense. This condition
         -- protects the elaboration from bad vector ranges.
         IF (j = 0) THEN
            -- This is the degenerate matching case. it implies that the
            -- range is the entire 32-bits so any address will be in the
            -- baseaddr to highaddr range.
            --coverage off
            RETURN '1';
            --coverage on
         ELSE
            IF (OPB_ABus(0 TO j-1) = baseaddr(0 TO J-1)) THEN
               RETURN '1';
            ELSE
               RETURN '0';
            END IF;
         END IF;
      ELSE
         -- baseaddr+highaddr pair isn't in use so no match possible.
         RETURN '0';
      END IF;

   END FUNCTION abus_match;

   CONSTANT j0 : integer := addr_bits(C_RNG0_BASEADDR, C_RNG0_HIGHADDR);
   CONSTANT j1 : integer := addr_bits(C_RNG1_BASEADDR, C_RNG1_HIGHADDR);
   CONSTANT j2 : integer := addr_bits(C_RNG2_BASEADDR, C_RNG2_HIGHADDR);
   CONSTANT j3 : integer := addr_bits(C_RNG3_BASEADDR, C_RNG3_HIGHADDR);

   CONSTANT minimum_j : integer := min_j(j0, j1, j2, j3, C_NUM_ADDR_RNG);
   CONSTANT maximum_k : integer := 32-minimum_j;

   CONSTANT d                 : std_logic_vector(0 TO 32*4-1) := C_RNG0_HIGHADDR & C_RNG1_HIGHADDR & C_RNG2_HIGHADDR & C_RNG3_HIGHADDR;
   SIGNAL   highaddr_ns, highaddr_cs          : std_logic_vector(0 TO 32-1);  -- selected high addr range value
   SIGNAL   s                 : std_logic_vector(0 TO 4-1);
   -- Max K size is when rng is 0 to FFFFFFFF. So the max number of words is
   -- 2^(32-2). However, the length is 1-based. IE 1 to 16 not 0 to 15. So we
   -- need one more bit to represent the actual number of words. (The decimal
   -- value 16 requires 5-bits to represent 10000=16). So the expression for the
   -- width must be 2^(32-2+1)
   SIGNAL   words_to_highaddr : unsigned(1 TO maximum_k-2+1);  -- Dealing in words so need -2
   SIGNAL   OPB_ABus_dly1     : std_logic_vector(0 TO 31);

   BEGIN
      
      ASSERT FALSE REPORT "C_NUM_ADDR_RNG = " & integer'image(C_NUM_ADDR_RNG) SEVERITY NOTE;
      ASSERT C_NUM_ADDR_RNG < 1 REPORT "rng0 bits to match j0 = " & integer'image(j0) SEVERITY NOTE;
      ASSERT C_NUM_ADDR_RNG < 2 REPORT "rng1 bits to match j1 = " & integer'image(j1) SEVERITY NOTE;
      ASSERT C_NUM_ADDR_RNG < 3 REPORT "rng2 bits to match j2 = " & integer'image(j2) SEVERITY NOTE;
      ASSERT C_NUM_ADDR_RNG < 4 REPORT "rng3 bits to match j3 = " & integer'image(j3) SEVERITY NOTE;
      ASSERT FALSE REPORT "minimum j = " & integer'image(minimum_j) SEVERITY NOTE;
      ASSERT FALSE REPORT "maximum k = " & integer'image(maximum_k) SEVERITY NOTE;
      --coverage off
      ASSERT (maximum_k >= 6) 
         REPORT "The smallest address range must be greater then or equal to 64 bytes in size" 
         SEVERITY error;
      --coverage on
      
      abus_reg : PROCESS (SOPB_clk, SOPB_rst) IS
      BEGIN
         IF (SOPB_rst = '1') THEN
            OPB_ABus_dly1 <= (OTHERS => '0');
         ELSIF (rising_edge(SOPB_clk)) THEN
            OPB_ABus_dly1 <= OPB_ABus;
         END IF;
      END PROCESS abus_reg;

      -- The address ranges are supposed to be non-overlapping so these
      -- comparisons result in a one-hot (or no-hot) signal.
      s(0) <= abus_match(OPB_ABus_dly1, C_RNG0_BASEADDR, J0, C_NUM_ADDR_RNG, 0);
      s(1) <= abus_match(OPB_ABus_dly1, C_RNG1_BASEADDR, J1, C_NUM_ADDR_RNG, 1);
      s(2) <= abus_match(OPB_ABus_dly1, C_RNG2_BASEADDR, J2, C_NUM_ADDR_RNG, 2);
      s(3) <= abus_match(OPB_ABus_dly1, C_RNG3_BASEADDR, J3, C_NUM_ADDR_RNG, 3);

      arng_match_ns <= s(0) OR s(1) OR s(2) OR s(3);

      x_mux_onehot_f : ENTITY proc_common_v3_00_a.mux_onehot_f
         GENERIC MAP (
            C_DW     => 32,        -- [integer]
            C_NB     => 4,         -- [integer]
            C_FAMILY => C_FAMILY)  -- [string]
         PORT MAP (
            D => D,                -- [in  std_logic_vector(0 to C_DW*C_NB-1)]
            S => S,                -- [in  std_logic_vector(0 to C_NB-1)]
            Y => highaddr_ns);        -- [out std_logic_vector(0 to C_DW-1)]




      wha_reg : PROCESS (SOPB_clk, SOPB_rst) IS
         -- The transaction address register does double duty. It gets captured
         -- at a read prefetch or at the start of a write. 
      BEGIN
         IF (SOPB_rst = '1') THEN
            words_to_highaddr <= (OTHERS => '0');
            highaddr_cs <= (others => '0');
         ELSIF (rising_edge(SOPB_clk)) THEN
            -- This is kind of a mystical expression. The goal is to count the number
            -- of words using the smallest size subtractor that will work
            -- irrespective of the size of the address range block of the address
            -- range that matched the incoming OPB_ABus value. The one hot mux
            -- selects amongst the high addr range constants based on which addr
            -- range matched. The "-2" in the express insures that words are
            -- counted and not bytes. The "+ 1" is because the count is used in the
            -- command request to the plbv46_master and it requires a non-zero based count.
            words_to_highaddr <= unsigned('0'&highaddr_cs(minimum_j TO (32-1) -2))
                                 - unsigned('0'&OPB_ABus_dly1(minimum_j TO (32-1) -2))
                                 + 1;
            -- Pipelineing added to meet spartan3e timing requirements.
            highaddr_cs <= highaddr_ns;
         END IF;
      END PROCESS wha_reg;

      -- Now, the length of the desired read or write operation that will not
      -- overrun the end of the address range is given by min(16,
      -- words_to_highaddr). It is a min 16 operation because that is the
      -- largest prefetch read or posted write that can be done.
      -- Irregardless of the vector width of words_to_highaddr only the least
      -- significant 5 bits are needed.
      max_words_ns <= words_to_highaddr(maximum_k-2+1-4 TO maximum_k-2+1) WHEN 16 > words_to_highaddr ELSE
                      to_unsigned(16, 5) AFTER 1 NS;

      transAdr_reg : PROCESS (SOPB_clk, SOPB_rst) IS
         -- The transaction address register does double duty. It gets captured
         -- at a read prefetch or at the start of a write. 
      BEGIN
         IF (SOPB_rst = '1') THEN
            transaction_addr_cs <= (OTHERS => '0');
         ELSIF (rising_edge(SOPB_clk)) THEN
            IF (capture_transaction_addr_ns = '1') THEN
               transaction_addr_cs <= OPB_ABus;
               transaction_be_cs   <= OPB_BE;
            END IF;
         END IF;
      END PROCESS transAdr_reg;


      prefetch_match_ns <= '1' WHEN (OPB_ABus_dly1 = transaction_addr_cs)
                           AND brdg_prefetch_cmplt = '1' ELSE
                           '0';
      post_writedata_ns <= arng_match_ns AND NOT brdg_block AND NOT OPB_RNW;

      accept_trans_ns <= post_writedata_ns OR prefetch_match_ns;

      deny_trans_ns <= arng_match_ns AND brdg_block AND NOT brdg_prefetch_cmplt;

      retry_read_prefetch_ns <= arng_match_ns AND NOT brdg_block AND OPB_RNW;
      
   END BLOCK abus_decode;




-------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------
   sm : BLOCK IS
      TYPE   state_type IS (IDLE, DECODE, PIPEDLY1, PIPEDLY2, BURST1, BURST, SINGLE, RETRY);
      SIGNAL slave_ns, slave_cs : state_type;
   BEGIN

      NS : PROCESS (
         OPB_RNW, OPB_Select, OPB_seqAddr, Sl_errAck_cs, Sl_retry_cs,
         Sl_xferAck_cs, accept_trans_ns, ack_count_cs, bfd_dst_rdy_n,
         bfs_src_rdy_n, brdg_prefetch_status, brdg_prefetch_cmplt,
         deny_trans_ns, max_words_ns,
         opbs_length_cs, opbs_postedwr_clr_cs, opbs_postedwrt_req_cs,
         opbs_prefetch_clr_cs, opbs_prefetch_req_cs, opbs_type_cs,
         retry_read_prefetch_cs, retry_read_prefetch_ns, slave_cs) IS
         VARIABLE terminal_ack_count : std_logic;
      BEGIN
         slave_ns <= slave_cs;  -- Always hold state by default

         -- Always hold output state by default
         opbs_postedwrt_req_ns <= opbs_postedwrt_req_cs;
         opbs_prefetch_clr_ns  <= opbs_prefetch_clr_cs;
         opbs_postedwr_clr_ns  <= opbs_postedwr_clr_cs;
         opbs_prefetch_req_ns  <= opbs_prefetch_req_cs;
         opbs_type_ns          <= opbs_type_cs;
         opbs_length_ns        <= opbs_length_cs;
         ack_count_ns          <= ack_count_cs;

         capture_transaction_addr_ns <= '0';

         Sl_xferAck_ns <= Sl_xferAck_cs;
         Sl_errAck_ns  <= Sl_errAck_cs;
         Sl_retry_ns   <= Sl_retry_cs;

         bfs_dst_rdy_n_ns <= '1';
         --keep--bfd_src_rdy_n_ns <= '1';
         bfd_sof_n_ns     <= '1';
         bfd_eof_n_ns     <= '1';

         CASE slave_cs IS
            WHEN IDLE =>
               opbs_postedwrt_req_ns <= '0';
               opbs_prefetch_clr_ns  <= '0';
               opbs_postedwr_clr_ns  <= '0';
               opbs_prefetch_req_ns  <= '0';
               Sl_xferAck_ns         <= '0';
               Sl_errAck_ns          <= '0';
               Sl_retry_ns           <= '0';
               IF (OPB_Select = '1') THEN
                  slave_ns <= DECODE;
               END IF;
               
            WHEN DECODE =>
               -- This state is a pipeline delay to match the registering of OPB_ABus
               -- (which is necessary to allow enough cycle time for the
               -- combinatorial decode logic.)
               slave_ns <= PIPEDLY1;
               
            WHEN PIPEDLY1 =>
               -- This state is a pipeline delay to match the registering
               -- of the length calculation used in computing the number of
               -- words to the highaddr of the range. It also represents the
               -- delay on the pipeline stage on the input data bus OPB_data
               bfd_sof_n_ns <= '0';  -- will be first word if this is a write
               IF (NOT OPB_Select) = '1' THEN
                  -- Better luck next time
                  slave_ns <= IDLE;
               ELSIF (deny_trans_ns = '1') THEN
                  -- Better luck next time
                  Sl_retry_ns <= '1';
                  slave_ns    <= RETRY;
               ELSE
                  capture_transaction_addr_ns <= '1';
                  IF (retry_read_prefetch_ns = '1') THEN
                     -- We have a winner. Issue the prefetch request to the
                     -- bridge and retry the transaction to the OPB master.
                     -- If the OPB read request was issued with seqAddr de-asserted
                     -- then only request the plbv46_master_burst get a single
                     -- word as well. This is a fairly high probability
                     -- asssumption about the behaviour of Xilinx OPB masters.
                     Sl_retry_ns          <= '1';
                     opbs_type_ns         <= OPB_seqAddr;
                     slave_ns             <= PIPEDLY2;
                  ELSE
                     IF (accept_trans_ns = '1') THEN
                        -- Bridge is ready with prefetch data or waiting for a
                        -- full write buffer. 
                        Sl_retry_ns   <= '0';
                        -- Pass on read prefetch error status
                        Sl_errAck_ns  <= brdg_prefetch_status;
                        -- The expression should reduce to a '1' but is not
                        -- strictly reducible to a '1' at all time. This
                        -- might be a little overkill in trying to be too
                        -- precise but it exactly matches the necessary
                        -- LocalLink semantics. Note that the expression
                        -- should read (not bfd_dst_rdy_n and not
                        -- bfd_src_rdy_n) or (not bfs_dst_rdy_n and not
                        -- bfs_srcy_rdy_n). (Ignore the "nots" which are
                        -- appropriate for the active low signals when
                        -- reading this to understand.) Both terms just
                        -- state that a source & destination are ready so
                        -- the transfer can occur. That is what we need for
                        -- the acknowledgement!
                        -- Also, the OPB_seqAddr term is necessary for  writes
                        -- to prevent early assertion of the xferAck. This is a
                        -- nasty corner case protection term. When a burst
                        -- write is requested at the last word of a range the
                        -- only way to know is by checking the max transfer
                        -- count. That won't be available until after the
                        -- pipedly state (max_words is pipelined)
                        Sl_xferAck_ns <= (NOT bfd_dst_rdy_n AND NOT OPB_RNW AND NOT OPB_seqAddr)
                                         OR (OPB_RNW AND NOT bfs_src_rdy_n AND NOT OPB_seqAddr);
                        slave_ns <= PIPEDLY2;
                     ELSE
                        -- Just hang tight waiting for an address match or a
                        -- de-select or a prefetch match.
                        NULL;
                     END IF;
                  END IF;
               END IF;
               
            WHEN PIPEDLY2 =>
               -- This state is a pipeline delay to match the registering
               -- of the length calculation used in computing the number of
               -- words to the highaddr of the range.
               capture_transaction_addr_ns <= '0';
               IF (OPB_RNW = '1') THEN
                  -- The plbv46_master_burst ignores the IP2Bus_Mst_length WHEN
                  -- IP2Bus_Mst_type=0 indicating a single.
                  opbs_length_ns <= "00000" & max_words_ns & "00";
               ELSE
                  -- Pipelined, so starting with zero insures the proper count
                  -- at the end of the burst when the posted_wrt_req is made.
                  opbs_length_ns <= X"000";
               END IF;
               ack_count_ns     <= max_words_ns;
               --keep--bfd_src_rdy_n_ns <= '1';

               -- Use of the retry_read_prefetch_cs (registered) version of
               -- the combinatorial (_ns) signal eliminates a critical path on
               -- bfs_dst_rdy_n_ns which becomes a fifo read signal.
               IF (retry_read_prefetch_cs = '1') THEN
                  -- We have a winner. Issue the prefetch request to the
                  -- bridge and retry the transaction to the OPB master.
                  -- If the OPB read request was issued with seqAddr de-asserted
                  -- then only request the plbv46_master_burst get a single
                  -- word as well. This is a fairly high probability
                  -- asssumption about the behaviour of Xilinx OPB masters. The
                  -- prefetch request must assert here rather then in DECODE to
                  -- avoid a problem in 1:2 clock ratio mode where the
                  -- assertion caused the brdg_block to assert prematurely
                  -- (from the faster clock domain) thus cutting off
                  -- opbs_prefetch_req_ns before the PIPEDLY state was entered.
                  Sl_retry_ns          <= '0';
                  opbs_type_ns         <= OPB_seqAddr;
                  -- Don't issue the prefetch request if master aborts
                  -- transaction in this clock. (IE OPB_Select='0')
                  opbs_prefetch_req_ns <= OPB_Select;
                  slave_ns             <= IDLE;
               ELSE
                  -- For OPB Master aborts
                  --  1) the state transition must be to idle
                  --  2) the read prefetch buffer must not be touched and the
                  --     master must still come back and claim the data
                  --  3) Nothing has been written to the posted write buffer (bfd)
                  --     yet so it doesn't have to be cleared
                  --  4) prefetch buffer should be cleared since it has data in
                  --     it.
                  IF (OPB_seqAddr = '1') THEN
                     opbs_type_ns  <= '1';          -- specify a "burst"
                     -- Sl_xferAck_cs is qualified by opb_select for the abort
                     -- case elsewhere.
                     Sl_xferAck_ns <= (NOT bfd_dst_rdy_n AND NOT OPB_RNW)
                                      OR (OPB_RNW AND NOT bfs_src_rdy_n);
                     bfs_dst_rdy_n_ns <= NOT OPB_RNW;  --  ready to read data
                     IF (opb_select='1') THEN
                        slave_ns <= BURST1;
                     ELSE
                        slave_ns <= IDLE;
                     END IF;
                  ELSE
                     opbs_type_ns          <= '0';  -- specify a "single"
                     bfs_dst_rdy_n_ns      <= NOT OPB_RNW;  --  ready to read data
                     bfd_sof_n_ns          <= '0';  -- Is first since this is a single
                     bfd_eof_n_ns          <= '0';  -- Is last since this is a single
                     opbs_postedwrt_req_ns <= NOT OPB_RNW AND OPB_Select;
                     opbs_prefetch_clr_ns  <= '1';
                     Sl_xferAck_ns         <= '0';
                     IF (opb_select='1') THEN
                        slave_ns              <= SINGLE;
                     ELSE
                        slave_ns <= IDLE;
                     END IF;
                  END IF;
                  
               END IF;
               
            WHEN BURST1 =>
               opbs_length_ns <= opbs_length_cs + 4;  -- 1 word = 4 bytes
               ack_count_ns   <= ack_count_cs - 1;
               IF (NOT OPB_Select) = '1' THEN
                  -- Burst terminated prematurely (Master abort?)
                  Sl_retry_ns          <= '0';
                  Sl_xferAck_ns        <= '0';
                  opbs_prefetch_clr_ns <= OPB_RNW;
                  opbs_postedwr_clr_ns <= NOT OPB_RNW;
                  --keep--bfd_src_rdy_n_ns     <= '1';  -- clean shutdown of writes
                  bfs_dst_rdy_n_ns     <= '1';  -- although who cares! buffer is reset momentarily
                  slave_ns             <= IDLE;
               ELSE
                  Sl_retry_ns   <= '0';
                  Sl_xferAck_ns <= (NOT bfd_dst_rdy_n AND NOT OPB_RNW)
                                   OR (OPB_RNW AND NOT bfs_src_rdy_n);
                  bfs_dst_rdy_n_ns <= NOT OPB_RNW;    --  ready to read data
                  --keep--bfd_src_rdy_n_ns <= OPB_RNW;  --  ready to write
                  bfd_sof_n_ns     <= '0';
                  slave_ns         <= burst;
               END IF;
               
               
            WHEN BURST =>
               ack_count_ns   <= ack_count_cs - 1;
               IF (ack_count_cs = 1) THEN
                  terminal_ack_count := '1';
               ELSE
                  terminal_ack_count := '0';
               END IF;
               -- issue a retry if there isn't enough data in the fifo to
               -- satisfy the request. This might happen if a read meant to
               -- claim prefetch data has OPB_seqAddr asserted but the
               -- original read had OPB_seqAddr deasserted.
               Sl_retry_ns   <= '0';
               Sl_xferAck_ns <= (NOT bfd_dst_rdy_n AND NOT OPB_RNW)
                                OR (OPB_RNW AND NOT bfs_src_rdy_n);
               bfs_dst_rdy_n_ns <= NOT OPB_RNW;  --  ready to read data
               --keep--bfd_src_rdy_n_ns <= OPB_RNW;      --  ready to write
               bfd_sof_n_ns     <= '1';
               IF (terminal_ack_count='1' OR OPB_SeqAddr = '0' OR OPB_Select = '0') THEN
                  -- Since xferAck is pipelined (Sl_xferAck<=Sl_xferAck_cs)
                  -- the ack must turn off here for a burst otherwise it
                  -- will clobber the next back-to-back transaction.
                  -- (Supposedly the Xilinx OPB doesn't permit these type of
                  -- b2b transactions but they fail in simulation without
                  -- this.) The condition of OPB_Select=0 (master
                  -- abort) must be handled elsewhere by gating the registered
                  -- xferAck with OPB_Select.
                  Sl_xferAck_ns         <= '0';
                  -- HEY! This will be the last ack so make sure the Local Link
                  -- EOF is set properly. This only works for the lookahead
                  -- conditions (terminal_ack_count=1 or OPB_seqAddr=0). The
                  -- condition of OPB_Select=0 (master abort if no xferAcks
                  -- accepted yet) must be handled elsewhere by gating the
                  -- registered bfd_eof_n with OPB_Select.
                  bfd_eof_n_ns          <= '0';
                  --keep--bfd_src_rdy_n_ns      <= '1';  -- done w/ writing (using pipelined sig)
                  opbs_postedwrt_req_ns <=
                     -- brdg_prefetch_complete=1 would indicate that a read
                     -- burst was being satisfied. An opb master abort
                     -- typically causes OPB_RNW -> 0 which can cause an
                     -- unintentional opbs_postedwrt_req assertion in this
                     -- state because it thinks a write to the buffer is done.
                     -- The qualification by brdg_prefetch_complete rather then
                     -- opb_rnw will prevent that.
                     NOT brdg_prefetch_cmplt
                     AND (
                        -- Make request because
                        -- ... end of burst
                        (NOT OPB_seqAddr AND OPB_select)
                              -- ... master abort. Write data
                              -- already xferAck'd
                        OR (NOT OPB_Select)
                              -- ... buffer will
                              -- overflow if anymore accepted
                        OR (terminal_ack_count)
                        );
                  opbs_prefetch_clr_ns  <= '1';
                  slave_ns              <= IDLE;
                  IF (OPB_select)='1' THEN
                     opbs_length_ns <= opbs_length_cs + 4;  -- 1 word = 4 bytes
                  ELSE
                     -- master abort occured (IE OPB_Select dropped prior to
                     -- first xferAck) or the Master simply dropped OPB_Select
                     -- without first dropping OPB_seqAddr so the very last xferAck IS
                     -- disabled, and the last word is not written to the local
                     -- link destination buffer (bfd). So length should not get
                     -- incremented.
                     null;
                  END IF;
               ELSE
                  opbs_length_ns <= opbs_length_cs + 4;  -- 1 word = 4 bytes
               END IF;
               
            WHEN SINGLE =>
               opbs_prefetch_clr_ns  <= '1';
               opbs_postedwrt_req_ns <= '0';
               --keep--bfd_src_rdy_n_ns      <= '1';
               bfd_eof_n_ns          <= '0';
               bfs_dst_rdy_n_ns      <= '1';
               Sl_xferAck_ns         <= '0';
               Sl_retry_ns           <= '0';
               slave_ns              <= IDLE;

            WHEN RETRY =>
               -- This state is different then the SINGLE state in that the
               -- prefetch buffer is not cleared. A retry acknowledgement
               -- ends a transaction just like an xferAck does -- just
               -- nothing was transfered.
               Sl_retry_ns <= '0';
               slave_ns    <= IDLE;
               
            --coverage off
            WHEN OTHERS => NULL;
            --coverage on
         END CASE;
      END PROCESS NS;

      cs : PROCESS (SOPB_clk, SOPB_rst) IS
      BEGIN
         IF (SOPB_rst = '1') THEN
            slave_cs <= IDLE;

            ack_count_cs <= (OTHERS => '0');

            opbs_length_cs        <= (OTHERS => '0');
            opbs_prefetch_clr_cs  <= '0';
            opbs_prefetch_req_cs  <= '0';
            opbs_postedwrt_req_cs <= '0';
            opbs_type_cs          <= '0';

            Sl_xferAck_cs <= '0';
            Sl_errAck_cs  <= '0';
            Sl_retry_cs   <= '0';

            bfd_sof_n_cs     <= '1';
            bfd_eof_n_cs     <= '1';
            bfd_src_rdy_n_cs <= '1';

            retry_read_prefetch_cs <= '0';
            
         ELSIF (rising_edge(SOPB_clk)) THEN
            slave_cs <= slave_ns;

            ack_count_cs <= ack_count_ns;

            opbs_length_cs        <= opbs_length_ns;
            opbs_prefetch_clr_cs  <= opbs_prefetch_clr_ns;
            opbs_postedwr_clr_cs  <= opbs_postedwr_clr_ns;
            opbs_prefetch_req_cs  <= opbs_prefetch_req_ns;
            opbs_postedwrt_req_cs <= opbs_postedwrt_req_ns;
            opbs_type_cs          <= opbs_type_ns;

            Sl_xferAck_cs <= Sl_xferAck_ns;
            Sl_errAck_cs  <= Sl_errAck_ns;
            Sl_retry_cs   <= Sl_retry_ns;

            bfd_sof_n_cs     <= bfd_sof_n_ns;
            bfd_eof_n_cs     <= bfd_eof_n_ns;
            -- bfd_src_rdy_n_cs began to track the Sl_xferAck directly
            -- to avoid having the state machine manage it. A later bug
            -- fix identified the need to have xferAck drop with OPB_select
            -- deasserting (thus signaling an OPB master abort). This necessitated
            --  the addition of the OPB_select qualifier here as well. Otherwise,
            -- a bug is introduced where a word gets written into the
            -- destination buffer even though the xferAck got cut off. That
            -- extra word gums up the works for the next transfer.
            --keep--bfd_src_rdy_n_cs <= bfd_src_rdy_n_ns;
            bfd_src_rdy_n_cs <= NOT (Sl_xferAck_cs AND OPB_Select) OR OPB_RNW;

            -- Use of the registered version of the retry_read_prefetch SIGNAL
            -- eliminates a critical path inside the PIPEDLY state for reading
            -- data out of the Local Link buffer source (prefetch buffer).
            retry_read_prefetch_cs <= retry_read_prefetch_ns;
         END IF;
      END PROCESS cs;
      
   END BLOCK sm;

   bfs_dly1 : PROCESS (SOPB_clk) IS
   BEGIN
      -- The data from local link is registered here and qualified by the
      -- combinatorial slave xfer ack condition so that zero is driven when
      -- invalid data is present. bfs_data_cs drives the Sl_DBus directly so it
      -- must be zero at all other times to avoid clobbering data on the
      -- OPB_Dbus distributed to all other opb peripherals (including this one
      -- during write operations!) Note that the qualifier expression is
      -- redundant. sl_xferack_ns is already conditioned on opb_rnw but for
      -- both the read and write case. This redundancy will be removed during
      -- synthesis but is convienient here as the concept of sl_xferack as the
      -- qualifier is more clear then the underlying expression is.
      IF (rising_edge(SOPB_clk)) THEN
         IF ( (sl_xferack_ns AND OPB_rnw)='1') THEN
            bfs_data_cs <= bfs_data;
         ELSE
            bfs_data_cs <= (others => '0');
         END IF;
      END IF;
   END PROCESS bfs_dly1;

   bfd_dly1 : PROCESS (SOPB_clk) IS
   BEGIN
      IF (rising_edge(SOPB_clk)) THEN
         bfd_data_cs <= OPB_DBus;
      END IF;
   END PROCESS bfd_dly1;


----------------------------------------------------------------------------
-- Final output assignments from internal combinatorial or registered,
-- control or data paths.
----------------------------------------------------------------------------

   -- The slave acknowledgements must be registed by Xilinx convention.
   -- Unfortunately, to cover the Master abort case the ack's must be
   -- qualified by OPB_Select combinatorially. No way around this.
   Sl_xferAck <= Sl_xferAck_cs AND OPB_Select;
   Sl_errAck  <= Sl_errAck_cs AND OPB_Select;
   Sl_retry   <= Sl_retry_cs AND OPB_Select;
   -- Since the Xilinx implementation of the OPB BUS arbiter and bus structure
   -- differs then the true IBM implementation (in order to save on resources)
   -- the Sl_DBus must be qualified such that it is all '0' when this slave
   -- is not actively outputing data. The primary qualifier is thus Sl_xferAck.
   -- The qualification must include OPB_Select as well to account for the CASE
   -- of a master abort. bfs_data_cs includes a synchronous reset in the case
   -- that Sl_xferAck is deasserted or OPB_rnw=write.
   Sl_DBus    <= bfs_data_cs WHEN (OPB_Select)='1'
                 ELSE (OTHERS => '0');
   Sl_ToutSup <= '0';

-- The clr signal doesn't need clock domain transition pulse conditioning
-- because remaining on for two MPLB_clk periods (in 1:2 clock period ratio
-- situation) is not a problem. No read transaction can be activated in that
-- time period.
   opbs_prefetch_req <= opbs_prefetch_req_cs;

-- pass through - no cross domain conditioning required.
   opbs_trans_addr    <= transaction_addr_cs;
   opbs_be            <= transaction_be_cs;
   opbs_prefetch_clr  <= opbs_prefetch_clr_cs;
   opbs_postedwr_clr  <= opbs_postedwr_clr_cs;
   opbs_type          <= opbs_type_cs;
   opbs_length        <= std_logic_vector(opbs_length_cs);
   opbs_postedwrt_req <= opbs_postedwrt_req_cs;


-- LocalLink buffer destination (the posted write buffer) connections
   bfd_sof_n     <= bfd_sof_n_cs;
   -- This "or" gate ensures that, on occasion of na OPB master abort, the last 
   -- word of data put into the fifo has its end of frame flag set.
   bfd_eof_n     <= bfd_eof_n_cs AND OPB_select ;
   bfd_data      <= bfd_data_cs;
   bfd_src_dsc_n <= '1';      -- never DISCONNECT

   bfd_gen1 : IF (C_BUS_CLOCK_PERIOD_RATIO = 1) GENERATE
      -- The registered version of src_rdy is used to track the registered
      -- version of OPB_xferAck
      bfd_src_rdy_n <= bfd_src_rdy_n_cs;
   END GENERATE bfd_gen1;

   bfd_gen2 : IF (C_BUS_CLOCK_PERIOD_RATIO = 2) GENERATE

      -- This flip flop toggles for one MPLB_clk period whenver the SOPB_clk
      -- domain signal is asserted. Note that both signals are active low so an
      -- "OR" is used to be an active low input/output AND function.
      reg : PROCESS (MPLB_clk) IS
         VARIABLE reg_n : std_logic := '0';
      BEGIN
         IF (rising_edge(MPLB_clk)) THEN
            reg_n := NOT reg_n OR bfd_src_rdy_n_cs;
         END IF;
         bfd_src_rdy_n <= reg_n;
      END PROCESS reg;
   END GENERATE bfd_gen2;



   -- LocalLink buffer source (the read prefetch buffer) connections
   bfs_dst_dsc_n <= '1';      -- never DISCONNECT

   bfs_gen1 : IF (C_BUS_CLOCK_PERIOD_RATIO = 1) GENERATE
      bfs_dst_rdy_n <= bfs_dst_rdy_n_ns;
   END GENERATE bfs_gen1;

   bfs_gen2 : IF (C_BUS_CLOCK_PERIOD_RATIO = 2) GENERATE

      -- This flip flop toggles for one MPLB_clk period whenver the SOPB_clk
      -- domain signal is asserted. Note that both signals are active low so an
      -- "OR" is used to be an active low input/output AND function.
      reg : PROCESS (MPLB_clk) IS
         VARIABLE reg_n : std_logic := '0';
      BEGIN
         IF (rising_edge(MPLB_clk)) THEN
            reg_n := NOT reg_n OR bfs_dst_rdy_n_ns;
         END IF;
         bfs_dst_rdy_n <= reg_n;
      END PROCESS reg;
   END GENERATE bfs_gen2;
   
END ARCHITECTURE syn;
