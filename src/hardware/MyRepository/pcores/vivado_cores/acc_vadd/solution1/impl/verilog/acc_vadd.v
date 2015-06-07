// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2014.2
// Copyright (C) 2014 Xilinx Inc. All rights reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="acc_vadd,hls_ip_2014_2,{HLS_INPUT_TYPE=c,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7k325tffg900-2,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=1.600000,HLS_SYN_LAT=0,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=0,HLS_SYN_LUT=0}" *)

module acc_vadd (
        ap_clk,
        ap_rst_n,
        sI1_TDATA,
        sI1_TVALID,
        sI1_TREADY,
        sI2_TDATA,
        sI2_TVALID,
        sI2_TREADY,
        mO1_TDATA,
        mO1_TVALID,
        mO1_TREADY
);

parameter    ap_const_logic_1 = 1'b1;
parameter    ap_const_logic_0 = 1'b0;
parameter    ap_ST_st1_fsm_0 = 1'b0;
parameter    ap_true = 1'b1;

input   ap_clk;
input   ap_rst_n;
input  [31:0] sI1_TDATA;
input   sI1_TVALID;
output   sI1_TREADY;
input  [31:0] sI2_TDATA;
input   sI2_TVALID;
output   sI2_TREADY;
output  [31:0] mO1_TDATA;
output   mO1_TVALID;
input   mO1_TREADY;

reg sI1_TREADY;
reg sI2_TREADY;
reg mO1_TVALID;
reg   [0:0] ap_CS_fsm = 1'b0;
reg    ap_sig_bdd_23;
reg    ap_sig_ioackin_mO1_TREADY;
reg    ap_reg_ioackin_mO1_TREADY = 1'b0;
reg   [0:0] ap_NS_fsm;
reg    ap_sig_bdd_48;




/// the current state (ap_CS_fsm) of the state machine. ///
always @ (posedge ap_clk)
begin : ap_ret_ap_CS_fsm
    if (ap_rst_n == 1'b0) begin
        ap_CS_fsm <= ap_ST_st1_fsm_0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

/// ap_reg_ioackin_mO1_TREADY assign process. ///
always @ (posedge ap_clk)
begin : ap_ret_ap_reg_ioackin_mO1_TREADY
    if (ap_rst_n == 1'b0) begin
        ap_reg_ioackin_mO1_TREADY <= ap_const_logic_0;
    end else begin
        if ((ap_ST_st1_fsm_0 == ap_CS_fsm)) begin
            if (~(ap_sig_bdd_23 | (ap_const_logic_0 == ap_sig_ioackin_mO1_TREADY))) begin
                ap_reg_ioackin_mO1_TREADY <= ap_const_logic_0;
            end else if (ap_sig_bdd_48) begin
                ap_reg_ioackin_mO1_TREADY <= ap_const_logic_1;
            end
        end
    end
end

/// ap_sig_ioackin_mO1_TREADY assign process. ///
always @ (mO1_TREADY or ap_reg_ioackin_mO1_TREADY)
begin
    if ((ap_const_logic_0 == ap_reg_ioackin_mO1_TREADY)) begin
        ap_sig_ioackin_mO1_TREADY = mO1_TREADY;
    end else begin
        ap_sig_ioackin_mO1_TREADY = ap_const_logic_1;
    end
end

/// mO1_TVALID assign process. ///
always @ (ap_CS_fsm or ap_sig_bdd_23 or ap_reg_ioackin_mO1_TREADY)
begin
    if (((ap_ST_st1_fsm_0 == ap_CS_fsm) & ~ap_sig_bdd_23 & (ap_const_logic_0 == ap_reg_ioackin_mO1_TREADY))) begin
        mO1_TVALID = ap_const_logic_1;
    end else begin
        mO1_TVALID = ap_const_logic_0;
    end
end

/// sI1_TREADY assign process. ///
always @ (ap_CS_fsm or ap_sig_bdd_23 or ap_sig_ioackin_mO1_TREADY)
begin
    if (((ap_ST_st1_fsm_0 == ap_CS_fsm) & ~(ap_sig_bdd_23 | (ap_const_logic_0 == ap_sig_ioackin_mO1_TREADY)))) begin
        sI1_TREADY = ap_const_logic_1;
    end else begin
        sI1_TREADY = ap_const_logic_0;
    end
end

/// sI2_TREADY assign process. ///
always @ (ap_CS_fsm or ap_sig_bdd_23 or ap_sig_ioackin_mO1_TREADY)
begin
    if (((ap_ST_st1_fsm_0 == ap_CS_fsm) & ~(ap_sig_bdd_23 | (ap_const_logic_0 == ap_sig_ioackin_mO1_TREADY)))) begin
        sI2_TREADY = ap_const_logic_1;
    end else begin
        sI2_TREADY = ap_const_logic_0;
    end
end
/// the next state (ap_NS_fsm) of the state machine. ///
always @ (ap_CS_fsm or ap_sig_bdd_23 or ap_sig_ioackin_mO1_TREADY)
begin
    case (ap_CS_fsm)
        ap_ST_st1_fsm_0 : 
        begin
            ap_NS_fsm = ap_ST_st1_fsm_0;
        end
        default : 
        begin
            ap_NS_fsm = 'bx;
        end
    endcase
end


/// ap_sig_bdd_23 assign process. ///
always @ (sI1_TVALID or sI2_TVALID)
begin
    ap_sig_bdd_23 = ((sI1_TVALID == ap_const_logic_0) | (sI2_TVALID == ap_const_logic_0));
end

/// ap_sig_bdd_48 assign process. ///
always @ (mO1_TREADY or ap_sig_bdd_23)
begin
    ap_sig_bdd_48 = (~ap_sig_bdd_23 & (ap_const_logic_1 == mO1_TREADY));
end
assign mO1_TDATA = (sI2_TDATA + sI1_TDATA);


endmodule //acc_vadd
