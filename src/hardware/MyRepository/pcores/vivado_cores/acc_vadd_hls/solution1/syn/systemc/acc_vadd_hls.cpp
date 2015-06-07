// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2014.2
// Copyright (C) 2014 Xilinx Inc. All rights reserved.
// 
// ===========================================================

#include "acc_vadd_hls.h"
#include "AESL_pkg.h"

using namespace std;

namespace ap_rtl {

const sc_logic acc_vadd_hls::ap_const_logic_1 = sc_dt::Log_1;
const sc_logic acc_vadd_hls::ap_const_logic_0 = sc_dt::Log_0;
const sc_lv<3> acc_vadd_hls::ap_ST_st1_fsm_0 = "000";
const sc_lv<3> acc_vadd_hls::ap_ST_st2_fsm_1 = "1";
const sc_lv<3> acc_vadd_hls::ap_ST_st3_fsm_2 = "10";
const sc_lv<3> acc_vadd_hls::ap_ST_st4_fsm_3 = "11";
const sc_lv<3> acc_vadd_hls::ap_ST_st5_fsm_4 = "100";
const sc_lv<3> acc_vadd_hls::ap_ST_st6_fsm_5 = "101";
const sc_lv<1> acc_vadd_hls::ap_const_lv1_0 = "0";
const sc_lv<32> acc_vadd_hls::ap_const_lv32_1 = "1";
const sc_lv<32> acc_vadd_hls::ap_const_lv32_2 = "10";
const sc_lv<4> acc_vadd_hls::ap_const_lv4_0 = "0000";
const sc_lv<4> acc_vadd_hls::ap_const_lv4_F = "1111";
const sc_lv<32> acc_vadd_hls::ap_const_lv32_FFFFFFFF = "11111111111111111111111111111111";
const sc_lv<32> acc_vadd_hls::ap_const_lv32_0 = "00000000000000000000000000000000";

acc_vadd_hls::acc_vadd_hls(sc_module_name name) : sc_module(name), mVcdFile(0) {

    SC_METHOD(thread_ap_clk_no_reset_);
    dont_initialize();
    sensitive << ( ap_clk.pos() );

    SC_METHOD(thread_a_Addr_A);
    sensitive << ( a_Addr_A_orig );

    SC_METHOD(thread_a_Addr_A_orig);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_s_fu_173_p1 );
    sensitive << ( tmp_5_fu_190_p1 );
    sensitive << ( ap_sig_bdd_86 );
    sensitive << ( ap_sig_bdd_100 );

    SC_METHOD(thread_a_Clk_A);
    sensitive << ( ap_clk );

    SC_METHOD(thread_a_Din_A);

    SC_METHOD(thread_a_EN_A);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_reg_247 );
    sensitive << ( tmp_2_reg_251 );
    sensitive << ( tmp_8_fu_168_p2 );
    sensitive << ( tmp_3_fu_185_p2 );

    SC_METHOD(thread_a_Rst_A);
    sensitive << ( ap_rst_n );

    SC_METHOD(thread_a_WEN_A);

    SC_METHOD(thread_ap_sig_bdd_100);
    sensitive << ( tmp_reg_247 );
    sensitive << ( tmp_3_fu_185_p2 );

    SC_METHOD(thread_ap_sig_bdd_86);
    sensitive << ( tmp_reg_247 );
    sensitive << ( tmp_2_reg_251 );
    sensitive << ( tmp_8_fu_168_p2 );

    SC_METHOD(thread_ap_sig_ioackin_resp_TREADY);
    sensitive << ( resp_TREADY );
    sensitive << ( ap_reg_ioackin_resp_TREADY );

    SC_METHOD(thread_b_Addr_A);
    sensitive << ( b_Addr_A_orig );

    SC_METHOD(thread_b_Addr_A_orig);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_s_fu_173_p1 );
    sensitive << ( tmp_5_fu_190_p1 );
    sensitive << ( ap_sig_bdd_86 );
    sensitive << ( ap_sig_bdd_100 );

    SC_METHOD(thread_b_Clk_A);
    sensitive << ( ap_clk );

    SC_METHOD(thread_b_Din_A);

    SC_METHOD(thread_b_EN_A);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_reg_247 );
    sensitive << ( tmp_2_reg_251 );
    sensitive << ( tmp_8_fu_168_p2 );
    sensitive << ( tmp_3_fu_185_p2 );

    SC_METHOD(thread_b_Rst_A);
    sensitive << ( ap_rst_n );

    SC_METHOD(thread_b_WEN_A);

    SC_METHOD(thread_cmd_TREADY);
    sensitive << ( cmd_TVALID );
    sensitive << ( ap_CS_fsm );

    SC_METHOD(thread_grp_fu_149_p2);
    sensitive << ( end_reg_234 );

    SC_METHOD(thread_i_2_fu_222_p2);
    sensitive << ( i_reg_138 );

    SC_METHOD(thread_i_3_fu_209_p2);
    sensitive << ( i_1_reg_128 );

    SC_METHOD(thread_resp_TDATA);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_10_reg_273 );
    sensitive << ( tmp_7_reg_295 );

    SC_METHOD(thread_resp_TVALID);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_10_reg_273 );
    sensitive << ( tmp_7_reg_295 );
    sensitive << ( ap_reg_ioackin_resp_TREADY );

    SC_METHOD(thread_result_Addr_A);
    sensitive << ( result_Addr_A_orig );

    SC_METHOD(thread_result_Addr_A_orig);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_s_reg_258 );
    sensitive << ( tmp_5_reg_280 );

    SC_METHOD(thread_result_Clk_A);
    sensitive << ( ap_clk );

    SC_METHOD(thread_result_Din_A);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_9_fu_202_p2 );
    sensitive << ( tmp_6_fu_215_p2 );

    SC_METHOD(thread_result_EN_A);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_10_reg_273 );
    sensitive << ( tmp_7_reg_295 );
    sensitive << ( ap_sig_ioackin_resp_TREADY );

    SC_METHOD(thread_result_Rst_A);
    sensitive << ( ap_rst_n );

    SC_METHOD(thread_result_WEN_A);
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_10_reg_273 );
    sensitive << ( tmp_7_reg_295 );
    sensitive << ( ap_sig_ioackin_resp_TREADY );

    SC_METHOD(thread_tmp_10_fu_179_p2);
    sensitive << ( reg_154 );
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_reg_247 );
    sensitive << ( tmp_2_reg_251 );
    sensitive << ( tmp_8_fu_168_p2 );
    sensitive << ( i_1_reg_128 );

    SC_METHOD(thread_tmp_2_fu_163_p2);
    sensitive << ( cmd_TVALID );
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_fu_158_p2 );
    sensitive << ( op_reg_228 );

    SC_METHOD(thread_tmp_3_fu_185_p2);
    sensitive << ( ap_CS_fsm );
    sensitive << ( end_reg_234 );
    sensitive << ( tmp_reg_247 );
    sensitive << ( i_reg_138 );

    SC_METHOD(thread_tmp_5_fu_190_p1);
    sensitive << ( i_reg_138 );

    SC_METHOD(thread_tmp_6_fu_215_p2);
    sensitive << ( a_Dout_A );
    sensitive << ( b_Dout_A );

    SC_METHOD(thread_tmp_7_fu_196_p2);
    sensitive << ( reg_154 );
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_reg_247 );
    sensitive << ( tmp_3_fu_185_p2 );
    sensitive << ( i_reg_138 );

    SC_METHOD(thread_tmp_8_fu_168_p2);
    sensitive << ( ap_CS_fsm );
    sensitive << ( end_reg_234 );
    sensitive << ( tmp_reg_247 );
    sensitive << ( tmp_2_reg_251 );
    sensitive << ( i_1_reg_128 );

    SC_METHOD(thread_tmp_9_fu_202_p2);
    sensitive << ( a_Dout_A );
    sensitive << ( b_Dout_A );

    SC_METHOD(thread_tmp_fu_158_p2);
    sensitive << ( cmd_TVALID );
    sensitive << ( ap_CS_fsm );
    sensitive << ( op_reg_228 );

    SC_METHOD(thread_tmp_s_fu_173_p1);
    sensitive << ( i_1_reg_128 );

    SC_METHOD(thread_ap_NS_fsm);
    sensitive << ( cmd_TVALID );
    sensitive << ( ap_CS_fsm );
    sensitive << ( tmp_reg_247 );
    sensitive << ( tmp_2_reg_251 );
    sensitive << ( tmp_8_fu_168_p2 );
    sensitive << ( tmp_10_reg_273 );
    sensitive << ( tmp_3_fu_185_p2 );
    sensitive << ( tmp_7_reg_295 );
    sensitive << ( ap_sig_ioackin_resp_TREADY );

    SC_THREAD(thread_hdltv_gen);
    sensitive << ( ap_clk.pos() );

    ap_CS_fsm = "000";
    ap_reg_ioackin_resp_TREADY = SC_LOGIC_0;
    static int apTFileNum = 0;
    stringstream apTFilenSS;
    apTFilenSS << "acc_vadd_hls_sc_trace_" << apTFileNum ++;
    string apTFn = apTFilenSS.str();
    mVcdFile = sc_create_vcd_trace_file(apTFn.c_str());
    mVcdFile->set_time_unit(1, SC_PS);
    if (1) {
#ifdef __HLS_TRACE_LEVEL_PORT__
    sc_trace(mVcdFile, ap_clk, "(port)ap_clk");
    sc_trace(mVcdFile, ap_rst_n, "(port)ap_rst_n");
    sc_trace(mVcdFile, cmd_TDATA, "(port)cmd_TDATA");
    sc_trace(mVcdFile, cmd_TVALID, "(port)cmd_TVALID");
    sc_trace(mVcdFile, cmd_TREADY, "(port)cmd_TREADY");
    sc_trace(mVcdFile, resp_TDATA, "(port)resp_TDATA");
    sc_trace(mVcdFile, resp_TVALID, "(port)resp_TVALID");
    sc_trace(mVcdFile, resp_TREADY, "(port)resp_TREADY");
    sc_trace(mVcdFile, a_Addr_A, "(port)a_Addr_A");
    sc_trace(mVcdFile, a_EN_A, "(port)a_EN_A");
    sc_trace(mVcdFile, a_WEN_A, "(port)a_WEN_A");
    sc_trace(mVcdFile, a_Din_A, "(port)a_Din_A");
    sc_trace(mVcdFile, a_Dout_A, "(port)a_Dout_A");
    sc_trace(mVcdFile, a_Clk_A, "(port)a_Clk_A");
    sc_trace(mVcdFile, a_Rst_A, "(port)a_Rst_A");
    sc_trace(mVcdFile, b_Addr_A, "(port)b_Addr_A");
    sc_trace(mVcdFile, b_EN_A, "(port)b_EN_A");
    sc_trace(mVcdFile, b_WEN_A, "(port)b_WEN_A");
    sc_trace(mVcdFile, b_Din_A, "(port)b_Din_A");
    sc_trace(mVcdFile, b_Dout_A, "(port)b_Dout_A");
    sc_trace(mVcdFile, b_Clk_A, "(port)b_Clk_A");
    sc_trace(mVcdFile, b_Rst_A, "(port)b_Rst_A");
    sc_trace(mVcdFile, result_Addr_A, "(port)result_Addr_A");
    sc_trace(mVcdFile, result_EN_A, "(port)result_EN_A");
    sc_trace(mVcdFile, result_WEN_A, "(port)result_WEN_A");
    sc_trace(mVcdFile, result_Din_A, "(port)result_Din_A");
    sc_trace(mVcdFile, result_Dout_A, "(port)result_Dout_A");
    sc_trace(mVcdFile, result_Clk_A, "(port)result_Clk_A");
    sc_trace(mVcdFile, result_Rst_A, "(port)result_Rst_A");
#endif
#ifdef __HLS_TRACE_LEVEL_INT__
    sc_trace(mVcdFile, grp_fu_149_p2, "grp_fu_149_p2");
    sc_trace(mVcdFile, reg_154, "reg_154");
    sc_trace(mVcdFile, ap_CS_fsm, "ap_CS_fsm");
    sc_trace(mVcdFile, tmp_fu_158_p2, "tmp_fu_158_p2");
    sc_trace(mVcdFile, tmp_2_fu_163_p2, "tmp_2_fu_163_p2");
    sc_trace(mVcdFile, op_reg_228, "op_reg_228");
    sc_trace(mVcdFile, end_reg_234, "end_reg_234");
    sc_trace(mVcdFile, tmp_reg_247, "tmp_reg_247");
    sc_trace(mVcdFile, tmp_2_reg_251, "tmp_2_reg_251");
    sc_trace(mVcdFile, tmp_s_fu_173_p1, "tmp_s_fu_173_p1");
    sc_trace(mVcdFile, tmp_s_reg_258, "tmp_s_reg_258");
    sc_trace(mVcdFile, tmp_8_fu_168_p2, "tmp_8_fu_168_p2");
    sc_trace(mVcdFile, tmp_10_fu_179_p2, "tmp_10_fu_179_p2");
    sc_trace(mVcdFile, tmp_10_reg_273, "tmp_10_reg_273");
    sc_trace(mVcdFile, tmp_5_fu_190_p1, "tmp_5_fu_190_p1");
    sc_trace(mVcdFile, tmp_5_reg_280, "tmp_5_reg_280");
    sc_trace(mVcdFile, tmp_3_fu_185_p2, "tmp_3_fu_185_p2");
    sc_trace(mVcdFile, tmp_7_fu_196_p2, "tmp_7_fu_196_p2");
    sc_trace(mVcdFile, tmp_7_reg_295, "tmp_7_reg_295");
    sc_trace(mVcdFile, i_3_fu_209_p2, "i_3_fu_209_p2");
    sc_trace(mVcdFile, ap_sig_ioackin_resp_TREADY, "ap_sig_ioackin_resp_TREADY");
    sc_trace(mVcdFile, i_2_fu_222_p2, "i_2_fu_222_p2");
    sc_trace(mVcdFile, i_1_reg_128, "i_1_reg_128");
    sc_trace(mVcdFile, i_reg_138, "i_reg_138");
    sc_trace(mVcdFile, ap_reg_ioackin_resp_TREADY, "ap_reg_ioackin_resp_TREADY");
    sc_trace(mVcdFile, b_Addr_A_orig, "b_Addr_A_orig");
    sc_trace(mVcdFile, a_Addr_A_orig, "a_Addr_A_orig");
    sc_trace(mVcdFile, tmp_9_fu_202_p2, "tmp_9_fu_202_p2");
    sc_trace(mVcdFile, tmp_6_fu_215_p2, "tmp_6_fu_215_p2");
    sc_trace(mVcdFile, result_Addr_A_orig, "result_Addr_A_orig");
    sc_trace(mVcdFile, ap_NS_fsm, "ap_NS_fsm");
    sc_trace(mVcdFile, ap_sig_bdd_86, "ap_sig_bdd_86");
    sc_trace(mVcdFile, ap_sig_bdd_100, "ap_sig_bdd_100");
#endif

    }
    mHdltvinHandle.open("acc_vadd_hls.hdltvin.dat");
    mHdltvoutHandle.open("acc_vadd_hls.hdltvout.dat");
}

acc_vadd_hls::~acc_vadd_hls() {
    if (mVcdFile) 
        sc_close_vcd_trace_file(mVcdFile);

    mHdltvinHandle << "] " << endl;
    mHdltvoutHandle << "] " << endl;
    mHdltvinHandle.close();
    mHdltvoutHandle.close();
}

void acc_vadd_hls::thread_ap_clk_no_reset_() {
    if ( ap_rst_n.read() == ap_const_logic_0) {
        ap_CS_fsm = ap_ST_st1_fsm_0;
    } else {
        ap_CS_fsm = ap_NS_fsm.read();
    }
    if ( ap_rst_n.read() == ap_const_logic_0) {
        ap_reg_ioackin_resp_TREADY = ap_const_logic_0;
    } else {
        if (((esl_seteq<1,3,3>(ap_ST_st5_fsm_4, ap_CS_fsm.read()) && 
              !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_10_reg_273.read()) && 
              !(!esl_seteq<1,1,1>(ap_const_lv1_0, tmp_10_reg_273.read()) && esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read()))) || 
             (esl_seteq<1,3,3>(ap_ST_st6_fsm_5, ap_CS_fsm.read()) && 
              !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_7_reg_295.read()) && 
              !(esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_7_reg_295.read()))))) {
            ap_reg_ioackin_resp_TREADY = ap_const_logic_0;
        } else if (((esl_seteq<1,3,3>(ap_ST_st5_fsm_4, ap_CS_fsm.read()) && 
                     !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_10_reg_273.read()) && 
                     esl_seteq<1,1,1>(ap_const_logic_1, resp_TREADY.read())) || 
                    (esl_seteq<1,3,3>(ap_ST_st6_fsm_5, ap_CS_fsm.read()) && 
                     !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_7_reg_295.read()) && 
                     esl_seteq<1,1,1>(ap_const_logic_1, resp_TREADY.read())))) {
            ap_reg_ioackin_resp_TREADY = ap_const_logic_1;
        }
    }
    if ((esl_seteq<1,3,3>(ap_ST_st3_fsm_2, ap_CS_fsm.read()) && 
         !esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0) && 
         esl_seteq<1,1,1>(tmp_fu_158_p2.read(), ap_const_lv1_0) && 
         !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_2_fu_163_p2.read()))) {
        i_1_reg_128 = cmd_TDATA.read();
    } else if ((esl_seteq<1,3,3>(ap_ST_st5_fsm_4, ap_CS_fsm.read()) && 
                !(!esl_seteq<1,1,1>(ap_const_lv1_0, tmp_10_reg_273.read()) && esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read())))) {
        i_1_reg_128 = i_3_fu_209_p2.read();
    }
    if ((esl_seteq<1,3,3>(ap_ST_st3_fsm_2, ap_CS_fsm.read()) && 
         !esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0) && 
         !esl_seteq<1,1,1>(tmp_fu_158_p2.read(), ap_const_lv1_0))) {
        i_reg_138 = cmd_TDATA.read();
    } else if ((esl_seteq<1,3,3>(ap_ST_st6_fsm_5, ap_CS_fsm.read()) && 
                !(esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_7_reg_295.read())))) {
        i_reg_138 = i_2_fu_222_p2.read();
    }
    if ((!esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0) && esl_seteq<1,3,3>(ap_ST_st2_fsm_1, ap_CS_fsm.read()))) {
        end_reg_234 = cmd_TDATA.read();
    }
    if ((!esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0) && esl_seteq<1,3,3>(ap_ST_st1_fsm_0, ap_CS_fsm.read()))) {
        op_reg_228 = cmd_TDATA.read();
    }
    if (((esl_seteq<1,3,3>(ap_ST_st3_fsm_2, ap_CS_fsm.read()) && 
  !esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0) && 
  esl_seteq<1,1,1>(tmp_fu_158_p2.read(), ap_const_lv1_0) && 
  !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_2_fu_163_p2.read())) || (esl_seteq<1,3,3>(ap_ST_st3_fsm_2, ap_CS_fsm.read()) && 
  !esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0) && 
  !esl_seteq<1,1,1>(tmp_fu_158_p2.read(), ap_const_lv1_0)))) {
        reg_154 = grp_fu_149_p2.read();
    }
    if ((esl_seteq<1,3,3>(ap_ST_st4_fsm_3, ap_CS_fsm.read()) && esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_2_reg_251.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_8_fu_168_p2.read()))) {
        tmp_10_reg_273 = tmp_10_fu_179_p2.read();
        tmp_s_reg_258 = tmp_s_fu_173_p1.read();
    }
    if ((esl_seteq<1,3,3>(ap_ST_st3_fsm_2, ap_CS_fsm.read()) && !esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0) && esl_seteq<1,1,1>(tmp_fu_158_p2.read(), ap_const_lv1_0))) {
        tmp_2_reg_251 = tmp_2_fu_163_p2.read();
    }
    if ((esl_seteq<1,3,3>(ap_ST_st4_fsm_3, ap_CS_fsm.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_3_fu_185_p2.read()))) {
        tmp_5_reg_280 = tmp_5_fu_190_p1.read();
        tmp_7_reg_295 = tmp_7_fu_196_p2.read();
    }
    if ((esl_seteq<1,3,3>(ap_ST_st3_fsm_2, ap_CS_fsm.read()) && !esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0))) {
        tmp_reg_247 = tmp_fu_158_p2.read();
    }
}

void acc_vadd_hls::thread_a_Addr_A() {
    a_Addr_A = (!ap_const_lv32_2.is_01())? sc_lv<32>(): a_Addr_A_orig.read() << (unsigned short)ap_const_lv32_2.to_uint();
}

void acc_vadd_hls::thread_a_Addr_A_orig() {
    if (esl_seteq<1,3,3>(ap_ST_st4_fsm_3, ap_CS_fsm.read())) {
        if (ap_sig_bdd_100.read()) {
            a_Addr_A_orig =  (sc_lv<32>) (tmp_5_fu_190_p1.read());
        } else if (ap_sig_bdd_86.read()) {
            a_Addr_A_orig =  (sc_lv<32>) (tmp_s_fu_173_p1.read());
        } else {
            a_Addr_A_orig = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        }
    } else {
        a_Addr_A_orig = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    }
}

void acc_vadd_hls::thread_a_Clk_A() {
    a_Clk_A = ap_clk.read()? SC_LOGIC_1 : SC_LOGIC_0;
}

void acc_vadd_hls::thread_a_Din_A() {
    a_Din_A = ap_const_lv32_0;
}

void acc_vadd_hls::thread_a_EN_A() {
    if (((esl_seteq<1,3,3>(ap_ST_st4_fsm_3, ap_CS_fsm.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_2_reg_251.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_8_fu_168_p2.read())) || 
         (esl_seteq<1,3,3>(ap_ST_st4_fsm_3, ap_CS_fsm.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_3_fu_185_p2.read())))) {
        a_EN_A = ap_const_logic_1;
    } else {
        a_EN_A = ap_const_logic_0;
    }
}

void acc_vadd_hls::thread_a_Rst_A() {
    a_Rst_A = ap_rst_n.read();
}

void acc_vadd_hls::thread_a_WEN_A() {
    a_WEN_A = ap_const_lv4_0;
}

void acc_vadd_hls::thread_ap_sig_bdd_100() {
    ap_sig_bdd_100 = (!esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_3_fu_185_p2.read()));
}

void acc_vadd_hls::thread_ap_sig_bdd_86() {
    ap_sig_bdd_86 = (esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_2_reg_251.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_8_fu_168_p2.read()));
}

void acc_vadd_hls::thread_ap_sig_ioackin_resp_TREADY() {
    if (esl_seteq<1,1,1>(ap_const_logic_0, ap_reg_ioackin_resp_TREADY.read())) {
        ap_sig_ioackin_resp_TREADY = resp_TREADY.read();
    } else {
        ap_sig_ioackin_resp_TREADY = ap_const_logic_1;
    }
}

void acc_vadd_hls::thread_b_Addr_A() {
    b_Addr_A = (!ap_const_lv32_2.is_01())? sc_lv<32>(): b_Addr_A_orig.read() << (unsigned short)ap_const_lv32_2.to_uint();
}

void acc_vadd_hls::thread_b_Addr_A_orig() {
    if (esl_seteq<1,3,3>(ap_ST_st4_fsm_3, ap_CS_fsm.read())) {
        if (ap_sig_bdd_100.read()) {
            b_Addr_A_orig =  (sc_lv<32>) (tmp_5_fu_190_p1.read());
        } else if (ap_sig_bdd_86.read()) {
            b_Addr_A_orig =  (sc_lv<32>) (tmp_s_fu_173_p1.read());
        } else {
            b_Addr_A_orig = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        }
    } else {
        b_Addr_A_orig = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    }
}

void acc_vadd_hls::thread_b_Clk_A() {
    b_Clk_A = ap_clk.read()? SC_LOGIC_1 : SC_LOGIC_0;
}

void acc_vadd_hls::thread_b_Din_A() {
    b_Din_A = ap_const_lv32_0;
}

void acc_vadd_hls::thread_b_EN_A() {
    if (((esl_seteq<1,3,3>(ap_ST_st4_fsm_3, ap_CS_fsm.read()) && 
          esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_2_reg_251.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_8_fu_168_p2.read())) || 
         (esl_seteq<1,3,3>(ap_ST_st4_fsm_3, ap_CS_fsm.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_3_fu_185_p2.read())))) {
        b_EN_A = ap_const_logic_1;
    } else {
        b_EN_A = ap_const_logic_0;
    }
}

void acc_vadd_hls::thread_b_Rst_A() {
    b_Rst_A = ap_rst_n.read();
}

void acc_vadd_hls::thread_b_WEN_A() {
    b_WEN_A = ap_const_lv4_0;
}

void acc_vadd_hls::thread_cmd_TREADY() {
    if (((esl_seteq<1,3,3>(ap_ST_st3_fsm_2, ap_CS_fsm.read()) && 
          !esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0)) || 
         (!esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0) && 
          esl_seteq<1,3,3>(ap_ST_st1_fsm_0, ap_CS_fsm.read())) || 
         (!esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0) && 
          esl_seteq<1,3,3>(ap_ST_st2_fsm_1, ap_CS_fsm.read())))) {
        cmd_TREADY = ap_const_logic_1;
    } else {
        cmd_TREADY = ap_const_logic_0;
    }
}

void acc_vadd_hls::thread_grp_fu_149_p2() {
    grp_fu_149_p2 = (!end_reg_234.read().is_01() || !ap_const_lv32_FFFFFFFF.is_01())? sc_lv<32>(): (sc_bigint<32>(end_reg_234.read()) + sc_biguint<32>(ap_const_lv32_FFFFFFFF));
}

void acc_vadd_hls::thread_i_2_fu_222_p2() {
    i_2_fu_222_p2 = (!i_reg_138.read().is_01() || !ap_const_lv32_1.is_01())? sc_lv<32>(): (sc_bigint<32>(i_reg_138.read()) + sc_biguint<32>(ap_const_lv32_1));
}

void acc_vadd_hls::thread_i_3_fu_209_p2() {
    i_3_fu_209_p2 = (!i_1_reg_128.read().is_01() || !ap_const_lv32_1.is_01())? sc_lv<32>(): (sc_bigint<32>(i_1_reg_128.read()) + sc_biguint<32>(ap_const_lv32_1));
}

void acc_vadd_hls::thread_resp_TDATA() {
    resp_TDATA = ap_const_lv32_1;
}

void acc_vadd_hls::thread_resp_TVALID() {
    if (((esl_seteq<1,3,3>(ap_ST_st5_fsm_4, ap_CS_fsm.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_10_reg_273.read()) && 
          esl_seteq<1,1,1>(ap_const_logic_0, ap_reg_ioackin_resp_TREADY.read())) || 
         (esl_seteq<1,3,3>(ap_ST_st6_fsm_5, ap_CS_fsm.read()) && 
          !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_7_reg_295.read()) && 
          esl_seteq<1,1,1>(ap_const_logic_0, ap_reg_ioackin_resp_TREADY.read())))) {
        resp_TVALID = ap_const_logic_1;
    } else {
        resp_TVALID = ap_const_logic_0;
    }
}

void acc_vadd_hls::thread_result_Addr_A() {
    result_Addr_A = (!ap_const_lv32_2.is_01())? sc_lv<32>(): result_Addr_A_orig.read() << (unsigned short)ap_const_lv32_2.to_uint();
}

void acc_vadd_hls::thread_result_Addr_A_orig() {
    if (esl_seteq<1,3,3>(ap_ST_st6_fsm_5, ap_CS_fsm.read())) {
        result_Addr_A_orig =  (sc_lv<32>) (tmp_5_reg_280.read());
    } else if (esl_seteq<1,3,3>(ap_ST_st5_fsm_4, ap_CS_fsm.read())) {
        result_Addr_A_orig =  (sc_lv<32>) (tmp_s_reg_258.read());
    } else {
        result_Addr_A_orig = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    }
}

void acc_vadd_hls::thread_result_Clk_A() {
    result_Clk_A = ap_clk.read()? SC_LOGIC_1 : SC_LOGIC_0;
}

void acc_vadd_hls::thread_result_Din_A() {
    if (esl_seteq<1,3,3>(ap_ST_st6_fsm_5, ap_CS_fsm.read())) {
        result_Din_A = tmp_6_fu_215_p2.read();
    } else if (esl_seteq<1,3,3>(ap_ST_st5_fsm_4, ap_CS_fsm.read())) {
        result_Din_A = tmp_9_fu_202_p2.read();
    } else {
        result_Din_A = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
    }
}

void acc_vadd_hls::thread_result_EN_A() {
    if (((esl_seteq<1,3,3>(ap_ST_st5_fsm_4, ap_CS_fsm.read()) && 
          !(!esl_seteq<1,1,1>(ap_const_lv1_0, tmp_10_reg_273.read()) && esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read()))) || 
         (esl_seteq<1,3,3>(ap_ST_st6_fsm_5, ap_CS_fsm.read()) && 
          !(esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_7_reg_295.read()))))) {
        result_EN_A = ap_const_logic_1;
    } else {
        result_EN_A = ap_const_logic_0;
    }
}

void acc_vadd_hls::thread_result_Rst_A() {
    result_Rst_A = ap_rst_n.read();
}

void acc_vadd_hls::thread_result_WEN_A() {
    if (((esl_seteq<1,3,3>(ap_ST_st5_fsm_4, ap_CS_fsm.read()) && 
          !(!esl_seteq<1,1,1>(ap_const_lv1_0, tmp_10_reg_273.read()) && esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read()))) || 
         (esl_seteq<1,3,3>(ap_ST_st6_fsm_5, ap_CS_fsm.read()) && 
          !(esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_7_reg_295.read()))))) {
        result_WEN_A = ap_const_lv4_F;
    } else {
        result_WEN_A = ap_const_lv4_0;
    }
}

void acc_vadd_hls::thread_tmp_10_fu_179_p2() {
    tmp_10_fu_179_p2 = (!i_1_reg_128.read().is_01() || !reg_154.read().is_01())? sc_lv<1>(): sc_lv<1>(i_1_reg_128.read() == reg_154.read());
}

void acc_vadd_hls::thread_tmp_2_fu_163_p2() {
    tmp_2_fu_163_p2 = (!op_reg_228.read().is_01() || !ap_const_lv32_2.is_01())? sc_lv<1>(): sc_lv<1>(op_reg_228.read() == ap_const_lv32_2);
}

void acc_vadd_hls::thread_tmp_3_fu_185_p2() {
    tmp_3_fu_185_p2 = (!i_reg_138.read().is_01() || !end_reg_234.read().is_01())? sc_lv<1>(): (sc_bigint<32>(i_reg_138.read()) < sc_bigint<32>(end_reg_234.read()));
}

void acc_vadd_hls::thread_tmp_5_fu_190_p1() {
    tmp_5_fu_190_p1 = esl_sext<64,32>(i_reg_138.read());
}

void acc_vadd_hls::thread_tmp_6_fu_215_p2() {
    tmp_6_fu_215_p2 = (!b_Dout_A.read().is_01() || !a_Dout_A.read().is_01())? sc_lv<32>(): (sc_bigint<32>(b_Dout_A.read()) + sc_biguint<32>(a_Dout_A.read()));
}

void acc_vadd_hls::thread_tmp_7_fu_196_p2() {
    tmp_7_fu_196_p2 = (!i_reg_138.read().is_01() || !reg_154.read().is_01())? sc_lv<1>(): sc_lv<1>(i_reg_138.read() == reg_154.read());
}

void acc_vadd_hls::thread_tmp_8_fu_168_p2() {
    tmp_8_fu_168_p2 = (!i_1_reg_128.read().is_01() || !end_reg_234.read().is_01())? sc_lv<1>(): (sc_bigint<32>(i_1_reg_128.read()) < sc_bigint<32>(end_reg_234.read()));
}

void acc_vadd_hls::thread_tmp_9_fu_202_p2() {
    tmp_9_fu_202_p2 = (!a_Dout_A.read().is_01() || !b_Dout_A.read().is_01())? sc_lv<32>(): (sc_bigint<32>(a_Dout_A.read()) + sc_biguint<32>(b_Dout_A.read()));
}

void acc_vadd_hls::thread_tmp_fu_158_p2() {
    tmp_fu_158_p2 = (!op_reg_228.read().is_01() || !ap_const_lv32_1.is_01())? sc_lv<1>(): sc_lv<1>(op_reg_228.read() == ap_const_lv32_1);
}

void acc_vadd_hls::thread_tmp_s_fu_173_p1() {
    tmp_s_fu_173_p1 = esl_sext<64,32>(i_1_reg_128.read());
}

void acc_vadd_hls::thread_ap_NS_fsm() {
    switch (ap_CS_fsm.read().to_uint64()) {
        case 0 : 
            if (!esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0)) {
                ap_NS_fsm = ap_ST_st2_fsm_1;
            } else {
                ap_NS_fsm = ap_ST_st1_fsm_0;
            }
            break;
        case 1 : 
            if (!esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0)) {
                ap_NS_fsm = ap_ST_st3_fsm_2;
            } else {
                ap_NS_fsm = ap_ST_st2_fsm_1;
            }
            break;
        case 2 : 
            if (!esl_seteq<1,1,1>(cmd_TVALID.read(), ap_const_logic_0)) {
                ap_NS_fsm = ap_ST_st4_fsm_3;
            } else {
                ap_NS_fsm = ap_ST_st3_fsm_2;
            }
            break;
        case 3 : 
            if (((esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && 
  esl_seteq<1,1,1>(ap_const_lv1_0, tmp_2_reg_251.read())) || (!esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && 
  esl_seteq<1,1,1>(ap_const_lv1_0, tmp_3_fu_185_p2.read())) || (esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && 
  esl_seteq<1,1,1>(ap_const_lv1_0, tmp_8_fu_168_p2.read())))) {
                ap_NS_fsm = ap_ST_st1_fsm_0;
            } else if ((!esl_seteq<1,1,1>(ap_const_lv1_0, tmp_reg_247.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_3_fu_185_p2.read()))) {
                ap_NS_fsm = ap_ST_st6_fsm_5;
            } else {
                ap_NS_fsm = ap_ST_st5_fsm_4;
            }
            break;
        case 4 : 
            if (!(!esl_seteq<1,1,1>(ap_const_lv1_0, tmp_10_reg_273.read()) && esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read()))) {
                ap_NS_fsm = ap_ST_st4_fsm_3;
            } else {
                ap_NS_fsm = ap_ST_st5_fsm_4;
            }
            break;
        case 5 : 
            if (!(esl_seteq<1,1,1>(ap_const_logic_0, ap_sig_ioackin_resp_TREADY.read()) && !esl_seteq<1,1,1>(ap_const_lv1_0, tmp_7_reg_295.read()))) {
                ap_NS_fsm = ap_ST_st4_fsm_3;
            } else {
                ap_NS_fsm = ap_ST_st6_fsm_5;
            }
            break;
        default : 
            ap_NS_fsm =  (sc_lv<3>) ("XXX");
            break;
    }
}

void acc_vadd_hls::thread_hdltv_gen() {
    const char* dump_tv = std::getenv("AP_WRITE_TV");
    if (!(dump_tv && string(dump_tv) == "on")) return;

    wait();

    mHdltvinHandle << "[ " << endl;
    mHdltvoutHandle << "[ " << endl;
    int ap_cycleNo = 0;
    while (1) {
        wait();
        const char* mComma = ap_cycleNo == 0 ? " " : ", " ;
        mHdltvinHandle << mComma << "{"  <<  " \"ap_rst_n\" :  \"" << ap_rst_n.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"cmd_TDATA\" :  \"" << cmd_TDATA.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"cmd_TVALID\" :  \"" << cmd_TVALID.read() << "\" ";
        mHdltvoutHandle << mComma << "{"  <<  " \"cmd_TREADY\" :  \"" << cmd_TREADY.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"resp_TDATA\" :  \"" << resp_TDATA.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"resp_TVALID\" :  \"" << resp_TVALID.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"resp_TREADY\" :  \"" << resp_TREADY.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"a_Addr_A\" :  \"" << a_Addr_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"a_EN_A\" :  \"" << a_EN_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"a_WEN_A\" :  \"" << a_WEN_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"a_Din_A\" :  \"" << a_Din_A.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"a_Dout_A\" :  \"" << a_Dout_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"a_Clk_A\" :  \"" << a_Clk_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"a_Rst_A\" :  \"" << a_Rst_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"b_Addr_A\" :  \"" << b_Addr_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"b_EN_A\" :  \"" << b_EN_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"b_WEN_A\" :  \"" << b_WEN_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"b_Din_A\" :  \"" << b_Din_A.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"b_Dout_A\" :  \"" << b_Dout_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"b_Clk_A\" :  \"" << b_Clk_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"b_Rst_A\" :  \"" << b_Rst_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"result_Addr_A\" :  \"" << result_Addr_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"result_EN_A\" :  \"" << result_EN_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"result_WEN_A\" :  \"" << result_WEN_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"result_Din_A\" :  \"" << result_Din_A.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"result_Dout_A\" :  \"" << result_Dout_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"result_Clk_A\" :  \"" << result_Clk_A.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"result_Rst_A\" :  \"" << result_Rst_A.read() << "\" ";
        mHdltvinHandle << "}" << std::endl;
        mHdltvoutHandle << "}" << std::endl;
        ap_cycleNo++;
    }
}

}

