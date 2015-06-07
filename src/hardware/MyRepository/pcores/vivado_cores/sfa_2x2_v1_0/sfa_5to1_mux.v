`timescale 1 ns / 1 ps

module sfa_5to1_mux
(

  output  reg              s1_tready  ,
  input   wire             s1_tvalid  ,
  input   wire  [31 : 0]   s1_tdata   ,

  output  reg              s2_tready  ,
  input   wire             s2_tvalid  ,
  input   wire  [31 : 0]   s2_tdata   ,

  output  reg              s3_tready  ,
  input   wire             s3_tvalid  ,
  input   wire  [31 : 0]   s3_tdata   ,

  output  reg              s4_tready  ,
  input   wire             s4_tvalid  ,
  input   wire  [31 : 0]   s4_tdata   ,

  output  reg              s5_tready  ,
  input   wire             s5_tvalid  ,
  input   wire  [31 : 0]   s5_tdata   ,

  input   wire             mO_tready ,
  output  reg              mO_tvalid ,
  output  reg   [31 : 0]   mO_tdata  ,

  input   wire  [ 3 : 0]   CONF
);

always @(*)
begin

  case (CONF)
    4'd0: begin
      mO_tvalid =  1'b0     ;
      mO_tdata  = 32'd0     ;
      s1_tready =  1'b0     ;
      s2_tready =  1'b0     ;
      s3_tready =  1'b0     ;
      s4_tready =  1'b0     ;
      s5_tready =  1'b0     ;
    end

    4'd1: begin
      mO_tvalid = s1_tvalid ;
      mO_tdata  = s1_tdata  ;
      s1_tready = mO_tready ;
      s2_tready = 1'b0      ;
      s3_tready = 1'b0      ;
      s4_tready = 1'b0      ;
      s5_tready = 1'b0      ;
    end

    4'd2: begin
      mO_tvalid = s2_tvalid ;
      mO_tdata  = s2_tdata  ;
      s1_tready = 1'b0      ;
      s2_tready = mO_tready ;
      s3_tready = 1'b0      ;
      s4_tready = 1'b0      ;
      s5_tready = 1'b0      ;
    end

    4'd3: begin
      mO_tvalid = s3_tvalid ;
      mO_tdata  = s3_tdata  ;
      s1_tready = 1'b0      ;
      s2_tready = 1'b0      ;
      s3_tready = mO_tready ;
      s4_tready = 1'b0      ;
      s5_tready = 1'b0      ;
    end

    4'd4: begin
      mO_tvalid = s4_tvalid ;
      mO_tdata  = s4_tdata  ;
      s1_tready = 1'b0      ;
      s2_tready = 1'b0      ;
      s3_tready = 1'b0      ;
      s4_tready = mO_tready ;
      s5_tready = 1'b0      ;
    end

    4'd5: begin
      mO_tvalid = s5_tvalid ;
      mO_tdata  = s5_tdata  ;
      s1_tready = 1'b0      ;
      s2_tready = 1'b0      ;
      s3_tready = 1'b0      ;
      s4_tready = 1'b0      ;
      s5_tready = mO_tready ;
    end

    default: begin
      mO_tvalid =  1'b0     ;
      mO_tdata  = 32'd0     ;
      s1_tready =  1'b0     ;
      s2_tready =  1'b0     ;
      s3_tready =  1'b0     ;
      s4_tready =  1'b0     ;
      s5_tready =  1'b0     ;
    end
  endcase
end

endmodule
