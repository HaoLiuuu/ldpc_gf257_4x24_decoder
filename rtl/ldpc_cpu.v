// =============================================================================
// @File         :  ldpc_cpu.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/10 14:58:08
// @Description  :  4x24 ldpc cpu
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/10 14:58:08 | original
// =============================================================================

module ldpc_cpu #(
	parameter LLR_WIDTH = 8,
	parameter ROW_WEIGHT = 24,
	parameter PIPE_DELAY = 7 // 这个值还是根据上板子的时候确定吧
)(
	input clk,    // Clock
	input en,
	input rst_n,  // Asynchronous reset active low
	
	input [LLR_WIDTH-1:0] llr_in_0,
	input [LLR_WIDTH-1:0] llr_in_1,
	input [LLR_WIDTH-1:0] llr_in_2,
	input [LLR_WIDTH-1:0] llr_in_3,
	input [LLR_WIDTH-1:0] llr_in_4,
	input [LLR_WIDTH-1:0] llr_in_5,
	input [LLR_WIDTH-1:0] llr_in_6,
	input [LLR_WIDTH-1:0] llr_in_7,
	input [LLR_WIDTH-1:0] llr_in_8,
	input [LLR_WIDTH-1:0] llr_in_9,
	input [LLR_WIDTH-1:0] llr_in_10,
	input [LLR_WIDTH-1:0] llr_in_11,
	input [LLR_WIDTH-1:0] llr_in_12,
	input [LLR_WIDTH-1:0] llr_in_13,
	input [LLR_WIDTH-1:0] llr_in_14,
	input [LLR_WIDTH-1:0] llr_in_15,
	input [LLR_WIDTH-1:0] llr_in_16,
	input [LLR_WIDTH-1:0] llr_in_17,
	input [LLR_WIDTH-1:0] llr_in_18,
	input [LLR_WIDTH-1:0] llr_in_19,
	input [LLR_WIDTH-1:0] llr_in_20,
	input [LLR_WIDTH-1:0] llr_in_21,
	input [LLR_WIDTH-1:0] llr_in_22,
	input [LLR_WIDTH-1:0] llr_in_23,

	// 观察输出的数据的端口
    output [LLR_WIDTH-2:0] min,
    output [LLR_WIDTH-2:0] submin,
    // 实际上线时应该注释掉

    output reg [LLR_WIDTH-1:0] llr_out_0 ,
    output reg [LLR_WIDTH-1:0] llr_out_1 ,
    output reg [LLR_WIDTH-1:0] llr_out_2 ,
    output reg [LLR_WIDTH-1:0] llr_out_3 ,
    output reg [LLR_WIDTH-1:0] llr_out_4 ,
    output reg [LLR_WIDTH-1:0] llr_out_5 ,
    output reg [LLR_WIDTH-1:0] llr_out_6 ,
    output reg [LLR_WIDTH-1:0] llr_out_7 ,
    output reg [LLR_WIDTH-1:0] llr_out_8 ,
    output reg [LLR_WIDTH-1:0] llr_out_9 ,
    output reg [LLR_WIDTH-1:0] llr_out_10,
    output reg [LLR_WIDTH-1:0] llr_out_11,
    output reg [LLR_WIDTH-1:0] llr_out_12,
    output reg [LLR_WIDTH-1:0] llr_out_13,
    output reg [LLR_WIDTH-1:0] llr_out_14,
    output reg [LLR_WIDTH-1:0] llr_out_15,
    output reg [LLR_WIDTH-1:0] llr_out_16,
    output reg [LLR_WIDTH-1:0] llr_out_17,
    output reg [LLR_WIDTH-1:0] llr_out_18,
    output reg [LLR_WIDTH-1:0] llr_out_19,
    output reg [LLR_WIDTH-1:0] llr_out_20,
    output reg [LLR_WIDTH-1:0] llr_out_21,
    output reg [LLR_WIDTH-1:0] llr_out_22,
    output reg [LLR_WIDTH-1:0] llr_out_23
);

// 定义生成器变量
genvar i;

// 函数 计算输入 LLR 的绝对值
// 2021/3/22 10:48:07
// 需要针对 TMIN 做一个修正
function [LLR_WIDTH-2:0] absolute;
    input sign;
    input [LLR_WIDTH-2:0] signed_value;
    begin 
        if (sign == 1'b1 && signed_value != {(LLR_WIDTH-1){1'b0}})
            absolute = ~signed_value + 1'b1;
        else if (sign == 1'b0)
            absolute = signed_value;
        else
            absolute = {(LLR_WIDTH-1){1'b1}};
    end
endfunction


// 保存输入数据的符号
wire [ROW_WEIGHT-1:0] llr_in_sign;
assign llr_in_sign[0 ] = llr_in_0[LLR_WIDTH-1 ];
assign llr_in_sign[1 ] = llr_in_1[LLR_WIDTH-1 ];
assign llr_in_sign[2 ] = llr_in_2[LLR_WIDTH-1 ];
assign llr_in_sign[3 ] = llr_in_3[LLR_WIDTH-1 ];
assign llr_in_sign[4 ] = llr_in_4[LLR_WIDTH-1 ];
assign llr_in_sign[5 ] = llr_in_5[LLR_WIDTH-1 ];
assign llr_in_sign[6 ] = llr_in_6[LLR_WIDTH-1 ];
assign llr_in_sign[7 ] = llr_in_7[LLR_WIDTH-1 ];
assign llr_in_sign[8 ] = llr_in_8[LLR_WIDTH-1 ];
assign llr_in_sign[9 ] = llr_in_9[LLR_WIDTH-1 ];
assign llr_in_sign[10] = llr_in_10[LLR_WIDTH-1];
assign llr_in_sign[11] = llr_in_11[LLR_WIDTH-1];
assign llr_in_sign[12] = llr_in_12[LLR_WIDTH-1];
assign llr_in_sign[13] = llr_in_13[LLR_WIDTH-1];
assign llr_in_sign[14] = llr_in_14[LLR_WIDTH-1];
assign llr_in_sign[15] = llr_in_15[LLR_WIDTH-1];
assign llr_in_sign[16] = llr_in_16[LLR_WIDTH-1];
assign llr_in_sign[17] = llr_in_17[LLR_WIDTH-1];
assign llr_in_sign[18] = llr_in_18[LLR_WIDTH-1];
assign llr_in_sign[19] = llr_in_19[LLR_WIDTH-1];
assign llr_in_sign[20] = llr_in_20[LLR_WIDTH-1];
assign llr_in_sign[21] = llr_in_21[LLR_WIDTH-1];
assign llr_in_sign[22] = llr_in_22[LLR_WIDTH-1];
assign llr_in_sign[23] = llr_in_23[LLR_WIDTH-1];

// 保存输入数据的绝对值
// 弄到 array 中，方便使用 generate 语句
wire [LLR_WIDTH-2:0] llr_in_reg [ROW_WEIGHT-1:0];
assign llr_in_reg[0]  = absolute(llr_in_sign[0 ], llr_in_0[LLR_WIDTH-2:0 ]);
assign llr_in_reg[1]  = absolute(llr_in_sign[1 ], llr_in_1[LLR_WIDTH-2:0 ]);
assign llr_in_reg[2]  = absolute(llr_in_sign[2 ], llr_in_2[LLR_WIDTH-2:0 ]);
assign llr_in_reg[3]  = absolute(llr_in_sign[3 ], llr_in_3[LLR_WIDTH-2:0 ]);
assign llr_in_reg[4]  = absolute(llr_in_sign[4 ], llr_in_4[LLR_WIDTH-2:0 ]);
assign llr_in_reg[5]  = absolute(llr_in_sign[5 ], llr_in_5[LLR_WIDTH-2:0 ]);
assign llr_in_reg[6]  = absolute(llr_in_sign[6 ], llr_in_6[LLR_WIDTH-2:0 ]);
assign llr_in_reg[7]  = absolute(llr_in_sign[7 ], llr_in_7[LLR_WIDTH-2:0 ]);
assign llr_in_reg[8]  = absolute(llr_in_sign[8 ], llr_in_8[LLR_WIDTH-2:0 ]);
assign llr_in_reg[9]  = absolute(llr_in_sign[9 ], llr_in_9[LLR_WIDTH-2:0 ]);
assign llr_in_reg[10] = absolute(llr_in_sign[10], llr_in_10[LLR_WIDTH-2:0]);
assign llr_in_reg[11] = absolute(llr_in_sign[11], llr_in_11[LLR_WIDTH-2:0]);
assign llr_in_reg[12] = absolute(llr_in_sign[12], llr_in_12[LLR_WIDTH-2:0]);
assign llr_in_reg[13] = absolute(llr_in_sign[13], llr_in_13[LLR_WIDTH-2:0]);
assign llr_in_reg[14] = absolute(llr_in_sign[14], llr_in_14[LLR_WIDTH-2:0]);
assign llr_in_reg[15] = absolute(llr_in_sign[15], llr_in_15[LLR_WIDTH-2:0]);
assign llr_in_reg[16] = absolute(llr_in_sign[16], llr_in_16[LLR_WIDTH-2:0]);
assign llr_in_reg[17] = absolute(llr_in_sign[17], llr_in_17[LLR_WIDTH-2:0]);
assign llr_in_reg[18] = absolute(llr_in_sign[18], llr_in_18[LLR_WIDTH-2:0]);
assign llr_in_reg[19] = absolute(llr_in_sign[19], llr_in_19[LLR_WIDTH-2:0]);
assign llr_in_reg[20] = absolute(llr_in_sign[20], llr_in_20[LLR_WIDTH-2:0]);
assign llr_in_reg[21] = absolute(llr_in_sign[21], llr_in_21[LLR_WIDTH-2:0]);
assign llr_in_reg[22] = absolute(llr_in_sign[22], llr_in_22[LLR_WIDTH-2:0]);
assign llr_in_reg[23] = absolute(llr_in_sign[23], llr_in_23[LLR_WIDTH-2:0]);

// =============================================================================
//                          寄存输入信号
// =============================================================================
reg [ROW_WEIGHT-1:0] reg_llr_in_sign [PIPE_DELAY:0];
wire xor_sign = ^llr_in_sign;

always @(posedge clk) begin
    if (en) begin
    	reg_llr_in_sign[0] <= {
    		xor_sign^llr_in_sign[23],
    		xor_sign^llr_in_sign[22],
    		xor_sign^llr_in_sign[21],
    		xor_sign^llr_in_sign[20],
    		xor_sign^llr_in_sign[19],
    		xor_sign^llr_in_sign[18],
    		xor_sign^llr_in_sign[17],
    		xor_sign^llr_in_sign[16],
    		xor_sign^llr_in_sign[15],
    		xor_sign^llr_in_sign[14],
    		xor_sign^llr_in_sign[13],
    		xor_sign^llr_in_sign[12],
    		xor_sign^llr_in_sign[11],
    		xor_sign^llr_in_sign[10],
    		xor_sign^llr_in_sign[9],
    		xor_sign^llr_in_sign[8],
    		xor_sign^llr_in_sign[7],
    		xor_sign^llr_in_sign[6],
    		xor_sign^llr_in_sign[5],
    		xor_sign^llr_in_sign[4],
    		xor_sign^llr_in_sign[3],
    		xor_sign^llr_in_sign[2],
    		xor_sign^llr_in_sign[1],
    		xor_sign^llr_in_sign[0]
    	};
	end
end

generate
    for (i = 1; i <= PIPE_DELAY; i = i + 1) begin : reg_llr_sign
        always @(posedge clk) begin 
            reg_llr_in_sign[i] <= reg_llr_in_sign[i-1];
        end 
    end
endgenerate


// =============================================================================
//                          寄存输入信号的绝对值
// 为了数据的延迟对齐
// 这种直接使用 D 触发器的延迟方法是否可以使用一个存储器进行替换
// =============================================================================
reg [LLR_WIDTH-2:0] reg_llr_in_0_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_1_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_2_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_3_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_4_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_5_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_6_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_7_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_8_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_9_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_10_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_11_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_12_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_13_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_14_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_15_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_16_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_17_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_18_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_19_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_20_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_21_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_22_abs [PIPE_DELAY-1:0];
reg [LLR_WIDTH-2:0] reg_llr_in_23_abs [PIPE_DELAY-1:0];

always @(posedge clk) begin 
    reg_llr_in_0_abs [0] <= llr_in_reg[0];
    reg_llr_in_1_abs [0] <= llr_in_reg[1];
    reg_llr_in_2_abs [0] <= llr_in_reg[2];
    reg_llr_in_3_abs [0] <= llr_in_reg[3];
    reg_llr_in_4_abs [0] <= llr_in_reg[4];
    reg_llr_in_5_abs [0] <= llr_in_reg[5];
    reg_llr_in_6_abs [0] <= llr_in_reg[6];
    reg_llr_in_7_abs [0] <= llr_in_reg[7];
    reg_llr_in_8_abs [0] <= llr_in_reg[8];
    reg_llr_in_9_abs [0] <= llr_in_reg[9];
    reg_llr_in_10_abs[0] <= llr_in_reg[10];
    reg_llr_in_11_abs[0] <= llr_in_reg[11];
    reg_llr_in_12_abs[0] <= llr_in_reg[12];
    reg_llr_in_13_abs[0] <= llr_in_reg[13];
    reg_llr_in_14_abs[0] <= llr_in_reg[14];
    reg_llr_in_15_abs[0] <= llr_in_reg[15];
    reg_llr_in_16_abs[0] <= llr_in_reg[16];
    reg_llr_in_17_abs[0] <= llr_in_reg[17];
    reg_llr_in_18_abs[0] <= llr_in_reg[18];
    reg_llr_in_19_abs[0] <= llr_in_reg[19];
    reg_llr_in_20_abs[0] <= llr_in_reg[20];
    reg_llr_in_21_abs[0] <= llr_in_reg[21];
    reg_llr_in_22_abs[0] <= llr_in_reg[22];
    reg_llr_in_23_abs[0] <= llr_in_reg[23];
end

generate
    for (i = 1; i < PIPE_DELAY; i = i + 1) begin : reg_llr_in_abs_0
        always @(posedge clk) begin 
            reg_llr_in_0_abs[i]  <= reg_llr_in_0_abs[i-1];
            reg_llr_in_1_abs[i]  <= reg_llr_in_1_abs[i-1];
            reg_llr_in_2_abs[i]  <= reg_llr_in_2_abs[i-1];
            reg_llr_in_3_abs[i]  <= reg_llr_in_3_abs[i-1];
            reg_llr_in_4_abs[i]  <= reg_llr_in_4_abs[i-1];
            reg_llr_in_5_abs[i]  <= reg_llr_in_5_abs[i-1];
            reg_llr_in_6_abs[i]  <= reg_llr_in_6_abs[i-1];
            reg_llr_in_7_abs[i]  <= reg_llr_in_7_abs[i-1];
            reg_llr_in_8_abs[i]  <= reg_llr_in_8_abs[i-1];
            reg_llr_in_9_abs[i]  <= reg_llr_in_9_abs[i-1];
            reg_llr_in_10_abs[i] <= reg_llr_in_10_abs[i-1];
            reg_llr_in_11_abs[i] <= reg_llr_in_11_abs[i-1];
            reg_llr_in_12_abs[i] <= reg_llr_in_12_abs[i-1];
            reg_llr_in_13_abs[i] <= reg_llr_in_13_abs[i-1];
            reg_llr_in_14_abs[i] <= reg_llr_in_14_abs[i-1];
            reg_llr_in_15_abs[i] <= reg_llr_in_15_abs[i-1];
            reg_llr_in_16_abs[i] <= reg_llr_in_16_abs[i-1];
            reg_llr_in_17_abs[i] <= reg_llr_in_17_abs[i-1];
            reg_llr_in_18_abs[i] <= reg_llr_in_18_abs[i-1];
            reg_llr_in_19_abs[i] <= reg_llr_in_19_abs[i-1];
            reg_llr_in_20_abs[i] <= reg_llr_in_20_abs[i-1];
            reg_llr_in_21_abs[i] <= reg_llr_in_21_abs[i-1];
            reg_llr_in_22_abs[i] <= reg_llr_in_22_abs[i-1];
            reg_llr_in_23_abs[i] <= reg_llr_in_23_abs[i-1];
        end
    end // reg_llr_in_abs_0
endgenerate

// =============================================================================
//                          1st-stage pipeline
// =============================================================================
localparam A_STAGE_SIG_HALF = ROW_WEIGHT / 3; // 8
// 定义一级流水的输出端口 as_min = first stage output min
wire [LLR_WIDTH-2:0] as_min         [A_STAGE_SIG_HALF-1:0];
wire [LLR_WIDTH-2:0] as_submin      [A_STAGE_SIG_HALF-1:0];
// 一级流水寄存
reg  [LLR_WIDTH-2:0] reg_as_min     [A_STAGE_SIG_HALF-1:0];
reg  [LLR_WIDTH-2:0] reg_as_submin  [A_STAGE_SIG_HALF-1:0];

generate
    for (i = 0; i < A_STAGE_SIG_HALF; i = i + 1) begin : a_stage
        comp3in2out #(
                .WIDTH(LLR_WIDTH-1)
            ) inst_comp3in2out (
                .in_1     (llr_in_reg[i*3])  ,
                .in_2     (llr_in_reg[i*3+1]),
                .in_3     (llr_in_reg[i*3+2]),
                .min_v    (as_min[i])        , // 这里默认是整除了 需要验证下
                .submin_v (as_submin[i])
            );
    end
endgenerate
// reg out
// TODO add enable signal to control
generate
    for (i = 0; i < A_STAGE_SIG_HALF; i = i + 1) begin : a_stage_reg
        always @(posedge clk) begin
            if (en) begin 
                reg_as_min[i]       <= as_min[i];
                reg_as_submin[i]    <= as_submin[i]; 
            end
        end
    end
endgenerate

// =============================================================================
//                          2nd-stage pipeline
// =============================================================================
localparam B_STAGE_SIG_1OF3 = A_STAGE_SIG_HALF / 2; // 4
// min of 2in2out comparator
wire [LLR_WIDTH-2:0] bs_min             [B_STAGE_SIG_1OF3-1:0];
// submin of 2in2out comparator
wire [LLR_WIDTH-2:0] bs_submin_2out     [B_STAGE_SIG_1OF3-1:0];
// submin of 2in1out comparator
wire [LLR_WIDTH-2:0] bs_submin_1out     [B_STAGE_SIG_1OF3-1:0];
// reg output
reg  [LLR_WIDTH-2:0] reg_bs_min         [B_STAGE_SIG_1OF3-1:0];
reg  [LLR_WIDTH-2:0] reg_bs_submin_2out [B_STAGE_SIG_1OF3-1:0];
reg  [LLR_WIDTH-2:0] reg_bs_submin_1out [B_STAGE_SIG_1OF3-1:0];

// 2in2out comparator
generate
    // 2in2out comparator
    for (i = 0; i < B_STAGE_SIG_1OF3; i = i + 1) begin : b_stage_1
        comp2in2out #(
                .WIDTH(LLR_WIDTH-1)
            ) inst_comp2in2out (
                .in_1(reg_as_min[i*2])          , 
                .in_2(reg_as_min[i*2+1])        , 
                .min_v(bs_min[i])               , 
                .submin_v(bs_submin_2out[i])
            );

    end
endgenerate

// 2in1out comparator
generate
    // 2in1out comparator
    for (i = 0; i < B_STAGE_SIG_1OF3; i = i + 1) begin : b_stage_2
        assign bs_submin_1out[i] = 
            (reg_as_submin[i*2] > reg_as_submin[i*2+1]) ? 
                                  reg_as_submin[i*2+1]  :
                                  reg_as_submin[i*2]    ;
    end
endgenerate

// reg
generate
    for (i = 0; i < B_STAGE_SIG_1OF3; i = i + 1) begin : b_stage_reg
        always @(posedge clk) begin
            if (en) begin 
                reg_bs_min[i]          <= bs_min[i]        ;
                reg_bs_submin_2out[i]  <= bs_submin_2out[i];
                reg_bs_submin_1out[i]  <= bs_submin_1out[i];
            end
        end
    end
endgenerate

// =============================================================================
//                          3rd-stage pipeline
// =============================================================================
localparam C_STAGE_SIG = B_STAGE_SIG_1OF3 / 2; // 2

wire [LLR_WIDTH-2:0] cs_submin_1    [C_STAGE_SIG*2-1:0] ;
wire [LLR_WIDTH-2:0] cs_submin_2    [C_STAGE_SIG-1:0]   ;
wire [LLR_WIDTH-2:0] cs_min         [C_STAGE_SIG-1:0]   ;
// reg output
reg  [LLR_WIDTH-2:0] reg_cs_submin_1    [C_STAGE_SIG*2-1:0] ;
reg  [LLR_WIDTH-2:0] reg_cs_submin_2    [C_STAGE_SIG-1:0]   ;
reg  [LLR_WIDTH-2:0] reg_cs_min         [C_STAGE_SIG-1:0]   ;

// 2in1out comparator for cs_submin_1
generate
    for (i = 0; i < C_STAGE_SIG * 2; i = i + 1) begin : c_stage_1
        assign cs_submin_1[i] = 
                (reg_bs_submin_2out[i] > reg_bs_submin_1out[i]) ?
                                         reg_bs_submin_1out[i]  :
                                         reg_bs_submin_2out[i]  ;
    end
endgenerate

// 2in2out comparator for cs_min and cs_submin2
generate
    for (i = 0; i < C_STAGE_SIG; i = i + 1) begin : c_stage_2
        comp2in2out #(
                .WIDTH(LLR_WIDTH-1)
            ) inst_comp2in2out (
                .in_1(reg_bs_min[i*2])          , 
                .in_2(reg_bs_min[i*2+1])        , 
                .min_v(cs_min[i])               , 
                .submin_v(cs_submin_2[i])
            );
    end
endgenerate

// reg output
generate
    for (i = 0; i < C_STAGE_SIG; i = i + 1) begin : c_stage_reg
        always @(posedge clk) begin 
            if (en) begin 
                reg_cs_submin_1[i*2]        <= cs_submin_1[i*2]  ;
                reg_cs_submin_1[i*2+1]      <= cs_submin_1[i*2+1];
                reg_cs_submin_2[i]          <= cs_submin_2[i]    ;
                reg_cs_min[i]               <= cs_min[i]         ;
            end
        end
    end
endgenerate

// =============================================================================
//                          4th-stage pipeline
// =============================================================================
localparam D_STAGE_SIG = C_STAGE_SIG / 2; // 1

wire [LLR_WIDTH-2:0] ds_min             [D_STAGE_SIG-1:0];
wire [LLR_WIDTH-2:0] ds_submin_1        [C_STAGE_SIG-1:0];
wire [LLR_WIDTH-2:0] ds_submin_2        [D_STAGE_SIG-1:0];
// reg output
reg  [LLR_WIDTH-2:0] reg_ds_min         [D_STAGE_SIG-1:0];
reg  [LLR_WIDTH-2:0] reg_ds_submin_1    [C_STAGE_SIG-1:0];
reg  [LLR_WIDTH-2:0] reg_ds_submin_2    [D_STAGE_SIG-1:0];

// 3in1out comparator
generate
    // 这里的数目恰好和前一级流水的相同 ！！！需要注意
    for (i = 0; i < C_STAGE_SIG ; i = i + 1) begin : d_stage_1
        comp3in1out #(
                .WIDTH(LLR_WIDTH-1)
            ) inst_comp3in1out (
                .in_1(reg_cs_submin_1[i*2])     ,
                .in_2(reg_cs_submin_2[i])       ,
                .in_3(reg_cs_submin_1[i*2+1])   ,
                .min_v(ds_submin_1[i])
            );
    end
endgenerate

// 2in2out comparator
generate
    for (i = 0; i < D_STAGE_SIG; i = i + 1) begin : d_stage_2
        comp2in2out #(
                .WIDTH(LLR_WIDTH-1)
            ) inst_comp2in2out (
                .in_1(reg_cs_min[i*2])      , 
                .in_2(reg_cs_min[i*2+1])    , 
                .min_v(ds_min[i])           ,
                .submin_v(ds_submin_2[i])
            );
    end
endgenerate

// reg output
generate
    for (i = 0; i < D_STAGE_SIG; i = i + 1) begin : d_stage_reg
        always @(posedge clk) begin
            if (en) begin 
                reg_ds_min[i]           <= ds_min[i]         ;
                reg_ds_submin_1[i*2]    <= ds_submin_1[i*2]  ;
                reg_ds_submin_1[i*2+1]  <= ds_submin_1[i*2+1];
                reg_ds_submin_2[i]      <= ds_submin_2[i]    ;
            end
        end
    end
endgenerate

// =============================================================================
//                          5th-stage pipeline
// =============================================================================
wire [LLR_WIDTH-2:0] final_submin       ;
reg  [LLR_WIDTH-2:0] reg_final_submin   ;
reg  [LLR_WIDTH-2:0] reg_final_min      ;

// 对最小值再进行一个延迟 以对齐
wire [LLR_WIDTH-2:0] reg_pre_min = reg_ds_min[0];

wire [LLR_WIDTH-2:0] reg_pre_submin [2:0];
assign reg_pre_submin[0] = reg_ds_submin_1[0];
assign reg_pre_submin[1] = reg_ds_submin_1[1];
assign reg_pre_submin[2] = reg_ds_submin_2[0];

comp3in1out #(
        .WIDTH(LLR_WIDTH-1)
    ) es_inst_comp3in1out (
        .in_1(reg_pre_submin[0])     ,
        .in_2(reg_pre_submin[1])     ,
        .in_3(reg_pre_submin[2])     ,
        .min_v(final_submin)
    );

always @(posedge clk) begin
	if (en) begin
		reg_final_submin <= final_submin;
		reg_final_min <= reg_pre_min;
	end
end

// =============================================================================
//                          pre output
// =============================================================================

assign min = reg_final_min;
assign submin = reg_final_submin;

// 将绝对值转换为补码
// 这个模块是不必要的，在我学到了一种新方法之后，这种方法更加显得不好
// function [LLR_WIDTH-1:0] complement;
//     input sign;
//     input [LLR_WIDTH-2:0] absolute;
//     begin
//         if (absolute == {(LLR_WIDTH-1){1'b0}}) // equal to 0, do not rely on sign
//             complement = {(LLR_WIDTH){1'b0}};
//         else if (sign)
//             complement = {1'b1, ~absolute + 1'b1};
//         else
//             complement = {1'b0, absolute};
//     end
// endfunction

//
// 这里从 符号+幅值 到 补码当的形式应该只需要做四次转换，然后再做选择
//
reg [LLR_WIDTH-1:0] pos_min;
reg [LLR_WIDTH-1:0] neg_min;
reg [LLR_WIDTH-1:0] pos_submin;
reg [LLR_WIDTH-1:0] neg_submin;
reg [LLR_WIDTH-2:0] reg_min;

always @(posedge clk) begin
    if (en) begin
        reg_min <= min;
    end
end

always @(posedge clk) begin
    if (en) begin
        pos_min <= {1'b0, min};
    end
end

always @(posedge clk) begin
    if (en) begin
        neg_min <= ~{1'b0, min} + 1'b1;
    end
end

always @(posedge clk) begin
    if (en) begin
        pos_submin <= {1'b0, submin};
    end
end

always @(posedge clk) begin
    if (en) begin
        neg_submin <= ~{1'b0, submin} + 1'b1;
    end
end

// =============================================================================
//                          output llr
// =============================================================================
always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_0_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][0 ])
                llr_out_0 <= neg_submin;
            else
                llr_out_0 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][0 ])
                llr_out_0 <= neg_min;
            else
                llr_out_0 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_1_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][1 ])
                llr_out_1 <= neg_submin;
            else
                llr_out_1 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][1 ])
                llr_out_1 <= neg_min;
            else
                llr_out_1 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_2_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][2 ])
                llr_out_2 <= neg_submin;
            else
                llr_out_2 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][2 ])
                llr_out_2 <= neg_min;
            else
                llr_out_2 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_3_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][3 ])
                llr_out_3 <= neg_submin;
            else
                llr_out_3 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][3 ])
                llr_out_3 <= neg_min;
            else
                llr_out_3 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_4_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][4 ])
                llr_out_4 <= neg_submin;
            else
                llr_out_4 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][4 ])
                llr_out_4 <= neg_min;
            else
                llr_out_4 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_5_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][5 ])
                llr_out_5 <= neg_submin;
            else
                llr_out_5 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][5 ])
                llr_out_5 <= neg_min;
            else
                llr_out_5 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_6_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][6 ])
                llr_out_6 <= neg_submin;
            else
                llr_out_6 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][6 ])
                llr_out_6 <= neg_min;
            else
                llr_out_6 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_7_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][7 ])
                llr_out_7 <= neg_submin;
            else
                llr_out_7 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][7 ])
                llr_out_7 <= neg_min;
            else
                llr_out_7 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_8_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][8 ])
                llr_out_8 <= neg_submin;
            else
                llr_out_8 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][8 ])
                llr_out_8 <= neg_min;
            else
                llr_out_8 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_9_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][9 ])
                llr_out_9 <= neg_submin;
            else
                llr_out_9 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][9 ])
                llr_out_9 <= neg_min;
            else
                llr_out_9 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_10_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][10 ])
                llr_out_10 <= neg_submin;
            else
                llr_out_10 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][10 ])
                llr_out_10 <= neg_min;
            else
                llr_out_10 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_11_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][11 ])
                llr_out_11 <= neg_submin;
            else
                llr_out_11 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][11 ])
                llr_out_11 <= neg_min;
            else
                llr_out_11 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_12_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][12 ])
                llr_out_12 <= neg_submin;
            else
                llr_out_12 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][12 ])
                llr_out_12 <= neg_min;
            else
                llr_out_12 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_13_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][13 ])
                llr_out_13 <= neg_submin;
            else
                llr_out_13 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][13 ])
                llr_out_13 <= neg_min;
            else
                llr_out_13 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_14_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][14 ])
                llr_out_14 <= neg_submin;
            else
                llr_out_14 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][14 ])
                llr_out_14 <= neg_min;
            else
                llr_out_14 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_15_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][15 ])
                llr_out_15 <= neg_submin;
            else
                llr_out_15 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][15 ])
                llr_out_15 <= neg_min;
            else
                llr_out_15 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_16_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][16 ])
                llr_out_16 <= neg_submin;
            else
                llr_out_16 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][16 ])
                llr_out_16 <= neg_min;
            else
                llr_out_16 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_17_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][17 ])
                llr_out_17 <= neg_submin;
            else
                llr_out_17 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][17 ])
                llr_out_17 <= neg_min;
            else
                llr_out_17 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_18_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][18 ])
                llr_out_18 <= neg_submin;
            else
                llr_out_18 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][18 ])
                llr_out_18 <= neg_min;
            else
                llr_out_18 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_19_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][19 ])
                llr_out_19 <= neg_submin;
            else
                llr_out_19 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][19 ])
                llr_out_19 <= neg_min;
            else
                llr_out_19 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_20_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][20 ])
                llr_out_20 <= neg_submin;
            else
                llr_out_20 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][20 ])
                llr_out_20 <= neg_min;
            else
                llr_out_20 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_21_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][21 ])
                llr_out_21 <= neg_submin;
            else
                llr_out_21 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][21 ])
                llr_out_21 <= neg_min;
            else
                llr_out_21 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_22_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][22 ])
                llr_out_22 <= neg_submin;
            else
                llr_out_22 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][22 ])
                llr_out_22 <= neg_min;
            else
                llr_out_22 <= pos_min;
        end
    end
end

always @(posedge clk) begin
    if (en) begin
        if (reg_min == reg_llr_in_23_abs[PIPE_DELAY-1]) begin
            if (reg_llr_in_sign[PIPE_DELAY-1][23 ])
                llr_out_23 <= neg_submin;
            else
                llr_out_23 <= pos_submin;
        end
        else begin
            if (reg_llr_in_sign[PIPE_DELAY-1][23 ])
                llr_out_23 <= neg_min;
            else
                llr_out_23 <= pos_min;
        end
    end
end


endmodule
