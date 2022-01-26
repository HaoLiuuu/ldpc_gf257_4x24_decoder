// =============================================================================
// @File         :  ldpc_vpu.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/10 16:49:09
// @Description  :  4x24 ldpc vpu
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/10 16:49:09 | original
// =============================================================================

module ldpc_vpu #(
    parameter COL_WEIGHT = 4,   // col weight in H matrix, use 6 in this doubly-code
    parameter LLR_WIDTH  = 8,   // LLR value width, by default using 8 bit 
    parameter VN_STAGE   = 2
)(
    input clk,
    input rst_n,
    input en,

    input [LLR_WIDTH-1:0] llr_intri, // intrinsic message

    input [LLR_WIDTH-1:0] llr_in_0,
    input [LLR_WIDTH-1:0] llr_in_1, //! 输入外信息
    input [LLR_WIDTH-1:0] llr_in_2,
    input [LLR_WIDTH-1:0] llr_in_3,

    output reg [LLR_WIDTH-1:0] llr_out_0,
    output reg [LLR_WIDTH-1:0] llr_out_1,
    output reg [LLR_WIDTH-1:0] llr_out_2,
    output reg [LLR_WIDTH-1:0] llr_out_3,

    output reg [LLR_WIDTH-1:0] llr_all
);

genvar i;

// =============================================================================
//                          对输入数据寄存 VN_STAGE 次
// =============================================================================
reg [LLR_WIDTH-1:0] reg_llr_in_0 [VN_STAGE-1:0];
reg [LLR_WIDTH-1:0] reg_llr_in_1 [VN_STAGE-1:0];
reg [LLR_WIDTH-1:0] reg_llr_in_2 [VN_STAGE-1:0];
reg [LLR_WIDTH-1:0] reg_llr_in_3 [VN_STAGE-1:0];

always @(posedge clk) begin
	reg_llr_in_0[0] <= llr_in_0;
	reg_llr_in_1[0] <= llr_in_1;
	reg_llr_in_2[0] <= llr_in_2;
	reg_llr_in_3[0] <= llr_in_3;
end

generate
    for ( i = 1; i < VN_STAGE; i = i + 1 ) begin : reg_llr_in
        always @(posedge clk) begin
            reg_llr_in_0[i] <= reg_llr_in_0[i-1];
            reg_llr_in_1[i] <= reg_llr_in_1[i-1];
            reg_llr_in_2[i] <= reg_llr_in_2[i-1];
            reg_llr_in_3[i] <= reg_llr_in_3[i-1];
        end
    end
endgenerate

// =============================================================================
//                          四数之和
// 2022/1/10 17:29:12
// 		是否需要考虑扩宽中间变量的宽度，减小误差？
// 		我想这是有必要的
// =============================================================================

wire signed [LLR_WIDTH:0] sum_0_1;
wire signed [LLR_WIDTH:0] sum_2_3;
reg [LLR_WIDTH:0] reg_sum_01;
reg [LLR_WIDTH:0] reg_sum_23;

assign sum_0_1 = $signed(llr_in_0) + $signed(llr_in_1);
assign sum_2_3 = $signed(llr_in_2) + $signed(llr_in_3);

always @(posedge clk) begin
	reg_sum_01 <= sum_0_1;
	reg_sum_23 <= sum_2_3;
end

// --- 加入 intrinsic message
// reg_sum_2nd 其实就是扩展之后的 llr_all

wire signed [LLR_WIDTH+2:0] sum_2nd;
reg [LLR_WIDTH+2:0] reg_sum_2nd;
assign sum_2nd = $signed(reg_sum_01) + $signed(reg_sum_23) + $signed(llr_intri);

always @(posedge clk) begin
	reg_sum_2nd <= sum_2nd;
end

// --- 开始输出信息
wire [LLR_WIDTH-1:0] reg_ok_llr_0 = reg_llr_in_0[VN_STAGE-1];
wire [LLR_WIDTH-1:0] reg_ok_llr_1 = reg_llr_in_1[VN_STAGE-1];
wire [LLR_WIDTH-1:0] reg_ok_llr_2 = reg_llr_in_2[VN_STAGE-1];
wire [LLR_WIDTH-1:0] reg_ok_llr_3 = reg_llr_in_3[VN_STAGE-1];

wire signed [LLR_WIDTH+1:0] llr_out_0_pre = $signed(reg_sum_2nd) - $signed(reg_ok_llr_0);
wire signed [LLR_WIDTH+1:0] llr_out_1_pre = $signed(reg_sum_2nd) - $signed(reg_ok_llr_1);
wire signed [LLR_WIDTH+1:0] llr_out_2_pre = $signed(reg_sum_2nd) - $signed(reg_ok_llr_2);
wire signed [LLR_WIDTH+1:0] llr_out_3_pre = $signed(reg_sum_2nd) - $signed(reg_ok_llr_3);

// =============================================================================
//                          输出
// 2022/1/10 19:26:12
// 		增加了溢出判断，反正都要做溢出判断的话，为何不试试 S-M 格式呢？
// =============================================================================

always @(posedge clk) begin
	if (~llr_out_0_pre[LLR_WIDTH+1] & (llr_out_0_pre[LLR_WIDTH] | llr_out_0_pre[LLR_WIDTH-1])) // + overflow
		llr_out_0 <= {1'b0, {(LLR_WIDTH-1){1'b1}}};
	else if (llr_out_0_pre[LLR_WIDTH+1] & ~(llr_out_0_pre[LLR_WIDTH] & llr_out_0_pre[LLR_WIDTH-1])) // - overflow
		llr_out_0 <= {1'b1, {(LLR_WIDTH-1){1'b0}}};
	else
		llr_out_0 <= llr_out_0_pre[LLR_WIDTH-1:0];
end

always @(posedge clk) begin
	if (~llr_out_1_pre[LLR_WIDTH+1] & (llr_out_1_pre[LLR_WIDTH] | llr_out_1_pre[LLR_WIDTH-1])) // + overflow
		llr_out_1 <= {1'b0, {(LLR_WIDTH-1){1'b1}}};
	else if (llr_out_1_pre[LLR_WIDTH+1] & ~(llr_out_1_pre[LLR_WIDTH] & llr_out_1_pre[LLR_WIDTH-1])) // - overflow
		llr_out_1 <= {1'b1, {(LLR_WIDTH-1){1'b0}}};
	else
		llr_out_1 <= llr_out_1_pre[LLR_WIDTH-1:0];
end

always @(posedge clk) begin
	if (~llr_out_2_pre[LLR_WIDTH+1] & (llr_out_2_pre[LLR_WIDTH] | llr_out_2_pre[LLR_WIDTH-1])) // + overflow
		llr_out_2 <= {1'b0, {(LLR_WIDTH-1){1'b1}}};
	else if (llr_out_2_pre[LLR_WIDTH+1] & ~(llr_out_2_pre[LLR_WIDTH] & llr_out_2_pre[LLR_WIDTH-1])) // - overflow
		llr_out_2 <= {1'b1, {(LLR_WIDTH-1){1'b0}}};
	else
		llr_out_2 <= llr_out_2_pre[LLR_WIDTH-1:0];
end

always @(posedge clk) begin
	if (~llr_out_3_pre[LLR_WIDTH+1] & (llr_out_3_pre[LLR_WIDTH] | llr_out_3_pre[LLR_WIDTH-1])) // + overflow
		llr_out_3 <= {1'b0, {(LLR_WIDTH-1){1'b1}}};
	else if (llr_out_3_pre[LLR_WIDTH+1] & ~(llr_out_3_pre[LLR_WIDTH] & llr_out_3_pre[LLR_WIDTH-1])) // - overflow
		llr_out_3 <= {1'b1, {(LLR_WIDTH-1){1'b0}}};
	else
		llr_out_3 <= llr_out_3_pre[LLR_WIDTH-1:0];
end

// llr_all
always @(posedge clk) begin
	// if (~reg_sum_2nd[LLR_WIDTH+1] & reg_sum_2nd[LLR_WIDTH]) // + overflow
	// 	llr_all <= {1'b0, {(LLR_WIDTH-1){1'b1}}};
	// else if (reg_sum_2nd[LLR_WIDTH+1] & ~reg_sum_2nd[LLR_WIDTH]) // - overflow
	// 	llr_all <= {1'b1, {(LLR_WIDTH-1){1'b0}}};
	// else
	llr_all <= reg_sum_2nd[LLR_WIDTH+2:3];
end

endmodule
