`timescale 1 ns / 1 ps

module sfa_interconnect(
  // Inputs
  output  wire            sn_tready     ,
  input   wire            sn_tvalid     ,
  input   wire  [31 : 0]  sn_tdata      ,

  output  wire            se_tready     ,
  input   wire            se_tvalid     ,
  input   wire  [31 : 0]  se_tdata      ,

  output  wire            ss_tready     ,
  input   wire            ss_tvalid     ,
  input   wire  [31 : 0]  ss_tdata      ,

  output  wire            sw_tready     ,
  input   wire            sw_tvalid     ,
  input   wire  [31 : 0]  sw_tdata      ,

  // Outputs
  input   wire            mn_tready     ,
  output  wire            mn_tvalid     ,
  output  wire  [31 : 0]  mn_tdata      ,

  input   wire            me_tready     ,
  output  wire            me_tvalid     ,
  output  wire  [31 : 0]  me_tdata      ,

  input   wire            ms_tready     ,
  output  wire            ms_tvalid     ,
  output  wire  [31 : 0]  ms_tdata      ,

  input   wire            mw_tready     ,
  output  wire            mw_tvalid     ,
  output  wire  [31 : 0]  mw_tdata      ,

  // PR Intrface
  input   wire            macc1_tready  ,
  output  wire            macc1_tvalid  ,
  output  wire  [31 : 0]  macc1_tdata   ,

  input   wire            macc2_tready  ,
  output  wire            macc2_tvalid  ,
  output  wire  [31 : 0]  macc2_tdata   ,

  output  wire            sacc_tready   ,
  input   wire            sacc_tvalid   ,
  input   wire  [31 : 0]  sacc_tdata    ,

  // Config Interface
  input   wire  [ 3 : 0]  IN1_CONF      ,
  input   wire  [ 3 : 0]  IN2_CONF      ,
  input   wire  [ 3 : 0]  N_CONF        ,
  input   wire  [ 3 : 0]  E_CONF        ,
  input   wire  [ 3 : 0]  S_CONF        ,
  input   wire  [ 3 : 0]  W_CONF        ,

  input   wire            ACLK          ,
  input   wire            ARESETN
);

wire en_tmp_tready;
wire sn_tmp_tready;
wire wn_tmp_tready;

wire ne_tmp_tready;
wire se_tmp_tready;
wire we_tmp_tready;

wire ns_tmp_tready;
wire es_tmp_tready;
wire ws_tmp_tready;

wire nw_tmp_tready;
wire ew_tmp_tready;
wire sw_tmp_tready;

wire nacc1_tmp_tready;
wire eacc1_tmp_tready;
wire sacc1_tmp_tready;
wire wacc1_tmp_tready;

wire nacc2_tmp_tready;
wire eacc2_tmp_tready;
wire sacc2_tmp_tready;
wire wacc2_tmp_tready;

assign sn_tready    = en_tmp_tready   | sn_tmp_tready   | wn_tmp_tready   | nacc1_tmp_tready | nacc2_tmp_tready;
assign se_tready    = ne_tmp_tready   | se_tmp_tready   | we_tmp_tready   | eacc1_tmp_tready | eacc2_tmp_tready;
assign ss_tready    = ns_tmp_tready   | es_tmp_tready   | ws_tmp_tready   | sacc1_tmp_tready | sacc2_tmp_tready;
assign sw_tready    = nw_tmp_tready   | ew_tmp_tready   | sw_tmp_tready   | wacc1_tmp_tready | wacc2_tmp_tready;
assign sacc_tready  = nout_tmp_tready | eout_tmp_tready | sout_tmp_tready | wout_tmp_tready;

sfa_5to1_mux N_OUT_MUX (
  .s1_tready () ,
  .s1_tvalid (1'b0 ) ,
  .s1_tdata  (32'b0) ,

  .s2_tready (ne_tmp_tready) ,
  .s2_tvalid (se_tvalid) ,
  .s2_tdata  (se_tdata ) ,

  .s3_tready (ns_tmp_tready) ,
  .s3_tvalid (ss_tvalid) ,
  .s3_tdata  (ss_tdata ) ,

  .s4_tready (nw_tmp_tready) ,
  .s4_tvalid (sw_tvalid) ,
  .s4_tdata  (sw_tdata ) ,

  .s5_tready (nout_tmp_tready) ,
  .s5_tvalid (sacc_tvalid) ,
  .s5_tdata  (sacc_tdata ) ,

  .mO_tready (mn_tready) ,
  .mO_tvalid (mn_tvalid) ,
  .mO_tdata  (mn_tdata ) ,
  .CONF      (N_CONF    )
);

sfa_5to1_mux E_OUT_MUX (
  .s1_tready (en_tmp_tready) ,
  .s1_tvalid (sn_tvalid) ,
  .s1_tdata  (sn_tdata ) ,

  .s2_tready () ,
  .s2_tvalid (1'b0 ) ,
  .s2_tdata  (32'b0) ,

  .s3_tready (es_tmp_tready) ,
  .s3_tvalid (ss_tvalid) ,
  .s3_tdata  (ss_tdata ) ,

  .s4_tready (ew_tmp_tready) ,
  .s4_tvalid (sw_tvalid) ,
  .s4_tdata  (sw_tdata ) ,

  .s5_tready (eout_tmp_tready) ,
  .s5_tvalid (sacc_tvalid) ,
  .s5_tdata  (sacc_tdata ) ,

  .mO_tready (me_tready) ,
  .mO_tvalid (me_tvalid) ,
  .mO_tdata  (me_tdata ) ,
  .CONF      (E_CONF    )
);

sfa_5to1_mux S_OUT_MUX (
  .s1_tready (sn_tmp_tready) ,
  .s1_tvalid (sn_tvalid) ,
  .s1_tdata  (sn_tdata ) ,

  .s2_tready (se_tmp_tready) ,
  .s2_tvalid (se_tvalid) ,
  .s2_tdata  (se_tdata ) ,

  .s3_tready () ,
  .s3_tvalid (1'b0 ) ,
  .s3_tdata  (32'b0) ,

  .s4_tready (sw_tmp_tready) ,
  .s4_tvalid (sw_tvalid) ,
  .s4_tdata  (sw_tdata ) ,

  .s5_tready (sout_tmp_tready) ,
  .s5_tvalid (sacc_tvalid) ,
  .s5_tdata  (sacc_tdata ) ,

  .mO_tready (ms_tready) ,
  .mO_tvalid (ms_tvalid) ,
  .mO_tdata  (ms_tdata ) ,
  .CONF      (S_CONF    )
);

sfa_5to1_mux W_OUT_MUX (
  .s1_tready (wn_tmp_tready) ,
  .s1_tvalid (sn_tvalid) ,
  .s1_tdata  (sn_tdata ) ,

  .s2_tready (we_tmp_tready) ,
  .s2_tvalid (se_tvalid) ,
  .s2_tdata  (se_tdata ) ,

  .s3_tready (ws_tmp_tready) ,
  .s3_tvalid (ss_tvalid) ,
  .s3_tdata  (ss_tdata ) ,

  .s4_tready () ,
  .s4_tvalid (1'b0 ) ,
  .s4_tdata  (32'b0) ,

  .s5_tready (wout_tmp_tready) ,
  .s5_tvalid (sacc_tvalid) ,
  .s5_tdata  (sacc_tdata ) ,

  .mO_tready (mw_tready) ,
  .mO_tvalid (mw_tvalid) ,
  .mO_tdata  (mw_tdata ) ,
  .CONF      (W_CONF    )
);

sfa_5to1_mux ACC_IN1_MUX (
  .s1_tready (nacc1_tmp_tready) ,
  .s1_tvalid (sn_tvalid) ,
  .s1_tdata  (sn_tdata ) ,

  .s2_tready (eacc1_tmp_tready) ,
  .s2_tvalid (se_tvalid) ,
  .s2_tdata  (se_tdata ) ,

  .s3_tready (sacc1_tmp_tready) ,
  .s3_tvalid (ss_tvalid) ,
  .s3_tdata  (ss_tdata ) ,

  .s4_tready (wacc1_tmp_tready) ,
  .s4_tvalid (sw_tvalid) ,
  .s4_tdata  (sw_tdata ) ,

  .mO_tready (macc1_tready) ,
  .mO_tvalid (macc1_tvalid) ,
  .mO_tdata  (macc1_tdata ) ,
  .CONF      (IN1_CONF )
);

sfa_5to1_mux ACC_IN2_MUX (
  .s1_tready (nacc2_tmp_tready) ,
  .s1_tvalid (sn_tvalid) ,
  .s1_tdata  (sn_tdata ) ,

  .s2_tready (eacc2_tmp_tready) ,
  .s2_tvalid (se_tvalid) ,
  .s2_tdata  (se_tdata ) ,

  .s3_tready (sacc2_tmp_tready) ,
  .s3_tvalid (ss_tvalid) ,
  .s3_tdata  (ss_tdata ) ,

  .s4_tready (wacc2_tmp_tready) ,
  .s4_tvalid (sw_tvalid) ,
  .s4_tdata  (sw_tdata ) ,

  .mO_tready (macc2_tready) ,
  .mO_tvalid (macc2_tvalid) ,
  .mO_tdata  (macc2_tdata ) ,
  .CONF      (IN2_CONF )
);

endmodule
