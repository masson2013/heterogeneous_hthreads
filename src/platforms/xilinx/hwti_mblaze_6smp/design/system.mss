
 PARAMETER VERSION = 2.2.0


# #######################################
# HOST                 #
# #######################################
BEGIN OS
 PARAMETER OS_NAME = standalone
 PARAMETER OS_VER = 3.00.a
 PARAMETER PROC_INSTANCE = microblaze0
 PARAMETER STDIN = RS232_Uart_1
 PARAMETER STDOUT = RS232_Uart_1
END

# SLAVE PROCESSOR NUMBER 1
# #######################################
BEGIN OS
 PARAMETER OS_NAME = standalone
 PARAMETER OS_VER = 3.00.a
 PARAMETER PROC_INSTANCE = microblaze1
 PARAMETER stdin = RS232_Uart_1
 PARAMETER stdout = RS232_Uart_1
END

# SLAVE PROCESSOR NUMBER 2
# #######################################
BEGIN OS
 PARAMETER OS_NAME = standalone
 PARAMETER OS_VER = 3.00.a
 PARAMETER PROC_INSTANCE = microblaze2
 PARAMETER stdin = RS232_Uart_1
 PARAMETER stdout = RS232_Uart_1
END

# SLAVE PROCESSOR NUMBER 3
# #######################################
BEGIN OS
 PARAMETER OS_NAME = standalone
 PARAMETER OS_VER = 3.00.a
 PARAMETER PROC_INSTANCE = microblaze3
 PARAMETER stdin = RS232_Uart_1
 PARAMETER stdout = RS232_Uart_1
END

# SLAVE PROCESSOR NUMBER 4
# #######################################
BEGIN OS
 PARAMETER OS_NAME = standalone
 PARAMETER OS_VER = 3.00.a
 PARAMETER PROC_INSTANCE = microblaze4
 PARAMETER stdin = RS232_Uart_1
 PARAMETER stdout = RS232_Uart_1
END

# SLAVE PROCESSOR NUMBER 5
# #######################################
BEGIN OS
 PARAMETER OS_NAME = standalone
 PARAMETER OS_VER = 3.00.a
 PARAMETER PROC_INSTANCE = microblaze5
 PARAMETER stdin = RS232_Uart_1
 PARAMETER stdout = RS232_Uart_1
END

# SLAVE PROCESSOR NUMBER 6
# #######################################
BEGIN OS
 PARAMETER OS_NAME = standalone
 PARAMETER OS_VER = 3.00.a
 PARAMETER PROC_INSTANCE = microblaze6
 PARAMETER stdin = RS232_Uart_1
 PARAMETER stdout = RS232_Uart_1
END


BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu
 PARAMETER DRIVER_VER = 1.13.a
 PARAMETER HW_INSTANCE = microblaze0
 PARAMETER COMPILER = mb-gcc
 PARAMETER ARCHIVER = mb-ar
END

BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu
 PARAMETER DRIVER_VER = 1.13.a
 PARAMETER HW_INSTANCE = microblaze1
 PARAMETER COMPILER = mb-gcc
 PARAMETER ARCHIVER = mb-ar
END

BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu
 PARAMETER DRIVER_VER = 1.13.a
 PARAMETER HW_INSTANCE = microblaze2
 PARAMETER COMPILER = mb-gcc
 PARAMETER ARCHIVER = mb-ar
END

BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu
 PARAMETER DRIVER_VER = 1.13.a
 PARAMETER HW_INSTANCE = microblaze3
 PARAMETER COMPILER = mb-gcc
 PARAMETER ARCHIVER = mb-ar
END

BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu
 PARAMETER DRIVER_VER = 1.13.a
 PARAMETER HW_INSTANCE = microblaze4
 PARAMETER COMPILER = mb-gcc
 PARAMETER ARCHIVER = mb-ar
END

BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu
 PARAMETER DRIVER_VER = 1.13.a
 PARAMETER HW_INSTANCE = microblaze5
 PARAMETER COMPILER = mb-gcc
 PARAMETER ARCHIVER = mb-ar
END

BEGIN PROCESSOR
 PARAMETER DRIVER_NAME = cpu
 PARAMETER DRIVER_VER = 1.13.a
 PARAMETER HW_INSTANCE = microblaze6
 PARAMETER COMPILER = mb-gcc
 PARAMETER ARCHIVER = mb-ar
END


BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = main_bus
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = ilmb_cntlr0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = dlmb_cntlr0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = host_bram0
END

# #######################################
# SLAVES                #
# #######################################
# GROUP 1
# #######################################
BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group1_bus
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group1_main_bridge
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = ilmb_cntlr1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = dlmb_cntlr1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = lmb_bram1
END

# GROUP 2
# #######################################
BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group2_bus
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group2_main_bridge
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = ilmb_cntlr2
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = dlmb_cntlr2
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = lmb_bram2
END

# GROUP 3
# #######################################
BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group3_bus
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group3_main_bridge
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = ilmb_cntlr3
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = dlmb_cntlr3
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = lmb_bram3
END

# GROUP 4
# #######################################
BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group4_bus
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group4_main_bridge
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = ilmb_cntlr4
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = dlmb_cntlr4
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = lmb_bram4
END

# GROUP 5
# #######################################
BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group5_bus
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group5_main_bridge
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = ilmb_cntlr5
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = dlmb_cntlr5
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = lmb_bram5
END

# GROUP 6
# #######################################
BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group6_bus
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = group6_main_bridge
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = ilmb_cntlr6
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = dlmb_cntlr6
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = lmb_bram6
END

# #######################################
# VHWTI                #
# #######################################
BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = vhwti_bus1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = main_vhwti_bridge1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_local_cntlr1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_global_cntlr1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = vhwti_bram1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_local_cntlr2
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_global_cntlr2
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = vhwti_bram2
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_local_cntlr3
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_global_cntlr3
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = vhwti_bram3
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_local_cntlr4
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_global_cntlr4
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = vhwti_bram4
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_local_cntlr5
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_global_cntlr5
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = vhwti_bram5
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_local_cntlr6
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = bram
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = vhwti_global_cntlr6
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = vhwti_bram6
END

# #######################################
# HTHREADS CORES            #
# #######################################
BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = core_main_bridge
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = main_core_bridge
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = core_bus
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = cond_vars
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = scheduler
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = thread_manager
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = sync_manager
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = intc
 PARAMETER DRIVER_VER = 2.01.a
 PARAMETER HW_INSTANCE = xps_intc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = plb_hthread_reset_core_0
END

# #######################################
# PERIPHERALS              #
# #######################################
BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = plb_hthreads_timer_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = tmrctr
 PARAMETER DRIVER_VER = 2.01.a
 PARAMETER HW_INSTANCE = xps_timer_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartlite
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = mdm_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = mpmc
 PARAMETER DRIVER_VER = 4.01.a
 PARAMETER HW_INSTANCE = mpmc_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = uartlite
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = RS232_Uart_1
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = clock_generator0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = generic
 PARAMETER DRIVER_VER = 1.00.a
 PARAMETER HW_INSTANCE = proc_sys_reset_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = dmacentral
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = xps_central_dma_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = hwicap
 PARAMETER DRIVER_VER = 5.01.a
 PARAMETER HW_INSTANCE = xps_hwicap_0
END

BEGIN DRIVER
 PARAMETER DRIVER_NAME = sysace
 PARAMETER DRIVER_VER = 2.00.a
 PARAMETER HW_INSTANCE = SysACE_CompactFlash
END


BEGIN LIBRARY
 PARAMETER LIBRARY_NAME = xilfatfs
 PARAMETER LIBRARY_VER = 1.00.a
 PARAMETER PROC_INSTANCE = microblaze0
END

