// =============================================================================
// @File         :  tb_controller.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/20 10:30:54
// @Description  :  testbench for controller
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/20 10:30:54 | original
// =============================================================================

`timescale 1ns/100ps
`define PERIOD 20
module tb_controller ();

localparam ADDR_WIDTH = 8;

reg clk;
reg ini_st;
reg rst_n;
wire initial_on;
wire vpu_on;
wire cpu_on;


wire vpu_rd_addr_en;
wire vpu_wr_addr_en;
wire cpu_wr_addr_en;

wire llr_ram_rden;
wire llr_ram_wren;
wire in_info_rden;


controller #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) inst_controller (
        .clk            (clk),
        .ini_st         (ini_st),
        .rst_n          (rst_n),
        .initial_on     (initial_on),
        .vpu_on         (vpu_on),
        .cpu_on         (cpu_on),
        .vpu_rd_addr_en (vpu_rd_addr_en),
        .vpu_wr_addr_en (vpu_wr_addr_en),
        .cpu_wr_addr_en (cpu_wr_addr_en),
        .llr_ram_rden   (llr_ram_rden),
        .llr_ram_wren   (llr_ram_wren),
        .in_info_rden   (in_info_rden)
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


initial begin
    rst_n = 1'b1;
    ini_st = 1'b0;
    sys_reset(100); // 复位 100ns
    ini_st = 1'b1;
    repeat (2) @(posedge clk);
    ini_st = 1'b0;
    repeat (1000) @(posedge clk);
    $stop;
end

// initial begin
//     // when quit -sim, all data are writen into file
//     $dumpfile("wave_out.vcd");
//     $dumpvars;
// end

endmodule