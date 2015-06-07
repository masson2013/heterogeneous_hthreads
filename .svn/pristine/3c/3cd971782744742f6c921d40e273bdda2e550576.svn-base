set slave $group/slave_$i
set ROW 2
set COL 4
# #################################################################
# BRAM NAME LIST
# #################################################################
set LIST ""
if {[expr $ROW > 1] && [expr $COL > 1]} {
	for {set edge 1} {$edge <= 4} {incr edge} \
	{
		if {[expr $edge % 2] != 0} {
			for {set jj 0} {$jj < $COL} {incr jj} \
			{
				lappend LIST $edge$jj
			}
		} else {
			for {set jj 0} {$jj < $ROW} {incr jj} \
			{
				lappend LIST $edge$jj
			}
		}
	}
} elseif {[expr $ROW == 1]} {
	for {set edge 1} {$edge <= 4} {incr edge} \
	{
		if {[expr $edge % 2] != 0} {
			for {set jj 0} {$jj < $COL} {incr jj} \
			{
				if {[expr $edge == 3] && ([expr $jj == 0] || [expr $jj == $COL - 1])} {
					continue
				}
				lappend LIST $edge$jj
			}
		} else {
			for {set jj 0} {$jj < $ROW} {incr jj} \
			{
				lappend LIST $edge$jj
			}
		}
	}
} elseif {[expr $COL == 1]} {
	for {set edge 1} {$edge <= 4} {incr edge} \
	{
		if {[expr $edge % 2] != 0} {
			for {set jj 0} {$jj < $COL} {incr jj} \
			{
				lappend LIST $edge$jj
			}
		} else {
			for {set jj 0} {$jj < $ROW} {incr jj} \
			{
				if {[expr $edge == 2] && ([expr $jj == 0] || [expr $jj == $ROW - 1])} {
					continue
				}
				lappend LIST $edge$jj
			}
		}
	}
}
set BRAM_NAME_LIST $LIST
# #################################################################
# BIF LIST NAME
# #################################################################
set LIST ""
if {[expr $ROW > 1] && [expr $COL > 1]} {
	for {set ii 0} {$ii < $ROW} {incr ii} {
		for {set jj 0} {$jj < $COL} {incr jj} {
			if {($ii > 0 && $ii < [expr $ROW -1]) && ($jj > 0 && $jj < [expr $COL - 1])} {
				continue
			}
			if {$ii == 0 && $jj == 0} {
				lappend LIST bif_$ii$jj\_1_bram
				lappend LIST bif_$ii$jj\_2_bram
				continue
			}
			if {$ii == 0 && $jj == [expr $COL - 1]} {
				lappend LIST bif_$ii$jj\_1_bram
				lappend LIST bif_$ii$jj\_2_bram
				continue
			}
			if {$ii == [expr $ROW - 1] && $jj == 0} {
				lappend LIST bif_$ii$jj\_1_bram
				lappend LIST bif_$ii$jj\_2_bram
				continue
			}
			if {$ii == [expr $ROW - 1] && $jj == [expr $COL -1]} {
				lappend LIST bif_$ii$jj\_1_bram
				lappend LIST bif_$ii$jj\_2_bram
				continue
			}
			if {$ii == 0 && $jj > 0 && $jj < [expr $COL - 1]} {
				lappend LIST bif_$ii$jj\_1_bram
				continue
			}
			if {$ii == [expr $ROW - 1] && $jj > 0 && $jj < [expr $COL - 1]} {
				lappend LIST bif_$ii$jj\_1_bram
				continue
			}
			if {$jj == 0 && $ii > 0 && $ii < [expr $COL - 1]} {
				lappend LIST bif_$ii$jj\_2_bram
				continue
			}
			if {$jj == [expr $ROW - 1] && $ii > 0 && $ii < [expr $COL - 1]} {
				lappend LIST bif_$ii$jj\_2_bram
				continue
			}
		}
	}
} elseif {[expr $ROW == 1] || [expr $COL == 1]} {
	for {set ii 0} {$ii < $ROW} {incr ii} {
		for {set jj 0} {$jj < $COL} {incr jj} {
			lappend LIST bif_$ii$jj\_1_bram
			lappend LIST bif_$ii$jj\_2_bram
		}
	}
}
set BIF_NAME_LIST $LIST
# #################################################################
# SWITCH NAME LIST
# #################################################################
set LIST ""
for {set ii 0} {$ii < $ROW} {incr ii} {
	for {set jj 0} {$jj < $COL} {incr jj} {
		lappend LIST switch_$ii$jj
	}
}
set SWITCH_NAME_LIST $LIST
# #################################################################
# ACC NAME LIST
# #################################################################
set LIST ""
for {set ii 0} {$ii < $ROW} {incr ii} {
	for {set jj 0} {$jj < $COL} {incr jj} {
		lappend LIST ACC_PR$ii$jj
	}
}
set ACC_NAME_LIST $LIST
# #################################################################
# ACC FIFO NAME LIST
# #################################################################
set LIST ""
for {set ii 0} {$ii < $ROW} {incr ii} {
	for {set jj 0} {$jj < $COL} {incr jj} {
		lappend LIST ACC_PR$ii$jj\_FIFO_IN1
		lappend LIST ACC_PR$ii$jj\_FIFO_IN2
	}
}
set FIFO_NAME_LIST $LIST


set_property ip_repo_paths  {../../../../../src/hardware/MyRepository/pcores/axi_hthread_cores/ ../../../../../src/hardware/MyRepository/pcores/vivado_cores ../../../../../src/hardware/MyRepository/pcores/SFA_cores} [current_fileset]
update_ip_catalog

create_bd_cell -type hier $slave
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.3 $slave/microblaze_1
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/global_vhwti_cntrl_[expr $j * $C + $i]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/local_vhwti_cntrl
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/blk_mem_gen_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/group1_bus
copy_bd_objs $slave  [get_bd_cells {host_local_memory}]
set_property name microblaze_0_local_memory [get_bd_cells $slave/host_local_memory]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/dma_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 $slave/local_dma
create_bd_cell -type ip -vlnv user.org:user:sm_timer_64:1.0 $slave/sm_timer_64_0
# #################################################################
set CLK host_Clk
set RstName peripherals_peripheral_reset
set nRstName S00_ARESETN_1
# #################################################################

set tmpname $slave/SFA_ARRAY_00
create_bd_cell -type hier $tmpname
create_bd_pin -dir I $tmpname/s_axi_aclk
create_bd_pin -dir I $tmpname/s_axi_aresetn

set slave $slave/SFA_ARRAY_00

# #################################################################
# BRAMs
# #################################################################
# set BRAM_NAME_LIST {10}
set LIST_LEN [llength $BRAM_NAME_LIST]
for {set ii 0} {$ii < $LIST_LEN} {incr ii} \
{
	set tmpname BRAM[lindex $BRAM_NAME_LIST $ii]
	set ctrlname AXI_BRAM_CTRL_[lindex $BRAM_NAME_LIST $ii]
	set bramname ACC_BRAM_[lindex $BRAM_NAME_LIST $ii]
	set bramport BRAM_[lindex $BRAM_NAME_LIST $ii]

	set sAXIsname sAXIs_[lindex $BRAM_NAME_LIST $ii]
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 $slave/$sAXIsname

	set tmpname $slave/$tmpname
	create_bd_cell -type hier $tmpname

	create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $tmpname/$ctrlname
	set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells $tmpname/$ctrlname]
	set_property -dict [list CONFIG.PROTOCOL {AXI4}] [get_bd_cells $tmpname/$ctrlname]
	create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $tmpname/$bramname
	set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}] [get_bd_cells $tmpname/$bramname]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/$ctrlname/BRAM_PORTA] [get_bd_intf_pins $tmpname/$bramname/BRAM_PORTB]
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 $tmpname/$bramport
	connect_bd_intf_net [get_bd_intf_pins $tmpname/$bramport] [get_bd_intf_pins $tmpname/$bramname/BRAM_PORTA]

	create_bd_pin -dir I $tmpname/s_axi_aclk
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/$ctrlname/s_axi_aclk]
	connect_bd_net [get_bd_pins $tmpname/$ctrlname/s_axi_aclk] [get_bd_pins $tmpname/$bramname/clka]
	connect_bd_net [get_bd_pins $tmpname/$ctrlname/s_axi_aclk] [get_bd_pins $tmpname/$bramname/clkb]

	create_bd_pin -dir I $tmpname/s_axi_aresetn
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/$ctrlname/s_axi_aresetn]

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 $tmpname/S_AXI
	connect_bd_intf_net [get_bd_intf_pins $tmpname/S_AXI] [get_bd_intf_pins $tmpname/$ctrlname/S_AXI]

	connect_bd_intf_net 	[get_bd_intf_pins $slave/$sAXIsname] 	[get_bd_intf_pins $tmpname/S_AXI]

	connect_bd_net 		[get_bd_pins $slave/s_axi_aclk] 	[get_bd_pins $tmpname/s_axi_aclk]
	connect_bd_net 		[get_bd_pins $slave/s_axi_aresetn] 	[get_bd_pins $tmpname/s_axi_aresetn]
}

# #################################################################
# NOC
# #################################################################
	set nocname sfa_$ROW\x$COL
	create_bd_cell -type ip -vlnv user.org:user:$nocname:1.0 $slave/sfa_$ROW\x$COL\_0
	connect_bd_net 		[get_bd_pins $slave/s_axi_aclk] 	  [get_bd_pins $slave/sfa_$ROW\x$COL\_0/ACLK]
	connect_bd_net 		[get_bd_pins $slave/s_axi_aresetn] 	[get_bd_pins $slave/sfa_$ROW\x$COL\_0/ARESETN]

	set LIST_LEN [llength $BRAM_NAME_LIST]
	for {set ii 0} {$ii < $LIST_LEN} {incr ii} \
	{
		set bram     BRAM[lindex $BRAM_NAME_LIST $ii]
		set bramport BRAM_[lindex $BRAM_NAME_LIST $ii]
		set bifport  [lindex $BIF_NAME_LIST $ii]
		connect_bd_intf_net [get_bd_intf_pins $slave/sfa_$ROW\x$COL\_0/$bifport] -boundary_type upper [get_bd_intf_pins $slave/$bram/$bramport]
	}

	set LIST_LEN [llength $SWITCH_NAME_LIST]
	for {set ii 0} {$ii < $LIST_LEN} {incr ii} \
	{
		set cmdport [lindex $SWITCH_NAME_LIST $ii]_sCMD
		set retport [lindex $SWITCH_NAME_LIST $ii]_mRet
		create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $slave/$cmdport
		connect_bd_intf_net [get_bd_intf_pins $slave/$cmdport] [get_bd_intf_pins $slave/sfa_$ROW\x$COL\_0/$cmdport]
		create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $slave/$retport
		connect_bd_intf_net [get_bd_intf_pins $slave/$retport] [get_bd_intf_pins $slave/sfa_$ROW\x$COL\_0/$retport]
	}

# #################################################################
# FIFOs Between NOC and ACC
# #################################################################
#set FIFO_NAME_LIST {C00 C01 C02 C10 C11 C12 R00 R01 R02 R10 R11 R12}
set tmpname ACC_FIFO
set tmpname $slave/$tmpname
create_bd_cell -type hier $tmpname
create_bd_pin -dir I $tmpname/s_axi_aclk
create_bd_pin -dir I $tmpname/s_axi_aresetn
connect_bd_net 	[get_bd_pins $slave/s_axi_aclk] 	[get_bd_pins $tmpname/s_axi_aclk]
connect_bd_net 	[get_bd_pins $slave/s_axi_aresetn] 	[get_bd_pins $tmpname/s_axi_aresetn]

set LIST_LEN [llength $FIFO_NAME_LIST]
for {set ii 0} {$ii< $LIST_LEN} {incr ii} \
{
	set fifoname [lindex $FIFO_NAME_LIST $ii]
	set sPort [lindex $FIFO_NAME_LIST $ii]_sAXIs
	set mPort [lindex $FIFO_NAME_LIST $ii]_mAXIs

	create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 $tmpname/$fifoname
	# create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/$fifoname
	# set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/$fifoname]

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/$sPort
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/$mPort

	connect_bd_intf_net [get_bd_intf_pins $tmpname/$sPort] [get_bd_intf_pins $tmpname/$fifoname/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/$mPort] [get_bd_intf_pins $tmpname/$fifoname/M_AXIS]

	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/$fifoname/aclk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/$fifoname/aresetn]
}

# #################################################################
# ACC
# #################################################################
set LIST_LEN [llength $ACC_NAME_LIST]
set kk 0
for {set ii 0} {$ii < $LIST_LEN} {incr ii} \
{
	set accname  [lindex $ACC_NAME_LIST $ii]
	set macc1    [lindex $SWITCH_NAME_LIST $ii]\_macc1
	set macc2    [lindex $SWITCH_NAME_LIST $ii]\_macc2
	set sacc     [lindex $SWITCH_NAME_LIST $ii]\_sacc
	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_vadd:1.0 $slave/$accname

	set fifoname [lindex $FIFO_NAME_LIST $kk]
	connect_bd_intf_net [get_bd_intf_pins $slave/$accname/sI1] [get_bd_intf_pins $slave/ACC_FIFO/$fifoname\_mAXIs]
	connect_bd_intf_net [get_bd_intf_pins $slave/sfa_$ROW\x$COL\_0/$macc1] [get_bd_intf_pins $slave/ACC_FIFO/$fifoname\_sAXIs]
	incr kk
	set fifoname [lindex $FIFO_NAME_LIST $kk]
	connect_bd_intf_net [get_bd_intf_pins $slave/$accname/sI2] [get_bd_intf_pins $slave/ACC_FIFO/$fifoname\_mAXIs]
	connect_bd_intf_net [get_bd_intf_pins $slave/sfa_$ROW\x$COL\_0/$macc2] [get_bd_intf_pins $slave/ACC_FIFO/$fifoname\_sAXIs]
	incr kk

	connect_bd_intf_net [get_bd_intf_pins $slave/sfa_$ROW\x$COL\_0/$sacc]  [get_bd_intf_pins $slave/$accname/mO1]
	connect_bd_net 		[get_bd_pins $slave/s_axi_aclk] 	  [get_bd_pins $slave/$accname/ap_clk]
	connect_bd_net 		[get_bd_pins $slave/s_axi_aresetn] 	[get_bd_pins $slave/$accname/ap_rst_n]
}

set slave $group/slave_$i

set_property -dict [list CONFIG.C_FSL_LINKS [expr $ROW * $COL + 1] CONFIG.C_USE_EXTENDED_FSL_INSTR {1} CONFIG.C_D_AXI {1} CONFIG.C_USE_BARREL {1} CONFIG.C_PVR {2} CONFIG.C_PVR_USER2 {0xC0000000}  CONFIG.C_PVR_USER1 0x[format "%02x" [expr $j * $C + $i]]  CONFIG.C_USE_ICACHE {1}]  [get_bd_cells $slave/microblaze_1]
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {9} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $slave/group1_bus]
set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI [expr (($ROW + $COL) * 2) + 1] CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $slave/dma_bus]
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}]  [get_bd_cells $slave/blk_mem_gen_0]
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE}]  [get_bd_cells $slave/global_vhwti_cntrl_[expr $j * $C + $i]]
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE}]  [get_bd_cells $slave/local_vhwti_cntrl]
set_property -dict [list CONFIG.C_M_AXI_MAX_BURST_LEN {256} CONFIG.C_INCLUDE_SG {0}]  [get_bd_cells  $slave/local_dma]

#connecting internal ports
connect_bd_intf_net [get_bd_intf_pins $slave/sm_timer_64_0/sCMD] [get_bd_intf_pins $slave/microblaze_1/M[expr $ROW * $COL]_AXIS]
connect_bd_intf_net [get_bd_intf_pins $slave/sm_timer_64_0/mRet] [get_bd_intf_pins $slave/microblaze_1/S[expr $ROW * $COL]_AXIS]


connect_bd_intf_net [get_bd_intf_pins $slave/local_vhwti_cntrl/S_AXI]  -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M03_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/blk_mem_gen_0/BRAM_PORTA]  [get_bd_intf_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/BRAM_PORTA]
connect_bd_intf_net [get_bd_intf_pins $slave/blk_mem_gen_0/BRAM_PORTB]  [get_bd_intf_pins $slave/local_vhwti_cntrl/BRAM_PORTA]
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/M_AXI_DP]  -boundary_type upper [get_bd_intf_pins $slave/group1_bus/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/DLMB]  -boundary_type upper [get_bd_intf_pins $slave/microblaze_0_local_memory/DLMB]
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/ILMB]  -boundary_type upper [get_bd_intf_pins $slave/microblaze_0_local_memory/ILMB]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M01_AXI] [get_bd_intf_pins $slave/local_dma/S_AXI_LITE]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M02_AXI] [get_bd_intf_pins  $slave/dma_bus/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/local_dma/M_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/S01_AXI]
for {set jj 0} {$jj < [expr $ROW * $COL]} {incr jj} \
{
	set cmdname  [lindex $SWITCH_NAME_LIST $jj]_sCMD
	set respname [lindex $SWITCH_NAME_LIST $jj]_mRet
	connect_bd_intf_net [get_bd_intf_pins $slave/SFA_ARRAY_00/$cmdname]  [get_bd_intf_pins $slave/microblaze_1/M[expr $jj]_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $slave/SFA_ARRAY_00/$respname]  [get_bd_intf_pins $slave/microblaze_1/S[expr $jj]_AXIS]
}
for {set jj 0} {$jj < [expr ($ROW + $COL) * 2]} {incr jj} \
{
	set sAXIsname sAXIs_[lindex $BRAM_NAME_LIST $jj]
	connect_bd_intf_net [get_bd_intf_pins $slave/SFA_ARRAY_00/$sAXIsname] [get_bd_intf_pins $slave/dma_bus/M[format "%02d" [expr $jj + 1]]_AXI]
}
#clk and reset connections
connect_bd_net [get_bd_pins $slave/microblaze_1/Clk] [get_bd_pins ddr_bus/ACLK]
connect_bd_net [get_bd_pins $slave/microblaze_1/Reset] [get_bd_pins host/Reset]
connect_bd_net [get_bd_pins $slave/microblaze_0_local_memory/LMB_Rst] [get_bd_pins host_local_memory/LMB_Rst]
connect_bd_net [get_bd_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aresetn] [get_bd_pins peripherals/peripheral_aresetn]
connect_bd_net [get_bd_pins $slave/group1_bus/aresetn] [get_bd_pins peripherals/interconnect_aresetn] -boundary_type upper
connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/local_dma/s_axi_lite_aresetn]
connect_bd_net -net [get_bd_nets $slave/aresetn_1] [get_bd_pins $slave/aresetn] [get_bd_pins $slave/dma_bus/aresetn]
connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/sm_timer_64_0/ACLK]
connect_bd_net -net [get_bd_nets $slave/ARESETN_1] [get_bd_pins $slave/ARESETN] [get_bd_pins $slave/sm_timer_64_0/ARESETN]
foreach module [list SFA_ARRAY_00/s_axi_aclk microblaze_0_local_memory/LMB_Clk dma_bus/aclk local_dma/m_axi_aclk local_dma/s_axi_lite_aclk local_vhwti_cntrl/s_axi_aclk global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aclk  group1_bus/aclk]\
{
	connect_bd_net  -net [get_bd_nets $slave/Clk_1]  [get_bd_pins $slave/Clk]  [get_bd_pins $slave/$module]
}
foreach module [list local_vhwti_cntrl SFA_ARRAY_00]\
{
   connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn]  [get_bd_pins $slave/$module/s_axi_aresetn]
}

foreach module [list group1_bus  dma_bus ]\
{

 for {set k 0} {$k < 16} {incr k} \
   {
      connect_bd_net -quiet -net [get_bd_nets  $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/$module/S[format "%02d" [expr $k]]_ACLK]
      connect_bd_net  -quiet -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/$module/S[format "%02d" [expr $k]]_ARESETN]
      connect_bd_net  -quiet -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/$module/M[format "%02d" [expr $k]]_ACLK]
      connect_bd_net  -quiet -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/$module/M[format "%02d" [expr $k]]_ARESETN]
   }

}
set path [pwd]
set_property STEPS.SYNTH_DESIGN.TCL.PRE $path/loop.tcl [get_runs synth_1]
set_property STEPS.OPT_DESIGN.TCL.PRE  $path/loop.tcl [get_runs impl_1]
set_property STEPS.WRITE_BITSTREAM.TCL.PRE $path/loop.tcl [get_runs impl_1]
########################################

