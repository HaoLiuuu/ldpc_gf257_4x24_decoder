// =============================================================================
// @File         :  cpu_addr_gen.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/18 11:54:20
// @Description  :  addr generator for CPU
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/18 11:54:20 | original
// =============================================================================

module cpu_addr_gen #( 
	parameter ADDR_WIDTH = 8
)(
	input clk,    // Clock
	input cpu_addr_ena,

	output reg [ADDR_WIDTH-1:0] cpu_addr_0 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_1 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_2 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_3 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_4 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_5 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_6 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_7 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_8 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_9 ,
	output reg [ADDR_WIDTH-1:0] cpu_addr_10,
	output reg [ADDR_WIDTH-1:0] cpu_addr_11,
	output reg [ADDR_WIDTH-1:0] cpu_addr_12,
	output reg [ADDR_WIDTH-1:0] cpu_addr_13,
	output reg [ADDR_WIDTH-1:0] cpu_addr_14,
	output reg [ADDR_WIDTH-1:0] cpu_addr_15,
	output reg [ADDR_WIDTH-1:0] cpu_addr_16,
	output reg [ADDR_WIDTH-1:0] cpu_addr_17,
	output reg [ADDR_WIDTH-1:0] cpu_addr_18,
	output reg [ADDR_WIDTH-1:0] cpu_addr_19,
	output reg [ADDR_WIDTH-1:0] cpu_addr_20,
	output reg [ADDR_WIDTH-1:0] cpu_addr_21,
	output reg [ADDR_WIDTH-1:0] cpu_addr_22,
	output reg [ADDR_WIDTH-1:0] cpu_addr_23
	
);

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_0 <= cpu_addr_0 + 1'b1;
	end
	else
		cpu_addr_0 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_1 <= cpu_addr_1 + 1'b1;
	end
	else
		cpu_addr_1 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_2 <= cpu_addr_2 + 1'b1;
	end
	else
		cpu_addr_2 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_3 <= cpu_addr_3 + 1'b1;
	end
	else
		cpu_addr_3 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_4 <= cpu_addr_4 + 1'b1;
	end
	else
		cpu_addr_4 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_5 <= cpu_addr_5 + 1'b1;
	end
	else
		cpu_addr_5 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_6 <= cpu_addr_6 + 1'b1;
	end
	else
		cpu_addr_6 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_7 <= cpu_addr_7 + 1'b1;
	end
	else
		cpu_addr_7 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_8 <= cpu_addr_8 + 1'b1;
	end
	else
		cpu_addr_8 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_9 <= cpu_addr_9 + 1'b1;
	end
	else
		cpu_addr_9 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_10 <= cpu_addr_10 + 1'b1;
	end
	else
		cpu_addr_10 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_11 <= cpu_addr_11 + 1'b1;
	end
	else
		cpu_addr_11 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_12 <= cpu_addr_12 + 1'b1;
	end
	else
		cpu_addr_12 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_13 <= cpu_addr_13 + 1'b1;
	end
	else
		cpu_addr_13 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_14 <= cpu_addr_14 + 1'b1;
	end
	else
		cpu_addr_14 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_15 <= cpu_addr_15 + 1'b1;
	end
	else
		cpu_addr_15 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_16 <= cpu_addr_16 + 1'b1;
	end
	else
		cpu_addr_16 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_17 <= cpu_addr_17 + 1'b1;
	end
	else
		cpu_addr_17 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_18 <= cpu_addr_18 + 1'b1;
	end
	else
		cpu_addr_18 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_19 <= cpu_addr_19 + 1'b1;
	end
	else
		cpu_addr_19 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_20 <= cpu_addr_20 + 1'b1;
	end
	else
		cpu_addr_20 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_21 <= cpu_addr_21 + 1'b1;
	end
	else
		cpu_addr_21 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_22 <= cpu_addr_22 + 1'b1;
	end
	else
		cpu_addr_22 <= 0;
end

always @(posedge clk) begin
	if (cpu_addr_ena == 1'b1)  begin
		cpu_addr_23 <= cpu_addr_23 + 1'b1;
	end
	else
		cpu_addr_23 <= 0;
end

endmodule

