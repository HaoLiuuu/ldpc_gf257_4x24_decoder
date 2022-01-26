// =============================================================================
// @File         :  tb_ldpc_vpu.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/10 19:31:17
// @Description  :  testbench for 4x24 LDPC vpu
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/10 19:31:17 | original
// =============================================================================

`timescale 1us/1us
`define PERIOD 20

module tb_ldpc_vpu ();

localparam COL_WEIGHT = 4;
localparam LLR_WIDTH = 8;

reg clk;
reg rst_n;
reg en;

reg [LLR_WIDTH-1:0] llr_intri; // intrinsic message

reg [LLR_WIDTH-1:0] llr_in_0;
reg [LLR_WIDTH-1:0] llr_in_1;
reg [LLR_WIDTH-1:0] llr_in_2;
reg [LLR_WIDTH-1:0] llr_in_3;

wire [LLR_WIDTH-1:0] llr_out_0;
wire [LLR_WIDTH-1:0] llr_out_1;
wire [LLR_WIDTH-1:0] llr_out_2;
wire [LLR_WIDTH-1:0] llr_out_3;

wire [LLR_WIDTH-1:0] llr_all;


ldpc_vpu #(
		.COL_WEIGHT(COL_WEIGHT),
		.LLR_WIDTH(LLR_WIDTH)
	) inst_ldpc_vpu (
		.clk       (clk),
		.rst_n     (rst_n),
		.en        (en),
		.llr_intri (llr_intri),
		.llr_in_0  (llr_in_0),
		.llr_in_1  (llr_in_1),
		.llr_in_2  (llr_in_2),
		.llr_in_3  (llr_in_3),
		.llr_out_0 (llr_out_0),
		.llr_out_1 (llr_out_1),
		.llr_out_2 (llr_out_2),
		.llr_out_3 (llr_out_3),
		.llr_all   (llr_all)
	);

//--------------------------------------------
// system clock generate
//--------------------------------------------
initial begin : clock
    clk = 1'b0;
    forever #(`PERIOD/2) clk = ~clk;
end

// reset task
task sys_reset;
    input [31:0] reset_time;
    begin 
        rst_n = 1'b0;
        #reset_time;
        rst_n = 1'b1;
    end
endtask

task write;
	input [LLR_WIDTH-1:0] in_0;
	input [LLR_WIDTH-1:0] in_1;
	input [LLR_WIDTH-1:0] in_2;
	input [LLR_WIDTH-1:0] in_3;
	input [LLR_WIDTH-1:0] in_intrin;
	begin
		llr_in_0 <= in_0;
		llr_in_1 <= in_1;
		llr_in_2 <= in_2;
		llr_in_3 <= in_3;
		@(posedge clk);
		llr_intri <= in_intrin;
	end
endtask

// =============================================================================
//                          测试用例
// =============================================================================

initial begin
	sys_reset(100);
// case 1
	write(127, 127, 127, 127, 127);
	write(-128, -128, -128, -128, -128);

	write(-127, -127, -127, -127, -127);
	write(-1, -1, -1, -1, -1);


	write(1, 1, 1, 1, 1);
// 应该增加更多的测试用例的
// 2022/1/10 19:41:08
// 		是时候了解更多的 verification 了
   	repeat (5) @(posedge clk);
   	$stop;
end

endmodule

