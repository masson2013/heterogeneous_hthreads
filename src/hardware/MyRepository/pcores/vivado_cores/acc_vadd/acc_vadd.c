
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
