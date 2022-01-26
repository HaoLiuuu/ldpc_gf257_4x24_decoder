// =============================================================================
// @File         :  tb_ldpc_runner_top.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/22 12:20:30
// @Description  :  ldpc runner
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/22 12:20:30 | original
// =============================================================================

`timescale 1ns/100ps
`define PERIOD 20
module tb_ldpc_runner_top ();

localparam LLR_WIDTH = 8;
localparam ROW_WEIGHT = 24;
localparam GF_base = 256;
localparam loop_size = 260;

reg clk;
reg en;
reg rst_n;
reg ini_st;
wire wrclk = clk;
reg in_info_wren;
reg [LLR_WIDTH-1:0] rece_llr_intri_0 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_1 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_2 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_3 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_4 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_5 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_6 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_7 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_8 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_9 ;
reg [LLR_WIDTH-1:0] rece_llr_intri_10;
reg [LLR_WIDTH-1:0] rece_llr_intri_11;
reg [LLR_WIDTH-1:0] rece_llr_intri_12;
reg [LLR_WIDTH-1:0] rece_llr_intri_13;
reg [LLR_WIDTH-1:0] rece_llr_intri_14;
reg [LLR_WIDTH-1:0] rece_llr_intri_15;
reg [LLR_WIDTH-1:0] rece_llr_intri_16;
reg [LLR_WIDTH-1:0] rece_llr_intri_17;
reg [LLR_WIDTH-1:0] rece_llr_intri_18;
reg [LLR_WIDTH-1:0] rece_llr_intri_19;
reg [LLR_WIDTH-1:0] rece_llr_intri_20;
reg [LLR_WIDTH-1:0] rece_llr_intri_21;
reg [LLR_WIDTH-1:0] rece_llr_intri_22;
reg [LLR_WIDTH-1:0] rece_llr_intri_23;
wire [23:0] llr_sign;


reg [LLR_WIDTH-1:0] llr_in_0  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_1  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_2  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_3  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_4  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_5  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_6  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_7  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_8  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_9  [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_10 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_11 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_12 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_13 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_14 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_15 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_16 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_17 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_18 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_19 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_20 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_21 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_22 [0:GF_base-1];
reg [LLR_WIDTH-1:0] llr_in_23 [0:GF_base-1];


ldpc_runner_top #(
		.LLR_WIDTH(LLR_WIDTH)
	) inst_ldpc_runner_top (
		.clk               (clk),
		.en                (en),
		.rst_n             (rst_n),
		.ini_st            (ini_st),
		.wrclk             (wrclk),
		.in_info_wren      (in_info_wren),
		.rece_llr_intri_0  (rece_llr_intri_0),
		.rece_llr_intri_1  (rece_llr_intri_1),
		.rece_llr_intri_2  (rece_llr_intri_2),
		.rece_llr_intri_3  (rece_llr_intri_3),
		.rece_llr_intri_4  (rece_llr_intri_4),
		.rece_llr_intri_5  (rece_llr_intri_5),
		.rece_llr_intri_6  (rece_llr_intri_6),
		.rece_llr_intri_7  (rece_llr_intri_7),
		.rece_llr_intri_8  (rece_llr_intri_8),
		.rece_llr_intri_9  (rece_llr_intri_9),
		.rece_llr_intri_10 (rece_llr_intri_10),
		.rece_llr_intri_11 (rece_llr_intri_11),
		.rece_llr_intri_12 (rece_llr_intri_12),
		.rece_llr_intri_13 (rece_llr_intri_13),
		.rece_llr_intri_14 (rece_llr_intri_14),
		.rece_llr_intri_15 (rece_llr_intri_15),
		.rece_llr_intri_16 (rece_llr_intri_16),
		.rece_llr_intri_17 (rece_llr_intri_17),
		.rece_llr_intri_18 (rece_llr_intri_18),
		.rece_llr_intri_19 (rece_llr_intri_19),
		.rece_llr_intri_20 (rece_llr_intri_20),
		.rece_llr_intri_21 (rece_llr_intri_21),
		.rece_llr_intri_22 (rece_llr_intri_22),
		.rece_llr_intri_23 (rece_llr_intri_23),
		.llr_sign          (llr_sign)
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
        #reset_time;
        rst_n = 1'b0;
        #reset_time;
        rst_n = 1'b1;
    end
endtask

task initial_llr_intrisic;
	integer i;
	begin
		in_info_wren <= 1'b1;
		for (i = 0; i < GF_base; i = i + 1) begin
			rece_llr_intri_0  <= llr_in_0 [i];
			rece_llr_intri_1  <= llr_in_1 [i];
			rece_llr_intri_2  <= llr_in_2 [i];
			rece_llr_intri_3  <= llr_in_3 [i];
			rece_llr_intri_4  <= llr_in_4 [i];
			rece_llr_intri_5  <= llr_in_5 [i];
			rece_llr_intri_6  <= llr_in_6 [i];
			rece_llr_intri_7  <= llr_in_7 [i];
			rece_llr_intri_8  <= llr_in_8 [i];
			rece_llr_intri_9  <= llr_in_9 [i];
			rece_llr_intri_10 <= llr_in_10[i];
			rece_llr_intri_11 <= llr_in_11[i];
			rece_llr_intri_12 <= llr_in_12[i];
			rece_llr_intri_13 <= llr_in_13[i];
			rece_llr_intri_14 <= llr_in_14[i];
			rece_llr_intri_15 <= llr_in_15[i];
			rece_llr_intri_16 <= llr_in_16[i];
			rece_llr_intri_17 <= llr_in_17[i];
			rece_llr_intri_18 <= llr_in_18[i];
			rece_llr_intri_19 <= llr_in_19[i];
			rece_llr_intri_20 <= llr_in_20[i];
			rece_llr_intri_21 <= llr_in_21[i];
			rece_llr_intri_22 <= llr_in_22[i];
			rece_llr_intri_23 <= llr_in_23[i];
			@(posedge clk);
		end
		in_info_wren <= 1'b0;
	end
endtask

task start_dec();
	begin
		ini_st = 1'b1;
		repeat (2) @(posedge clk);
		ini_st = 1'b0;
	end
endtask

// 读取文件内容到虚拟 rom 中
initial begin
	$readmemb("./testcase/llr_in_0.txt",  llr_in_0 );
	$readmemb("./testcase/llr_in_1.txt",  llr_in_1 );
	$readmemb("./testcase/llr_in_2.txt",  llr_in_2 );
	$readmemb("./testcase/llr_in_3.txt",  llr_in_3 );
	$readmemb("./testcase/llr_in_4.txt",  llr_in_4 );
	$readmemb("./testcase/llr_in_5.txt",  llr_in_5 );
	$readmemb("./testcase/llr_in_6.txt",  llr_in_6 );
	$readmemb("./testcase/llr_in_7.txt",  llr_in_7 );
	$readmemb("./testcase/llr_in_8.txt",  llr_in_8 );
	$readmemb("./testcase/llr_in_9.txt",  llr_in_9 );
	$readmemb("./testcase/llr_in_10.txt", llr_in_10);
	$readmemb("./testcase/llr_in_11.txt", llr_in_11);
	$readmemb("./testcase/llr_in_12.txt", llr_in_12);
	$readmemb("./testcase/llr_in_13.txt", llr_in_13);
	$readmemb("./testcase/llr_in_14.txt", llr_in_14);
	$readmemb("./testcase/llr_in_15.txt", llr_in_15);
	$readmemb("./testcase/llr_in_16.txt", llr_in_16);
	$readmemb("./testcase/llr_in_17.txt", llr_in_17);
	$readmemb("./testcase/llr_in_18.txt", llr_in_18);
	$readmemb("./testcase/llr_in_19.txt", llr_in_19);
	$readmemb("./testcase/llr_in_20.txt", llr_in_20);
	$readmemb("./testcase/llr_in_21.txt", llr_in_21);
	$readmemb("./testcase/llr_in_22.txt", llr_in_22);
	$readmemb("./testcase/llr_in_23.txt", llr_in_23);
end

initial begin
	ini_st = 1'b0;
	en = 1'b0;
	in_info_wren = 1'b0;

	sys_reset(100);
	initial_llr_intrisic();
	// 启动译码器
	start_dec();
	repeat (loop_size*20) @(posedge clk);
	$stop;
end

endmodule
