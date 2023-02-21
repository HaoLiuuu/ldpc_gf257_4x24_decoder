// =============================================================================
// @File         :  tb_comp.v
// @Author       :  Jiangxuan Li
// @Created      :  2023/02/21 16:01:48
// @Description  :  test comp
//
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2023/02/21 16:01:48 | original
// =============================================================================

`timescale 1ns/100ps
`define PERIOD 20
module tb_comp ();

localparam WIDTH = 8;

reg [WIDTH-1:0] in_1;
reg [WIDTH-1:0] in_2;
reg [WIDTH-1:0] in_3;

wire [WIDTH-1:0] min_v;
wire [WIDTH-1:0] submin_v;

comp3in2out #(
  .WIDTH (
      WIDTH )
) comp3in2out_dut (
  .in_1 (in_1 ),
  .in_2 (in_2 ),
  .in_3 (in_3 ),
  .min_v (min_v ),
  .submin_v  ( submin_v)
);

initial begin
  #100;
  // 基础测试
  in_1 = $random;
  in_2 = $random;
  in_3 = $random;
  #(`PERIOD)
  in_1 = $random;
  in_2 = $random;
  in_3 = $random;
  #(`PERIOD)
  in_1 = $random;
  in_2 = $random;
  in_3 = $random;
  #(`PERIOD)

  // 加入高阻态
  in_1 = {WIDTH{1'bx}};
  in_2 = $random;
  in_3 = $random;
  #(`PERIOD)
  in_1 = $random;
  in_2 = {WIDTH{1'bx}};
  in_3 = $random;
  #(`PERIOD)
  in_1 = $random;
  in_2 = $random;
  in_3 = {WIDTH{1'bx}};
  #(`PERIOD)
  $stop;
end



endmodule //tb_comp
