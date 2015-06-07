
/*
void acc_vadd_hls ( volatile int *cmd, volatile int *resp, int a[4096], int b[4096], int result[4096]  ) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis depth=16 port=cmd
#pragma HLS INTERFACE axis depth=16 port=resp
#pragma HLS INTERFACE bram depth=1024 port=a
#pragma HLS INTERFACE bram depth=1024 port=b
#pragma HLS INTERFACE bram depth=1024 port=result

#pragma HLS RESOURCE variable=a core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=b core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=result core=RAM_1P_BRAM

	int i,op, start,end;
	// Accumulate each channel
	op		= *cmd; //get the start command
	end		= *cmd;
	start 	= *cmd;
	if (op == 1)
		add_Loop: for (i = start; i < end; i++) {
					result[i]= a[i] + b[i] * 2;
						if (i == end-1) {
							*resp= 1; //means I am done.
						}
	}
}
*/


void acc_vadd_hls ( volatile int *cmd, volatile int *resp, int a[4096], int b[4096], int result[4096]  ) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis depth=16 port=cmd
#pragma HLS INTERFACE axis depth=16 port=resp
#pragma HLS INTERFACE bram depth=1024 port=a
#pragma HLS INTERFACE bram depth=1024 port=b
#pragma HLS INTERFACE bram depth=1024 port=result

#pragma HLS RESOURCE variable=a core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=b core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=result core=RAM_1P_BRAM

	int i,op, start,end;
	// Accumulate each channel
	op		= *cmd; //get the start command
	end		= *cmd;
	start 	= *cmd;
	if (op == 1)
		add_Loop: for (i = start; i < end; i++) {
					result[i]= a[i] + b[i];
						if (i == end-1) {
							*resp= 1; //means I am done.
						}
	}
	else if (op == 2)
		sub_Loop: for (i = start; i < end; i++) {
					result[i]= b[i] + a[i];
						if (i == end-1) {
							*resp= 1; //means I am done.
						}
	}
}

