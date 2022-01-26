base = "\
output [ADDR_WIDTH-1:0] rdaddr_ram_b{block}_s{sect},\
"

for p in range(4):
	for x in range(24):
		print(base.format(block=p, sect=x))
	print()

