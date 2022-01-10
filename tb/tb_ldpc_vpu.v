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


// =============================================================================
//                          测试用例
// =============================================================================

initial begin
	sys_reset(100);
// case 1
    llr_in_0 = 8'h28;
    llr_in_1 = 8'h45;
    llr_in_2 = 8'ha3;
    llr_in_3 = 8'h93;
    #(`PERIOD)
    llr_intri  = 8'h22;

// case 2
    llr_in_0 = 8'h11;
    llr_in_1 = 8'h44;
    llr_in_0 = 8'hb2;
    llr_in_1 = 8'h41;
   	#(`PERIOD)
   	llr_intri  = 8'h34;

// 应该增加更多的测试用例的
// 2022/1/10 19:41:08
// 		是时候了解更多的 verification 了
   	#(`PERIOD*10)
   	$stop;
end

endmodule

