# 创建库及映射库
vlib work
vmap work work

vlog -incr -work work ../../rtl/comp3in2out.v
vlog -incr -work work ../../tb/tb_comp.v

vsim -voptargs=+acc work.tb_comp

add wave -divider tb
add wave -radix unsigned sim:/tb_comp/*

add wave -divider comp
add wave -radix unsigned sim:/tb_comp/comp3in2out_dut/*

view wave

run -all