base = "\n\
always @(posedge clk) begin\n\
	if (vpu_addr_ena == 1'b1)  begin\n\
		vpu_addr_{port} <= vpu_addr_{port} + 1'b1;\n\
	end\n\
	else\n\
		vpu_addr_{port} <= row_start_{port};\n\
end\
"

# for x in range(24):
# 	print(base.format(port=x))


base_cpu = "\n\
always @(posedge clk) begin\n\
	if (cpu_addr_ena == 1'b1)  begin\n\
		cpu_addr_{port} <= cpu_addr_{port} + 1'b1;\n\
	end\n\
	else\n\
		cpu_addr_{port} <= 0;\n\
end\
"

for x in range(24):
	print(base_cpu.format(port=x))
