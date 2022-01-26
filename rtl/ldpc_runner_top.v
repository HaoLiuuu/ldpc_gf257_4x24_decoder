// =============================================================================
// @File         :  ldpc_runner_top.v
// @Author       :  Jiangxuan Li
// @Created      :  2022/1/16 20:00:32
// @Description  :  runner 的顶层文件，初始化 CPU 和 VPU
// 
// -----------------------------------------------------------------------------
// History
// -----------------------------------------------------------------------------
// Ver  :| Author  :| Mod. Date          :| Changes Made :|
// 0.1   | Jx L     | 2022/1/16 20:00:32 | original
// =============================================================================

module ldpc_runner_top #(
	parameter LLR_WIDTH = 8,
	parameter ADDR_WIDTH = 8,
	parameter ROW_WEIGHT = 24,
	parameter COL_WEIGHT = 4,
	parameter VN_STAGE = 2
)(
	input clk,    // Clock
	input en,
	input rst_n,  // Asynchronous reset active low
	input ini_st, //! 状态切换信号，即启动译码

	input wrclk,
	input in_info_wren,

	input [LLR_WIDTH-1:0] rece_llr_intri_0 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_1 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_2 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_3 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_4 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_5 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_6 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_7 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_8 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_9 ,
	input [LLR_WIDTH-1:0] rece_llr_intri_10,
	input [LLR_WIDTH-1:0] rece_llr_intri_11,
	input [LLR_WIDTH-1:0] rece_llr_intri_12,
	input [LLR_WIDTH-1:0] rece_llr_intri_13,
	input [LLR_WIDTH-1:0] rece_llr_intri_14,
	input [LLR_WIDTH-1:0] rece_llr_intri_15,
	input [LLR_WIDTH-1:0] rece_llr_intri_16,
	input [LLR_WIDTH-1:0] rece_llr_intri_17,
	input [LLR_WIDTH-1:0] rece_llr_intri_18,
	input [LLR_WIDTH-1:0] rece_llr_intri_19,
	input [LLR_WIDTH-1:0] rece_llr_intri_20,
	input [LLR_WIDTH-1:0] rece_llr_intri_21,
	input [LLR_WIDTH-1:0] rece_llr_intri_22,
	input [LLR_WIDTH-1:0] rece_llr_intri_23,

	output [23:0] llr_sign	
);

genvar i;

// =============================================================================
//                          外部初始化信息输入
// =============================================================================
wire [LLR_WIDTH-1:0] rece_llr_intri [ROW_WEIGHT-1:0];

assign rece_llr_intri[0 ] = rece_llr_intri_0 ;
assign rece_llr_intri[1 ] = rece_llr_intri_1 ;
assign rece_llr_intri[2 ] = rece_llr_intri_2 ;
assign rece_llr_intri[3 ] = rece_llr_intri_3 ;
assign rece_llr_intri[4 ] = rece_llr_intri_4 ;
assign rece_llr_intri[5 ] = rece_llr_intri_5 ;
assign rece_llr_intri[6 ] = rece_llr_intri_6 ;
assign rece_llr_intri[7 ] = rece_llr_intri_7 ;
assign rece_llr_intri[8 ] = rece_llr_intri_8 ;
assign rece_llr_intri[9 ] = rece_llr_intri_9 ;
assign rece_llr_intri[10] = rece_llr_intri_10;
assign rece_llr_intri[11] = rece_llr_intri_11;
assign rece_llr_intri[12] = rece_llr_intri_12;
assign rece_llr_intri[13] = rece_llr_intri_13;
assign rece_llr_intri[14] = rece_llr_intri_14;
assign rece_llr_intri[15] = rece_llr_intri_15;
assign rece_llr_intri[16] = rece_llr_intri_16;
assign rece_llr_intri[17] = rece_llr_intri_17;
assign rece_llr_intri[18] = rece_llr_intri_18;
assign rece_llr_intri[19] = rece_llr_intri_19;
assign rece_llr_intri[20] = rece_llr_intri_20;
assign rece_llr_intri[21] = rece_llr_intri_21;
assign rece_llr_intri[22] = rece_llr_intri_22;
assign rece_llr_intri[23] = rece_llr_intri_23;

// ------------------------------------------
//  地址连线定义
// ------------------------------------------
wire [ADDR_WIDTH-1:0] rdaddr_intri  [ROW_WEIGHT-1:0];
wire [ADDR_WIDTH-1:0] wraddr_intri  [ROW_WEIGHT-1:0];

wire [ADDR_WIDTH-1:0] rdaddr_ram_b0 [ROW_WEIGHT-1:0];
wire [ADDR_WIDTH-1:0] rdaddr_ram_b1 [ROW_WEIGHT-1:0];
wire [ADDR_WIDTH-1:0] rdaddr_ram_b2 [ROW_WEIGHT-1:0];
wire [ADDR_WIDTH-1:0] rdaddr_ram_b3 [ROW_WEIGHT-1:0];

wire [ADDR_WIDTH-1:0] wraddr_ram_b0 [ROW_WEIGHT-1:0];
wire [ADDR_WIDTH-1:0] wraddr_ram_b1 [ROW_WEIGHT-1:0];
wire [ADDR_WIDTH-1:0] wraddr_ram_b2 [ROW_WEIGHT-1:0];
wire [ADDR_WIDTH-1:0] wraddr_ram_b3 [ROW_WEIGHT-1:0];


wire [ADDR_WIDTH-1:0] vpu_addr_0 ;
wire [ADDR_WIDTH-1:0] vpu_addr_1 ;
wire [ADDR_WIDTH-1:0] vpu_addr_2 ;
wire [ADDR_WIDTH-1:0] vpu_addr_3 ;
wire [ADDR_WIDTH-1:0] vpu_addr_4 ;
wire [ADDR_WIDTH-1:0] vpu_addr_5 ;
wire [ADDR_WIDTH-1:0] vpu_addr_6 ;
wire [ADDR_WIDTH-1:0] vpu_addr_7 ;
wire [ADDR_WIDTH-1:0] vpu_addr_8 ;
wire [ADDR_WIDTH-1:0] vpu_addr_9 ;
wire [ADDR_WIDTH-1:0] vpu_addr_10;
wire [ADDR_WIDTH-1:0] vpu_addr_11;
wire [ADDR_WIDTH-1:0] vpu_addr_12;
wire [ADDR_WIDTH-1:0] vpu_addr_13;
wire [ADDR_WIDTH-1:0] vpu_addr_14;
wire [ADDR_WIDTH-1:0] vpu_addr_15;
wire [ADDR_WIDTH-1:0] vpu_addr_16;
wire [ADDR_WIDTH-1:0] vpu_addr_17;
wire [ADDR_WIDTH-1:0] vpu_addr_18;
wire [ADDR_WIDTH-1:0] vpu_addr_19;
wire [ADDR_WIDTH-1:0] vpu_addr_20;
wire [ADDR_WIDTH-1:0] vpu_addr_21;
wire [ADDR_WIDTH-1:0] vpu_addr_22;
wire [ADDR_WIDTH-1:0] vpu_addr_23;
wire [ADDR_WIDTH-1:0] vpu_addr_0_appd;
wire [ADDR_WIDTH-1:0] vpu_addr_1_appd;
wire [ADDR_WIDTH-1:0] vpu_addr_2_appd;

wire [ADDR_WIDTH-1:0] wr_vpu_addr_0 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_1 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_2 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_3 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_4 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_5 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_6 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_7 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_8 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_9 ;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_10;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_11;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_12;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_13;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_14;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_15;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_16;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_17;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_18;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_19;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_20;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_21;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_22;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_23;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_0_appd;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_1_appd;
wire [ADDR_WIDTH-1:0] wr_vpu_addr_2_appd;

wire [ADDR_WIDTH-1:0] cpu_addr_0 ;
wire [ADDR_WIDTH-1:0] cpu_addr_1 ;
wire [ADDR_WIDTH-1:0] cpu_addr_2 ;
wire [ADDR_WIDTH-1:0] cpu_addr_3 ;
wire [ADDR_WIDTH-1:0] cpu_addr_4 ;
wire [ADDR_WIDTH-1:0] cpu_addr_5 ;
wire [ADDR_WIDTH-1:0] cpu_addr_6 ;
wire [ADDR_WIDTH-1:0] cpu_addr_7 ;
wire [ADDR_WIDTH-1:0] cpu_addr_8 ;
wire [ADDR_WIDTH-1:0] cpu_addr_9 ;
wire [ADDR_WIDTH-1:0] cpu_addr_10;
wire [ADDR_WIDTH-1:0] cpu_addr_11;
wire [ADDR_WIDTH-1:0] cpu_addr_12;
wire [ADDR_WIDTH-1:0] cpu_addr_13;
wire [ADDR_WIDTH-1:0] cpu_addr_14;
wire [ADDR_WIDTH-1:0] cpu_addr_15;
wire [ADDR_WIDTH-1:0] cpu_addr_16;
wire [ADDR_WIDTH-1:0] cpu_addr_17;
wire [ADDR_WIDTH-1:0] cpu_addr_18;
wire [ADDR_WIDTH-1:0] cpu_addr_19;
wire [ADDR_WIDTH-1:0] cpu_addr_20;
wire [ADDR_WIDTH-1:0] cpu_addr_21;
wire [ADDR_WIDTH-1:0] cpu_addr_22;
wire [ADDR_WIDTH-1:0] cpu_addr_23;

wire [ADDR_WIDTH-1:0] wr_cpu_addr_0 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_1 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_2 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_3 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_4 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_5 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_6 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_7 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_8 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_9 ;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_10;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_11;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_12;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_13;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_14;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_15;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_16;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_17;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_18;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_19;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_20;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_21;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_22;
wire [ADDR_WIDTH-1:0] wr_cpu_addr_23;

// -------------------------------------------------
// llr_ram 数据连线定义
// -------------------------------------------------
wire [LLR_WIDTH-1:0] llr_ram_in_0  [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] llr_ram_in_1  [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] llr_ram_in_2  [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] llr_ram_in_3  [ROW_WEIGHT-1:0];

wire [LLR_WIDTH-1:0] llr_ram_out_0 [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] llr_ram_out_1 [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] llr_ram_out_2 [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] llr_ram_out_3 [ROW_WEIGHT-1:0];
 

// -------------------------------------------------
// CPU 数据连线定义
// -------------------------------------------------
wire [LLR_WIDTH-1:0] cpu_llr_in_0  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_1  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_2  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_3  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_4  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_5  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_6  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_7  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_8  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_9  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_10 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_11 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_12 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_13 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_14 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_15 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_16 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_17 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_18 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_19 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_20 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_21 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_22 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_in_23 [COL_WEIGHT-1:0];

wire [LLR_WIDTH-1:0] cpu_llr_out_0  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_1  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_2  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_3  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_4  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_5  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_6  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_7  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_8  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_9  [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_10 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_11 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_12 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_13 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_14 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_15 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_16 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_17 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_18 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_19 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_20 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_21 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_22 [COL_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] cpu_llr_out_23 [COL_WEIGHT-1:0];

// -------------------------------------------------
// VPU 数据连线定义
// -------------------------------------------------
wire [LLR_WIDTH-1:0] llr_intri 	  [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] llr_all 	  [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] vpu_llr_in_0 [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] vpu_llr_in_1 [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] vpu_llr_in_2 [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] vpu_llr_in_3 [ROW_WEIGHT-1:0];

wire [LLR_WIDTH-1:0] vpu_llr_out_0 [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] vpu_llr_out_1 [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] vpu_llr_out_2 [ROW_WEIGHT-1:0];
wire [LLR_WIDTH-1:0] vpu_llr_out_3 [ROW_WEIGHT-1:0];

// =============================================================================
//                          top controller
// =============================================================================
wire initial_on;
wire cpu_on;
wire vpu_on;
wire vpu_rd_addr_en;
wire vpu_wr_addr_en;
wire cpu_wr_addr_en;
wire llr_ram_rden; //! 读 llr ram 使能
wire llr_ram_wren; //! 写 llr ram 使能
wire in_info_rden; //! 读 llr intrinsic 使能
// wire in_info_wren; //! 写 llr intrinsic 使能

controller #(
		.ADDR_WIDTH(ADDR_WIDTH)
	) inst_controller   (
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
		// .in_info_wren   (in_info_wren)
	);


// =============================================================================
//                          vpu addr generator
// =============================================================================
// 没有添加复位信号，不知这种写法能否被接受，还是要具体的仿真情况确定
vpu_addr_gen #(
		.ADDR_WIDTH(ADDR_WIDTH)
	) rd_vpu_addr_gen (
		.clk         (clk),
		.en          (vpu_rd_addr_en),
		.vpu_addr_0  (vpu_addr_0),
		.vpu_addr_1  (vpu_addr_1),
		.vpu_addr_2  (vpu_addr_2),
		.vpu_addr_3  (vpu_addr_3),
		.vpu_addr_4  (vpu_addr_4),
		.vpu_addr_5  (vpu_addr_5),
		.vpu_addr_6  (vpu_addr_6),
		.vpu_addr_7  (vpu_addr_7),
		.vpu_addr_8  (vpu_addr_8),
		.vpu_addr_9  (vpu_addr_9),
		.vpu_addr_10 (vpu_addr_10),
		.vpu_addr_11 (vpu_addr_11),
		.vpu_addr_12 (vpu_addr_12),
		.vpu_addr_13 (vpu_addr_13),
		.vpu_addr_14 (vpu_addr_14),
		.vpu_addr_15 (vpu_addr_15),
		.vpu_addr_16 (vpu_addr_16),
		.vpu_addr_17 (vpu_addr_17),
		.vpu_addr_18 (vpu_addr_18),
		.vpu_addr_19 (vpu_addr_19),
		.vpu_addr_20 (vpu_addr_20),
		.vpu_addr_21 (vpu_addr_21),
		.vpu_addr_22 (vpu_addr_22),
		.vpu_addr_23 (vpu_addr_23),
// 2022/1/20 17:41:04
// 由于循环结构的原因，还需要再补三个 vpu_addr_gen
		.vpu_addr_0_appd(vpu_addr_0_appd),
		.vpu_addr_1_appd(vpu_addr_1_appd),
		.vpu_addr_2_appd(vpu_addr_2_appd)
	);

vpu_addr_gen #(
		.ADDR_WIDTH(ADDR_WIDTH)
	) wr_vpu_addr_gen (
		.clk         (clk),
		.en          (vpu_wr_addr_en),
		.vpu_addr_0  (wr_vpu_addr_0 ),
		.vpu_addr_1  (wr_vpu_addr_1 ),
		.vpu_addr_2  (wr_vpu_addr_2 ),
		.vpu_addr_3  (wr_vpu_addr_3 ),
		.vpu_addr_4  (wr_vpu_addr_4 ),
		.vpu_addr_5  (wr_vpu_addr_5 ),
		.vpu_addr_6  (wr_vpu_addr_6 ),
		.vpu_addr_7  (wr_vpu_addr_7 ),
		.vpu_addr_8  (wr_vpu_addr_8 ),
		.vpu_addr_9  (wr_vpu_addr_9 ),
		.vpu_addr_10 (wr_vpu_addr_10),
		.vpu_addr_11 (wr_vpu_addr_11),
		.vpu_addr_12 (wr_vpu_addr_12),
		.vpu_addr_13 (wr_vpu_addr_13),
		.vpu_addr_14 (wr_vpu_addr_14),
		.vpu_addr_15 (wr_vpu_addr_15),
		.vpu_addr_16 (wr_vpu_addr_16),
		.vpu_addr_17 (wr_vpu_addr_17),
		.vpu_addr_18 (wr_vpu_addr_18),
		.vpu_addr_19 (wr_vpu_addr_19),
		.vpu_addr_20 (wr_vpu_addr_20),
		.vpu_addr_21 (wr_vpu_addr_21),
		.vpu_addr_22 (wr_vpu_addr_22),
		.vpu_addr_23 (wr_vpu_addr_23),
// 2022/1/20 17:41:04
// 由于循环结构的原因，还需要再补三个 vpu_addr_gen
		.vpu_addr_0_appd(wr_vpu_addr_0_appd),
		.vpu_addr_1_appd(wr_vpu_addr_1_appd),
		.vpu_addr_2_appd(wr_vpu_addr_2_appd)
	);


// =============================================================================
//                          cpu addr generator
// =============================================================================
cpu_addr_gen #(
		.ADDR_WIDTH(ADDR_WIDTH)
	) rd_cpu_addr_gen (
		.clk         (clk),
		.cpu_addr_ena(cpu_on),
		.cpu_addr_0  (cpu_addr_0),
		.cpu_addr_1  (cpu_addr_1),
		.cpu_addr_2  (cpu_addr_2),
		.cpu_addr_3  (cpu_addr_3),
		.cpu_addr_4  (cpu_addr_4),
		.cpu_addr_5  (cpu_addr_5),
		.cpu_addr_6  (cpu_addr_6),
		.cpu_addr_7  (cpu_addr_7),
		.cpu_addr_8  (cpu_addr_8),
		.cpu_addr_9  (cpu_addr_9),
		.cpu_addr_10 (cpu_addr_10),
		.cpu_addr_11 (cpu_addr_11),
		.cpu_addr_12 (cpu_addr_12),
		.cpu_addr_13 (cpu_addr_13),
		.cpu_addr_14 (cpu_addr_14),
		.cpu_addr_15 (cpu_addr_15),
		.cpu_addr_16 (cpu_addr_16),
		.cpu_addr_17 (cpu_addr_17),
		.cpu_addr_18 (cpu_addr_18),
		.cpu_addr_19 (cpu_addr_19),
		.cpu_addr_20 (cpu_addr_20),
		.cpu_addr_21 (cpu_addr_21),
		.cpu_addr_22 (cpu_addr_22),
		.cpu_addr_23 (cpu_addr_23)
	);

cpu_addr_gen #(
		.ADDR_WIDTH(ADDR_WIDTH)
	) wr_cpu_addr_gen (
		.clk         (clk),
		.cpu_addr_ena(cpu_wr_addr_en),
		.cpu_addr_0  (wr_cpu_addr_0 ),
		.cpu_addr_1  (wr_cpu_addr_1 ),
		.cpu_addr_2  (wr_cpu_addr_2 ),
		.cpu_addr_3  (wr_cpu_addr_3 ),
		.cpu_addr_4  (wr_cpu_addr_4 ),
		.cpu_addr_5  (wr_cpu_addr_5 ),
		.cpu_addr_6  (wr_cpu_addr_6 ),
		.cpu_addr_7  (wr_cpu_addr_7 ),
		.cpu_addr_8  (wr_cpu_addr_8 ),
		.cpu_addr_9  (wr_cpu_addr_9 ),
		.cpu_addr_10 (wr_cpu_addr_10),
		.cpu_addr_11 (wr_cpu_addr_11),
		.cpu_addr_12 (wr_cpu_addr_12),
		.cpu_addr_13 (wr_cpu_addr_13),
		.cpu_addr_14 (wr_cpu_addr_14),
		.cpu_addr_15 (wr_cpu_addr_15),
		.cpu_addr_16 (wr_cpu_addr_16),
		.cpu_addr_17 (wr_cpu_addr_17),
		.cpu_addr_18 (wr_cpu_addr_18),
		.cpu_addr_19 (wr_cpu_addr_19),
		.cpu_addr_20 (wr_cpu_addr_20),
		.cpu_addr_21 (wr_cpu_addr_21),
		.cpu_addr_22 (wr_cpu_addr_22),
		.cpu_addr_23 (wr_cpu_addr_23)
	);

// =============================================================================
//                          intrinsic message ram
// =============================================================================
// 2022/1/20 15:29:38
// 暂时用一个行为模型代替
// 假设已经有一个初始化好的 intrinsic message 模块
// 其中包含 24 个 ram，分别为各个 llr ram 提供信息
//
generate
	for (i = 0; i < ROW_WEIGHT; i = i + 1) begin : llr_intrinsic
		llr_intrinsic inst_llr_intrinsic
			(
				.data      (rece_llr_intri[i]),
				.rdaddress (rdaddr_intri[i]),
				.rdclock   (clk),
				.rden      (in_info_rden),
				.wraddress (wraddr_intri[i]),
				.wrclock   (wrclk),
				.wren      (in_info_wren),
				.q         (llr_intri[i])
			);
	end
endgenerate


// =============================================================================
//                          llr ram
// =============================================================================
generate
	for (i = 0; i < ROW_WEIGHT; i = i + 1) begin : llr_ram_b0
		llr_ram inst_llr_ram
		(
			.clock     (clk),
			.data      (llr_ram_in_0[i]),
			.rdaddress (rdaddr_ram_b0[i]),
			.rden      (llr_ram_rden),
			.wraddress (wraddr_ram_b0[i]),
			.wren      (llr_ram_wren),
			.q         (llr_ram_out_0[i])
		);
	end
endgenerate

generate
	for (i = 0; i < ROW_WEIGHT; i = i + 1) begin : llr_ram_b1
		llr_ram inst_llr_ram
		(
			.clock     (clk),
			.data      (llr_ram_in_1[i]),
			.rdaddress (rdaddr_ram_b1[i]),
			.rden      (llr_ram_rden),
			.wraddress (wraddr_ram_b1[i]),
			.wren      (llr_ram_wren),
			.q         (llr_ram_out_1[i])
		);
	end
endgenerate

generate
	for (i = 0; i < ROW_WEIGHT; i = i + 1) begin : llr_ram_b2
		llr_ram inst_llr_ram
		(
			.clock     (clk),
			.data      (llr_ram_in_2[i]),
			.rdaddress (rdaddr_ram_b2[i]),
			.rden      (llr_ram_rden),
			.wraddress (wraddr_ram_b2[i]),
			.wren      (llr_ram_wren),
			.q         (llr_ram_out_2[i])
		);
	end
endgenerate

generate
	for (i = 0; i < ROW_WEIGHT; i = i + 1) begin : llr_ram_b3
		llr_ram inst_llr_ram
		(
			.clock     (clk),
			.data      (llr_ram_in_3[i]),
			.rdaddress (rdaddr_ram_b3[i]),
			.rden      (llr_ram_rden),
			.wraddress (wraddr_ram_b3[i]),
			.wren      (llr_ram_wren),
			.q         (llr_ram_out_3[i])
		);
	end
endgenerate



// =============================================================================
//                          cpu block
// =============================================================================
generate
	for (i = 0; i < COL_WEIGHT; i = i + 1) begin : cpu_block
		ldpc_cpu #(
				.LLR_WIDTH(LLR_WIDTH),
				.ROW_WEIGHT(ROW_WEIGHT)
			) inst_ldpc_cpu (
				.clk        (clk),
				.en         (cpu_on),
				.rst_n      (rst_n),
				.llr_in_0   (cpu_llr_in_0[i]),
				.llr_in_1   (cpu_llr_in_1[i]),
				.llr_in_2   (cpu_llr_in_2[i]),
				.llr_in_3   (cpu_llr_in_3[i]),
				.llr_in_4   (cpu_llr_in_4[i]),
				.llr_in_5   (cpu_llr_in_5[i]),
				.llr_in_6   (cpu_llr_in_6[i]),
				.llr_in_7   (cpu_llr_in_7[i]),
				.llr_in_8   (cpu_llr_in_8[i]),
				.llr_in_9   (cpu_llr_in_9[i]),
				.llr_in_10  (cpu_llr_in_10[i]),
				.llr_in_11  (cpu_llr_in_11[i]),
				.llr_in_12  (cpu_llr_in_12[i]),
				.llr_in_13  (cpu_llr_in_13[i]),
				.llr_in_14  (cpu_llr_in_14[i]),
				.llr_in_15  (cpu_llr_in_15[i]),
				.llr_in_16  (cpu_llr_in_16[i]),
				.llr_in_17  (cpu_llr_in_17[i]),
				.llr_in_18  (cpu_llr_in_18[i]),
				.llr_in_19  (cpu_llr_in_19[i]),
				.llr_in_20  (cpu_llr_in_20[i]),
				.llr_in_21  (cpu_llr_in_21[i]),
				.llr_in_22  (cpu_llr_in_22[i]),
				.llr_in_23  (cpu_llr_in_23[i]),
				.min        (),
				.submin     (),
				.llr_out_0  (cpu_llr_out_0[i]),
				.llr_out_1  (cpu_llr_out_1[i]),
				.llr_out_2  (cpu_llr_out_2[i]),
				.llr_out_3  (cpu_llr_out_3[i]),
				.llr_out_4  (cpu_llr_out_4[i]),
				.llr_out_5  (cpu_llr_out_5[i]),
				.llr_out_6  (cpu_llr_out_6[i]),
				.llr_out_7  (cpu_llr_out_7[i]),
				.llr_out_8  (cpu_llr_out_8[i]),
				.llr_out_9  (cpu_llr_out_9[i]),
				.llr_out_10 (cpu_llr_out_10[i]),
				.llr_out_11 (cpu_llr_out_11[i]),
				.llr_out_12 (cpu_llr_out_12[i]),
				.llr_out_13 (cpu_llr_out_13[i]),
				.llr_out_14 (cpu_llr_out_14[i]),
				.llr_out_15 (cpu_llr_out_15[i]),
				.llr_out_16 (cpu_llr_out_16[i]),
				.llr_out_17 (cpu_llr_out_17[i]),
				.llr_out_18 (cpu_llr_out_18[i]),
				.llr_out_19 (cpu_llr_out_19[i]),
				.llr_out_20 (cpu_llr_out_20[i]),
				.llr_out_21 (cpu_llr_out_21[i]),
				.llr_out_22 (cpu_llr_out_22[i]),
				.llr_out_23 (cpu_llr_out_23[i])
			);

	end
endgenerate

// =============================================================================
//                          vpu block
// =============================================================================
generate
	for (i = 0; i < ROW_WEIGHT; i = i + 1) begin
		ldpc_vpu #(
				.COL_WEIGHT(COL_WEIGHT),
				.LLR_WIDTH(LLR_WIDTH),
				.VN_STAGE(VN_STAGE)
			) inst_ldpc_vpu (
				.clk       (clk),
				.rst_n     (rst_n),
				.en        (vpu_on),
				.llr_intri (llr_intri[i]),
				.llr_in_0  (vpu_llr_in_0[i]),
				.llr_in_1  (vpu_llr_in_1[i]),
				.llr_in_2  (vpu_llr_in_2[i]),
				.llr_in_3  (vpu_llr_in_3[i]),
				.llr_out_0 (vpu_llr_out_0[i]),
				.llr_out_1 (vpu_llr_out_1[i]),
				.llr_out_2 (vpu_llr_out_2[i]),
				.llr_out_3 (vpu_llr_out_3[i]),
				.llr_all   (llr_all[i])
			);
	end
endgenerate

assign llr_sign = {llr_all[23][LLR_WIDTH-1],
				   llr_all[22][LLR_WIDTH-1],
				   llr_all[21][LLR_WIDTH-1],
				   llr_all[20][LLR_WIDTH-1],
				   llr_all[19][LLR_WIDTH-1],
				   llr_all[18][LLR_WIDTH-1],
				   llr_all[17][LLR_WIDTH-1],
				   llr_all[16][LLR_WIDTH-1],
				   llr_all[15][LLR_WIDTH-1],
				   llr_all[14][LLR_WIDTH-1],
				   llr_all[13][LLR_WIDTH-1],
				   llr_all[12][LLR_WIDTH-1],
				   llr_all[11][LLR_WIDTH-1],
				   llr_all[10][LLR_WIDTH-1],
				   llr_all[ 9][LLR_WIDTH-1],
				   llr_all[ 8][LLR_WIDTH-1],
				   llr_all[ 7][LLR_WIDTH-1],
				   llr_all[ 6][LLR_WIDTH-1],
				   llr_all[ 5][LLR_WIDTH-1],
				   llr_all[ 4][LLR_WIDTH-1],
				   llr_all[ 3][LLR_WIDTH-1],
				   llr_all[ 2][LLR_WIDTH-1],
				   llr_all[ 1][LLR_WIDTH-1],
				   llr_all[ 0][LLR_WIDTH-1]
				   };

// =============================================================================
//                          data connetions
// from VN and CN to llr_ram
// =============================================================================
// llr_ram write back data choose
// 4 ram block in total
// 
// --- about VPU
// 
// llr_ram_in_0[0...23] ---> vpu_llr_out_0[0...23]
// llr_ram_in_1[0...23] ---> vpu_llr_out_1[0...23]
// llr_ram_in_2[0...23] ---> vpu_llr_out_2[0...23]
// llr_ram_in_3[0...23] ---> vpu_llr_out_3[0...23]
// 
// ...
// 
// --- about CPU
// 
// llr_ram_in_0[0...23]  ---> {cpu_llr_out_0[0], cpu_llr_out_1[0], ..., cpu_llr_out_23[0]}
// llr_ram_in_1[0...23]  ---> {cpu_llr_out_0[1], cpu_llr_out_1[1], ..., cpu_llr_out_23[1]}
// llr_ram_in_2[0...23]  ---> {cpu_llr_out_0[2], cpu_llr_out_1[2], ..., cpu_llr_out_23[2]}
// llr_ram_in_3[0...23]  ---> {cpu_llr_out_0[3], cpu_llr_out_1[3], ..., cpu_llr_out_23[3]}

assign llr_ram_in_0[0] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_0[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[0])
						| ({LLR_WIDTH{initial_on}} & llr_intri[0]);
assign llr_ram_in_0[1] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_1[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[1])
						| ({LLR_WIDTH{initial_on}} & llr_intri[1]);
assign llr_ram_in_0[2] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_2[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[2])
						| ({LLR_WIDTH{initial_on}} & llr_intri[2]);
assign llr_ram_in_0[3] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_3[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[3])
						| ({LLR_WIDTH{initial_on}} & llr_intri[3]);
assign llr_ram_in_0[4] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_4[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[4])
						| ({LLR_WIDTH{initial_on}} & llr_intri[4]);
assign llr_ram_in_0[5] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_5[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[5])
						| ({LLR_WIDTH{initial_on}} & llr_intri[5]);
assign llr_ram_in_0[6] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_6[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[6])
						| ({LLR_WIDTH{initial_on}} & llr_intri[6]);
assign llr_ram_in_0[7] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_7[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[7])
						| ({LLR_WIDTH{initial_on}} & llr_intri[7]);
assign llr_ram_in_0[8] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_8[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[8])
						| ({LLR_WIDTH{initial_on}} & llr_intri[8]);
assign llr_ram_in_0[9] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_9[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[9])
						| ({LLR_WIDTH{initial_on}} & llr_intri[9]);
assign llr_ram_in_0[10] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_10[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[10])
						| ({LLR_WIDTH{initial_on}} & llr_intri[10]);
assign llr_ram_in_0[11] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_11[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[11])
						| ({LLR_WIDTH{initial_on}} & llr_intri[11]);
assign llr_ram_in_0[12] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_12[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[12])
						| ({LLR_WIDTH{initial_on}} & llr_intri[12]);
assign llr_ram_in_0[13] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_13[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[13])
						| ({LLR_WIDTH{initial_on}} & llr_intri[13]);
assign llr_ram_in_0[14] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_14[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[14])
						| ({LLR_WIDTH{initial_on}} & llr_intri[14]);
assign llr_ram_in_0[15] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_15[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[15])
						| ({LLR_WIDTH{initial_on}} & llr_intri[15]);
assign llr_ram_in_0[16] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_16[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[16])
						| ({LLR_WIDTH{initial_on}} & llr_intri[16]);
assign llr_ram_in_0[17] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_17[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[17])
						| ({LLR_WIDTH{initial_on}} & llr_intri[17]);
assign llr_ram_in_0[18] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_18[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[18])
						| ({LLR_WIDTH{initial_on}} & llr_intri[18]);
assign llr_ram_in_0[19] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_19[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[19])
						| ({LLR_WIDTH{initial_on}} & llr_intri[19]);
assign llr_ram_in_0[20] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_20[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[20])
						| ({LLR_WIDTH{initial_on}} & llr_intri[20]);
assign llr_ram_in_0[21] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_21[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[21])
						| ({LLR_WIDTH{initial_on}} & llr_intri[21]);
assign llr_ram_in_0[22] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_22[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[22])
						| ({LLR_WIDTH{initial_on}} & llr_intri[22]);
assign llr_ram_in_0[23] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_23[0])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_0[23])
						| ({LLR_WIDTH{initial_on}} & llr_intri[23]);
assign llr_ram_in_1[0] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_0[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[0])
						| ({LLR_WIDTH{initial_on}} & llr_intri[0]);
assign llr_ram_in_1[1] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_1[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[1])
						| ({LLR_WIDTH{initial_on}} & llr_intri[1]);
assign llr_ram_in_1[2] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_2[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[2])
						| ({LLR_WIDTH{initial_on}} & llr_intri[2]);
assign llr_ram_in_1[3] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_3[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[3])
						| ({LLR_WIDTH{initial_on}} & llr_intri[3]);
assign llr_ram_in_1[4] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_4[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[4])
						| ({LLR_WIDTH{initial_on}} & llr_intri[4]);
assign llr_ram_in_1[5] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_5[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[5])
						| ({LLR_WIDTH{initial_on}} & llr_intri[5]);
assign llr_ram_in_1[6] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_6[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[6])
						| ({LLR_WIDTH{initial_on}} & llr_intri[6]);
assign llr_ram_in_1[7] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_7[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[7])
						| ({LLR_WIDTH{initial_on}} & llr_intri[7]);
assign llr_ram_in_1[8] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_8[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[8])
						| ({LLR_WIDTH{initial_on}} & llr_intri[8]);
assign llr_ram_in_1[9] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_9[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[9])
						| ({LLR_WIDTH{initial_on}} & llr_intri[9]);
assign llr_ram_in_1[10] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_10[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[10])
						| ({LLR_WIDTH{initial_on}} & llr_intri[10]);
assign llr_ram_in_1[11] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_11[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[11])
						| ({LLR_WIDTH{initial_on}} & llr_intri[11]);
assign llr_ram_in_1[12] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_12[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[12])
						| ({LLR_WIDTH{initial_on}} & llr_intri[12]);
assign llr_ram_in_1[13] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_13[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[13])
						| ({LLR_WIDTH{initial_on}} & llr_intri[13]);
assign llr_ram_in_1[14] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_14[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[14])
						| ({LLR_WIDTH{initial_on}} & llr_intri[14]);
assign llr_ram_in_1[15] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_15[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[15])
						| ({LLR_WIDTH{initial_on}} & llr_intri[15]);
assign llr_ram_in_1[16] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_16[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[16])
						| ({LLR_WIDTH{initial_on}} & llr_intri[16]);
assign llr_ram_in_1[17] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_17[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[17])
						| ({LLR_WIDTH{initial_on}} & llr_intri[17]);
assign llr_ram_in_1[18] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_18[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[18])
						| ({LLR_WIDTH{initial_on}} & llr_intri[18]);
assign llr_ram_in_1[19] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_19[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[19])
						| ({LLR_WIDTH{initial_on}} & llr_intri[19]);
assign llr_ram_in_1[20] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_20[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[20])
						| ({LLR_WIDTH{initial_on}} & llr_intri[20]);
assign llr_ram_in_1[21] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_21[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[21])
						| ({LLR_WIDTH{initial_on}} & llr_intri[21]);
assign llr_ram_in_1[22] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_22[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[22])
						| ({LLR_WIDTH{initial_on}} & llr_intri[22]);
assign llr_ram_in_1[23] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_23[1])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_1[23])
						| ({LLR_WIDTH{initial_on}} & llr_intri[23]);
assign llr_ram_in_2[0] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_0[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[0])
						| ({LLR_WIDTH{initial_on}} & llr_intri[0]);
assign llr_ram_in_2[1] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_1[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[1])
						| ({LLR_WIDTH{initial_on}} & llr_intri[1]);
assign llr_ram_in_2[2] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_2[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[2])
						| ({LLR_WIDTH{initial_on}} & llr_intri[2]);
assign llr_ram_in_2[3] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_3[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[3])
						| ({LLR_WIDTH{initial_on}} & llr_intri[3]);
assign llr_ram_in_2[4] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_4[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[4])
						| ({LLR_WIDTH{initial_on}} & llr_intri[4]);
assign llr_ram_in_2[5] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_5[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[5])
						| ({LLR_WIDTH{initial_on}} & llr_intri[5]);
assign llr_ram_in_2[6] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_6[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[6])
						| ({LLR_WIDTH{initial_on}} & llr_intri[6]);
assign llr_ram_in_2[7] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_7[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[7])
						| ({LLR_WIDTH{initial_on}} & llr_intri[7]);
assign llr_ram_in_2[8] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_8[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[8])
						| ({LLR_WIDTH{initial_on}} & llr_intri[8]);
assign llr_ram_in_2[9] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_9[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[9])
						| ({LLR_WIDTH{initial_on}} & llr_intri[9]);
assign llr_ram_in_2[10] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_10[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[10])
						| ({LLR_WIDTH{initial_on}} & llr_intri[10]);
assign llr_ram_in_2[11] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_11[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[11])
						| ({LLR_WIDTH{initial_on}} & llr_intri[11]);
assign llr_ram_in_2[12] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_12[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[12])
						| ({LLR_WIDTH{initial_on}} & llr_intri[12]);
assign llr_ram_in_2[13] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_13[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[13])
						| ({LLR_WIDTH{initial_on}} & llr_intri[13]);
assign llr_ram_in_2[14] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_14[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[14])
						| ({LLR_WIDTH{initial_on}} & llr_intri[14]);
assign llr_ram_in_2[15] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_15[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[15])
						| ({LLR_WIDTH{initial_on}} & llr_intri[15]);
assign llr_ram_in_2[16] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_16[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[16])
						| ({LLR_WIDTH{initial_on}} & llr_intri[16]);
assign llr_ram_in_2[17] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_17[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[17])
						| ({LLR_WIDTH{initial_on}} & llr_intri[17]);
assign llr_ram_in_2[18] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_18[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[18])
						| ({LLR_WIDTH{initial_on}} & llr_intri[18]);
assign llr_ram_in_2[19] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_19[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[19])
						| ({LLR_WIDTH{initial_on}} & llr_intri[19]);
assign llr_ram_in_2[20] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_20[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[20])
						| ({LLR_WIDTH{initial_on}} & llr_intri[20]);
assign llr_ram_in_2[21] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_21[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[21])
						| ({LLR_WIDTH{initial_on}} & llr_intri[21]);
assign llr_ram_in_2[22] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_22[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[22])
						| ({LLR_WIDTH{initial_on}} & llr_intri[22]);
assign llr_ram_in_2[23] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_23[2])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_2[23])
						| ({LLR_WIDTH{initial_on}} & llr_intri[23]);
assign llr_ram_in_3[0] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_0[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[0])
						| ({LLR_WIDTH{initial_on}} & llr_intri[0]);
assign llr_ram_in_3[1] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_1[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[1])
						| ({LLR_WIDTH{initial_on}} & llr_intri[1]);
assign llr_ram_in_3[2] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_2[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[2])
						| ({LLR_WIDTH{initial_on}} & llr_intri[2]);
assign llr_ram_in_3[3] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_3[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[3])
						| ({LLR_WIDTH{initial_on}} & llr_intri[3]);
assign llr_ram_in_3[4] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_4[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[4])
						| ({LLR_WIDTH{initial_on}} & llr_intri[4]);
assign llr_ram_in_3[5] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_5[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[5])
						| ({LLR_WIDTH{initial_on}} & llr_intri[5]);
assign llr_ram_in_3[6] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_6[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[6])
						| ({LLR_WIDTH{initial_on}} & llr_intri[6]);
assign llr_ram_in_3[7] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_7[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[7])
						| ({LLR_WIDTH{initial_on}} & llr_intri[7]);
assign llr_ram_in_3[8] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_8[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[8])
						| ({LLR_WIDTH{initial_on}} & llr_intri[8]);
assign llr_ram_in_3[9] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_9[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[9])
						| ({LLR_WIDTH{initial_on}} & llr_intri[9]);
assign llr_ram_in_3[10] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_10[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[10])
						| ({LLR_WIDTH{initial_on}} & llr_intri[10]);
assign llr_ram_in_3[11] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_11[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[11])
						| ({LLR_WIDTH{initial_on}} & llr_intri[11]);
assign llr_ram_in_3[12] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_12[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[12])
						| ({LLR_WIDTH{initial_on}} & llr_intri[12]);
assign llr_ram_in_3[13] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_13[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[13])
						| ({LLR_WIDTH{initial_on}} & llr_intri[13]);
assign llr_ram_in_3[14] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_14[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[14])
						| ({LLR_WIDTH{initial_on}} & llr_intri[14]);
assign llr_ram_in_3[15] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_15[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[15])
						| ({LLR_WIDTH{initial_on}} & llr_intri[15]);
assign llr_ram_in_3[16] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_16[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[16])
						| ({LLR_WIDTH{initial_on}} & llr_intri[16]);
assign llr_ram_in_3[17] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_17[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[17])
						| ({LLR_WIDTH{initial_on}} & llr_intri[17]);
assign llr_ram_in_3[18] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_18[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[18])
						| ({LLR_WIDTH{initial_on}} & llr_intri[18]);
assign llr_ram_in_3[19] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_19[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[19])
						| ({LLR_WIDTH{initial_on}} & llr_intri[19]);
assign llr_ram_in_3[20] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_20[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[20])
						| ({LLR_WIDTH{initial_on}} & llr_intri[20]);
assign llr_ram_in_3[21] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_21[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[21])
						| ({LLR_WIDTH{initial_on}} & llr_intri[21]);
assign llr_ram_in_3[22] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_22[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[22])
						| ({LLR_WIDTH{initial_on}} & llr_intri[22]);
assign llr_ram_in_3[23] =  ({LLR_WIDTH{cpu_on}} & cpu_llr_out_23[3])
						| ({LLR_WIDTH{vpu_on}} & vpu_llr_out_3[23])
						| ({LLR_WIDTH{initial_on}} & llr_intri[23]);


// =============================================================================
//                          data connection
// from llr_ram to CN and VN
// =============================================================================
// 
// llr_ram_out_0[0...23] ---> vpu_llr_in_0[0...23];
// 
// llr_ram_out_0[0...23] ---> {cpu_llr_in_0[0], cpu_llr_in_1[0], ...., cpu_llr_in_23[0]};
// 
// 2022/1/22 9:58:30
// !UNDERCHECK
// 直接连接进行
// 或者增加一个选择网络
// 实际看下效果如何
assign vpu_llr_in_0[0] = llr_ram_out_0[0];
assign vpu_llr_in_0[1] = llr_ram_out_0[1];
assign vpu_llr_in_0[2] = llr_ram_out_0[2];
assign vpu_llr_in_0[3] = llr_ram_out_0[3];
assign vpu_llr_in_0[4] = llr_ram_out_0[4];
assign vpu_llr_in_0[5] = llr_ram_out_0[5];
assign vpu_llr_in_0[6] = llr_ram_out_0[6];
assign vpu_llr_in_0[7] = llr_ram_out_0[7];
assign vpu_llr_in_0[8] = llr_ram_out_0[8];
assign vpu_llr_in_0[9] = llr_ram_out_0[9];
assign vpu_llr_in_0[10] = llr_ram_out_0[10];
assign vpu_llr_in_0[11] = llr_ram_out_0[11];
assign vpu_llr_in_0[12] = llr_ram_out_0[12];
assign vpu_llr_in_0[13] = llr_ram_out_0[13];
assign vpu_llr_in_0[14] = llr_ram_out_0[14];
assign vpu_llr_in_0[15] = llr_ram_out_0[15];
assign vpu_llr_in_0[16] = llr_ram_out_0[16];
assign vpu_llr_in_0[17] = llr_ram_out_0[17];
assign vpu_llr_in_0[18] = llr_ram_out_0[18];
assign vpu_llr_in_0[19] = llr_ram_out_0[19];
assign vpu_llr_in_0[20] = llr_ram_out_0[20];
assign vpu_llr_in_0[21] = llr_ram_out_0[21];
assign vpu_llr_in_0[22] = llr_ram_out_0[22];
assign vpu_llr_in_0[23] = llr_ram_out_0[23];

assign vpu_llr_in_1[0] = llr_ram_out_1[0];
assign vpu_llr_in_1[1] = llr_ram_out_1[1];
assign vpu_llr_in_1[2] = llr_ram_out_1[2];
assign vpu_llr_in_1[3] = llr_ram_out_1[3];
assign vpu_llr_in_1[4] = llr_ram_out_1[4];
assign vpu_llr_in_1[5] = llr_ram_out_1[5];
assign vpu_llr_in_1[6] = llr_ram_out_1[6];
assign vpu_llr_in_1[7] = llr_ram_out_1[7];
assign vpu_llr_in_1[8] = llr_ram_out_1[8];
assign vpu_llr_in_1[9] = llr_ram_out_1[9];
assign vpu_llr_in_1[10] = llr_ram_out_1[10];
assign vpu_llr_in_1[11] = llr_ram_out_1[11];
assign vpu_llr_in_1[12] = llr_ram_out_1[12];
assign vpu_llr_in_1[13] = llr_ram_out_1[13];
assign vpu_llr_in_1[14] = llr_ram_out_1[14];
assign vpu_llr_in_1[15] = llr_ram_out_1[15];
assign vpu_llr_in_1[16] = llr_ram_out_1[16];
assign vpu_llr_in_1[17] = llr_ram_out_1[17];
assign vpu_llr_in_1[18] = llr_ram_out_1[18];
assign vpu_llr_in_1[19] = llr_ram_out_1[19];
assign vpu_llr_in_1[20] = llr_ram_out_1[20];
assign vpu_llr_in_1[21] = llr_ram_out_1[21];
assign vpu_llr_in_1[22] = llr_ram_out_1[22];
assign vpu_llr_in_1[23] = llr_ram_out_1[23];

assign vpu_llr_in_2[0] = llr_ram_out_2[0];
assign vpu_llr_in_2[1] = llr_ram_out_2[1];
assign vpu_llr_in_2[2] = llr_ram_out_2[2];
assign vpu_llr_in_2[3] = llr_ram_out_2[3];
assign vpu_llr_in_2[4] = llr_ram_out_2[4];
assign vpu_llr_in_2[5] = llr_ram_out_2[5];
assign vpu_llr_in_2[6] = llr_ram_out_2[6];
assign vpu_llr_in_2[7] = llr_ram_out_2[7];
assign vpu_llr_in_2[8] = llr_ram_out_2[8];
assign vpu_llr_in_2[9] = llr_ram_out_2[9];
assign vpu_llr_in_2[10] = llr_ram_out_2[10];
assign vpu_llr_in_2[11] = llr_ram_out_2[11];
assign vpu_llr_in_2[12] = llr_ram_out_2[12];
assign vpu_llr_in_2[13] = llr_ram_out_2[13];
assign vpu_llr_in_2[14] = llr_ram_out_2[14];
assign vpu_llr_in_2[15] = llr_ram_out_2[15];
assign vpu_llr_in_2[16] = llr_ram_out_2[16];
assign vpu_llr_in_2[17] = llr_ram_out_2[17];
assign vpu_llr_in_2[18] = llr_ram_out_2[18];
assign vpu_llr_in_2[19] = llr_ram_out_2[19];
assign vpu_llr_in_2[20] = llr_ram_out_2[20];
assign vpu_llr_in_2[21] = llr_ram_out_2[21];
assign vpu_llr_in_2[22] = llr_ram_out_2[22];
assign vpu_llr_in_2[23] = llr_ram_out_2[23];

assign vpu_llr_in_3[0] = llr_ram_out_3[0];
assign vpu_llr_in_3[1] = llr_ram_out_3[1];
assign vpu_llr_in_3[2] = llr_ram_out_3[2];
assign vpu_llr_in_3[3] = llr_ram_out_3[3];
assign vpu_llr_in_3[4] = llr_ram_out_3[4];
assign vpu_llr_in_3[5] = llr_ram_out_3[5];
assign vpu_llr_in_3[6] = llr_ram_out_3[6];
assign vpu_llr_in_3[7] = llr_ram_out_3[7];
assign vpu_llr_in_3[8] = llr_ram_out_3[8];
assign vpu_llr_in_3[9] = llr_ram_out_3[9];
assign vpu_llr_in_3[10] = llr_ram_out_3[10];
assign vpu_llr_in_3[11] = llr_ram_out_3[11];
assign vpu_llr_in_3[12] = llr_ram_out_3[12];
assign vpu_llr_in_3[13] = llr_ram_out_3[13];
assign vpu_llr_in_3[14] = llr_ram_out_3[14];
assign vpu_llr_in_3[15] = llr_ram_out_3[15];
assign vpu_llr_in_3[16] = llr_ram_out_3[16];
assign vpu_llr_in_3[17] = llr_ram_out_3[17];
assign vpu_llr_in_3[18] = llr_ram_out_3[18];
assign vpu_llr_in_3[19] = llr_ram_out_3[19];
assign vpu_llr_in_3[20] = llr_ram_out_3[20];
assign vpu_llr_in_3[21] = llr_ram_out_3[21];
assign vpu_llr_in_3[22] = llr_ram_out_3[22];
assign vpu_llr_in_3[23] = llr_ram_out_3[23];

// 
// CPU llr_in
// 

assign cpu_llr_in_0[0] = llr_ram_out_0[0];
assign cpu_llr_in_1[0] = llr_ram_out_0[1];
assign cpu_llr_in_2[0] = llr_ram_out_0[2];
assign cpu_llr_in_3[0] = llr_ram_out_0[3];
assign cpu_llr_in_4[0] = llr_ram_out_0[4];
assign cpu_llr_in_5[0] = llr_ram_out_0[5];
assign cpu_llr_in_6[0] = llr_ram_out_0[6];
assign cpu_llr_in_7[0] = llr_ram_out_0[7];
assign cpu_llr_in_8[0] = llr_ram_out_0[8];
assign cpu_llr_in_9[0] = llr_ram_out_0[9];
assign cpu_llr_in_10[0] = llr_ram_out_0[10];
assign cpu_llr_in_11[0] = llr_ram_out_0[11];
assign cpu_llr_in_12[0] = llr_ram_out_0[12];
assign cpu_llr_in_13[0] = llr_ram_out_0[13];
assign cpu_llr_in_14[0] = llr_ram_out_0[14];
assign cpu_llr_in_15[0] = llr_ram_out_0[15];
assign cpu_llr_in_16[0] = llr_ram_out_0[16];
assign cpu_llr_in_17[0] = llr_ram_out_0[17];
assign cpu_llr_in_18[0] = llr_ram_out_0[18];
assign cpu_llr_in_19[0] = llr_ram_out_0[19];
assign cpu_llr_in_20[0] = llr_ram_out_0[20];
assign cpu_llr_in_21[0] = llr_ram_out_0[21];
assign cpu_llr_in_22[0] = llr_ram_out_0[22];
assign cpu_llr_in_23[0] = llr_ram_out_0[23];

assign cpu_llr_in_0[1] = llr_ram_out_1[0];
assign cpu_llr_in_1[1] = llr_ram_out_1[1];
assign cpu_llr_in_2[1] = llr_ram_out_1[2];
assign cpu_llr_in_3[1] = llr_ram_out_1[3];
assign cpu_llr_in_4[1] = llr_ram_out_1[4];
assign cpu_llr_in_5[1] = llr_ram_out_1[5];
assign cpu_llr_in_6[1] = llr_ram_out_1[6];
assign cpu_llr_in_7[1] = llr_ram_out_1[7];
assign cpu_llr_in_8[1] = llr_ram_out_1[8];
assign cpu_llr_in_9[1] = llr_ram_out_1[9];
assign cpu_llr_in_10[1] = llr_ram_out_1[10];
assign cpu_llr_in_11[1] = llr_ram_out_1[11];
assign cpu_llr_in_12[1] = llr_ram_out_1[12];
assign cpu_llr_in_13[1] = llr_ram_out_1[13];
assign cpu_llr_in_14[1] = llr_ram_out_1[14];
assign cpu_llr_in_15[1] = llr_ram_out_1[15];
assign cpu_llr_in_16[1] = llr_ram_out_1[16];
assign cpu_llr_in_17[1] = llr_ram_out_1[17];
assign cpu_llr_in_18[1] = llr_ram_out_1[18];
assign cpu_llr_in_19[1] = llr_ram_out_1[19];
assign cpu_llr_in_20[1] = llr_ram_out_1[20];
assign cpu_llr_in_21[1] = llr_ram_out_1[21];
assign cpu_llr_in_22[1] = llr_ram_out_1[22];
assign cpu_llr_in_23[1] = llr_ram_out_1[23];

assign cpu_llr_in_0[2] = llr_ram_out_2[0];
assign cpu_llr_in_1[2] = llr_ram_out_2[1];
assign cpu_llr_in_2[2] = llr_ram_out_2[2];
assign cpu_llr_in_3[2] = llr_ram_out_2[3];
assign cpu_llr_in_4[2] = llr_ram_out_2[4];
assign cpu_llr_in_5[2] = llr_ram_out_2[5];
assign cpu_llr_in_6[2] = llr_ram_out_2[6];
assign cpu_llr_in_7[2] = llr_ram_out_2[7];
assign cpu_llr_in_8[2] = llr_ram_out_2[8];
assign cpu_llr_in_9[2] = llr_ram_out_2[9];
assign cpu_llr_in_10[2] = llr_ram_out_2[10];
assign cpu_llr_in_11[2] = llr_ram_out_2[11];
assign cpu_llr_in_12[2] = llr_ram_out_2[12];
assign cpu_llr_in_13[2] = llr_ram_out_2[13];
assign cpu_llr_in_14[2] = llr_ram_out_2[14];
assign cpu_llr_in_15[2] = llr_ram_out_2[15];
assign cpu_llr_in_16[2] = llr_ram_out_2[16];
assign cpu_llr_in_17[2] = llr_ram_out_2[17];
assign cpu_llr_in_18[2] = llr_ram_out_2[18];
assign cpu_llr_in_19[2] = llr_ram_out_2[19];
assign cpu_llr_in_20[2] = llr_ram_out_2[20];
assign cpu_llr_in_21[2] = llr_ram_out_2[21];
assign cpu_llr_in_22[2] = llr_ram_out_2[22];
assign cpu_llr_in_23[2] = llr_ram_out_2[23];

assign cpu_llr_in_0[3] = llr_ram_out_3[0];
assign cpu_llr_in_1[3] = llr_ram_out_3[1];
assign cpu_llr_in_2[3] = llr_ram_out_3[2];
assign cpu_llr_in_3[3] = llr_ram_out_3[3];
assign cpu_llr_in_4[3] = llr_ram_out_3[4];
assign cpu_llr_in_5[3] = llr_ram_out_3[5];
assign cpu_llr_in_6[3] = llr_ram_out_3[6];
assign cpu_llr_in_7[3] = llr_ram_out_3[7];
assign cpu_llr_in_8[3] = llr_ram_out_3[8];
assign cpu_llr_in_9[3] = llr_ram_out_3[9];
assign cpu_llr_in_10[3] = llr_ram_out_3[10];
assign cpu_llr_in_11[3] = llr_ram_out_3[11];
assign cpu_llr_in_12[3] = llr_ram_out_3[12];
assign cpu_llr_in_13[3] = llr_ram_out_3[13];
assign cpu_llr_in_14[3] = llr_ram_out_3[14];
assign cpu_llr_in_15[3] = llr_ram_out_3[15];
assign cpu_llr_in_16[3] = llr_ram_out_3[16];
assign cpu_llr_in_17[3] = llr_ram_out_3[17];
assign cpu_llr_in_18[3] = llr_ram_out_3[18];
assign cpu_llr_in_19[3] = llr_ram_out_3[19];
assign cpu_llr_in_20[3] = llr_ram_out_3[20];
assign cpu_llr_in_21[3] = llr_ram_out_3[21];
assign cpu_llr_in_22[3] = llr_ram_out_3[22];
assign cpu_llr_in_23[3] = llr_ram_out_3[23];

// =============================================================================
//                          address connection
// =============================================================================
assign rdaddr_ram_b0[0] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_0)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_0);
assign rdaddr_ram_b0[1] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_1)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_1);
assign rdaddr_ram_b0[2] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_2)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_2);
assign rdaddr_ram_b0[3] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_3)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_3);
assign rdaddr_ram_b0[4] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_4)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_4);
assign rdaddr_ram_b0[5] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_5)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_5);
assign rdaddr_ram_b0[6] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_6)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_6);
assign rdaddr_ram_b0[7] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_7)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_7);
assign rdaddr_ram_b0[8] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_8)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_8);
assign rdaddr_ram_b0[9] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_9)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_9);
assign rdaddr_ram_b0[10] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_10)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_10);
assign rdaddr_ram_b0[11] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_11)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_11);
assign rdaddr_ram_b0[12] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_12)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_12);
assign rdaddr_ram_b0[13] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_13)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_13);
assign rdaddr_ram_b0[14] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_14)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_14);
assign rdaddr_ram_b0[15] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_15)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_15);
assign rdaddr_ram_b0[16] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_16)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_16);
assign rdaddr_ram_b0[17] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_17)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_17);
assign rdaddr_ram_b0[18] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_18)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_18);
assign rdaddr_ram_b0[19] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_19)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_19);
assign rdaddr_ram_b0[20] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_20)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_20);
assign rdaddr_ram_b0[21] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_21)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_21);
assign rdaddr_ram_b0[22] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_22)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_22);
assign rdaddr_ram_b0[23] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_23)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_23);

assign rdaddr_ram_b1[0] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_0_appd) // 修正
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_0);
assign rdaddr_ram_b1[1] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_0)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_1);
assign rdaddr_ram_b1[2] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_1)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_2);
assign rdaddr_ram_b1[3] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_2)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_3);
assign rdaddr_ram_b1[4] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_3)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_4);
assign rdaddr_ram_b1[5] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_4)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_5);
assign rdaddr_ram_b1[6] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_5)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_6);
assign rdaddr_ram_b1[7] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_6)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_7);
assign rdaddr_ram_b1[8] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_7)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_8);
assign rdaddr_ram_b1[9] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_8)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_9);
assign rdaddr_ram_b1[10] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_9)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_10);
assign rdaddr_ram_b1[11] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_10)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_11);
assign rdaddr_ram_b1[12] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_11)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_12);
assign rdaddr_ram_b1[13] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_12)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_13);
assign rdaddr_ram_b1[14] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_13)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_14);
assign rdaddr_ram_b1[15] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_14)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_15);
assign rdaddr_ram_b1[16] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_15)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_16);
assign rdaddr_ram_b1[17] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_16)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_17);
assign rdaddr_ram_b1[18] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_17)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_18);
assign rdaddr_ram_b1[19] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_18)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_19);
assign rdaddr_ram_b1[20] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_19)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_20);
assign rdaddr_ram_b1[21] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_20)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_21);
assign rdaddr_ram_b1[22] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_21)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_22);
assign rdaddr_ram_b1[23] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_22)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_23);

assign rdaddr_ram_b2[0] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_1_appd) // 修正
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_0);
assign rdaddr_ram_b2[1] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_0_appd) // 修正
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_1);
assign rdaddr_ram_b2[2] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_0)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_2);
assign rdaddr_ram_b2[3] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_1)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_3);
assign rdaddr_ram_b2[4] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_2)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_4);
assign rdaddr_ram_b2[5] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_3)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_5);
assign rdaddr_ram_b2[6] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_4)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_6);
assign rdaddr_ram_b2[7] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_5)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_7);
assign rdaddr_ram_b2[8] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_6)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_8);
assign rdaddr_ram_b2[9] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_7)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_9);
assign rdaddr_ram_b2[10] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_8)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_10);
assign rdaddr_ram_b2[11] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_9)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_11);
assign rdaddr_ram_b2[12] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_10)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_12);
assign rdaddr_ram_b2[13] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_11)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_13);
assign rdaddr_ram_b2[14] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_12)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_14);
assign rdaddr_ram_b2[15] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_13)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_15);
assign rdaddr_ram_b2[16] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_14)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_16);
assign rdaddr_ram_b2[17] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_15)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_17);
assign rdaddr_ram_b2[18] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_16)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_18);
assign rdaddr_ram_b2[19] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_17)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_19);
assign rdaddr_ram_b2[20] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_18)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_20);
assign rdaddr_ram_b2[21] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_19)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_21);
assign rdaddr_ram_b2[22] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_20)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_22);
assign rdaddr_ram_b2[23] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_21)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_23);

assign rdaddr_ram_b3[0] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_2_appd)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_0);
assign rdaddr_ram_b3[1] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_1_appd)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_1);
assign rdaddr_ram_b3[2] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_0_appd)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_2);
assign rdaddr_ram_b3[3] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_0)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_3);
assign rdaddr_ram_b3[4] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_1)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_4);
assign rdaddr_ram_b3[5] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_2)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_5);
assign rdaddr_ram_b3[6] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_3)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_6);
assign rdaddr_ram_b3[7] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_4)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_7);
assign rdaddr_ram_b3[8] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_5)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_8);
assign rdaddr_ram_b3[9] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_6)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_9);
assign rdaddr_ram_b3[10] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_7)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_10);
assign rdaddr_ram_b3[11] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_8)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_11);
assign rdaddr_ram_b3[12] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_9)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_12);
assign rdaddr_ram_b3[13] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_10)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_13);
assign rdaddr_ram_b3[14] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_11)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_14);
assign rdaddr_ram_b3[15] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_12)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_15);
assign rdaddr_ram_b3[16] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_13)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_16);
assign rdaddr_ram_b3[17] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_14)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_17);
assign rdaddr_ram_b3[18] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_15)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_18);
assign rdaddr_ram_b3[19] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_16)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_19);
assign rdaddr_ram_b3[20] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_17)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_20);
assign rdaddr_ram_b3[21] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_18)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_21);
assign rdaddr_ram_b3[22] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_19)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_22);
assign rdaddr_ram_b3[23] =  ({LLR_WIDTH{vpu_rd_addr_en}} & vpu_addr_20)
						| ({LLR_WIDTH{cpu_on}} & cpu_addr_23);

// 写地址
assign wraddr_ram_b0[0] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_0)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_0)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_0);
assign wraddr_ram_b0[1] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_1)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_1)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_1);
assign wraddr_ram_b0[2] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_2)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_2)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_2);
assign wraddr_ram_b0[3] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_3)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_3)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_3);
assign wraddr_ram_b0[4] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_4)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_4)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_4);
assign wraddr_ram_b0[5] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_5)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_5)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_5);
assign wraddr_ram_b0[6] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_6)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_6)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_6);
assign wraddr_ram_b0[7] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_7)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_7)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_7);
assign wraddr_ram_b0[8] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_8)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_8)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_8);
assign wraddr_ram_b0[9] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_9)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_9)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_9);
assign wraddr_ram_b0[10] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_10)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_10)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_10);
assign wraddr_ram_b0[11] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_11)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_11)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_11);
assign wraddr_ram_b0[12] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_12)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_12)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_12);
assign wraddr_ram_b0[13] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_13)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_13)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_13);
assign wraddr_ram_b0[14] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_14)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_14)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_14);
assign wraddr_ram_b0[15] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_15)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_15)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_15);
assign wraddr_ram_b0[16] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_16)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_16)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_16);
assign wraddr_ram_b0[17] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_17)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_17)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_17);
assign wraddr_ram_b0[18] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_18)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_18)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_18);
assign wraddr_ram_b0[19] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_19)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_19)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_19);
assign wraddr_ram_b0[20] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_20)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_20)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_20);
assign wraddr_ram_b0[21] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_21)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_21)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_21);
assign wraddr_ram_b0[22] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_22)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_22)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_22);
assign wraddr_ram_b0[23] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_23)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_23)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_23);

assign wraddr_ram_b1[0] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_0_appd)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_0)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_0_appd);
assign wraddr_ram_b1[1] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_0)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_1)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_0);
assign wraddr_ram_b1[2] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_1)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_2)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_1);
assign wraddr_ram_b1[3] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_2)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_3)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_2);
assign wraddr_ram_b1[4] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_3)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_4)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_3);
assign wraddr_ram_b1[5] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_4)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_5)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_4);
assign wraddr_ram_b1[6] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_5)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_6)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_5);
assign wraddr_ram_b1[7] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_6)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_7)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_6);
assign wraddr_ram_b1[8] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_7)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_8)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_7);
assign wraddr_ram_b1[9] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_8)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_9)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_8);
assign wraddr_ram_b1[10] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_9)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_10)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_9);
assign wraddr_ram_b1[11] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_10)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_11)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_10);
assign wraddr_ram_b1[12] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_11)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_12)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_11);
assign wraddr_ram_b1[13] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_12)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_13)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_12);
assign wraddr_ram_b1[14] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_13)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_14)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_13);
assign wraddr_ram_b1[15] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_14)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_15)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_14);
assign wraddr_ram_b1[16] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_15)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_16)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_15);
assign wraddr_ram_b1[17] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_16)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_17)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_16);
assign wraddr_ram_b1[18] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_17)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_18)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_17);
assign wraddr_ram_b1[19] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_18)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_19)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_18);
assign wraddr_ram_b1[20] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_19)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_20)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_19);
assign wraddr_ram_b1[21] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_20)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_21)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_20);
assign wraddr_ram_b1[22] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_21)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_22)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_21);
assign wraddr_ram_b1[23] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_22)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_23)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_22);

assign wraddr_ram_b2[0] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_1_appd)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_0)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_1_appd);
assign wraddr_ram_b2[1] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_0_appd)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_1)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_0_appd);
assign wraddr_ram_b2[2] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_0)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_2)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_0);
assign wraddr_ram_b2[3] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_1)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_3)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_1);
assign wraddr_ram_b2[4] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_2)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_4)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_2);
assign wraddr_ram_b2[5] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_3)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_5)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_3);
assign wraddr_ram_b2[6] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_4)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_6)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_4);
assign wraddr_ram_b2[7] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_5)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_7)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_5);
assign wraddr_ram_b2[8] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_6)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_8)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_6);
assign wraddr_ram_b2[9] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_7)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_9)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_7);
assign wraddr_ram_b2[10] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_8)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_10)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_8);
assign wraddr_ram_b2[11] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_9)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_11)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_9);
assign wraddr_ram_b2[12] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_10)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_12)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_10);
assign wraddr_ram_b2[13] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_11)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_13)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_11);
assign wraddr_ram_b2[14] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_12)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_14)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_12);
assign wraddr_ram_b2[15] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_13)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_15)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_13);
assign wraddr_ram_b2[16] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_14)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_16)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_14);
assign wraddr_ram_b2[17] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_15)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_17)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_15);
assign wraddr_ram_b2[18] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_16)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_18)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_16);
assign wraddr_ram_b2[19] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_17)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_19)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_17);
assign wraddr_ram_b2[20] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_18)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_20)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_18);
assign wraddr_ram_b2[21] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_19)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_21)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_19);
assign wraddr_ram_b2[22] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_20)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_22)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_20);
assign wraddr_ram_b2[23] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_21)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_23)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_21);

assign wraddr_ram_b3[0] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_2_appd)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_0)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_2_appd);
assign wraddr_ram_b3[1] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_1_appd)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_1)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_1_appd);
assign wraddr_ram_b3[2] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_0_appd)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_2)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_0_appd);
assign wraddr_ram_b3[3] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_0)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_3)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_0);
assign wraddr_ram_b3[4] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_1)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_4)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_1);
assign wraddr_ram_b3[5] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_2)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_5)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_2);
assign wraddr_ram_b3[6] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_3)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_6)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_3);
assign wraddr_ram_b3[7] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_4)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_7)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_4);
assign wraddr_ram_b3[8] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_5)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_8)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_5);
assign wraddr_ram_b3[9] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_6)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_9)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_6);
assign wraddr_ram_b3[10] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_7)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_10)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_7);
assign wraddr_ram_b3[11] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_8)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_11)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_8);
assign wraddr_ram_b3[12] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_9)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_12)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_9);
assign wraddr_ram_b3[13] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_10)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_13)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_10);
assign wraddr_ram_b3[14] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_11)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_14)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_11);
assign wraddr_ram_b3[15] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_12)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_15)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_12);
assign wraddr_ram_b3[16] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_13)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_16)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_13);
assign wraddr_ram_b3[17] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_14)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_17)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_14);
assign wraddr_ram_b3[18] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_15)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_18)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_15);
assign wraddr_ram_b3[19] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_16)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_19)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_16);
assign wraddr_ram_b3[20] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_17)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_20)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_17);
assign wraddr_ram_b3[21] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_18)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_21)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_18);
assign wraddr_ram_b3[22] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_19)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_22)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_19);
assign wraddr_ram_b3[23] =  ({LLR_WIDTH{vpu_wr_addr_en}} & wr_vpu_addr_20)
						| ({LLR_WIDTH{cpu_wr_addr_en}} & wr_cpu_addr_23)
						| ({LLR_WIDTH{initial_on}} & vpu_addr_20);

// =============================================================================
//                          llr_intrisci address connection
// =============================================================================
reg [ADDR_WIDTH-1:0] intrinsic_addr_cnt;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		intrinsic_addr_cnt <= 0;
	else if (in_info_rden == 1'b1)
		intrinsic_addr_cnt <= intrinsic_addr_cnt + 1'b1;
	else
		intrinsic_addr_cnt <= 0;
end

assign rdaddr_intri[0 ] = intrinsic_addr_cnt;
assign rdaddr_intri[1 ] = intrinsic_addr_cnt;
assign rdaddr_intri[2 ] = intrinsic_addr_cnt;
assign rdaddr_intri[3 ] = intrinsic_addr_cnt;
assign rdaddr_intri[4 ] = intrinsic_addr_cnt;
assign rdaddr_intri[5 ] = intrinsic_addr_cnt;
assign rdaddr_intri[6 ] = intrinsic_addr_cnt;
assign rdaddr_intri[7 ] = intrinsic_addr_cnt;
assign rdaddr_intri[8 ] = intrinsic_addr_cnt;
assign rdaddr_intri[9 ] = intrinsic_addr_cnt;
assign rdaddr_intri[10] = intrinsic_addr_cnt;
assign rdaddr_intri[11] = intrinsic_addr_cnt;
assign rdaddr_intri[12] = intrinsic_addr_cnt;
assign rdaddr_intri[13] = intrinsic_addr_cnt;
assign rdaddr_intri[14] = intrinsic_addr_cnt;
assign rdaddr_intri[15] = intrinsic_addr_cnt;
assign rdaddr_intri[16] = intrinsic_addr_cnt;
assign rdaddr_intri[17] = intrinsic_addr_cnt;
assign rdaddr_intri[18] = intrinsic_addr_cnt;
assign rdaddr_intri[19] = intrinsic_addr_cnt;
assign rdaddr_intri[20] = intrinsic_addr_cnt;
assign rdaddr_intri[21] = intrinsic_addr_cnt;
assign rdaddr_intri[22] = intrinsic_addr_cnt;
assign rdaddr_intri[23] = intrinsic_addr_cnt;

reg [ADDR_WIDTH-1:0] wr_intrinsic_addr_cnt;
always @(posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0)
		wr_intrinsic_addr_cnt <= 0;
	else if (in_info_wren == 1'b1)
		wr_intrinsic_addr_cnt <= wr_intrinsic_addr_cnt + 1'b1;
	else
		wr_intrinsic_addr_cnt <= 0;
end

assign wraddr_intri[0 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[1 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[2 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[3 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[4 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[5 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[6 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[7 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[8 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[9 ] = wr_intrinsic_addr_cnt;
assign wraddr_intri[10] = wr_intrinsic_addr_cnt;
assign wraddr_intri[11] = wr_intrinsic_addr_cnt;
assign wraddr_intri[12] = wr_intrinsic_addr_cnt;
assign wraddr_intri[13] = wr_intrinsic_addr_cnt;
assign wraddr_intri[14] = wr_intrinsic_addr_cnt;
assign wraddr_intri[15] = wr_intrinsic_addr_cnt;
assign wraddr_intri[16] = wr_intrinsic_addr_cnt;
assign wraddr_intri[17] = wr_intrinsic_addr_cnt;
assign wraddr_intri[18] = wr_intrinsic_addr_cnt;
assign wraddr_intri[19] = wr_intrinsic_addr_cnt;
assign wraddr_intri[20] = wr_intrinsic_addr_cnt;
assign wraddr_intri[21] = wr_intrinsic_addr_cnt;
assign wraddr_intri[22] = wr_intrinsic_addr_cnt;
assign wraddr_intri[23] = wr_intrinsic_addr_cnt;


endmodule

