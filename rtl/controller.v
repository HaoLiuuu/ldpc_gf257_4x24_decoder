// =============================================================================
// @File         :  controller.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/19 20:55:49
// @Description  :  controller
// 					top controller of LDPC decoder
// 					generate controlling siganls and read & write address
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/19 20:55:49 | original
// =============================================================================

module controller #( 
	parameter ADDR_WIDTH = 8
)(
	input clk,    // Clock
    input ini_st,
	input rst_n,  // Asynchronous reset active low
	
	// 控制信号
	output initial_on,		// initialize info from intrinsic ram to llr ram
	output vpu_on,			// VPU update
	output cpu_on,			// CPU update

    output vpu_rd_addr_en,
    output vpu_wr_addr_en,
    output cpu_wr_addr_en,

	output llr_ram_rden,
	output llr_ram_wren,
	output in_info_rden
// 2022/1/19 21:08:40
// 内信息存储块的写控制信号
// 应该由外部模块输入
	// output in_info_wren

// 2022/1/19 21:17:43
// 应该不需要从 controller 输出地址信号才对
);

genvar i;

// 2022/1/22 11:53:56
// 这里有几个延迟值还需要再确定下
// 按照我们的步骤就能确定好
localparam COR_DELAY = 2 ;
localparam VPU_DELAY = 3 ; // not certainly
localparam RW_DELAY  = 2 ;
localparam CPU_DELAY = 7 ; // not certainly

localparam IDLE     = 3'b000;
localparam INI_LOOP = 3'b001;
localparam CPU_LOOP = 3'b010;
localparam VPU_LOOP = 3'b100;
localparam INI_LOOP_CLK_NEEDED = 9'd256;
localparam CPU_LOOP_CLK_NEEDED = 9'd263;
localparam VPU_LOOP_CLK_NEEDED = 9'd259;

reg [VPU_DELAY+RW_DELAY-1:0] reg_vpu_en;
reg [CPU_DELAY+RW_DELAY-1:0] reg_cpu_en;
reg [RW_DELAY-1:0] reg_initial;

assign llr_ram_rden = vpu_on | cpu_on;
assign in_info_rden = (vpu_on & reg_vpu_en[0]) | initial_on;
assign vpu_rd_addr_en = vpu_on | (initial_on & reg_initial[RW_DELAY-1]);
assign vpu_wr_addr_en = reg_vpu_en[VPU_DELAY+RW_DELAY-1] & vpu_on; // 由读使能信号延迟得到
assign cpu_wr_addr_en = reg_cpu_en[CPU_DELAY+RW_DELAY-1] & cpu_on; // 由读使能信号延迟得到
assign llr_ram_wren = vpu_wr_addr_en | cpu_wr_addr_en | initial_on;

always @(posedge clk) reg_initial[0] <= initial_on;
generate
    for (i = 1; i < RW_DELAY; i = i + 1) begin : initial_en_delay
        always @(posedge clk) reg_initial[i] <= reg_initial[i-1];
    end
endgenerate

always @(posedge clk) reg_cpu_en[0] <= cpu_on;
generate
    for (i = 1; i < CPU_DELAY+RW_DELAY; i = i + 1) begin : cpu_en_delay
        always @(posedge clk) reg_cpu_en[i] <= reg_cpu_en[i-1];
    end
endgenerate

always @(posedge clk) reg_vpu_en[0] <= vpu_on;
generate
    for (i = 1; i < VPU_DELAY+RW_DELAY; i = i + 1) begin : vpu_en_delay
        always @(posedge clk) reg_vpu_en[i] <= reg_vpu_en[i-1];
    end
endgenerate


// one counter for one state
reg [8:0] cnt_ini;
reg [8:0] cnt_cpu;
reg [8:0] cnt_vpu;

// variable controlling state switchment
wire ini2cpu = (cnt_ini == INI_LOOP_CLK_NEEDED);
wire cpu2vpu = (cnt_cpu == CPU_LOOP_CLK_NEEDED);
wire vpu2cpu = (cnt_vpu == VPU_LOOP_CLK_NEEDED);
wire vpu2ini = 0; // use

// =============================================================================
//                          Counter
// =============================================================================
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        cnt_ini <= 0;
    end
    else if (initial_on && cnt_ini <= INI_LOOP_CLK_NEEDED) begin
        cnt_ini <= cnt_ini + 1'b1;
    end
    else
        cnt_ini <= 0;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        cnt_cpu <= 0;
    end
    else if (cpu_on && cnt_cpu <= CPU_LOOP_CLK_NEEDED) begin
        cnt_cpu <= cnt_cpu + 1'b1;
    end
    else
        cnt_cpu <= 0;
end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        cnt_vpu <= 0;
    end
    else if (vpu_on && cnt_vpu <= VPU_LOOP_CLK_NEEDED) begin
        cnt_vpu <= cnt_vpu + 1'b1;
    end
    else
        cnt_vpu <= 0;
end

// =============================================================================
//                          controll FSM
// =============================================================================
reg [2:0] cur_state;
reg [2:0] next_state;

always @(posedge clk or negedge rst_n) begin : proc_cur_state
    if(rst_n == 1'b0) begin
        cur_state <= IDLE;
    end 
    else begin
        cur_state <= next_state;
    end
end

always @(*) begin : proc_next_state
    case (cur_state)
        IDLE: begin
                if (ini_st) // after ROMs initialize intrinsic messages RAMs
                    next_state = INI_LOOP;
                else
                    next_state = IDLE;
              end
        INI_LOOP: begin 
                    if (ini2cpu)
                        next_state = CPU_LOOP;
                    else
                        next_state = INI_LOOP;
                  end
        CPU_LOOP: begin
                    if (cpu2vpu)
                        next_state = VPU_LOOP;
                    else
                        next_state = CPU_LOOP;
                  end
        VPU_LOOP: begin
                    if (vpu2cpu)
                        next_state = CPU_LOOP;
                    else if (vpu2ini)
                        next_state = INI_LOOP;
                    else
                        next_state = VPU_LOOP;
                  end
        default : next_state = IDLE;
    endcase
end

reg [2:0] output_controll;
assign {initial_on, cpu_on, vpu_on} = output_controll;

always @(posedge clk or negedge rst_n) begin : proc_result
    if(rst_n == 1'b0) begin
        output_controll <= 0;
    end 
    else begin
        case (cur_state)
            IDLE:     begin 
                        output_controll <= 3'b000;
                      end
            INI_LOOP: begin 
                        output_controll <= 3'b100;
                      end
            CPU_LOOP: begin 
                        output_controll <= 3'b010;
                      end
            VPU_LOOP: begin 
                        output_controll <= 3'b001;
                      end
            default : begin
                        output_controll <= 3'b000;
                    end
        endcase
    end
end



endmodule