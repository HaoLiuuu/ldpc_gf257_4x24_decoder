
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/wraddr_intri[0]
# 控制信号
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/initial_on;
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/cpu_on;
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/vpu_on;
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/vpu_rd_addr_en;
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/vpu_wr_addr_en;
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/cpu_wr_addr_en;
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_rden
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_wren
add wave sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/in_info_rden

# 地址信号
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_in_0
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_in_1
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_in_2
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_in_3
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_out_0
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_out_1
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_out_2
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_ram_out_3
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_intri

add wave -radix unsigned sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/wraddr_ram_b0
add wave -radix unsigned sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/rdaddr_ram_b0

add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/cpu_llr_out_0

add wave -radix unsigned sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/rdaddr_intri[0]
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/llr_intri[0]
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/vpu_llr_in_0[0]
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/vpu_llr_in_1[0]
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/vpu_llr_in_2[0]
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/vpu_llr_in_3[0]
add wave -radix decimal sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/vpu_llr_out_0[0]

add wave -radix unsigned sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/rdaddr_ram_b1[0]
add wave -radix unsigned sim:/tb_ldpc_runner_top/inst_ldpc_runner_top/wraddr_ram_b1[0]
