all:	clean test.vcd
	gtkwave test.vcd

test.vcd:
	iverilog -I sources/ -DFOR_TEST -o test.vvp testbench.v
#	iverilog -I sources/ -o test.vvp testbench.v
	vvp test.vvp

clean:
	rm -f *.vvp
	rm -f *.vcd
