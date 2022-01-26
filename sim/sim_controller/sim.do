# 创建库及映射库
vlib work
vmap work work

# 这里参数都是可选的 不加其实也可以
# vlog -incr -work work ../../ip/
vlog -incr -work work ../../rtl/controller.v
vlog -incr -work work ../../tb/tb_controller.v

# 固定格式，虽不知为何一定要用 -voptargs=+acc 但默认就是这种方式
# 不加的话代码跑不下去
vsim -voptargs=+acc work.tb_controller

# 添加波形
# 这里可以引入更加复杂的设置
add wave -divider controller
add wave sim:/tb_controller/*
# add wave sim:/tb_controller/inst_ldpc_vpu/*

# 指定以何种进制显示
# Use binary, octal, decimal, signed, unsigned, hexadecimal, ascii or default. 默认二进制
# add wave -radix hex sim:/tb_ldpc_vpu/llr_all
# 指定以何种颜色显示
# add wave -color Yellow sim:/tb_ldpc_vpu/llr_out_0

view wave

run -all
