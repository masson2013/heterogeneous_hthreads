############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 2014 Xilinx Inc. All rights reserved.
############################################################
open_project acc_vadd
set_top acc_vadd
add_files acc_vadd/acc_vadd.c
open_solution "solution1"
set_part {xc7k325tffg900-2}
create_clock -period 10 -name default
source "./acc_vadd/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -format ip_catalog
