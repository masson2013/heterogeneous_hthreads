# 1 "acc_vadd/acc_vadd.c"
# 1 "acc_vadd/acc_vadd.c" 1
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 149 "<built-in>" 3
# 1 "<command line>" 1






# 1 "/opt/Xilinx/Vivado_HLS/2014.2/common/technology/autopilot/etc/autopilot_ssdm_op.h" 1
/* autopilot_ssdm_op.h*/
/*
#-  (c) Copyright 2011-2014 Xilinx, Inc. All rights reserved.
#-
#-  This file contains confidential and proprietary information
#-  of Xilinx, Inc. and is protected under U.S. and
#-  international copyright and other intellectual property
#-  laws.
#-
#-  DISCLAIMER
#-  This disclaimer is not a license and does not grant any
#-  rights to the materials distributed herewith. Except as
#-  otherwise provided in a valid license issued to you by
#-  Xilinx, and to the maximum extent permitted by applicable
#-  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
#-  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
#-  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
#-  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
#-  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
#-  (2) Xilinx shall not be liable (whether in contract or tort,
#-  including negligence, or under any other theory of
#-  liability) for any loss or damage of any kind or nature
#-  related to, arising under or in connection with these
#-  materials, including for any direct, or any indirect,
#-  special, incidental, or consequential loss or damage
#-  (including loss of data, profits, goodwill, or any type of
#-  loss or damage suffered as a result of any action brought
#-  by a third party) even if such damage or loss was
#-  reasonably foreseeable or Xilinx had been advised of the
#-  possibility of the same.
#-
#-  CRITICAL APPLICATIONS
#-  Xilinx products are not designed or intended to be fail-
#-  safe, or for use in any application requiring fail-safe
#-  performance, such as life-support or safety devices or
#-  systems, Class III medical devices, nuclear facilities,
#-  applications related to the deployment of airbags, or any
#-  other applications that could lead to death, personal
#-  injury, or severe property or environmental damage
#-  (individually and collectively, "Critical
#-  Applications"). Customer assumes the sole risk and
#-  liability of any use of Xilinx products in Critical
#-  Applications, subject only to applicable laws and
#-  regulations governing limitations on product liability.
#-
#-  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
#-  PART OF THIS FILE AT ALL TIMES. 
#- ************************************************************************

 *
 * $Id$
 */
# 278 "/opt/Xilinx/Vivado_HLS/2014.2/common/technology/autopilot/etc/autopilot_ssdm_op.h"
/*#define AP_SPEC_ATTR __attribute__ ((pure))*/



    /****** SSDM Intrinsics: OPERATIONS ***/
    // Interface operations
    //typedef unsigned int __attribute__ ((bitwidth(1))) _uint1_;
    void _ssdm_op_IfRead() __attribute__ ((nothrow));
    void _ssdm_op_IfWrite() __attribute__ ((nothrow));
    //_uint1_ _ssdm_op_IfNbRead() SSDM_OP_ATTR;
    //_uint1_ _ssdm_op_IfNbWrite() SSDM_OP_ATTR;
    //_uint1_ _ssdm_op_IfCanRead() SSDM_OP_ATTR;
    //_uint1_ _ssdm_op_IfCanWrite() SSDM_OP_ATTR;

    // Stream Intrinsics
    void _ssdm_StreamRead() __attribute__ ((nothrow));
    void _ssdm_StreamWrite() __attribute__ ((nothrow));
    //_uint1_  _ssdm_StreamNbRead() SSDM_OP_ATTR;
    //_uint1_  _ssdm_StreamNbWrite() SSDM_OP_ATTR;
    //_uint1_  _ssdm_StreamCanRead() SSDM_OP_ATTR;
    //_uint1_  _ssdm_StreamCanWrite() SSDM_OP_ATTR;

    // Misc
    void _ssdm_op_MemShiftRead() __attribute__ ((nothrow));

    void _ssdm_op_Wait() __attribute__ ((nothrow));
    void _ssdm_op_Poll() __attribute__ ((nothrow));

    void _ssdm_op_Return() __attribute__ ((nothrow));

    /* SSDM Intrinsics: SPECIFICATIONS */
    void _ssdm_op_SpecSynModule() __attribute__ ((nothrow));
    void _ssdm_op_SpecTopModule() __attribute__ ((nothrow));
    void _ssdm_op_SpecProcessDecl() __attribute__ ((nothrow));
    void _ssdm_op_SpecProcessDef() __attribute__ ((nothrow));
    void _ssdm_op_SpecPort() __attribute__ ((nothrow));
    void _ssdm_op_SpecConnection() __attribute__ ((nothrow));
    void _ssdm_op_SpecChannel() __attribute__ ((nothrow));
    void _ssdm_op_SpecSensitive() __attribute__ ((nothrow));
    void _ssdm_op_SpecModuleInst() __attribute__ ((nothrow));
    void _ssdm_op_SpecPortMap() __attribute__ ((nothrow));

    void _ssdm_op_SpecReset() __attribute__ ((nothrow));

    void _ssdm_op_SpecPlatform() __attribute__ ((nothrow));
    void _ssdm_op_SpecClockDomain() __attribute__ ((nothrow));
    void _ssdm_op_SpecPowerDomain() __attribute__ ((nothrow));

    int _ssdm_op_SpecRegionBegin() __attribute__ ((nothrow));
    int _ssdm_op_SpecRegionEnd() __attribute__ ((nothrow));

    void _ssdm_op_SpecLoopName() __attribute__ ((nothrow));

    void _ssdm_op_SpecLoopTripCount() __attribute__ ((nothrow));

    int _ssdm_op_SpecStateBegin() __attribute__ ((nothrow));
    int _ssdm_op_SpecStateEnd() __attribute__ ((nothrow));

    void _ssdm_op_SpecInterface() __attribute__ ((nothrow));

    void _ssdm_op_SpecPipeline() __attribute__ ((nothrow));
    void _ssdm_op_SpecDataflowPipeline() __attribute__ ((nothrow));


    void _ssdm_op_SpecLatency() __attribute__ ((nothrow));
    void _ssdm_op_SpecParallel() __attribute__ ((nothrow));
    void _ssdm_op_SpecProtocol() __attribute__ ((nothrow));
    void _ssdm_op_SpecOccurrence() __attribute__ ((nothrow));

    void _ssdm_op_SpecResource() __attribute__ ((nothrow));
    void _ssdm_op_SpecResourceLimit() __attribute__ ((nothrow));
    void _ssdm_op_SpecCHCore() __attribute__ ((nothrow));
    void _ssdm_op_SpecFUCore() __attribute__ ((nothrow));
    void _ssdm_op_SpecIFCore() __attribute__ ((nothrow));
    void _ssdm_op_SpecIPCore() __attribute__ ((nothrow));
    void _ssdm_op_SpecKeepValue() __attribute__ ((nothrow));
    void _ssdm_op_SpecMemCore() __attribute__ ((nothrow));

    void _ssdm_op_SpecExt() __attribute__ ((nothrow));
    /*void* _ssdm_op_SpecProcess() SSDM_SPEC_ATTR;
    void* _ssdm_op_SpecEdge() SSDM_SPEC_ATTR; */

    /* Presynthesis directive functions */
    void _ssdm_SpecArrayDimSize() __attribute__ ((nothrow));

    void _ssdm_RegionBegin() __attribute__ ((nothrow));
    void _ssdm_RegionEnd() __attribute__ ((nothrow));

    void _ssdm_Unroll() __attribute__ ((nothrow));
    void _ssdm_UnrollRegion() __attribute__ ((nothrow));

    void _ssdm_InlineAll() __attribute__ ((nothrow));
    void _ssdm_InlineLoop() __attribute__ ((nothrow));
    void _ssdm_Inline() __attribute__ ((nothrow));
    void _ssdm_InlineSelf() __attribute__ ((nothrow));
    void _ssdm_InlineRegion() __attribute__ ((nothrow));

    void _ssdm_SpecArrayMap() __attribute__ ((nothrow));
    void _ssdm_SpecArrayPartition() __attribute__ ((nothrow));
    void _ssdm_SpecArrayReshape() __attribute__ ((nothrow));

    void _ssdm_SpecStream() __attribute__ ((nothrow));

    void _ssdm_SpecExpr() __attribute__ ((nothrow));
    void _ssdm_SpecExprBalance() __attribute__ ((nothrow));

    void _ssdm_SpecDependence() __attribute__ ((nothrow));

    void _ssdm_SpecLoopMerge() __attribute__ ((nothrow));
    void _ssdm_SpecLoopFlatten() __attribute__ ((nothrow));
    void _ssdm_SpecLoopRewind() __attribute__ ((nothrow));

    void _ssdm_SpecFuncInstantiation() __attribute__ ((nothrow));
    void _ssdm_SpecFuncBuffer() __attribute__ ((nothrow));
    void _ssdm_SpecFuncExtract() __attribute__ ((nothrow));
    void _ssdm_SpecConstant() __attribute__ ((nothrow));

    void _ssdm_DataPack() __attribute__ ((nothrow));
    void _ssdm_SpecDataPack() __attribute__ ((nothrow));

    void _ssdm_op_SpecBitsMap() __attribute__ ((nothrow));


/*#define _ssdm_op_WaitUntil(X) while (!(X)) _ssdm_op_Wait(1);
#define _ssdm_op_Delayed(X) X */
# 8 "<command line>" 2
# 1 "<built-in>" 2
# 1 "acc_vadd/acc_vadd.c" 2

void acc_vadd(int *sI1, int *sI2, int *mO1)
{
#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS INTERFACE axis depth=16 port=sI1
#pragma HLS INTERFACE axis depth=16 port=sI2
#pragma HLS INTERFACE axis depth=16 port=mO1

 *mO1 = *sI1 + *sI2;

}
/*
#include <stdio.h>

#define BRAMR		1
#define BRAMW		2
#define BRAMRW		3
#define READBRAM	11
#define WRITEBRAM	22

#define conf_num	4

#define N2N 11
#define N2E	12
#define N2S 13
#define N2W 14

#define E2E 22
#define E2N	21
#define E2S 23
#define E2W	24

#define S2S 33
#define S2N	31
#define S2E 32
#define S2W 34

#define W2W 44
#define W2N 41
#define W2E 42
#define W2S 43

#define HACC_GO		1000
#define HACC_SET	1001
#define HACC_DIR	1002

#define NORTH		1
#define EAST		2
#define SOUTH		3
#define WEST		4

#define NA			-1
#define IN			0
#define OUT			1
#define SPIN		2
#define SPOUT		3

#define NB0			0
#define NB1			1
#define NB2			2
#define NB3			3

#define EB0			0
#define EB1			1
#define EB2			2
#define EB3			3

#define SB0			0
#define SB1			1
#define SB2			2
#define SB3			3

#define WB0			0
#define WB1			1
#define WB2			2
#define WB3			3

#define SP			4

void acc_vadd(
		volatile int 						*cmd		,
		volatile int						*resp		,
		volatile int						*sI1		,
		volatile int						*sI2		,
		volatile int						*mO1			)
{
#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS INTERFACE axis port=cmd
#pragma HLS INTERFACE axis port=resp

#pragma HLS INTERFACE axis port=sI1
#pragma HLS INTERFACE axis port=sI2

#pragma HLS INTERFACE axis port=mO1

#pragma HLS STREAM variable=sI1 	depth=16
#pragma HLS STREAM variable=sI2 	depth=16
#pragma HLS STREAM variable=mO1 	depth=16

	int conf;
	int len;
	int sum;
	int svalue;
	while_loop:
	while(1){
		conf = *cmd;
		len	 = *cmd;
		svalue 	= *cmd;
		if (len == 0){
			*resp = 1;
		}
		else if (conf == 1) {
			for(int i = 0; i < len; i++) {
				*mO1 = *sI1 + *sI2;
				if (i == len - 1) {
					*resp = 1;
				}
			}
		}
	}
}
*/

/*
void acc_pr(
		volatile int 						*cmd		,
		volatile int 						*resp		,
		volatile int						*Is1		,
		//volatile int						*Is2		,
		volatile int						*Os1		,
		volatile int						*BC1		,
		volatile int						*BC2		,
		hls::stream<AXI_VAL>				&sI1		,
		//hls::stream<AXI_VAL>				&sI2		,
		hls::stream<AXI_VAL>				&mO			)
{

#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS INTERFACE axis port=cmd
#pragma HLS INTERFACE axis port=resp

#pragma HLS INTERFACE axis port=BC1
#pragma HLS INTERFACE axis port=BC2

#pragma HLS INTERFACE axis port=Is1
//#pragma HLS INTERFACE axis port=Is2
#pragma HLS INTERFACE axis port=Os1

#pragma HLS INTERFACE axis port=sI1
//#pragma HLS INTERFACE axis port=sI2
#pragma HLS INTERFACE axis port=mO

#pragma HLS STREAM variable=sI1 	depth=16
#pragma HLS STREAM variable=mO 		depth=16

	int index;
	int len;

	int i;
	AXI_VAL dout_val;
	AXI_VAL din1_val;
	AXI_VAL din2_val;

	while_Loop:
	while (1){
		len	 = *cmd;
		*Is1 = WEST;
		*Is1 = len;
		*Os1 = EAST;
		*Os1 = len;

		*BC1 = READBRAM;
		*BC1 = 0;
		*BC1 = len;

		*BC2 = WRITEBRAM;
		*BC2 = 0;
		*BC2 = len;

		*BC1 = 1;
		*BC2 = 1;

		for(i=0; i<len; i++){
			din1_val = sI1.read();
			//din_val = sI2.read();
			dout_val.dest = din1_val.dest;
			dout_val.data = din1_val.data.to_int();
			dout_val.last = din1_val.last;
			mO << dout_val;
			if (i== len-1){
				*resp = 1;
			}
		}
	}

}

*/
