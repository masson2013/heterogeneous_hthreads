`timescale 1ns / 1ps

module sfa_control (
  output  wire             sCMD_tready   ,
  input   wire             sCMD_tvalid   ,
  input   wire  [31 : 0]   sCMD_tdata    ,
  input   wire             mRet_tready   ,
  output  wire             mRet_tvalid   ,
  output  wire  [31 : 0]   mRet_tdata    ,

  // BIF 1 Interface
  output  wire             BC1_ap_start  ,
  input   wire             BC1_ap_done   ,
  input   wire             BC1_ap_idle   ,
  input   wire             BC1_ap_ready  ,
  output  wire             BC1_MODE      ,
  output  wire  [23 : 0]   BC1_INDEX     ,
  output  wire  [23 : 0]   BC1_SIZE      ,
  output  wire  [23 : 0]   BC1_STRIDE    ,

  // BIF 2 Interface
  output  wire             BC2_ap_start  ,
  input   wire             BC2_ap_done   ,
  input   wire             BC2_ap_idle   ,
  input   wire             BC2_ap_ready  ,
  output  wire             BC2_MODE      ,
  output  wire  [23 : 0]   BC2_INDEX     ,
  output  wire  [23 : 0]   BC2_SIZE      ,
  output  wire  [23 : 0]   BC2_STRIDE    ,

  // CONF Signals
  output  wire  [ 3 : 0]   IN1_CONF      ,
  output  wire  [ 3 : 0]   IN2_CONF      ,
  output  wire  [ 3 : 0]   N_CONF        ,
  output  wire  [ 3 : 0]   E_CONF        ,
  output  wire  [ 3 : 0]   S_CONF        ,
  output  wire  [ 3 : 0]   W_CONF        ,

  input   wire             ACLK          ,
  input   wire             ARESETN
);


  localparam Fetch           = 6'd1;
  localparam Decode          = 6'd2;
  localparam VAMSET          = 6'd3;
  localparam VAMSTART        = 6'd4;
  localparam VAMDONE         = 6'd5;
  localparam VAMDONE_PLUS    = 6'd6;
  localparam WRITE_BACK      = 6'd7;

  localparam VSET          = 8'h1;
  localparam VSTART        = 8'hA;

  localparam VBC1_MODE     = 8'h11;
  localparam VBC1_INDEX    = 8'h12;
  localparam VBC1_SIZE     = 8'h13;
  localparam VBC1_STRIDE   = 8'h14;

  localparam VBC2_MODE     = 8'h21;
  localparam VBC2_INDEX    = 8'h22;
  localparam VBC2_SIZE     = 8'h23;
  localparam VBC2_STRIDE   = 8'h24;


  wire       condition_done;

  reg [ 5:0] state       ;
  reg [31:0] instruction ;
  reg [31:0] ret         ;
  reg [31:0] rPRSTART    ;
  reg [31:0] rPRDONE     ;

  assign sCMD_tready   = (state == Fetch);
  assign mRet_tvalid   = (state == WRITE_BACK);

  assign mRet_tdata   = ret;

  reg        rBC1_ap_start;
  reg        rBC2_ap_start;

  reg [3:0]  rIN1_CONF;
  reg [3:0]  rIN2_CONF;
  reg [3:0]  rN_CONF;
  reg [3:0]  rE_CONF;
  reg [3:0]  rS_CONF;
  reg [3:0]  rW_CONF;

  reg [23:0] rBC1_INDEX  ;
  reg [23:0] rBC1_SIZE   ;
  reg [23:0] rBC1_STRIDE ;
  reg        rBC1_MODE   ;
  reg [23:0] rBC2_INDEX  ;
  reg [23:0] rBC2_SIZE   ;
  reg [23:0] rBC2_STRIDE ;
  reg        rBC2_MODE   ;

  assign condition_done = BC1_ap_done & BC2_ap_done;

  assign IN1_CONF    = rIN1_CONF ;
  assign IN2_CONF    = rIN2_CONF ;
  assign N_CONF     = rN_CONF  ;
  assign E_CONF     = rE_CONF  ;
  assign S_CONF     = rS_CONF  ;
  assign W_CONF     = rW_CONF  ;

  assign BC1_ap_start = rBC1_ap_start ;
  assign BC1_INDEX    = rBC1_INDEX    ;
  assign BC1_SIZE     = rBC1_SIZE     ;
  assign BC1_STRIDE   = rBC1_STRIDE   ;
  assign BC1_MODE     = rBC1_MODE     ;

  assign BC2_ap_start = rBC2_ap_start ;
  assign BC2_INDEX    = rBC2_INDEX    ;
  assign BC2_SIZE     = rBC2_SIZE     ;
  assign BC2_STRIDE   = rBC2_STRIDE   ;
  assign BC2_MODE     = rBC2_MODE     ;

  always @(posedge ACLK)
  begin
    if(!ARESETN) begin
      state <= Fetch;
      rBC1_ap_start <= 1'd0;
      rBC2_ap_start <= 1'd0;

      rBC1_MODE    <=  1'd0;
      rBC1_INDEX   <= 24'd0;
      rBC1_SIZE    <= 24'd0;
      rBC1_STRIDE  <= 24'd0;

      rBC2_MODE    <=  1'd0;
      rBC2_INDEX   <= 24'd0;
      rBC2_SIZE    <= 24'd0;
      rBC2_STRIDE  <= 24'd0;

      instruction  <= 32'd0;
      ret          <= 32'd0;
    end
    else begin
      case (state)
        Fetch: begin
          if (sCMD_tvalid == 1) begin
            instruction  <= sCMD_tdata;
            state        <= Decode;
          end
          else begin
            state        <= Fetch;
          end
        end

        Decode: begin
          case (instruction[31 : 24])
            VSET        : state <= VAMSET;
            VSTART      : begin
              state <= VAMSTART;
            end
            VBC1_INDEX  : begin
              rBC1_INDEX  <= instruction[23 : 0];
              state       <= Fetch;
            end
            VBC1_SIZE   : begin
              rBC1_SIZE   <= instruction[23 : 0];
              state       <= Fetch;
            end
            VBC1_STRIDE : begin
              rBC1_STRIDE <= instruction[23 : 0];
              state       <= Fetch;
            end
            VBC1_MODE : begin
              rBC1_MODE   <= instruction[0];
              state       <= Fetch;
            end
            VBC2_INDEX  : begin
              rBC2_INDEX  <= instruction[23 : 0];
              state       <= Fetch;
            end
            VBC2_SIZE   : begin
              rBC2_SIZE   <= instruction[23 : 0];
              state       <= Fetch;
            end
            VBC2_STRIDE : begin
              rBC2_STRIDE <= instruction[23 : 0];
              state       <= Fetch;
            end
            VBC2_MODE : begin
              rBC2_MODE   <= instruction[0];
              state       <= Fetch;
            end
            default: begin
              state       <= Fetch;
            end
          endcase
        end

        VAMSET: begin
          rIN1_CONF  <= instruction[23 : 20];
          rIN2_CONF  <= instruction[19 : 16];
          rN_CONF   <= instruction[15 : 12];
          rE_CONF   <= instruction[11 :  8];
          rS_CONF   <= instruction[ 7 :  4];
          rW_CONF   <= instruction[ 3 :  0];
          state <=  Fetch;
        end

        VAMSTART: begin
          if (BC1_ap_idle == 1 & BC2_ap_idle == 1) begin
            rBC1_ap_start <= 1;
            rBC2_ap_start <= 1;
            state <= VAMDONE;
          end
          else begin
            state <= VAMSTART;
          end
        end

        VAMDONE: begin
          rBC1_ap_start <= 0;
          rBC2_ap_start <= 0;
          if (BC1_ap_done == 0 & BC2_ap_done == 0) begin
            state <= VAMDONE;
          end
          else if (BC1_ap_done == 1 & BC2_ap_done == 1) begin
            ret   <= 32'hFFFF   ;
            state <= WRITE_BACK ;
          end
          else if (BC1_ap_done == 1 | BC2_ap_done == 1) begin
            state <= VAMDONE_PLUS;
          end
        end

        VAMDONE_PLUS: begin
          if (BC1_ap_done == 1 | BC2_ap_done == 1) begin
            ret   <= 32'hFFFF   ;
            state <= WRITE_BACK ;
          end
        end

        WRITE_BACK: begin
          if (mRet_tready == 1) begin
            state        <= Fetch;
          end
          else begin
            state        <= WRITE_BACK;
          end
        end
      endcase
    end
  end
endmodule

