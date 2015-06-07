`timescale 1 ns / 1 ps

module sfa_2x2(
  input   wire            u_switch_00_macc1_tready,
  output  wire            u_switch_00_macc1_tvalid,
  output  wire  [31 : 0]  u_switch_00_macc1_tdata ,
  input   wire            u_switch_00_macc2_tready,
  output  wire            u_switch_00_macc2_tvalid,
  output  wire  [31 : 0]  u_switch_00_macc2_tdata ,
  output  wire            u_switch_00_sacc_tready ,
  input   wire            u_switch_00_sacc_tvalid ,
  input   wire  [31 : 0]  u_switch_00_sacc_tdata  ,
  output  wire            u_switch_00_sCMD_tready ,
  input   wire            u_switch_00_sCMD_tvalid ,
  input   wire  [31 : 0]  u_switch_00_sCMD_tdata  ,
  input   wire            u_switch_00_mRet_tready ,
  output  wire            u_switch_00_mRet_tvalid ,
  output  wire  [31 : 0]  u_switch_00_mRet_tdata  ,
  input   wire            u_switch_01_macc1_tready,
  output  wire            u_switch_01_macc1_tvalid,
  output  wire  [31 : 0]  u_switch_01_macc1_tdata ,
  input   wire            u_switch_01_macc2_tready,
  output  wire            u_switch_01_macc2_tvalid,
  output  wire  [31 : 0]  u_switch_01_macc2_tdata ,
  output  wire            u_switch_01_sacc_tready ,
  input   wire            u_switch_01_sacc_tvalid ,
  input   wire  [31 : 0]  u_switch_01_sacc_tdata  ,
  output  wire            u_switch_01_sCMD_tready ,
  input   wire            u_switch_01_sCMD_tvalid ,
  input   wire  [31 : 0]  u_switch_01_sCMD_tdata  ,
  input   wire            u_switch_01_mRet_tready ,
  output  wire            u_switch_01_mRet_tvalid ,
  output  wire  [31 : 0]  u_switch_01_mRet_tdata  ,
  input   wire            u_switch_10_macc1_tready,
  output  wire            u_switch_10_macc1_tvalid,
  output  wire  [31 : 0]  u_switch_10_macc1_tdata ,
  input   wire            u_switch_10_macc2_tready,
  output  wire            u_switch_10_macc2_tvalid,
  output  wire  [31 : 0]  u_switch_10_macc2_tdata ,
  output  wire            u_switch_10_sacc_tready ,
  input   wire            u_switch_10_sacc_tvalid ,
  input   wire  [31 : 0]  u_switch_10_sacc_tdata  ,
  output  wire            u_switch_10_sCMD_tready ,
  input   wire            u_switch_10_sCMD_tvalid ,
  input   wire  [31 : 0]  u_switch_10_sCMD_tdata  ,
  input   wire            u_switch_10_mRet_tready ,
  output  wire            u_switch_10_mRet_tvalid ,
  output  wire  [31 : 0]  u_switch_10_mRet_tdata  ,
  input   wire            u_switch_11_macc1_tready,
  output  wire            u_switch_11_macc1_tvalid,
  output  wire  [31 : 0]  u_switch_11_macc1_tdata ,
  input   wire            u_switch_11_macc2_tready,
  output  wire            u_switch_11_macc2_tvalid,
  output  wire  [31 : 0]  u_switch_11_macc2_tdata ,
  output  wire            u_switch_11_sacc_tready ,
  input   wire            u_switch_11_sacc_tvalid ,
  input   wire  [31 : 0]  u_switch_11_sacc_tdata  ,
  output  wire            u_switch_11_sCMD_tready ,
  input   wire            u_switch_11_sCMD_tvalid ,
  input   wire  [31 : 0]  u_switch_11_sCMD_tdata  ,
  input   wire            u_switch_11_mRet_tready ,
  output  wire            u_switch_11_mRet_tvalid ,
  output  wire  [31 : 0]  u_switch_11_mRet_tdata  ,
  output  wire            u_bif_00_1_bram_clk    ,
  output  wire            u_bif_00_1_bram_rst    ,
  output  wire            u_bif_00_1_bram_en     ,
  output  wire  [ 3 : 0]  u_bif_00_1_bram_we     ,
  output  wire  [31 : 0]  u_bif_00_1_bram_addr   ,
  output  wire  [31 : 0]  u_bif_00_1_bram_din    ,
  input   wire  [31 : 0]  u_bif_00_1_bram_dout   ,
  output  wire            u_bif_00_2_bram_clk    ,
  output  wire            u_bif_00_2_bram_rst    ,
  output  wire            u_bif_00_2_bram_en     ,
  output  wire  [ 3 : 0]  u_bif_00_2_bram_we     ,
  output  wire  [31 : 0]  u_bif_00_2_bram_addr   ,
  output  wire  [31 : 0]  u_bif_00_2_bram_din    ,
  input   wire  [31 : 0]  u_bif_00_2_bram_dout   ,
  output  wire            u_bif_01_1_bram_clk    ,
  output  wire            u_bif_01_1_bram_rst    ,
  output  wire            u_bif_01_1_bram_en     ,
  output  wire  [ 3 : 0]  u_bif_01_1_bram_we     ,
  output  wire  [31 : 0]  u_bif_01_1_bram_addr   ,
  output  wire  [31 : 0]  u_bif_01_1_bram_din    ,
  input   wire  [31 : 0]  u_bif_01_1_bram_dout   ,
  output  wire            u_bif_01_2_bram_clk    ,
  output  wire            u_bif_01_2_bram_rst    ,
  output  wire            u_bif_01_2_bram_en     ,
  output  wire  [ 3 : 0]  u_bif_01_2_bram_we     ,
  output  wire  [31 : 0]  u_bif_01_2_bram_addr   ,
  output  wire  [31 : 0]  u_bif_01_2_bram_din    ,
  input   wire  [31 : 0]  u_bif_01_2_bram_dout   ,
  output  wire            u_bif_10_1_bram_clk    ,
  output  wire            u_bif_10_1_bram_rst    ,
  output  wire            u_bif_10_1_bram_en     ,
  output  wire  [ 3 : 0]  u_bif_10_1_bram_we     ,
  output  wire  [31 : 0]  u_bif_10_1_bram_addr   ,
  output  wire  [31 : 0]  u_bif_10_1_bram_din    ,
  input   wire  [31 : 0]  u_bif_10_1_bram_dout   ,
  output  wire            u_bif_10_2_bram_clk    ,
  output  wire            u_bif_10_2_bram_rst    ,
  output  wire            u_bif_10_2_bram_en     ,
  output  wire  [ 3 : 0]  u_bif_10_2_bram_we     ,
  output  wire  [31 : 0]  u_bif_10_2_bram_addr   ,
  output  wire  [31 : 0]  u_bif_10_2_bram_din    ,
  input   wire  [31 : 0]  u_bif_10_2_bram_dout   ,
  output  wire            u_bif_11_1_bram_clk    ,
  output  wire            u_bif_11_1_bram_rst    ,
  output  wire            u_bif_11_1_bram_en     ,
  output  wire  [ 3 : 0]  u_bif_11_1_bram_we     ,
  output  wire  [31 : 0]  u_bif_11_1_bram_addr   ,
  output  wire  [31 : 0]  u_bif_11_1_bram_din    ,
  input   wire  [31 : 0]  u_bif_11_1_bram_dout   ,
  output  wire            u_bif_11_2_bram_clk    ,
  output  wire            u_bif_11_2_bram_rst    ,
  output  wire            u_bif_11_2_bram_en     ,
  output  wire  [ 3 : 0]  u_bif_11_2_bram_we     ,
  output  wire  [31 : 0]  u_bif_11_2_bram_addr   ,
  output  wire  [31 : 0]  u_bif_11_2_bram_din    ,
  input   wire  [31 : 0]  u_bif_11_2_bram_dout   ,
  input   wire            ACLK,
  input   wire            ARESETN
);

  wire            mn_u_bif_00_1_tready;
  wire            mn_u_bif_00_1_tvalid;
  wire  [31 : 0]  mn_u_bif_00_1_tdata;
  wire            me_00_sw_01_tready;
  wire            me_00_sw_01_tvalid;
  wire  [31 : 0]  me_00_sw_01_tdata;
  wire            ms_00_sn_10_tready;
  wire            ms_00_sn_10_tvalid;
  wire  [31 : 0]  ms_00_sn_10_tdata;
  wire            mw_u_bif_00_2_tready;
  wire            mw_u_bif_00_2_tvalid;
  wire  [31 : 0]  mw_u_bif_00_2_tdata;
  wire            BC1_u_bif_00_1_ap_start;
  wire            BC1_u_bif_00_1_ap_done ;
  wire            BC1_u_bif_00_1_ap_idle ;
  wire            BC1_u_bif_00_1_ap_ready;
  wire            BC1_u_bif_00_1_MODE    ;
  wire  [23 : 0]  BC1_u_bif_00_1_INDEX   ;
  wire  [23 : 0]  BC1_u_bif_00_1_SIZE    ;
  wire  [23 : 0]  BC1_u_bif_00_1_STRIDE  ;
  wire            BC2_u_bif_00_2_ap_start;
  wire            BC2_u_bif_00_2_ap_done ;
  wire            BC2_u_bif_00_2_ap_idle ;
  wire            BC2_u_bif_00_2_ap_ready;
  wire            BC2_u_bif_00_2_MODE    ;
  wire  [23 : 0]  BC2_u_bif_00_2_INDEX   ;
  wire  [23 : 0]  BC2_u_bif_00_2_SIZE    ;
  wire  [23 : 0]  BC2_u_bif_00_2_STRIDE  ;

  wire            mn_u_bif_01_1_tready;
  wire            mn_u_bif_01_1_tvalid;
  wire  [31 : 0]  mn_u_bif_01_1_tdata;
  wire            me_u_bif_01_2_tready;
  wire            me_u_bif_01_2_tvalid;
  wire  [31 : 0]  me_u_bif_01_2_tdata;
  wire            ms_01_sn_11_tready;
  wire            ms_01_sn_11_tvalid;
  wire  [31 : 0]  ms_01_sn_11_tdata;
  wire            mw_01_se_00_tready;
  wire            mw_01_se_00_tvalid;
  wire  [31 : 0]  mw_01_se_00_tdata;
  wire            BC1_u_bif_01_1_ap_start;
  wire            BC1_u_bif_01_1_ap_done ;
  wire            BC1_u_bif_01_1_ap_idle ;
  wire            BC1_u_bif_01_1_ap_ready;
  wire            BC1_u_bif_01_1_MODE    ;
  wire  [23 : 0]  BC1_u_bif_01_1_INDEX   ;
  wire  [23 : 0]  BC1_u_bif_01_1_SIZE    ;
  wire  [23 : 0]  BC1_u_bif_01_1_STRIDE  ;
  wire            BC2_u_bif_01_2_ap_start;
  wire            BC2_u_bif_01_2_ap_done ;
  wire            BC2_u_bif_01_2_ap_idle ;
  wire            BC2_u_bif_01_2_ap_ready;
  wire            BC2_u_bif_01_2_MODE    ;
  wire  [23 : 0]  BC2_u_bif_01_2_INDEX   ;
  wire  [23 : 0]  BC2_u_bif_01_2_SIZE    ;
  wire  [23 : 0]  BC2_u_bif_01_2_STRIDE  ;

  wire            mn_10_ss_00_tready;
  wire            mn_10_ss_00_tvalid;
  wire  [31 : 0]  mn_10_ss_00_tdata;
  wire            me_10_sw_11_tready;
  wire            me_10_sw_11_tvalid;
  wire  [31 : 0]  me_10_sw_11_tdata;
  wire            ms_u_bif_10_1_tready;
  wire            ms_u_bif_10_1_tvalid;
  wire  [31 : 0]  ms_u_bif_10_1_tdata;
  wire            mw_u_bif_10_2_tready;
  wire            mw_u_bif_10_2_tvalid;
  wire  [31 : 0]  mw_u_bif_10_2_tdata;
  wire            BC1_u_bif_10_1_ap_start;
  wire            BC1_u_bif_10_1_ap_done ;
  wire            BC1_u_bif_10_1_ap_idle ;
  wire            BC1_u_bif_10_1_ap_ready;
  wire            BC1_u_bif_10_1_MODE    ;
  wire  [23 : 0]  BC1_u_bif_10_1_INDEX   ;
  wire  [23 : 0]  BC1_u_bif_10_1_SIZE    ;
  wire  [23 : 0]  BC1_u_bif_10_1_STRIDE  ;
  wire            BC2_u_bif_10_2_ap_start;
  wire            BC2_u_bif_10_2_ap_done ;
  wire            BC2_u_bif_10_2_ap_idle ;
  wire            BC2_u_bif_10_2_ap_ready;
  wire            BC2_u_bif_10_2_MODE    ;
  wire  [23 : 0]  BC2_u_bif_10_2_INDEX   ;
  wire  [23 : 0]  BC2_u_bif_10_2_SIZE    ;
  wire  [23 : 0]  BC2_u_bif_10_2_STRIDE  ;

  wire            mn_11_ss_01_tready;
  wire            mn_11_ss_01_tvalid;
  wire  [31 : 0]  mn_11_ss_01_tdata;
  wire            me_u_bif_11_2_tready;
  wire            me_u_bif_11_2_tvalid;
  wire  [31 : 0]  me_u_bif_11_2_tdata;
  wire            ms_u_bif_11_1_tready;
  wire            ms_u_bif_11_1_tvalid;
  wire  [31 : 0]  ms_u_bif_11_1_tdata;
  wire            mw_11_se_10_tready;
  wire            mw_11_se_10_tvalid;
  wire  [31 : 0]  mw_11_se_10_tdata;
  wire            BC1_u_bif_11_1_ap_start;
  wire            BC1_u_bif_11_1_ap_done ;
  wire            BC1_u_bif_11_1_ap_idle ;
  wire            BC1_u_bif_11_1_ap_ready;
  wire            BC1_u_bif_11_1_MODE    ;
  wire  [23 : 0]  BC1_u_bif_11_1_INDEX   ;
  wire  [23 : 0]  BC1_u_bif_11_1_SIZE    ;
  wire  [23 : 0]  BC1_u_bif_11_1_STRIDE  ;
  wire            BC2_u_bif_11_2_ap_start;
  wire            BC2_u_bif_11_2_ap_done ;
  wire            BC2_u_bif_11_2_ap_idle ;
  wire            BC2_u_bif_11_2_ap_ready;
  wire            BC2_u_bif_11_2_MODE    ;
  wire  [23 : 0]  BC2_u_bif_11_2_INDEX   ;
  wire  [23 : 0]  BC2_u_bif_11_2_SIZE    ;
  wire  [23 : 0]  BC2_u_bif_11_2_STRIDE  ;

  wire            sn_u_bif_00_1_tready     ;
  wire            sn_u_bif_00_1_tvalid     ;
  wire  [31 : 0]  sn_u_bif_00_1_tdata      ;

  wire            sw_u_bif_00_2_tready     ;
  wire            sw_u_bif_00_2_tvalid     ;
  wire  [31 : 0]  sw_u_bif_00_2_tdata      ;

  wire            sn_u_bif_01_1_tready     ;
  wire            sn_u_bif_01_1_tvalid     ;
  wire  [31 : 0]  sn_u_bif_01_1_tdata      ;

  wire            se_u_bif_01_2_tready     ;
  wire            se_u_bif_01_2_tvalid     ;
  wire  [31 : 0]  se_u_bif_01_2_tdata      ;

  wire            ss_u_bif_10_1_tready     ;
  wire            ss_u_bif_10_1_tvalid     ;
  wire  [31 : 0]  ss_u_bif_10_1_tdata      ;

  wire            sw_u_bif_10_2_tready     ;
  wire            sw_u_bif_10_2_tvalid     ;
  wire  [31 : 0]  sw_u_bif_10_2_tdata      ;

  wire            ss_u_bif_11_1_tready     ;
  wire            ss_u_bif_11_1_tvalid     ;
  wire  [31 : 0]  ss_u_bif_11_1_tdata      ;

  wire            se_u_bif_11_2_tready     ;
  wire            se_u_bif_11_2_tvalid     ;
  wire  [31 : 0]  se_u_bif_11_2_tdata      ;

sfa_switch u_switch_00(
  .sn_tready     (sn_u_bif_00_1_tready),
  .sn_tvalid     (sn_u_bif_00_1_tvalid),
  .sn_tdata      (sn_u_bif_00_1_tdata),
  .mn_tready     (mn_u_bif_00_1_tready),
  .mn_tvalid     (mn_u_bif_00_1_tvalid),
  .mn_tdata      (mn_u_bif_00_1_tdata),
  .se_tready     (mw_01_se_00_tready),
  .se_tvalid     (mw_01_se_00_tvalid),
  .se_tdata      (mw_01_se_00_tdata),
  .me_tready     (me_00_sw_01_tready),
  .me_tvalid     (me_00_sw_01_tvalid),
  .me_tdata      (me_00_sw_01_tdata),
  .ss_tready     (mn_10_ss_00_tready),
  .ss_tvalid     (mn_10_ss_00_tvalid),
  .ss_tdata      (mn_10_ss_00_tdata),
  .ms_tready     (ms_00_sn_10_tready),
  .ms_tvalid     (ms_00_sn_10_tvalid),
  .ms_tdata      (ms_00_sn_10_tdata),
  .sw_tready     (sw_u_bif_00_2_tready),
  .sw_tvalid     (sw_u_bif_00_2_tvalid),
  .sw_tdata      (sw_u_bif_00_2_tdata),
  .mw_tready     (mw_u_bif_00_2_tready),
  .mw_tvalid     (mw_u_bif_00_2_tvalid),
  .mw_tdata      (mw_u_bif_00_2_tdata),
  .macc1_tready  (u_switch_00_macc1_tready),
  .macc1_tvalid  (u_switch_00_macc1_tvalid),
  .macc1_tdata   (u_switch_00_macc1_tdata ),
  .macc2_tready  (u_switch_00_macc2_tready),
  .macc2_tvalid  (u_switch_00_macc2_tvalid),
  .macc2_tdata   (u_switch_00_macc2_tdata),
  .sacc_tready   (u_switch_00_sacc_tready),
  .sacc_tvalid   (u_switch_00_sacc_tvalid),
  .sacc_tdata    (u_switch_00_sacc_tdata ),
  .sCMD_tready   (u_switch_00_sCMD_tready),
  .sCMD_tvalid   (u_switch_00_sCMD_tvalid),
  .sCMD_tdata    (u_switch_00_sCMD_tdata ),
  .mRet_tready   (u_switch_00_mRet_tready),
  .mRet_tvalid   (u_switch_00_mRet_tvalid),
  .mRet_tdata    (u_switch_00_mRet_tdata ),
  .BC1_ap_start  (BC1_u_bif_00_1_ap_start),
  .BC1_ap_done   (BC1_u_bif_00_1_ap_done ),
  .BC1_ap_idle   (BC1_u_bif_00_1_ap_idle ),
  .BC1_ap_ready  (BC1_u_bif_00_1_ap_ready),
  .BC1_MODE      (BC1_u_bif_00_1_MODE    ),
  .BC1_INDEX     (BC1_u_bif_00_1_INDEX   ),
  .BC1_SIZE      (BC1_u_bif_00_1_SIZE    ),
  .BC1_STRIDE    (BC1_u_bif_00_1_STRIDE  ),
  .BC2_ap_start  (BC2_u_bif_00_2_ap_start),
  .BC2_ap_done   (BC2_u_bif_00_2_ap_done ),
  .BC2_ap_idle   (BC2_u_bif_00_2_ap_idle ),
  .BC2_ap_ready  (BC2_u_bif_00_2_ap_ready),
  .BC2_MODE      (BC2_u_bif_00_2_MODE    ),
  .BC2_INDEX     (BC2_u_bif_00_2_INDEX   ),
  .BC2_SIZE      (BC2_u_bif_00_2_SIZE    ),
  .BC2_STRIDE    (BC2_u_bif_00_2_STRIDE  ),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_switch u_switch_01(
  .sn_tready     (sn_u_bif_01_1_tready),
  .sn_tvalid     (sn_u_bif_01_1_tvalid),
  .sn_tdata      (sn_u_bif_01_1_tdata),
  .mn_tready     (mn_u_bif_01_1_tready),
  .mn_tvalid     (mn_u_bif_01_1_tvalid),
  .mn_tdata      (mn_u_bif_01_1_tdata),
  .se_tready     (se_u_bif_01_2_tready),
  .se_tvalid     (se_u_bif_01_2_tvalid),
  .se_tdata      (se_u_bif_01_2_tdata),
  .me_tready     (me_u_bif_01_2_tready),
  .me_tvalid     (me_u_bif_01_2_tvalid),
  .me_tdata      (me_u_bif_01_2_tdata),
  .ss_tready     (mn_11_ss_01_tready),
  .ss_tvalid     (mn_11_ss_01_tvalid),
  .ss_tdata      (mn_11_ss_01_tdata),
  .ms_tready     (ms_01_sn_11_tready),
  .ms_tvalid     (ms_01_sn_11_tvalid),
  .ms_tdata      (ms_01_sn_11_tdata),
  .sw_tready     (me_00_sw_01_tready),
  .sw_tvalid     (me_00_sw_01_tvalid),
  .sw_tdata      (me_00_sw_01_tdata),
  .mw_tready     (mw_01_se_00_tready),
  .mw_tvalid     (mw_01_se_00_tvalid),
  .mw_tdata      (mw_01_se_00_tdata),
  .macc1_tready  (u_switch_01_macc1_tready),
  .macc1_tvalid  (u_switch_01_macc1_tvalid),
  .macc1_tdata   (u_switch_01_macc1_tdata ),
  .macc2_tready  (u_switch_01_macc2_tready),
  .macc2_tvalid  (u_switch_01_macc2_tvalid),
  .macc2_tdata   (u_switch_01_macc2_tdata),
  .sacc_tready   (u_switch_01_sacc_tready),
  .sacc_tvalid   (u_switch_01_sacc_tvalid),
  .sacc_tdata    (u_switch_01_sacc_tdata ),
  .sCMD_tready   (u_switch_01_sCMD_tready),
  .sCMD_tvalid   (u_switch_01_sCMD_tvalid),
  .sCMD_tdata    (u_switch_01_sCMD_tdata ),
  .mRet_tready   (u_switch_01_mRet_tready),
  .mRet_tvalid   (u_switch_01_mRet_tvalid),
  .mRet_tdata    (u_switch_01_mRet_tdata ),
  .BC1_ap_start  (BC1_u_bif_01_1_ap_start),
  .BC1_ap_done   (BC1_u_bif_01_1_ap_done ),
  .BC1_ap_idle   (BC1_u_bif_01_1_ap_idle ),
  .BC1_ap_ready  (BC1_u_bif_01_1_ap_ready),
  .BC1_MODE      (BC1_u_bif_01_1_MODE    ),
  .BC1_INDEX     (BC1_u_bif_01_1_INDEX   ),
  .BC1_SIZE      (BC1_u_bif_01_1_SIZE    ),
  .BC1_STRIDE    (BC1_u_bif_01_1_STRIDE  ),
  .BC2_ap_start  (BC2_u_bif_01_2_ap_start),
  .BC2_ap_done   (BC2_u_bif_01_2_ap_done ),
  .BC2_ap_idle   (BC2_u_bif_01_2_ap_idle ),
  .BC2_ap_ready  (BC2_u_bif_01_2_ap_ready),
  .BC2_MODE      (BC2_u_bif_01_2_MODE    ),
  .BC2_INDEX     (BC2_u_bif_01_2_INDEX   ),
  .BC2_SIZE      (BC2_u_bif_01_2_SIZE    ),
  .BC2_STRIDE    (BC2_u_bif_01_2_STRIDE  ),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_switch u_switch_10(
  .sn_tready     (ms_00_sn_10_tready),
  .sn_tvalid     (ms_00_sn_10_tvalid),
  .sn_tdata      (ms_00_sn_10_tdata),
  .mn_tready     (mn_10_ss_00_tready),
  .mn_tvalid     (mn_10_ss_00_tvalid),
  .mn_tdata      (mn_10_ss_00_tdata),
  .se_tready     (mw_11_se_10_tready),
  .se_tvalid     (mw_11_se_10_tvalid),
  .se_tdata      (mw_11_se_10_tdata),
  .me_tready     (me_10_sw_11_tready),
  .me_tvalid     (me_10_sw_11_tvalid),
  .me_tdata      (me_10_sw_11_tdata),
  .ss_tready     (ss_u_bif_10_1_tready),
  .ss_tvalid     (ss_u_bif_10_1_tvalid),
  .ss_tdata      (ss_u_bif_10_1_tdata),
  .ms_tready     (ms_u_bif_10_1_tready),
  .ms_tvalid     (ms_u_bif_10_1_tvalid),
  .ms_tdata      (ms_u_bif_10_1_tdata),
  .sw_tready     (sw_u_bif_10_2_tready),
  .sw_tvalid     (sw_u_bif_10_2_tvalid),
  .sw_tdata      (sw_u_bif_10_2_tdata),
  .mw_tready     (mw_u_bif_10_2_tready),
  .mw_tvalid     (mw_u_bif_10_2_tvalid),
  .mw_tdata      (mw_u_bif_10_2_tdata),
  .macc1_tready  (u_switch_10_macc1_tready),
  .macc1_tvalid  (u_switch_10_macc1_tvalid),
  .macc1_tdata   (u_switch_10_macc1_tdata ),
  .macc2_tready  (u_switch_10_macc2_tready),
  .macc2_tvalid  (u_switch_10_macc2_tvalid),
  .macc2_tdata   (u_switch_10_macc2_tdata),
  .sacc_tready   (u_switch_10_sacc_tready),
  .sacc_tvalid   (u_switch_10_sacc_tvalid),
  .sacc_tdata    (u_switch_10_sacc_tdata ),
  .sCMD_tready   (u_switch_10_sCMD_tready),
  .sCMD_tvalid   (u_switch_10_sCMD_tvalid),
  .sCMD_tdata    (u_switch_10_sCMD_tdata ),
  .mRet_tready   (u_switch_10_mRet_tready),
  .mRet_tvalid   (u_switch_10_mRet_tvalid),
  .mRet_tdata    (u_switch_10_mRet_tdata ),
  .BC1_ap_start  (BC1_u_bif_10_1_ap_start),
  .BC1_ap_done   (BC1_u_bif_10_1_ap_done ),
  .BC1_ap_idle   (BC1_u_bif_10_1_ap_idle ),
  .BC1_ap_ready  (BC1_u_bif_10_1_ap_ready),
  .BC1_MODE      (BC1_u_bif_10_1_MODE    ),
  .BC1_INDEX     (BC1_u_bif_10_1_INDEX   ),
  .BC1_SIZE      (BC1_u_bif_10_1_SIZE    ),
  .BC1_STRIDE    (BC1_u_bif_10_1_STRIDE  ),
  .BC2_ap_start  (BC2_u_bif_10_2_ap_start),
  .BC2_ap_done   (BC2_u_bif_10_2_ap_done ),
  .BC2_ap_idle   (BC2_u_bif_10_2_ap_idle ),
  .BC2_ap_ready  (BC2_u_bif_10_2_ap_ready),
  .BC2_MODE      (BC2_u_bif_10_2_MODE    ),
  .BC2_INDEX     (BC2_u_bif_10_2_INDEX   ),
  .BC2_SIZE      (BC2_u_bif_10_2_SIZE    ),
  .BC2_STRIDE    (BC2_u_bif_10_2_STRIDE  ),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_switch u_switch_11(
  .sn_tready     (ms_01_sn_11_tready),
  .sn_tvalid     (ms_01_sn_11_tvalid),
  .sn_tdata      (ms_01_sn_11_tdata),
  .mn_tready     (mn_11_ss_01_tready),
  .mn_tvalid     (mn_11_ss_01_tvalid),
  .mn_tdata      (mn_11_ss_01_tdata),
  .se_tready     (se_u_bif_11_2_tready),
  .se_tvalid     (se_u_bif_11_2_tvalid),
  .se_tdata      (se_u_bif_11_2_tdata),
  .me_tready     (me_u_bif_11_2_tready),
  .me_tvalid     (me_u_bif_11_2_tvalid),
  .me_tdata      (me_u_bif_11_2_tdata),
  .ss_tready     (ss_u_bif_11_1_tready),
  .ss_tvalid     (ss_u_bif_11_1_tvalid),
  .ss_tdata      (ss_u_bif_11_1_tdata),
  .ms_tready     (ms_u_bif_11_1_tready),
  .ms_tvalid     (ms_u_bif_11_1_tvalid),
  .ms_tdata      (ms_u_bif_11_1_tdata),
  .sw_tready     (me_10_sw_11_tready),
  .sw_tvalid     (me_10_sw_11_tvalid),
  .sw_tdata      (me_10_sw_11_tdata),
  .mw_tready     (mw_11_se_10_tready),
  .mw_tvalid     (mw_11_se_10_tvalid),
  .mw_tdata      (mw_11_se_10_tdata),
  .macc1_tready  (u_switch_11_macc1_tready),
  .macc1_tvalid  (u_switch_11_macc1_tvalid),
  .macc1_tdata   (u_switch_11_macc1_tdata ),
  .macc2_tready  (u_switch_11_macc2_tready),
  .macc2_tvalid  (u_switch_11_macc2_tvalid),
  .macc2_tdata   (u_switch_11_macc2_tdata),
  .sacc_tready   (u_switch_11_sacc_tready),
  .sacc_tvalid   (u_switch_11_sacc_tvalid),
  .sacc_tdata    (u_switch_11_sacc_tdata ),
  .sCMD_tready   (u_switch_11_sCMD_tready),
  .sCMD_tvalid   (u_switch_11_sCMD_tvalid),
  .sCMD_tdata    (u_switch_11_sCMD_tdata ),
  .mRet_tready   (u_switch_11_mRet_tready),
  .mRet_tvalid   (u_switch_11_mRet_tvalid),
  .mRet_tdata    (u_switch_11_mRet_tdata ),
  .BC1_ap_start  (BC1_u_bif_11_1_ap_start),
  .BC1_ap_done   (BC1_u_bif_11_1_ap_done ),
  .BC1_ap_idle   (BC1_u_bif_11_1_ap_idle ),
  .BC1_ap_ready  (BC1_u_bif_11_1_ap_ready),
  .BC1_MODE      (BC1_u_bif_11_1_MODE    ),
  .BC1_INDEX     (BC1_u_bif_11_1_INDEX   ),
  .BC1_SIZE      (BC1_u_bif_11_1_SIZE    ),
  .BC1_STRIDE    (BC1_u_bif_11_1_STRIDE  ),
  .BC2_ap_start  (BC2_u_bif_11_2_ap_start),
  .BC2_ap_done   (BC2_u_bif_11_2_ap_done ),
  .BC2_ap_idle   (BC2_u_bif_11_2_ap_idle ),
  .BC2_ap_ready  (BC2_u_bif_11_2_ap_ready),
  .BC2_MODE      (BC2_u_bif_11_2_MODE    ),
  .BC2_INDEX     (BC2_u_bif_11_2_INDEX   ),
  .BC2_SIZE      (BC2_u_bif_11_2_SIZE    ),
  .BC2_STRIDE    (BC2_u_bif_11_2_STRIDE  ),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_bif u_bif_00_1(
  .sBIF_tready   (mn_u_bif_00_1_tready),
  .sBIF_tvalid   (mn_u_bif_00_1_tvalid),
  .sBIF_tdata    (mn_u_bif_00_1_tdata ),
  .mBIF_tready   (sn_u_bif_00_1_tready),
  .mBIF_tvalid   (sn_u_bif_00_1_tvalid),
  .mBIF_tdata    (sn_u_bif_00_1_tdata ),
  .bram_clk      (u_bif_00_1_bram_clk ),
  .bram_rst      (u_bif_00_1_bram_rst ),
  .bram_en       (u_bif_00_1_bram_en  ),
  .bram_we       (u_bif_00_1_bram_we  ),
  .bram_addr     (u_bif_00_1_bram_addr),
  .bram_din      (u_bif_00_1_bram_din ),
  .bram_dout     (u_bif_00_1_bram_dout),
  .ap_start      (BC1_u_bif_00_1_ap_start),
  .ap_done       (BC1_u_bif_00_1_ap_done ),
  .ap_idle       (BC1_u_bif_00_1_ap_idle ),
  .MODE          (BC1_u_bif_00_1_MODE  ),
  .INDEX         (BC1_u_bif_00_1_INDEX ),
  .SIZE          (BC1_u_bif_00_1_SIZE  ),
  .STRIDE        (BC1_u_bif_00_1_STRIDE),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_bif u_bif_00_2(
  .sBIF_tready   (mw_u_bif_00_2_tready),
  .sBIF_tvalid   (mw_u_bif_00_2_tvalid),
  .sBIF_tdata    (mw_u_bif_00_2_tdata ),
  .mBIF_tready   (sw_u_bif_00_2_tready),
  .mBIF_tvalid   (sw_u_bif_00_2_tvalid),
  .mBIF_tdata    (sw_u_bif_00_2_tdata ),
  .bram_clk      (u_bif_00_2_bram_clk ),
  .bram_rst      (u_bif_00_2_bram_rst ),
  .bram_en       (u_bif_00_2_bram_en  ),
  .bram_we       (u_bif_00_2_bram_we  ),
  .bram_addr     (u_bif_00_2_bram_addr),
  .bram_din      (u_bif_00_2_bram_din ),
  .bram_dout     (u_bif_00_2_bram_dout),
  .ap_start      (BC2_u_bif_00_2_ap_start),
  .ap_done       (BC2_u_bif_00_2_ap_done ),
  .ap_idle       (BC2_u_bif_00_2_ap_idle ),
  .MODE          (BC2_u_bif_00_2_MODE  ),
  .INDEX         (BC2_u_bif_00_2_INDEX ),
  .SIZE          (BC2_u_bif_00_2_SIZE  ),
  .STRIDE        (BC2_u_bif_00_2_STRIDE),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_bif u_bif_01_1(
  .sBIF_tready   (mn_u_bif_01_1_tready),
  .sBIF_tvalid   (mn_u_bif_01_1_tvalid),
  .sBIF_tdata    (mn_u_bif_01_1_tdata ),
  .mBIF_tready   (sn_u_bif_01_1_tready),
  .mBIF_tvalid   (sn_u_bif_01_1_tvalid),
  .mBIF_tdata    (sn_u_bif_01_1_tdata ),
  .bram_clk      (u_bif_01_1_bram_clk ),
  .bram_rst      (u_bif_01_1_bram_rst ),
  .bram_en       (u_bif_01_1_bram_en  ),
  .bram_we       (u_bif_01_1_bram_we  ),
  .bram_addr     (u_bif_01_1_bram_addr),
  .bram_din      (u_bif_01_1_bram_din ),
  .bram_dout     (u_bif_01_1_bram_dout),
  .ap_start      (BC1_u_bif_01_1_ap_start),
  .ap_done       (BC1_u_bif_01_1_ap_done ),
  .ap_idle       (BC1_u_bif_01_1_ap_idle ),
  .MODE          (BC1_u_bif_01_1_MODE  ),
  .INDEX         (BC1_u_bif_01_1_INDEX ),
  .SIZE          (BC1_u_bif_01_1_SIZE  ),
  .STRIDE        (BC1_u_bif_01_1_STRIDE),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_bif u_bif_01_2(
  .sBIF_tready   (me_u_bif_01_2_tready),
  .sBIF_tvalid   (me_u_bif_01_2_tvalid),
  .sBIF_tdata    (me_u_bif_01_2_tdata ),
  .mBIF_tready   (se_u_bif_01_2_tready),
  .mBIF_tvalid   (se_u_bif_01_2_tvalid),
  .mBIF_tdata    (se_u_bif_01_2_tdata ),
  .bram_clk      (u_bif_01_2_bram_clk ),
  .bram_rst      (u_bif_01_2_bram_rst ),
  .bram_en       (u_bif_01_2_bram_en  ),
  .bram_we       (u_bif_01_2_bram_we  ),
  .bram_addr     (u_bif_01_2_bram_addr),
  .bram_din      (u_bif_01_2_bram_din ),
  .bram_dout     (u_bif_01_2_bram_dout),
  .ap_start      (BC2_u_bif_01_2_ap_start),
  .ap_done       (BC2_u_bif_01_2_ap_done ),
  .ap_idle       (BC2_u_bif_01_2_ap_idle ),
  .MODE          (BC2_u_bif_01_2_MODE  ),
  .INDEX         (BC2_u_bif_01_2_INDEX ),
  .SIZE          (BC2_u_bif_01_2_SIZE  ),
  .STRIDE        (BC2_u_bif_01_2_STRIDE),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_bif u_bif_10_1(
  .sBIF_tready   (ms_u_bif_10_1_tready),
  .sBIF_tvalid   (ms_u_bif_10_1_tvalid),
  .sBIF_tdata    (ms_u_bif_10_1_tdata ),
  .mBIF_tready   (ss_u_bif_10_1_tready),
  .mBIF_tvalid   (ss_u_bif_10_1_tvalid),
  .mBIF_tdata    (ss_u_bif_10_1_tdata ),
  .bram_clk      (u_bif_10_1_bram_clk ),
  .bram_rst      (u_bif_10_1_bram_rst ),
  .bram_en       (u_bif_10_1_bram_en  ),
  .bram_we       (u_bif_10_1_bram_we  ),
  .bram_addr     (u_bif_10_1_bram_addr),
  .bram_din      (u_bif_10_1_bram_din ),
  .bram_dout     (u_bif_10_1_bram_dout),
  .ap_start      (BC1_u_bif_10_1_ap_start),
  .ap_done       (BC1_u_bif_10_1_ap_done ),
  .ap_idle       (BC1_u_bif_10_1_ap_idle ),
  .MODE          (BC1_u_bif_10_1_MODE  ),
  .INDEX         (BC1_u_bif_10_1_INDEX ),
  .SIZE          (BC1_u_bif_10_1_SIZE  ),
  .STRIDE        (BC1_u_bif_10_1_STRIDE),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_bif u_bif_10_2(
  .sBIF_tready   (mw_u_bif_10_2_tready),
  .sBIF_tvalid   (mw_u_bif_10_2_tvalid),
  .sBIF_tdata    (mw_u_bif_10_2_tdata ),
  .mBIF_tready   (sw_u_bif_10_2_tready),
  .mBIF_tvalid   (sw_u_bif_10_2_tvalid),
  .mBIF_tdata    (sw_u_bif_10_2_tdata ),
  .bram_clk      (u_bif_10_2_bram_clk ),
  .bram_rst      (u_bif_10_2_bram_rst ),
  .bram_en       (u_bif_10_2_bram_en  ),
  .bram_we       (u_bif_10_2_bram_we  ),
  .bram_addr     (u_bif_10_2_bram_addr),
  .bram_din      (u_bif_10_2_bram_din ),
  .bram_dout     (u_bif_10_2_bram_dout),
  .ap_start      (BC2_u_bif_10_2_ap_start),
  .ap_done       (BC2_u_bif_10_2_ap_done ),
  .ap_idle       (BC2_u_bif_10_2_ap_idle ),
  .MODE          (BC2_u_bif_10_2_MODE  ),
  .INDEX         (BC2_u_bif_10_2_INDEX ),
  .SIZE          (BC2_u_bif_10_2_SIZE  ),
  .STRIDE        (BC2_u_bif_10_2_STRIDE),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_bif u_bif_11_1(
  .sBIF_tready   (ms_u_bif_11_1_tready),
  .sBIF_tvalid   (ms_u_bif_11_1_tvalid),
  .sBIF_tdata    (ms_u_bif_11_1_tdata ),
  .mBIF_tready   (ss_u_bif_11_1_tready),
  .mBIF_tvalid   (ss_u_bif_11_1_tvalid),
  .mBIF_tdata    (ss_u_bif_11_1_tdata ),
  .bram_clk      (u_bif_11_1_bram_clk ),
  .bram_rst      (u_bif_11_1_bram_rst ),
  .bram_en       (u_bif_11_1_bram_en  ),
  .bram_we       (u_bif_11_1_bram_we  ),
  .bram_addr     (u_bif_11_1_bram_addr),
  .bram_din      (u_bif_11_1_bram_din ),
  .bram_dout     (u_bif_11_1_bram_dout),
  .ap_start      (BC1_u_bif_11_1_ap_start),
  .ap_done       (BC1_u_bif_11_1_ap_done ),
  .ap_idle       (BC1_u_bif_11_1_ap_idle ),
  .MODE          (BC1_u_bif_11_1_MODE  ),
  .INDEX         (BC1_u_bif_11_1_INDEX ),
  .SIZE          (BC1_u_bif_11_1_SIZE  ),
  .STRIDE        (BC1_u_bif_11_1_STRIDE),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

sfa_bif u_bif_11_2(
  .sBIF_tready   (me_u_bif_11_2_tready),
  .sBIF_tvalid   (me_u_bif_11_2_tvalid),
  .sBIF_tdata    (me_u_bif_11_2_tdata ),
  .mBIF_tready   (se_u_bif_11_2_tready),
  .mBIF_tvalid   (se_u_bif_11_2_tvalid),
  .mBIF_tdata    (se_u_bif_11_2_tdata ),
  .bram_clk      (u_bif_11_2_bram_clk ),
  .bram_rst      (u_bif_11_2_bram_rst ),
  .bram_en       (u_bif_11_2_bram_en  ),
  .bram_we       (u_bif_11_2_bram_we  ),
  .bram_addr     (u_bif_11_2_bram_addr),
  .bram_din      (u_bif_11_2_bram_din ),
  .bram_dout     (u_bif_11_2_bram_dout),
  .ap_start      (BC2_u_bif_11_2_ap_start),
  .ap_done       (BC2_u_bif_11_2_ap_done ),
  .ap_idle       (BC2_u_bif_11_2_ap_idle ),
  .MODE          (BC2_u_bif_11_2_MODE  ),
  .INDEX         (BC2_u_bif_11_2_INDEX ),
  .SIZE          (BC2_u_bif_11_2_SIZE  ),
  .STRIDE        (BC2_u_bif_11_2_STRIDE),
  .ACLK          (ACLK),
  .ARESETN       (ARESETN)
);

endmodule
//	u_switch_00	BC1:N	u_bif_00_1	0xE0
//	u_switch_00	BC2:W	u_bif_00_2	0xE1
//	u_switch_01	BC1:N	u_bif_01_1	0xE2
//	u_switch_01	BC2:E	u_bif_01_2	0xE3
//	u_switch_10	BC1:S	u_bif_10_1	0xE4
//	u_switch_10	BC2:W	u_bif_10_2	0xE5
//	u_switch_11	BC1:S	u_bif_11_1	0xE6
//	u_switch_11	BC2:E	u_bif_11_2	0xE7
