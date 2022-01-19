// =============================================================================
// @File         :  tb_vpu_addr_gen.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/18 12:13:10
// @Description  :  testbench for vpu addr gen
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/18 12:13:10 | original
// =============================================================================

`timescale 1ns/1ns
`define PERIOD 20
module tb_vpu_addr_gen ();

localparam ADDR_WIDTH = 8;

reg clk;
reg en;
reg initial_on;
reg vpu_on;
reg rst_n;

wire [ADDR_WIDTH-1:0] vpu_addr_0 ;
wire [ADDR_WIDTH-1:0] vpu_addr_1 ;
wire [ADDR_WIDTH-1:0] vpu_addr_2 ;
wire [ADDR_WIDTH-1:0] vpu_addr_3 ;
wire [ADDR_WIDTH-1:0] vpu_addr_4 ;
wire [ADDR_WIDTH-1:0] vpu_addr_5 ;
wire [ADDR_WIDTH-1:0] vpu_addr_6 ;
wire [ADDR_WIDTH-1:0] vpu_addr_7 ;
wire [ADDR_WIDTH-1:0] vpu_addr_8 ;
wire [ADDR_WIDTH-1:0] vpu_addr_9 ;
wire [ADDR_WIDTH-1:0] vpu_addr_10;
wire [ADDR_WIDTH-1:0] vpu_addr_11;
wire [ADDR_WIDTH-1:0] vpu_addr_12;
wire [ADDR_WIDTH-1:0] vpu_addr_13;
wire [ADDR_WIDTH-1:0] vpu_addr_14;
wire [ADDR_WIDTH-1:0] vpu_addr_15;
wire [ADDR_WIDTH-1:0] vpu_addr_16;
wire [ADDR_WIDTH-1:0] vpu_addr_17;
wire [ADDR_WIDTH-1:0] vpu_addr_18;
wire [ADDR_WIDTH-1:0] vpu_addr_19;
wire [ADDR_WIDTH-1:0] vpu_addr_20;
wire [ADDR_WIDTH-1:0] vpu_addr_21;
wire [ADDR_WIDTH-1:0] vpu_addr_22;
wire [ADDR_WIDTH-1:0] vpu_addr_23;

vpu_addr_gen #(
		.ADDR_WIDTH(ADDR_WIDTH)
	) inst_vpu_addr_gen (
		.clk         (clk),
		.en          (en),
		.rst_n       (rst_n),
		.initial_on  (initial_on),
		.vpu_on      (vpu_on),
		.vpu_addr_0  (vpu_addr_0),
		.vpu_addr_1  (vpu_addr_1),
		.vpu_addr_2  (vpu_addr_2),
		.vpu_addr_3  (vpu_addr_3),
		.vpu_addr_4  (vpu_addr_4),
		.vpu_addr_5  (vpu_addr_5),
		.vpu_addr_6  (vpu_addr_6),
		.vpu_addr_7  (vpu_addr_7),
		.vpu_addr_8  (vpu_addr_8),
		.vpu_addr_9  (vpu_addr_9),
		.vpu_addr_10 (vpu_addr_10),
		.vpu_addr_11 (vpu_addr_11),
		.vpu_addr_12 (vpu_addr_12),
		.vpu_addr_13 (vpu_addr_13),
		.vpu_addr_14 (vpu_addr_14),
		.vpu_addr_15 (vpu_addr_15),
		.vpu_addr_16 (vpu_addr_16),
		.vpu_addr_17 (vpu_addr_17),
		.vpu_addr_18 (vpu_addr_18),
		.vpu_addr_19 (vpu_addr_19),
		.vpu_addr_20 (vpu_addr_20),
		.vpu_addr_21 (vpu_addr_21),
		.vpu_addr_22 (vpu_addr_22),
		.vpu_addr_23 (vpu_addr_23)
	);

//--------------------------------------------
// system clock generate
//--------------------------------------------
initial begin : clock
    clk = 1'b0;
    forever #(`PERIOD/2) clk = ~clk;
end

task sys_reset;
    input [31:0] reset_time;
    begin 
        rst_n = 1'b0;
        #reset_time;
        rst_n = 1'b1;
    end
endtask

initial begin
	// testcase
	sys_reset(45);
	en = 1'b1;
	@(posedge clk);
	vpu_on = 1'b0;
	initial_on = 1'b1;
	// 延迟 1000 时钟
	repeat (300) @(posedge clk);

	initial_on = 1'b0;
	repeat (2) @(posedge clk);
	vpu_on = 1'b1;
	repeat (300) @(posedge clk);

	$stop;
end


endmodule
