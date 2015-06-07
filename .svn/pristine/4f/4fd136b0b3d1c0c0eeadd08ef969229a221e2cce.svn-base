`timescale 1 ns / 1 ps

module sfa_switch(
  // Interconnect
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

  // // PR Intrface
  input   wire            macc1_tready  ,
  output  wire            macc1_tvalid  ,
  output  wire  [31 : 0]  macc1_tdata   ,

  input   wire            macc2_tready  ,
  output  wire            macc2_tvalid  ,
  output  wire  [31 : 0]  macc2_tdata   ,

  output  wire            sacc_tready   ,
  input   wire            sacc_tvalid   ,
  input   wire  [31 : 0]  sacc_tdata    ,

  // Control
  output  wire            sCMD_tready   ,
  input   wire            sCMD_tvalid   ,
  input   wire  [31 : 0]  sCMD_tdata    ,

  input   wire            mRet_tready   ,
  output  wire            mRet_tvalid   ,
  output  wire  [31 : 0]  mRet_tdata    ,

  // BIF 1 Interface
  output  wire            BC1_ap_start  ,
  input   wire            BC1_ap_done   ,
  input   wire            BC1_ap_idle   ,
  input   wire            BC1_ap_ready  ,
  output  wire            BC1_MODE      ,
  output  wire  [23 : 0]  BC1_INDEX     ,
  output  wire  [23 : 0]  BC1_SIZE      ,
  output  wire  [23 : 0]  BC1_STRIDE    ,

  // BIF 2 Interface
  output  wire            BC2_ap_start  ,
  input   wire            BC2_ap_done   ,
  input   wire            BC2_ap_idle   ,
  input   wire            BC2_ap_ready  ,
  output  wire            BC2_MODE      ,
  output  wire  [23 : 0]  BC2_INDEX     ,
  output  wire  [23 : 0]  BC2_SIZE      ,
  output  wire  [23 : 0]  BC2_STRIDE    ,

  input   wire            ACLK          ,
  input   wire            ARESETN
);

wire  [ 3 : 0]  IN1_CONF;
wire  [ 3 : 0]  IN2_CONF;
wire  [ 3 : 0]  N_CONF  ;
wire  [ 3 : 0]  E_CONF  ;
wire  [ 3 : 0]  S_CONF  ;
wire  [ 3 : 0]  W_CONF  ;

sfa_interconnect u_interconnect(
  .sn_tready      (sn_tready      ) ,
  .sn_tvalid      (sn_tvalid      ) ,
  .sn_tdata       (sn_tdata       ) ,
  .se_tready      (se_tready      ) ,
  .se_tvalid      (se_tvalid      ) ,
  .se_tdata       (se_tdata       ) ,
  .ss_tready      (ss_tready      ) ,
  .ss_tvalid      (ss_tvalid      ) ,
  .ss_tdata       (ss_tdata       ) ,
  .sw_tready      (sw_tready      ) ,
  .sw_tvalid      (sw_tvalid      ) ,
  .sw_tdata       (sw_tdata       ) ,
  .mn_tready      (mn_tready      ) ,
  .mn_tvalid      (mn_tvalid      ) ,
  .mn_tdata       (mn_tdata       ) ,
  .me_tready      (me_tready      ) ,
  .me_tvalid      (me_tvalid      ) ,
  .me_tdata       (me_tdata       ) ,
  .ms_tready      (ms_tready      ) ,
  .ms_tvalid      (ms_tvalid      ) ,
  .ms_tdata       (ms_tdata       ) ,
  .mw_tready      (mw_tready      ) ,
  .mw_tvalid      (mw_tvalid      ) ,
  .mw_tdata       (mw_tdata       ) ,
  .macc1_tready   (macc1_tready   ) ,
  .macc1_tvalid   (macc1_tvalid   ) ,
  .macc1_tdata    (macc1_tdata    ) ,
  .macc2_tready   (macc2_tready   ) ,
  .macc2_tvalid   (macc2_tvalid   ) ,
  .macc2_tdata    (macc2_tdata    ) ,
  .sacc_tready    (sacc_tready    ) ,
  .sacc_tvalid    (sacc_tvalid    ) ,
  .sacc_tdata     (sacc_tdata     ) ,
  .N_CONF         (N_CONF         ) ,
  .E_CONF         (E_CONF         ) ,
  .S_CONF         (S_CONF         ) ,
  .W_CONF         (W_CONF         ) ,
  .IN1_CONF       (IN1_CONF       ) ,
  .IN2_CONF       (IN2_CONF       ) ,
  .ACLK           (ACLK           ) ,
  .ARESETN        (ARESETN        )
);

sfa_control u_control(
  .sCMD_tready    (sCMD_tready    ) ,
  .sCMD_tvalid    (sCMD_tvalid    ) ,
  .sCMD_tdata     (sCMD_tdata     ) ,
  .mRet_tready    (mRet_tready    ) ,
  .mRet_tvalid    (mRet_tvalid    ) ,
  .mRet_tdata     (mRet_tdata     ) ,
  .BC1_ap_start   (BC1_ap_start   ) ,
  .BC1_ap_done    (BC1_ap_done    ) ,
  .BC1_ap_idle    (BC1_ap_idle    ) ,
  .BC1_ap_ready   (BC1_ap_ready   ) ,
  .BC1_MODE       (BC1_MODE       ) ,
  .BC1_INDEX      (BC1_INDEX      ) ,
  .BC1_SIZE       (BC1_SIZE       ) ,
  .BC1_STRIDE     (BC1_STRIDE     ) ,
  .BC2_ap_start   (BC2_ap_start   ) ,
  .BC2_ap_done    (BC2_ap_done    ) ,
  .BC2_ap_idle    (BC2_ap_idle    ) ,
  .BC2_ap_ready   (BC2_ap_ready   ) ,
  .BC2_MODE       (BC2_MODE       ) ,
  .BC2_INDEX      (BC2_INDEX      ) ,
  .BC2_SIZE       (BC2_SIZE       ) ,
  .BC2_STRIDE     (BC2_STRIDE     ) ,
  .IN1_CONF       (IN1_CONF       ) ,
  .IN2_CONF       (IN2_CONF       ) ,
  .N_CONF         (N_CONF         ) ,
  .E_CONF         (E_CONF         ) ,
  .S_CONF         (S_CONF         ) ,
  .W_CONF         (W_CONF         ) ,
  .ACLK           (ACLK           ) ,
  .ARESETN        (ARESETN        )
);

endmodule
