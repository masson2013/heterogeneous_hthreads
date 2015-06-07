-------------------------------------------------------------------------------
-- $Id: opb_ipif.vhd,v 1.18 2004/11/23 01:04:03 jcanaris Exp $
-------------------------------------------------------------------------------
-- opb_ipif.vhd
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        opb_ipif.vhd
--
-- Description:     This is the top level design file for the OPB IPIF.
--                  It provides a standardized interface between the
--                  IP and the OPB Bus. It also provides data transfer support
--                  via DMA, Scatter/Gather, and fifo buffering.
--
--
-------------------------------------------------------------------------------
-- Structure:
--
--
--                  opb_ipif.vhd
--                    \
--                    \-- reset_control.vhd
--                    \      ipif_reset.vhd
--                    \
--                    \
--                    \-- interrupt_control.vhd
--                    \
--                    \-- bus2ip_amux.vhd
--                    \
--                    \-- ip2bus_dmux.vhd
--                    \      ip2bus_dmux.vhd
--                    \
--                    \-- ip2bus_srmux.vhd
--                    \      ip2bus_srmux.vhd
--                    \
--                    \-- address_decoder.vhd
--                    \
--                    \-- slave_attachment.vhd
--                    \
--                    \-- ipif_steer
--                    \
--                    \-- master_attachment.vhd
--                    \      mst_attach.vhd
--                    \
--                    \   dma_sg_pkg.vhd
--                    \   dma_sg_cmp.vhd
--                    \-- dma_sg.vhd
--                    \         dma_sg_sim.vhd
--                    \            srl_fifo.vhd
--                    \            ctrl_reg.vhd
--                    \            ld_arith_reg.vhd
--                    \
--                    \-- rdfifo.vhd
--                    \      rpfifo_top.vhd
--                    \          ipif_control_rd.vhd
--                    \          rdpfifo_dp_cntl.vhd
--                    \
--                    \          dp512x32_v3_2_rden_ve.edn
--                    \             or
--                    \          dp512x32_v3_2_rden_vii.edn
--                    \
--                    \
--                    \-- wrfifo.vhd
--                    \     wpfifo_top.vhd
--                    \          ipif_control_wr.vhd
--                    \          wrpfifo_dp_cntl.vhd
--                    \
--                    \          dp512x32_v3_2_rden_ve.edn
--                    \             or
--                    \          dp512x32_v3_2_rden_vii.edn
--
--
-------------------------------------------------------------------------------
-- @BEGIN_CHANGELOG EDK_Gm_SP2
--
-- FPGA families qvirtex2, qrvirtex2 and virtex4 supported.
--
-- Fixed problem with Mn_BE generation for mastered reads when both DMA
-- and IP masters are present.
--
-- Fixed problem where local master write data could get driven to OPB
-- during a slave write.
--
-- Added IPIC timeout for the local read phase of locally mastered write
-- transactions.
--
--  Drive the low-order two Mn_Abus bits to match the numerically lowest
--  Mn_BE bit that is asserted.
--
-- @END_CHANGELOG
-------------------------------------------------------------------------------
-- Author:      <Farrell Ostler, Mike Lovejoy, and Doug Thorpe>
--
-- History:
--
--  D. Thorpe   Aug-16-2001    -- Version v1.22a
--
--  DET         Aug-23-2001    -- no version change
--              - corrected some file header errors
--              - corrected some generic default values
--
--  DET         Aug-29-2001    -- no version change
--              - corrected the spelling of the C_VIRTEX_II parameter
--
--  FO          Sep-26-2001
--              - Adapted to the wrapper-removed, generic-adjusted
--                versions of slave_attachment and addr_decode generated
--                by AS.
--
--  ALS         Sep-27-2001
--              - added ipif_pkg which contains log2 function
--              - changed the address widths of SRAM, WRFIFO, and RDFIFO to
--                log2 of their size
--              - changed the data widths of SRAM, WRFIFO, and RDFIFO to
--                represent the number of bits instead of the number of bytes
--                and made these constants set to the C_IPIF_DBUS_WIDTH generic
--
--  FO          Oct-15-2001
--              - Simplified address calculations for generics.
--              - Removed dependency of arithmetic into msb to get past XST.
--
--  FO          Oct-16-2001
--              - Fixed assertion checking low-order zeroes for C_DEV_BASEADDR.
--
--  FO          Dec-03-2001
--              - Added a commented-out chipscope ILA at the bottom.
--
--  FO          Jan-02-2002
--              - General cleanup
--                  - Removal of un-needed comments.
--                  - Elimination Bus_Reset_i in favor of Reset.
--                  - Where possible made lower-level signal same as top-level
--                    signal.
--                  - Elimination of C_SL_ATT_ADDR_SEL_WIDTH parameter for sa.
--
--  FO          Apr-08-2002
--              - v2.00a version; has
--                  - Considerable signal renaming in ipif and submodules to
--                    improve naming consistency and remove some synonymous
--                    names.
--                  - Rework of the generics:
--                      - Address Range Definition (ARD) parameters
--                        implement the notion of generalized address
--                        ranges and properties.
--                      - DMA_SG generics now allow n channels of any of the
--                        four types.
--                      - Several other generic changes, also. See current
--                        generic set.
--                  - Bus2IP_Reg_rdCE, Bus2IP_Reg_WrCE and Bus2IP_SRAM_CE
--                    signals eliminated in favor of Bus2IP_CS, Bus2IP_CE,
--                    Bus2IP_RdCE and Bus2IP_WrCE, which are the decode
--                    signals for generalized Address Range Definitions.
--                  - Addr_decode replaced by address_decode, which handles
--                    the generalized address ranges.
--                  - Revised interrupt_control module instantiated, allow
--                    now for level interrrupts and general edge detect
--                    interrupts. Along with original pulse-detect interrupt
--                    signal type and true or complement polarity for
--                    each type, there are now 6 kinds of interrupt signals
--                    that can be specified for the IP2Bus_IntrEvent
--                    signals.
--                  - ipif_steer module added to allow for multiple IPIF
--                    dwidth sizes.
--
--  FO          Apr-08-2002        Synplify 6.2 workaround.
--                                 Removal of 'length and function calls
--                                 in component port declarations.
--
--  FO          Jun-04-2002
--              - Added generic C_ARD_DEPENDENT_PROPS_ARRAY and signal
--                IP2Bus_PostedWrInh. The function associated with
--                the signal is not yet implemented, however.
--
--  FO          Jun-06-2002
--              - Corrected WFIFO2IP_Occupancy and RFIFO2IP_Vacancy
--                to adjust their vector widths to the FIFO parameters
--                passed in through C_ARD_DEPENDENT_PROPS_ARRAY.
--
--  FO          Jun-07-2002
--              - Corrected the various vacancy and occupancy signals
--                to be compatible with FIFO capacity and read and
--                write width parameters.
--
--  FO          Jun-24-2002
--              - Added FIFO parameters for INCLUDE_PACKET_MODE
--                and INCLUDE_VACANCY.
--              - Implemented dynamic byte-enable capability.
--
--  FO          Aug-08-2002
--              - Fixed to set C_VIRTEX_II generic for FIFOs to true when
--                C_FAMILY is virtex2p.
--
--  FLO (FO)    Aug-12-2002
--              - Using bits_needed_for_vac and bits_needed_for_occ now
--                for vacancy and occupancy vecter-width calculations.
--
--  FLO         Aug-29-2002
--              - Up to now, the OPB_IPIF implementation has had a
--                wrapper that mapped a handful of boolean generics to
--                integers used as booleans. This was to comply with
--                some CoreGen restrictions on generics. The wrapper
--                was opb_ipif.vhd and it wrapped the implementation
--                in ipif.vhd.
--
--                Now, leaving opb_ipif.vhd as the top-level interface, the
--                extra level is removed and ipif.vhd is subsumed into
--                opb_ipif.vhd. This includes replacing the opb_ipif.vhd
--                file header--of which this is a part--with the ipif.vhd
--                file header, edited to replace "ipif" by "opb_ipif".
--
--  FLO         Sep-05-2002
--              - Added default values for input ports.
--              - Added signal OPB_timeout to the port list of the
--                instantiation of the slave_attachment.
--
-- ~~~~~~
--      FLO         09/10/02
-- ^^^^^^
--      Added port signal Bus2IP_LocalMstTrans. This signal is a qualifier
--      valid during any IPIC transfer. It is asserted during an IPIC
--      transfer if and only if the transfer is taking place as part of
--      a locally initiated master transaction. Local master transactions
--      can be initiated either by an IPIF DMA[SG] engine or a IP-core
--      master, if either or both are present. If there is no IPIC
--      transfer in progress, the value of Bus2IP_LocalMstTrans may be
--      arbitrary.
-- ~~~~~~
--      FLO         09/23/02
-- ^^^^^^
--      - Substituted the port signal Bus2IP_IPMstTrans for the
--        recently added Bus2IP_LocalMstTrans. The replaced signal
--        qualified the IPIC transaction as being due to either the
--        IP-core master or the DMA master. The new signal qualifies
--        the IPIC transaction as being due to the IP-core master, only.
--
--      - Added qualification by "not(Mstr_sel_ma)" to signals
--        Bus2IP_MstRetry, Bus2IP_MstTimeOut and Bus2IP_MstLastAck.
-- ~~~~~~
--      FLO         10/30/02
-- ^^^^^^
--      - Bus2IP_RdReq signal to the read fifo is gated off for the
--        cycle following the falling edge of opb_seqaddr. This is needed
--        because Bus2IP_RdReq was generalized to handle cases where
--        the IP2Bus_RdAck signal throttles and doesn't complete a read
--        on every cycle of a burst.
-- ~~~~~~
--      FLO         11/19/02
-- ^^^^^^
--      Added signal SA2MA_PostedWrInh, from slave_attachment to
--      master_attachment.
-- ~~~~~~
--  FLO      11/19/02
-- ^^^^^^
--  Added generic C_MASTER_ARB_MODEL, which allows for user-parameterized
--  arbitration behavior when there are both DMA and IP masters. Supports
--  fair, DMA-priority and IP-priority modes.
-- ~~~~~~
--  FLO      05/15/03
-- ^^^^^^
--  Now passing the C_ARD_ADDR_RANGE_ARRAY generic to the slave attachment.
-- ~~~~~~
--  FLO      05/18/03
-- ^^^^^^
--  Replaced the C_DMA_ALLOW_BURST parameter by C_DMA_BURST_SIZE.
--  This parameter can be set to 1 to disable burst or to some power
--  of two to enable DMA to use bursts of that size.
--  The default is for DMA to use bursts of 16.
--  Also added parameter C_DMA_SHORT_BURST_REMAINDER, which controls
--  whether DMA remainders are transferred as a short burst or as
--  a sequence of single transactions.
-- ~~~~~~

--  FO          May-22-2003
-- ^^^^^^
--              - Fixed to set C_VIRTEX_II generic for FIFOs to true when
--                C_FAMILY is spartan3.
-- ~~~~~~
--  GAB         April-28-2004
-- ^^^^^^
--              - Updated C_VIRTEX_II to support VIRTEX4, QVIRTEX2, and QRVIRTEX2
--              - Added change log
-- ~~~~~~
--      FLO         05/26/2004
-- ^^^^^^
--      - An IPIC read timeout function was added to the slave_attachment, its
--        use was added in the master attachment, and the connection of the
--        corresponding new signal SA2MA_TimeOut to master and slave
--        attachments is done here in opb_ipif. The timeout can detect a hung
--        IPIC read occurring as the slave attachment reads into its read
--        buffer in support of a local master write OPB transaction. When
--        SA2MA_TimeOut asserts, the master_attachment terminates the
--        local master transaction with Bus2IP_MstTimeOut. The timeout
--        function can be supressed by assertion of IP2Bus_ToutSup.
-- ~~~~~~
--  FLO      08/11/2004
-- ^^^^^^
--  Added signal MA2SA_RSRA (retained_state_retry_active).
--  Inhibit the slave attachement from reseting its count of transfers
--  left to complete a burst if in retained-state retry.
--  Fixes bug that could manifest as spurious writes in the local
--  device under a certain pattern of unrelated OPB activity.
-- ~~~~~~
--  FLO      08/20/2004
-- ^^^^^^
--  Fixed bug wherein unrelated OPB activity could cause an erroneous delay
--  in generation of the Bus2IP_DeviceSel during locally mastered write
--  transactions. An observed failure mode was the CE for a single IPIC read
--  being correspondingly delayed and, therefore, not being asserted
--  concurrently with the RdReq pulse.
-- ~~~~~~
--  FLO      08/25/2004
-- ^^^^^^
--  Changed bus2ip_rdreq_rfifo to be qualified by opb_busy. Because
--  opb_busy is only available in the slave_attachment, moved
--  generation bus2ip_rdreq_rfifo to the slave_attachment.
-- ~~~~~~
--  FLO      09/24/2004
-- ^^^^^^
--  -Added signal SA2MA_BufOccMinus1 and connected it to master and
--   slave attachments. This signal is used to help implement allowance of
--   arbitrary IPIC read retries when getting locally mastered write data
--   ready.
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

library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;

library unisim;
use unisim.vcomponents.all;

library opb_ipif_v2_00_h;

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.log2;
use proc_common_v1_00_b.family.virtex2;
use proc_common_v1_00_b.family.derived;

library ipif_common_v1_00_d;
use ipif_common_v1_00_d.ipif_pkg.INTEGER_ARRAY_TYPE;
use ipif_common_v1_00_d.ipif_pkg.SLV64_ARRAY_TYPE;
use ipif_common_v1_00_d.ipif_pkg.IPIF_RST;
use ipif_common_v1_00_d.ipif_pkg.IPIF_INTR;
use ipif_common_v1_00_d.ipif_pkg.IPIF_DMA_SG;
use ipif_common_v1_00_d.ipif_pkg.IPIF_WRFIFO_DATA;
use ipif_common_v1_00_d.ipif_pkg.IPIF_WRFIFO_REG;
use ipif_common_v1_00_d.ipif_pkg.IPIF_RDFIFO_DATA;
use ipif_common_v1_00_d.ipif_pkg.IPIF_RDFIFO_REG;
use ipif_common_v1_00_d.ipif_pkg.USER_00;
use ipif_common_v1_00_d.ipif_pkg.calc_num_ce;
use ipif_common_v1_00_d.ipif_pkg.calc_start_ce_index;
use ipif_common_v1_00_d.ipif_pkg.find_ard_id;
use ipif_common_v1_00_d.ipif_pkg.get_id_index;
use ipif_common_v1_00_d.ipif_pkg.get_min_dwidth;
use ipif_common_v1_00_d.ipif_pkg.DEPENDENT_PROPS_ARRAY_TYPE;
use ipif_common_v1_00_d.ipif_pkg.FIFO_CAPACITY_BITS;
use ipif_common_v1_00_d.ipif_pkg.WR_WIDTH_BITS;
use ipif_common_v1_00_d.ipif_pkg.RD_WIDTH_BITS;
use ipif_common_v1_00_d.ipif_pkg.EXCLUDE_PACKET_MODE;
use ipif_common_v1_00_d.ipif_pkg.EXCLUDE_VACANCY;
use ipif_common_v1_00_d.ipif_pkg.bits_needed_for_vac;
use ipif_common_v1_00_d.ipif_pkg.bits_needed_for_occ;
use ipif_common_v1_00_d.ipif_pkg.get_id_index_iboe;
use ipif_common_v1_00_d.dma_sg_pkg.all;
use ipif_common_v1_00_d.dma_sg_cmp.all;

entity opb_ipif is
  generic (
    C_ARD_ID_ARRAY         : INTEGER_ARRAY_TYPE
                           := ( IPIF_RST, -- 2
                                USER_00   -- 100
                              );

    C_ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE
                           := ( x"0000_0000_6000_0040",  -- IPIF_RST
                                x"0000_0000_6000_0043",
                                --
                                x"0000_0000_6000_1100",  -- USER_00
                                x"0000_0000_6000_11FF"
                              );

    C_ARD_DWIDTH_ARRAY     : INTEGER_ARRAY_TYPE
                           := ( 32,  -- IPIF_RST
                                32   -- USER_00
                              );

    C_ARD_NUM_CE_ARRAY     : INTEGER_ARRAY_TYPE
                           := (  1,  -- IPIF_RST
                                17   -- USER_00
                              );

    C_ARD_DEPENDENT_PROPS_ARRAY : DEPENDENT_PROPS_ARRAY_TYPE
                               := ( 0 => (others => 0),
                                    1 => (others => 0)
                                  );
      -- Properties depending on the address range (AR) type.
      --
      -- AR Type                  Properties (use these index constants, de-
      -- -------                  ----------  fined in ipif_pkg, in aggregates).
      --
      -- IPIF_WRFIFO_DATA or      FIFO_CAPACITY_BITS
      -- IPIF_RDFIFO_DATA         WR_WIDTH_BITS
      --                          RD_WIDTH_BITS

    C_DEV_BLK_ID : INTEGER := 1;
      --  Platform Builder Assiged Device ID number (unique
      --  for each device)

    C_DEV_MIR_ENABLE : integer := 0;
      --  Used to Enable/Disable Module ID functions

    C_DEV_BURST_ENABLE : INTEGER := 0;
      -- Burst Enable for IPIF Interface

    C_DEV_MAX_BURST_SIZE : INTEGER := 64;
      -- Maximum burst size to be supported (in bytes)

    C_INCLUDE_DEV_ISC : INTEGER := 1;
      -- 'true' specifies that the full device interrupt
      -- source controller structure will be included;
      -- 'false' specifies that only the global interrupt
      -- enable is present in the device interrupt source
      -- controller and that the only source of interrupts
      -- in the device is the IP interrupt source controller

    C_INCLUDE_DEV_PENCODER : integer := 0;
      -- 'true' will include the Device IID in the IPIF Interrupt
      -- function

    C_IP_INTR_MODE_ARRAY   : INTEGER_ARRAY_TYPE :=
                        (
                         1,  -- pass through (non-inverting)
                         2,  -- pass through (inverting)
                         3,  -- registered level (non-inverting)
                         4,  -- registered level (inverting)
                         5,  -- positive edge detect
                         6   -- negative edge detect
                        );
      -- One entry for each IP interrupt signal, with the
      -- signal type for each signal given by the value
      -- in the corresponding position. (See above.)

    C_IP_MASTER_PRESENT : integer := 0;
      -- 'true' specifies that the IP has Bus Master capability

    C_MASTER_ARB_MODEL  : integer := 0;
      -- Arbitration scheme if both DMA and IP masters are present.
      -- 0:FAIR  1:DMA_PRIORITY  2:IP_PRIORITY

   -----------------------------------------------------------------------------
   -- The parameters with names starting with 'C_DMA'  need only be specified if
   -- one of the address ranges is for the optional DMA[SG] controller, i.e. one
   -- range of type IPIF_DMA_SG is included in C_ARD_ID_ARRAY (see above).
   -- If DMA[SG] is included, then the number of channels and the
   -- parameterizeable properties of each Channel are specified in the arrays,
   -- below.
   -----------------------------------------------------------------------------
    C_DMA_CHAN_TYPE_ARRAY : INTEGER_ARRAY_TYPE :=       (2,
                                                         3
                                                        );
      -- One entry in the array for each channel, encoded as
      --    0 = simple DMA,  1 = simple sg,  2 = pkt tx SG,  3 = pkt rx SG

    C_DMA_LENGTH_WIDTH_ARRAY : INTEGER_ARRAY_TYPE :=    (11,
                                                         11
                                                        );
      -- One entry in the array for each channel.
      -- Gives the number of bits needed to specify the maximum DMA transfer
      -- length, in bytes, for the channel.

    C_DMA_PKT_LEN_FIFO_ADDR_ARRAY : SLV64_ARRAY_TYPE := (x"00000000_00000000",
                                                         x"00000000_00000000"
                                                        );
      -- One entry in the array for each channel.
      -- If the channel type is 0 or 1, the value should be "zero".
      -- If the channel type is 2 or 3 (packet channel),
      -- the value should give the address of the packet-length FIFO associated
      -- with the channel.

    C_DMA_PKT_STAT_FIFO_ADDR_ARRAY : SLV64_ARRAY_TYPE :=(x"00000000_00000000",
                                                         x"00000000_00000000"
                                                        );
      -- One entry in the array for each channel.
      -- If the channel type is 0 or 1, the value should be "zero".
      -- If the channel type is 2 or 3 (packet channel),
      -- the value should give the address of the packet-status FIFO associated
      -- with the channel.

    C_DMA_INTR_COALESCE_ARRAY : INTEGER_ARRAY_TYPE    :=(0,
                                                         0
                                                        );
      -- One entry in the array for each channel.
      -- If the channel type is 0 or 1, the value should be 0 for the
      -- channel.
      -- If the channel type is 2 or 3, the channel is a packet channel and
      -- the value 1 specifies that interrupt-coalescing features are
      -- to be implemented for the channel. The value 0 declines the features.


    C_DMA_BURST_SIZE: integer := 16; -- Must be a power of 2
      -- Gives the size of burst that DMA uses to tranfer data on the bus.
      -- A value of one causes DMA to use single transactions (burst disabled).

    C_DMA_SHORT_BURST_REMAINDER: integer := 0;
      -- When 0, any DMA data remaining that is less than a burst size will be
      -- transferred as a series of single transactions.
      -- When 1, remaining data is tranferred as a short burst.


    C_DMA_PACKET_WAIT_UNIT_NS : INTEGER := 1000000;
      -- Gives the unit for timing pack-wait bounds for all channels
      -- with interrupt coalescing. (Usually left at default value.);
      -- Needs to be specified only if at least one channel is of type
      -- 2 or 3 with interrupt coalescing and there is a need
      -- to deviate from the nominal unit of 1 ms (for example,
      -- to facilitate testing by simulation).

    C_OPB_AWIDTH : INTEGER := 32;
      --  width of OPB Address Bus (in bits)

    C_OPB_DWIDTH : INTEGER := 32;
      --  Width of the OPB Data Bus (in bits)

    C_OPB_CLK_PERIOD_PS : INTEGER := 10000;
      --  The period of the OPB Bus clock in ps (10000 = 10ns)

    C_IPIF_DWIDTH : INTEGER := 32;
      --  Set this equal to C_OPB_DWIDTH

    C_FAMILY : string := "virtexe"

  );
  port (
        OPB_ABus : in std_logic_vector(0 to C_OPB_AWIDTH - 1 ) := (others => '0');

        OPB_DBus : in std_logic_vector(0 to C_OPB_DWIDTH - 1 ) := (others => '0');

        Sln_DBus : out std_logic_vector(0 to C_OPB_DWIDTH - 1 );

        Mn_ABus : out std_logic_vector(0 to C_OPB_AWIDTH - 1 );

        IP2Bus_Addr : in std_logic_vector(0 to C_OPB_AWIDTH - 1 ) := (others => '0');

        Bus2IP_Addr : out std_logic_vector(0 to C_OPB_AWIDTH - 1 );

        Bus2IP_Data : out std_logic_vector(0 to C_IPIF_DWIDTH - 1 );

        Bus2IP_RNW  : out std_logic;

        Bus2IP_CS      : Out std_logic_vector(0 to ((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);

        Bus2IP_CE      : out std_logic_vector(0 to calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);

        Bus2IP_RdCE    : out std_logic_vector(0 to calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);

        Bus2IP_WrCE    : out std_logic_vector(0 to calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);

        IP2Bus_Data : in std_logic_vector(0 to C_IPIF_DWIDTH - 1 ) := (others  => '0');

        IP2Bus_WrAck : in std_logic := '0';

        IP2Bus_RdAck : in std_logic := '0';

        IP2Bus_Retry : in std_logic := '0';

        IP2Bus_Error : in std_logic := '0';

        IP2Bus_ToutSup : in std_logic := '0';

        IP2Bus_PostedWrInh : in std_logic := '0';

        IP2DMA_RxLength_Empty : in std_logic := '0';

        IP2DMA_RxStatus_Empty : in std_logic := '0';

        IP2DMA_TxLength_Full : in std_logic := '0';

        IP2DMA_TxStatus_Empty : in std_logic := '0';

        IP2IP_Addr : in std_logic_vector(0 to C_OPB_AWIDTH - 1 )
                   := (others => '0');

        IP2RFIFO_Data : in std_logic_vector(0 to 31 ) := (others  => '0');

        IP2RFIFO_WrMark : in std_logic := '0';

        IP2RFIFO_WrRelease : in std_logic := '0';

        IP2RFIFO_WrReq : in std_logic := '0';

        IP2RFIFO_WrRestore : in std_logic := '0';

        IP2WFIFO_RdMark : in std_logic := '0';

        IP2WFIFO_RdRelease : in std_logic := '0';

        IP2WFIFO_RdReq : in std_logic := '0';

        IP2WFIFO_RdRestore : in std_logic := '0';

        IP2Bus_MstBE : in std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 ) := (others => '0');

        IP2Bus_MstWrReq : in std_logic := '0';

        IP2Bus_MstRdReq : in std_logic := '0';

        IP2Bus_MstBurst : in std_logic := '0';

        IP2Bus_MstBusLock : in std_logic := '0';

        Bus2IP_MstWrAck : out std_logic;

        Bus2IP_MstRdAck : out std_logic;

        Bus2IP_MstRetry : out std_logic;

        Bus2IP_MstError : out std_logic;

        Bus2IP_MstTimeOut : out std_logic;

        Bus2IP_MstLastAck : out std_logic;

        Bus2IP_BE : out std_logic_vector(0 to C_IPIF_DWIDTH/8 - 1 );

        Bus2IP_WrReq : out std_logic;

        Bus2IP_RdReq : out std_logic;

        Bus2IP_IPMstTrans : out std_logic;

        Bus2IP_Burst : out std_logic;

        Mn_request : out std_logic;

        Mn_busLock : out std_logic;

        Mn_select : out std_logic;

        Mn_RNW : out std_logic;

        Mn_BE : out std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 );

        Mn_seqAddr : out std_logic;

        OPB_MnGrant : in std_logic := '0';

        OPB_xferAck : in std_logic := '0';

        OPB_errAck : in std_logic := '0';

        OPB_retry : in std_logic := '0';

        OPB_timeout : in std_logic := '0';

        Freeze : in std_logic := '0';

        RFIFO2IP_AlmostFull : out std_logic;

        RFIFO2IP_Full : out std_logic;

        RFIFO2IP_Vacancy : out
            std_logic_vector (
                0 to
                bits_needed_for_vac(
                    find_ard_id(C_ARD_ID_ARRAY, IPIF_RDFIFO_DATA),
                    C_ARD_DEPENDENT_PROPS_ARRAY(
                        get_id_index_iboe(C_ARD_ID_ARRAY, IPIF_RDFIFO_DATA)
                    )
                ) - 1
            );

        RFIFO2IP_WrAck : out std_logic;

        OPB_select : in std_logic := '0';

        OPB_RNW : in std_logic := '0';

        OPB_seqAddr : in std_logic := '0';

        OPB_BE : in std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 ) := (others  => '0');

        Sln_xferAck : out std_logic;

        Sln_errAck : out std_logic;

        Sln_toutSup : out std_logic;

        Sln_retry : out std_logic;

        WFIFO2IP_AlmostEmpty : out std_logic;

        WFIFO2IP_Data : out std_logic_vector(0 to 31 );

        WFIFO2IP_Empty : out std_logic;

        WFIFO2IP_Occupancy : out
            std_logic_vector (
                0 to
                bits_needed_for_occ(
                    find_ard_id(C_ARD_ID_ARRAY, IPIF_WRFIFO_DATA),
                    C_ARD_DEPENDENT_PROPS_ARRAY(
                        get_id_index_iboe(C_ARD_ID_ARRAY, IPIF_WRFIFO_DATA)
                    )
                ) - 1
            );

        WFIFO2IP_RdAck : out std_logic;

        Bus2IP_Clk : out std_logic;

        Bus2IP_DMA_Ack : out std_logic;

        Bus2IP_Freeze : out std_logic;

        Bus2IP_Reset : out std_logic;

        IP2Bus_Clk : in std_logic := '0';

        IP2Bus_DMA_Req : in std_logic := '0';

        IP2Bus_IntrEvent : in std_logic_vector(0 to C_IP_INTR_MODE_ARRAY'length-1 )
                         := (others  => '0');

        IP2INTC_Irpt : out std_logic;

        OPB_Clk : in std_logic := '0';

        Reset : in std_logic := '0'
        );


end opb_ipif;



library unisim;
use unisim.all;

library ieee;
use ieee.numeric_std.UNSIGNED;
use ieee.numeric_std."+";

architecture implementation of opb_ipif is

  constant ZEROES : std_logic_vector(0 to 256) := (others => '0');

 -- MIR Constants

  constant IPIF_MAJOR_VERSION : INTEGER range 0 to 15 := 2;
            --  set Major Version of this IPIF here (reflected in IPIF MIR)
            --  Now set to Major Version 2 for v2.00d

  constant IPIF_MINOR_VERSION : INTEGER range 0 to 127:= 0;
            --  set Minor Version of this IPIF here (reflected in IPIF MIR)
            --  Now set to 00

  constant IPIF_REVISION : INTEGER := 7;
            --  set Revision of this IPIF here (reflected in IPIF MIR)
            --  0 = a, 1 = b, 2 = c, etc.

  constant IPIF_TYPE : INTEGER := 1;
            --  set interface type for this IPIF here (reflected in IPIF MIR)
            --  Always '1' for OPB ipif interface type


  function num_CEs(ard_id: integer) return integer is
      variable id_included: boolean;
  begin
      id_included := find_ard_id(C_ARD_ID_ARRAY, ard_id);
      if id_included then
          return C_ARD_NUM_CE_ARRAY(get_id_index(C_ARD_ID_ARRAY, ard_id));
      else return 0;
      end if;
  end num_CEs;


  type SLV_OF_BUS_SIZE is array(0 to C_OPB_AWIDTH-1) of std_logic;

  function base_address(ard_id: integer)
                       return SLV_OF_BUS_SIZE is
      variable result : SLV_OF_BUS_SIZE
                      := (others => '0');
      variable id_included: boolean;
      variable ar_index: integer;
  begin
      id_included := find_ard_id(C_ARD_ID_ARRAY, ard_id);
      ar_index := 2*get_id_index(C_ARD_ID_ARRAY, ard_id);
      if id_included then
        result := SLV_OF_BUS_SIZE(
                    C_ARD_ADDR_RANGE_ARRAY(ar_index)
                      (   C_ARD_ADDR_RANGE_ARRAY(0)'length - C_OPB_AWIDTH
                       to C_ARD_ADDR_RANGE_ARRAY(0)'length - 1
                      )
                  )
                  ;
      end if;
      return result;
  end base_address;


  function num_common_high_order_addr_bits(ara: SLV64_ARRAY_TYPE)
                                          return integer is
      variable n : integer := C_OPB_AWIDTH;
          -- Maximum number of common high-order bits for
          -- the ranges starting at an index less than i.
      variable i, j: integer;
      variable old_base: std_logic_vector(0 to C_OPB_AWIDTH-1)
                       := ara(0)(   ara(0)'length-C_OPB_AWIDTH
                                 to ara(0)'length-1
                                );
      variable new_base, new_high: std_logic_vector(0 to C_OPB_AWIDTH-1);
  begin
    i := 0;
    while i < ara'length loop
        new_base := ara(i  )(ara(0)'length-C_OPB_AWIDTH to ara(0)'length-1);
        new_high := ara(i+1)(ara(0)'length-C_OPB_AWIDTH to ara(0)'length-1);
        j := 0;
        while    j < n                            -- Limited by earlier value.
             and new_base(j) = old_base(j)         -- High-order addr diff found
                                                   -- with a previous range.
             and (new_base(j) xor new_high(j))='0' -- Addr-range boundary found
                                                   -- for current range.
        loop
            j := j+1;
        end loop;
        n := j;
        i := i+2;
    end loop;
    return n;
  end num_common_high_order_addr_bits;


 -- Other constants

  constant K_DEV_ADDR_DECODE_WIDTH
             : integer
             := num_common_high_order_addr_bits(C_ARD_ADDR_RANGE_ARRAY);

  constant LOW_ADDR_DECODE_WIDTH : INTEGER
                             := C_OPB_AWIDTH - K_DEV_ADDR_DECODE_WIDTH;

  constant LOGIC_LOW : std_logic := '0';

  constant ZERO_ADDR_PREFIX
                     : std_logic_vector(0 to 64 - C_OPB_AWIDTH-1)
                     := (others => '0');


  constant RESET_PRESENT      : boolean
                              := find_ard_id(C_ARD_ID_ARRAY, IPIF_RST);

  constant INTERRUPT_PRESENT  : boolean
                              := find_ard_id(C_ARD_ID_ARRAY, IPIF_INTR);

  constant WRFIFO_PRESENT     : boolean
                              := find_ard_id(C_ARD_ID_ARRAY, IPIF_WRFIFO_REG)
                             and find_ard_id(C_ARD_ID_ARRAY, IPIF_WRFIFO_DATA);

  constant RDFIFO_PRESENT     : boolean
                              := find_ard_id(C_ARD_ID_ARRAY, IPIF_RDFIFO_REG)
                             and find_ard_id(C_ARD_ID_ARRAY, IPIF_RDFIFO_DATA);

  constant DMA_PRESENT        : boolean
                              := find_ard_id(C_ARD_ID_ARRAY, IPIF_DMA_SG);

  constant INTERRUPT_REG_NUM : INTEGER := num_CEs(IPIF_INTR);


  constant DMA_BASEADDR     :  std_logic_vector(0 to C_OPB_AWIDTH - 1 )
                            := std_logic_vector(base_address(IPIF_DMA_SG));


  constant DEV_IS_SLAVE_ONLY : BOOLEAN := not(DMA_PRESENT or
                                              (C_IP_MASTER_PRESENT /= 0));


  constant VIRTEX_II           : boolean :=   derived(C_FAMILY, virtex2);

--constant DMA_USE_BURST : BOOLEAN := (C_DMA_ALLOW_BURST /= 0) and
--                                    (C_DEV_BURST_ENABLE /= 0);

  function gate_burst_size(bool: boolean; posit: integer) return positive is
  begin
      if bool then return posit; else return 1; end if;
  end gate_burst_size;
  --
  constant DMA_BURST_SIZE : positive := gate_burst_size(C_DEV_BURST_ENABLE=1,
                                                        C_DMA_BURST_SIZE);


  constant NUM_CE : integer := calc_num_ce(C_ARD_NUM_CE_ARRAY);


  -- signal used as a constant (when constant fails to be a globally
  -- static expression).
  signal CONST_ALL_IP_BYTES_ENABLED :
      std_logic_vector(0 to C_IPIF_DWIDTH/8 -1) := (others => '1');

 -- Signal declarations
  signal Addr_Cntr_ClkEN : std_logic;
  signal Addr_Sel : std_logic_vector(0 to 1 );
  signal Bus2IP_Addr_i : std_logic_vector(0 to C_OPB_AWIDTH - 1 );
  signal Bus2IP_Addr_sa : std_logic_vector(0 to C_OPB_AWIDTH - 1 );
  signal Bus2IP_BE_sa  : std_logic_vector(0 to C_IPIF_DWIDTH/8 - 1 );
  signal Bus2IP_BE_amx : std_logic_vector(0 to C_IPIF_DWIDTH/8 - 1 );
  signal Bus2IP_BE_i   : std_logic_vector(0 to C_IPIF_DWIDTH/8 - 1 );
  signal Bus2IP_Burst_i  : std_logic;
  signal Bus2IP_Clk_i : std_logic;
  signal Bus2IP_Data_sa : std_logic_vector(0 to C_OPB_DWIDTH - 1 );
  signal Bus2IP_Data_i  : std_logic_vector(0 to C_OPB_DWIDTH - 1 );
  signal Bus2IP_Freeze_i : std_logic;
  signal Bus2IP_MstError_i : std_logic;
  signal Bus2IP_MstLastAck_i : std_logic;
  signal Bus2IP_MstRdAck_ma : std_logic;
  signal Bus2IP_MstRetry_i : std_logic;
  signal Bus2IP_MstTimeOut_i : std_logic;
  signal Bus2IP_MstWrAck_ma : std_logic;
  signal Bus2IP_DeviceSel : std_logic;
  signal Bus2IP_RdReq_i : std_logic;
  signal Bus2IP_Reset_i : std_logic;
  signal Bus2IP_RNW_i  : std_logic;
  signal Bus2IP_WrReq_i : std_logic;
  signal Bus_MnGrant : std_logic;
  signal const_zero : std_logic := '0';
  signal DMA2Bus_Addr : std_logic_vector(0 to C_OPB_AWIDTH - 1 );
  signal DMA2Bus_Data : std_logic_vector(0 to C_OPB_DWIDTH - 1 );
  signal DMA2Intr_Intr : std_logic_vector(0 to 1 );
  signal DMA2IP_Addr : std_logic_vector(0 to C_OPB_AWIDTH - 1 );
  signal DMA2Bus_MstBE : std_logic_vector(0 to C_OPB_DWIDTH/8 - 1 );
  signal DMA2Bus_MstNum : STD_LOGIC_VECTOR(0 to
                                           log2(C_DEV_MAX_BURST_SIZE/4+1)-1);
  signal DMA2Bus_MstBurst : std_logic;
  signal DMA2Bus_MstBusLock : std_logic;
  signal DMA2Bus_MstRdReq : std_logic;
  signal DMA2Bus_MstWrReq : std_logic;
  signal DMA2Bus_Error : std_logic;
  signal DMA2Bus_RdAck : std_logic;
  signal DMA2Bus_Retry : std_logic;
  signal DMA2Bus_ToutSup : std_logic;
  signal DMA2Bus_WrAck : std_logic;
  signal Intr2Bus_DBus : std_logic_vector(0 to C_OPB_DWIDTH - 1 );
  signal Intr2Bus_DevIntr : std_logic;
  signal Intr2Bus_Error : std_logic;
  signal Intr2Bus_RdAck : std_logic;
  signal Intr2Bus_Retry : std_logic;
  signal Intr2Bus_ToutSup : std_logic;
  signal Intr2Bus_WrAck : std_logic;
  signal IP2Bus_Data_mx    : std_logic_vector(0 to C_OPB_DWIDTH - 1 );
  signal IP2Bus_Data_steer : std_logic_vector(0 to C_OPB_DWIDTH - 1 );
  signal IP2Bus_Error_mx : std_logic;
  signal IP2Bus_RdAck_mx : std_logic;
  signal IP2Bus_Retry_mx : std_logic;
  signal IP2Bus_ToutSup_mx : std_logic;
  signal IP2Bus_WrAck_mx : std_logic;
  signal IPIF_Lvl_Interrupts : std_logic_vector(0 to 3 );
  signal IPIF_Reg_Interrupts : std_logic_vector(0 to 1 );
  signal MA2SA_Num : std_logic_vector(0 to log2(C_DEV_MAX_BURST_SIZE/4+1)-1);
  signal MA2SA_Rd : std_logic;
  signal MA2SA_Select : std_logic;
  signal MA2SA_XferAck : std_logic;
  signal MA2SA_Retry   : std_logic;
  signal MA2SA_RSRA    : std_logic;
  signal Mstr_sel_ma : std_logic;
  signal RdFIFO2Bus_Data : std_logic_vector(0 to C_OPB_DWIDTH - 1 );
  signal RdFIFO2Intr_DeadLock : std_logic;
  signal Reset2Bus_DBus : std_logic_vector(0 to C_OPB_DWIDTH - 1 );
  signal RFIFO2DMA_AlmostEmpty : std_logic;
  signal RFIFO2DMA_Empty : std_logic;
  signal RFIFO2DMA_Occupancy :
              std_logic_vector (
                 0 to
                 bits_needed_for_occ(
                     find_ard_id(C_ARD_ID_ARRAY, IPIF_RDFIFO_DATA),
                     C_ARD_DEPENDENT_PROPS_ARRAY(
                         get_id_index_iboe(C_ARD_ID_ARRAY, IPIF_RDFIFO_DATA)
                     )
                 ) - 1
              );

  signal RFIFO_Error : std_logic;
  signal RFIFO_RdAck : std_logic;
  signal RFIFO_Retry : std_logic;
  signal RFIFO_ToutSup : std_logic;
  signal RFIFO_WrAck : std_logic;
  signal Rst2Bus_Error : std_logic;
  signal Rst2Bus_RdAck : std_logic;
  signal Rst2Bus_Retry : std_logic;
  signal Rst2Bus_ToutSup : std_logic;
  signal Rst2Bus_WrAck : std_logic;
  signal SA2MA_RdRdy : std_logic;
  signal SA2MA_WrAck : std_ulogic;
  signal SA2MA_Retry : std_logic;
  signal SA2MA_Error : std_logic;
  signal SA2MA_FifoRd: std_logic;
  signal SA2MA_FifoWr: std_logic;
  signal SA2MA_FifoBu: std_logic;
  signal SA2MA_PostedWrInh: std_logic;
  signal SA2MA_TimeOut: std_logic;
  signal SA2MA_BufOccMinus1 : std_logic_vector(0 to 4);
  signal WFIFO2DMA_AlmostFull : std_logic;
  signal WFIFO2DMA_Full : std_logic;
  signal WFIFO2DMA_vacancy   :
              std_logic_vector (
                 0 to
                 bits_needed_for_vac(
                     find_ard_id(C_ARD_ID_ARRAY, IPIF_WRFIFO_DATA),
                     C_ARD_DEPENDENT_PROPS_ARRAY(
                         get_id_index_iboe(C_ARD_ID_ARRAY, IPIF_WRFIFO_DATA)
                     )
                 ) - 1
              );

  signal WFIFO_Error : std_logic;
  signal WFIFO_RdAck : std_logic;
  signal WFIFO_Retry : std_logic;
  signal WFIFO_ToutSup : std_logic;
  signal WFIFO_WrAck : std_logic;
  signal WrFIFO2Bus_Data : std_logic_vector(0 to C_OPB_DWIDTH - 1 );
  signal WrFIFO2Intr_DeadLock : std_logic;
  signal CS_Out   : std_logic_vector(0 to (C_ARD_ADDR_RANGE_ARRAY'length)/2 - 1);
  signal CE_Out   : std_logic_vector(0 to calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);
  signal RdCE_Out : std_logic_vector(0 to calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);
  signal WrCE_Out : std_logic_vector(0 to calc_num_ce(C_ARD_NUM_CE_ARRAY)-1);
  signal cs_dwidth: std_logic_vector(0 to 2);
  signal bus2ip_localmsttrans: std_logic;
  signal devicesel_inh_opb  : std_logic;
  signal devicesel_inh_mstr : std_logic;
  signal bus2ip_rdreq_rfifo: std_logic;


-------------------------------------------------------------------------------
-- components

  constant NUM_CE_NEEDED : integer := calc_num_ce(C_ARD_NUM_CE_ARRAY);
  constant NUM_CS_NEEDED : integer := C_ARD_ADDR_RANGE_ARRAY'LENGTH/2;

constant NUM_IP_INTR_SIGS : integer := C_IP_INTR_MODE_ARRAY'length;

-------------------------------------------------------------------------------
-- Instantiate the components
-------------------------------------------------------------------------------

begin

    -- Perform consistency checks

    -- synthesis translate_off

    -- Any parameter consistency checks should be implemented here.

    -- synthesis translate_on



 ------------------------------------------------------------------------------
  INCLUDE_MASTER : if (DEV_IS_SLAVE_ONLY = false) generate

     I_MASTER_ATTACHMENT: entity opb_ipif_v2_00_h.master_attachment
       generic map (C_OPB_ABUS_WIDTH  => C_OPB_AWIDTH,
                    C_OPB_DBUS_WIDTH  => C_OPB_DWIDTH,
                    C_MA2SA_NUM_WIDTH => log2(C_DEV_MAX_BURST_SIZE/4 + 1),
                    C_DMA_ONLY     => DMA_PRESENT and not (C_IP_MASTER_PRESENT /= 0),
                    C_IP_MSTR_ONLY => not DMA_PRESENT and (C_IP_MASTER_PRESENT /= 0),
                    C_MASTER_ARB_MODEL => C_MASTER_ARB_MODEL)
       port map (
                Reset       => Reset,

        --OPB ports
                OPB_Clk     => Bus2IP_Clk_i,
                OPB_MnGrant => OPB_MnGrant,
                OPB_xferAck => OPB_xferAck,
                OPB_errAck  => OPB_errAck,
                OPB_timeout => OPB_timeout,
                OPB_retry   => OPB_retry,

        --Master Attachment to OPB ports
                Mn_request  => Mn_request,
                Mn_select   => Mn_select,
                Mn_RNW      => Mn_RNW,
                Mn_seqAddr  => Mn_seqAddr,
                Mn_busLock  => Mn_busLock,
                Mn_BE       => Mn_BE,
                Mn_ABus     => Mn_ABus,

        --Master Attachment to SA ports
                Bus_MnGrant   => Bus_MnGrant,
                MA2SA_Select  => MA2SA_Select,
                MA2SA_XferAck => MA2SA_XferAck,
                MA2SA_Retry   => MA2SA_Retry,
                MA2SA_RSRA    => MA2SA_RSRA,
                MA2SA_Rd      => MA2SA_Rd,
                MA2SA_Num     => MA2SA_Num,
                SA2MA_RdRdy   => SA2MA_RdRdy,
                SA2MA_WrAck   => SA2MA_WrAck,
                SA2MA_Retry   => SA2MA_Retry,
                SA2MA_Error   => SA2MA_Error,
                SA2MA_FifoRd  => SA2MA_FifoRd,
                SA2MA_FifoWr  => SA2MA_FifoWr,
                SA2MA_FifoBu  => SA2MA_FifoBu,
                SA2MA_PostedWrInh  => SA2MA_PostedWrInh,
                SA2MA_TimeOut => SA2MA_TimeOut,
                SA2MA_BufOccMinus1 => SA2MA_BufOccMinus1,


        --Master Attachment from IP ports
                Mstr_sel_ma   => Mstr_sel_ma,

        --Master Attachment from IP ports
                IP2Bus_Addr       => IP2Bus_Addr,
                IP2Bus_MstBE      => IP2Bus_MstBE,
                IP2Bus_MstWrReq   => IP2Bus_MstWrReq,
                IP2Bus_MstRdReq   => IP2Bus_MstRdReq,
                IP2Bus_MstBurst   => IP2Bus_MstBurst,
                IP2Bus_MstBusLock => IP2Bus_MstBusLock,

        --Master Attachment to IP ports
                Bus2IP_MstWrAck_ma => Bus2IP_MstWrAck_ma,
                Bus2IP_MstRdAck_ma => Bus2IP_MstRdAck_ma,
                Bus2IP_MstRetry    => Bus2IP_MstRetry_i,
                Bus2IP_MstError    => Bus2IP_MstError_i,
                Bus2IP_MstTimeOut  => Bus2IP_MstTimeOut_i,
                Bus2IP_MstLastAck  => Bus2IP_MstLastAck_i,

        --Master Attachment from DMA ports
                DMA2Bus_Addr        => DMA2Bus_Addr,
                DMA2Bus_MstBE       => DMA2Bus_MstBE,
                DMA2Bus_MstWrReq    => DMA2Bus_MstWrReq,
                DMA2Bus_MstRdReq    => DMA2Bus_MstRdReq,
                DMA2Bus_MstNum      => DMA2Bus_MstNum,
                DMA2Bus_MstBurst    => DMA2Bus_MstBurst,
                DMA2Bus_MstBusLock  => DMA2Bus_MstBusLock );

  end generate INCLUDE_MASTER;


  REMOVE_MASTER : if (DEV_IS_SLAVE_ONLY = true) generate

           Bus2IP_MstError_i   <=  '0';
           Bus2IP_MstLastAck_i <=  '0';
           Bus2IP_MstRdAck_ma   <=  '0';
           Bus2IP_MstRetry_i   <=  '0';
           Bus2IP_MstTimeOut_i <=  '0';
           Bus2IP_MstWrAck_ma   <=  '0';
           Bus_MnGrant         <=  '0';
           MA2SA_Num           <=  (others => '0');
           MA2SA_Rd            <=  '0';
           MA2SA_Select        <=  '0';
           MA2SA_XferAck       <=  '0';
           MA2SA_Retry         <=  '0';
           MA2SA_RSRA          <=  '0';
           Mn_ABus             <=  (others => '0');
           Mn_BE               <=  (others => '0');
           Mn_busLock          <=  '0';
           Mn_request          <=  '0';
           Mn_RNW              <=  '0';
           Mn_select           <=  '0';
           Mn_seqAddr          <=  '0';
           Mstr_sel_ma         <=  '0';

  end generate REMOVE_MASTER;

 ------------------------------------------------------------------------------
  I_ADDRESS_DECODER: entity opb_ipif_v2_00_h.address_decoder
    generic map (
      C_BUS_AWIDTH            => LOW_ADDR_DECODE_WIDTH,
      C_USE_REG_OUTPUTS       => true,
      C_ARD_ADDR_RANGE_ARRAY  => C_ARD_ADDR_RANGE_ARRAY,
      C_ARD_DWIDTH_ARRAY      => C_ARD_DWIDTH_ARRAY,
      C_ARD_NUM_CE_ARRAY      => C_ARD_NUM_CE_ARRAY
    )
    port map (
      Bus_clk         => Bus2IP_Clk_i,
      Bus_rst         => Reset,
      Address_In      => Bus2IP_Addr_i(   C_OPB_AWIDTH-LOW_ADDR_DECODE_WIDTH
                                       to C_OPB_AWIDTH-1
                                      ),
      Address_Valid      => Bus2IP_DeviceSel,
      Bus_RNW            => Bus2IP_RNW_i,
      IP2Bus_RdAck_mx    => IP2Bus_RdAck_mx,
      IP2Bus_WrAck_mx    => IP2Bus_WrAck_mx,
      Bus2IP_Burst       => Bus2IP_Burst_i,
      Addr_Match         => open,
      CS_Out             => CS_Out,
      CS_Size            => cs_dwidth,
      CE_Out             => CE_Out,
      RdCE_Out           => RdCE_Out,
      WrCE_Out           => WrCE_Out,
      Devicesel_inh_opb  => devicesel_inh_opb,
      Devicesel_inh_mstr => devicesel_inh_mstr
    );
    Bus2IP_CS <= CS_Out;
    Bus2IP_CE <= CE_Out;
    Bus2IP_RdCE <= RdCE_Out;
    Bus2IP_WrCE <= WrCE_Out;



  I_IP2BUS_SRMUX: entity opb_ipif_v2_00_h.ip2bus_srmux_blk
    port map (
              DMA2Bus_Error => DMA2Bus_Error,
              DMA2Bus_RdAck => DMA2Bus_RdAck,
              DMA2Bus_Retry => DMA2Bus_Retry,
              DMA2Bus_ToutSup => DMA2Bus_ToutSup,
              DMA2Bus_WrAck => DMA2Bus_WrAck,
              Intr2Bus_Error => Intr2Bus_Error,
              Intr2Bus_RdAck => Intr2Bus_RdAck,
              Intr2Bus_Retry => Intr2Bus_Retry,
              Intr2Bus_ToutSup => Intr2Bus_ToutSup,
              Intr2Bus_WrAck => Intr2Bus_WrAck,
              IP2Bus_Error => IP2Bus_Error,
              IP2Bus_Error_mx => IP2Bus_Error_mx,
              IP2Bus_RdAck => IP2Bus_RdAck,
              IP2Bus_RdAck_mx => IP2Bus_RdAck_mx,
              IP2Bus_Retry => IP2Bus_Retry,
              IP2Bus_Retry_mx => IP2Bus_Retry_mx,
              IP2Bus_ToutSup => IP2Bus_ToutSup,
              IP2Bus_ToutSup_mx => IP2Bus_ToutSup_mx,
              IP2Bus_WrAck => IP2Bus_WrAck,
              IP2Bus_WrAck_mx => IP2Bus_WrAck_mx,
              RFIFO_Error => RFIFO_Error,
              RFIFO_RdAck => RFIFO_RdAck,
              RFIFO_Retry => RFIFO_Retry,
              RFIFO_ToutSup => RFIFO_ToutSup,
              RFIFO_WrAck => RFIFO_WrAck,
              Rst2Bus_Error => Rst2Bus_Error,
              Rst2Bus_RdAck => Rst2Bus_RdAck,
              Rst2Bus_Retry => Rst2Bus_Retry,
              Rst2Bus_ToutSup => Rst2Bus_ToutSup,
              Rst2Bus_WrAck => Rst2Bus_WrAck,
              WFIFO_Error => WFIFO_Error,
              WFIFO_RdAck => WFIFO_RdAck,
              WFIFO_Retry => WFIFO_Retry,
              WFIFO_ToutSup => WFIFO_ToutSup,
              WFIFO_WrAck => WFIFO_WrAck);


  I_BUS2IP_AMUX: entity opb_ipif_v2_00_h.bus2ip_amux
    generic map (
                 C_IPIF_ABUS_WIDTH  => C_OPB_AWIDTH,
                 C_IPIF_DBUS_WIDTH  => C_IPIF_DWIDTH)
    port map (
              Bus2IP_Reset_i    => Reset,
              Bus2IP_Clk_i      => Bus2IP_Clk_i,
              Mstr_sel_ma       => Mstr_sel_ma,
              Addr_Cntr_ClkEN   => Addr_Cntr_ClkEN,
              Addr_Sel          => Addr_Sel,
              Bus2IP_Addr_sa    => Bus2IP_Addr_sa,
              IP2IP_Addr        => IP2IP_Addr,
              DMA2IP_Addr       => DMA2IP_Addr,
              Bus2IP_Addr_i     => Bus2IP_Addr_i,
              Bus2IP_BE_sa      => Bus2IP_BE_sa,
              IP2IP_BE          => CONST_ALL_IP_BYTES_ENABLED,
              DMA2IP_BE         => CONST_ALL_IP_BYTES_ENABLED,
              Bus2IP_BE_i       => Bus2IP_BE_amx
             );

  I_IP2BUS_DMUX: entity opb_ipif_v2_00_h.ip2bus_dmux_blk
    generic map (C_DBUS_WIDTH => C_OPB_DWIDTH)
    port map (
              DMA2Bus_Data   => DMA2Bus_Data(0 to C_OPB_DWIDTH - 1),
              Intr2Bus_DBus  => Intr2Bus_DBus(0 to C_OPB_DWIDTH - 1),
              IP2Bus_Data    => IP2Bus_Data(0 to C_IPIF_DWIDTH - 1),
              IP2Bus_Data_mx => IP2Bus_Data_mx(0 to C_OPB_DWIDTH - 1),
              Reset2Bus_Data => Reset2Bus_DBus(0 to C_OPB_DWIDTH - 1),
              RFIFO2Bus_Data => RdFIFO2Bus_Data(0 to C_OPB_DWIDTH - 1),
              WFIFO2Bus_Data => WrFIFO2Bus_Data(0 to C_OPB_DWIDTH - 1));


  I_SLAVE_ATTACHMENT: entity opb_ipif_v2_00_h.slave_attachment
    generic map (
        C_OPB_ABUS_WIDTH        => C_OPB_AWIDTH,
        C_OPB_DBUS_WIDTH        => C_OPB_DWIDTH,
        C_IPIF_ABUS_WIDTH       => C_OPB_AWIDTH,
        C_IPIF_DBUS_WIDTH       => C_IPIF_DWIDTH,
        C_DEV_ADDR_DECODE_WIDTH => K_DEV_ADDR_DECODE_WIDTH,
        C_DEV_BASEADDR          => C_ARD_ADDR_RANGE_ARRAY(0)
                                     (     C_ARD_ADDR_RANGE_ARRAY(0)'length
                                         - C_OPB_AWIDTH
                                      to C_ARD_ADDR_RANGE_ARRAY(0)'length -1
                                     ), -- Any baseaddr from array will serve to
                                        -- supply the K_DEV_ADDR_DECODE_WIDTH
                                        -- high-order bits.
        C_DEV_BURST_ENABLE      => (C_DEV_BURST_ENABLE /= 0),
        C_DEV_IS_SLAVE_ONLY     => DEV_IS_SLAVE_ONLY,
        C_MA2SA_NUM_WIDTH       => log2(C_DEV_MAX_BURST_SIZE/4 + 1),
        C_ARD_ADDR_RANGE_ARRAY  => C_ARD_ADDR_RANGE_ARRAY
    )
    port map (
              Reset           => Reset,
              OPB_Clk         => Bus2IP_Clk_i,
              OPB_select      => OPB_select,
              OPB_RNW         => OPB_RNW,
              OPB_SeqAddr     => OPB_SeqAddr,
              OPB_BE          => OPB_BE(0 to C_OPB_DWIDTH/8 - 1),
              OPB_ABus        => OPB_ABus(0 to C_OPB_AWIDTH - 1),
              OPB_DBus        => OPB_DBus(0 to C_OPB_DWIDTH - 1),
              OPB_timeout     => OPB_timeout,
              Sln_DBus        => Sln_DBus(0 to C_OPB_DWIDTH - 1),
              Sln_xferAck     => Sln_xferAck,
              Sln_errAck      => Sln_errAck,
              Sln_toutSup     => Sln_toutSup,
              Sln_retry       => Sln_retry,
              Bus_MnGrant     => Bus_MnGrant,
              MA2SA_Select    => MA2SA_Select,
              MA2SA_XferAck   => MA2SA_XferAck,
              MA2SA_Retry     => MA2SA_Retry,
              MA2SA_RSRA      => MA2SA_RSRA,
              MA2SA_Rd        => MA2SA_Rd,
              MA2SA_Num       => MA2SA_Num,
              SA2MA_RdRdy     => SA2MA_RdRdy,
              SA2MA_WrAck     => SA2MA_WrAck,
              SA2MA_Retry     => SA2MA_Retry,
              SA2MA_Error     => SA2MA_Error,
              SA2MA_FifoRd    => SA2MA_FifoRd,
              SA2MA_FifoWr    => SA2MA_FifoWr,
              SA2MA_FifoBu    => SA2MA_FifoBu,
              SA2MA_PostedWrInh    => SA2MA_PostedWrInh,
              SA2MA_TimeOut   => SA2MA_TimeOut,
              SA2MA_BufOccMinus1 => SA2MA_BufOccMinus1,
              Addr_Sel        => Addr_Sel(0 to 1),
              Addr_Cntr_ClkEn => Addr_Cntr_ClkEN,
              Bus2IP_Burst    => Bus2IP_Burst_i ,
              Bus2IP_RNW      => Bus2IP_RNW_i ,
              Bus2IP_BE_sa    => Bus2IP_BE_sa(0 to C_IPIF_DWIDTH/8 - 1),
              Bus2IP_Addr_sa  => Bus2IP_Addr_sa,
              Bus2IP_Data     => Bus2IP_Data_sa(0 to C_IPIF_DWIDTH - 1),
              Bus2IP_DeviceSel=> Bus2IP_DeviceSel,
              Bus2IP_WrReq    => Bus2IP_WrReq_i,
              Bus2IP_RdReq    => Bus2IP_RdReq_i,
              Bus2IP_RdReq_rfifo => bus2ip_rdreq_rfifo,
              Bus2IP_LocalMstTrans => bus2ip_localmsttrans,
              IP2Bus_Data_mx  => IP2Bus_Data_steer(0 to C_IPIF_DWIDTH - 1),
              IP2Bus_WrAck_mx => IP2Bus_WrAck_mx,
              IP2Bus_RdAck_mx => IP2Bus_RdAck_mx,
              IP2Bus_Error_mx => IP2Bus_Error_mx,
              IP2Bus_ToutSup_mx  => IP2Bus_ToutSup_mx,
              IP2Bus_Retry_mx    => IP2Bus_Retry_mx,
              IP2Bus_PostedWrInh => IP2Bus_PostedWrInh,
              Devicesel_inh_opb_out  => devicesel_inh_opb,
              Devicesel_inh_mstr_out => devicesel_inh_mstr
              );

  Bus2IP_IPMstTrans <= bus2ip_localmsttrans and not(Mstr_sel_ma);


  I_IPIF_STEER : entity ipif_common_v1_00_d.IPIF_Steer
  generic map (
    C_DWIDTH    => C_OPB_DWIDTH,
    C_SMALLEST  => get_min_dwidth(C_ARD_DWIDTH_ARRAY),
    C_AWIDTH    => C_OPB_AWIDTH
  )
  port map (
    Wr_Data_In  => Bus2IP_Data_sa,    -- in  std_logic_vector(0 to C_DWIDTH-1)
    Rd_Data_In  => IP2Bus_Data_mx,    -- in  std_logic_vector(0 to C_DWIDTH-1)
    Addr        => Bus2IP_Addr_i,     -- in  std_logic_vector(0 to C_AWIDTH-1)
    BE_In       => Bus2IP_BE_amx,     -- in  std_logic_vector(0 to C_DWIDTH/8-1)
    Decode_size => cs_dwidth,         -- in  std_logic_vector(0 to 2)
    Wr_Data_Out => Bus2IP_Data_i,     -- out std_logic_vector(0 to C_DWIDTH-1)
    Rd_Data_Out => IP2Bus_Data_steer, -- out std_logic_vector(0 to C_DWIDTH-1)
    BE_Out      => Bus2IP_BE_i        -- out std_logic_vector(0 to C_DWIDTH/8-1)
  );

--------------------------------------------------------------------------------

  INCLUDE_RESET : if (RESET_PRESENT) generate

     Constant RESET_NAME_INDEX      : integer := get_id_index(
                                                   C_ARD_ID_ARRAY,
                                                   IPIF_RST
                                                 );
     Constant RESET_REG_CE_INDEX    : integer := calc_start_ce_index(
                                                   C_ARD_NUM_CE_ARRAY,
                                                   RESET_NAME_INDEX
                                                 );

  begin
        I_RESET_CONTROL: entity opb_ipif_v2_00_h.reset_control
          generic map (C_IPIF_MIR_ENABLE    => (C_DEV_MIR_ENABLE /= 0),
                       C_IPIF_TYPE          => IPIF_TYPE,
                       C_IPIF_BLK_ID        => C_DEV_BLK_ID,
                       C_IPIF_REVISION      => IPIF_REVISION,
                       C_IPIF_MINOR_VERSION => IPIF_MINOR_VERSION,
                       C_IPIF_MAJOR_VERSION => IPIF_MAJOR_VERSION,
                       C_OPB_DBUS_WIDTH     => C_OPB_DWIDTH)
          port map (
                    Bus2IP_Clk_i => Bus2IP_Clk_i,
                    Bus_DBus => Bus2IP_Data_i(0 to C_OPB_DWIDTH - 1),
                    IP_Reset_RdCE => RdCE_Out(RESET_REG_CE_INDEX),
                    IP_Reset_WrCE => WrCE_Out(RESET_REG_CE_INDEX),
                    Reset => Reset,
                    Reset2Bus_DBus    => Reset2Bus_DBus(0 to C_OPB_DWIDTH - 1),
                    Reset2Bus_Error   => Rst2Bus_Error,
                    Reset2Bus_RdAck   => Rst2Bus_RdAck,
                    Reset2Bus_Retry   => Rst2Bus_Retry,
                    Reset2Bus_ToutSup => Rst2Bus_ToutSup,
                    Reset2Bus_WrAck   => Rst2Bus_WrAck,
                    Reset2IP_Reset    => bus2ip_reset_i);

  end generate INCLUDE_RESET;



  REMOVE_RESET : if (not RESET_PRESENT) generate

        Reset2Bus_DBus  <= (others => '0') ;
        Rst2Bus_Error   <=  '0';
        Rst2Bus_RdAck   <=  '0';
        Rst2Bus_Retry   <=  '0';
        Rst2Bus_ToutSup <=  '0';
        Rst2Bus_WrAck   <=  '0';
        Bus2IP_Reset_i  <=  Reset; -- No sw reset capability since
                                   -- reset_control is excluded.
  end generate REMOVE_RESET;



-------------------------------------------------------------------------------

  INCLUDE_INTERRUPT : if (INTERRUPT_PRESENT) generate

     Constant INDEX    : integer := get_id_index(C_ARD_ID_ARRAY,IPIF_INTR);
     Constant CE_INDEX : integer := calc_start_ce_index(C_ARD_NUM_CE_ARRAY,
                                                        INDEX);

  begin


    I_INTERRUPT_CONTROL: entity ipif_common_v1_00_d.interrupt_control
      generic map (C_INTERRUPT_REG_NUM    => INTERRUPT_REG_NUM,
                   C_NUM_IPIF_IRPT_SRC    => 4,
                   C_IP_INTR_MODE_ARRAY   => C_IP_INTR_MODE_ARRAY,
                   C_INCLUDE_DEV_PENCODER => (C_INCLUDE_DEV_PENCODER /= 0) and
                                             (C_INCLUDE_DEV_ISC /= 0),
                   C_INCLUDE_DEV_ISC      => (C_INCLUDE_DEV_ISC /= 0),
                   C_IRPT_DBUS_WIDTH      => C_IPIF_DWIDTH)
      port map (
                Bus2IP_Clk_i => Bus2IP_Clk_i,
                Bus2IP_Data_sa => Bus2IP_Data_i(0 to C_OPB_DWIDTH - 1),
                Bus2IP_RdReq_sa => Bus2IP_RdReq_i,
                Bus2IP_Reset_i => Bus2IP_Reset_i,
                Bus2IP_WrReq_sa => Bus2IP_WrReq_i,
                Interrupt_RdCE => RdCE_Out(CE_INDEX to CE_INDEX+INTERRUPT_REG_NUM - 1),
                Interrupt_WrCE => WrCE_Out(CE_INDEX to CE_INDEX+INTERRUPT_REG_NUM - 1),
                Intr2Bus_DBus => Intr2Bus_DBus(0 to C_OPB_DWIDTH - 1),
                Intr2Bus_DevIntr => Intr2Bus_DevIntr,
                Intr2Bus_Error => Intr2Bus_Error,
                Intr2Bus_RdAck => Intr2Bus_RdAck,
                Intr2Bus_Retry => Intr2Bus_Retry,
                Intr2Bus_ToutSup => Intr2Bus_ToutSup,
                Intr2Bus_WrAck => Intr2Bus_WrAck,
                IP2Bus_IntrEvent => IP2Bus_IntrEvent,
                IPIF_Lvl_Interrupts => IPIF_Lvl_Interrupts(0 to 3),
                IPIF_Reg_Interrupts => IPIF_Reg_Interrupts(0 to 1));

 end generate INCLUDE_INTERRUPT;


  REMOVE_INTERRUPT : if (not INTERRUPT_PRESENT) generate

      Intr2Bus_DBus     <=  (others => '0');
      Intr2Bus_DevIntr  <=  IP2Bus_IntrEvent(0);
      Intr2Bus_Error    <=  '0';
      Intr2Bus_RdAck    <=  '0';
      Intr2Bus_Retry    <=  '0';
      Intr2Bus_ToutSup  <=  '0';
      Intr2Bus_WrAck    <=  '0';

 end generate REMOVE_INTERRUPT;



 ------------------------------------------------------------------------------

  INCLUDE_RDFIFO : if (RDFIFO_PRESENT) generate

   constant DATA_INDEX: integer := get_id_index(C_ARD_ID_ARRAY,
                                                IPIF_RDFIFO_DATA);
   constant DATA_CE_INDEX : integer := calc_start_ce_index(C_ARD_NUM_CE_ARRAY,
                                                           DATA_INDEX);
   constant REG_INDEX: integer := get_id_index(C_ARD_ID_ARRAY,
                                               IPIF_RDFIFO_REG);
   constant REG_CE_INDEX : integer := calc_start_ce_index(C_ARD_NUM_CE_ARRAY,
                                                          REG_INDEX);
   signal opb_seqaddr_d1 : std_logic;

  begin

    assert C_ARD_DEPENDENT_PROPS_ARRAY(DATA_INDEX)(WR_WIDTH_BITS) =
           C_ARD_DEPENDENT_PROPS_ARRAY(DATA_INDEX)(RD_WIDTH_BITS)
    report "This implementation of the OPB IPIF requires the read " &
           " width to be equal to the write width for the RDFIFO."
    severity FAILURE;

    OPB_SEQADDR_DN_PROC : process (Bus2IP_Clk_i) is
    begin
        if Bus2IP_Clk_i'event and Bus2IP_Clk_i = '1' then
            opb_seqaddr_d1 <= OPB_seqAddr;
        end if;
    end process;



    I_RDFIFO: entity opb_ipif_v2_00_h.rdpfifo_top
      Generic map(
        C_MIR_ENABLE          => (C_DEV_MIR_ENABLE /= 0),
        C_BLOCK_ID            => C_DEV_BLK_ID,
        C_FIFO_DEPTH_LOG2X    => log2(
                                     C_ARD_DEPENDENT_PROPS_ARRAY
                                         (DATA_INDEX)
                                             (FIFO_CAPACITY_BITS) /
                                     C_ARD_DEPENDENT_PROPS_ARRAY
                                         (DATA_INDEX)
                                             (WR_WIDTH_BITS)
                                 ),
        C_FIFO_WIDTH          => C_ARD_DEPENDENT_PROPS_ARRAY
                                     (DATA_INDEX)
                                         (WR_WIDTH_BITS),
        C_INCLUDE_PACKET_MODE => C_ARD_DEPENDENT_PROPS_ARRAY
                                     (DATA_INDEX)
                                         (EXCLUDE_PACKET_MODE)=0,
        C_INCLUDE_VACANCY     => C_ARD_DEPENDENT_PROPS_ARRAY
                                     (DATA_INDEX)
                                         (EXCLUDE_VACANCY)=0,
        C_SUPPORT_BURST       => true,
        C_IPIF_DBUS_WIDTH     => C_IPIF_DWIDTH,
        C_VIRTEX_II           => VIRTEX_II
              )
      port map(
      -- Inputs From the IPIF Bus
        Bus_rst               =>  Bus2IP_Reset_i,
        Bus_Clk               =>  Bus2IP_Clk_i,
        Bus_RdReq             =>  bus2ip_rdreq_rfifo,
        Bus_WrReq             =>  Bus2IP_WrReq_i,
        Bus2FIFO_RdCE1        =>  RdCE_Out(REG_CE_INDEX),
        Bus2FIFO_RdCE2        =>  RdCE_Out(REG_CE_INDEX+1),
        Bus2FIFO_RdCE3        =>  RdCE_Out(DATA_CE_INDEX),
        Bus2FIFO_WrCE1        =>  WrCE_Out(REG_CE_INDEX),
        Bus2FIFO_WrCE2        =>  WrCE_Out(REG_CE_INDEX+1),
        Bus2FIFO_WrCE3        =>  WrCE_Out(DATA_CE_INDEX),
        Bus_DBus              =>  Bus2IP_Data_i,
      -- Inputs from the IP
        IP2RFIFO_WrReq        =>  IP2RFIFO_WrReq,
        IP2RFIFO_WrMark       =>  IP2RFIFO_WrMark,
        IP2RFIFO_WrRestore    =>  IP2RFIFO_WrRestore,
        IP2RFIFO_WrRelease    =>  IP2RFIFO_WrRelease,
        IP2RFIFO_Data         =>  IP2RFIFO_Data,
      -- Outputs to the IP
        RFIFO2IP_WrAck        =>  RFIFO2IP_WrAck,
        RFIFO2IP_AlmostFull   =>  RFIFO2IP_AlmostFull,
        RFIFO2IP_Full         =>  RFIFO2IP_Full,
        RFIFO2IP_Vacancy      =>  RFIFO2IP_Vacancy,
      -- Outputs to the IPIF DMA/SG function
        RFIFO2DMA_AlmostEmpty =>  RFIFO2DMA_AlmostEmpty,
        RFIFO2DMA_Empty       =>  RFIFO2DMA_Empty,
        RFIFO2DMA_Occupancy   =>  RFIFO2DMA_Occupancy,
      -- Interrupt Output to IPIF Interrupt Register
        FIFO2IRPT_DeadLock    =>  RdFIFO2Intr_DeadLock,
      -- Outputs to the IPIF Bus
        FIFO2Bus_DBus         =>  RdFIFO2Bus_Data,
        FIFO2Bus_WrAck        =>  RFIFO_WrAck,
        FIFO2Bus_RdAck        =>  RFIFO_RdAck,
        FIFO2Bus_Error        =>  RFIFO_Error,
        FIFO2Bus_Retry        =>  RFIFO_Retry,
        FIFO2Bus_ToutSup      =>  RFIFO_ToutSup
      );

  end generate INCLUDE_RDFIFO;


  REMOVE_RDFIFO : if (not RDFIFO_PRESENT) generate

          RdFIFO2Bus_Data       <=  (others => '0');
          RdFIFO2Intr_DeadLock  <=  '0';
          RFIFO2DMA_AlmostEmpty <=  '0';
          RFIFO2DMA_Empty       <=  '0';
          RFIFO2DMA_Occupancy   <=  (others => '0');
          RFIFO2IP_AlmostFull   <=  '0';
          RFIFO2IP_Full         <=  '0';
          RFIFO2IP_Vacancy      <=  (others => '0');
          RFIFO2IP_WrAck        <=  '0';
          RFIFO_Error           <=  '0';
          RFIFO_RdAck           <=  '0';
          RFIFO_Retry           <=  '0';
          RFIFO_ToutSup         <=  '0';
          RFIFO_WrAck           <=  '0';

  end generate REMOVE_RDFIFO;


--------------------------------------------------------------------------------
  INCLUDE_WRFIFO : if (WRFIFO_PRESENT) generate

   constant DATA_INDEX: integer := get_id_index(C_ARD_ID_ARRAY,
                                                IPIF_WRFIFO_DATA);
   constant DATA_CE_INDEX : integer := calc_start_ce_index(C_ARD_NUM_CE_ARRAY,
                                                           DATA_INDEX);
   constant REG_INDEX: integer := get_id_index(C_ARD_ID_ARRAY,
                                               IPIF_WRFIFO_REG);
   constant REG_CE_INDEX : integer := calc_start_ce_index(C_ARD_NUM_CE_ARRAY,
                                                          REG_INDEX);
  begin

    assert C_ARD_DEPENDENT_PROPS_ARRAY(DATA_INDEX)(WR_WIDTH_BITS) =
           C_ARD_DEPENDENT_PROPS_ARRAY(DATA_INDEX)(RD_WIDTH_BITS)
    report "This implementation of the OPB IPIF requires the read " &
           " width to be equal to the write width for the RDFIFO."
    severity FAILURE;

    I_WRPFIFO_TOP: entity opb_ipif_v2_00_h.wrpfifo_top
      Generic map(
          C_MIR_ENABLE          => (C_DEV_MIR_ENABLE /= 0),
          C_BLOCK_ID            => C_DEV_BLK_ID,
          C_FIFO_DEPTH_LOG2X    => log2(
                                       C_ARD_DEPENDENT_PROPS_ARRAY
                                           (DATA_INDEX)
                                               (FIFO_CAPACITY_BITS) /
                                       C_ARD_DEPENDENT_PROPS_ARRAY
                                           (DATA_INDEX)
                                               (WR_WIDTH_BITS)
                                   ),
          C_FIFO_WIDTH          => C_ARD_DEPENDENT_PROPS_ARRAY
                                       (DATA_INDEX)
                                           (WR_WIDTH_BITS),
          C_INCLUDE_PACKET_MODE => C_ARD_DEPENDENT_PROPS_ARRAY
                                       (DATA_INDEX)
                                           (EXCLUDE_PACKET_MODE)=0,
          C_INCLUDE_VACANCY     => C_ARD_DEPENDENT_PROPS_ARRAY
                                       (DATA_INDEX)
                                           (EXCLUDE_VACANCY)=0,
          C_SUPPORT_BURST       =>  true,
          C_IPIF_DBUS_WIDTH     =>  C_IPIF_DWIDTH,
          C_VIRTEX_II           =>  VIRTEX_II
              )
      port map(
        -- Inputs From the IPIF Bus
          Bus_rst               =>  Bus2IP_Reset_i, -- In  std_logic;
          Bus_clk               =>  Bus2IP_Clk_i, -- In  std_logic;
          Bus_RdReq             =>  Bus2IP_RdReq_i, -- In  std_logic;
          Bus_WrReq             =>  Bus2IP_WrReq_i, -- In  std_logic;
          Bus2FIFO_RdCE1        =>  RdCE_Out(REG_CE_INDEX),
          Bus2FIFO_RdCE2        =>  RdCE_Out(REG_CE_INDEX+1),
          Bus2FIFO_RdCE3        =>  RdCE_Out(DATA_CE_INDEX),
          Bus2FIFO_WrCE1        =>  WrCE_Out(REG_CE_INDEX),
          Bus2FIFO_WrCE2        =>  WrCE_Out(REG_CE_INDEX+1),
          Bus2FIFO_WrCE3        =>  WrCE_Out(DATA_CE_INDEX),
          Bus_DBus              =>  Bus2IP_Data_i, -- In  std_logic_vector(0 to C_IPIF_DWIDTH-1);
        -- Inputs from the IP
          IP2WFIFO_RdReq        =>  IP2WFIFO_RdReq, -- In std_logic;
          IP2WFIFO_RdMark       =>  IP2WFIFO_RdMark, -- In std_logic;
          IP2WFIFO_RdRestore    =>  IP2WFIFO_RdRestore, -- In std_logic;
          IP2WFIFO_RdRelease    =>  IP2WFIFO_RdRelease, -- In std_logic;
        -- Outputs to the IP
          WFIFO2IP_Data         =>  WFIFO2IP_Data, -- Out std_logic_vector(0 to C_FIFO_WIDTH-1);
          WFIFO2IP_RdAck        =>  WFIFO2IP_RdAck, -- Out std_logic;
          WFIFO2IP_AlmostEmpty  =>  WFIFO2IP_AlmostEmpty, -- Out std_logic;
          WFIFO2IP_Empty        =>  WFIFO2IP_Empty, -- Out std_logic;
          WFIFO2IP_Occupancy    =>  WFIFO2IP_Occupancy,
        -- Outputs to the IPIF DMA/SG function
          WFIFO2DMA_AlmostFull  =>  WFIFO2DMA_AlmostFull, -- Out std_logic;
          WFIFO2DMA_Full        =>  WFIFO2DMA_Full, -- Out std_logic;
          WFIFO2DMA_Vacancy     =>  WFIFO2DMA_Vacancy,
        -- Interrupt Output to IPIF Interrupt Register
          FIFO2IRPT_DeadLock    =>  WrFIFO2Intr_DeadLock, -- Out std_logic;
        -- Outputs to the IPIF Bus
          FIFO2Bus_DBus         =>  WrFIFO2Bus_Data, -- Out std_logic_vector(0 to C_IPIF_DWIDTH-1);
          FIFO2Bus_WrAck        =>  WFIFO_WrAck, -- Out std_logic;
          FIFO2Bus_RdAck        =>  WFIFO_RdAck, -- Out std_logic;
          FIFO2Bus_Error        =>  WFIFO_Error, -- Out std_logic;
          FIFO2Bus_Retry        =>  WFIFO_Retry, -- Out std_logic;
          FIFO2Bus_ToutSup      =>  WFIFO_ToutSup  -- Out std_logic
        );

  end generate INCLUDE_WRFIFO;


  REMOVE_WRFIFO : if (not WRFIFO_PRESENT) generate

                WFIFO2DMA_Full        <=  '0';
                WFIFO2DMA_Vacancy     <=  (others => '0');
                WFIFO2IP_AlmostEmpty  <=  '0';
                WFIFO2IP_Data         <=  (others => '0');
                WFIFO2IP_Empty        <=  '0';
                WFIFO2IP_Occupancy    <=  (others => '0');
                WFIFO2IP_RdAck        <=  '0';
                WFIFO_Error           <=  '0';
                WFIFO_RdAck           <=  '0';
                WFIFO_Retry           <=  '0';
                WFIFO_ToutSup         <=  '0';
                WFIFO_WrAck           <=  '0';
                WrFIFO2Bus_Data       <=  (others => '0');
                WrFIFO2Intr_DeadLock  <=  '0';


  end generate REMOVE_WRFIFO;


 ------------------------------------------------------------------------------

 ------------------------------------------------------------------------------
 -- Include DMA in the IPIF
 ------------------------------------------------------------------------------
  INCLUDE_DMA : if (DMA_PRESENT) generate

     Constant DMA_INDEX      : integer := get_id_index(C_ARD_ID_ARRAY,IPIF_DMA_SG);
     Constant DMA_CE_INDEX   : integer := calc_start_ce_index(C_ARD_NUM_CE_ARRAY, DMA_INDEX);

  begin

    dma_sg_i1 : dma_sg
    generic map (
       C_OPB_DWIDTH           =>  C_OPB_DWIDTH,
       C_OPB_AWIDTH           =>  C_OPB_AWIDTH,
       C_IPIF_ABUS_WIDTH      =>  C_OPB_AWIDTH,
       C_CLK_PERIOD_PS        =>  C_OPB_CLK_PERIOD_PS,
       C_PACKET_WAIT_UNIT_NS  =>  C_DMA_PACKET_WAIT_UNIT_NS,

       C_DMA_CHAN_TYPE        => C_DMA_CHAN_TYPE_ARRAY,

       C_DMA_LENGTH_WIDTH     => C_DMA_LENGTH_WIDTH_ARRAY,

       C_LEN_FIFO_ADDR        => C_DMA_PKT_LEN_FIFO_ADDR_ARRAY,

       C_STAT_FIFO_ADDR       => C_DMA_PKT_STAT_FIFO_ADDR_ARRAY,

       C_INTR_COALESCE        => C_DMA_INTR_COALESCE_ARRAY,

       C_DEV_BLK_ID           => C_DEV_BLK_ID,

       C_DMA_BASEADDR         => ZERO_ADDR_PREFIX & DMA_BASEADDR,
       C_DMA_BURST_SIZE       => DMA_BURST_SIZE,
       C_DMA_SHORT_BURST_REMAINDER => C_DMA_SHORT_BURST_REMAINDER,
       C_MA2SA_NUM_WIDTH      => log2(C_DEV_MAX_BURST_SIZE/4 + 1),

       C_WFIFO_VACANCY_WIDTH  =>
           bits_needed_for_vac(
               find_ard_id(C_ARD_ID_ARRAY, IPIF_WRFIFO_DATA),
               C_ARD_DEPENDENT_PROPS_ARRAY(
                   get_id_index_iboe(C_ARD_ID_ARRAY, IPIF_WRFIFO_DATA)
               )
           )
    )
    port map (
          DMA2Bus_Data          => DMA2Bus_Data,
          DMA2Bus_Addr          => DMA2Bus_Addr,
          DMA2Bus_MstBE         => DMA2Bus_MstBE,
          DMA2Bus_MstWrReq      => DMA2Bus_MstWrReq,
          DMA2Bus_MstRdReq      => DMA2Bus_MstRdReq,
          DMA2Bus_MstNum        => DMA2Bus_MstNum,
          DMA2Bus_MstBurst      => DMA2Bus_MstBurst,
          DMA2Bus_MstBusLock    => DMA2Bus_MstBusLock,
          DMA2IP_Addr           => DMA2IP_Addr(0 to C_OPB_AWIDTH-3),
          DMA2Bus_WrAck         => DMA2Bus_WrAck,
          DMA2Bus_RdAck         => DMA2Bus_RdAck,
          DMA2Bus_Retry         => DMA2Bus_Retry,
          DMA2Bus_Error         => DMA2Bus_Error,
          DMA2Bus_ToutSup       => DMA2Bus_ToutSup,
          Bus2IP_MstWrAck       => Bus2IP_MstWrAck_ma,
          Bus2IP_MstRdAck       => Bus2IP_MstRdAck_ma,
          Mstr_sel_ma           => Mstr_sel_ma,
          Bus2IP_MstRetry       => Bus2IP_MstRetry_i,
          Bus2IP_MstError       => Bus2IP_MstError_i,
          Bus2IP_MstTimeOut     => Bus2IP_MstTimeOut_i,
          Bus2IP_BE             => Bus2IP_BE_i,
          Bus2IP_WrReq          => Bus2IP_WrReq_i,
          Bus2IP_RdReq          => Bus2IP_RdReq_i,
          Bus2IP_Clk            => Bus2IP_Clk_i,
          Bus2IP_Reset          => Bus2IP_Reset_i,
          Bus2IP_Freeze         => Bus2IP_Freeze_i,
          Bus2IP_Addr           => Bus2IP_Addr_i(0 to C_OPB_AWIDTH-3),
          Bus2IP_Data           => Bus2IP_Data_i,
          Bus2IP_Burst          => Bus2IP_Burst_i,
          WFIFO2DMA_Vacancy     => WFIFO2DMA_Vacancy,
          Bus2IP_MstLastAck     => Bus2IP_MstLastAck_i,
          DMA_RdCE              => RdCE_Out(DMA_CE_INDEX),
          DMA_WrCE              => WrCE_Out(DMA_CE_INDEX),
          IP2DMA_RxStatus_Empty => IP2DMA_RxStatus_Empty,
          IP2DMA_RxLength_Empty => IP2DMA_RxLength_Empty,
          IP2DMA_TxStatus_Empty => IP2DMA_TxStatus_Empty,
          IP2DMA_TxLength_Full  => IP2DMA_TxLength_Full,
          IP2Bus_DMA_Req        => IP2Bus_DMA_Req,
          Bus2IP_DMA_Ack        => Bus2IP_DMA_Ack,
          DMA2Intr_Intr         => DMA2Intr_Intr
    );
    DMA2IP_Addr(C_OPB_AWIDTH-2 to C_OPB_AWIDTH-1) <= (others => '0');

 end generate INCLUDE_DMA;


------------------------------------------------------------------------------
    -- Don't include DMA in the IPIF . Drive all outputs to zero.
------------------------------------------------------------------------------

    REMOVE_DMA : if (not DMA_PRESENT) generate

           Bus2IP_DMA_Ack      <=  '0';
           DMA2Bus_Addr        <=  (others => '0');
           DMA2Bus_Data        <=  (others => '0');
           DMA2Intr_Intr       <=  (others => '0');
           DMA2IP_Addr         <=  (others => '0');
           DMA2Bus_MstBE       <=  (others => '0');
           DMA2Bus_MstBurst    <=  '0';
           DMA2Bus_MstBusLock  <=  '0';
           DMA2Bus_MstRdReq    <=  '0';
           DMA2Bus_MstWrReq    <=  '0';
           DMA2Bus_Error        <=  '0';
           DMA2Bus_RdAck        <=  '0';
           DMA2Bus_Retry        <=  '0';
           DMA2Bus_ToutSup      <=  '0';
           DMA2Bus_WrAck        <=  '0';


      end generate REMOVE_DMA;



-------------------------------------------------------------------------------
-- Misc logic assignments

  Bus2IP_Addr       <= Bus2IP_Addr_i;

  Bus2IP_Data       <= Bus2IP_Data_i(0 to C_IPIF_DWIDTH-1);

  Bus2IP_BE         <= Bus2IP_BE_i;
  Bus2IP_WrReq      <= Bus2IP_WrReq_i;
  Bus2IP_RdReq      <= Bus2IP_RdReq_i;
  Bus2IP_Burst      <= Bus2IP_Burst_i ;

  Bus2IP_MstWrAck   <= Bus2IP_MstWrAck_ma and not(Mstr_sel_ma);
  Bus2IP_MstRdAck   <= Bus2IP_MstRdAck_ma and not(Mstr_sel_ma);
  Bus2IP_MstRetry   <= Bus2IP_MstRetry_i  and not(Mstr_sel_ma);
  Bus2IP_MstError   <= Bus2IP_MstError_i;
  Bus2IP_MstTimeOut <= Bus2IP_MstTimeOut_i and not(Mstr_sel_ma);
  Bus2IP_MstLastAck <= Bus2IP_MstLastAck_i and not(Mstr_sel_ma);

  Bus2IP_Clk_i      <= OPB_Clk;
  Bus2IP_Clk        <= OPB_Clk;

  Bus2IP_Freeze_i   <= Freeze;
  Bus2IP_Freeze     <= Freeze;

  IP2INTC_Irpt      <= Intr2Bus_DevIntr;

  IPIF_Lvl_Interrupts(0) <= DMA2Intr_Intr(0);
  IPIF_Lvl_Interrupts(1) <= DMA2Intr_Intr(1);
  IPIF_Lvl_Interrupts(2) <= RdFIFO2Intr_DeadLock;
  IPIF_Lvl_Interrupts(3) <= WrFIFO2Intr_DeadLock;

  IPIF_Reg_Interrupts(0) <= IP2Bus_Error_mx;
  IPIF_Reg_Interrupts(1) <= const_zero;

  Bus2IP_Reset      <= Bus2IP_Reset_i; -- hw or sw reset; if no sw reset
                                       -- function is included, then this
                                       -- is set equal to the hw reset, Reset.
  Bus2IP_RNW        <= Bus2IP_RNW_i;

  const_zero        <= LOGIC_LOW;




end implementation;

