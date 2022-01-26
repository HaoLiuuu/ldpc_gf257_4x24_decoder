base = "\n\
always @(posedge clk) begin\n\
	if (en)\n\
		reg_vpu_addr_{p}[0] <= in_vpu_addr_{p};\n\
	else\n\
		reg_vpu_addr_{p}[0] <= reg_vpu_addr_{p}[0];\n\
end\n\
\n\
generate\n\
	for (i = 1; i < DEPTH; i = i + 1) begin : p{p}\n\
		always @(posedge clk) begin\n\
			if (en)\n\
				reg_vpu_addr_{p}[i] <= reg_vpu_addr_{p}[i-1];\n\
			else\n\
				reg_vpu_addr_{p}[i] <= reg_vpu_addr_{p}[i];\n\
		end\n\
	end\n\
endgenerate\
"

for x in range(24):
	print(base.format(p=x))