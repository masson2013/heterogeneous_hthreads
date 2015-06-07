#################################################################
# Makefile generated by Xilinx Platform Studio 
# Project:/home/abazar63/hthread/src/platforms/xilinx/smp3_opbhwti/design/system.xmp
#
# WARNING : This file will be re-generated every time a command
# to run a make target is invoked. So, any changes made to this  
# file manually, will be lost when make is invoked next. 
#################################################################

XILINX_EDK_DIR = /opt/Xilinx/12.3/ISE_DS/EDK
NON_CYG_XILINX_EDK_DIR = /opt/Xilinx/12.3/ISE_DS/EDK

SYSTEM = system

MHSFILE = system.mhs

MSSFILE = system.mss

FPGA_ARCH = virtex6

DEVICE = xc6vlx240tff1156-1

LANGUAGE = vhdl
GLOBAL_SEARCHPATHOPT = 
PROJECT_SEARCHPATHOPT =  -lp /home/abazar63/hthread/src/hardware/

SEARCHPATHOPT = $(PROJECT_SEARCHPATHOPT) $(GLOBAL_SEARCHPATHOPT)

SUBMODULE_OPT = 

PLATGEN_OPTIONS = -p $(DEVICE) -lang $(LANGUAGE) $(SEARCHPATHOPT) $(SUBMODULE_OPT) -msg __xps/ise/xmsgprops.lst

LIBGEN_OPTIONS = -mhs $(MHSFILE) -p $(DEVICE) $(SEARCHPATHOPT) -msg __xps/ise/xmsgprops.lst \
                   $(MICROBLAZE0_LIBG_OPT) \
                   $(MICROBLAZE1_LIBG_OPT) \
                   $(MICROBLAZE2_LIBG_OPT) \
                   $(MICROBLAZE3_LIBG_OPT)

OBSERVE_PAR_OPTIONS = -error no

CORE_TEST_OUTPUT_DIR = CoreTest
CORE_TEST_OUTPUT = $(CORE_TEST_OUTPUT_DIR)/executable.elf
CYG_CORE_TEST_OUTPUT_DIR = CoreTest
CYG_CORE_TEST_OUTPUT = $(CYG_CORE_TEST_OUTPUT_DIR)/executable.elf

MB_HWT0_OUTPUT_DIR = MB_HWT0
MB_HWT0_OUTPUT = $(MB_HWT0_OUTPUT_DIR)/executable.elf
CYG_MB_HWT0_OUTPUT_DIR = MB_HWT0
CYG_MB_HWT0_OUTPUT = $(CYG_MB_HWT0_OUTPUT_DIR)/executable.elf

MB_HWT1_OUTPUT_DIR = MB_HWT1
MB_HWT1_OUTPUT = $(MB_HWT1_OUTPUT_DIR)/executable.elf
CYG_MB_HWT1_OUTPUT_DIR = MB_HWT1
CYG_MB_HWT1_OUTPUT = $(CYG_MB_HWT1_OUTPUT_DIR)/executable.elf

MB_HWT2_OUTPUT_DIR = MB_HWT2
MB_HWT2_OUTPUT = $(MB_HWT2_OUTPUT_DIR)/executable.elf
CYG_MB_HWT2_OUTPUT_DIR = MB_HWT2
CYG_MB_HWT2_OUTPUT = $(CYG_MB_HWT2_OUTPUT_DIR)/executable.elf

MICROBLAZE_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/microblaze/mb_bootloop.elf
MICROBLAZE_BOOTLOOP_LE = $(XILINX_EDK_DIR)/sw/lib/microblaze/mb_bootloop_le.elf
PPC405_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/ppc405/ppc_bootloop.elf
PPC440_BOOTLOOP = $(XILINX_EDK_DIR)/sw/lib/ppc440/ppc440_bootloop.elf
BOOTLOOP_DIR = bootloops

MICROBLAZE0_BOOTLOOP = $(BOOTLOOP_DIR)/microblaze0.elf
MICROBLAZE0_XMDSTUB = microblaze0/code/xmdstub.elf

MICROBLAZE1_BOOTLOOP = $(BOOTLOOP_DIR)/microblaze1.elf
MICROBLAZE1_XMDSTUB = microblaze1/code/xmdstub.elf

MICROBLAZE2_BOOTLOOP = $(BOOTLOOP_DIR)/microblaze2.elf
MICROBLAZE2_XMDSTUB = microblaze2/code/xmdstub.elf

MICROBLAZE3_BOOTLOOP = $(BOOTLOOP_DIR)/microblaze3.elf
MICROBLAZE3_XMDSTUB = microblaze3/code/xmdstub.elf

BRAMINIT_ELF_FILES =  $(CORE_TEST_OUTPUT) $(MB_HWT0_OUTPUT) $(MB_HWT1_OUTPUT) $(MB_HWT2_OUTPUT) 
BRAMINIT_ELF_FILE_ARGS =   -pe microblaze0 $(CORE_TEST_OUTPUT)  -pe microblaze1 $(MB_HWT0_OUTPUT)  -pe microblaze2 $(MB_HWT1_OUTPUT)  -pe microblaze3 $(MB_HWT2_OUTPUT) 

ALL_USER_ELF_FILES = $(CORE_TEST_OUTPUT) $(MB_HWT0_OUTPUT) $(MB_HWT1_OUTPUT) $(MB_HWT2_OUTPUT) 

SIM_CMD = vsim

BEHAVIORAL_SIM_SCRIPT = simulation/behavioral/$(SYSTEM)_setup.do

STRUCTURAL_SIM_SCRIPT = simulation/structural/$(SYSTEM)_setup.do

TIMING_SIM_SCRIPT = simulation/timing/$(SYSTEM)_setup.do

DEFAULT_SIM_SCRIPT = $(BEHAVIORAL_SIM_SCRIPT)

MIX_LANG_SIM_OPT = -mixed no

SIMGEN_OPTIONS = -p $(DEVICE) -lang $(LANGUAGE) $(SEARCHPATHOPT) $(BRAMINIT_ELF_FILE_ARGS) $(MIX_LANG_SIM_OPT) -msg __xps/ise/xmsgprops.lst -sd implementation/ -s mti


LIBRARIES =  \
       microblaze0/lib/libxil.a  \
       microblaze1/lib/libxil.a  \
       microblaze2/lib/libxil.a  \
       microblaze3/lib/libxil.a 

LIBSCLEAN_TARGETS = microblaze0_libsclean microblaze1_libsclean microblaze2_libsclean microblaze3_libsclean 

PROGRAMCLEAN_TARGETS = Core_Test_programclean MB_HWT0_programclean MB_HWT1_programclean MB_HWT2_programclean 

CORE_STATE_DEVELOPMENT_FILES = /opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/proc_common_pkg.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/ipif_pkg.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/or_muxcy.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/or_gate128.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/family_support.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/pselect_f.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/counter_f.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/cntr_incr_decr_addn_f.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/muxf_struct_f.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/dynshreg_f.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/srl_fifo_rbu_f.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/srl_fifo_f.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/proc_common_v3_00_a/hdl/vhdl/soft_reset.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/plbv46_slave_single_v1_01_a/hdl/vhdl/plb_address_decoder.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/plbv46_slave_single_v1_01_a/hdl/vhdl/plb_slave_attachment.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/plbv46_slave_single_v1_01_a/hdl/vhdl/plbv46_slave_single.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/plbv46_master_single_v1_01_a/hdl/vhdl/data_width_adapter.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/plbv46_master_single_v1_01_a/hdl/vhdl/data_mirror_128.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/plbv46_master_single_v1_01_a/hdl/vhdl/plbv46_master_single.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/fsl_v20_v2_11_c/hdl/vhdl/async_fifo_bram.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/fsl_v20_v2_11_c/hdl/vhdl/async_fifo.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/fsl_v20_v2_11_c/hdl/vhdl/gen_srlfifo.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/fsl_v20_v2_11_c/hdl/vhdl/gen_sync_bram.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/fsl_v20_v2_11_c/hdl/vhdl/gen_sync_dpram.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/fsl_v20_v2_11_c/hdl/vhdl/sync_fifo.vhd \
/opt/Xilinx/12.3/ISE_DS/EDK/hw/XilinxProcessorIPLib/pcores/fsl_v20_v2_11_c/hdl/vhdl/fsl_v20.vhd \
pcores/plb_cond_vars_v1_00_a/hdl/vhdl/condvar.vhd \
pcores/plb_cond_vars_v1_00_a/hdl/vhdl/user_logic.vhd \
pcores/plb_cond_vars_v1_00_a/hdl/vhdl/plb_cond_vars.vhd \
pcores/plb_scheduler_v1_00_a/hdl/vhdl/infer_bram.vhd \
pcores/plb_scheduler_v1_00_a/hdl/vhdl/parallel.vhd \
pcores/plb_scheduler_v1_00_a/hdl/vhdl/user_logic.vhd \
pcores/plb_scheduler_v1_00_a/hdl/vhdl/plb_scheduler.vhd \
pcores/plb_thread_manager_v1_00_a/hdl/vhdl/infer_bram_dual_port.vhd \
pcores/plb_thread_manager_v1_00_a/hdl/vhdl/user_logic.vhd \
pcores/plb_thread_manager_v1_00_a/hdl/vhdl/plb_thread_manager.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/common.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/lock_fsm.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/unlock_fsm.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/trylock_fsm.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/owner_fsm.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/kind_fsm.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/count_fsm.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/result_fsm.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/mutex_store.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/thread_store.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/send_store.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/slave.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/master.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/user_logic.vhd \
pcores/plb_sync_manager_v1_00_a/hdl/vhdl/plb_sync_manager.vhd \
pcores/plb_hthread_reset_core_v1_00_a/hdl/vhdl/user_logic.vhd \
pcores/plb_hthread_reset_core_v1_00_a/hdl/vhdl/plb_hthread_reset_core.vhd \
pcores/plb_hthreads_timer_v1_00_a/hdl/vhdl/user_logic.vhd \
pcores/plb_hthreads_timer_v1_00_a/hdl/vhdl/plb_hthreads_timer.vhd

WRAPPER_NGC_FILES = implementation/main_bus_wrapper.ngc \
implementation/microblaze0_wrapper.ngc \
implementation/ilmb0_wrapper.ngc \
implementation/dlmb0_wrapper.ngc \
implementation/ilmb_cntlr0_wrapper.ngc \
implementation/dlmb_cntlr0_wrapper.ngc \
implementation/host_bram0_wrapper.ngc \
implementation/group1_bus_wrapper.ngc \
implementation/group1_main_bridge_wrapper.ngc \
implementation/microblaze1_wrapper.ngc \
implementation/hw_acc_1_wrapper.ngc \
implementation/mb2thrd1_0_wrapper.ngc \
implementation/mb2thrd1_1_wrapper.ngc \
implementation/thrd2mb1_0_wrapper.ngc \
implementation/thrd2mb1_1_wrapper.ngc \
implementation/thrd2mb1_2_wrapper.ngc \
implementation/ilmb1_wrapper.ngc \
implementation/dlmb1_wrapper.ngc \
implementation/ilmb_cntlr1_wrapper.ngc \
implementation/dlmb_cntlr1_wrapper.ngc \
implementation/lmb_bram1_wrapper.ngc \
implementation/group2_bus_wrapper.ngc \
implementation/group2_main_bridge_wrapper.ngc \
implementation/microblaze2_wrapper.ngc \
implementation/hw_acc_two_1_wrapper.ngc \
implementation/mb2thrd2_0_wrapper.ngc \
implementation/mb2thrd2_1_wrapper.ngc \
implementation/thrd2mb2_0_wrapper.ngc \
implementation/thrd2mb2_1_wrapper.ngc \
implementation/thrd2mb2_2_wrapper.ngc \
implementation/ilmb2_wrapper.ngc \
implementation/dlmb2_wrapper.ngc \
implementation/ilmb_cntlr2_wrapper.ngc \
implementation/dlmb_cntlr2_wrapper.ngc \
implementation/lmb_bram2_wrapper.ngc \
implementation/group3_bus_wrapper.ngc \
implementation/group3_main_bridge_wrapper.ngc \
implementation/microblaze3_wrapper.ngc \
implementation/hw_acc_three_1_wrapper.ngc \
implementation/mb2thrd3_0_wrapper.ngc \
implementation/mb2thrd3_1_wrapper.ngc \
implementation/thrd2mb3_0_wrapper.ngc \
implementation/thrd2mb3_1_wrapper.ngc \
implementation/thrd2mb3_2_wrapper.ngc \
implementation/ilmb3_wrapper.ngc \
implementation/dlmb3_wrapper.ngc \
implementation/ilmb_cntlr3_wrapper.ngc \
implementation/dlmb_cntlr3_wrapper.ngc \
implementation/lmb_bram3_wrapper.ngc \
implementation/vhwti_bus1_wrapper.ngc \
implementation/main_vhwti_bridge1_wrapper.ngc \
implementation/vhwti_local_cntlr1_wrapper.ngc \
implementation/vhwti_global_cntlr1_wrapper.ngc \
implementation/vhwti_bram1_wrapper.ngc \
implementation/vhwti_local_cntlr2_wrapper.ngc \
implementation/vhwti_global_cntlr2_wrapper.ngc \
implementation/vhwti_bram2_wrapper.ngc \
implementation/vhwti_local_cntlr3_wrapper.ngc \
implementation/vhwti_global_cntlr3_wrapper.ngc \
implementation/vhwti_bram3_wrapper.ngc \
implementation/core_main_bridge_wrapper.ngc \
implementation/main_core_bridge_wrapper.ngc \
implementation/core_bus_wrapper.ngc \
implementation/cond_vars_wrapper.ngc \
implementation/scheduler_wrapper.ngc \
implementation/thread_manager_wrapper.ngc \
implementation/sync_manager_wrapper.ngc \
implementation/xps_intc_0_wrapper.ngc \
implementation/plb_hthread_reset_core_0_wrapper.ngc \
implementation/plb_hthreads_timer_0_wrapper.ngc \
implementation/xps_timer_0_wrapper.ngc \
implementation/mdm_0_wrapper.ngc \
implementation/mpmc_0_wrapper.ngc \
implementation/rs232_uart_1_wrapper.ngc \
implementation/clock_generator0_wrapper.ngc \
implementation/proc_sys_reset_0_wrapper.ngc \
implementation/xps_central_dma_0_wrapper.ngc \
implementation/hwti_bus_wrapper.ngc \
implementation/main_hwti_bridge_0_wrapper.ngc \
implementation/hwti_main_bridge_0_wrapper.ngc \
implementation/opb_hwti_0_wrapper.ngc \
implementation/hw_acc_0_wrapper.ngc \
implementation/intrfc2thrd0_0_wrapper.ngc \
implementation/intrfc2thrd0_1_wrapper.ngc \
implementation/thrd2intrfc0_0_wrapper.ngc \
implementation/thrd2intrfc0_1_wrapper.ngc \
implementation/thrd2intrfc0_2_wrapper.ngc \
implementation/opb_hwti_1_wrapper.ngc \
implementation/hw_acc_two_0_wrapper.ngc \
implementation/intrfc2thrd1_0_wrapper.ngc \
implementation/intrfc2thrd1_1_wrapper.ngc \
implementation/thrd2intrfc1_0_wrapper.ngc \
implementation/thrd2intrfc1_1_wrapper.ngc \
implementation/thrd2intrfc1_2_wrapper.ngc \
implementation/opb_hwti_2_wrapper.ngc \
implementation/hw_acc_three_0_wrapper.ngc \
implementation/intrfc2thrd2_0_wrapper.ngc \
implementation/intrfc2thrd2_1_wrapper.ngc \
implementation/thrd2intrfc2_0_wrapper.ngc \
implementation/thrd2intrfc2_1_wrapper.ngc \
implementation/thrd2intrfc2_2_wrapper.ngc

POSTSYN_NETLIST = implementation/$(SYSTEM).ngc

SYSTEM_BIT = implementation/$(SYSTEM).bit

DOWNLOAD_BIT = implementation/download.bit

SYSTEM_ACE = implementation/$(SYSTEM).ace

UCF_FILE = data/system.ucf

BMM_FILE = implementation/$(SYSTEM).bmm

BITGEN_UT_FILE = etc/bitgen.ut

XFLOW_OPT_FILE = etc/fast_runtime.opt
XFLOW_DEPENDENCY = __xps/xpsxflow.opt $(XFLOW_OPT_FILE)

XPLORER_DEPENDENCY = __xps/xplorer.opt
XPLORER_OPTIONS = -p $(DEVICE) -uc $(SYSTEM).ucf -bm $(SYSTEM).bmm -max_runs 7

FPGA_IMP_DEPENDENCY = $(BMM_FILE) $(POSTSYN_NETLIST) $(UCF_FILE) $(XFLOW_DEPENDENCY)

# cygwin path for windows
SDK_EXPORT_DIR = SDK/SDK_Export/hw
CYG_SDK_EXPORT_DIR = SDK/SDK_Export/hw
SYSTEM_HW_HANDOFF = $(SDK_EXPORT_DIR)/$(SYSTEM).xml
CYG_SYSTEM_HW_HANDOFF = $(CYG_SDK_EXPORT_DIR)/$(SYSTEM).xml
SYSTEM_HW_HANDOFF_BIT = $(SDK_EXPORT_DIR)/$(SYSTEM).bit
CYG_SYSTEM_HW_HANDOFF_BIT = $(CYG_SDK_EXPORT_DIR)/$(SYSTEM).bit
SYSTEM_HW_HANDOFF_BMM = $(SDK_EXPORT_DIR)/$(SYSTEM)_bd.bmm
CYG_SYSTEM_HW_HANDOFF_BMM = $(CYG_SDK_EXPORT_DIR)/$(SYSTEM)_bd.bmm
SYSTEM_HW_HANDOFF_DEP = $(CYG_SYSTEM_HW_HANDOFF) $(CYG_SYSTEM_HW_HANDOFF_BIT) $(CYG_SYSTEM_HW_HANDOFF_BMM)

#################################################################
# SOFTWARE APPLICATION CORE_TEST
#################################################################

CORE_TEST_SOURCES = CoreTest.c 

CORE_TEST_HEADERS = 

CORE_TEST_CC = mb-gcc
CORE_TEST_CC_SIZE = mb-size
CORE_TEST_CC_OPT = -O2
CORE_TEST_CFLAGS = 
CORE_TEST_CC_SEARCH = # -B
CORE_TEST_LIBPATH = -L./microblaze0/lib/ # -L
CORE_TEST_INCLUDES = -I./microblaze0/include/ # -I
CORE_TEST_LFLAGS = # -l
CORE_TEST_LINKER_SCRIPT = 
CORE_TEST_LINKER_SCRIPT_FLAG = #-T $(CORE_TEST_LINKER_SCRIPT) 
CORE_TEST_CC_DEBUG_FLAG =  -g 
CORE_TEST_CC_PROFILE_FLAG = # -pg
CORE_TEST_CC_GLOBPTR_FLAG= # -mxl-gp-opt
CORE_TEST_MODE = executable
CORE_TEST_LIBG_OPT = -$(CORE_TEST_MODE) microblaze0
CORE_TEST_CC_INFERRED_FLAGS= -mxl-soft-mul -mxl-barrel-shift -mcpu=v8.00.a 
CORE_TEST_CC_START_ADDR_FLAG=  # -Wl,-defsym -Wl,_TEXT_START_ADDR=
CORE_TEST_CC_STACK_SIZE_FLAG=  # -Wl,-defsym -Wl,_STACK_SIZE=
CORE_TEST_CC_HEAP_SIZE_FLAG=  # -Wl,-defsym -Wl,_HEAP_SIZE=
CORE_TEST_OTHER_CC_FLAGS= $(CORE_TEST_CC_GLOBPTR_FLAG)  \
                  $(CORE_TEST_CC_START_ADDR_FLAG) $(CORE_TEST_CC_STACK_SIZE_FLAG) $(CORE_TEST_CC_HEAP_SIZE_FLAG)  \
                  $(CORE_TEST_CC_INFERRED_FLAGS)  \
                  $(CORE_TEST_LINKER_SCRIPT_FLAG) $(CORE_TEST_CC_DEBUG_FLAG) $(CORE_TEST_CC_PROFILE_FLAG) 

#################################################################
# SOFTWARE APPLICATION MB_HWT0
#################################################################

MB_HWT0_SOURCES = my_sw/hw_thread.c my_sw/proc_hw_thread.c 

MB_HWT0_HEADERS = my_sw/proc_hw_thread.h 

MB_HWT0_CC = mb-gcc
MB_HWT0_CC_SIZE = mb-size
MB_HWT0_CC_OPT = -O2
MB_HWT0_CFLAGS = 
MB_HWT0_CC_SEARCH = # -B
MB_HWT0_LIBPATH = -L./microblaze1/lib/ # -L
MB_HWT0_INCLUDES = -I./microblaze1/include/  -Imy_sw/ # -I
MB_HWT0_LFLAGS = # -l
MB_HWT0_LINKER_SCRIPT = 
MB_HWT0_LINKER_SCRIPT_FLAG = #-T $(MB_HWT0_LINKER_SCRIPT) 
MB_HWT0_CC_DEBUG_FLAG =  -g 
MB_HWT0_CC_PROFILE_FLAG = # -pg
MB_HWT0_CC_GLOBPTR_FLAG= # -mxl-gp-opt
MB_HWT0_MODE = executable
MB_HWT0_LIBG_OPT = -$(MB_HWT0_MODE) microblaze1
MB_HWT0_CC_INFERRED_FLAGS= -mxl-soft-mul -mxl-barrel-shift -mcpu=v8.00.a 
MB_HWT0_CC_START_ADDR_FLAG=  # -Wl,-defsym -Wl,_TEXT_START_ADDR=
MB_HWT0_CC_STACK_SIZE_FLAG=  # -Wl,-defsym -Wl,_STACK_SIZE=
MB_HWT0_CC_HEAP_SIZE_FLAG=  # -Wl,-defsym -Wl,_HEAP_SIZE=
MB_HWT0_OTHER_CC_FLAGS= $(MB_HWT0_CC_GLOBPTR_FLAG)  \
                  $(MB_HWT0_CC_START_ADDR_FLAG) $(MB_HWT0_CC_STACK_SIZE_FLAG) $(MB_HWT0_CC_HEAP_SIZE_FLAG)  \
                  $(MB_HWT0_CC_INFERRED_FLAGS)  \
                  $(MB_HWT0_LINKER_SCRIPT_FLAG) $(MB_HWT0_CC_DEBUG_FLAG) $(MB_HWT0_CC_PROFILE_FLAG) 

#################################################################
# SOFTWARE APPLICATION MB_HWT1
#################################################################

MB_HWT1_SOURCES = my_sw/hw_thread.c my_sw/proc_hw_thread.c 

MB_HWT1_HEADERS = my_sw/proc_hw_thread.h 

MB_HWT1_CC = mb-gcc
MB_HWT1_CC_SIZE = mb-size
MB_HWT1_CC_OPT = -O2
MB_HWT1_CFLAGS = 
MB_HWT1_CC_SEARCH = # -B
MB_HWT1_LIBPATH = -L./microblaze2/lib/ # -L
MB_HWT1_INCLUDES = -I./microblaze2/include/  -Imy_sw/ # -I
MB_HWT1_LFLAGS = # -l
MB_HWT1_LINKER_SCRIPT = 
MB_HWT1_LINKER_SCRIPT_FLAG = #-T $(MB_HWT1_LINKER_SCRIPT) 
MB_HWT1_CC_DEBUG_FLAG =  -g 
MB_HWT1_CC_PROFILE_FLAG = # -pg
MB_HWT1_CC_GLOBPTR_FLAG= # -mxl-gp-opt
MB_HWT1_MODE = executable
MB_HWT1_LIBG_OPT = -$(MB_HWT1_MODE) microblaze2
MB_HWT1_CC_INFERRED_FLAGS= -mxl-soft-mul -mxl-barrel-shift -mcpu=v8.00.a 
MB_HWT1_CC_START_ADDR_FLAG=  # -Wl,-defsym -Wl,_TEXT_START_ADDR=
MB_HWT1_CC_STACK_SIZE_FLAG=  # -Wl,-defsym -Wl,_STACK_SIZE=
MB_HWT1_CC_HEAP_SIZE_FLAG=  # -Wl,-defsym -Wl,_HEAP_SIZE=
MB_HWT1_OTHER_CC_FLAGS= $(MB_HWT1_CC_GLOBPTR_FLAG)  \
                  $(MB_HWT1_CC_START_ADDR_FLAG) $(MB_HWT1_CC_STACK_SIZE_FLAG) $(MB_HWT1_CC_HEAP_SIZE_FLAG)  \
                  $(MB_HWT1_CC_INFERRED_FLAGS)  \
                  $(MB_HWT1_LINKER_SCRIPT_FLAG) $(MB_HWT1_CC_DEBUG_FLAG) $(MB_HWT1_CC_PROFILE_FLAG) 

#################################################################
# SOFTWARE APPLICATION MB_HWT2
#################################################################

MB_HWT2_SOURCES = my_sw/hw_thread.c my_sw/proc_hw_thread.c 

MB_HWT2_HEADERS = my_sw/proc_hw_thread.h 

MB_HWT2_CC = mb-gcc
MB_HWT2_CC_SIZE = mb-size
MB_HWT2_CC_OPT = -O2
MB_HWT2_CFLAGS = 
MB_HWT2_CC_SEARCH = # -B
MB_HWT2_LIBPATH = -L./microblaze3/lib/ # -L
MB_HWT2_INCLUDES = -I./microblaze3/include/  -Imy_sw/ # -I
MB_HWT2_LFLAGS = # -l
MB_HWT2_LINKER_SCRIPT = 
MB_HWT2_LINKER_SCRIPT_FLAG = #-T $(MB_HWT2_LINKER_SCRIPT) 
MB_HWT2_CC_DEBUG_FLAG =  -g 
MB_HWT2_CC_PROFILE_FLAG = # -pg
MB_HWT2_CC_GLOBPTR_FLAG= # -mxl-gp-opt
MB_HWT2_MODE = executable
MB_HWT2_LIBG_OPT = -$(MB_HWT2_MODE) microblaze3
MB_HWT2_CC_INFERRED_FLAGS= -mxl-soft-mul -mxl-barrel-shift -mcpu=v8.00.a 
MB_HWT2_CC_START_ADDR_FLAG=  # -Wl,-defsym -Wl,_TEXT_START_ADDR=
MB_HWT2_CC_STACK_SIZE_FLAG=  # -Wl,-defsym -Wl,_STACK_SIZE=
MB_HWT2_CC_HEAP_SIZE_FLAG=  # -Wl,-defsym -Wl,_HEAP_SIZE=
MB_HWT2_OTHER_CC_FLAGS= $(MB_HWT2_CC_GLOBPTR_FLAG)  \
                  $(MB_HWT2_CC_START_ADDR_FLAG) $(MB_HWT2_CC_STACK_SIZE_FLAG) $(MB_HWT2_CC_HEAP_SIZE_FLAG)  \
                  $(MB_HWT2_CC_INFERRED_FLAGS)  \
                  $(MB_HWT2_LINKER_SCRIPT_FLAG) $(MB_HWT2_CC_DEBUG_FLAG) $(MB_HWT2_CC_PROFILE_FLAG) 
