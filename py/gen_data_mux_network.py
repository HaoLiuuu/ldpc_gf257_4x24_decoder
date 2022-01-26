base = "\
assign cpu_outin_ram_{ram}[{p}] = cpu_llr_out_{p}[{ram}];\
"

# for ram in range(4):
# 	for x in range(24):
# 		print(base.format(ram=0, p=x))



# ----------------------------------------------------------------------------------
# llr_ram input data generator
data_assign = "\
assign llr_ram_in_{ram}[{p}] =  ({{LLR_WIDTH{{cpu_on}}}} & cpu_llr_out_{p}[{ram}])\n\
						| ({{LLR_WIDTH{{vpu_on}}}} & vpu_llr_out_{ram}[{p}])\n\
						| ({{LLR_WIDTH{{initial_on}}}} & llr_intri[{p}]);\
"

# for ram in range(4):
# 	for x in range(24):
# 		print(data_assign.format(ram=ram, p=x))




# ----------------------------------------------------------------------------------
# llr_ram rdaddr generator

rdaddr_assign_0 = "\
assign rdaddr_ram_b{ram}[{p}] =  ({{LLR_WIDTH{{vpu_on}}}} & vpu_addr_{p})\n\
						| ({{LLR_WIDTH{{cpu_on}}}} & cpu_addr_{p});\
"

# ram 0
# for x in range(24):
# 	print(rdaddr_assign.format(ram=0, p=x))

# print()

rdaddr_assign_1 = "\
assign rdaddr_ram_b{ram}[{p}] =  ({{LLR_WIDTH{{vpu_on}}}} & vpu_addr_{p_minus1})\n\
						| ({{LLR_WIDTH{{cpu_on}}}} & cpu_addr_{p});\
"
# for x in range(24):
# 	print(rdaddr_assign_1.format(ram=1, p=x, p_minus1=x-1))

# for x in range(24):
# 	print(rdaddr_assign_1.format(ram=2, p=x, p_minus1=x-2))

# for x in range(24):
# 	print(rdaddr_assign_1.format(ram=3, p=x, p_minus1=x-3))


# ----------------------------------------------------------------------------------
# wraddr
wraddr_assign_0 = "\
assign wraddr_ram_b{ram}[{p}] =  ({{LLR_WIDTH{{vpu_wr_addr_en}}}} & wr_vpu_addr_{p_minus})\n\
						| ({{LLR_WIDTH{{cpu_wr_addr_en}}}} & wr_cpu_addr_{p})\n\
						| ({{LLR_WIDTH{{initial_on}}}} & vpu_addr_{p_minus});\
"
for ram in range(4):
	for x in range(24):
		print(wraddr_assign_0.format(ram=ram, p=x, p_minus=x-ram))
	print()


# ----------------------------------------------------------------------------------
# llr_ram output data into vpu and cpu assign generator

vpu_llr_in = "\
assign vpu_llr_in_{ram}[{p}] = llr_ram_out_{ram}[{p}];\
"

# for ram in range(4):
# 	for x in range(24):
# 		print(vpu_llr_in.format(ram=ram, p=x))
# 	print()

cpu_llr_in = "\
assign cpu_llr_in_{p}[{ram}] = llr_ram_out_{ram}[{p}];\
"
# for ram in range(4):
# 	for x in range(24):
# 		print(cpu_llr_in.format(ram=ram, p=x))
# 	print()
