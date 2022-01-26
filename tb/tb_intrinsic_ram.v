// =============================================================================
// @File         :  tb_intrinsic_ram.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/22 15:36:28
// @Description  :  des
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/22 15:36:28 | original
// =============================================================================

`timescale 1ns/100ps
`define PERIOD 20
module tb_intrinsic_ram ();

localparam LLR_WIDTH = 8;
localparam ADDR_WIDTH = 8;

reg rst_n;
reg [LLR_WIDTH-1:0] rece_llr_intri;
reg [ADDR_WIDTH-1:0] rdaddr_intri;
reg clk;
reg in_info_wren;
reg in_info_rden;
reg [ADDR_WIDTH-1:0] wraddr_intri;
wire wrclk = clk;
wire [LLR_WIDTH-1:0] llr_intri;

llr_intrinsic inst_llr_intrinsic
	(
		.data      (rece_llr_intri),
		.rdaddress (rdaddr_intri),
		.rdclock   (clk),
		.rden      (in_info_rden),
		.wraddress (wraddr_intri),
		.wrclock   (wrclk),
		.wren      (in_info_wren),
		.q         (llr_intri)
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
	input [ADDR_WIDTH-1:0] addr;
	input [LLR_WIDTH-1:0] data;
	begin
		in_info_wren <= 1'b1;
		@(posedge wrclk);
		wraddr_intri <= addr;
		rece_llr_intri <= data;
		repeat (2) @(posedge wrclk);
		in_info_wren <= 1'b0;
	end
endtask // task

task read;
	input [ADDR_WIDTH-1:0] addr;
	begin
		in_info_rden <= 1'b1;
		@(posedge clk)
		rdaddr_intri <= addr;
		@(posedge clk)
		in_info_rden <= 1'b0;
	end
endtask

initial begin
	sys_reset(100);

	write(0, 10);

	read(0);
	repeat (3) @(posedge clk);
	$stop;
end


endmodule