//==============================================================================
// @file:    tb_ldpc_cpu.v
// @Arthor:  Li Jiangxuan
// @date:    2020/12/14 20:43:26
// @des:     check node processing unit testbench
//==============================================================================

`timescale 1us/1us
`define PERIOD 20

module tb_ldpc_cpu ();

reg clk     ;
reg rst_n   ;
reg en      ;

localparam LLR_WIDTH  = 8,
       ROW_WEIGHT = 24;

reg  [LLR_WIDTH-1:0] llr_in  [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] llr_out [ROW_WEIGHT-1:0];

wire [LLR_WIDTH-2:0] min;
wire [LLR_WIDTH-2:0] submin;

ldpc_cpu #(
    .LLR_WIDTH(LLR_WIDTH),
    .ROW_WEIGHT(ROW_WEIGHT)
) inst_ldpc_cpu (
    .clk        (clk),
    .en         (en),
    .rst_n      (rst_n),
    .llr_in_0   (llr_in[0]),
    .llr_in_1   (llr_in[1]),
    .llr_in_2   (llr_in[2]),
    .llr_in_3   (llr_in[3]),
    .llr_in_4   (llr_in[4]),
    .llr_in_5   (llr_in[5]),
    .llr_in_6   (llr_in[6]),
    .llr_in_7   (llr_in[7]),
    .llr_in_8   (llr_in[8]),
    .llr_in_9   (llr_in[9]),
    .llr_in_10  (llr_in[10]),
    .llr_in_11  (llr_in[11]),
    .llr_in_12  (llr_in[12]),
    .llr_in_13  (llr_in[13]),
    .llr_in_14  (llr_in[14]),
    .llr_in_15  (llr_in[15]),
    .llr_in_16  (llr_in[16]),
    .llr_in_17  (llr_in[17]),
    .llr_in_18  (llr_in[18]),
    .llr_in_19  (llr_in[19]),
    .llr_in_20  (llr_in[20]),
    .llr_in_21  (llr_in[21]),
    .llr_in_22  (llr_in[22]),
    .llr_in_23  (llr_in[23]),
    .min        (min),
    .submin     (submin),
    .llr_out_0  (llr_out[0]),
    .llr_out_1  (llr_out[1]),
    .llr_out_2  (llr_out[2]),
    .llr_out_3  (llr_out[3]),
    .llr_out_4  (llr_out[4]),
    .llr_out_5  (llr_out[5]),
    .llr_out_6  (llr_out[6]),
    .llr_out_7  (llr_out[7]),
    .llr_out_8  (llr_out[8]),
    .llr_out_9  (llr_out[9]),
    .llr_out_10 (llr_out[10]),
    .llr_out_11 (llr_out[11]),
    .llr_out_12 (llr_out[12]),
    .llr_out_13 (llr_out[13]),
    .llr_out_14 (llr_out[14]),
    .llr_out_15 (llr_out[15]),
    .llr_out_16 (llr_out[16]),
    .llr_out_17 (llr_out[17]),
    .llr_out_18 (llr_out[18]),
    .llr_out_19 (llr_out[19]),
    .llr_out_20 (llr_out[20]),
    .llr_out_21 (llr_out[21]),
    .llr_out_22 (llr_out[22]),
    .llr_out_23 (llr_out[23])
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
    
 //=============================================================================
 // 测试用例设计
 //=============================================================================
integer testcase_rd;    // 测试用例所在文件
integer result_wr  ;    // 写入测试结果
initial begin
    sys_reset(100);      // 复位 100 个系统时间
    // 将文件写入
    en = 1'b0;
    @(posedge clk);
    en = 1'b1;
    // #(`PERIOD*1)
    $readmemb("testcase_0.txt", llr_in);
    @(posedge clk);
    $readmemb("testcase_1.txt", llr_in);
    @(posedge clk);
    $readmemb("testcase_2.txt", llr_in);
    repeat (100) @(posedge clk);
    $stop;
end

endmodule