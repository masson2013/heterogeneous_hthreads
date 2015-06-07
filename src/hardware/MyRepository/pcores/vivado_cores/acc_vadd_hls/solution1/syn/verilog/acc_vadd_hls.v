// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2014.2
// Copyright (C) 2014 Xilinx Inc. All rights reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="acc_vadd_hls,hls_ip_2014_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7k325tffg900-2,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=6.380000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=0,HLS_SYN_LUT=0}" *)

module acc_vadd_hls (
        ap_clk,
        ap_rst_n,
        cmd_TDATA,
        cmd_TVALID,
        cmd_TREADY,
        resp_TDATA,
        resp_TVALID,
        resp_TREADY,
        a_Addr_A,
        a_EN_A,
        a_WEN_A,
        a_Din_A,
        a_Dout_A,
        a_Clk_A,
        a_Rst_A,
        b_Addr_A,
        b_EN_A,
        b_WEN_A,
        b_Din_A,
        b_Dout_A,
        b_Clk_A,
        b_Rst_A,
        result_Addr_A,
        result_EN_A,
        result_WEN_A,
        result_Din_A,
        result_Dout_A,
        result_Clk_A,
        result_Rst_A
);

parameter    ap_const_logic_1 = 1'b1;
parameter    ap_const_logic_0 = 1'b0;
parameter    ap_ST_st1_fsm_0 = 3'b000;
parameter    ap_ST_st2_fsm_1 = 3'b1;
parameter    ap_ST_st3_fsm_2 = 3'b10;
parameter    ap_ST_st4_fsm_3 = 3'b11;
parameter    ap_ST_st5_fsm_4 = 3'b100;
parameter    ap_ST_st6_fsm_5 = 3'b101;
parameter    ap_const_lv1_0 = 1'b0;
parameter    ap_const_lv32_1 = 32'b1;
parameter    ap_const_lv32_2 = 32'b10;
parameter    ap_const_lv4_0 = 4'b0000;
parameter    ap_const_lv4_F = 4'b1111;
parameter    ap_const_lv32_FFFFFFFF = 32'b11111111111111111111111111111111;
parameter    ap_const_lv32_0 = 32'b00000000000000000000000000000000;
parameter    ap_true = 1'b1;

input   ap_clk;
input   ap_rst_n;
input  [31:0] cmd_TDATA;
input   cmd_TVALID;
output   cmd_TREADY;
output  [31:0] resp_TDATA;
output   resp_TVALID;
input   resp_TREADY;
output  [31:0] a_Addr_A;
output   a_EN_A;
output  [3:0] a_WEN_A;
output  [31:0] a_Din_A;
input  [31:0] a_Dout_A;
output   a_Clk_A;
output   a_Rst_A;
output  [31:0] b_Addr_A;
output   b_EN_A;
output  [3:0] b_WEN_A;
output  [31:0] b_Din_A;
input  [31:0] b_Dout_A;
output   b_Clk_A;
output   b_Rst_A;
output  [31:0] result_Addr_A;
output   result_EN_A;
output  [3:0] result_WEN_A;
output  [31:0] result_Din_A;
input  [31:0] result_Dout_A;
output   result_Clk_A;
output   result_Rst_A;

reg cmd_TREADY;
reg resp_TVALID;
reg a_EN_A;
reg b_EN_A;
reg result_EN_A;
reg[3:0] result_WEN_A;
reg[31:0] result_Din_A;
wire   [31:0] grp_fu_149_p2;
reg   [31:0] reg_154;
reg   [2:0] ap_CS_fsm = 3'b000;
wire   [0:0] tmp_fu_158_p2;
wire   [0:0] tmp_2_fu_163_p2;
reg   [31:0] op_reg_228;
reg   [31:0] end_reg_234;
reg   [0:0] tmp_reg_247;
reg   [0:0] tmp_2_reg_251;
wire   [63:0] tmp_s_fu_173_p1;
reg   [63:0] tmp_s_reg_258;
wire   [0:0] tmp_8_fu_168_p2;
wire   [0:0] tmp_10_fu_179_p2;
reg   [0:0] tmp_10_reg_273;
wire   [63:0] tmp_5_fu_190_p1;
reg   [63:0] tmp_5_reg_280;
wire   [0:0] tmp_3_fu_185_p2;
wire   [0:0] tmp_7_fu_196_p2;
reg   [0:0] tmp_7_reg_295;
wire   [31:0] i_3_fu_209_p2;
reg    ap_sig_ioackin_resp_TREADY;
wire   [31:0] i_2_fu_222_p2;
reg   [31:0] i_1_reg_128;
reg   [31:0] i_reg_138;
reg    ap_reg_ioackin_resp_TREADY = 1'b0;
reg   [31:0] b_Addr_A_orig;
reg   [31:0] a_Addr_A_orig;
wire   [31:0] tmp_9_fu_202_p2;
wire   [31:0] tmp_6_fu_215_p2;
reg   [31:0] result_Addr_A_orig;
reg   [2:0] ap_NS_fsm;
reg    ap_sig_bdd_86;
reg    ap_sig_bdd_100;




/// the current state (ap_CS_fsm) of the state machine. ///
always @ (posedge ap_clk)
begin : ap_ret_ap_CS_fsm
    if (ap_rst_n == 1'b0) begin
        ap_CS_fsm <= ap_ST_st1_fsm_0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

/// ap_reg_ioackin_resp_TREADY assign process. ///
always @ (posedge ap_clk)
begin : ap_ret_ap_reg_ioackin_resp_TREADY
    if (ap_rst_n == 1'b0) begin
        ap_reg_ioackin_resp_TREADY <= ap_const_logic_0;
    end else begin
        if ((((ap_ST_st5_fsm_4 == ap_CS_fsm) & ~(ap_const_lv1_0 == tmp_10_reg_273) & ~(~(ap_const_lv1_0 == tmp_10_reg_273) & (ap_const_logic_0 == ap_sig_ioackin_resp_TREADY))) | ((ap_ST_st6_fsm_5 == ap_CS_fsm) & ~(ap_const_lv1_0 == tmp_7_reg_295) & ~((ap_const_logic_0 == ap_sig_ioackin_resp_TREADY) & ~(ap_const_lv1_0 == tmp_7_reg_295))))) begin
            ap_reg_ioackin_resp_TREADY <= ap_const_logic_0;
        end else if ((((ap_ST_st5_fsm_4 == ap_CS_fsm) & ~(ap_const_lv1_0 == tmp_10_reg_273) & (ap_const_logic_1 == resp_TREADY)) | ((ap_ST_st6_fsm_5 == ap_CS_fsm) & ~(ap_const_lv1_0 == tmp_7_reg_295) & (ap_const_logic_1 == resp_TREADY)))) begin
            ap_reg_ioackin_resp_TREADY <= ap_const_logic_1;
        end
    end
end

/// assign process. ///
always @(posedge ap_clk)
begin
    if (((ap_ST_st3_fsm_2 == ap_CS_fsm) & ~(cmd_TVALID == ap_const_logic_0) & (tmp_fu_158_p2 == ap_const_lv1_0) & ~(ap_const_lv1_0 == tmp_2_fu_163_p2))) begin
        i_1_reg_128 <= cmd_TDATA;
    end else if (((ap_ST_st5_fsm_4 == ap_CS_fsm) & ~(~(ap_const_lv1_0 == tmp_10_reg_273) & (ap_const_logic_0 == ap_sig_ioackin_resp_TREADY)))) begin
        i_1_reg_128 <= i_3_fu_209_p2;
    end
end

/// assign process. ///
always @(posedge ap_clk)
begin
    if (((ap_ST_st3_fsm_2 == ap_CS_fsm) & ~(cmd_TVALID == ap_const_logic_0) & ~(tmp_fu_158_p2 == ap_const_lv1_0))) begin
        i_reg_138 <= cmd_TDATA;
    end else if (((ap_ST_st6_fsm_5 == ap_CS_fsm) & ~((ap_const_logic_0 == ap_sig_ioackin_resp_TREADY) & ~(ap_const_lv1_0 == tmp_7_reg_295)))) begin
        i_reg_138 <= i_2_fu_222_p2;
    end
end

/// assign process. ///
always @(posedge ap_clk)
begin
    if ((~(cmd_TVALID == ap_const_logic_0) & (ap_ST_st2_fsm_1 == ap_CS_fsm))) begin
        end_reg_234 <= cmd_TDATA;
    end
end

/// assign process. ///
always @(posedge ap_clk)
begin
    if ((~(cmd_TVALID == ap_const_logic_0) & (ap_ST_st1_fsm_0 == ap_CS_fsm))) begin
        op_reg_228 <= cmd_TDATA;
    end
end

/// assign process. ///
always @(posedge ap_clk)
begin
    if ((((ap_ST_st3_fsm_2 == ap_CS_fsm) & ~(cmd_TVALID == ap_const_logic_0) & (tmp_fu_158_p2 == ap_const_lv1_0) & ~(ap_const_lv1_0 == tmp_2_fu_163_p2)) | ((ap_ST_st3_fsm_2 == ap_CS_fsm) & ~(cmd_TVALID == ap_const_logic_0) & ~(tmp_fu_158_p2 == ap_const_lv1_0)))) begin
        reg_154 <= grp_fu_149_p2;
    end
end

/// assign process. ///
always @(posedge ap_clk)
begin
    if (((ap_ST_st4_fsm_3 == ap_CS_fsm) & (ap_const_lv1_0 == tmp_reg_247) & ~(ap_const_lv1_0 == tmp_2_reg_251) & ~(ap_const_lv1_0 == tmp_8_fu_168_p2))) begin
        tmp_10_reg_273 <= tmp_10_fu_179_p2;
        tmp_s_reg_258 <= tmp_s_fu_173_p1;
    end
end

/// assign process. ///
always @(posedge ap_clk)
begin
    if (((ap_ST_st3_fsm_2 == ap_CS_fsm) & ~(cmd_TVALID == ap_const_logic_0) & (tmp_fu_158_p2 == ap_const_lv1_0))) begin
        tmp_2_reg_251 <= tmp_2_fu_163_p2;
    end
end

/// assign process. ///
always @(posedge ap_clk)
begin
    if (((ap_ST_st4_fsm_3 == ap_CS_fsm) & ~(ap_const_lv1_0 == tmp_reg_247) & ~(ap_const_lv1_0 == tmp_3_fu_185_p2))) begin
        tmp_5_reg_280 <= tmp_5_fu_190_p1;
        tmp_7_reg_295 <= tmp_7_fu_196_p2;
    end
end

/// assign process. ///
always @(posedge ap_clk)
begin
    if (((ap_ST_st3_fsm_2 == ap_CS_fsm) & ~(cmd_TVALID == ap_const_logic_0))) begin
        tmp_reg_247 <= tmp_fu_158_p2;
    end
end

/// a_Addr_A_orig assign process. ///
always @ (ap_CS_fsm or tmp_s_fu_173_p1 or tmp_5_fu_190_p1 or ap_sig_bdd_86 or ap_sig_bdd_100)
begin
    if ((ap_ST_st4_fsm_3 == ap_CS_fsm)) begin
        if (ap_sig_bdd_100) begin
            a_Addr_A_orig = tmp_5_fu_190_p1;
        end else if (ap_sig_bdd_86) begin
            a_Addr_A_orig = tmp_s_fu_173_p1;
        end else begin
            a_Addr_A_orig = 'bx;
        end
    end else begin
        a_Addr_A_orig = 'bx;
    end
end

/// a_EN_A assign process. ///
always @ (ap_CS_fsm or tmp_reg_247 or tmp_2_reg_251 or tmp_8_fu_168_p2 or tmp_3_fu_185_p2)
begin
    if ((((ap_ST_st4_fsm_3 == ap_CS_fsm) & (ap_const_lv1_0 == tmp_reg_247) & ~(ap_const_lv1_0 == tmp_2_reg_251) & ~(ap_const_lv1_0 == tmp_8_fu_168_p2)) | ((ap_ST_st4_fsm_3 == ap_CS_fsm) & ~(ap_const_lv1_0 == tmp_reg_247) & ~(ap_const_lv1_0 == tmp_3_fu_185_p2)))) begin
        a_EN_A = ap_const_logic_1;
    end else begin
        a_EN_A = ap_const_logic_0;
    end
end

/// ap_sig_ioackin_resp_TREADY assign process. ///
always @ (resp_TREADY or ap_reg_ioackin_resp_TREADY)
begin
    if ((ap_const_logic_0 == ap_reg_ioackin_resp_TREADY)) begin
        ap_sig_ioackin_resp_TREADY = resp_TREADY;
    end else begin
        ap_sig_ioackin_resp_TREADY = ap_const_logic_1;
    end
end

/// b_Addr_A_orig assign process. ///
always @ (ap_CS_fsm or tmp_s_fu_173_p1 or tmp_5_fu_190_p1 or ap_sig_bdd_86 or ap_sig_bdd_100)
begin
    if ((ap_ST_st4_fsm_3 == ap_CS_fsm)) begin
        if (ap_sig_bdd_100) begin
            b_Addr_A_orig = tmp_5_fu_190_p1;
        end else if (ap_sig_bdd_86) begin
            b_Addr_A_orig = tmp_s_fu_173_p1;
        end else begin
            b_Addr_A_orig = 'bx;
        end
    end else begin
        b_Addr_A_orig = 'bx;
    end
end

/// b_EN_A assign process. ///
always @ (ap_CS_fsm or tmp_reg_247 or tmp_2_reg_251 or tmp_8_fu_168_p2 or tmp_3_fu_185_p2)
begin
    if ((((ap_ST_st4_fsm_3 == ap_CS_fsm) & (ap_const_lv1_0 == tmp_reg_247) & ~(ap_const_lv1_0 == tmp_2_reg_251) & ~(ap_const_lv1_0 == tmp_8_fu_168_p2)) | ((ap_ST_st4_fsm_3 == ap_CS_fsm) & ~(ap_const_lv1_0 == tmp_reg_247) & ~(ap_const_lv1_0 == tmp_3_fu_185_p2)))) begin
        b_EN_A = ap_const_logic_1;
    end else begin
        b_EN_A = ap_const_logic_0;
    end
end

/// cmd_TREADY assign process. ///
always @ (cmd_TVALID or ap_CS_fsm)
begin
    if ((((ap_ST_st3_fsm_2 == ap_CS_fsm) & ~(cmd_TVALID == ap_const_logic_0)) | (~(cmd_TVALID == ap_const_logic_0) & (ap_ST_st1_fsm_0 == ap_CS_fsm)) | (~(cmd_TVALID == ap_const_logic_0) & (ap_ST_st2_fsm_1 == ap_CS_fsm)))) begin
        cmd_TREADY = ap_const_logic_1;
    end else begin
        cmd_TREADY = ap_const_logic_0;
    end
end

/// resp_TVALID assign process. ///
always @ (ap_CS_fsm or tmp_10_reg_273 or tmp_7_reg_295 or ap_reg_ioackin_resp_TREADY)
begin
    if ((((ap_ST_st5_fsm_4 == ap_CS_fsm) & ~(ap_const_lv1_0 == tmp_10_reg_273) & (ap_const_logic_0 == ap_reg_ioackin_resp_TREADY)) | ((ap_ST_st6_fsm_5 == ap_CS_fsm) & ~(ap_const_lv1_0 == tmp_7_reg_295) & (ap_const_logic_0 == ap_reg_ioackin_resp_TREADY)))) begin
        resp_TVALID = ap_const_logic_1;
    end else begin
        resp_TVALID = ap_const_logic_0;
    end
end

/// result_Addr_A_orig assign process. ///
always @ (ap_CS_fsm or tmp_s_reg_258 or tmp_5_reg_280)
begin
    if ((ap_ST_st6_fsm_5 == ap_CS_fsm)) begin
        result_Addr_A_orig = tmp_5_reg_280;
    end else if ((ap_ST_st5_fsm_4 == ap_CS_fsm)) begin
        result_Addr_A_orig = tmp_s_reg_258;
    end else begin
        result_Addr_A_orig = 'bx;
    end
end

/// result_Din_A assign process. ///
always @ (ap_CS_fsm or tmp_9_fu_202_p2 or tmp_6_fu_215_p2)
begin
    if ((ap_ST_st6_fsm_5 == ap_CS_fsm)) begin
        result_Din_A = tmp_6_fu_215_p2;
    end else if ((ap_ST_st5_fsm_4 == ap_CS_fsm)) begin
        result_Din_A = tmp_9_fu_202_p2;
    end else begin
        result_Din_A = 'bx;
    end
end

/// result_EN_A assign process. ///
always @ (ap_CS_fsm or tmp_10_reg_273 or tmp_7_reg_295 or ap_sig_ioackin_resp_TREADY)
begin
    if ((((ap_ST_st5_fsm_4 == ap_CS_fsm) & ~(~(ap_const_lv1_0 == tmp_10_reg_273) & (ap_const_logic_0 == ap_sig_ioackin_resp_TREADY))) | ((ap_ST_st6_fsm_5 == ap_CS_fsm) & ~((ap_const_logic_0 == ap_sig_ioackin_resp_TREADY) & ~(ap_const_lv1_0 == tmp_7_reg_295))))) begin
        result_EN_A = ap_const_logic_1;
    end else begin
        result_EN_A = ap_const_logic_0;
    end
end

/// result_WEN_A assign process. ///
always @ (ap_CS_fsm or tmp_10_reg_273 or tmp_7_reg_295 or ap_sig_ioackin_resp_TREADY)
begin
    if ((((ap_ST_st5_fsm_4 == ap_CS_fsm) & ~(~(ap_const_lv1_0 == tmp_10_reg_273) & (ap_const_logic_0 == ap_sig_ioackin_resp_TREADY))) | ((ap_ST_st6_fsm_5 == ap_CS_fsm) & ~((ap_const_logic_0 == ap_sig_ioackin_resp_TREADY) & ~(ap_const_lv1_0 == tmp_7_reg_295))))) begin
        result_WEN_A = ap_const_lv4_F;
    end else begin
        result_WEN_A = ap_const_lv4_0;
    end
end
/// the next state (ap_NS_fsm) of the state machine. ///
always @ (cmd_TVALID or ap_CS_fsm or tmp_reg_247 or tmp_2_reg_251 or tmp_8_fu_168_p2 or tmp_10_reg_273 or tmp_3_fu_185_p2 or tmp_7_reg_295 or ap_sig_ioackin_resp_TREADY)
begin
    case (ap_CS_fsm)
        ap_ST_st1_fsm_0 : 
        begin
            if (~(cmd_TVALID == ap_const_logic_0)) begin
                ap_NS_fsm = ap_ST_st2_fsm_1;
            end else begin
                ap_NS_fsm = ap_ST_st1_fsm_0;
            end
        end
        ap_ST_st2_fsm_1 : 
        begin
            if (~(cmd_TVALID == ap_const_logic_0)) begin
                ap_NS_fsm = ap_ST_st3_fsm_2;
            end else begin
                ap_NS_fsm = ap_ST_st2_fsm_1;
            end
        end
        ap_ST_st3_fsm_2 : 
        begin
            if (~(cmd_TVALID == ap_const_logic_0)) begin
                ap_NS_fsm = ap_ST_st4_fsm_3;
            end else begin
                ap_NS_fsm = ap_ST_st3_fsm_2;
            end
        end
        ap_ST_st4_fsm_3 : 
        begin
            if ((((ap_const_lv1_0 == tmp_reg_247) & (ap_const_lv1_0 == tmp_2_reg_251)) | (~(ap_const_lv1_0 == tmp_reg_247) & (ap_const_lv1_0 == tmp_3_fu_185_p2)) | ((ap_const_lv1_0 == tmp_reg_247) & (ap_const_lv1_0 == tmp_8_fu_168_p2)))) begin
                ap_NS_fsm = ap_ST_st1_fsm_0;
            end else if ((~(ap_const_lv1_0 == tmp_reg_247) & ~(ap_const_lv1_0 == tmp_3_fu_185_p2))) begin
                ap_NS_fsm = ap_ST_st6_fsm_5;
            end else begin
                ap_NS_fsm = ap_ST_st5_fsm_4;
            end
        end
        ap_ST_st5_fsm_4 : 
        begin
            if (~(~(ap_const_lv1_0 == tmp_10_reg_273) & (ap_const_logic_0 == ap_sig_ioackin_resp_TREADY))) begin
                ap_NS_fsm = ap_ST_st4_fsm_3;
            end else begin
                ap_NS_fsm = ap_ST_st5_fsm_4;
            end
        end
        ap_ST_st6_fsm_5 : 
        begin
            if (~((ap_const_logic_0 == ap_sig_ioackin_resp_TREADY) & ~(ap_const_lv1_0 == tmp_7_reg_295))) begin
                ap_NS_fsm = ap_ST_st4_fsm_3;
            end else begin
                ap_NS_fsm = ap_ST_st6_fsm_5;
            end
        end
        default : 
        begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign a_Addr_A = a_Addr_A_orig << ap_const_lv32_2;
assign a_Clk_A = ap_clk;
assign a_Din_A = ap_const_lv32_0;
assign a_Rst_A = ap_rst_n;
assign a_WEN_A = ap_const_lv4_0;

/// ap_sig_bdd_100 assign process. ///
always @ (tmp_reg_247 or tmp_3_fu_185_p2)
begin
    ap_sig_bdd_100 = (~(ap_const_lv1_0 == tmp_reg_247) & ~(ap_const_lv1_0 == tmp_3_fu_185_p2));
end

/// ap_sig_bdd_86 assign process. ///
always @ (tmp_reg_247 or tmp_2_reg_251 or tmp_8_fu_168_p2)
begin
    ap_sig_bdd_86 = ((ap_const_lv1_0 == tmp_reg_247) & ~(ap_const_lv1_0 == tmp_2_reg_251) & ~(ap_const_lv1_0 == tmp_8_fu_168_p2));
end
assign b_Addr_A = b_Addr_A_orig << ap_const_lv32_2;
assign b_Clk_A = ap_clk;
assign b_Din_A = ap_const_lv32_0;
assign b_Rst_A = ap_rst_n;
assign b_WEN_A = ap_const_lv4_0;
assign grp_fu_149_p2 = (end_reg_234 + ap_const_lv32_FFFFFFFF);
assign i_2_fu_222_p2 = (i_reg_138 + ap_const_lv32_1);
assign i_3_fu_209_p2 = (i_1_reg_128 + ap_const_lv32_1);
assign resp_TDATA = ap_const_lv32_1;
assign result_Addr_A = result_Addr_A_orig << ap_const_lv32_2;
assign result_Clk_A = ap_clk;
assign result_Rst_A = ap_rst_n;
assign tmp_10_fu_179_p2 = (i_1_reg_128 == reg_154? 1'b1: 1'b0);
assign tmp_2_fu_163_p2 = (op_reg_228 == ap_const_lv32_2? 1'b1: 1'b0);
assign tmp_3_fu_185_p2 = ($signed(i_reg_138) < $signed(end_reg_234)? 1'b1: 1'b0);
assign tmp_5_fu_190_p1 = $signed(i_reg_138);
assign tmp_6_fu_215_p2 = (b_Dout_A + a_Dout_A);
assign tmp_7_fu_196_p2 = (i_reg_138 == reg_154? 1'b1: 1'b0);
assign tmp_8_fu_168_p2 = ($signed(i_1_reg_128) < $signed(end_reg_234)? 1'b1: 1'b0);
assign tmp_9_fu_202_p2 = (a_Dout_A + b_Dout_A);
assign tmp_fu_158_p2 = (op_reg_228 == ap_const_lv32_1? 1'b1: 1'b0);
assign tmp_s_fu_173_p1 = $signed(i_1_reg_128);


endmodule //acc_vadd_hls

