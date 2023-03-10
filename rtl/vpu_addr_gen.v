// =============================================================================
// @File         :  vpu_addr_gen.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/18 11:48:36
// @Description  :  addr generator for VPU
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/18 11:48:36 | original
// =============================================================================

module vpu_addr_gen #(
	parameter ADDR_WIDTH = 8
)(
	input clk,    // Clock
	input en,
	input rst_n,  // Asynchronous reset active low
	
	output reg [ADDR_WIDTH-1:0] vpu_addr_0 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_1 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_2 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_3 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_4 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_5 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_6 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_7 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_8 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_9 ,
	output reg [ADDR_WIDTH-1:0] vpu_addr_10,
	output reg [ADDR_WIDTH-1:0] vpu_addr_11,
	output reg [ADDR_WIDTH-1:0] vpu_addr_12,
	output reg [ADDR_WIDTH-1:0] vpu_addr_13,
	output reg [ADDR_WIDTH-1:0] vpu_addr_14,
	output reg [ADDR_WIDTH-1:0] vpu_addr_15,
	output reg [ADDR_WIDTH-1:0] vpu_addr_16,
	output reg [ADDR_WIDTH-1:0] vpu_addr_17,
	output reg [ADDR_WIDTH-1:0] vpu_addr_18,
	output reg [ADDR_WIDTH-1:0] vpu_addr_19,
	output reg [ADDR_WIDTH-1:0] vpu_addr_20,
	output reg [ADDR_WIDTH-1:0] vpu_addr_21,
	output reg [ADDR_WIDTH-1:0] vpu_addr_22,
	output reg [ADDR_WIDTH-1:0] vpu_addr_23,

	output reg [ADDR_WIDTH-1:0] vpu_addr_0_appd,
	output reg [ADDR_WIDTH-1:0] vpu_addr_1_appd,
	output reg [ADDR_WIDTH-1:0] vpu_addr_2_appd
);

localparam  row_start_0  = 9;
localparam  row_start_1  = 72;
localparam  row_start_2  = 177;
localparam  row_start_3  = 47;
localparam  row_start_4  = 198;
localparam  row_start_5  = 97;
localparam  row_start_6  = 94;
localparam  row_start_7  = 212;
localparam  row_start_8  = 30;
localparam  row_start_9  = 247;
localparam  row_start_10 = 10;
localparam  row_start_11 = 189;
localparam  row_start_12 = 126;
localparam  row_start_13 = 18;
localparam  row_start_14 = 84;
localparam  row_start_15 = 57;
localparam  row_start_16 = 70;
localparam  row_start_17 = 36;
localparam  row_start_18 = 101;
localparam  row_start_19 = 42;
localparam  row_start_20 = 246;
localparam  row_start_21 = 35;
localparam  row_start_22 = 125;
localparam  row_start_23 = 106;

localparam  row_start_0_appd = 102;
localparam  row_start_1_appd = 112;
localparam  row_start_2_appd = 208;

// ???????????????????????????

// =============================================================================
//                          vpu addr generator
// =============================================================================
// ???????????????????????????????????????????????????????????????????????????????????????????????????

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_0 <= vpu_addr_0 + 1'b1;
	end
	else
		vpu_addr_0 <= row_start_0;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_1 <= vpu_addr_1 + 1'b1;
	end
	else
		vpu_addr_1 <= row_start_1;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_2 <= vpu_addr_2 + 1'b1;
	end
	else
		vpu_addr_2 <= row_start_2;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_3 <= vpu_addr_3 + 1'b1;
	end
	else
		vpu_addr_3 <= row_start_3;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_4 <= vpu_addr_4 + 1'b1;
	end
	else
		vpu_addr_4 <= row_start_4;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_5 <= vpu_addr_5 + 1'b1;
	end
	else
		vpu_addr_5 <= row_start_5;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_6 <= vpu_addr_6 + 1'b1;
	end
	else
		vpu_addr_6 <= row_start_6;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_7 <= vpu_addr_7 + 1'b1;
	end
	else
		vpu_addr_7 <= row_start_7;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_8 <= vpu_addr_8 + 1'b1;
	end
	else
		vpu_addr_8 <= row_start_8;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_9 <= vpu_addr_9 + 1'b1;
	end
	else
		vpu_addr_9 <= row_start_9;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_10 <= vpu_addr_10 + 1'b1;
	end
	else
		vpu_addr_10 <= row_start_10;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_11 <= vpu_addr_11 + 1'b1;
	end
	else
		vpu_addr_11 <= row_start_11;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_12 <= vpu_addr_12 + 1'b1;
	end
	else
		vpu_addr_12 <= row_start_12;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_13 <= vpu_addr_13 + 1'b1;
	end
	else
		vpu_addr_13 <= row_start_13;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_14 <= vpu_addr_14 + 1'b1;
	end
	else
		vpu_addr_14 <= row_start_14;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_15 <= vpu_addr_15 + 1'b1;
	end
	else
		vpu_addr_15 <= row_start_15;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_16 <= vpu_addr_16 + 1'b1;
	end
	else
		vpu_addr_16 <= row_start_16;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_17 <= vpu_addr_17 + 1'b1;
	end
	else
		vpu_addr_17 <= row_start_17;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_18 <= vpu_addr_18 + 1'b1;
	end
	else
		vpu_addr_18 <= row_start_18;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_19 <= vpu_addr_19 + 1'b1;
	end
	else
		vpu_addr_19 <= row_start_19;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_20 <= vpu_addr_20 + 1'b1;
	end
	else
		vpu_addr_20 <= row_start_20;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_21 <= vpu_addr_21 + 1'b1;
	end
	else
		vpu_addr_21 <= row_start_21;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_22 <= vpu_addr_22 + 1'b1;
	end
	else
		vpu_addr_22 <= row_start_22;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_23 <= vpu_addr_23 + 1'b1;
	end
	else
		vpu_addr_23 <= row_start_23;
end

// appd gen

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_0_appd <= vpu_addr_0_appd + 1'b1;
	end
	else
		vpu_addr_0_appd <= row_start_0_appd;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_1_appd <= vpu_addr_1_appd + 1'b1;
	end
	else
		vpu_addr_1_appd <= row_start_1_appd;
end

always @(posedge clk) begin
	if (en == 1'b1)  begin
		vpu_addr_2_appd <= vpu_addr_2_appd + 1'b1;
	end
	else
		vpu_addr_2_appd <= row_start_2_appd;
end

endmodule


