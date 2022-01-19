// =============================================================================
// @File         :  tb_llr_ram.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/18 16:06:51
// @Description  :  testbench for llr ram
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/18 16:06:51 | original
// =============================================================================

`timescale 1ns/100ps
`define PERIOD 20
module tb_llr_ram ();

localparam ADDR_WIDTH = 8;
localparam LLR_WIDTH = 8;

reg clk;
reg rst_n;
reg [LLR_WIDTH-1:0]  llr_in;
reg [ADDR_WIDTH-1:0] rd_addr;
reg rden;
reg [ADDR_WIDTH-1:0] wr_addr;
reg wren;
wire [LLR_WIDTH-1:0] llr_out;

llr_ram inst_llr_ram
	(
		.clock     (clk),
		.data      (llr_in),
		.rdaddress (rd_addr),
		.rden      (rden),
		.wraddress (wr_addr),
		.wren      (wren),
		.q         (llr_out)
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


integer i;
integer Write_out_file;
initial begin
	sys_reset(500); // 500 ns复位
	// 写入测试
	Write_out_file = $fopen("Write_out_file.txt", "w");
	wren = 1'b1;
	rden = 1'b0;
	for (i = 0; i < 256; i = i + 1) begin
		wr_addr = i;
		llr_in = {$random()} % 256;
		$display("write %d @%d  ---> ", llr_in, wr_addr);
		$fdisplay(Write_out_file, "write %d @%d  ---> ", llr_in, wr_addr);
		@(posedge clk);
	end
	$fdisplay(Write_out_file, "\n");
	wren = 1'b0;
	rden = 1'b1;
	for (i = 0; i < 255; i = i + 1) begin
		rd_addr = i;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		$display("read %d @%d", llr_out, rd_addr);
		$fdisplay(Write_out_file, "read %d @%d", llr_out, rd_addr);
	end

$fclose(Write_out_file);
$stop;
end

endmodule
